import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import 'dashboard_demo_text.dart';
import 'dashboard_demo_theme.dart';
import 'dashboard_demo_ui.dart';

/// Interactive Ui theme customizer panel.
class UiThemePanel extends StatelessWidget {
  const UiThemePanel({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = UiDashboardThemeScope.of(context);
    final settings = scope.settings;

    Widget choice<T extends Object>({
      required String label,
      required T selectedValue,
      required List<RemixSegmentedControlItem<T>> items,
      required UiThemeSettings Function(T value) apply,
    }) => _Control(
      label: label,
      child: UiSegmentedControl<T>(
        size: .size1,
        selectedValue: selectedValue,
        semanticLabel: label,
        items: items,
        onChanged: (value) => scope.onChanged(apply(value)),
      ),
    );

    return Box(
      key: const ValueKey('theme-panel'),
      style: BoxStyler().width(360),
      child: ColumnBox(
        style: FlexBoxStyler().crossAxisAlignment(.stretch).spacing(18),
        children: [
          choice<UiThemeMode>(
            label: 'Appearance',
            selectedValue: settings.appearance,
            items: _enumSegmentedItems(UiThemeMode.values),
            apply: (value) => settings.copyWith(appearance: value),
          ),
          _Control(
            label: 'Accent color',
            child: WrapBox(
              style: WrapBoxStyler().spacing(8).runSpacing(8),
              children: [
                for (final accent in UiAccentColor.values)
                  _AccentSwatch(
                    key: ValueKey('accent-${accent.name}'),
                    accent: accent,
                    selected: accent == settings.accentColor,
                    onPressed: () =>
                        scope.onChanged(settings.copyWith(accentColor: accent)),
                  ),
              ],
            ),
          ),
          _Control(
            label: 'Gray color',
            child: UiSelect<UiGrayColor>(
              trigger: const RemixSelectTrigger(placeholder: 'Choose gray'),
              selectedValue: settings.grayColor,
              items: [
                for (final gray in UiGrayColor.values)
                  RemixSelectItem(value: gray, label: enumLabel(gray)),
              ],
              onChanged: (value) {
                if (value != null) {
                  scope.onChanged(settings.copyWith(grayColor: value));
                }
              },
            ),
          ),
          choice<UiPanelBackground>(
            label: 'Panel background',
            selectedValue: settings.panelBackground,
            items: _enumSegmentedItems(UiPanelBackground.values),
            apply: (value) => settings.copyWith(panelBackground: value),
          ),
          RowBox(
            style: FlexBoxStyler().spacing(10),
            children: [
              Expanded(
                child: choice<UiRadius>(
                  label: 'Radius',
                  selectedValue: settings.radius,
                  items: _enumSegmentedItems(
                    UiRadius.values,
                    labelBuilder: _radiusLabel,
                  ),
                  apply: (value) => settings.copyWith(radius: value),
                ),
              ),
              Box(
                style: BoxStyler()
                    .width(28)
                    .height(28)
                    .color(UiTokens.accent9())
                    .borderRadius(.all(UiTokens.radius3())),
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: choice<UiScaling>(
              label: 'Scaling',
              selectedValue: settings.scaling,
              items: _enumSegmentedItems(
                UiScaling.values,
                labelBuilder: _scalingLabel,
              ),
              apply: (value) => settings.copyWith(scaling: value),
            ),
          ),
          Box(
            style: BoxStyler().alignment(.centerStart),
            child: UiButton.ghost(
              key: const ValueKey('theme-reset'),
              size: .size1,
              onPressed: () => scope.onChanged(const UiThemeSettings()),
              label: 'Reset theme',
              leadingIcon: RemixIcons.reload,
            ),
          ),
        ],
      ),
    );
  }
}

List<RemixSegmentedControlItem<T>> _enumSegmentedItems<T extends Enum>(
  List<T> values, {
  String Function(T value)? labelBuilder,
}) => [
  for (final value in values)
    RemixSegmentedControlItem(
      value: value,
      label: labelBuilder?.call(value) ?? enumLabel(value),
    ),
];

String _radiusLabel(UiRadius radius) => switch (radius) {
  .none => 'None',
  .small => 'S',
  .medium => 'M',
  .large => 'L',
  .full => 'Full',
};

String _scalingLabel(UiScaling scaling) => '${(scaling.factor * 100).round()}%';

class _Control extends StatelessWidget {
  const _Control({required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) => ColumnBox(
    style: FlexBoxStyler().crossAxisAlignment(.start).spacing(8),
    children: [
      UiText(label, size: .size2, weight: .medium),
      child,
    ],
  );
}

class _AccentSwatch extends StatelessWidget {
  const _AccentSwatch({
    super.key,
    required this.accent,
    required this.selected,
    required this.onPressed,
  });

  static final _ring = ToggleStyler().border(
    .color(UiTokens.focus8())
        .width(UiTokens.focusRingWidth())
        .strokeAlign(BorderSide.strokeAlignOutside),
  );

  static final _style =
      ToggleStyler(
            container: FlexBoxStyler()
                .size(30, 30)
                .alignment(.center)
                .mainAxisSize(.min)
                .borderRadius(.all(const Radius.circular(15))),
            icon: .size(15),
          )
          // A swatch is the palette's mark fill, so its selected tick takes
          // the mark ink; the focus-coloured ring also marks the selection.
          .color(UiTokens.accentIndicator())
          .iconColor(const Color(0x00000000))
          .onHovered(ToggleStyler().color(UiTokens.accent10()))
          .onPressed(ToggleStyler().color(UiTokens.accent10()))
          .onSelected(
            ToggleStyler()
                .iconColor(UiTokens.accentIndicatorContrast())
                .merge(_ring),
          )
          .onFocusVisible(_ring);

  final UiAccentColor accent;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => UiAccentScope(
    accent: accent,
    child: RemixToggle(
      selected: selected,
      onChanged: (_) => onPressed(),
      icon: RemixIcons.check,
      semanticLabel: '${enumLabel(accent)} accent',
      style: _style,
    ),
  );
}
