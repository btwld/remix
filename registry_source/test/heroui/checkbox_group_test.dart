import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/heroui.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

const _first = 'Alpha';
const _second = 'Beta';
const _error = 'Pick at least one.';
const _modes = ['light', 'dark'];

Widget _group({
  Set<String> values = const {'a'},
  HeroUiCheckboxVariant variant = .primary,
  bool invalid = false,
  bool enabled = true,
  String? errorText,
  ValueChanged<Set<String>>? onChanged,
}) => SizedBox(
  width: 400,
  child: HeroUiCheckboxGroup<String>(
    values: values,
    variant: variant,
    invalid: invalid,
    enabled: enabled,
    onChanged: onChanged ?? (_) {},
    label: 'Choose boxes',
    helperText: 'Group help',
    errorText: errorText,
    options: const [
      HeroUiCheckboxOption(value: 'a', label: _first),
      HeroUiCheckboxOption(value: 'b', label: _second),
    ],
  ),
);

Future<void> _pump(
  WidgetTester tester,
  Widget group, {
  String mode = 'light',
}) async {
  await tester.pumpHeroUi(group, mode: mode);
  await tester.pumpAndSettle();
}

CheckboxSpec _spec(WidgetTester tester, String label) =>
    tester.resolvedSpecOf<CheckboxSpec>(find.text(label));

Color? _fill(CheckboxSpec spec) =>
    (spec.container.spec.decoration as BoxDecoration?)?.color;

TextStyle _style(WidgetTester tester, String text) =>
    tester.widget<Text>(find.text(text)).style!;

void main() {
  for (final mode in _modes) {
    for (final variant in HeroUiCheckboxVariant.values) {
      testWidgets('${variant.name} items match upstream in $mode', (
        tester,
      ) async {
        await _pump(tester, _group(variant: variant), mode: mode);
        final selected = heroUiCase(
          'checkbox-group-${variant.name}-a-control',
          mode: mode,
        );
        final label = heroUiCase(
          'checkbox-group-${variant.name}-a-label',
          mode: mode,
        );
        final content = heroUiCase(
          'checkbox-group-${variant.name}-a-content',
          mode: mode,
        );
        final rest = heroUiCase(
          'checkbox-${variant.name}-rest-control',
          mode: mode,
        );

        final a = _spec(tester, _first);
        final b = _spec(tester, _second);
        expect(
          a.container.spec.constraints,
          BoxConstraints.tight(selected.size),
        );
        expect(
          (a.container.spec.decoration as BoxDecoration).borderRadius,
          BorderRadius.circular(selected.px('borderRadius')),
        );
        // The checked box is `accent`: the capture of a selected control
        // reports the field fill (see checkbox_test.dart).
        expect(_fill(a), heroUiToken(HeroUiTokens.accent, mode));
        expectCssColor(
          _fill(b)!,
          rest.styles['backgroundColor']!,
          reason: 'unselected fill',
        );
        final style = a.label.spec.style!;
        expect(style.fontSize, label.px('fontSize'));
        expect(style.fontSize! * style.height!, label.px('lineHeight'));
        expect(style.fontWeight, FontWeight.w500);
        expectCssColor(style.color!, label.styles['color']!, reason: 'label');
        expect(a.labelSpacing, content.px('gap'));
      });
    }
  }

  testWidgets('the label, options, and description stack as in the CSS', (
    tester,
  ) async {
    await _pump(tester, _group());
    final label = tester.getRect(find.text('Choose boxes'));
    final first = tester.getRect(
      find.byType(HeroUiCheckboxGroupItem<String>).first,
    );
    final second = tester.getRect(
      find.byType(HeroUiCheckboxGroupItem<String>).last,
    );
    final help = tester.getRect(find.text('Group help'));
    // Every option has `mt-4`: after the label and after the previous option.
    const marginTop = 16.0;
    expect(first.top - label.bottom, marginTop);
    expect(second.top - first.bottom, marginTop);
    expect(help.top - second.bottom, 0);
    // Each option is the 24px touch target; upstream's content row is 20.
    expect(first.height, 24);
    expect(first.left, label.left);
  });

  testWidgets('horizontal options flow beside the label and wrap', (
    tester,
  ) async {
    const group = HeroUiCheckboxGroup<String>(
      orientation: Axis.horizontal,
      values: {'a'},
      label: 'Options',
      options: [
        HeroUiCheckboxOption(value: 'a', label: _first),
        HeroUiCheckboxOption(value: 'b', label: _second),
      ],
    );
    await _pump(tester, group);
    final label = find.text('Options');
    final items = find.byType(HeroUiCheckboxGroupItem<String>);
    final first = tester.getRect(items.first);
    final second = tester.getRect(items.last);
    expect(first.left - tester.getRect(label).right, 16);
    expect(second.left - first.right, 16);
    expect(second.top, first.top);

    final width = second.right - tester.getRect(label).left - 1;
    await _pump(tester, SizedBox(width: width, child: group));
    final firstInRow = tester.getRect(items.first);
    final wrapped = tester.getRect(items.last);
    expect(firstInRow.top, tester.getTopLeft(label).dy);
    expect(wrapped.left, tester.getTopLeft(label).dx);
    expect(wrapped.top - firstInRow.bottom, 16);
  });

  testWidgets('horizontal Tab traversal skips disabled options', (
    tester,
  ) async {
    final after = FocusNode();
    addTearDown(after.dispose);
    var values = {'a'};
    final changes = <Set<String>>[];
    await _pump(
      tester,
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StatefulBuilder(
            builder: (context, setState) => HeroUiCheckboxGroup<String>(
              orientation: Axis.horizontal,
              values: values,
              onChanged: (next) => setState(() {
                changes.add(next);
                values = next;
              }),
              options: const [
                HeroUiCheckboxOption(value: 'a', label: _first),
                HeroUiCheckboxOption(
                  value: 'disabled',
                  label: 'Unavailable',
                  enabled: false,
                ),
                HeroUiCheckboxOption(value: 'b', label: _second),
              ],
            ),
          ),
          Focus(focusNode: after, child: const SizedBox(width: 24, height: 24)),
        ],
      ),
    );
    final first = find.semantics.byLabel(_first);
    final second = find.semantics.byLabel(_second);
    await tester.focusWithTab();
    expect(
      first.evaluate().single,
      isSemantics(isFocused: true, isChecked: true),
    );
    await tester.focusWithTab();
    expect(
      second.evaluate().single,
      isSemantics(isFocused: true, isChecked: false),
    );
    expect(changes, isEmpty);

    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();
    expect(changes, [
      <String>{'a', 'b'},
    ]);
    expect(
      second.evaluate().single,
      isSemantics(isFocused: true, isChecked: true),
    );

    await tester.focusWithTab();
    expect(after.hasPrimaryFocus, isTrue);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    await tester.focusWithTab();
    expect(second.evaluate().single, isSemantics(isFocused: true));
    await tester.focusWithTab();
    await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    expect(first.evaluate().single, isSemantics(isFocused: true));
    expect(changes, hasLength(1));
  });

  testWidgets('toggling options updates the controlled set through Remix', (
    tester,
  ) async {
    var values = {'a'};
    await _pump(
      tester,
      StatefulBuilder(
        builder: (context, setState) => _group(
          values: values,
          onChanged: (next) => setState(() => values = next),
        ),
      ),
    );
    await tester.tap(find.text(_second));
    await tester.pumpAndSettle();
    expect(values, {'a', 'b'});
    expect(_fill(_spec(tester, _second)), heroUiToken(HeroUiTokens.accent));
    await tester.tap(find.text(_first));
    await tester.pumpAndSettle();
    expect(values, {'b'});
  });

  for (final mode in _modes) {
    testWidgets('invalid colors the labels and the error, and keeps the '
        'description in $mode', (tester) async {
      await _pump(tester, _group(invalid: true, errorText: _error), mode: mode);
      final label = heroUiCase('checkbox-primary-invalid-label', mode: mode);
      final description = heroUiCase(
        'checkbox-primary-rest-description',
        mode: mode,
      );
      // `.field-error` is the same `danger` as an invalid label.
      final fieldError = heroUiCase(
        'search-primary-intrinsic-invalid-error',
        mode: mode,
      );
      expectCssColor(
        _spec(tester, _first).label.spec.style!.color!,
        label.styles['color']!,
        reason: 'option',
      );
      expectCssColor(
        _style(tester, 'Choose boxes').color!,
        label.styles['color']!,
        reason: 'group label',
      );
      // Unlike a text field, a group keeps its description beside the error.
      expectCssColor(
        _style(tester, 'Group help').color!,
        description.styles['color']!,
        reason: 'description',
      );
      final error = _style(tester, _error);
      expectCssColor(
        error.color!,
        fieldError.styles['color']!,
        reason: 'error',
      );
      expect(error.fontSize, fieldError.px('fontSize'));
      expect(error.fontSize! * error.height!, fieldError.px('lineHeight'));
      final insets = tester
          .widgetList<Padding>(
            find.ancestor(
              of: find.text(_error),
              matching: find.byType(Padding),
            ),
          )
          .map((padding) => padding.padding);
      expect(
        insets,
        contains(
          EdgeInsets.symmetric(horizontal: fieldError.px('paddingLeft')),
        ),
      );
      // The error follows the description.
      expect(
        tester.getRect(find.text(_error)).top,
        greaterThanOrEqualTo(tester.getRect(find.text('Group help')).bottom),
      );
    });
  }

  testWidgets('the error shows only while invalid', (tester) async {
    await _pump(tester, _group(errorText: _error));
    expect(find.text(_error), findsNothing);
    expect(find.text('Group help'), findsOneWidget);
  });

  for (final mode in _modes) {
    testWidgets('disabled options dim, and cannot be toggled in $mode', (
      tester,
    ) async {
      Set<String>? values;
      await _pump(
        tester,
        _group(enabled: false, onChanged: (next) => values = next),
        mode: mode,
      );
      final root = heroUiCase('checkbox-primary-disabled', mode: mode);
      expect(
        tester.opacityAbove(find.text(_first)),
        double.parse(root.styles['opacity']!),
      );
      await tester.tap(find.text(_second));
      expect(values, isNull);
    });
  }

  testWidgets('a caller style wins over the recipe', (tester) async {
    const override = Color(0xFF00FF00);
    await tester.pumpHeroUi(
      RemixCheckboxGroup<String>(
        values: const {},
        onChanged: (_) {},
        child: HeroUiCheckboxGroupItem<String>(
          value: 'a',
          label: _first,
          style: CheckboxStyler().color(override),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(_fill(_spec(tester, _first)), override);
  });
}
