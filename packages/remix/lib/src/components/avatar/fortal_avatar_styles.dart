part of 'avatar.dart';

/// Fortal avatar size presets.
enum FortalAvatarSize { size1, size2, size3, size4 }

/// Fortal avatar color variants.
enum FortalAvatarVariant { soft, solid }

/// Creates a Fortal-themed [RemixAvatarStyler].
@MixWidget(name: 'FortalAvatar')
RemixAvatarStyler fortalAvatarStyler({
  FortalAvatarVariant variant = .soft,
  FortalAvatarSize size = .size2,
}) {
  return switch (variant) {
    .soft => _fortalAvatarSoftStyler(size),
    .solid => _fortalAvatarSolidStyler(size),
  };
}

RemixAvatarStyler _fortalAvatarBaseStyler(FortalAvatarSize size) {
  return RemixAvatarStyler()
      .clipBehavior(.hardEdge)
      .labelFontWeight(FontWeight.w500)
      .merge(_fortalAvatarSizeStyler(size));
}

RemixAvatarStyler _fortalAvatarSoftStyler([FortalAvatarSize size = .size2]) {
  return _fortalAvatarBaseStyler(size)
      .backgroundColor(FortalTokens.accentA3())
      .foregroundColor(FortalTokens.accentA10());
}

RemixAvatarStyler _fortalAvatarSolidStyler([FortalAvatarSize size = .size2]) {
  return _fortalAvatarBaseStyler(size)
      .backgroundColor(FortalTokens.accent9())
      .foregroundColor(FortalTokens.accentContrast());
}

RemixAvatarStyler _fortalAvatarSizeStyler(FortalAvatarSize size) {
  return switch (size) {
    .size1 =>
      RemixAvatarStyler()
          .square(24.0)
          .borderRadiusAll(FortalTokens.radius2())
          .labelStyle(FortalTokens.text1.mix()),
    .size2 =>
      RemixAvatarStyler()
          .square(32.0)
          .borderRadiusAll(FortalTokens.radius3())
          .labelStyle(FortalTokens.text2.mix()),
    .size3 =>
      RemixAvatarStyler()
          .square(40.0)
          .borderRadiusAll(FortalTokens.radius4())
          .labelStyle(FortalTokens.text3.mix()),
    .size4 =>
      RemixAvatarStyler()
          .square(64.0)
          .borderRadiusAll(FortalTokens.radius5())
          .labelStyle(FortalTokens.text4.mix()),
  };
}
