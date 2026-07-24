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

/// Fortal-themed preset for [RemixDivider].
@MixWidget(
  name: 'FortalDivider',
  target: RemixDivider.new,
  factoryParameters: .only({'size'}),
)
RemixDividerStyler fortalDividerStyler({FortalDividerSize size = .size1}) {
  return RemixDividerStyler()
      .color(FortalTokens.gray6())
      .merge(_fortalDividerSizeStyler(size));
}

RemixDividerStyler _fortalDividerSizeStyler(FortalDividerSize size) {
  return switch (size) {
    .size1 => RemixDividerStyler().thickness(1.0),
    .size2 => RemixDividerStyler().thickness(2.0),
    .size3 => RemixDividerStyler().thickness(3.0),
  };
}

/// Fortal-themed preset for [RemixDivider].
