import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/carbon.dart';
import 'package:remix/remix.dart';

void main() {
  testWidgets('button activates and disabled/loading buttons suppress taps', (
    tester,
  ) async {
    var presses = 0;

    await tester.pumpWidget(
      _host(CarbideButton(label: 'Active', onPressed: () => presses++)),
    );
    await tester.tap(find.text('Active'));
    expect(presses, 1);

    await tester.pumpWidget(
      _host(
        CarbideButton(
          label: 'Disabled',
          enabled: false,
          onPressed: () => presses++,
        ),
      ),
    );
    await tester.tap(find.text('Disabled'), warnIfMissed: false);
    expect(presses, 1);

    await tester.pumpWidget(
      _host(
        CarbideButton(
          label: 'Loading',
          loading: true,
          onPressed: () => presses++,
        ),
      ),
    );
    await tester.tap(find.byType(CarbideButton), warnIfMissed: false);
    expect(presses, 1);
  });

  testWidgets('every kind renders at the fixed 48px initial height', (
    tester,
  ) async {
    for (final theme in CarbideTheme.values) {
      for (final kind in CarbideButtonKind.values) {
        await tester.pumpWidget(
          _host(
            CarbideButton(label: kind.name, kind: kind, onPressed: () {}),
            theme: theme,
          ),
        );
        await tester.pump();

        expect(
          tester.getSize(find.byType(CarbideButton)).height,
          48.0,
          reason: '$theme $kind',
        );
        expect(tester.takeException(), isNull, reason: '$theme $kind');
      }
    }
  });

  testWidgets('loading preserves primary fill while disabled uses gray', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(CarbideButton(label: 'Loading', loading: true, onPressed: () {})),
    );
    await tester.pump(const Duration(milliseconds: 100));
    expect(_backgroundColor(tester), const Color(0xFF0F62FE));

    await tester.pumpWidget(
      _host(const CarbideButton(label: 'Disabled', enabled: false)),
    );
    await tester.pump();
    expect(_backgroundColor(tester), const Color(0xFFC6C6C6));
  });

  testWidgets('focus-visible renders Carbon focus and inset layers', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        WidgetStateStyleOverride(
          states: const {WidgetState.focused},
          child: CarbideButton(label: 'Focused', onPressed: () {}),
        ),
      ),
    );
    await tester.pump();

    final decoration =
        tester
                .widgetList<DecoratedBox>(
                  find.descendant(
                    of: find.byType(CarbideButton),
                    matching: find.byType(DecoratedBox),
                  ),
                )
                .where((box) => box.position == DecorationPosition.foreground)
                .single
                .decoration
            as ShapeDecoration;
    expect(decoration.shape.dimensions, const EdgeInsets.all(3.0));
    expect(
      decoration.shape,
      const RoundedRectangleBorder(
            side: BorderSide(color: Color(0xFFFFFFFF), width: 1.0),
          ) +
          const RoundedRectangleBorder(
            side: BorderSide(color: Color(0xFF0F62FE), width: 2.0),
          ),
    );
  });
}

Widget _host(Widget child, {CarbideTheme theme = CarbideTheme.white}) =>
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: CarbideScope(theme: theme, child: child),
        ),
      ),
    );

Color? _backgroundColor(WidgetTester tester) => tester
    .widgetList<DecoratedBox>(
      find.descendant(
        of: find.byType(CarbideButton),
        matching: find.byType(DecoratedBox),
      ),
    )
    .where((box) => box.position == DecorationPosition.background)
    .map((box) => box.decoration)
    .whereType<BoxDecoration>()
    .firstWhere((decoration) => decoration.color != null)
    .color;
