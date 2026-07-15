part of 'toggle_group.dart';

/// Fortal toggle-group size presets.
enum FortalToggleGroupSize { size1, size2, size3 }

/// Fortal toggle-group color treatments.
enum FortalToggleGroupVariant { soft, surface }

/// Fortal-themed segmented-control preset for [RemixToggleGroup].
RemixToggleGroupStyler fortalToggleGroupStyler({
  FortalToggleGroupVariant variant = .soft,
  FortalToggleGroupSize size = .size2,
}) {
  final selectedColor = switch (variant) {
    .soft => FortalTokens.accent3(),
    .surface => FortalTokens.accentSurface(),
  };

  return RemixToggleGroupStyler(
    container: FlexBoxStyler(
      decoration: BoxDecorationMix(
        border: BorderMix.all(
          BorderSideMix(
            color: FortalTokens.gray7(),
            width: FortalTokens.borderWidth1(),
          ),
        ),
        borderRadius: BorderRadiusMix.all(_fortalToggleGroupRadius(size)),
        color: FortalTokens.colorSurface(),
      ),
      clipBehavior: .hardEdge,
      mainAxisSize: .min,
      spacing: 0,
    ),
    item: RemixToggleGroupItemStyler()
        .alignment(.center)
        .spacing(_fortalToggleGroupSpacing(size))
        .padding(_fortalToggleGroupPadding(size))
        .foregroundColor(FortalTokens.gray11())
        .labelFontWeight(.w500)
        .labelFontSize(_fortalToggleGroupFontSize(size))
        .iconSize(_fortalToggleGroupIconSize(size))
        .onHovered(
          RemixToggleGroupItemStyler().backgroundColor(FortalTokens.grayA3()),
        )
        .onFocused(
          RemixToggleGroupItemStyler().borderAll(
            color: FortalTokens.focusA8(),
            width: FortalTokens.focusRingWidth(),
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        )
        .onSelected(
          RemixToggleGroupItemStyler()
              .backgroundColor(selectedColor)
              .foregroundColor(FortalTokens.accent11()),
        )
        .onDisabled(
          RemixToggleGroupItemStyler()
              .backgroundColor(FortalTokens.grayA3())
              .foregroundColor(FortalTokens.gray8()),
        ),
  );
}

Radius _fortalToggleGroupRadius(FortalToggleGroupSize size) {
  return switch (size) {
    .size1 || .size2 => FortalTokens.radius2(),
    .size3 => FortalTokens.radius3(),
  };
}

EdgeInsetsGeometryMix _fortalToggleGroupPadding(FortalToggleGroupSize size) {
  return switch (size) {
    .size1 => EdgeInsetsMix.symmetric(
      vertical: FortalTokens.space1(),
      horizontal: FortalTokens.space2(),
    ),
    .size2 => EdgeInsetsMix.symmetric(
      vertical: FortalTokens.space2(),
      horizontal: FortalTokens.space3(),
    ),
    .size3 => EdgeInsetsMix.symmetric(
      vertical: FortalTokens.space2(),
      horizontal: FortalTokens.space4(),
    ),
  };
}

double _fortalToggleGroupSpacing(FortalToggleGroupSize size) {
  return switch (size) {
    .size1 => 2,
    .size2 => 4,
    .size3 => 6,
  };
}

double _fortalToggleGroupFontSize(FortalToggleGroupSize size) {
  return switch (size) {
    .size1 => 12,
    .size2 => 14,
    .size3 => 16,
  };
}

double _fortalToggleGroupIconSize(FortalToggleGroupSize size) {
  return switch (size) {
    .size1 => 12,
    .size2 => 16,
    .size3 => 20,
  };
}

/// Fortal-themed segmented-control preset for [RemixToggleGroup].
class FortalToggleGroup<T> extends StatelessWidget {
  const FortalToggleGroup({
    super.key,
    this.variant = .soft,
    this.size = .size2,
    required this.items,
    required this.selectedValue,
    this.onChanged,
    this.enabled = true,
    this.orientation = .horizontal,
    this.loop = true,
    this.semanticLabel,
    this.excludeSemantics = false,
  });

  const FortalToggleGroup.soft({
    super.key,
    this.size = .size2,
    required this.items,
    required this.selectedValue,
    this.onChanged,
    this.enabled = true,
    this.orientation = .horizontal,
    this.loop = true,
    this.semanticLabel,
    this.excludeSemantics = false,
  }) : variant = FortalToggleGroupVariant.soft;

  const FortalToggleGroup.surface({
    super.key,
    this.size = .size2,
    required this.items,
    required this.selectedValue,
    this.onChanged,
    this.enabled = true,
    this.orientation = .horizontal,
    this.loop = true,
    this.semanticLabel,
    this.excludeSemantics = false,
  }) : variant = FortalToggleGroupVariant.surface;

  final FortalToggleGroupVariant variant;

  final FortalToggleGroupSize size;

  final List<RemixToggleGroupItem<T>> items;

  final T? selectedValue;

  final ValueChanged<T?>? onChanged;

  final bool enabled;

  final Axis orientation;

  final bool loop;

  final String? semanticLabel;

  final bool excludeSemantics;

  @override
  Widget build(BuildContext context) {
    return fortalToggleGroupStyler(
      variant: this.variant,
      size: this.size,
    ).call<T>(
      key: this.key,
      items: this.items,
      selectedValue: this.selectedValue,
      onChanged: this.onChanged,
      enabled: this.enabled,
      orientation: this.orientation,
      loop: this.loop,
      semanticLabel: this.semanticLabel,
      excludeSemantics: this.excludeSemantics,
    );
  }
}
