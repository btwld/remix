import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:remix/src/radix/tokens/css_var_parser.dart';

// Consolidated: minimal Radix CSS parsing helpers (avoid separate lib file)
class _RadixScaleSection {
  final Map<String, String> solid;
  final Map<String, String> alpha;
  final String? surface;
  final String? indicator;
  final String? track;
  final String? contrast;

  const _RadixScaleSection({
    required this.solid,
    required this.alpha,
    this.surface,
    this.indicator,
    this.track,
    this.contrast,
  });

  Map<String, dynamic> toJson() => {
        if (solid.isNotEmpty) 'solid': solid,
        if (alpha.isNotEmpty) 'alpha': alpha,
        if (surface != null) 'surface': surface,
        if (indicator != null) 'indicator': indicator,
        if (track != null) 'track': track,
        if (contrast != null) 'contrast': contrast,
      };
}

class _ParsedRadixScale {
  final _RadixScaleSection? light;
  final _RadixScaleSection? dark; // not used currently

  const _ParsedRadixScale({this.light, this.dark});
}

_ParsedRadixScale _parseRadixCss(String css, String scale) {
  final vars = parseCssVariables(css);

  String? _resolve(String? v) {
    if (v == null) return null;
    final s = v.trim();
    if (s.startsWith('var(')) {
      final name = s.substring(4, s.length - 1).trim(); // --foo
      final key = name.startsWith('--') ? name.substring(2) : name;
      return _resolve(vars[key]);
    }
    if (s == 'white') return '#ffffff';
    if (s == 'black') return '#000000';
    return s;
  }

  String solidKey(int i) => '$scale-$i';
  String alphaKey(int i) => '$scale-a$i';

  final solid = <String, String>{};
  for (var i = 1; i <= 12; i++) {
    final raw = vars[solidKey(i)];
    final v = _resolve(raw);
    if (v != null) solid['$i'] = v;
  }

  final alpha = <String, String>{};
  for (var i = 1; i <= 12; i++) {
    final raw = vars[alphaKey(i)];
    final v = _resolve(raw);
    if (v != null) alpha['a$i'] = v;
  }

  String? role(String name) => _resolve(vars['$scale-$name']);

  final section = _RadixScaleSection(
    solid: solid,
    alpha: alpha,
    surface: role('surface'),
    indicator: role('indicator'),
    track: role('track'),
    contrast: role('contrast'),
  );

  return _ParsedRadixScale(light: section);
}

const String kRadixThemesVersion = '3.2.1';
const String kRadixColorsVersion = '3.0.0';

const Map<String, String> kThemeScalePaths = {
  'gray': 'tokens/colors/gray.css',
  'mauve': 'tokens/colors/mauve.css',
  'slate': 'tokens/colors/slate.css',
  'sage': 'tokens/colors/sage.css',
  'olive': 'tokens/colors/olive.css',
  'sand': 'tokens/colors/sand.css',
  'tomato': 'tokens/colors/tomato.css',
  'red': 'tokens/colors/red.css',
  'ruby': 'tokens/colors/ruby.css',
  'crimson': 'tokens/colors/crimson.css',
  'pink': 'tokens/colors/pink.css',
  'plum': 'tokens/colors/plum.css',
  'purple': 'tokens/colors/purple.css',
  'violet': 'tokens/colors/violet.css',
  'iris': 'tokens/colors/iris.css',
  'indigo': 'tokens/colors/indigo.css',
  'blue': 'tokens/colors/blue.css',
  'cyan': 'tokens/colors/cyan.css',
  'teal': 'tokens/colors/teal.css',
  'jade': 'tokens/colors/jade.css',
  'green': 'tokens/colors/green.css',
  'grass': 'tokens/colors/grass.css',
  'bronze': 'tokens/colors/bronze.css',
  'gold': 'tokens/colors/gold.css',
  'brown': 'tokens/colors/brown.css',
  'orange': 'tokens/colors/orange.css',
  'amber': 'tokens/colors/amber.css',
  'yellow': 'tokens/colors/yellow.css',
  'lime': 'tokens/colors/lime.css',
  'mint': 'tokens/colors/mint.css',
  'sky': 'tokens/colors/sky.css',
};

const Map<String, String> kNeutralPaths = {
  'blackA': 'black-alpha.css',
  'whiteA': 'white-alpha.css',
};

// Single base tokens CSS per Radix Themes release note exports
const kBaseTokensPath = 'tokens/base.css';

Future<void> main(List<String> args) async {
  // Defaults that can be overridden via flags
  var themesBase = 'https://unpkg.com/@radix-ui/themes';
  var themesVersion = kRadixThemesVersion;
  var colorsBase = 'https://cdn.jsdelivr.net/npm/@radix-ui/colors';
  var colorsVersion = kRadixColorsVersion;

  String? _readFlag(String name) {
    final i = args.indexOf(name);
    if (i != -1 && i + 1 < args.length) return args[i + 1];

    return null;
  }

  themesBase = _readFlag('--themes-base') ?? themesBase;
  themesVersion = _readFlag('--themes-version') ?? themesVersion;
  colorsBase = _readFlag('--colors-base') ?? colorsBase;
  colorsVersion = _readFlag('--colors-version') ?? colorsVersion;

  // Colors: scales (full) — included here to keep radix_tokens as the single source
  final outScales = <String, Map<String, dynamic>>{};
  for (final entry in kThemeScalePaths.entries) {
    final scale = entry.key;
    final path = entry.value;
    final sourceUrl = '$themesBase@$themesVersion/$path';

    stdout.writeln('[fetch] $scale <- $sourceUrl');
    final css = await _fetch(sourceUrl);
    if (css == null) {
      stderr.writeln('[warn] Failed to fetch CSS for $scale');
      continue;
    }

    final parsed = _parseRadixCss(css, scale);
    Map<String, dynamic> sectionToJson(_RadixScaleSection? s) =>
        s?.toJson() ?? const {};
    final lightJson = sectionToJson(parsed.light);
    final darkJson = sectionToJson(parsed.dark);

    final map = <String, dynamic>{};
    if (lightJson.isNotEmpty) map['light'] = lightJson;
    if (darkJson.isNotEmpty) map['dark'] = darkJson;
    outScales[scale] = map;
  }

  // Colors: neutrals
  final neutralsOut = <String, Map<String, dynamic>>{};
  for (final entry in kNeutralPaths.entries) {
    final keyOut = entry.key; // e.g., 'blackA'
    final path = entry.value;
    final sourceUrl = '$colorsBase@$colorsVersion/$path';
    final scaleForCss = keyOut.endsWith('A')
        ? keyOut.substring(0, keyOut.length - 1).toLowerCase()
        : keyOut.toLowerCase();

    stdout.writeln('[fetch] neutral $keyOut <- $sourceUrl');
    final css = await _fetch(sourceUrl);
    if (css == null) {
      stderr.writeln('[warn] Failed to fetch CSS for neutral $keyOut');
      continue;
    }

    final parsed = _parseRadixCss(css, scaleForCss);
    final alpha = parsed.light?.alpha.isNotEmpty == true
        ? parsed.light!.alpha
        : (parsed.dark?.alpha ?? const <String, String>{});

    neutralsOut[keyOut] = {if (alpha.isNotEmpty) 'alpha': alpha};
  }

  // Other token categories from Themes (via consolidated base tokens)
  final categories = <String, Map<String, String>>{};
  final baseUrl = '$themesBase@$themesVersion/$kBaseTokensPath';
  stdout.writeln('[fetch] base tokens <- $baseUrl');
  final baseCss = await _fetch(baseUrl);
  if (baseCss == null) {
    stderr.writeln('[warn] Failed to fetch base tokens at $kBaseTokensPath');
  } else {
    final vars = parseCssVariables(baseCss);
    Map<String, String> filter(
      Map<String, String> src,
      bool Function(String) pred,
    ) {
      final out = <String, String>{};
      src.forEach((k, v) {
        if (pred(k)) out[k] = v;
      });

      return out;
    }

    categories['spacing'] = filter(vars, (k) => k.startsWith('space-'));
    categories['radius'] = filter(vars, (k) => k.startsWith('radius'));
    categories['shadows'] = filter(vars, (k) => k.startsWith('shadow-'));
    categories['typography'] = filter(
      vars,
      (k) =>
          k.startsWith('font-size-') ||
          k.startsWith('line-height-') ||
          k.startsWith('letter-spacing-') ||
          k.startsWith('font-weight-'),
    );
  }

  // Minimal theme references (using token paths)
  final theme = <String, dynamic>{
    'defaultAccent': 'indigo',
    'light': {
      'background': '{colors.scales.gray.light.solid.1}',
      'overlay': '{colors.scales.gray.light.alpha.a2}',
      'contrast': '{colors.scales.gray.light.contrast}',
      'accent': '{colors.scales.indigo.light.solid.9}',
    },
    'dark': {
      'background': '{colors.scales.gray.dark.solid.1}',
      'overlay': '{colors.scales.gray.dark.alpha.a2}',
      'contrast': '{colors.scales.gray.dark.contrast}',
      'accent': '{colors.scales.indigo.dark.solid.9}',
    },
  };

  stdout.writeln('[debug] scales=' +
      outScales.length.toString() +
      ' neutrals=' +
      neutralsOut.length.toString());

  // Write colors (scales + neutrals) to separate file
  final colorsJson = <String, dynamic>{
    'meta': <String, dynamic>{
      'description':
          'Radix color scales + neutrals. Generated by scripts/extract_radix_tokens.dart',
      'radix_themes_version': themesVersion,
      'radix_colors_version': colorsVersion,
      'generated': DateTime.now().toIso8601String(),
    },
    'colors': {'scales': outScales, 'neutrals': neutralsOut},
  };

  // Write non-color tokens and theme to radix_tokens.generated.json
  final outJson = <String, dynamic>{
    'meta': <String, dynamic>{
      'description':
          'Unified Radix design tokens (spacing, radius, typography, shadows). Generated by scripts/extract_radix_tokens.dart',
      'radix_themes_version': themesVersion,
      'radix_colors_version': colorsVersion,
      'generated': DateTime.now().toIso8601String(),
    },
    ...categories,
    'theme': theme,
  };

  final encoder = const JsonEncoder.withIndent('  ');
  final colorsOutput = encoder.convert(colorsJson);
  final tokensOutput = encoder.convert(outJson);

  const colorsPath = 'radix_colors.generated.json';
  const tokensPath = 'radix_tokens.generated.json';
  await File(colorsPath).writeAsString(colorsOutput);
  stdout.writeln('[done] Wrote $colorsPath');
  await File(tokensPath).writeAsString(tokensOutput);
  stdout.writeln('[done] Wrote $tokensPath');

  // Components: fetch and group variables from components.css
  final componentsUrl = '$themesBase@$themesVersion/components.css';
  stdout.writeln('[fetch] components <- $componentsUrl');
  final componentsCss = await _fetch(componentsUrl);
  final componentsOut = <String, Map<String, String>>{};
  if (componentsCss == null) {
    stderr.writeln('[warn] Failed to fetch components.css');
  } else {
    final vars = parseCssVariables(componentsCss);

    bool isTwoWordHead(String a, String b) {
      const heads = {
        'text-field',
        'text-area',
        'base-dialog',
        'theme-panel',
        'segmented-control',
        'radio-card',
      };

      return heads.contains('$a-$b');
    }

    String groupFor(String name) {
      final parts = name.split('-');
      if (parts.length >= 2 && isTwoWordHead(parts[0], parts[1])) {
        return '${parts[0]}-${parts[1]}';
      }

      return parts.first;
    }

    vars.forEach((rawKey, value) {
      final key = rawKey.trim();
      if (key.isEmpty) return;
      final group = groupFor(key);
      final bucket = componentsOut.putIfAbsent(group, () => <String, String>{});
      bucket[key] = value;
    });
  }

  final componentsJson = <String, dynamic>{
    'meta': <String, dynamic>{
      'description': 'Radix component tokens grouped by component type.',
      'radix_themes_version': themesVersion,
      'generated': DateTime.now().toIso8601String(),
    },
    'components': componentsOut,
  };
  final componentsOutput = encoder.convert(componentsJson);
  const componentsPath = 'radix_components.generated.json';
  await File(componentsPath).writeAsString(componentsOutput);
  stdout.writeln('[done] Wrote $componentsPath');

  exit(0);
}

Future<String?> _fetch(String url) async {
  try {
    final client = HttpClient()
      ..userAgent = 'remix-scripts/1.0'
      ..idleTimeout = const Duration(seconds: 5)
      ..connectionTimeout = const Duration(seconds: 15);

    final req = await client
        .getUrl(Uri.parse(url))
        .timeout(const Duration(seconds: 20), onTimeout: () {
      client.close(force: true);

      return throw TimeoutException('getUrl timeout');
    });

    final res =
        await req.close().timeout(const Duration(seconds: 30), onTimeout: () {
      client.close(force: true);

      return throw TimeoutException('close timeout');
    });

    if (res.statusCode != 200) {
      client.close(force: true);

      return null;
    }

    final data = await res
        .transform(utf8.decoder)
        .join()
        .timeout(const Duration(seconds: 30), onTimeout: () {
      client.close(force: true);
      throw TimeoutException('read timeout');
    });

    client.close(force: true);

    return data;
  } catch (_) {
    return null;
  }
}
