import 'dart:convert';

/// Parses CSS variable declarations into a flat map.
///
/// Strips @supports P3 blocks and extracts `--name: value;` declarations.
/// Optionally filters by [prefix].
Map<String, String> parseCssVariables(String css, {String? prefix}) {
  final filtered = _stripP3Blocks(css);
  final declRe = RegExp(r'^\s*--([a-z0-9-]+):\s*([^;]+);', caseSensitive: false);

  final out = <String, String>{};
  for (final rawLine in const LineSplitter().convert(filtered)) {
    final m = declRe.firstMatch(rawLine);
    if (m == null) continue;
    final name = m.group(1)!.trim();
    final value = m.group(2)!.trim();
    if (prefix != null && !name.startsWith(prefix)) continue;
    out[name] = value;
  }

  return out;
}

String _stripP3Blocks(String css) {
  final lines = const LineSplitter().convert(css);
  final out = StringBuffer();

  var inP3 = false;
  var depth = 0;

  for (final line in lines) {
    final trimmed = line.trimLeft();

    if (!inP3 && trimmed.startsWith('@supports') && trimmed.contains('color(display-p3')) {
      inP3 = true;
      depth = 0;
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

