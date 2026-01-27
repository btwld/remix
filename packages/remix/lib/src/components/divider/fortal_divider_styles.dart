part of 'divider.dart';

enum FortalDividerSize {
  size1, // hairline
  size2, // medium
  size3, // thick
}

class FortalDividerStyles {
  const FortalDividerStyles._();

  static RemixDividerStyle create({
    FortalDividerSize size = .size1,
  }) {
    return base(size: size);
  }

  static RemixDividerStyle base({
    FortalDividerSize size = .size1,
  }) {
    // NOTE: JSON exposes "separator-size: 100%" (length), not thickness.
    // We map sizes to typical thickness and a neutral gray color. Orientation
    // is handled by RemixDividerStyle rather than this factory.
    return RemixDividerStyle()
        .color(FortalTokens.gray6())
        .merge(_sizeStyle(size));
  }

  static RemixDividerStyle _sizeStyle(FortalDividerSize size) {
    return switch (size) {
      .size1 => RemixDividerStyle().thickness(1.0),
      .size2 => RemixDividerStyle().thickness(2.0),
      .size3 => RemixDividerStyle().thickness(3.0),
    };
  }
}
