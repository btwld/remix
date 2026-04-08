part of 'toggle.dart';

enum FortalToggleSize { size1, size2, size3 }

enum FortalToggleVariant { ghost, outline }

/// Factory class for creating Fortal-compliant toggle styles.
class FortalToggleStyles {
  const FortalToggleStyles._();

  /// Factory constructor with variant and size parameters.
  static RemixToggleStyle create({
    FortalToggleVariant variant = .ghost,
    FortalToggleSize size = .size2,
  }) {
    return switch (variant) {
      .ghost => ghost(size: size),
      .outline => outline(size: size),
    };
  }

  /// Base sizing and shared styling.
  static RemixToggleStyle base({FortalToggleSize size = .size2}) {
    return RemixToggleStyle()
        .foregroundColor(FortalTokens.gray12())
        .onFocused(
          RemixToggleStyle().borderAll(
            color: FortalTokens.focusA8(),
            width: FortalTokens.focusRingWidth(),
          ),
        )
        .onDisabled(
          RemixToggleStyle()
              .backgroundColor(FortalTokens.grayA3())
              .foregroundColor(FortalTokens.gray8()),
        )
        .merge(_sizeStyle(size));
  }

  /// Ghost variant: borderless, subtle background on hover, accent on selected.
  static RemixToggleStyle ghost({FortalToggleSize size = .size2}) {
    return base(size: size)
        .backgroundColor(Colors.transparent)
        .onHovered(RemixToggleStyle().backgroundColor(FortalTokens.grayA3()))
        .onPressed(RemixToggleStyle().scale(0.97))
        .onSelected(
          RemixToggleStyle()
              .backgroundColor(FortalTokens.accent3())
              .foregroundColor(FortalTokens.accent11()),
        );
  }

  /// Outline variant: border-based, accent fill when selected.
  static RemixToggleStyle outline({FortalToggleSize size = .size2}) {
    return base(size: size)
        .backgroundColor(Colors.transparent)
        .borderAll(
          color: FortalTokens.gray7(),
          width: FortalTokens.borderWidth1(),
          strokeAlign: BorderSide.strokeAlignInside,
        )
        .onHovered(RemixToggleStyle().backgroundColor(FortalTokens.grayA3()))
        .onPressed(RemixToggleStyle().scale(0.97))
        .onSelected(
          RemixToggleStyle()
              .backgroundColor(FortalTokens.accent9())
              .foregroundColor(FortalTokens.accentContrast())
              .borderAll(color: FortalTokens.accent9()),
        );
  }

  // Internal size builder
  static RemixToggleStyle _sizeStyle(FortalToggleSize size) {
    return switch (size) {
      .size1 => RemixToggleStyle(
        container: FlexBoxStyler()
            .paddingX(FortalTokens.space2())
            .paddingY(FortalTokens.space1())
            .borderRadiusAll(FortalTokens.radius2()),
        label: TextStyler(style: FortalTokens.text1.mix()),
        icon: IconStyler(size: 14),
      ),
      .size2 => RemixToggleStyle(
        container: FlexBoxStyler()
            .paddingX(FortalTokens.space3())
            .paddingY(FortalTokens.space2())
            .borderRadiusAll(FortalTokens.radius2()),
        label: TextStyler(style: FortalTokens.text2.mix()),
        icon: IconStyler(size: 16),
      ),
      .size3 => RemixToggleStyle(
        container: FlexBoxStyler()
            .paddingX(FortalTokens.space4())
            .paddingY(FortalTokens.space2())
            .borderRadiusAll(FortalTokens.radius3()),
        label: TextStyler(style: FortalTokens.text3.mix()),
        icon: IconStyler(size: 18),
      ),
    };
  }
}
