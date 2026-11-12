// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'callout.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's Callout recipe.
///
/// The `card` surface inside a `border` hairline with `radiusLg` corners. One
/// content color sets both text and icon. The destructive tone keeps the
/// neutral surface and sets its text in `destructive` (4.5:1 on `card` in both
/// shipped themes); a solid fill would read as a pressed button.
///
/// A callout is not a control, so it has no state fragments.
class VanillaCallout extends StatelessWidget {
  const VanillaCallout({
    super.key,
    this.variant = .neutral,
    this.style = const CalloutStyler.create(),
    this.text,
    this.icon,
    this.child,
  });

  /// A neutral aside on the `card` surface.
  const VanillaCallout.neutral({
    super.key,
    this.style = const CalloutStyler.create(),
    this.text,
    this.icon,
    this.child,
  }) : variant = VanillaCalloutVariant.neutral;

  /// A problem the reader has to act on.
  const VanillaCallout.destructive({
    super.key,
    this.style = const CalloutStyler.create(),
    this.text,
    this.icon,
    this.child,
  }) : variant = VanillaCalloutVariant.destructive;

  final VanillaCalloutVariant variant;

  final CalloutStyler style;

  final String? text;

  final IconData? icon;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return RemixCallout(
      key: this.key,
      style: vanillaCalloutStyle(variant: this.variant, style: this.style),
      text: this.text,
      icon: this.icon,
      child: this.child,
    );
  }
}
