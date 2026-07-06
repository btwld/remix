part of 'avatar.dart';

/// Fortal avatar size presets.
enum FortalAvatarSize { size1, size2, size3, size4 }

/// Fortal avatar color variants.
enum FortalAvatarVariant { soft, solid }

/// Creates a Fortal-themed [RemixAvatarStyle].
@MixWidget()
RemixAvatarStyle fortalAvatarStyle({
  FortalAvatarVariant variant = .soft,
  FortalAvatarSize size = .size2,
}) {
  return switch (variant) {
    .soft => _fortalAvatarSoftStyle(size),
    .solid => _fortalAvatarSolidStyle(size),
  };
}

RemixAvatarStyle _fortalAvatarBaseStyle(FortalAvatarSize size) {
  return RemixAvatarStyle()
      .clipBehavior(.hardEdge)
      .labelFontWeight(FontWeight.w500)
      .merge(_fortalAvatarSizeStyle(size));
}

RemixAvatarStyle _fortalAvatarSoftStyle([FortalAvatarSize size = .size2]) {
  return _fortalAvatarBaseStyle(size)
      .backgroundColor(FortalTokens.accentA3())
      .foregroundColor(FortalTokens.accentA10());
}

RemixAvatarStyle _fortalAvatarSolidStyle([FortalAvatarSize size = .size2]) {
  return _fortalAvatarBaseStyle(size)
      .backgroundColor(FortalTokens.accent9())
      .foregroundColor(FortalTokens.accentContrast());
}

RemixAvatarStyle _fortalAvatarSizeStyle(FortalAvatarSize size) {
  return switch (size) {
    .size1 =>
      RemixAvatarStyle()
          .square(24.0)
          .borderRadiusAll(FortalTokens.radius2())
          .labelStyle(FortalTokens.text1.mix()),
    .size2 =>
      RemixAvatarStyle()
          .square(32.0)
          .borderRadiusAll(FortalTokens.radius3())
          .labelStyle(FortalTokens.text2.mix()),
    .size3 =>
      RemixAvatarStyle()
          .square(40.0)
          .borderRadiusAll(FortalTokens.radius4())
          .labelStyle(FortalTokens.text3.mix()),
    .size4 =>
      RemixAvatarStyle()
          .square(64.0)
          .borderRadiusAll(FortalTokens.radius5())
          .labelStyle(FortalTokens.text4.mix()),
  };
}
