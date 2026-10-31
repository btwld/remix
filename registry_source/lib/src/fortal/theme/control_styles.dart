import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import 'tokens.dart';

/// Fortal's focus ring: solid step 8, 2px wide, with a 2px gap.
/// Tokens resolve at the control, so nested themes and overrides work.
/// The outline takes no layout space and never replaces the control's border.
RemixBoxEffectsMix fortalFocusOutline() => RemixBoxEffectsMix(
  outline: BorderSideMix(
    color: FortalTokens.focus8(),
    width: FortalTokens.focusRingWidth(),
  ),
  outlineOffset: FortalTokens.focusRingOffset(),
);

/// Keeps compact visual sizes while giving controls a 40px interaction area.
/// This wraps the painted child inside Naked UI's existing gesture target.
WidgetModifierConfig fortalTouchTarget() =>
    WidgetModifierConfig.modifier(const _FortalTouchTargetMix());

final class _FortalTouchTargetMix extends ModifierMix<_FortalTouchTarget> {
  const _FortalTouchTargetMix();

  @override
  _FortalTouchTarget resolve(BuildContext context) =>
      _FortalTouchTarget(FortalTokens.touchTargetMin.resolve(context));

  @override
  _FortalTouchTargetMix merge(_FortalTouchTargetMix? other) => other ?? this;

  @override
  List<Object?> get props => const [];
}

final class _FortalTouchTarget extends WidgetModifier<_FortalTouchTarget> {
  const _FortalTouchTarget(this.minimum);
  final double minimum;

  @override
  Widget build(Widget child) => ConstrainedBox(
    constraints: BoxConstraints(minWidth: minimum, minHeight: minimum),
    child: Center(widthFactor: 1, heightFactor: 1, child: child),
  );

  @override
  _FortalTouchTarget copyWith({double? minimum}) =>
      _FortalTouchTarget(minimum ?? this.minimum);

  @override
  _FortalTouchTarget lerp(_FortalTouchTarget? other, double t) =>
      _FortalTouchTarget(minimum + ((other?.minimum ?? minimum) - minimum) * t);

  @override
  List<Object?> get props => [minimum];
}

/// The same outline for surfaces without a Remix effects slot.
/// [inset] measures from content inside an edge-to-edge clipped surface.
WidgetModifierConfig fortalFocusRingModifier({
  Radius? radius,
  bool visible = true,
  double inset = 0,
}) =>
    WidgetModifierConfig.modifier(_FortalFocusRingMix(radius, visible, inset));

extension FortalFocusRingToggle on ToggleStyler {
  ToggleStyler fortalFocusRing({Radius? radius}) =>
      container(FlexBoxStyler().wrap(fortalFocusRingModifier(radius: radius)));
}

extension FortalFocusRingToggleGroup on ToggleGroupItemStyler {
  ToggleGroupItemStyler fortalFocusRing({Radius? radius}) =>
      container(FlexBoxStyler().wrap(fortalFocusRingModifier(radius: radius)));
}

extension FortalFocusRingTab on TabStyler {
  TabStyler fortalFocusRing({Radius? radius}) =>
      container(FlexBoxStyler().wrap(fortalFocusRingModifier(radius: radius)));
}

extension FortalFocusRingDisclosure on DisclosureStyler {
  DisclosureStyler fortalFocusRing({Radius? radius}) =>
      trigger(BoxStyler().wrap(fortalFocusRingModifier(radius: radius)));
}

extension FortalFocusRingFlexBox on FlexBoxStyler {
  FlexBoxStyler fortalFocusRing({Radius? radius}) =>
      wrap(fortalFocusRingModifier(radius: radius));
}

extension FortalFocusRingBox on BoxStyler {
  BoxStyler fortalFocusRing({Radius? radius, double inset = 0}) =>
      wrap(fortalFocusRingModifier(radius: radius, inset: inset));
}

final class _FortalFocusRingMix extends ModifierMix<_FortalFocusRingModifier> {
  const _FortalFocusRingMix(this.radius, this.visible, this.inset);
  final Radius? radius;
  final bool visible;
  final double inset;

  @override
  _FortalFocusRingModifier resolve(BuildContext context) {
    final outline = fortalFocusOutline().resolve(context);
    return _FortalFocusRingModifier(
      color: visible ? outline.outline.color : const Color(0x00000000),
      width: outline.outline.width,
      offset: outline.outlineOffset,
      inset: MixOps.resolve(context, Prop.value(inset)) ?? 0,
      radius:
          MixOps.resolve(context, Prop.maybe(radius)) ??
          FortalTokens.radius2.resolve(context),
    );
  }

  @override
  _FortalFocusRingMix merge(_FortalFocusRingMix? other) => other ?? this;
  @override
  List<Object?> get props => [radius, visible, inset];
}

final class _FortalFocusRingModifier
    extends WidgetModifier<_FortalFocusRingModifier> {
  const _FortalFocusRingModifier({
    required this.color,
    required this.width,
    required this.offset,
    required this.radius,
    required this.inset,
  });
  final Color color;
  final double width;
  final double offset;
  final Radius radius;
  final double inset;

  @override
  _FortalFocusRingModifier copyWith({
    Color? color,
    double? width,
    double? offset,
    Radius? radius,
    double? inset,
  }) => _FortalFocusRingModifier(
    color: color ?? this.color,
    width: width ?? this.width,
    offset: offset ?? this.offset,
    radius: radius ?? this.radius,
    inset: inset ?? this.inset,
  );
  @override
  _FortalFocusRingModifier lerp(_FortalFocusRingModifier? other, double t) =>
      other == null
      ? this
      : _FortalFocusRingModifier(
          color: Color.lerp(color, other.color, t)!,
          width: width + (other.width - width) * t,
          offset: offset + (other.offset - offset) * t,
          radius: Radius.lerp(radius, other.radius, t)!,
          inset: inset + (other.inset - inset) * t,
        );
  @override
  Widget build(Widget child) => CustomPaint(
    foregroundPainter: _FortalFocusPainter(color, width, offset, radius, inset),
    child: child,
  );
  @override
  List<Object?> get props => [color, width, offset, radius, inset];
}

class _FortalFocusPainter extends CustomPainter {
  const _FortalFocusPainter(
    this.color,
    this.width,
    this.offset,
    this.radius,
    this.inset,
  );
  final Color color;
  final double width;
  final double offset;
  final Radius radius;
  final double inset;

  @override
  void paint(Canvas canvas, Size size) {
    if (color.a == 0 || width == 0) return;
    final box = RRect.fromRectAndRadius(
      (Offset.zero & size).deflate(inset),
      radius,
    );
    canvas.drawDRRect(
      box.inflate(offset + width),
      box.inflate(offset),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(_FortalFocusPainter old) =>
      color != old.color ||
      width != old.width ||
      offset != old.offset ||
      radius != old.radius ||
      inset != old.inset;
}

/// A crisp inset frame, not an elevation shadow. No blur or offset is used.
RemixBoxEffectLayerMix fortalInsetSurface({required List<Color> strokes}) =>
    RemixBoxEffectLayerMix(
      shadows: [
        for (final stroke in strokes)
          RemixBoxShadowMix(
            kind: .inset,
            color: stroke,
            spreadRadius: FortalTokens.borderWidth1(),
          ),
      ],
    );
