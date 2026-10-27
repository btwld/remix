import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:remix/remix.dart';

import '../../helpers/pixels.dart';
import '../../helpers/test_helpers.dart';

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
        'only the focused sortable ${variant.name} header rings in focus-8 on '
        'all four sides in ${mode.name}',
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
                        columns: [
                          _column(id: 'first', sortable: true),
                          _column(id: 'second', sortable: true),
                        ],
                        onSortChanged: (_) {},
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
          final headers = find.byType(Pressable);
          final focusedCell = tester.getRect(headers.first);
          final otherCell = tester.getRect(headers.last);
          final idle = await capturePixels(tester, boundary);

          await focusWithKeyboard(tester);
          final focused = await capturePixels(tester, boundary);
          final focus8 = MixScope.tokenOf(
            FortalTokens.focus8,
            tester.element(headers.first),
          );

          final origin = tester.getTopLeft(find.byKey(boundary));
          Color pixel(Pixels pixels, Offset logical) {
            final device = (logical - origin) * pixelScale.toDouble();
            return pixels.at(device.dx.round(), device.dy.round());
          }

          // Each probe is the middle of an edge, `inside` logical pixels in
          // from it. The 2px ring covers 1; the cell past the ring starts at 3.
          List<Offset Function(double inside)> edges(Rect cell) => [
            (inside) => Offset(cell.center.dx, cell.top + inside),
            (inside) => Offset(cell.center.dx, cell.bottom - inside),
            (inside) => Offset(cell.left + inside, cell.center.dy),
            (inside) => Offset(cell.right - inside, cell.center.dy),
          ];

          for (final at in edges(focusedCell)) {
            expectNearColor(pixel(focused, at(1)), focus8);
            expectNearColor(pixel(focused, at(3)), pixel(idle, at(3)));
          }
          // The neighbouring sortable header is not the focused one.
          for (final at in edges(otherCell)) {
            expectNearColor(pixel(focused, at(1)), pixel(idle, at(1)));
          }
          expect(tester.getRect(headers.first), focusedCell);
        },
      );
    }
  }

  testWidgets('the ring follows the focus ring width token', (tester) async {
    for (final width in [2.0, 3.5]) {
      await tester.pumpRemixApp(
        MixScope.inherit(
          spaces: {FortalTokens.focusRingWidth: width},
          child: SizedBox(
            width: 400,
            child: FortalDataTable<String>(
              rows: const ['one'],
              columns: [_column(sortable: true)],
              onSortChanged: (_) {},
            ),
          ),
        ),
      );

      await focusWithKeyboard(tester);

      expect(_headerRings(tester).map((side) => side.width), [width]);
    }
  });

  testWidgets('a zero-width ring draws nothing and keeps the divider', (
    tester,
  ) async {
    final boundary = GlobalKey();
    await tester.pumpRemixApp(
      MixScope.inherit(
        spaces: {FortalTokens.focusRingWidth: 0},
        child: RepaintBoundary(
          key: boundary,
          child: ColoredBox(
            color: const Color(0xFFFFFFFF),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: 400,
                child: FortalDataTable<String>(
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
    final cell = tester.getRect(find.byType(Pressable));
    final idle = await capturePixels(tester, boundary);

    await focusWithKeyboard(tester);
    final focused = await capturePixels(tester, boundary);

    expect(_headerRings(tester), isEmpty);
    final origin = tester.getTopLeft(find.byKey(boundary));
    for (final at in [
      Offset(cell.center.dx, cell.top + 0.5),
      Offset(cell.center.dx, cell.bottom - 0.5),
      Offset(cell.left + 0.5, cell.center.dy),
      Offset(cell.right - 0.5, cell.center.dy),
    ]) {
      final device = (at - origin) * pixelScale.toDouble();
      expectNearColor(
        focused.at(device.dx.round(), device.dy.round()),
        idle.at(device.dx.round(), device.dy.round()),
      );
    }
  });

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

      await focusWithKeyboard(tester);

      expect(host.hasPrimaryFocus, isTrue);
      expect(_headerRings(tester), isEmpty);
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

      await focusWithKeyboard(tester);

      expect(host.hasPrimaryFocus, isTrue);
      expect(_headerRings(tester), isEmpty);
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
      expect(inits, 1);

      await focusWithKeyboard(tester);

      expect(_headerRings(tester), hasLength(1));
      expect(inits, 1);

      FocusManager.instance.primaryFocus!.unfocus();
      await tester.pumpAndSettle();

      expect(_headerRings(tester), isEmpty);
      expect(inits, 1);
    },
  );
}

RemixDataTableColumn<String> _column({
  String id = 'value',
  bool sortable = false,
}) => RemixDataTableColumn<String>(
  id: id,
  label: 'Value $id',
  sortable: sortable,
  cellBuilder: (context, row) => Text(row),
);

/// The ring of every header cell. Only a ring has a solid top side; the row
/// divider draws just its bottom edge.
List<BorderSide> _headerRings(WidgetTester tester) => [
  for (final box in tester.widgetList<Box>(
    find.descendant(
      of: find.byType(RemixDataTable<String>),
      matching: find.byType(Box),
    ),
  ))
    if ((box.styleSpec?.spec.foregroundDecoration as BoxDecoration?)
        case BoxDecoration(border: final Border border))
      if (border.top.style == BorderStyle.solid) border.top,
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
