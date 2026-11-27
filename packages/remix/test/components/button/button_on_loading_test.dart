import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

const _idle = Color(0xFF000001);
const _disabled = Color(0xFF000002);
const _loading = Color(0xFF000003);

Color? _labelColor(WidgetTester tester) =>
    tester.widget<Text>(find.text('Save')).style?.color;

ButtonStyler _style({bool withOnLoading = true}) {
  var style = ButtonStyler()
      .label(TextStyler().color(_idle))
      .onDisabled(ButtonStyler().label(TextStyler().color(_disabled)));
  if (withOnLoading) {
    style = style.onLoading(ButtonStyler().label(TextStyler().color(_loading)));
  }
  return style;
}

void main() {
  testWidgets('without onLoading a loading button looks disabled', (
    tester,
  ) async {
    await tester.pumpRemixApp(
      RemixButton(
        label: 'Save',
        loading: true,
        onPressed: () {},
        style: _style(withOnLoading: false),
      ),
    );
    expect(_labelColor(tester), _disabled);
  });

  testWidgets('onLoading declared after onDisabled wins while loading', (
    tester,
  ) async {
    await tester.pumpRemixApp(
      RemixButton(
        label: 'Save',
        loading: true,
        onPressed: () {},
        style: _style(),
      ),
    );
    expect(_labelColor(tester), _loading);
  });

  testWidgets('onLoading does not apply to a disabled idle button', (
    tester,
  ) async {
    await tester.pumpRemixApp(
      RemixButton(label: 'Save', enabled: false, style: _style()),
    );
    expect(_labelColor(tester), _disabled);
  });

  testWidgets('onLoading follows loading as it toggles', (tester) async {
    final loading = ValueNotifier(false);
    addTearDown(loading.dispose);
    await tester.pumpRemixApp(
      ValueListenableBuilder<bool>(
        valueListenable: loading,
        builder: (context, isLoading, _) => RemixButton(
          label: 'Save',
          loading: isLoading,
          onPressed: () {},
          style: _style(),
        ),
      ),
    );
    expect(_labelColor(tester), _idle);

    loading.value = true;
    await tester.pump();
    expect(_labelColor(tester), _loading);

    loading.value = false;
    await tester.pump();
    expect(_labelColor(tester), _idle);
  });
}
