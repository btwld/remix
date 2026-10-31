import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:remix/remix.dart';

import '../../helpers/pixels.dart';
import '../../helpers/test_helpers.dart';

/// Sortable headers use the shared token outline, measured from the cell's
/// padding so every edge remains visible inside a clipped table.
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
          final context = tester.element(headers.first);
          final focus8 = FortalTokens.focus8.resolve(context);
          final width = FortalTokens.focusRingWidth.resolve(context);
          final offset = FortalTokens.focusRingOffset.resolve(context);
          final inset = FortalTokens.space2.resolve(context);
          final outerInset = inset - offset - width;
          final paint = _headerRings(tester).single;
          final ringBounds = paint.localToGlobal(Offset.zero) & paint.size;

          final origin = tester.getTopLeft(find.byKey(boundary));
          Color pixel(Pixels pixels, Offset logical) {
            final device = (logical - origin) * pixelScale.toDouble();
            return pixels.at(device.dx.round(), device.dy.round());
          }

          // Probe the outline, its gap and the cell beyond its outer edge.
          List<Offset Function(double inside)> edges(Rect cell) => [
            (inside) => Offset(cell.center.dx, cell.top + inside),
            (inside) => Offset(cell.center.dx, cell.bottom - inside),
            (inside) => Offset(cell.left + inside, cell.center.dy),
            (inside) => Offset(cell.right - inside, cell.center.dy),
          ];

          for (final at in edges(ringBounds)) {
            expectNearColor(pixel(focused, at(outerInset + width / 2)), focus8);
            for (final distance in [outerInset - 0.5, inset - offset / 2]) {
              expectNearColor(
                pixel(focused, at(distance)),
                pixel(idle, at(distance)),
              );
            }
          }
          // The neighbouring sortable header is not the focused one.
          for (final at in edges(otherCell)) {
            final distance = outerInset + width / 2;
            expectNearColor(
              pixel(focused, at(distance)),
              pixel(idle, at(distance)),
            );
          }
          expect(tester.getRect(headers.first), focusedCell);
        },
      );
    }
  }

  testWidgets('the ring follows the shared width and offset tokens', (
    tester,
  ) async {
    for (final (width, offset) in [(2.0, 2.0), (3.5, 1.0)]) {
      await tester.pumpRemixApp(
        MixScope.inherit(
          spaces: {
            FortalTokens.focusRingWidth: width,
            FortalTokens.focusRingOffset: offset,
          },
          child: SizedBox(
            key: ValueKey((width, offset)),
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

      final paint = _headerRings(tester).single;
      final context = tester.element(find.byType(Pressable).first);
      final content = RRect.fromRectAndRadius(
        (Offset.zero & paint.size).deflate(
          FortalTokens.space2.resolve(context),
        ),
        FortalTokens.radius2.resolve(context),
      );
      expect(
        paint,
        paints..drrect(
          outer: content.inflate(offset + width),
          inner: content.inflate(offset),
          color: FortalTokens.focus8.resolve(context),
        ),
      );
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

/// Header outlines paint separately from the cell decoration and row divider.
List<RenderCustomPaint> _headerRings(WidgetTester tester) {
  final result = <RenderCustomPaint>[];
  for (final element
      in find
          .descendant(
            of: find.byWidgetPredicate((widget) => widget is Table),
            matching: find.byWidgetPredicate(
              (widget) =>
                  widget is CustomPaint && widget.foregroundPainter != null,
            ),
          )
          .evaluate()) {
    final paint = element.renderObject! as RenderCustomPaint;
    final state = <dynamic, dynamic>{};
    final matched = ((paints..drrect()) as Matcher).matches(
      (Canvas canvas) => paint.foregroundPainter!.paint(canvas, paint.size),
      state,
    );
    if (matched) result.add(paint);
  }
  return result;
}

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
