import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:remix/remix.dart';

import '../../helpers/pixels.dart';
import '../../helpers/test_helpers.dart';

const _transparent = Color(0x00000000);

/// Radix's Table has no sortable header, so a focusable header takes Fortal's
/// own `focus-8` ring inside the cell, the way a tab does.
void main() {
  late FocusHighlightStrategy previousStrategy;

  setUp(() {
    previousStrategy = FocusManager.instance.highlightStrategy;
    FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.alwaysTraditional;
  });

  tearDown(() => FocusManager.instance.highlightStrategy = previousStrategy);

  Future<void> focusWithKeyboard(WidgetTester tester) async {
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
  }

  for (final variant in FortalDataTableVariant.values) {
    for (final mode in [FortalThemeMode.light, FortalThemeMode.dark]) {
      testWidgets(
        'a sortable ${variant.name} header rings in focus-8 on keyboard focus '
        'in ${mode.name}',
        (tester) async {
          final boundary = GlobalKey();
          await tester.pumpRemixApp(
            FortalTheme(
              mode: mode,
              child: RepaintBoundary(
                key: boundary,
                child: ColoredBox(
                  color: mode == .dark
                      ? const Color(0xFF000000)
                      : const Color(0xFFFFFFFF),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: 400,
                      child: FortalDataTable<String>(
                        variant: variant,
                        rows: const ['one'],
                        columns: [_column(sortable: true)],
                        onSortChanged: (_) {},
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
          final header = find.byType(Pressable);
          final cell = tester.getRect(header);
          final idle = await capturePixels(tester, boundary);

          await focusWithKeyboard(tester);
          final focused = await capturePixels(tester, boundary);
          final focus8 = MixScope.tokenOf(
            FortalTokens.focus8,
            tester.element(header),
          );

          // The ring is the 2px band along the cell's edges. The bottom edge
          // is left out: the row divider paints over its last pixel.
          final origin = tester.getTopLeft(find.byKey(boundary));
          Color pixel(Pixels pixels, Offset logical) {
            final device = (logical - origin) * pixelScale.toDouble();
            return pixels.at(device.dx.round(), device.dy.round());
          }

          for (final at in <Offset Function(double inside)>[
            (inside) => Offset(cell.center.dx, cell.top + inside),
            (inside) => Offset(cell.left + inside, cell.center.dy),
            (inside) => Offset(cell.right - inside, cell.center.dy),
          ]) {
            expectNearColor(pixel(focused, at(1)), focus8);
            expectNearColor(pixel(focused, at(3)), pixel(idle, at(3)));
            expectNearColor(pixel(focused, at(-1)), pixel(idle, at(-1)));
          }
          expect(tester.getRect(header), cell);
        },
      );
    }
  }

  group('a header that is not sortable', () {
    testWidgets('draws no ring inside a focused Pressable', (tester) async {
      final host = FocusNode();
      addTearDown(host.dispose);
      await tester.pumpRemixApp(
        Pressable(
          focusNode: host,
          onPress: () {},
          child: SizedBox(
            width: 400,
            child: FortalDataTable<String>(
              rows: const ['one'],
              columns: [_column()],
            ),
          ),
        ),
      );
      expect(_headerRings(tester), [_transparent]);

      await focusWithKeyboard(tester);

      expect(host.hasPrimaryFocus, isTrue);
      expect(_headerRings(tester), [_transparent]);
    });

    testWidgets('draws no ring inside a focused FortalDisclosure trigger', (
      tester,
    ) async {
      final host = FocusNode();
      addTearDown(host.dispose);
      await tester.pumpRemixApp(
        SizedBox(
          width: 400,
          child: FortalDisclosure(
            focusNode: host,
            defaultExpanded: true,
            trigger: const Text('Details'),
            content: FortalDataTable<String>(
              rows: const ['one'],
              columns: [_column()],
            ),
          ),
        ),
      );
      expect(_headerRings(tester), [_transparent]);

      await focusWithKeyboard(tester);

      expect(host.hasPrimaryFocus, isTrue);
      expect(_headerRings(tester), [_transparent]);
    });
  });

  testWidgets(
    'a custom header keeps its state while it takes and loses focus',
    (tester) async {
      var inits = 0;
      await tester.pumpRemixApp(
        SizedBox(
          width: 400,
          child: FortalDataTable<String>(
            rows: const ['one'],
            columns: [
              RemixDataTableColumn<String>(
                id: 'value',
                header: _InitCounter(() => inits++),
                semanticLabel: 'Value',
                sortable: true,
                cellBuilder: (context, row) => Text(row),
              ),
            ],
            onSortChanged: (_) {},
          ),
        ),
      );
      final focus8 = MixScope.tokenOf(
        FortalTokens.focus8,
        tester.element(find.byType(Pressable)),
      );
      expect(inits, 1);

      await focusWithKeyboard(tester);

      expect(_headerRings(tester), [focus8]);
      expect(inits, 1);

      FocusManager.instance.primaryFocus!.unfocus();
      await tester.pumpAndSettle();

      expect(_headerRings(tester), [_transparent]);
      expect(inits, 1);
    },
  );
}

RemixDataTableColumn<String> _column({bool sortable = false}) =>
    RemixDataTableColumn<String>(
      id: 'value',
      label: 'Value',
      sortable: sortable,
      cellBuilder: (context, row) => Text(row),
    );

/// The ring color of every header cell. Only a ring has a solid top side; a
/// row divider draws just its bottom edge.
List<Color> _headerRings(WidgetTester tester) => [
  for (final box in tester.widgetList<Box>(
    find.descendant(
      of: find.byType(RemixDataTable<String>),
      matching: find.byType(Box),
    ),
  ))
    if ((box.styleSpec?.spec.foregroundDecoration as BoxDecoration?)
        case BoxDecoration(border: final Border border))
      if (border.top.style == BorderStyle.solid) border.top.color,
];

class _InitCounter extends StatefulWidget {
  const _InitCounter(this.onInit);

  final VoidCallback onInit;

  @override
  State<_InitCounter> createState() => _InitCounterState();
}

class _InitCounterState extends State<_InitCounter> {
  @override
  void initState() {
    super.initState();
    widget.onInit();
  }

  @override
  Widget build(BuildContext context) => const Text('Value');
}
