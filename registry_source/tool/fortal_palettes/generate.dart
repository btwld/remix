import 'dart:convert';
import 'dart:io';
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
    ).replaceAll(RegExp(r'\bFortal(?=[A-Z])'), typePrefix);
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
  errorPaletteName(typePrefix),
  'blackAlpha',
  'whiteAlpha',
  for (final suffix in ['Neutral', 'FunctionalLight', 'FunctionalDark'])
    '${typePrefix[0].toLowerCase()}${typePrefix.substring(1)}$suffix',
};

/// Renders [seeds] as palette constants. [builtIns] marks the shipped file:
/// The neutral, the accents, the dedicated error palette, the functional
/// roles and the neutral alpha swatches are emitted. Custom output never infers either
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
  if (builtIns) return _renderFoundationPalettes(paletteImport, errorName);
  final out = StringBuffer(
    '''// Fortal OKLCH scales, generated from the seed noted on each palette.
import 'package:flutter/painting.dart';

import '$paletteImport';

''',
  );
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

/// Built-in scales and roles are Fortal's foundation literals, read from
/// `specs/fortal_colors.json`; the generated file only arranges them.
String _renderFoundationPalettes(String paletteImport, String errorName) {
  const relative = 'specs/fortal_colors.json';
  final candidates = [
    File('registry_source/$relative'),
    File(relative),
    File.fromUri(Platform.script.resolve('../../$relative')),
  ];
  final file = candidates.firstWhere((file) => file.existsSync());
  final source = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  final out = StringBuffer(
    """// Fortal's foundation colours, generated from specs/fortal_colors.json.
// One untinted neutral serves every accent; each accent pins its own roles.
import 'package:flutter/painting.dart';

import '$paletteImport';

""",
  );
  _writeTheme(
    out,
    'fortalNeutral',
    source['neutral'] as Map<String, dynamic>,
    note:
        'The neutral scale every accent shares, with the neutral control roles.',
  );
  final accents = (source['accents'] as Map).cast<String, dynamic>();
  for (final entry in accents.entries) {
    _writeTheme(
      out,
      entry.key,
      entry.value as Map<String, dynamic>,
      note: 'The ${entry.key} accent palette.',
    );
  }
  _writeTheme(
    out,
    errorName,
    source['error'] as Map<String, dynamic>,
    note: 'Error roles only; not a selectable accent.',
  );
  final functional = (source['functional'] as Map).cast<String, dynamic>();
  for (final mode in ['light', 'dark']) {
    final values = (functional[mode] as Map).cast<String, dynamic>();
    out.writeln(
      '/// $mode roles that follow neither the accent nor a custom palette.',
    );
    out.writeln(
      'const fortalFunctional${mode[0].toUpperCase()}${mode.substring(1)} = FortalFunctionalColors(',
    );
    for (final entry in values.entries) {
      out.writeln('${entry.key}: Color(${entry.value}),');
    }
    out.writeln(');');
  }
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

void _writeTheme(
  StringBuffer out,
  String name,
  Map<String, dynamic> theme, {
  required String note,
}) {
  out.writeln('/// $note');
  out.writeln('const $name = FortalColorTheme(');
  for (final mode in ['light', 'dark']) {
    final values = (theme[mode] as Map).cast<String, dynamic>();
    out.writeln('FortalColor(FortalColorScale(');
    for (final key in ['solid', 'alpha']) {
      final scale = (values[key] as List).cast<String>();
      out.writeln('ColorSwatch(${scale[8]}, {');
      for (var i = 0; i < 12; i++) {
        out.writeln('${i + 1}: Color(${scale[i]}),');
      }
      out.writeln('}),');
    }
    out.write(
      '), Color(${values['surface']}), Color(${values['indicator']}), '
      'Color(${values['track']}), Color(${values['contrast']})',
    );
    for (final (key, field) in [
      ('fill', 'solid'),
      ('fillHover', 'solidHover'),
      ('markContrast', 'markContrast'),
      ('markHover', 'markHover'),
    ]) {
      if (values[key] case final String value) {
        out.write(', $field: Color($value)');
      }
    }
    if (values['roles'] case final Map roles) {
      out.write(', roles: FortalColorRoles(');
      for (final entry in roles.entries) {
        out.write('${entry.key}: Color(${entry.value}), ');
      }
      out.write(')');
    }
    out.writeln('),');
  }
  out.writeln(');');
}
