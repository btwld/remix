import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:registry_source/fortal.dart';

import '../../helpers/test_helpers.dart';

void main() {
  testWidgets('disabled fades the whole control to 50% and keeps its colors', (
    tester,
  ) async {
    for (final variant in FortalCheckboxVariant.values) {
      for (final selected in [false, true]) {
        Future<StyleSpec<CheckboxSpec>> resolve(Set<WidgetState> states) =>
            resolveInFortalTheme(
              tester,
              (context) =>
                  fortalCheckboxStyle(variant: variant).build(context),
              states: {if (selected) WidgetState.selected, ...states},
            );
        final enabled = await resolve({});
        final disabled = await resolve({WidgetState.disabled});
        final reason = '$variant/$selected';

        expect(
          disabled.spec.container.spec.decoration,
          enabled.spec.container.spec.decoration,
          reason: reason,
        );
        expect(
          disabled.widgetModifiers?.whereType<OpacityModifier>().single.opacity,
          0.5,
          reason: reason,
        );
        expect(
          enabled.widgetModifiers?.whereType<OpacityModifier>(),
          anyOf(isNull, isEmpty),
          reason: reason,
        );
      }
    }
  });
}
