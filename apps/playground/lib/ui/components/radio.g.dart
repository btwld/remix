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
///     PlaygroundRadio(value: 'free', label: 'Free'),
///     PlaygroundRadio(value: 'pro', label: 'Pro'),
///   ]),
/// )
/// ```
class PlaygroundRadio<T> extends StatelessWidget {
  const PlaygroundRadio({
    super.key,
    this.style = const RadioStyler.create(),
    required this.value,
    this.label,
    this.description,
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

  final String? description;

  final String? semanticLabel;

  final Size minimumTapTargetSize;

  final bool enabled;

  final bool toggleable;

  final MouseCursor? mouseCursor;

  final FocusNode? focusNode;

  final bool autofocus;

  final bool excludeSemantics;

  @override
  Widget build(BuildContext _) {
    return RemixRadio<T>(
      style: playgroundRadioStyle(style: style),
      value: value,
      label: label,
      description: description,
      semanticLabel: semanticLabel,
      minimumTapTargetSize: minimumTapTargetSize,
      enabled: enabled,
      toggleable: toggleable,
      mouseCursor: mouseCursor,
      focusNode: focusNode,
      autofocus: autofocus,
      excludeSemantics: excludeSemantics,
    );
  }
}
