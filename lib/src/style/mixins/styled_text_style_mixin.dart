import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

/// Mixin that provides convenient text styling methods for component styles.
/// 
/// This mixin requires the implementing class to provide a method that accepts
/// a TextStyler and returns the modified component style.
mixin StyledTextStyleMixin<T extends Mix<Object?>> {
  /// Must be implemented by the class using this mixin
  /// Should merge the provided TextStyler with the component's text style
  T text(TextStyler value);

  /// Sets text style using TextStyleMix directly
  T textStyle(TextStyleMix value) {
    return text(TextStyler(style: value));
  }

  /// Sets text color
  T textColor(Color value) {
    return text(TextStyler(style: TextStyleMix(color: value)));
  }

  /// Sets text font size
  T fontSize(double value) {
    return text(TextStyler(style: TextStyleMix(fontSize: value)));
  }

  /// Sets text font weight
  T fontWeight(FontWeight value) {
    return text(TextStyler(style: TextStyleMix(fontWeight: value)));
  }

  /// Sets text font style (italic/normal)
  T fontStyle(FontStyle value) {
    return text(TextStyler(style: TextStyleMix(fontStyle: value)));
  }

  /// Sets text letter spacing
  T letterSpacing(double value) {
    return text(TextStyler(style: TextStyleMix(letterSpacing: value)));
  }

  /// Sets text decoration (underline, strikethrough, etc.)
  T textDecoration(TextDecoration value) {
    return text(TextStyler(style: TextStyleMix(decoration: value)));
  }

  /// Sets text font family
  T fontFamily(String value) {
    return text(TextStyler(style: TextStyleMix(fontFamily: value)));
  }

  /// Sets text line height
  T textHeight(double value) {
    return text(TextStyler(style: TextStyleMix(height: value)));
  }

  /// Sets text word spacing
  T wordSpacing(double value) {
    return text(TextStyler(style: TextStyleMix(wordSpacing: value)));
  }

  /// Sets text decoration color
  T textDecorationColor(Color value) {
    return text(TextStyler(style: TextStyleMix(decorationColor: value)));
  }
}
