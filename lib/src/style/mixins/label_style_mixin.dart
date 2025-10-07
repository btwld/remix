import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

/// Mixin that provides convenient label/text styling methods for component styles.
/// 
/// This mixin requires the implementing class to provide a method that accepts
/// a TextStyler and returns the modified component style.
mixin LabelStyleMixin<T extends Mix<Object?>> {
  /// Must be implemented by the class using this mixin
  /// Should merge the provided TextStyler with the component's label/text style
  T label(TextStyler value);

  /// Sets label/text style using TextStyleMix directly
  T labelTextStyle(TextStyleMix value) {
    return label(TextStyler(style: value));
  }

  /// Sets label/text color
  T labelColor(Color value) {
    return label(TextStyler(style: TextStyleMix(color: value)));
  }

  /// Sets label/text font size
  T labelFontSize(double value) {
    return label(TextStyler(style: TextStyleMix(fontSize: value)));
  }

  /// Sets label/text font weight
  T labelFontWeight(FontWeight value) {
    return label(TextStyler(style: TextStyleMix(fontWeight: value)));
  }

  /// Sets label/text font style (italic/normal)
  T labelFontStyle(FontStyle value) {
    return label(TextStyler(style: TextStyleMix(fontStyle: value)));
  }

  /// Sets label/text letter spacing
  T labelLetterSpacing(double value) {
    return label(TextStyler(style: TextStyleMix(letterSpacing: value)));
  }

  /// Sets label/text decoration (underline, strikethrough, etc.)
  T labelDecoration(TextDecoration value) {
    return label(TextStyler(style: TextStyleMix(decoration: value)));
  }

  /// Sets label/text font family
  T labelFontFamily(String value) {
    return label(TextStyler(style: TextStyleMix(fontFamily: value)));
  }

  /// Sets label/text line height
  T labelHeight(double value) {
    return label(TextStyler(style: TextStyleMix(height: value)));
  }

  /// Sets label/text word spacing
  T labelWordSpacing(double value) {
    return label(TextStyler(style: TextStyleMix(wordSpacing: value)));
  }

  /// Sets label/text decoration color
  T labelDecorationColor(Color value) {
    return label(TextStyler(style: TextStyleMix(decorationColor: value)));
  }
}
