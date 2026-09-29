// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'callout.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's Callout recipe.
///
/// A callout is a block of text, usually with a leading icon, that says
/// something about the surrounding page. Remix owns the layout and the icon
/// slot; this recipe owns the surface, the outline, and the content colors.
///
/// It is shadcn's alert: the `card` surface inside a `border` hairline with
/// `radiusLg` corners, a 16px by 12px inset, and the icon 12px from `textSm`
/// prose. The icon takes the text's color, so the tone is set in one place.
/// The destructive tone keeps the neutral surface and outline and sets its
/// text in `destructive`, which clears 4.5:1 on `card` in both shipped
/// themes; a solid `destructive` fill would read as a pressed button rather
/// than as a notice.
///
/// There are no interaction fragments. A callout is not a control — anything
/// actionable inside it is a separate button or link with its own recipe.
///
/// [style] is merged **last**, so a single call site can override any part of
/// the resolved recipe without forking it. Because [variant] is a non-nullable
/// enum, the generator also emits one named constructor per enum value:
///
/// ```dart
/// PlaygroundCallout.destructive(
///   icon: warningGlyph,
///   text: 'This deletes the workspace for everyone.',
/// )
/// ```
class PlaygroundCallout extends StatelessWidget {
  const PlaygroundCallout({
    super.key,
    this.variant = .neutral,
    this.style = const CalloutStyler.create(),
    this.text,
    this.icon,
    this.child,
  });

  /// A neutral aside on the `card` surface.
  const PlaygroundCallout.neutral({
    super.key,
    this.style = const CalloutStyler.create(),
    this.text,
    this.icon,
    this.child,
  }) : variant = PlaygroundCalloutVariant.neutral;

  /// A problem the reader has to act on.
  const PlaygroundCallout.destructive({
    super.key,
    this.style = const CalloutStyler.create(),
    this.text,
    this.icon,
    this.child,
  }) : variant = PlaygroundCalloutVariant.destructive;

  final PlaygroundCalloutVariant variant;

  final CalloutStyler style;

  final String? text;

  final IconData? icon;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return RemixCallout(
      key: this.key,
      style: playgroundCalloutStyle(variant: this.variant, style: this.style),
      text: this.text,
      icon: this.icon,
      child: this.child,
    );
  }
}
