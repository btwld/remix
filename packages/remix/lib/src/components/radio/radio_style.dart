part of 'radio.dart';

/// Style configuration for [RemixRadio] container and selected indicator.
extension RemixRadioStylerRemixHelpers on RemixRadioStyler {
  /// Creates a RemixRadio widget with this style applied.
  RemixRadio<T> call<T>({
    Key? key,
    required T value,
    bool enabled = true,
    bool toggleable = false,
    MouseCursor? mouseCursor,
    FocusNode? focusNode,
    bool autofocus = false,
  }) {
    return RemixRadio(
      key: key,
      value: value,
      enabled: enabled,
      toggleable: toggleable,
      mouseCursor: mouseCursor,
      focusNode: focusNode,
      autofocus: autofocus,
      style: this,
    );
  }

  /// Sets fill color on the container.
  RemixRadioStyler fillColor(Color value) {
    return merge(
      RemixRadioStyler(
        container: BoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  /// Sets the indicator's fill color.
  RemixRadioStyler indicatorColor(Color value) {
    return merge(
      RemixRadioStyler(
        indicator: BoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }
}
