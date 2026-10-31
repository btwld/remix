import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import 'dashboard_demo_text.dart';
import 'dashboard_demo_theme.dart';
import 'dashboard_demo_ui.dart';

/// Interactive Fortal theme customizer panel.
class FortalThemePanel extends StatelessWidget {
  const FortalThemePanel({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = FortalDashboardThemeScope.of(context);
    final settings = scope.settings;

    Widget choice<T extends Object>({
      required String label,
      required T selectedValue,
      required List<RemixSegmentedControlItem<T>> items,
      required FortalThemeSettings Function(T value) apply,
    }) => _Control(
      label: label,
      child: FortalSegmentedControl<T>(
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
          choice<FortalThemeMode>(
            label: 'Appearance',
            selectedValue: settings.appearance,
            items: _enumSegmentedItems(FortalThemeMode.values),
            apply: (value) => settings.copyWith(appearance: value),
          ),
          _Control(
            label: 'Accent color',
            child: WrapBox(
              style: WrapBoxStyler().spacing(8).runSpacing(8),
              children: [
                for (final accent in FortalAccentColor.values)
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
            child: FortalSelect<FortalGrayColor>(
              trigger: const RemixSelectTrigger(placeholder: 'Choose gray'),
              selectedValue: settings.grayColor,
              items: [
                for (final gray in FortalGrayColor.values)
                  RemixSelectItem(value: gray, label: enumLabel(gray)),
              ],
              onChanged: (value) {
                if (value != null) {
                  scope.onChanged(settings.copyWith(grayColor: value));
                }
              },
            ),
          ),
          choice<FortalPanelBackground>(
            label: 'Panel background',
            selectedValue: settings.panelBackground,
            items: _enumSegmentedItems(FortalPanelBackground.values),
            apply: (value) => settings.copyWith(panelBackground: value),
          ),
          RowBox(
            style: FlexBoxStyler().spacing(10),
            children: [
              Expanded(
                child: choice<FortalRadius>(
                  label: 'Radius',
                  selectedValue: settings.radius,
                  items: _enumSegmentedItems(
                    FortalRadius.values,
                    labelBuilder: _radiusLabel,
                  ),
                  apply: (value) => settings.copyWith(radius: value),
                ),
              ),
              Box(
                style: BoxStyler()
                    .width(28)
                    .height(28)
                    .color(FortalTokens.accent9())
                    .borderRadius(.all(FortalTokens.radius3())),
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: choice<FortalScaling>(
              label: 'Scaling',
              selectedValue: settings.scaling,
              items: _enumSegmentedItems(
                FortalScaling.values,
                labelBuilder: _scalingLabel,
              ),
              apply: (value) => settings.copyWith(scaling: value),
            ),
          ),
          Box(
            style: BoxStyler().alignment(.centerStart),
            child: FortalButton.ghost(
              key: const ValueKey('theme-reset'),
              size: .size1,
              onPressed: () => scope.onChanged(const FortalThemeSettings()),
              label: 'Reset theme',
              leadingIcon: RemixIcons.refresh,
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

String _radiusLabel(FortalRadius radius) => switch (radius) {
  .none => 'None',
  .small => 'S',
  .medium => 'M',
  .large => 'L',
  .full => 'Full',
};

String _scalingLabel(FortalScaling scaling) =>
    '${(scaling.factor * 100).round()}%';

class _Control extends StatelessWidget {
  const _Control({required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) => ColumnBox(
    style: FlexBoxStyler().crossAxisAlignment(.start).spacing(8),
    children: [
      FortalText(label, size: .size2, weight: .medium),
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
    .color(FortalTokens.focus8())
        .width(FortalTokens.focusRingWidth())
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
          .color(FortalTokens.accent9())
          .iconColor(const Color(0x00000000))
          .onHovered(ToggleStyler().color(FortalTokens.accent10()))
          .onPressed(ToggleStyler().color(FortalTokens.accent10()))
          .onSelected(
            ToggleStyler()
                .iconColor(FortalTokens.accentContrast())
                .merge(_ring),
          )
          .onFocusVisible(_ring);

  final FortalAccentColor accent;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => FortalAccentScope(
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
