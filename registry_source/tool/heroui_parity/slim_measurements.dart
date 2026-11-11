// Derives reference/heroui_3_2_6/measurements.json from the Chromium captures
// that chromium/generate.mjs writes.
//
// Keeps the families HeroUI ships over Remix, viewports 375 and 1024 (either
// side of the `md` breakpoint), and the geometry and paint styles a recipe
// test compares. Run from registry_source:
//
//   dart run tool/heroui_parity/slim_measurements.dart
import 'dart:convert';
import 'dart:io';

const _reference = 'reference/heroui_3_2_6';

/// Capture-id prefixes of the shipped families.
const _families = [
  'accordion',
  'alert',
  'avatar',
  'badge',
  'breadcrumbs',
  'button',
  'card',
  'checkbox',
  'chip',
  'close',
  'combobox',
  'code',
  'disclosure',
  'dropdown',
  'group',
  'heading',
  'input',
  'kbd',
  'link',
  'menu',
  'modal',
  'paragraph',
  'popover',
  'progress',
  'prose',
  'radio',
  'search',
  'select',
  'separator',
  'skeleton',
  'slider',
  'spinner',
  'surface',
  'switch',
  'table',
  'tabs',
  'textarea',
  'textfield',
  'toast',
  'toggle',
  'tooltip',
  'typography',
];

const _styles = [
  'width',
  'height',
  'minHeight',
  'minWidth',
  'paddingTop',
  'paddingRight',
  'paddingBottom',
  'paddingLeft',
  'gap',
  'borderRadius',
  'borderTopWidth',
  'borderRightWidth',
  'borderBottomWidth',
  'borderLeftWidth',
  'borderColor',
  'backgroundColor',
  'color',
  'opacity',
  'fontSize',
  'fontWeight',
  'lineHeight',
  'letterSpacing',
  'boxShadow',
  'outlineStyle',
  'outlineColor',
  'outlineWidth',
  'outlineOffset',
  'textDecorationLine',
];

/// Further styles kept for one family; adding them to [_styles] would also
/// rewrite every existing case that happens to carry them.
const _familyStyles = {
  'accordion': ['rotate', 'left', 'right'],
  'disclosure': ['rotate'],
  'combobox': ['transform'],
  'modal': [
    'maxWidth',
    'maxHeight',
    'marginTop',
    'marginBottom',
    'backdropFilter',
    'overflow',
  ],
  'progress': ['overflow'],
  'slider': ['left', 'top', 'transform', 'scale'],
  'table': ['rotate'],
  'tooltip': ['maxWidth'],
};

/// Families whose captures also keep the box position (`x`, `y`): viewport
/// coordinates for Modal and Toast, offsets from the trigger for Tooltip.
const _positioned = {'modal', 'toast', 'tooltip'};

/// CSS initial values, omitted to keep the file small.
const _initial = {'0px', 'normal', 'none', 'auto', '0', 'rgba(0, 0, 0, 0)'};

const _widths = {'375', '1024'};

void main(List<String> arguments) {
  if (arguments.isNotEmpty) {
    if (arguments.length != 1 ||
        !const {'--range-slider', '--calendar'}.contains(arguments.single)) {
      throw ArgumentError('Usage: slim_measurements.dart [--range-slider]');
    }
    _mergeMatrix(
      arguments.single == '--calendar' ? 'calendar' : 'range_slider',
    );
    return;
  }
  final modes = <String, Map<String, Map<String, Object>>>{};
  Map<String, Object> group(String mode, String name) =>
      (modes[mode] ??= {})[name] ??= <String, Object>{};

  // Matrix captures: modes.<mode>.viewports.<width>.<id> and .states.<id>.
  for (final file in [
    'measurements',
    'foundation',
    'selection',
    'toggles',
    'editors',
    'families2',
    'range_slider',
  ]) {
    final capture = _read('chromium/$file.json');
    for (final MapEntry(key: mode, value: data)
        in (capture['modes'] as Map<String, dynamic>).entries) {
      final viewports =
          (data['viewports'] ?? <String, dynamic>{}) as Map<String, dynamic>;
      for (final MapEntry(key: width, value: cases) in viewports.entries) {
        if (!_widths.contains(width)) continue;
        for (final MapEntry(key: id, value: measurement)
            in (cases as Map<String, dynamic>).entries) {
          if (_shipped(id)) {
            group(mode, width)[id] = _slim(measurement, id);
          }
        }
      }
      for (final MapEntry(key: id, value: measurement)
          in ((data['states'] ?? <String, dynamic>{}) as Map<String, dynamic>)
              .entries) {
        if (!_shipped(id) || measurement is! Map) continue;
        if (measurement['styles'] != null) {
          group(mode, 'states')[id] = _slim(measurement, id);
          continue;
        }
        // Interaction states record each slot separately (control, content).
        for (final MapEntry(key: slot, value: part) in measurement.entries) {
          if (part is Map && part['styles'] != null) {
            group(mode, 'states')['$id-$slot'] = _slim(part, '$id-$slot');
          }
        }
      }
    }
  }

  // Interaction captures: one case per mode/width/variant/state, with slots.
  // A slot that repeats (tabs, list items) is keyed by its text.
  for (final family in ['tabs', 'select', 'menu', 'dropdown', 'combobox']) {
    final capture = _read('chromium/${family}_visual.json');
    for (final c in capture['cases'] as List) {
      final width = '${c['width']}';
      if (!_widths.contains(width)) continue;
      final measurements = (c['measurements'] as List).cast<Map>();
      final slots = <String, int>{};
      for (final m in measurements) {
        slots.update('${m['slot']}', (n) => n + 1, ifAbsent: () => 1);
      }
      for (final m in measurements) {
        final slot = '${m['slot']}';
        final text = '${m['text'] ?? ''}'.trim();
        final key = slots[slot]! > 1 && text.isNotEmpty
            ? '$family-${c['variant']}-${c['state']}-$slot:$text'
            : '$family-${c['variant']}-${c['state']}-$slot';
        group('${c['mode']}', width)[key] = _slim(m, key);
      }
    }
  }

  // Breadcrumbs record item rects and the list gap.
  for (final v in _read('chromium/breadcrumbs_visual.json')['visual'] as List) {
    final width = '${v['width']}';
    if (!_widths.contains(width) || v['direction'] != 'ltr') continue;
    final state = v['state'] as Map<String, dynamic>;
    final root = state['root'] as Map<String, dynamic>;
    final prefix = 'breadcrumbs-${v['stateName']}';
    group('${v['mode']}', width)[prefix] = {
      'rect': _rect(root['rect']),
      'styles': {'gap': root['gap']},
    };
    for (final item in state['items'] as List) {
      group('${v['mode']}', width)['$prefix-item:${item['text']}'] = {
        'rect': _rect(item['rect']),
      };
    }
  }

  // 375 lists only the cases that differ from 1024.
  for (final groups in modes.values) {
    final desktop = groups['1024'] ?? {};
    groups['375']?.removeWhere(
      (id, value) => jsonEncode(desktop[id]) == jsonEncode(value),
    );
  }

  final source = _read('chromium/measurements.json');
  final env = source['environment'] as Map<String, dynamic>;
  _write({
    'upstream': source['upstream'],
    'environment': {
      for (final key in [
        'browser',
        'deviceScaleFactor',
        'colorProfile',
        'reducedMotion',
        'resolvedFonts',
      ])
        if (env.containsKey(key)) key: env[key],
    },
    'note':
        'Viewport 375 lists only cases that differ from 1024. Styles omit CSS '
        'initial values. Regenerate with tool/heroui_parity/slim_measurements.dart.',
    'modes': modes,
  });
}

// Refresh this isolated matrix without requiring all ignored raw captures.
void _mergeMatrix(String matrix) {
  final existing = _read('measurements.json');
  final capture = _read('chromium/$matrix.json');
  if (capture['upstream'] != existing['upstream']) {
    throw StateError('Range slider upstream commit drift');
  }
  final modes = <String, Map<String, Map<String, Object>>>{
    for (final entry in (existing['modes'] as Map<String, dynamic>).entries)
      entry.key: {
        for (final group in (entry.value as Map<String, dynamic>).entries)
          group.key: Map<String, Object>.from(group.value as Map),
      },
  };
  for (final entry in (capture['modes'] as Map<String, dynamic>).entries) {
    final groups = modes[entry.key]!;
    for (final cases in groups.values) {
      cases.removeWhere(
        (id, _) => matrix == 'calendar'
            ? const [
                'calendar-',
                'range-calendar-',
                'date-picker-',
                'date-range-picker-',
              ].any(id.startsWith)
            : id.startsWith('slider-range-'),
      );
    }
    final data = entry.value as Map;
    for (final width in _widths) {
      final cases = (data['viewports'] as Map)[width] as Map;
      for (final entry in cases.entries) {
        (groups[width] ??= {})[entry.key as String] = _slim(
          entry.value as Map,
          entry.key as String,
        );
      }
    }
    for (final entry in (data['states'] as Map).entries) {
      (groups['states'] ??= {})[entry.key as String] = _slim(
        entry.value as Map,
        entry.key as String,
      );
    }
    groups['375']?.removeWhere(
      (id, value) => jsonEncode(groups['1024']?[id]) == jsonEncode(value),
    );
  }
  _write({
    ...existing,
    'environment': {
      ...existing['environment'] as Map,
      matrix: capture['environment'],
    },
    'modes': modes,
  });
}

bool _shipped(String id) =>
    _families.any((family) => id == family || id.startsWith('$family-')) &&
    !id.contains('readonly') &&
    // Sibling items in a group repeat the first item.
    !RegExp(r'-(b|c|d)(-|$)').hasMatch(id);

Map<String, Object> _slim(Map measurement, String id) {
  final family = id.split('-').first;
  final styles = <String, Object>{};
  final source = (measurement['styles'] ?? {}) as Map;
  final hasBorder = _styles.any(
    (key) =>
        key.endsWith('Width') &&
        key.startsWith('border') &&
        !_initial.contains(source[key]),
  );
  for (final key in [..._styles, ...?_familyStyles[family]]) {
    final value = source[key];
    if (value == null || _initial.contains(value)) continue;
    if (key == 'opacity' && value == '1') continue;
    if (key == 'borderColor' && !hasBorder) continue;
    if (key.startsWith('outline') && source['outlineStyle'] == 'none') continue;
    if (key == 'boxShadow' && _transparentShadows(value as String)) continue;
    styles[key] = value;
  }
  return {
    'rect': _rect(
      measurement['rect'],
      positioned: _positioned.contains(family),
    ),
    if (styles.isNotEmpty) 'styles': styles,
  };
}

Map<String, num> _rect(Object? rect, {bool positioned = false}) => {
  for (final key in [
    'width',
    'height',
    if (positioned) ...['x', 'y'],
  ])
    if ((rect as Map)[key] case final num value) key: value,
};

bool _transparentShadows(String value) => value
    .split(RegExp(r',\s(?=rgba|oklch|rgb|color)'))
    .every((part) => part.contains('rgba(0, 0, 0, 0)'));

Map<String, dynamic> _read(String path) =>
    jsonDecode(File('$_reference/$path').readAsStringSync())
        as Map<String, dynamic>;

/// One case per line, so diffs stay reviewable.
void _write(Map<String, Object?> data) {
  final out = StringBuffer('{\n');
  for (final key in ['upstream', 'environment', 'note']) {
    out.writeln(' ${jsonEncode(key)}: ${jsonEncode(data[key])},');
  }
  out.writeln(' "modes": {');
  final modes = data['modes']! as Map<String, Map<String, Map<String, Object>>>;
  final modeNames = modes.keys.toList()..sort();
  for (final (i, mode) in modeNames.indexed) {
    out.writeln('  ${jsonEncode(mode)}: {');
    final groups = [
      '1024',
      '375',
      'states',
    ].where(modes[mode]!.containsKey).toList();
    for (final (j, name) in groups.indexed) {
      out.writeln('   ${jsonEncode(name)}: {');
      final cases = modes[mode]![name]!.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key));
      for (final (k, entry) in cases.indexed) {
        final comma = k < cases.length - 1 ? ',' : '';
        out.writeln(
          '    ${jsonEncode(entry.key)}: ${jsonEncode(entry.value)}$comma',
        );
      }
      out.writeln('   }${j < groups.length - 1 ? ',' : ''}');
    }
    out.writeln('  }${i < modeNames.length - 1 ? ',' : ''}');
  }
  out.writeln(' }\n}');
  File('$_reference/measurements.json').writeAsStringSync(out.toString());
}
