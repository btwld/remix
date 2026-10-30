import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:demo/polish_board.dart';
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
    });
  }

  testWidgets('all palettes: soft, solid, surface, focus and disabled states', (
    tester,
  ) async {
    final key = await _pumpBoard(
      tester,
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final accent in FortalAccentColor.values)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final dark in [false, true])
                  Expanded(
                    child: _PaletteStatePanel(accent: accent, dark: dark),
                  ),
              ],
            ),
        ],
      ),
    );
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byKey(key),
      matchesGoldenFile('goldens/fortal_palettes_states.png'),
    );
  });

  if (const bool.fromEnvironment('FORTAL_REVIEW')) {
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

class _PaletteStatePanel extends StatelessWidget {
  const _PaletteStatePanel({required this.accent, required this.dark});
  final FortalAccentColor accent;
  final bool dark;

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
