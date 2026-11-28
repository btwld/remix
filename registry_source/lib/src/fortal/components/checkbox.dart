import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../motion/motion.dart';
import '../theme/theme.dart';

part 'checkbox.g.dart';

/// The sizes a checkbox comes in. Pixel values are at 100% theme scaling.
enum FortalCheckboxSize {
  /// A 14px square with a 4px corner.
  size1,

  /// An 18px square with a 5px corner. The default.
  size2,

  /// A 20px square with a 5.5px corner.
  size3,
}

/// The looks a checkbox comes in.
enum FortalCheckboxVariant {
  /// A surface square inside a 1px strong frame, filled with the control ink
  /// when selected.
  surface,

  /// The surface square at rest; selected, a 10% control-ink tint inside a
  /// control-ink frame, with a control-ink mark.
  soft,
}

/// The Fortal Checkbox recipe.
///
/// It reads top to bottom: the square, then the variant's frame, fill and
/// mark, then press, disabled and the focus ring around the touch target.
/// The fill and mark are drawn by [_FortalCheckMark], which springs the fill
/// in from 60%, draws the check on and morphs it into the dash.
///
/// [highContrast] moves the selected fill (surface) or mark (soft) to accent
/// step 12.
@MixWidget(target: RemixCheckbox.new)
CheckboxStyler fortalCheckboxStyle({
  FortalCheckboxVariant variant = .surface,
  FortalCheckboxSize size = .size2,
  bool highContrast = false,
  CheckboxStyler style = const CheckboxStyler.create(),
}) => _square(size)
    .merge(switch (variant) {
      .surface => _surface(size, highContrast),
      .soft => _soft(size, highContrast),
    })
    .onPressed(CheckboxStyler().scale(0.95))
    .animate(_motion)
    .wrap(fortalTouchTarget())
    // The ring circles the 40px box inside the 48px tap target with the
    // control corner, not the small square.
    .onFocusVisible(
      CheckboxStyler().wrap(
        fortalFocusRingModifier(radius: const .circular(14), inset: 4),
      ),
    )
    .onDisabled(CheckboxStyler().wrap(.opacity(0.5)))
    .merge(style);

/// The Fortal CheckboxGroupItem recipe: the checkbox recipe plus a label and
/// an optional description under it.
///
/// It exists because `RemixCheckboxGroup` is behavioral and carries no styler,
/// so, unlike the menu, select, segmented control and toggle group items, there
/// is no parent recipe to push item styling down. Radio group items are the
/// same. Without this,
/// callers hand-attach a styler to each item and a missed one in a loop renders
/// unstyled beside its styled siblings.
@MixWidget(target: RemixCheckboxGroupItem.new)
CheckboxStyler fortalCheckboxGroupItemStyle({
  FortalCheckboxVariant variant = .surface,
  FortalCheckboxSize size = .size2,
  bool highContrast = false,
  CheckboxStyler style = const CheckboxStyler.create(),
}) => fortalCheckboxStyle(
  variant: variant,
  size: size,
  highContrast: highContrast,
).merge(_copy(size)).merge(style);

/// Frame colour and press scale: 150 ms on the standard ease.
final _motion = AnimationConfig.curve(
  duration: FortalMotion.fast,
  curve: FortalMotion.easeStandard,
);

/// Mark stroke of each step at 100% scaling.
const _strokes = <FortalCheckboxSize, double>{
  .size1: 1.5,
  .size2: 1.75,
  .size3: 1.75,
};

/// The square of each step and the box its fill and mark are drawn in.
CheckboxStyler _square(FortalCheckboxSize size) {
  final (side, corner, mark) = switch (size) {
    .size1 => (
      FortalTokens.checkboxSize1(),
      FortalTokens.checkboxRadius1(),
      FortalTokens.checkboxIndicatorSize1(),
    ),
    .size2 => (
      FortalTokens.checkboxSize2(),
      FortalTokens.checkboxRadius2(),
      FortalTokens.checkboxIndicatorSize2(),
    ),
    .size3 => (
      FortalTokens.checkboxSize3(),
      FortalTokens.checkboxRadius3(),
      FortalTokens.checkboxSize3(),
    ),
  };

  return CheckboxStyler(
    container: .size(side, side).alignment(.center).borderRadius(.all(corner)),
    indicator: .size(mark),
    containerEffects: RemixBoxEffectsMix(
      behindContent: RemixBoxEffectLayerMix(),
    ),
  ).controlAlignment(.start);
}

/// Medium foreground label 12px from the square, and a muted description
/// 2px under it.
CheckboxStyler _copy(FortalCheckboxSize size) {
  final (label, description) = switch (size) {
    .size1 => (FortalTokens.text1, FortalTokens.text1),
    .size2 => (FortalTokens.text2, FortalTokens.text1),
    .size3 => (FortalTokens.text3, FortalTokens.text2),
  };

  return CheckboxStyler()
      .label(
        TextStyler()
            .style(label.mix())
            .fontWeight(FortalTokens.fontWeightMedium())
            .color(FortalTokens.gray12()),
      )
      .labelSpacing(FortalTokens.space3())
      .description(
        TextStyler().style(description.mix()).color(FortalTokens.gray10()),
      )
      .descriptionSpacing(2);
}

/// A surface square in a strong frame that darkens on hover; selected, the
/// frame and fill take the control ink under a glyph-coloured mark.
CheckboxStyler _surface(FortalCheckboxSize size, bool highContrast) {
  final ink = highContrast
      ? FortalTokens.accent12
      : FortalTokens.accentIndicator;
  final selected = _frame(ink()).color(ink());

  return _rest()
      .indicatorColor(
        highContrast
            ? FortalTokens.accent1()
            : FortalTokens.accentIndicatorContrast(),
      )
      .indicatorBuilder(_mark(size, ink))
      .onSelected(selected)
      .onIndeterminate(selected);
}

/// The surface square at rest; selected, a 10% tint of the control ink
/// inside a control-ink frame, with a control-ink mark.
CheckboxStyler _soft(FortalCheckboxSize size, bool highContrast) {
  final ink = highContrast
      ? FortalTokens.accent12
      : FortalTokens.accentIndicator;
  final selected = _frame(ink()).color(_tint(ink)()).indicatorColor(ink());

  return _rest()
      .indicatorBuilder(_mark(size, ink, tint: true))
      .onSelected(selected)
      // The painted fill carries the tint; the frame and mark follow.
      .onIndeterminate(_frame(ink()).indicatorColor(ink()));
}

/// The control ink at 10%, one token per ink so equal arguments build equal
/// styles.
ContextToken<Color> _tint(ColorToken ink) => _tints.putIfAbsent(
  ink,
  () => ContextToken<Color>((c) => ink.resolve(c).withValues(alpha: 0.1)),
);
final _tints = <ColorToken, ContextToken<Color>>{};

CheckboxStyler _rest() => CheckboxStyler()
    .color(FortalTokens.colorSurface())
    .merge(_frame(FortalTokens.controlBorder()))
    .onHovered(_frame(FortalTokens.gray10()));

/// A 1px inset frame over the content in [color].
CheckboxStyler _frame(Color color) => CheckboxStyler().containerEffects(
  RemixBoxEffectsMix.overContent(fortalInsetSurface(strokes: [color])),
);

/// The fill and mark painter of a step, one builder per step and fill so
/// equal arguments build equal styles.
RemixCheckboxIndicatorBuilder _mark(
  FortalCheckboxSize size,
  ColorToken ink, {
  bool tint = false,
}) => _marks.putIfAbsent((size, ink, tint), () {
  final fill = tint ? _tint(ink).resolve : ink.resolve;

  return (context, value, indicator) {
    final scaling = FortalTheme.of(context).scaling.factor;
    final side = indicator.spec.size ?? 18 * scaling;

    return _FortalCheckMark(
      value: value,
      fill: fill(context),
      ink: indicator.spec.color ?? const Color(0xFFFFFFFF),
      side: side,
      corner: switch (size) {
        .size1 => FortalTokens.checkboxRadius1,
        .size2 => FortalTokens.checkboxRadius2,
        .size3 => FortalTokens.checkboxRadius3,
      }.resolve(context).x,
      stroke: _strokes[size]! * scaling,
    );
  };
});
final _marks =
    <(FortalCheckboxSize, ColorToken, bool), RemixCheckboxIndicatorBuilder>{};

/// The selected fill and the stroked check or dash of a checkbox.
///
/// The fill springs from 60% and fades in over 100 ms (out over 150 ms); the
/// check draws on along its length on the snappy spring; check and dash
/// morph point by point on the morph spring. Reduced motion jumps.
class _FortalCheckMark extends StatefulWidget {
  const _FortalCheckMark({
    required this.value,
    required this.fill,
    required this.ink,
    required this.side,
    required this.corner,
    required this.stroke,
  });

  /// Checked, unchecked, or null for indeterminate.
  final bool? value;
  final Color fill;
  final Color ink;
  final double side;
  final double corner;
  final double stroke;

  @override
  State<_FortalCheckMark> createState() => _FortalCheckMarkState();
}

class _FortalCheckMarkState extends State<_FortalCheckMark>
    with SingleTickerProviderStateMixin {
  late final _clock = FortalMotionClock(this, () => setState(() {}));
  late final _on = _clock.channel(widget.value == false ? 0 : 1);
  late final _opacity = _clock.channel(widget.value == false ? 0 : 1);
  late final _dash = _clock.channel(widget.value == null ? 1 : 0);

  @override
  void didUpdateWidget(_FortalCheckMark old) {
    super.didUpdateWidget(old);
    if (old.value == widget.value) return;
    final jump = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final on = widget.value != false;
    _clock
      ..animate(_on, on ? 1 : 0, FortalTiming.snappy, jump: jump)
      ..animate(
        _opacity,
        on ? 1 : 0,
        on ? FortalTiming.instant : FortalTiming.fade,
        jump: jump,
      );
    // Leaving keeps the shape it had; from unchecked the mark starts as the
    // shape it lands on.
    if (on) {
      _clock.animate(
        _dash,
        widget.value == null ? 1 : 0,
        FortalTiming.morph,
        jump: jump || old.value == false,
      );
    }
  }

  @override
  void dispose() {
    _clock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: .square(widget.side),
    painter: _CheckMarkPainter(
      on: _on.value,
      opacity: _opacity.value.clamp(0, 1),
      dash: _dash.value,
      fill: widget.fill,
      ink: widget.ink,
      corner: widget.corner,
      stroke: widget.stroke,
    ),
  );
}

class _CheckMarkPainter extends CustomPainter {
  const _CheckMarkPainter({
    required this.on,
    required this.opacity,
    required this.dash,
    required this.fill,
    required this.ink,
    required this.corner,
    required this.stroke,
  });

  final double on;
  final double opacity;
  final double dash;
  final Color fill;
  final Color ink;
  final double corner;
  final double stroke;

  // The mark on an 18-unit grid: a three-point check and a three-point dash,
  // so one morphs into the other point by point.
  static const _check = [
    Offset(4.25, 9.25),
    Offset(7.25, 12.25),
    Offset(13.75, 5.75),
  ];
  static const _dashPoints = [Offset(4.75, 9), Offset(9, 9), Offset(13.25, 9)];

  @override
  void paint(Canvas canvas, Size size) {
    if (opacity <= 0) return;
    final scale = lerpDouble(0.6, 1, on)!;
    final box = Rect.fromCenter(
      center: size.center(.zero),
      width: size.width * scale,
      height: size.height * scale,
    );
    canvas.drawRRect(
      .fromRectAndRadius(box, .circular(corner * scale)),
      Paint()..color = fill.withValues(alpha: fill.a * opacity),
    );

    final unit = size.width / 18;
    final path = Path();
    for (var i = 0; i < 3; i++) {
      final p = Offset.lerp(_check[i], _dashPoints[i], dash)! * unit;
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    final metric = path.computeMetrics().first;
    canvas.drawPath(
      metric.extractPath(0, metric.length * on.clamp(0, 1)),
      Paint()
        ..color = ink.withValues(alpha: ink.a * opacity)
        ..style = .stroke
        ..strokeWidth = stroke
        ..strokeCap = .round
        ..strokeJoin = .round,
    );
  }

  @override
  bool shouldRepaint(_CheckMarkPainter old) =>
      on != old.on ||
      opacity != old.opacity ||
      dash != old.dash ||
      fill != old.fill ||
      ink != old.ink ||
      corner != old.corner ||
      stroke != old.stroke;
}
