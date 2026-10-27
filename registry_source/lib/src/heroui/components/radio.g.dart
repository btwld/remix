// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'radio.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// HeroUI recipe for [RemixRadio], the bare control.
///
/// Labels and descriptions are the app's composition; see `HeroUiRadioGroup`.
/// [invalid] paints the error treatment; validation stays with the app.
class HeroUiRadio<T> extends StatelessWidget {
  const HeroUiRadio({
    super.key,
    this.variant = .primary,
    this.invalid = false,
    this.style = const RadioStyler.create(),
    required this.value,
    required this.semanticLabel,
    this.enabled = true,
    this.toggleable = false,
    this.mouseCursor,
    this.focusNode,
    this.autofocus = false,
    this.excludeSemantics = false,
  });

  const HeroUiRadio.primary({
    super.key,
    this.invalid = false,
    this.style = const RadioStyler.create(),
    required this.value,
    required this.semanticLabel,
    this.enabled = true,
    this.toggleable = false,
    this.mouseCursor,
    this.focusNode,
    this.autofocus = false,
    this.excludeSemantics = false,
  }) : variant = HeroUiRadioVariant.primary;

  const HeroUiRadio.secondary({
    super.key,
    this.invalid = false,
    this.style = const RadioStyler.create(),
    required this.value,
    required this.semanticLabel,
    this.enabled = true,
    this.toggleable = false,
    this.mouseCursor,
    this.focusNode,
    this.autofocus = false,
    this.excludeSemantics = false,
  }) : variant = HeroUiRadioVariant.secondary;

  final HeroUiRadioVariant variant;

  final bool invalid;

  final RadioStyler style;

  final T value;

  final String semanticLabel;

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
      style: heroUiRadioStyle(
        variant: this.variant,
        invalid: this.invalid,
        style: this.style,
      ),
      value: this.value,
      semanticLabel: this.semanticLabel,
      enabled: this.enabled,
      toggleable: this.toggleable,
      mouseCursor: this.mouseCursor,
      focusNode: this.focusNode,
      autofocus: this.autofocus,
      excludeSemantics: this.excludeSemantics,
    );
  }
}
