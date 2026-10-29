import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/heroui/components/alert.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

const _glyph = IconData(0xe5cf);

String _id(HeroUiAlertStatus status) =>
    status == .defaultStatus ? 'default' : status.name;

/// RemixCallout holds one line of text, so the title-only `-short-` fixtures
/// are the upstream counterpart.
Widget _alert({
  HeroUiAlertStatus status = .defaultStatus,
  CalloutStyler style = const CalloutStyler.create(),
  int width = 1024,
}) => SizedBox(
  width: heroUiCase('alert-default-short-root', width: width).size.width,
  child: HeroUiAlert(
    status: status,
    style: style,
    icon: _glyph,
    text: 'Heads up',
  ),
);

CalloutSpec _spec(WidgetTester tester) =>
    tester.resolvedSpecOf<CalloutSpec>(find.text('Heads up'));

BoxDecoration _box(CalloutSpec spec) =>
    spec.container.spec.boxSpec.decoration! as BoxDecoration;

void main() {
  test('statuses follow HeroUI', () {
    expect(HeroUiAlertStatus.values.map((status) => status.name), [
      'defaultStatus',
      'accent',
      'success',
      'warning',
      'danger',
    ]);
  });

  for (final mode in ['light', 'dark']) {
    testWidgets('the surface follows alert.css in $mode', (tester) async {
      await tester.pumpHeroUi(_alert(), mode: mode);
      await tester.pumpAndSettle();
      final spec = _spec(tester);
      final root = heroUiCase('alert-default-short-root', mode: mode);

      // bg-surface, px-4 py-3, gap-4, shadow-surface, min(32px, radius-3xl);
      // a title-only alert is 48 high.
      expect(tester.getSize(find.byType(RemixCallout)), root.size);
      expectCssColor(_box(spec).color!, root.styles['backgroundColor']!);
      expect(
        _box(spec).borderRadius,
        BorderRadius.circular(root.px('borderRadius')),
      );
      expect(
        spec.container.spec.boxSpec.padding,
        EdgeInsets.fromLTRB(
          root.px('paddingLeft'),
          root.px('paddingTop'),
          root.px('paddingRight'),
          root.px('paddingBottom'),
        ),
      );
      expect(spec.container.spec.flex!.spec.spacing, root.px('gap'));
      expect(
        behindShadows(spec.containerEffects),
        cssRemixShadows(root.styles['boxShadow'] ?? ''),
      );
    });

    testWidgets('the indicator is a size-4 icon with p-1 around it in $mode', (
      tester,
    ) async {
      await tester.pumpHeroUi(_alert(), mode: mode);
      await tester.pumpAndSettle();
      final icon = heroUiCase('alert-default-short-icon', mode: mode);
      final indicator = heroUiCase('alert-default-short-indicator', mode: mode);
      expect(_spec(tester).icon.spec.size, icon.size.width);
      expect(tester.getSize(find.byType(StyledIcon)), indicator.size);
    });

    testWidgets('the title is text-sm, 24px leading, medium in $mode', (
      tester,
    ) async {
      await tester.pumpHeroUi(_alert(), mode: mode);
      await tester.pumpAndSettle();
      final upstream = heroUiCase('alert-default-short-title', mode: mode);
      final title = _spec(tester).text.spec.style!;
      expect(title.fontSize, upstream.px('fontSize'));
      expect(
        title.fontSize! * title.height!,
        closeTo(upstream.px('lineHeight'), .01),
      );
      expect(title.fontWeight, FontWeight.w500);
      expect(
        tester.getSize(find.text('Heads up')).height,
        upstream.size.height,
      );
    });

    testWidgets('statuses color the title and the indicator in $mode', (
      tester,
    ) async {
      for (final status in HeroUiAlertStatus.values) {
        await tester.pumpHeroUi(_alert(status: status), mode: mode);
        await tester.pumpAndSettle();
        final spec = _spec(tester);
        final title = heroUiCase(
          'alert-${_id(status)}-short-title',
          mode: mode,
        );
        final icon = heroUiCase('alert-${_id(status)}-short-icon', mode: mode);
        expectCssColor(
          spec.text.spec.style!.color!,
          title.styles['color']!,
          reason: '${status.name} title',
        );
        expectCssColor(
          spec.icon.spec.color!,
          icon.styles['color']!,
          reason: '${status.name} icon',
        );
      }
    });
  }

  testWidgets('the alert spans its column at 375px', (tester) async {
    final root = heroUiCase('alert-default-short-root', width: 375);
    await tester.pumpHeroUi(_alert(width: 375), width: 375);
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(RemixCallout)), root.size);
  });

  testWidgets('a caller style wins over the recipe', (tester) async {
    const override = Color(0xFF00FF00);
    await tester.pumpHeroUi(_alert(style: CalloutStyler().color(override)));
    await tester.pumpAndSettle();
    expect(_box(_spec(tester)).color, override);
  });
}
