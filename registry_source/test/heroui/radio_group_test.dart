import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/heroui/components/field_layout.dart';
import 'package:registry_source/src/heroui/components/radio.dart';
import 'package:registry_source/src/heroui/components/radio_group.dart';
import 'package:registry_source/src/heroui/theme/theme.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

const _error = 'Pick one option.';
const _modes = ['light', 'dark'];

const _options = [
  HeroUiRadioOption(value: 'a', label: 'Alpha', description: 'Help text'),
  HeroUiRadioOption(value: 'b', label: 'Beta', description: 'Help text'),
  HeroUiRadioOption(value: 'c', label: 'Gamma', description: 'Help text'),
];

Widget _group({
  double width = 600,
  String? groupValue = 'a',
  Axis orientation = Axis.vertical,
  HeroUiRadioVariant variant = .primary,
  bool invalid = false,
  bool enabled = true,
  String? errorText,
  ValueChanged<String?>? onChanged,
}) => SizedBox(
  width: width,
  child: HeroUiRadioGroup<String>(
    groupValue: groupValue,
    orientation: orientation,
    variant: variant,
    invalid: invalid,
    enabled: enabled,
    onChanged: onChanged ?? (_) {},
    label: 'Choose radio',
    helperText: 'Group help',
    errorText: errorText,
    options: _options,
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

TextStyle _style(WidgetTester tester, Finder text) =>
    tester.widget<Text>(text).style!;

Finder _item(int index) => find.byType(HeroUiDescribedControl).at(index);

Finder _control(int index) => find
    .descendant(
      of: find.byType(HeroUiRadio<String>).at(index),
      matching: find.byType(StyleSpecBuilder<BoxSpec>),
    )
    .first;

RadioSpec _spec(WidgetTester tester, int index) =>
    tester.resolvedSpecOf<RadioSpec>(_control(index));

void main() {
  for (final mode in _modes) {
    testWidgets('a vertical group matches upstream in $mode', (tester) async {
      await _pump(tester, _group(), mode: mode);
      final group = heroUiCase('radio-primary-vertical-rest', mode: mode);
      final item = heroUiCase('radio-primary-vertical-rest-a', mode: mode);
      final content = heroUiCase(
        'radio-primary-vertical-rest-a-content',
        mode: mode,
      );
      final label = heroUiCase(
        'radio-primary-vertical-rest-a-label',
        mode: mode,
      );
      final description = heroUiCase(
        'radio-primary-vertical-rest-a-description',
        mode: mode,
      );

      // The label, three described options, and the group help stack to the
      // same height; each option is the content row, `gap-1`, and its help.
      expect(
        tester.getSize(find.byType(HeroUiRadioGroup<String>)).height,
        group.size.height,
      );
      expect(tester.getSize(_item(0)).height, item.size.height);

      final alpha = _style(tester, find.text('Alpha'));
      expect(alpha.fontSize, label.px('fontSize'));
      expect(alpha.fontSize! * alpha.height!, label.px('lineHeight'));
      expect(alpha.fontWeight, FontWeight.w500);
      expectCssColor(alpha.color!, label.styles['color']!, reason: 'label');

      final help = _style(tester, find.text('Help text').first);
      expect(help.fontSize, description.px('fontSize'));
      expect(help.fontSize! * help.height!, description.px('lineHeight'));
      expectCssColor(
        help.color!,
        description.styles['color']!,
        reason: 'description',
      );

      final control = tester.getRect(_control(0));
      expect(
        control.size,
        heroUiCase('radio-primary-vertical-rest-a-control').size,
      );
      expect(
        tester.getRect(find.text('Alpha')).left - control.right,
        content.px('gap'),
      );
      expect(
        tester.getRect(find.text('Help text').first).left - control.left,
        description.px('paddingLeft'),
      );
    });
  }

  for (final mode in _modes) {
    testWidgets('the selected option fills with accent, the rest do not in '
        '$mode', (tester) async {
      await _pump(
        tester,
        _group(groupValue: 'b', variant: .secondary),
        mode: mode,
      );
      Color? fill(int index) =>
          (_spec(tester, index).container.spec.decoration as BoxDecoration)
              .color;
      final selected = heroUiCase(
        'radio-secondary-vertical-rest-a-control',
        mode: mode,
      );
      expectCssColor(
        fill(1)!,
        selected.styles['backgroundColor']!,
        reason: 'selected',
      );
      expect(fill(0), heroUiToken(HeroUiTokens.defaultColor, mode));
      expect(fill(2), heroUiToken(HeroUiTokens.defaultColor, mode));
    });
  }

  testWidgets('a horizontal group is one wrapping row with gap-4', (
    tester,
  ) async {
    await _pump(tester, _group(orientation: Axis.horizontal, width: 1200));
    final group = heroUiCase('radio-primary-horizontal-rest');
    final label = tester.getRect(find.text('Choose radio'));
    final a = tester.getRect(_item(0));
    final b = tester.getRect(_item(1));
    final c = tester.getRect(_item(2));
    final help = tester.getRect(find.text('Group help'));
    // Upstream flows the label and the group help in the row with the options.
    expect(a.left - label.right, group.px('gap'));
    expect(b.left - a.right, group.px('gap'));
    expect(c.left - b.right, group.px('gap'));
    expect(help.left - c.right, group.px('gap'));
    expect(
      tester.getSize(find.byType(HeroUiRadioGroup<String>)).height,
      group.size.height,
    );
    expect(a.top, b.top);
  });

  for (final mode in _modes) {
    for (final variant in HeroUiRadioVariant.values) {
      testWidgets('an invalid ${variant.name} group keeps its description and '
          'adds the error in $mode', (tester) async {
        await _pump(
          tester,
          _group(variant: variant, invalid: true, errorText: _error),
          mode: mode,
        );
        final group = heroUiCase(
          'radio-${variant.name}-vertical-invalid',
          mode: mode,
        );
        final label = heroUiCase(
          'radio-${variant.name}-vertical-invalid-a-label',
          mode: mode,
        );
        final description = heroUiCase(
          'radio-${variant.name}-vertical-invalid-a-description',
          mode: mode,
        );
        // `.field-error`: `text-xs text-danger px-1`.
        final fieldError = heroUiCase(
          'search-primary-intrinsic-invalid-error',
          mode: mode,
        );

        // 204 at rest, plus the 16px error line.
        expect(
          tester.getSize(find.byType(HeroUiRadioGroup<String>)).height,
          group.size.height,
        );
        for (final text in ['Choose radio', 'Alpha', 'Beta']) {
          expectCssColor(
            _style(tester, find.text(text)).color!,
            label.styles['color']!,
            reason: text,
          );
        }
        // `radio-group.css` has no rule hiding the description.
        expect(find.text('Group help'), findsOneWidget);
        expectCssColor(
          _style(tester, find.text('Group help')).color!,
          description.styles['color']!,
          reason: 'group description',
        );
        expectCssColor(
          _style(tester, find.text('Help text').first).color!,
          description.styles['color']!,
          reason: 'option description',
        );

        final error = _style(tester, find.text(_error));
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
        // The error closes the group, after the description.
        expect(
          tester.getRect(find.text(_error)).top,
          greaterThanOrEqualTo(tester.getRect(find.text('Group help')).bottom),
        );

        for (var i = 0; i < 3; i++) {
          expect(
            _spec(tester, i).containerEffects!.outline.color,
            heroUiToken(HeroUiTokens.danger, mode),
          );
        }
      });
    }
  }

  testWidgets('the error shows only while the group is invalid', (
    tester,
  ) async {
    await _pump(tester, _group(errorText: _error));
    expect(find.text(_error), findsNothing);
    expect(
      tester.getSize(find.byType(HeroUiRadioGroup<String>)).height,
      heroUiCase('radio-primary-vertical-rest').size.height,
    );
  });

  for (final mode in _modes) {
    testWidgets('disabled dims the control once and its text twice in $mode', (
      tester,
    ) async {
      await _pump(tester, _group(enabled: false), mode: mode);
      final root = heroUiCase('radio-primary-vertical-disabled-a', mode: mode);
      final label = heroUiCase(
        'radio-primary-vertical-disabled-a-label',
        mode: mode,
      );
      final description = heroUiCase(
        'radio-primary-vertical-disabled-a-description',
        mode: mode,
      );

      // The radio dims its control and label together; the label's own
      // `status-disabled` is its color's alpha.
      final rootOpacity = double.parse(root.styles['opacity']!);
      expect(tester.opacityAbove(_control(0)), rootOpacity);
      expect(tester.opacityAbove(find.text('Alpha')), rootOpacity);
      expect(
        _style(tester, find.text('Alpha')).color!.a,
        closeTo(double.parse(label.styles['opacity']!), .001),
      );
      expect(
        tester.opacityAbove(find.text('Help text').first),
        closeTo(
          double.parse(description.styles['opacity']!) * rootOpacity,
          .001,
        ),
      );
      // The group label dims once; the group help is untouched.
      expect(
        tester.opacityAbove(find.text('Choose radio')),
        HeroUiTokens.disabledOpacity,
      );
      expect(tester.opacityAbove(find.text('Group help')), 1);
    });
  }

  testWidgets('tapping an option label selects it through Remix', (
    tester,
  ) async {
    var value = 'a';
    await _pump(
      tester,
      StatefulBuilder(
        builder: (context, setState) => _group(
          groupValue: value,
          onChanged: (next) => setState(() => value = next!),
        ),
      ),
    );
    await tester.tap(find.text('Beta'));
    await tester.pumpAndSettle();
    expect(value, 'b');
  });

  testWidgets('tapping a control selects through Remix', (tester) async {
    var value = 'a';
    await _pump(
      tester,
      StatefulBuilder(
        builder: (context, setState) => _group(
          groupValue: value,
          onChanged: (next) => setState(() => value = next!),
        ),
      ),
    );
    await tester.tap(_control(1));
    await tester.pumpAndSettle();
    expect(value, 'b');
  });

  testWidgets('a disabled option cannot be selected', (tester) async {
    String? picked;
    await _pump(
      tester,
      HeroUiRadioGroup<String>(
        groupValue: 'a',
        onChanged: (value) => picked = value,
        options: const [
          HeroUiRadioOption(value: 'a', label: 'Alpha'),
          HeroUiRadioOption(value: 'b', label: 'Beta', enabled: false),
        ],
      ),
    );
    await tester.tap(_control(1));
    expect(picked, isNull);
  });
}
