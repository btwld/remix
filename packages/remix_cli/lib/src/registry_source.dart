import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:yaml/yaml.dart';

import 'registry.dart';
import 'registry_reader.dart';

const officialRepository = 'btwld/remix';

/// The branch CI fast-forwards after the hosted registry checks pass.
///
/// A single path segment, so it is a valid `commits/{ref}` lookup.
const officialStableRef = 'registry-stable';

void validateNamespace(String value) {
  if (!RegExp(r'^@[a-z][a-z0-9_-]*$').hasMatch(value)) {
    throw FormatException('Invalid registry namespace $value; use @name.');
  }
}

void validateRegistryPath(String value) {
  if (value.isEmpty ||
      value.contains('\\') ||
      value
          .split('/')
          .any((part) => part.isEmpty || part == '.' || part == '..') ||
      !RegExp(r'^[A-Za-z0-9_./-]+$').hasMatch(value)) {
    throw FormatException(
      'Registry path $value must be repository-relative without traversal.',
    );
  }
}

void _validateRepository(String repository) {
  if (!RegExp(
    r'^[A-Za-z0-9_-][A-Za-z0-9_.-]*/[A-Za-z0-9_-][A-Za-z0-9_.-]*$',
  ).hasMatch(repository)) {
    throw FormatException(
      'Invalid GitHub repository $repository; use owner/repo.',
    );
  }
}

final class RegistrySource {
  RegistrySource({
    required this.repository,
    required this.path,
    required this.ref,
    required this.revision,
  }) {
    _validateRepository(repository);
    validateRegistryPath(path);
    if (ref.isEmpty || !RegExp(r'^[0-9a-f]{40}$').hasMatch(revision)) {
      throw const FormatException(
        'Registry requires a ref and a full lowercase commit SHA revision.',
      );
    }
  }
  final String repository;
  final String path;
  final String ref;
  final String revision;
}

final class RegistryResponse {
  const RegistryResponse(this.statusCode, this.body, {this.headers = const {}});
  final int statusCode;
  final String body;
  final Map<String, String> headers;
}

typedef RegistryTransport = Future<RegistryResponse> Function(Uri uri);

Future<RegistryResponse> githubTransport(Uri uri) async {
  final client = HttpClient()..connectionTimeout = const Duration(seconds: 20);
  try {
    // The timeout covers the whole exchange, response body included.
    return await _send(client, uri).timeout(const Duration(seconds: 30));
  } finally {
    client.close(force: true);
  }
}

Future<RegistryResponse> _send(HttpClient client, Uri uri) async {
  final request = await client.getUrl(uri);
  request.followRedirects = false;
  request.headers.set('User-Agent', 'remix_cli');
  request.headers.set(
    'Accept',
    uri.host == 'api.github.com' ? 'application/vnd.github+json' : 'text/plain',
  );
  final response = await request.close();
  return RegistryResponse(
    response.statusCode,
    await utf8.decoder.bind(response).join(),
    headers: {
      for (final name in ['x-ratelimit-remaining', 'retry-after'])
        if (response.headers.value(name) != null)
          name: response.headers.value(name)!,
    },
  );
}

/// GitHub answers a commit lookup for an unknown ref with 422, not 404. Only
/// that message means missing; any other 422 stays a request failure.
bool _isUnknownCommit(RegistryResponse response) {
  if (response.statusCode != 422) return false;
  final Object? body;
  try {
    body = jsonDecode(response.body);
  } on FormatException {
    return false;
  }
  final message = body is Map ? body['message'] : null;
  return message is String && message.startsWith('No commit found for SHA');
}

/// Resolves [preset] to its catalog path through a published `index.yaml`.
///
/// Shared by every reader serving the published layout. The frozen bundle
/// predates the index and selects presets by directory instead, which is why
/// preset resolution stays with the reader rather than the catalog.
String catalogPathForPreset(
  String indexSource, {
  required String preset,
  required String origin,
}) {
  final index = loadYaml(indexSource);
  if (index is! YamlMap || index['schema'] is! int || index['schema'] != 1) {
    throw const FormatException(
      'Unsupported registry index schema; expected schema 1.',
    );
  }
  final presets = index['presets'];
  final catalogPath = presets is YamlMap ? presets[preset] : null;
  if (catalogPath is! String)
    throw FormatException('Registry $origin has no $preset preset.');
  validateRegistryPath(catalogPath);
  return catalogPath;
}

/// Everything the installer needs from outside the project.
///
/// Pinning and reading are separate operations with separate lifetimes: the
/// frozen bundle reads without a pin, and `remix registry update` pins without
/// reading. They share one interface so the installer keeps a single seam.
abstract interface class RegistrySources {
  /// The official registry at its CI-promoted stable branch, resolved to a
  /// commit.
  Future<RegistrySource> latestOfficial();

  /// Resolve [repository] at [ref] to an immutable commit pin.
  Future<RegistrySource> resolve({
    required String repository,
    String path,
    String? ref,
  });

  /// Open [pin] for reading [preset].
  RegistryReader open(RegistrySource pin, String preset);
}

final class GitHubSources implements RegistrySources {
  const GitHubSources({this.transport = githubTransport});
  final RegistryTransport transport;

  Future<String> _read(Uri uri, {String missing = 'file'}) async {
    final RegistryResponse response;
    try {
      response = await transport(uri);
    } on TimeoutException {
      throw FormatException(
        'GitHub request timed out: $uri. Retry when the network is available.',
      );
    } on IOException catch (error) {
      throw FormatException('GitHub network failure for $uri: $error');
    }
    if (response.statusCode == 429 ||
        (response.statusCode == 403 &&
            (response.headers['x-ratelimit-remaining'] == '0' ||
                response.headers.containsKey('retry-after')))) {
      throw FormatException(
        'GitHub rate limit exceeded for $uri. Retry after the limit resets.',
      );
    }
    if (response.statusCode == 404 || _isUnknownCommit(response)) {
      throw FormatException(
        'GitHub $missing not found: $uri. Check that the repository is public and the source exists.',
      );
    }
    if (response.statusCode != 200) {
      throw FormatException(
        'GitHub request failed (${response.statusCode}): $uri.',
      );
    }
    return response.body;
  }

  Future<Object?> _api(String path) async => jsonDecode(
    await _read(Uri.https('api.github.com', path), missing: 'repository'),
  );

  @override
  Future<RegistrySource> resolve({
    required String repository,
    String path = 'registry',
    String? ref,
  }) async {
    _validateRepository(repository);
    validateRegistryPath(path);
    if (ref != null && ref.isEmpty)
      throw const FormatException('Registry ref must not be empty.');
    final metadata = await _api('/repos/$repository');
    var requested = ref;
    if (requested == null) {
      final branch = metadata is Map ? metadata['default_branch'] : null;
      if (branch is! String || branch.isEmpty) {
        throw const FormatException('GitHub repository has no default branch.');
      }
      requested = branch;
    }
    final commit = jsonDecode(
      await _read(
        Uri(
          scheme: 'https',
          host: 'api.github.com',
          pathSegments: [
            'repos',
            ...repository.split('/'),
            'commits',
            requested,
          ],
        ),
        missing: 'ref $requested',
      ),
    );
    final sha = commit is Map ? commit['sha'] : null;
    if (sha is! String)
      throw const FormatException('GitHub returned no commit revision.');
    return RegistrySource(
      repository: repository,
      path: path,
      ref: requested,
      revision: sha,
    );
  }

  @override
  Future<RegistrySource> latestOfficial() async {
    try {
      return await resolve(
        repository: officialRepository,
        ref: officialStableRef,
      );
    } on FormatException catch (error) {
      final message = error.message;
      if (message.startsWith('GitHub ref $officialStableRef not found:')) {
        throw FormatException(
          'No $officialStableRef branch is published for $officialRepository. '
          '$message',
        );
      }
      rethrow;
    }
  }

  @override
  RegistryReader open(RegistrySource pin, String preset) =>
      _GitHubRegistry(this, pin, preset);
}

/// One pinned GitHub registry, serving one preset.
final class _GitHubRegistry implements RegistryReader {
  _GitHubRegistry(this._sources, this._pin, this._preset);

  final GitHubSources _sources;
  final RegistrySource _pin;
  final String _preset;

  /// Every read goes through the pinned commit, never a mutable ref.
  Uri get _root => Uri.https(
    'raw.githubusercontent.com',
    '/${_pin.repository}/${_pin.revision}/${_pin.path}/',
  );

  /// The preset's own directory, which item template sources are relative to.
  /// Memoized so one reader fetches the index once regardless of call order.
  late final Future<Uri> _catalogUri = _resolveCatalogUri();

  Future<Uri> _resolveCatalogUri() async => _root.resolve(
    catalogPathForPreset(
      await _sources._read(_root.resolve('index.yaml')),
      preset: _preset,
      origin: _pin.repository,
    ),
  );

  @override
  Future<RegistryCatalog> catalog() async => RegistryCatalog.parse(
    await _sources._read(await _catalogUri),
    preset: _preset,
  );

  @override
  Future<String> template(RegistryFile file) async =>
      _sources._read((await _catalogUri).resolve(file.source));
}
