// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'radio.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// Ui-themed preset for [RemixRadio].
class UiRadio<T> extends StatelessWidget {
  const UiRadio({
    super.key,
    this.variant = .surface,
    this.size = .size2,
    this.highContrast = false,
    this.style = const RadioStyler.create(),
    required this.value,
    this.label,
    this.semanticLabel,
    this.minimumTapTargetSize = Size.zero,
    this.enabled = true,
    this.toggleable = false,
    this.mouseCursor,
    this.focusNode,
    this.autofocus = false,
    this.excludeSemantics = false,
  });

  /// Raised treatment with Radix's classic shadow and gradient layers.
  const UiRadio.classic({
    super.key,
    this.size = .size2,
    this.highContrast = false,
    this.style = const RadioStyler.create(),
    required this.value,
    this.label,
    this.semanticLabel,
    this.minimumTapTargetSize = Size.zero,
    this.enabled = true,
    this.toggleable = false,
    this.mouseCursor,
    this.focusNode,
    this.autofocus = false,
    this.excludeSemantics = false,
  }) : variant = UiRadioVariant.classic;

  /// Surface treatment with neutral border.
  const UiRadio.surface({
    super.key,
    this.size = .size2,
    this.highContrast = false,
    this.style = const RadioStyler.create(),
    required this.value,
    this.label,
    this.semanticLabel,
    this.minimumTapTargetSize = Size.zero,
    this.enabled = true,
    this.toggleable = false,
    this.mouseCursor,
    this.focusNode,
    this.autofocus = false,
    this.excludeSemantics = false,
  }) : variant = UiRadioVariant.surface;

  /// Soft accent treatment.
  const UiRadio.soft({
    super.key,
    this.size = .size2,
    this.highContrast = false,
    this.style = const RadioStyler.create(),
    required this.value,
    this.label,
    this.semanticLabel,
    this.minimumTapTargetSize = Size.zero,
    this.enabled = true,
    this.toggleable = false,
    this.mouseCursor,
    this.focusNode,
    this.autofocus = false,
    this.excludeSemantics = false,
  }) : variant = UiRadioVariant.soft;

  final UiRadioVariant variant;

  final UiRadioSize size;

  final bool highContrast;

  final RadioStyler style;

  final T value;

  final String? label;

  final String? semanticLabel;

  final Size minimumTapTargetSize;

  final bool enabled;

  final bool toggleable;

  final MouseCursor? mouseCursor;

  final FocusNode? focusNode;

  final bool autofocus;

  final bool excludeSemantics;

  @override
  Widget build(BuildContext context) {
    return RemixRadio<T>(
      key: this.key,
      style: uiRadioStyle(
        variant: this.variant,
        size: this.size,
        highContrast: this.highContrast,
        style: this.style,
      ),
      value: this.value,
      label: this.label,
      semanticLabel: this.semanticLabel,
      minimumTapTargetSize: this.minimumTapTargetSize,
      enabled: this.enabled,
      toggleable: this.toggleable,
      mouseCursor: this.mouseCursor,
      focusNode: this.focusNode,
      autofocus: this.autofocus,
      excludeSemantics: this.excludeSemantics,
    );
  }
}
