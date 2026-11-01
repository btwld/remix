import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/heroui/components/toggle_button.dart';
import 'package:registry_source/src/heroui/components/toggle_button_group.dart';
import 'package:registry_source/src/heroui/theme/theme.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

const _one = 'One';
const _two = 'Two';
const _icon = IconData(0xe000, fontFamily: 'Ahem');
const _modes = ['light', 'dark'];

Widget _group({
  HeroUiToggleButtonVariant variant = .defaultToggle,
  HeroUiToggleButtonSize size = .md,
  bool detached = false,
  bool iconOnly = false,
  Axis orientation = Axis.horizontal,
  String? selectedValue = 'a',
  bool secondEnabled = true,
  ValueChanged<String?>? onChanged,
  ToggleGroupStyler style = const ToggleGroupStyler.create(),
}) => HeroUiToggleButtonGroup<String>(
  variant: variant,
  size: size,
  detached: detached,
  iconOnly: iconOnly,
  orientation: orientation,
  selectedValue: selectedValue,
  onChanged: onChanged ?? (_) {},
  style: style,
  items: [
    RemixToggleGroupItem(
      value: 'a',
      label: iconOnly ? null : _one,
      icon: iconOnly ? _icon : null,
      semanticLabel: _one,
    ),
    RemixToggleGroupItem(
      value: 'b',
      label: iconOnly ? null : _two,
      icon: iconOnly ? _icon : null,
      semanticLabel: _two,
      enabled: secondEnabled,
    ),
  ],
);

Future<void> _pump(
  WidgetTester tester,
  Widget group, {
  String mode = 'light',
  int width = 1024,
}) async {
  await tester.pumpHeroUi(group, mode: mode, width: width.toDouble());
  await tester.pumpAndSettle();
}

ToggleGroupItemSpec _item(WidgetTester tester, [String text = _one]) =>
    tester.resolvedSpecOf<ToggleGroupItemSpec>(find.text(text));

ToggleGroupSpec _spec(WidgetTester tester) =>
    tester.resolvedSpecOf<ToggleGroupSpec>(find.text(_one));

/// The item's own box: the nearest box above its label.
Finder _itemBox(String text) => find
    .ancestor(
      of: find.text(text),
      matching: find.byType(StyleSpecBuilder<BoxSpec>),
    )
    .first;

BoxDecoration? _decoration(FlexBoxSpec spec) =>
    spec.boxSpec.decoration as BoxDecoration?;

Color? _fill(ToggleGroupItemSpec spec) =>
    (spec.container.spec.boxSpec.decoration as BoxDecoration?)?.color;

String _id(HeroUiToggleButtonVariant variant) =>
    variant == .defaultToggle ? 'default' : 'ghost';

void main() {
  for (final mode in _modes) {
    for (final width in [375, 1024]) {
      for (final variant in HeroUiToggleButtonVariant.values) {
        for (final size in HeroUiToggleButtonSize.values) {
          testWidgets(
            '${_id(variant)} ${size.name} group matches upstream at $width px in $mode',
            (tester) async {
              await _pump(
                tester,
                _group(variant: variant, size: size),
                mode: mode,
                width: width,
              );
              final id = 'group-horizontal-joined-auto-${size.name}';
              final group = heroUiCase(id, mode: mode, width: width);
              final item = heroUiCase('$id-a', mode: mode, width: width);
              final selected = _item(tester);
              final rest = _item(tester, _two);

              expect(
                tester
                    .getSize(find.byType(HeroUiToggleButtonGroup<String>))
                    .height,
                group.size.height,
              );
              // The item's own box: the label plus the paddings and the
              // ring border, at the measured height.
              final box = tester.getSize(_itemBox(_one));
              expect(box.height, item.size.height);
              expect(
                box.width - tester.getSize(find.text(_one)).width,
                item.px('paddingLeft') + item.px('paddingRight'),
              );
              final one = tester.getRect(find.text(_one));
              final two = tester.getRect(find.text(_two));
              expect(
                two.left - one.right,
                item.px('paddingLeft') + item.px('paddingRight'),
                reason: 'joined items touch',
              );

              // The selected item is `accent-soft`; the other is at rest.
              expect(
                _fill(selected),
                heroUiToken(HeroUiTokens.accentSoft, mode),
              );
              expect(
                selected.label.spec.style!.color,
                heroUiToken(HeroUiTokens.accentSoftForeground, mode),
              );
              expect(
                _fill(rest),
                variant == .defaultToggle
                    ? heroUiToken(HeroUiTokens.defaultColor, mode)
                    : HeroUiTokens.transparent,
              );
              final label = selected.label.spec.style!;
              expect(label.fontSize, item.px('fontSize'));
              expect(label.fontSize! * label.height!, item.px('lineHeight'));
            },
          );
        }
      }
    }
  }

  testWidgets('a joined group is one clipped pill of square items', (
    tester,
  ) async {
    await _pump(tester, _group());
    final item = heroUiCase('group-horizontal-joined-auto-md-a');
    final spec = _spec(tester);
    // The first item is rounded on its outer corners: `24px 0px 0px 24px`.
    final outer = double.parse(item.styles['borderRadius']!.split('px').first);
    expect(
      _decoration(spec.container.spec)!.borderRadius,
      BorderRadius.circular(outer),
    );
    // Every other rounded clip in the preset is anti-aliased.
    expect(spec.container.spec.boxSpec.clipBehavior, Clip.antiAlias);
    expect(spec.container.spec.flex!.spec.spacing ?? 0, 0);
    expect(_decoration(_item(tester).container.spec)?.borderRadius, isNull);
  });

  testWidgets('a detached group separates rounded items by gap-1', (
    tester,
  ) async {
    await _pump(tester, _group(detached: true));
    final joined = heroUiCase('group-horizontal-joined-auto-md');
    final detached = heroUiCase('group-horizontal-detached-auto-md');
    final item = heroUiCase('group-horizontal-detached-auto-md-a');
    final one = tester.getRect(find.byType(HeroUiToggleButtonGroup<String>));
    expect(detached.size.width - joined.size.width, detached.px('gap'));
    expect(_spec(tester).container.spec.flex!.spec.spacing, detached.px('gap'));
    expect(
      _decoration(_item(tester).container.spec)!.borderRadius,
      BorderRadius.circular(item.px('borderRadius')),
    );
    expect(one.height, detached.size.height);
    expect(_decoration(_spec(tester).container.spec)?.borderRadius, isNull);
  });

  testWidgets('a vertical group stacks its items', (tester) async {
    await _pump(tester, _group(orientation: Axis.vertical));
    final group = heroUiCase('group-vertical-joined-auto-md');
    final item = heroUiCase('group-vertical-joined-auto-md-a');
    final one = tester.getRect(_itemBox(_one));
    final two = tester.getRect(_itemBox(_two));
    expect(
      tester.getSize(find.byType(HeroUiToggleButtonGroup<String>)).height,
      group.size.height,
    );
    // Joined items touch: the second starts where the first ends.
    expect(one.height, item.size.height);
    expect(two.top, one.bottom);
    expect(one.center.dx, two.center.dx);
  });

  // `toggle-button.css`: `size-5 sm:size-4` on icons, and `p-0 w-10 md:w-9`
  // squares the button.
  for (final (width, iconSize) in [(375, 20.0), (1024, 16.0)]) {
    testWidgets('icon-only items are square at $width px', (tester) async {
      await _pump(tester, _group(iconOnly: true), width: width);
      final item = heroUiCase('toggle-default-md-icon-rest', width: width);
      final icon = tester.resolvedSpecOf<ToggleGroupItemSpec>(
        find.byIcon(_icon).first,
      );
      expect(icon.icon.spec.size, iconSize);
      expect(tester.widget<Icon>(find.byIcon(_icon).first).size, iconSize);
      expect(
        tester.getSize(find.byType(HeroUiToggleButtonGroup<String>)),
        Size(item.size.width * 2, item.size.height),
      );
    });
  }

  // The group repeats the toggle button's colors without its pressed scale
  // (`.toggle-button-group .toggle-button:active`).
  for (final mode in _modes) {
    for (final (variant, hover) in [
      (HeroUiToggleButtonVariant.defaultToggle, HeroUiTokens.defaultHover),
      (HeroUiToggleButtonVariant.ghost, HeroUiTokens.defaultColor),
    ]) {
      testWidgets(
        'hover and press do not scale the ${_id(variant)} items in $mode',
        (tester) async {
          await _pump(tester, _group(variant: variant), mode: mode);
          await tester.hoverCenter(find.text(_two));
          expect(_fill(_item(tester, _two)), heroUiToken(hover, mode));

          final press = await tester.pressCenter(find.text(_two));
          final item = _item(tester, _two);
          expect(_fill(item), heroUiToken(hover, mode));
          expect(item.container.spec.boxSpec.transform, isNull);
          await press.up();
        },
        variant: desktopOnly,
      );

      // A selected item keeps its soft fill and darkens under the pointer.
      testWidgets(
        'a selected ${_id(variant)} item takes accent-soft-hover when hovered '
        'in $mode',
        (tester) async {
          await _pump(tester, _group(variant: variant), mode: mode);
          expect(
            _fill(_item(tester)),
            heroUiToken(HeroUiTokens.accentSoft, mode),
            reason: 'rest',
          );
          await tester.hoverCenter(find.text(_one));
          expect(
            _fill(_item(tester)),
            heroUiToken(HeroUiTokens.accentSoftHover, mode),
            reason: 'hover',
          );
        },
        variant: desktopOnly,
      );

      testWidgets(
        'a selected ${_id(variant)} item takes accent-soft-hover when pressed '
        'in $mode',
        (tester) async {
          await _pump(tester, _group(variant: variant), mode: mode);
          final press = await tester.pressCenter(find.text(_one));
          final item = _item(tester);
          expect(
            _fill(item),
            heroUiToken(HeroUiTokens.accentSoftHover, mode),
            reason: 'press',
          );
          expect(item.container.spec.boxSpec.transform, isNull);
          await press.up();
        },
      );
    }

    testWidgets('keyboard focus insets the ring without resizing in $mode', (
      tester,
    ) async {
      await _pump(tester, _group(), mode: mode);
      final before = tester.getSize(
        find.byType(HeroUiToggleButtonGroup<String>),
      );
      await tester.focusWithTab();
      final border =
          _decoration(_item(tester).container.spec)!.border! as Border;
      expect(border.top.width, HeroUiTokens.focusWidth);
      expect(border.top.color, heroUiToken(HeroUiTokens.focus, mode));
      expect(
        tester.getSize(find.byType(HeroUiToggleButtonGroup<String>)),
        before,
      );
    });

    testWidgets('a disabled item dims in $mode', (tester) async {
      await _pump(tester, _group(secondEnabled: false), mode: mode);
      final disabled = heroUiCase(
        'toggle-default-md-label-disabled',
        mode: mode,
      );
      expect(
        tester.opacityAbove(find.text(_two)),
        double.parse(disabled.styles['opacity']!),
      );
    });
  }

  testWidgets('selecting an item reports its value through Remix', (
    tester,
  ) async {
    var value = 'a';
    await _pump(
      tester,
      StatefulBuilder(
        builder: (context, setState) => _group(
          selectedValue: value,
          onChanged: (next) => setState(() => value = next!),
        ),
      ),
    );
    await tester.tap(find.text(_two));
    await tester.pumpAndSettle();
    expect(value, 'b');
    expect(_fill(_item(tester, _two)), heroUiToken(HeroUiTokens.accentSoft));
    expect(_fill(_item(tester)), heroUiToken(HeroUiTokens.defaultColor));
  });

  testWidgets('a caller style wins over the recipe', (tester) async {
    const override = Color(0xFF00FF00);
    await _pump(
      tester,
      _group(style: ToggleGroupStyler().item(.color(override))),
    );
    expect(_fill(_item(tester, _two)), override);
  });
}
