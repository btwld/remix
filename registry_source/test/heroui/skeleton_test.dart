import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/heroui/components/skeleton.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

/// The fixture's 120 x 24 placeholder.
Widget _skeleton({SkeletonStyler style = const SkeletonStyler.create()}) =>
    SizedBox(width: 120, height: 24, child: HeroUiSkeleton(style: style));

final _surface = find.descendant(
  of: find.byType(HeroUiSkeleton),
  matching: find.byType(Container),
);

Future<SkeletonSpec> _pump(
  WidgetTester tester, {
  String mode = 'light',
  SkeletonStyler style = const SkeletonStyler.create(),
}) async {
  await tester.pumpHeroUi(_skeleton(style: style), mode: mode);
  // The pulse never settles.
  await tester.pump(const Duration(milliseconds: 16));
  return tester.resolvedSpecOf<SkeletonSpec>(_surface.first);
}

void main() {
  for (final mode in ['light', 'dark']) {
    testWidgets('matches upstream in $mode', (tester) async {
      final spec = await _pump(tester, mode: mode);
      final upstream = heroUiCase('skeleton-pulse', mode: mode);

      expect(tester.getSize(find.byType(HeroUiSkeleton)), upstream.size);
      final decoration = spec.container.spec.decoration! as BoxDecoration;
      expect(
        decoration.borderRadius,
        BorderRadius.circular(upstream.px('borderRadius')),
      );
      // `bg-surface-tertiary/70`
      expectCssColor(decoration.color!, upstream.styles['backgroundColor']!);
    });
  }

  testWidgets('pulses to half opacity and back, like animate-pulse', (
    tester,
  ) async {
    final spec = await _pump(tester);
    // `pulse 2s`: a leg of 1s down to opacity .5 at the 50% keyframe.
    expect(spec.duration, const Duration(seconds: 1));
    expect(tester.opacityAbove(_surface.first), closeTo(1, .02));
    await tester.pump(const Duration(seconds: 1));
    expect(tester.opacityAbove(_surface.first), closeTo(.5, .02));
    await tester.pump(const Duration(seconds: 1));
    expect(tester.opacityAbove(_surface.first), closeTo(1, .02));
  });

  testWidgets('a caller style wins over the recipe', (tester) async {
    const override = Color(0xFF00FF00);
    final spec = await _pump(
      tester,
      style: SkeletonStyler().container(BoxStyler().color(override)),
    );
    expect((spec.container.spec.decoration! as BoxDecoration).color, override);
  });
}
