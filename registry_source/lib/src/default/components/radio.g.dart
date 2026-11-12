// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'radio.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's Radio recipe.
///
/// A 16px ring with an 8px dot. The ring stays `input` whether or not the
/// option is chosen; the dot carries the choice. There is no hover fragment:
/// choosing is the feedback. The label is set like the checkbox's; a radio
/// without one needs a `semanticLabel`.
///
/// `RemixRadioGroup`, which owns `groupValue` and the change callback, has no
/// styler and no recipe. Wrap the options in it directly:
///
/// ```dart
/// RemixRadioGroup<String>(
///   groupValue: plan,
///   onChanged: (value) => setState(() => plan = value),
///   child: Column(children: const [
///     VanillaRadio(value: 'free', label: 'Free'),
///     VanillaRadio(value: 'pro', label: 'Pro'),
///   ]),
/// )
/// ```
class VanillaRadio<T> extends StatelessWidget {
  const VanillaRadio({
    super.key,
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
      style: vanillaRadioStyle(style: this.style),
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
