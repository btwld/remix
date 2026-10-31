import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:registry_source/src/fortal/recipes/dashboard/dashboard_demo_theme.dart';
import 'package:registry_source/src/fortal/recipes/dashboard/dashboard_demo_widgets.dart';

/// Dashboard statuses keep a text label; color only reinforces it. Negative
/// statuses and destructive actions use the dedicated error red, never the
/// orange Caju accent, even inside a Caju-accented scope.
void main() {
  Future<FortalColor> resolvedAccent(
    WidgetTester tester,
    Widget child, {
    required bool dark,
  }) async {
    await tester.pumpWidget(
      FortalTheme(
        accent: .caju,
        mode: dark ? .dark : .light,
        child: Directionality(
          textDirection: .ltr,
          child: Center(child: child),
        ),
      ),
    );
    final badge = tester.element(find.byType(FortalBadge));
    return resolveFortalTokens(FortalTheme.of(badge)).accent;
  }

  for (final dark in [false, true]) {
    final mode = dark ? 'dark' : 'light';
    FortalColor scheme(FortalColorTheme theme) =>
        dark ? theme.dark : theme.light;

    testWidgets('$mode: status badges map to their semantic palettes', (
      tester,
    ) async {
      final cases = <(Widget, String, FortalColorTheme)>[
        (FortalStatusBadge.order(.paid), 'Paid', serra),
        (FortalStatusBadge.order(.pending), 'Pending', sol),
        (FortalStatusBadge.order(.refunded), 'Refunded', fortalError),
        (FortalStatusBadge.order(.cancelled), 'Cancelled', calcadao),
        (FortalStatusBadge.customer(.active), 'Active', serra),
        (FortalStatusBadge.customer(.invited), 'Invited', ceu),
        (FortalStatusBadge.customer(.suspended), 'Suspended', fortalError),
        (FortalStatusBadge.label(' Fulfilled '), 'Fulfilled', serra),
        (FortalStatusBadge.label('suspended'), 'Suspended', fortalError),
      ];
      for (final (badge, label, palette) in cases) {
        final accent = await resolvedAccent(tester, badge, dark: dark);
        expect(find.text(label), findsOneWidget, reason: label);
        expect(
          accent.scale.step(9),
          scheme(palette).scale.step(9),
          reason: '$label palette',
        );
      }
    });

    testWidgets('$mode: the error scope overrides an inherited Caju accent', (
      tester,
    ) async {
      final accent = await resolvedAccent(
        tester,
        const FortalAccentScope.error(child: FortalBadge(label: 'Delete')),
        dark: dark,
      );
      expect(accent.scale.step(9), scheme(fortalError).scale.step(9));
      expect(accent.scale.step(9), isNot(scheme(caju).scale.step(9)));
    });
  }
}
