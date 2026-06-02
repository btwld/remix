part of 'divider.dart';

enum FortalDividerSize {
  size1, // hairline
  size2, // medium
  size3, // thick
}

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
