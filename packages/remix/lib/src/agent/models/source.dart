import 'package:flutter/foundation.dart';

/// A file, page or document an answer refers to.
@immutable
final class AgentSource {
  /// Creates a source.
  const AgentSource({required this.id, required this.title, this.uri});

  /// Stable identity across updates.
  final String id;

  /// The visible title, such as a file name or a page title.
  final String title;

  /// Where the source lives, when it has an address.
  final Uri? uri;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AgentSource &&
          other.id == id &&
          other.title == title &&
          other.uri == uri;

  @override
  int get hashCode => Object.hash(id, title, uri);

  @override
  String toString() => 'AgentSource(id: $id, title: $title, uri: $uri)';
}
