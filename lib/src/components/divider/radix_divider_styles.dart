// ABOUTME: Factory for creating RemixDividerStyle instances using Radix tokens
// ABOUTME: Adds size presets and neutral color mapping

import '../../radix/radix.dart';
import 'divider.dart';

enum RadixDividerSize {
  size1, // hairline
  size2, // medium
  size3, // thick
}

class RadixDividerStyles {
  const RadixDividerStyles._();

  static RemixDividerStyle create({RadixDividerSize size = RadixDividerSize.size1}) {
    return base(size: size);
  }

  static RemixDividerStyle base({RadixDividerSize size = RadixDividerSize.size1}) {
    // NOTE: JSON exposes "separator-size: 100%" (length), not thickness.
    // We map sizes to typical thickness and a neutral gray color.
    // TODO: Add orientation-aware sizing if/when exposed by spec.
    return RemixDividerStyle()
        .color(RadixTokens.gray6())
        .merge(_sizeStyle(size));
  }

  static RemixDividerStyle _sizeStyle(RadixDividerSize size) {
    return switch (size) {
      RadixDividerSize.size1 => RemixDividerStyle().thickness(1.0),
      RadixDividerSize.size2 => RemixDividerStyle().thickness(2.0),
      RadixDividerSize.size3 => RemixDividerStyle().thickness(3.0),
    };
  }
}
