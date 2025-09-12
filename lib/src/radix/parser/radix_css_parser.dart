import 'dart:convert';

enum _Section { none, light, dark, root }

/// Parsed representation of a single light/dark section for a Radix scale.
class RadixScaleSection {
  final Map<String, String> solid; // keys: '1'..'12'
  final Map<String, String> alpha; // keys: 'a1'..'a12'
  final String? surface;
  final String? indicator;
  final String? track;
  final String? contrast;

  const RadixScaleSection({
    required this.solid,
    required this.alpha,
    this.surface,
    this.indicator,
    this.track,
    this.contrast,
  });

  Map<String, dynamic> toJson() => {
        'solid': solid,
        'alpha': alpha,
        if (surface != null) 'surface': surface,
        if (indicator != null) 'indicator': indicator,
        if (track != null) 'track': track,
        if (contrast != null) 'contrast': contrast,
      };
}

/// Result of parsing a Radix CSS file for a given scale.
class RadixCssParseResult {
  final RadixScaleSection? light;
  final RadixScaleSection? dark;

  const RadixCssParseResult({this.light, this.dark});
}

/// Parses a Radix colors CSS (Themes tokens) for a specific [scale] (e.g., 'indigo').
///
/// - Skips P3 blocks under `@supports (color: color(display-p3 ...))`.
/// - Resolves simple `var(--{scale}-N)` references to concrete values within the same section.
/// - Leaves complex expressions (e.g., `oklab_mix(...)`) as-is.
RadixCssParseResult parseRadixCss(String css, String scale) {
  final filtered = _stripP3Blocks(css);

  final lightSolid = <String, String>{};
  final lightAlpha = <String, String>{};
  String? lightSurface;
  String? lightIndicator;
  String? lightTrack;
  String? lightContrast;

  final darkSolid = <String, String>{};
  final darkAlpha = <String, String>{};
  String? darkSurface;
  String? darkIndicator;
  String? darkTrack;
  String? darkContrast;

  var section = _Section.none;
  var braceDepth = 0;

  final declRe = RegExp(
    r'^\s*--([a-z0-9-]+):\s*([^;]+);',
    caseSensitive: false,
  );

  // Headers we care about
  final lightHeaderRe = RegExp(r'^\s*:root,\s*\.light,\s*\.light-theme\s*\{');
  final darkHeaderRe = RegExp(r'^\s*\.dark,\s*\.dark-theme\s*\{');
  final rootHeaderRe = RegExp(r'^\s*:root\s*\{');

  for (final rawLine in const LineSplitter().convert(filtered)) {
    final line = rawLine.trimRight();

    // Track braces to know when we leave a section
    if (line.contains('{')) braceDepth++;
    if (line.contains('}')) {
      braceDepth--;
      if (braceDepth <= 0) {
        section = _Section.none;
        braceDepth = 0;
      }
    }

    if (section == _Section.none) {
      if (lightHeaderRe.hasMatch(line)) {
        section = _Section.light;
        // braceDepth already incremented this line
        continue;
      }
      if (darkHeaderRe.hasMatch(line)) {
        section = _Section.dark;
        continue;
      }
      if (rootHeaderRe.hasMatch(line)) {
        section = _Section.root;
        continue;
      }
    }

    final m = declRe.firstMatch(line);
    if (m == null) continue;

    final name = m.group(1)!.trim();
    final valueRaw = m.group(2)!.trim();

    // Only consider variables for our scale
    if (!name.startsWith('$scale-')) continue;

    String value = _normalizeColorValue(valueRaw);

    // Attempt to resolve var(--scale-*) refs within the same section using a switch expression
    final (solidMap, alphaMap) = switch (section) {
      _Section.light => (lightSolid, lightAlpha),
      _Section.dark => (darkSolid, darkAlpha),
      _Section.root || _Section.none => (
          <String, String>{},
          <String, String>{},
        ),
    };
    value = _resolveVarRefs(value, scale, (solidMap, alphaMap));

    void writeToSection() {
      if (name == '$scale-surface') {
        switch (section) {
          case _Section.light:
            lightSurface = value;
            break;
          case _Section.dark:
            darkSurface = value;
            break;
          case _Section.root:
          case _Section.none:
            break;
        }

        return;
      }
      if (name == '$scale-indicator') {
        switch (section) {
          case _Section.light:
            lightIndicator = value;
            break;
          case _Section.dark:
            darkIndicator = value;
            break;
          case _Section.root:
          case _Section.none:
            break;
        }

        return;
      }
      if (name == '$scale-track') {
        switch (section) {
          case _Section.light:
            lightTrack = value;
            break;
          case _Section.dark:
            darkTrack = value;
            break;
          case _Section.root:
          case _Section.none:
            break;
        }

        return;
      }
      if (name == '$scale-contrast') {
        // Usually appears in :root; we duplicate into both sections.
        final v = value;
        lightContrast ??= v;
        darkContrast ??= v;

        return;
      }
      // solid and alpha entries
      final suffix = name.substring(scale.length + 1); // after "{scale}-"
      if (RegExp(r'^[0-9]{1,2}$').hasMatch(suffix)) {
        switch (section) {
          case _Section.light:
            lightSolid[suffix] = value;
            break;
          case _Section.dark:
            darkSolid[suffix] = value;
            break;
          case _Section.root:
            // If tokens are defined at :root (e.g., neutrals), duplicate into both.
            lightSolid[suffix] = value;
            darkSolid[suffix] = value;
            break;
          case _Section.none:
            break;
        }

        return;
      }
      final aMatch = RegExp(r'^a([0-9]{1,2})$').firstMatch(suffix);
      if (aMatch != null) {
        final n = aMatch.group(1)!;
        final key = 'a$n';
        switch (section) {
          case _Section.light:
            lightAlpha[key] = value;
            break;
          case _Section.dark:
            darkAlpha[key] = value;
            break;
          case _Section.root:
            // If tokens are defined at :root (e.g., neutrals), duplicate into both.
            lightAlpha[key] = value;
            darkAlpha[key] = value;
            break;
          case _Section.none:
            break;
        }
      }
    }

    writeToSection();
  }

  RadixScaleSection? buildSection(
    Map<String, String> solid,
    Map<String, String> alpha,
    String? surface,
    String? indicator,
    String? track,
    String? contrast,
  ) {
    if (solid.isEmpty &&
        alpha.isEmpty &&
        surface == null &&
        indicator == null &&
        track == null &&
        contrast == null) {
      return null;
    }

    return RadixScaleSection(
      solid: solid,
      alpha: alpha,
      surface: surface,
      indicator: indicator,
      track: track,
      contrast: contrast,
    );
  }

  return RadixCssParseResult(
    light: buildSection(
      lightSolid,
      lightAlpha,
      lightSurface,
      lightIndicator,
      lightTrack,
      lightContrast,
    ),
    dark: buildSection(
      darkSolid,
      darkAlpha,
      darkSurface,
      darkIndicator,
      darkTrack,
      darkContrast,
    ),
  );
}

String _stripP3Blocks(String css) {
  final lines = const LineSplitter().convert(css);
  final out = StringBuffer();

  var inP3 = false;
  var depth = 0;

  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    final trimmed = line.trimLeft();

    if (!inP3 &&
        trimmed.startsWith('@supports') &&
        trimmed.contains('color(display-p3')) {
      inP3 = true;
      depth = 0;
      // fall through to count braces, but do not include line
    }

    if (inP3) {
      depth += _countChar(line, '{');
      depth -= _countChar(line, '}');
      if (depth <= 0 && trimmed.contains('}')) {
        inP3 = false;
      }
      continue; // skip lines within p3 blocks
    }

    out.writeln(line);
  }

  return out.toString();
}

int _countChar(String s, String ch) {
  var c = 0;
  for (var i = 0; i < s.length; i++) {
    if (s[i] == ch) c++;
  }

  return c;
}

String _normalizeColorValue(String value) {
  // Trim trailing commas or whitespace
  var v = value.trim();

  // Convert named white/black to hex for consistency
  if (RegExp(r'^white$', caseSensitive: false).hasMatch(v)) return '#ffffff';
  if (RegExp(r'^black$', caseSensitive: false).hasMatch(v)) return '#000000';

  return v;
}

String _resolveVarRefs(
  String value,
  String scale,
  (Map<String, String>, Map<String, String>) sectionMaps,
) {
  // Only resolve simple var(--scale-9) or var(--scale-a9)
  final varRe =
      RegExp(r'^var\(--' + RegExp.escape(scale) + r'-(a)?([0-9]{1,2})\)$');
  final m = varRe.firstMatch(value);
  if (m == null) return value;

  final isAlpha = m.group(1) != null;
  final idx = m.group(2)!;
  final solid = sectionMaps.$1;
  final alpha = sectionMaps.$2;

  if (isAlpha) {
    return alpha['a$idx'] ?? value;
  }

  return solid[idx] ?? value;
}
