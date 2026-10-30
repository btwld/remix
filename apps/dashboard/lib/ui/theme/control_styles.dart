import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import 'tokens.dart';

/// Ui's focus ring: solid step 8, 2px wide, with a 2px gap.
/// Tokens resolve at the control, so nested themes and overrides work.
/// The outline takes no layout space and never replaces the control's border.
RemixBoxEffectsMix uiFocusOutline() => RemixBoxEffectsMix(
  outline: BorderSideMix(
    color: UiTokens.focus8(),
    width: UiTokens.focusRingWidth(),
  ),
  outlineOffset: UiTokens.focusRingOffset(),
);

/// Keeps compact visual sizes while giving controls a 40px interaction area.
/// This wraps the painted child inside Naked UI's existing gesture target.
WidgetModifierConfig uiTouchTarget() =>
    WidgetModifierConfig.modifier(const _UiTouchTargetMix());

final class _UiTouchTargetMix extends ModifierMix<_UiTouchTarget> {
  const _UiTouchTargetMix();

  @override
  _UiTouchTarget resolve(BuildContext context) =>
      _UiTouchTarget(UiTokens.touchTargetMin.resolve(context));

  @override
  _UiTouchTargetMix merge(_UiTouchTargetMix? other) => other ?? this;

  @override
  List<Object?> get props => const [];
}

final class _UiTouchTarget extends WidgetModifier<_UiTouchTarget> {
  const _UiTouchTarget(this.minimum);
  final double minimum;

  @override
  Widget build(Widget child) => ConstrainedBox(
    constraints: BoxConstraints(minWidth: minimum, minHeight: minimum),
    child: Center(widthFactor: 1, heightFactor: 1, child: child),
  );

  @override
  _UiTouchTarget copyWith({double? minimum}) =>
      _UiTouchTarget(minimum ?? this.minimum);

  @override
  _UiTouchTarget lerp(_UiTouchTarget? other, double t) =>
      _UiTouchTarget(minimum + ((other?.minimum ?? minimum) - minimum) * t);

  @override
  List<Object?> get props => [minimum];
}

/// The same outline for surfaces without a Remix effects slot.
/// [inset] measures from content inside an edge-to-edge clipped surface.
WidgetModifierConfig uiFocusRingModifier({
  Radius? radius,
  bool visible = true,
  double inset = 0,
}) => WidgetModifierConfig.modifier(_UiFocusRingMix(radius, visible, inset));

extension UiFocusRingToggle on ToggleStyler {
  ToggleStyler uiFocusRing({Radius? radius}) =>
      container(FlexBoxStyler().wrap(uiFocusRingModifier(radius: radius)));
}

extension UiFocusRingToggleGroup on ToggleGroupItemStyler {
  ToggleGroupItemStyler uiFocusRing({Radius? radius}) =>
      container(FlexBoxStyler().wrap(uiFocusRingModifier(radius: radius)));
}

extension UiFocusRingTab on TabStyler {
  TabStyler uiFocusRing({Radius? radius}) =>
      container(FlexBoxStyler().wrap(uiFocusRingModifier(radius: radius)));
}

extension UiFocusRingDisclosure on DisclosureStyler {
  DisclosureStyler uiFocusRing({Radius? radius}) =>
      trigger(BoxStyler().wrap(uiFocusRingModifier(radius: radius)));
}

extension UiFocusRingFlexBox on FlexBoxStyler {
  FlexBoxStyler uiFocusRing({Radius? radius}) =>
      wrap(uiFocusRingModifier(radius: radius));
}

extension UiFocusRingBox on BoxStyler {
  BoxStyler uiFocusRing({Radius? radius, double inset = 0}) =>
      wrap(uiFocusRingModifier(radius: radius, inset: inset));
}

final class _UiFocusRingMix extends ModifierMix<_UiFocusRingModifier> {
  const _UiFocusRingMix(this.radius, this.visible, this.inset);
  final Radius? radius;
  final bool visible;
  final double inset;

  @override
  _UiFocusRingModifier resolve(BuildContext context) {
    final outline = uiFocusOutline().resolve(context);
    return _UiFocusRingModifier(
      color: visible ? outline.outline.color : const Color(0x00000000),
      width: outline.outline.width,
      offset: outline.outlineOffset,
      inset: MixOps.resolve(context, Prop.value(inset)) ?? 0,
      radius:
          MixOps.resolve(context, Prop.maybe(radius)) ??
          UiTokens.radius2.resolve(context),
    );
  }

  @override
  _UiFocusRingMix merge(_UiFocusRingMix? other) => other ?? this;
  @override
  List<Object?> get props => [radius, visible, inset];
}

final class _UiFocusRingModifier extends WidgetModifier<_UiFocusRingModifier> {
  const _UiFocusRingModifier({
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
  _UiFocusRingModifier copyWith({
    Color? color,
    double? width,
    double? offset,
    Radius? radius,
    double? inset,
  }) => _UiFocusRingModifier(
    color: color ?? this.color,
    width: width ?? this.width,
    offset: offset ?? this.offset,
    radius: radius ?? this.radius,
    inset: inset ?? this.inset,
  );
  @override
  _UiFocusRingModifier lerp(_UiFocusRingModifier? other, double t) =>
      other == null
      ? this
      : _UiFocusRingModifier(
          color: Color.lerp(color, other.color, t)!,
          width: width + (other.width - width) * t,
          offset: offset + (other.offset - offset) * t,
          radius: Radius.lerp(radius, other.radius, t)!,
          inset: inset + (other.inset - inset) * t,
        );
  @override
  Widget build(Widget child) => CustomPaint(
    foregroundPainter: _UiFocusPainter(color, width, offset, radius, inset),
    child: child,
  );
  @override
  List<Object?> get props => [color, width, offset, radius, inset];
}

class _UiFocusPainter extends CustomPainter {
  const _UiFocusPainter(
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
  bool shouldRepaint(_UiFocusPainter old) =>
      color != old.color ||
      width != old.width ||
      offset != old.offset ||
      radius != old.radius ||
      inset != old.inset;
}

/// A crisp inset frame, not an elevation shadow. No blur or offset is used.
RemixBoxEffectLayerMix uiInsetSurface({required List<Color> strokes}) =>
    RemixBoxEffectLayerMix(
      shadows: [
        for (final stroke in strokes)
          RemixBoxShadowMix(
            kind: .inset,
            color: stroke,
            spreadRadius: UiTokens.borderWidth1(),
          ),
      ],
    );
