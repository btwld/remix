part of 'toggle_group.dart';

/// Fortal toggle-group size presets.
enum FortalToggleGroupSize { size1, size2, size3 }

/// Fortal toggle-group color treatments.
enum FortalToggleGroupVariant { soft, surface }

/// Fortal-themed segmented-control preset for [RemixToggleGroup].
@MixWidget(
  name: 'FortalToggleGroup',
  target: RemixToggleGroup.new,
  factoryParameters: .only({'variant', 'size'}),
)
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
        color: FortalTokens.colorSurface(),
      ),
      clipBehavior: .hardEdge,
      mainAxisSize: .min,
      spacing: 0,
    ),
    item: RemixToggleGroupItemStyler()
        .alignment(.center)
        .foregroundColor(FortalTokens.gray11())
        .labelFontWeight(.w500)
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
  ).merge(_fortalToggleGroupSizeStyler(size));
}

RemixToggleGroupStyler _fortalToggleGroupSizeStyler(
  FortalToggleGroupSize size,
) {
  return switch (size) {
    .size1 => RemixToggleGroupStyler(
      container: FlexBoxStyler().borderRadiusAll(FortalTokens.radius2()),
      item: RemixToggleGroupItemStyler(
        container: FlexBoxStyler()
            .paddingX(FortalTokens.space2())
            .paddingY(FortalTokens.space1())
            .spacing(2),
        label: TextStyler().fontSize(12),
        icon: IconStyler(size: 12),
      ),
    ),
    .size2 => RemixToggleGroupStyler(
      container: FlexBoxStyler().borderRadiusAll(FortalTokens.radius2()),
      item: RemixToggleGroupItemStyler(
        container: FlexBoxStyler()
            .paddingX(FortalTokens.space3())
            .paddingY(FortalTokens.space2())
            .spacing(4),
        label: TextStyler().fontSize(14),
        icon: IconStyler(size: 16),
      ),
    ),
    .size3 => RemixToggleGroupStyler(
      container: FlexBoxStyler().borderRadiusAll(FortalTokens.radius3()),
      item: RemixToggleGroupItemStyler(
        container: FlexBoxStyler()
            .paddingX(FortalTokens.space4())
            .paddingY(FortalTokens.space2())
            .spacing(6),
        label: TextStyler().fontSize(16),
        icon: IconStyler(size: 20),
      ),
    ),
  };
}

/// Fortal-themed segmented-control preset for [RemixToggleGroup].
