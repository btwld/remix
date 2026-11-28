import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:registry_source/fortal.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('FortalButton recipe', () {
    test('defaults to solid variant and size2', () {
      expect(
        fortalButtonStyle(),
        equals(fortalButtonStyle(variant: .solid, size: .size2)),
      );
    });

    // Under the green accent, so a recipe that reads an accent token where
    // the look is neutral fails.
    const light = (
      ink: Color(0xFF0B0B0B),
      page: Color(0xFFFFFFFF),
      muted: Color(0xFFF8F8F8),
      border: Color(0xFFE9E9E9),
      secondary: Color(0xFF585858),
    );
    final looks = {
      FortalButtonVariant.solid: (
        fill: light.ink,
        label: light.page,
        frame: null,
      ),
      FortalButtonVariant.soft: (
        fill: light.muted,
        label: light.ink,
        frame: null,
      ),
      FortalButtonVariant.surface: (
        fill: light.page,
        label: light.ink,
        frame: light.border,
      ),
      FortalButtonVariant.outline: (
        fill: const Color(0x00000000),
        label: light.ink,
        frame: light.border,
      ),
      FortalButtonVariant.ghost: (
        fill: const Color(0x00000000),
        label: light.secondary,
        frame: null,
      ),
    };

    for (final MapEntry(key: variant, value: look) in looks.entries) {
      testWidgets('$variant draws its neutral look under any accent', (
        tester,
      ) async {
        final resolved = await _resolveFortalButtonStyle(
          tester,
          fortalButtonStyle(variant: variant),
        );

        final box = resolved.spec.container.spec.box!.spec;
        expect((box.decoration as BoxDecoration?)?.color, look.fill);
        expect(resolved.spec.label.spec.style!.color, look.label);
        final effects = resolved.spec.containerEffects?.behindContent;
        if (look.frame case final frame?) {
          expect(effects!.shadows.single.color, frame);
          expect(effects.shadows.single.spreadRadius, 1);
        } else {
          expect(effects, isNull);
        }
      });
    }

    testWidgets('surface takes the dark surface fill and border', (
      tester,
    ) async {
      final resolved = await resolveInFortalTheme(
        tester,
        (context) => fortalButtonStyle(variant: .surface).resolve(context),
        mode: .dark,
      );

      final box = resolved.spec.container.spec.box!.spec;
      expect(
        (box.decoration as BoxDecoration?)?.color,
        const Color(0xFF191919),
      );
      expect(
        resolved.spec.containerEffects!.behindContent!.shadows.single.color,
        const Color(0xFF2B2B2B),
      );
      expect(resolved.spec.label.spec.style!.color, const Color(0xFFF2F2F2));
    });

    testWidgets('each size resolves its height, padding and corner', (
      tester,
    ) async {
      // Side padding is the inline space plus the 1px frame painted inside it.
      const expected = {
        FortalButtonSize.size1: (height: 32.0, inline: 13.0, corner: 12.0),
        FortalButtonSize.size2: (height: 40.0, inline: 17.0, corner: 14.0),
        FortalButtonSize.size3: (height: 44.0, inline: 19.0, corner: 16.0),
        FortalButtonSize.size4: (height: 48.0, inline: 21.0, corner: 16.0),
      };

      for (final MapEntry(key: size, value: metrics) in expected.entries) {
        final resolved = await _resolveFortalButtonStyle(
          tester,
          fortalButtonStyle(size: size),
        );
        final box = resolved.spec.container.spec.box!.spec;

        expect(box.constraints!.minHeight, metrics.height, reason: '$size');
        expect(
          box.padding,
          EdgeInsets.symmetric(horizontal: metrics.inline),
          reason: '$size',
        );
        expect(
          (box.decoration as BoxDecoration).borderRadius,
          BorderRadius.all(Radius.circular(metrics.corner)),
          reason: '$size',
        );
        expect(resolved.spec.container.spec.flex!.spec.spacing, 8);
        expect(resolved.spec.label.spec.style!.fontSize, 13);
        expect(resolved.spec.label.spec.style!.fontWeight, FontWeight.w500);
        expect(resolved.spec.icon.spec.size, 16);
      }
    });
  });
}

Future<StyleSpec<ButtonSpec>> _resolveFortalButtonStyle(
  WidgetTester tester,
  ButtonStyler style,
) async {
  late final StyleSpec<ButtonSpec> resolved;

  await tester.pumpRemixApp(
    Builder(
      builder: (context) {
        resolved = style.resolve(context);

        return const SizedBox.shrink();
      },
    ),
  );

  return resolved;
}
