import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// `RemixBoxAdapter` is `@internal` to `remix`, but this sibling package's
// tests need it to measure how a Remix component renders a Fortal recipe.
// Suppressed per-use below, so a future accidental internal-member use still
// gets flagged.
import 'package:remix/src/rendering/remix_box_effects.dart';
import 'package:registry_source/fortal.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('Fortal labeled checkbox', () {
    testWidgets('preserves each visual square inside a 48 target', (
      tester,
    ) async {
      const expectedVisualSizes = <FortalCheckboxSize, double>{
        FortalCheckboxSize.size1: 14,
        FortalCheckboxSize.size2: 18,
        FortalCheckboxSize.size3: 20,
      };

      for (final entry in expectedVisualSizes.entries) {
        await tester.pumpRemixApp(
          FortalCheckbox(
            key: ValueKey(entry.key),
            size: entry.key,
            selected: false,
            label: 'Receive updates',
            onChanged: (_) {},
          ),
        );

        expect(
          tester.getSize(find.byType(FortalCheckbox)).height,
          greaterThanOrEqualTo(48),
          reason: entry.key.name,
        );
        expect(
          // ignore: invalid_use_of_internal_member
          tester.getSize(find.byType(RemixBoxAdapter)),
          Size.square(entry.value),
          reason: entry.key.name,
        );
      }
    });

    testWidgets('draws the fill and mark over the whole square', (
      tester,
    ) async {
      const sides = <FortalCheckboxSize, double>{
        FortalCheckboxSize.size1: 14,
        FortalCheckboxSize.size2: 18,
        FortalCheckboxSize.size3: 20,
      };

      for (final entry in sides.entries) {
        await tester.pumpRemixApp(
          FortalCheckbox(
            key: ValueKey(entry.key),
            size: entry.key,
            selected: true,
            onChanged: (_) {},
          ),
        );
        await tester.pumpAndSettle();

        expect(
          tester.getSize(_mark()),
          Size.square(entry.value),
          reason: entry.key.name,
        );
        expect(_painter(tester).on, 1, reason: entry.key.name);
        expect(_painter(tester).opacity, 1, reason: entry.key.name);
      }
    });

    testWidgets('springs the fill in and draws the check on, then morphs', (
      tester,
    ) async {
      Widget checkbox(bool? selected) => FortalCheckbox(
        selected: selected,
        tristate: true,
        onChanged: (_) {},
      );

      await tester.pumpRemixApp(checkbox(false));
      expect(_painter(tester).opacity, 0);

      await tester.pumpRemixApp(checkbox(true));
      await tester.pump(const Duration(milliseconds: 50));
      final early = _painter(tester);
      expect(early.on, inExclusiveRange(0, 1), reason: 'fill scale and draw');
      expect(early.dash, 0);
      await tester.pumpAndSettle();
      expect(_painter(tester).on, 1);

      await tester.pumpRemixApp(checkbox(null));
      await tester.pump(const Duration(milliseconds: 100));
      expect(_painter(tester).dash, inExclusiveRange(0, 1), reason: 'morph');
      await tester.pumpAndSettle();
      expect(_painter(tester).dash, 1);

      await tester.pumpRemixApp(checkbox(false));
      await tester.pumpAndSettle();
      expect(_painter(tester).opacity, 0);
      expect(_painter(tester).dash, 1, reason: 'leaves as the shape it had');
    });

    testWidgets('jumps under reduced motion', (tester) async {
      Widget checkbox(bool selected) => MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: FortalCheckbox(selected: selected, onChanged: (_) {}),
      );

      await tester.pumpRemixApp(checkbox(false));
      await tester.pumpRemixApp(checkbox(true));
      await tester.pump();
      expect(_painter(tester).on, 1);
      expect(_painter(tester).opacity, 1);
    });

    test('generated wrapper forwards label and minimum target size', () {
      const checkbox = FortalCheckbox.surface(
        selected: false,
        label: 'Receive updates',
        minimumTapTargetSize: Size.zero,
      );

      expect(checkbox.label, 'Receive updates');
      expect(checkbox.minimumTapTargetSize, Size.zero);
    });
  });
}

Finder _mark() => find.descendant(
  of: find.byType(FortalCheckbox),
  matching: find.byWidgetPredicate(
    (widget) => widget is CustomPaint && widget.painter != null,
  ),
);

/// The private mark painter's fields: fill scale and draw progress, opacity,
/// and check-to-dash morph.
({double on, double opacity, double dash}) _painter(WidgetTester tester) {
  final dynamic painter = tester.widget<CustomPaint>(_mark()).painter;

  return (
    on: painter.on as double,
    opacity: painter.opacity as double,
    dash: painter.dash as double,
  );
}
