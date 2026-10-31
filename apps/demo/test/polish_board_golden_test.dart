import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:demo/polish_board.dart';
import 'package:demo/ui/theme/fortal_colors.dart';
import 'package:demo/ui/theme/palette.dart';
import 'package:demo/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    for (final family in ['FortalReview', 'Roboto']) {
      final loader = FontLoader(family);
      for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
        loader.addFont(
          File(
            '../../packages/remix_ui_fonts/lib/fonts/geist/Geist-$weight.ttf',
          ).readAsBytes().then((bytes) => ByteData.sublistView(bytes)),
        );
      }
      await loader.load();
    }
    final mono = FontLoader('Menlo');
    for (final weight in ['Regular', 'Medium']) {
      mono.addFont(
        File(
          '../../packages/remix_ui_fonts/lib/fonts/geist/GeistMono-$weight.ttf',
        ).readAsBytes().then((bytes) => ByteData.sublistView(bytes)),
      );
    }
    await mono.load();
    await (FontLoader(
      'MaterialIcons',
    )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
  });

  test('polish board covers every family in the owned specification', () {
    final catalog =
        jsonDecode(
              File(
                '../../registry_source/specs/fortal_catalog.json',
              ).readAsStringSync(),
            )
            as Map<String, dynamic>;
    final families = (catalog['families'] as List)
        .map((entry) => entry['id'] as String)
        .toSet();
    final board = polishFamilyIds
        .map(
          (id) => switch (id) {
            'textfield' => 'text_field',
            'textarea' => 'text_area',
            _ => id,
          },
        )
        .toSet();
    expect(board, families);
  });

  // Skia text rasterization is host-specific; canonical masters are Ubuntu 24.04 x64.
  for (final group in polishGroups) {
    testWidgets('$group: every size and variant in light and dark', (
      tester,
    ) async {
      final key = await _pumpBoard(
        tester,
        FortalPolishContents(group: group, fontFamily: 'FortalReview'),
      );
      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byKey(key)).height, lessThan(12000));
      await expectLater(
        find.byKey(key),
        matchesGoldenFile('goldens/fortal_${group.toLowerCase()}.png'),
      );
    }, skip: !Platform.isLinux);
  }

  testWidgets(
    'all palettes: soft, solid, surface, focus and disabled states',
    (tester) async {
      final key = await _pumpBoard(
        tester,
        _paletteBoard(FortalAccentColor.values),
      );
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byKey(key),
        matchesGoldenFile('goldens/fortal_palettes_states.png'),
      );
    },
    skip: !Platform.isLinux,
  );

  testWidgets(
    'semantics: status, Caju, error and chart colors in both modes',
    (tester) async {
      final key = await _pumpBoard(tester, _semanticsBoard());
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byKey(key),
        matchesGoldenFile('goldens/fortal_semantics.png'),
      );
    },
    skip: !Platform.isLinux,
  );

  testWidgets('public catalog: neutral and Mar light/dark states', (
    tester,
  ) async {
    final key = await _pumpBoard(
      tester,
      _paletteBoard([
        FortalAccentColor.calcadao,
        FortalAccentColor.mar,
      ], overview: true),
    );
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byKey(key),
      matchesGoldenFile('../../../docs/assets/fortal-catalog.png'),
    );
  }, skip: !Platform.isLinux);

  if (const bool.fromEnvironment('FORTAL_REVIEW')) {
    testWidgets('review export: palettes and semantics', (tester) async {
      for (final (name, board) in [
        ('palettes_states', _paletteBoard(FortalAccentColor.values)),
        ('semantics', _semanticsBoard()),
        ('foregrounds', _foregroundBoard()),
      ]) {
        final key = await _pumpBoard(tester, board);
        expect(tester.takeException(), isNull);
        await _export(tester, key, name);
      }
    });
    for (final accent in FortalAccentColor.values) {
      for (final group in polishGroups) {
        testWidgets('review export: ${accent.name}/$group', (tester) async {
          final key = await _pumpBoard(
            tester,
            FortalPolishContents(
              accent: accent,
              group: group,
              fontFamily: 'FortalReview',
            ),
          );
          expect(tester.takeException(), isNull);
          await _export(tester, key, '${accent.name}_${group.toLowerCase()}');
        });
      }
    }
    for (final state in [
      WidgetState.hovered,
      WidgetState.pressed,
      WidgetState.focused,
      WidgetState.disabled,
    ]) {
      for (final group in polishGroups) {
        testWidgets('review export: ${state.name}/$group', (tester) async {
          final key = await _pumpBoard(
            tester,
            FortalPolishContents(
              group: group,
              states: {state},
              fontFamily: 'FortalReview',
            ),
          );
          expect(tester.takeException(), isNull);
          await _export(tester, key, '${state.name}_${group.toLowerCase()}');
        });
      }
    }
  }
}

Future<GlobalKey> _pumpBoard(WidgetTester tester, Widget board) async {
  tester.view.devicePixelRatio = 1;
  await tester.binding.setSurfaceSize(const Size(1600, 12000));
  addTearDown(() async {
    tester.view.resetDevicePixelRatio();
    await tester.binding.setSurfaceSize(null);
  });
  FocusManager.instance.highlightStrategy =
      FocusHighlightStrategy.alwaysTraditional;
  addTearDown(
    () => FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.automatic,
  );
  final key = GlobalKey();
  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Align(
        alignment: Alignment.topCenter,
        child: RepaintBoundary(
          key: key,
          child: SizedBox(width: 1600, child: board),
        ),
      ),
    ),
  );
  await tester.pump(const Duration(milliseconds: 100));
  return key;
}

Future<void> _export(WidgetTester tester, GlobalKey key, String name) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(key));
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 1);
    try {
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      final file = File('../../.context/fortal-review/$name.png');
      await file.parent.create(recursive: true);
      await file.writeAsBytes(bytes!.buffer.asUint8List());
    } finally {
      image.dispose();
    }
  });
}

Widget _paletteBoard(
  Iterable<FortalAccentColor> accents, {
  bool overview = false,
}) => Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    for (final accent in accents)
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final dark in [false, true])
            Expanded(
              child: _PaletteStatePanel(
                accent: accent,
                dark: dark,
                overview: overview,
              ),
            ),
        ],
      ),
  ],
);

Widget _foregroundBoard() => Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    for (final dark in [false, true])
      Expanded(child: _ForegroundPanel(dark: dark)),
  ],
);

/// Review-only: every family's on-solid foreground on its standard solid
/// roles, followed by the high-contrast treatment for comparison.
class _ForegroundPanel extends StatelessWidget {
  const _ForegroundPanel({required this.dark});
  final bool dark;

  static const _rows = <(String, FortalColorTheme)>[
    ..._SemanticsPanel._families,
    ('Error', fortalError),
  ];

  @override
  Widget build(BuildContext context) => FortalTheme(
    mode: dark ? .dark : .light,
    child: PolishTypography(
      fontFamily: 'FortalReview',
      child: Builder(
        builder: (context) => ColoredBox(
          color: resolveFortalTokens(FortalTheme.of(context)).colorBackground,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 12,
              children: [
                FortalHeading(
                  'On-solid foregrounds · ${dark ? 'dark' : 'light'}',
                  size: .size4,
                ),
                for (final (name, palette) in _rows)
                  FortalTheme(
                    accentPalette: palette,
                    hasBackground: false,
                    child: PolishTypography(
                      fontFamily: 'FortalReview',
                      child: Row(
                        spacing: 12,
                        children: [
                          SizedBox(
                            width: 64,
                            child: FortalText(name, size: .size1),
                          ),
                          FortalButton(label: 'Solid', onPressed: () {}),
                          WidgetStateStyleOverride(
                            states: {WidgetState.hovered},
                            child: FortalButton(
                              label: 'Hover',
                              onPressed: () {},
                            ),
                          ),
                          FortalSwitch(
                            selected: true,
                            onChanged: (_) {},
                            semanticLabel: '$name switch',
                          ),
                          WidgetStateStyleOverride(
                            states: {WidgetState.selected},
                            child: const FortalCheckbox(selected: true),
                          ),
                          WidgetStateStyleOverride(
                            states: {WidgetState.selected},
                            child: RemixRadioGroup<String>(
                              groupValue: 'on',
                              child: FortalRadio<String>(
                                value: 'on',
                                semanticLabel: '$name radio',
                              ),
                            ),
                          ),
                          const FortalAvatar.solid(label: 'AB'),
                          const FortalBadge.solid(label: 'Badge'),
                          const SizedBox(width: 12),
                          FortalButton(
                            label: 'High',
                            highContrast: true,
                            onPressed: () {},
                          ),
                          FortalSwitch(
                            selected: true,
                            highContrast: true,
                            onChanged: (_) {},
                            semanticLabel: '$name high-contrast switch',
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _semanticsBoard() => Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    for (final dark in [false, true])
      Expanded(child: _SemanticsPanel(dark: dark)),
  ],
);

/// Dashboard status meanings, Caju beside the dedicated error red, and the
/// categorical chart palette. Labels carry meaning; color reinforces it.
class _SemanticsPanel extends StatelessWidget {
  const _SemanticsPanel({required this.dark});
  final bool dark;

  static const _statuses = <(String, FortalAccentColor?)>[
    ('Paid', .serra),
    ('Pending', .sol),
    ('Invited', .ceu),
    ('Cancelled', .calcadao),
    ('Refunded', null),
    ('Caju accent', .caju),
  ];

  static const _families = <(String, FortalColorTheme)>[
    ('Calçadão', calcadao),
    ('Mar', mar),
    ('Céu', ceu),
    ('Serra', serra),
    ('Sol', sol),
    ('Duna', duna),
    ('Caju', caju),
  ];

  /// A nested scope rebuilds Fortal's tokens, so reapply the review font.
  static Widget _scope(Widget child, {FortalAccentColor? accent}) =>
      FortalTheme(
        accent: accent,
        accentPalette: accent == null ? fortalError : null,
        hasBackground: false,
        child: PolishTypography(fontFamily: 'FortalReview', child: child),
      );

  static Widget _error(Widget child) => _scope(child);

  @override
  Widget build(BuildContext context) => FortalTheme(
    accent: .caju,
    mode: dark ? .dark : .light,
    child: PolishTypography(
      fontFamily: 'FortalReview',
      child: Builder(
        builder: (context) {
          final colors = resolveFortalTokens(FortalTheme.of(context));
          String familyOf(Color color) => _families
              .firstWhere(
                (family) =>
                    (dark ? family.$2.dark : family.$2.light).scale.step(9) ==
                    color,
              )
              .$1;
          return ColoredBox(
            color: colors.colorBackground,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 16,
                children: [
                  FortalHeading(
                    'Semantics · ${dark ? 'dark' : 'light'}',
                    size: .size4,
                  ),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      for (final (label, accent) in _statuses)
                        _scope(
                          FortalBadge(highContrast: true, label: label),
                          accent: accent,
                        ),
                    ],
                  ),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      FortalButton(label: 'Caju action', onPressed: () {}),
                      FortalButton.soft(label: 'Caju soft', onPressed: () {}),
                      _error(FortalButton(label: 'Delete', onPressed: () {})),
                      _error(
                        FortalButton.soft(label: 'Remove', onPressed: () {}),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 16,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: WidgetStateStyleOverride(
                          states: {WidgetState.focused},
                          child: const FortalTextField(
                            hintText: 'Focused (Caju)',
                            helperText: 'Accent focus ring',
                          ),
                        ),
                      ),
                      const Expanded(
                        child: FortalTextField(
                          error: true,
                          hintText: 'Workspace name',
                          helperText: 'Name is required',
                        ),
                      ),
                      Expanded(
                        child: WidgetStateStyleOverride(
                          states: {WidgetState.focused, WidgetState.error},
                          child: const FortalTextField(
                            error: true,
                            hintText: 'Focused with error',
                            helperText: 'Name is required',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 8,
                    children: [
                      for (final color in resolveFortalChartPalette(context))
                        Expanded(
                          child: Column(
                            spacing: 4,
                            children: [
                              SizedBox(
                                height: 32,
                                width: double.infinity,
                                child: ColoredBox(color: color),
                              ),
                              FortalText(familyOf(color), size: .size1),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}

class _PaletteStatePanel extends StatelessWidget {
  const _PaletteStatePanel({
    required this.accent,
    required this.dark,
    this.overview = false,
  });
  final FortalAccentColor accent;
  final bool dark;
  final bool overview;

  @override
  Widget build(BuildContext context) => FortalTheme(
    accent: accent,
    mode: dark ? .dark : .light,
    child: PolishTypography(
      fontFamily: 'FortalReview',
      child: Builder(
        builder: (context) {
          final colors = resolveFortalTokens(FortalTheme.of(context));
          return ColoredBox(
            color: colors.colorBackground,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 16,
                children: [
                  FortalHeading(
                    '${paletteLabel(accent)} · ${dark ? 'dark' : 'light'}',
                    size: .size4,
                  ),
                  Row(
                    children: [
                      for (var step = 1; step <= 12; step++)
                        Expanded(
                          child: SizedBox(
                            height: 24,
                            child: ColoredBox(
                              color: colors.accent.scale.step(step),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      FortalButton(label: 'Solid', onPressed: () {}),
                      FortalButton.soft(label: 'Soft', onPressed: () {}),
                      const FortalBadge(label: 'Soft label'),
                      const FortalAvatar(label: 'Ada'),
                    ],
                  ),
                  if (!overview) ...[
                    for (final variant in FortalSwitchVariant.values)
                      Row(
                        spacing: 16,
                        children: [
                          SizedBox(width: 72, child: FortalText(variant.name)),
                          for (final highContrast in [false, true])
                            for (final enabled in [true, false])
                              FortalSwitch(
                                variant: variant,
                                highContrast: highContrast,
                                selected: true,
                                enabled: enabled,
                                onChanged: (_) {},
                                semanticLabel:
                                    '${variant.name} '
                                    '${highContrast ? 'high contrast' : 'normal'} '
                                    '${enabled ? 'enabled' : 'disabled'}',
                              ),
                        ],
                      ),
                    const Row(
                      spacing: 16,
                      children: [
                        Expanded(
                          child: FortalTextField.soft(
                            hintText: 'Search workspace',
                            leading: Icon(Icons.search),
                          ),
                        ),
                        Expanded(
                          child: FortalTextField.soft(
                            enabled: false,
                            hintText: 'Disabled search',
                            leading: Icon(Icons.search),
                          ),
                        ),
                      ],
                    ),
                    const FortalTextArea.soft(
                      hintText: 'Notes',
                      leading: Icon(Icons.edit),
                    ),
                  ],
                  for (final state in [
                    WidgetState.hovered,
                    WidgetState.pressed,
                    WidgetState.focused,
                    WidgetState.disabled,
                  ])
                    WidgetStateStyleOverride(
                      states: {state},
                      child: Row(
                        spacing: 16,
                        children: [
                          FortalButton.soft(
                            label: state.name,
                            onPressed: () {},
                          ),
                          WidgetStateStyleOverride(
                            states: {state, WidgetState.selected},
                            child: const FortalCheckbox(selected: true),
                          ),
                          WidgetStateStyleOverride(
                            states: {state, WidgetState.selected},
                            child: const FortalSwitch(
                              selected: true,
                              semanticLabel: 'Switch',
                            ),
                          ),
                          const Expanded(
                            child: FortalTextField(hintText: 'Filled surface'),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}
