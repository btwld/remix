part of 'avatar.dart';

enum FortalAvatarSize { size1, size2, size3, size4 }

enum FortalAvatarVariant { soft, solid }

class FortalAvatarStyles {
  const FortalAvatarStyles._();

  static RemixAvatarStyle create({
    FortalAvatarVariant variant = FortalAvatarVariant.soft,
    FortalAvatarSize size = FortalAvatarSize.size2,
  }) {
    return switch (variant) {
      FortalAvatarVariant.soft => soft(size: size),
      FortalAvatarVariant.solid => solid(size: size),
    };
  }

  static RemixAvatarStyle base({
    FortalAvatarSize size = FortalAvatarSize.size2,
  }) {
    return RemixAvatarStyle()
        .clipBehavior(Clip.hardEdge)
        .merge(_sizeStyle(size));
  }

  static RemixAvatarStyle soft({
    FortalAvatarSize size = FortalAvatarSize.size2,
  }) {
    return base(size: size)
        .color(FortalTokens.accentA3())
        .labelColor(FortalTokens.accent9())
        .iconColor(FortalTokens.accent9());
  }

  static RemixAvatarStyle solid({
    FortalAvatarSize size = FortalAvatarSize.size2,
  }) {
    return base(size: size)
        .color(FortalTokens.accent9())
        .labelColor(FortalTokens.accentContrast())
        .iconColor(FortalTokens.accentContrast());
  }

  static RemixAvatarStyle _sizeStyle(FortalAvatarSize size) {
    return switch (size) {
      FortalAvatarSize.size1 =>
        RemixAvatarStyle()
            .square(24.0)
            .borderRadiusAll(FortalTokens.radius2())
            .labelTextStyle(FortalTokens.text1.mix()),
      FortalAvatarSize.size2 =>
        RemixAvatarStyle()
            .square(32.0)
            .borderRadiusAll(FortalTokens.radius3())
            .labelTextStyle(FortalTokens.text2.mix()),
      FortalAvatarSize.size3 =>
        RemixAvatarStyle()
            .square(40.0)
            .borderRadiusAll(FortalTokens.radius4())
            .labelTextStyle(FortalTokens.text3.mix()),
      FortalAvatarSize.size4 =>
        RemixAvatarStyle()
            .square(64.0)
            .borderRadiusAll(FortalTokens.radius5())
            .labelTextStyle(FortalTokens.text4.mix()),
    };
  }
}
