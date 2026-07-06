part of 'divider.dart';

/// Fortal divider thickness presets.
enum FortalDividerSize {
  /// Hairline divider.
  size1,

  /// Medium divider.
  size2,

  /// Thick divider.
  size3,
}

/// Creates a Fortal-themed [RemixDividerStyle].
@MixWidget()
RemixDividerStyle fortalDividerStyle({FortalDividerSize size = .size1}) {
  return RemixDividerStyle()
      .color(FortalTokens.gray6())
      .merge(_fortalDividerSizeStyle(size));
}

RemixDividerStyle _fortalDividerSizeStyle(FortalDividerSize size) {
  return switch (size) {
    .size1 => RemixDividerStyle().thickness(1.0),
    .size2 => RemixDividerStyle().thickness(2.0),
    .size3 => RemixDividerStyle().thickness(3.0),
  };
}
