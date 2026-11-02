import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'palette_generator.dart';

/// Run from anywhere. With no options, regenerates the seven built-in accents
/// and the dedicated error palette.
/// Custom: --name brand --seed '#8038CC' --output lib/ui/theme/brand_colors.dart
void main(List<String> arguments) {
  final options = <String, String>{};
  var check = false;
  try {
    for (var i = 0; i < arguments.length; i++) {
      final flag = arguments[i];
      if (flag == '--check') {
        check = true;
      } else if ([
            '--name',
            '--seed',
            '--output',
            '--palette-import',
            '--type-prefix',
          ].contains(flag) &&
          i + 1 < arguments.length) {
        options[flag] = arguments[++i];
      } else {
        throw FormatException('Unknown or incomplete option: $flag');
      }
    }
    final custom =
        options.containsKey('--name') || options.containsKey('--seed');
    final typePrefix = options['--type-prefix'] ?? 'Fortal';
    if (!RegExp(r'^[A-Z][A-Za-z0-9]*$').hasMatch(typePrefix)) {
      throw const FormatException('Invalid --type-prefix.');
    }
    var seeds = <String, int>{for (final name in builtInPaletteNames) name: 0};
    if (custom) {
      final name = options['--name'] ?? '';
      final hex = (options['--seed'] ?? '').replaceFirst('#', '');
      if (!RegExp(r'^[a-z][A-Za-z0-9]*$').hasMatch(name) ||
          !RegExp(r'^[0-9A-Fa-f]{6}$').hasMatch(hex) ||
          !options.containsKey('--output')) {
        throw const FormatException(
          'Custom palettes require --name (lowerCamelCase), --seed (#RRGGBB), and --output.',
        );
      }
      if (reservedPaletteNames(typePrefix).contains(name)) {
        throw FormatException(
          '--name $name is a built-in palette identifier; choose another name.',
        );
      }
      seeds = {name: 0xff000000 | int.parse(hex, radix: 16)};
    }
    final output = options['--output'] == null
        ? File.fromUri(
            Platform.script.resolve(
              '../../lib/src/fortal/theme/fortal_colors.dart',
            ),
          )
        : File(options['--output']!);
    var source = renderPalettes(
      seeds,
      paletteImport: options['--palette-import'] ?? 'palette.dart',
      builtIns: !custom,
      errorName: errorPaletteName(typePrefix),
    ).replaceAll('FortalColor', '${typePrefix}Color');
    if (!custom) {
      final valuePrefix =
          '${typePrefix[0].toLowerCase()}${typePrefix.substring(1)}';
      source = source.replaceAll(RegExp(r'\bfortal(?=[A-Z])'), valuePrefix);
    }
    // Use the installed SDK's formatter, so --check compares canonical Dart.
    final temp = Directory.systemTemp.createTempSync('fortal_palette_');
    late String formatted;
    try {
      final file = File('${temp.path}/colors.dart')..writeAsStringSync(source);
      final result = Process.runSync(Platform.resolvedExecutable, [
        'format',
        file.path,
      ]);
      if (result.exitCode != 0) throw StateError('${result.stderr}');
      formatted = file.readAsStringSync();
    } finally {
      temp.deleteSync(recursive: true);
    }
    if (check) {
      if (!output.existsSync() || output.readAsStringSync() != formatted) {
        stderr.writeln(
          '${output.path} is stale. Run registry_source/tool/fortal_palettes/generate.dart.',
        );
        exitCode = 1;
        return;
      }
      stdout.writeln('Fortal palettes are current.');
    } else {
      output.parent.createSync(recursive: true);
      output.writeAsStringSync(formatted);
      stdout.writeln(
        custom
            ? 'Generated the ${seeds.keys.single} palette: ${output.path}'
            : 'Generated ${seeds.length} accent palettes and the semantic '
                  'error palette: ${output.path}',
      );
    }
  } on FormatException catch (error) {
    stderr.writeln(error.message);
    exitCode = 64;
  }
}

/// The error palette identifier an installed theme declares for
/// [typePrefix]: `fortalError` for Fortal, `acmeError` for Acme.
String errorPaletteName(String typePrefix) =>
    '${typePrefix[0].toLowerCase()}${typePrefix.substring(1)}Error';

/// Identifiers declared by the installed built-in palette file. A custom
/// palette with one of these names would be ambiguous beside it.
Set<String> reservedPaletteNames(String typePrefix) => {
  ...builtInPaletteNames,
  'calcadao',
  errorPaletteName(typePrefix),
  'blackAlpha',
  'whiteAlpha',
  for (final suffix in [
    'GrayNeutral',
    'SageNeutral',
    'SlateNeutral',
    'OliveNeutral',
    'SandNeutral',
    'NeutralPalettes',
  ])
    '${typePrefix[0].toLowerCase()}${typePrefix.substring(1)}$suffix',
};

/// Renders [seeds] as palette constants. [builtIns] marks the shipped file:
/// Pinned Radix accent/neutral pairs, the dedicated error palette and
/// neutral alpha swatches are emitted. Custom output never infers either
/// from its name. [errorName] is the built-in error identifier for the
/// requested prefix; explicit custom names are never rewritten.
String renderPalettes(
  Map<String, int> seeds, {
  required String paletteImport,
  bool builtIns = false,
  String errorName = 'fortalError',
}) {
  if (paletteImport.contains("'") ||
      paletteImport.contains('\n') ||
      paletteImport.contains('\r')) {
    throw const FormatException('Invalid palette import.');
  }
  if (builtIns) return _renderRadixPalettes(paletteImport, errorName);
  final out = StringBuffer('''// GENERATED CODE - DO NOT EDIT.
// Fortal-owned OKLCH scales. Regenerate with tool/fortal_palettes/generate.dart.
import 'package:flutter/painting.dart';

import '$paletteImport';

''');
  for (final entry in seeds.entries) {
    _writePalette(
      out,
      entry.key,
      entry.value,
      generatePalette(entry.value, neutral: false),
    );
  }
  return out.toString();
}

void _writePalette(
  StringBuffer out,
  String name,
  int seed,
  GeneratedPalette palette, {
  String? note,
}) {
  out.writeln(
    '/// Seed: #${seed.toRadixString(16).substring(2).toUpperCase()}.'
    '${note == null ? '' : ' $note'}',
  );
  out.writeln('const $name = FortalColorTheme(');
  for (final mode in [palette.light, palette.dark]) {
    out.writeln('FortalColor(FortalColorScale(');
    for (final scale in [mode.solid, mode.alpha]) {
      out.writeln('ColorSwatch(${_hex(scale[8])}, {');
      for (var i = 0; i < 12; i++) {
        out.writeln('${i + 1}: Color(${_hex(scale[i])}),');
      }
      out.writeln('}),');
    }
    // The labelled solid is written only where it differs from steps 9/10,
    // the fallback the palette class applies otherwise.
    final split = mode.fill != mode.solid[8] || mode.fillHover != mode.solid[9];
    out.writeln(
      '), Color(${_hex(mode.surface)}), Color(${_hex(mode.indicator)}), Color(${_hex(mode.track)}), Color(${_hex(mode.contrast)})'
      '${split ? ', solid: Color(${_hex(mode.fill)}), solidHover: Color(${_hex(mode.fillHover)})' : ''}),',
    );
  }
  out.writeln(');');
}

String _hex(int value) => '0x${value.toRadixString(16).padLeft(8, '0')}';

/// Built-in raw scales are pinned upstream data; functional roles are derived
/// separately for Fortal's contrast contract and Orla's primary emphasis.
String _renderRadixPalettes(String paletteImport, String errorName) {
  final relative = 'specs/fortal_radix_colors.json';
  final candidates = [
    File('registry_source/$relative'),
    File(relative),
    File.fromUri(Platform.script.resolve('../../$relative')),
  ];
  final file = candidates.firstWhere((file) => file.existsSync());
  final source = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  final provenance = source['source'] as Map<String, dynamic>;
  final pairs = source['pairs'] as Map<String, dynamic>;
  final scales = source['scales'] as Map<String, dynamic>;
  final license = (provenance['licenseText'] as String)
      .split('\n')
      .map((line) => '// $line')
      .join('\n');
  final out = StringBuffer('''// GENERATED CODE - DO NOT EDIT.
// Raw scales: ${provenance['package']} ${provenance['version']} (sRGB).
// Source: https://github.com/radix-ui/colors
// Regenerate with tool/fortal_palettes/generate.dart.
// Fortal derives labelled fills separately; raw and alpha scales are unchanged.
$license
import 'package:flutter/painting.dart';

import '$paletteImport';

''');
  for (final entry in pairs.entries) {
    final pair = entry.value as Map<String, dynamic>;
    final family = pair['accent'] as String;
    final data = scales[family] as Map<String, dynamic>;
    final labelInk = family == 'amber'
        ? _rgb(((data['light'] as Map)['solid'] as List)[11] as String)
        : 0xffffffff;
    final lightData = data['light'] as Map<String, dynamic>;
    final markInk = _rgb((lightData['solid'] as List)[11] as String);
    _writeRadixPalette(
      out,
      entry.key,
      data,
      labelInk: labelInk,
      markInk: markInk,
      note: 'Radix $family + ${pair['neutral']}; paired Fortal theme.',
      neutral: scales[pair['neutral']] as Map<String, dynamic>,
      strongNeutral: entry.key == 'orla',
    );
  }
  out.writeln("@Deprecated('Use orla instead.')\nconst calcadao = orla;\n");
  for (final family in {'gray', 'sage', 'slate', 'olive', 'sand'}) {
    _writeRadixPalette(
      out,
      'fortal${family[0].toUpperCase()}${family.substring(1)}Neutral',
      scales[family] as Map<String, dynamic>,
      labelInk: 0xffffffff,
      markInk: _rgb(
        (((scales[family] as Map)['light'] as Map)['solid'] as List)[11]
            as String,
      ),
      note: 'Internal Radix $family neutral family.',
    );
  }
  out.writeln('const fortalNeutralPalettes = <String, FortalColorTheme>{');
  for (final entry in pairs.entries) {
    final family = (entry.value as Map)['neutral'] as String;
    out.writeln(
      "'${entry.key}': fortal${family[0].toUpperCase()}${family.substring(1)}Neutral,",
    );
  }
  out.writeln('};');
  _writePalette(
    out,
    errorName,
    fortalErrorSeed,
    generateErrorPalette(),
    note: 'Error roles only; not a selectable accent.',
  );
  const opacity = [.02, .04, .07, .11, .16, .24, .35, .48, .62, .74, .86, .94];
  for (final name in ['black', 'white']) {
    final rgb = name == 'black' ? 0 : 0xffffff;
    out.writeln(
      'const ${name}Alpha = ColorSwatch(${_hex(rgb | 0xff000000)}, {',
    );
    for (var i = 0; i < 12; i++) {
      out.writeln(
        '${i + 1}: Color(${_hex((opacity[i] * 255).round() << 24 | rgb)}),',
      );
    }
    out.writeln('});');
  }

  return out.toString();
}

int _rgb(String value) => 0xff000000 | int.parse(value.substring(1), radix: 16);
int _alpha(String value) {
  if (value.length == 7) return _rgb(value);
  final rgba = int.parse(value.substring(1), radix: 16);
  return (rgba & 0xff) << 24 | rgba >> 8;
}

double _contrast(int first, int second) {
  double luminance(int argb) {
    double channel(int shift) {
      final value = ((argb >> shift) & 0xff) / 255;
      return value <= .04045
          ? value / 12.92
          : math.pow((value + .055) / 1.055, 2.4).toDouble();
    }

    return .2126 * channel(16) + .7152 * channel(8) + .0722 * channel(0);
  }

  final a = luminance(first), b = luminance(second);
  return (math.max(a, b) + .05) / (math.min(a, b) + .05);
}

int _whiteLabelFill(int fill) {
  if (_contrast(0xffffffff, fill) >= contrastMargin.text) return fill;
  final tone = toOklch(fill);
  var lightness = tone.l;
  do {
    lightness -= .002;
    fill = fromOklch((l: lightness, c: tone.c, h: tone.h));
  } while (_contrast(0xffffffff, fill) < contrastMargin.text);
  return fill;
}

void _writeRadixPalette(
  StringBuffer out,
  String name,
  Map<String, dynamic> data, {
  required int labelInk,
  required int markInk,
  required String note,
  Map<String, dynamic>? neutral,
  bool strongNeutral = false,
}) {
  out.writeln('/// $note');
  out.writeln('const $name = FortalColorTheme(');
  for (final mode in ['light', 'dark']) {
    final values = data[mode] as Map<String, dynamic>;
    final solid = [
      for (final value in values['solid'] as List) _rgb(value as String),
    ];
    final alpha = [
      for (final value in values['alpha'] as List) _alpha(value as String),
    ];
    var fill = solid[8], hover = solid[9];
    if (labelInk == 0xffffffff &&
        (_contrast(labelInk, fill) < contrastMargin.text ||
            _contrast(labelInk, hover) < contrastMargin.text)) {
      fill = _whiteLabelFill(fill);
      final tone = toOklch(fill);
      hover = _whiteLabelFill(
        fromOklch((l: tone.l - .035, c: tone.c, h: tone.h)),
      );
    }
    var mark = solid[8];
    if (mode == 'light' && labelInk == 0xffffffff && neutral != null) {
      final surfaces = ((neutral[mode] as Map)['solid'] as List)
          .take(2)
          .map((value) => _rgb(value as String))
          .toList();
      final tone = toOklch(mark);
      var lightness = tone.l;
      while (surfaces.any((surface) => _contrast(mark, surface) < 3.05)) {
        lightness -= .002;
        mark = fromOklch((l: lightness, c: tone.c, h: tone.h));
      }
    }
    var contrast = labelInk;
    var markHover = solid[9];
    if (strongNeutral) {
      // Orla's primary roles are deliberately stronger than Radix's default
      // mid-gray accent. Raw source steps and internal neutrals stay exact.
      fill = mode == 'dark' ? 0xffffffff : solid[11];
      hover = mode == 'dark' ? solid[11] : 0xff303030;
      contrast = mode == 'dark' ? solid[0] : 0xffffffff;
      mark = fill;
      markHover = hover;
    }
    final ink = strongNeutral
        ? contrast
        : [mark, markHover].every((fill) => _contrast(0xffffffff, fill) >= 3)
        ? 0xffffffff
        : markInk;
    out.writeln('FortalColor(FortalColorScale(');
    for (final scale in [solid, alpha]) {
      out.writeln('ColorSwatch(${_hex(scale[8])}, {');
      for (var i = 0; i < 12; i++)
        out.writeln('${i + 1}: Color(${_hex(scale[i])}),');
      out.writeln('}),');
    }
    out.writeln(
      '), Color(${_hex(alpha[2])}), Color(${_hex(mark)}), Color(${_hex(mark)}), Color(${_hex(contrast)}),',
    );
    out.writeln(
      'solid: Color(${_hex(fill)}), solidHover: Color(${_hex(hover)}), markContrast: Color(${_hex(ink)})'
      '${strongNeutral ? ', markHover: Color(${_hex(markHover)})' : ''}),',
    );
  }
  out.writeln(');');
}
