import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../theme/theme.dart';

part 'number_field.g.dart';

/// The sizes a number field comes in. Pixel values are at 100% theme scaling.
enum FortalNumberFieldSize {
  /// A 32px shell with 24px steps, 14px value text and a 164px width.
  size1,

  /// A 40px shell with 30px steps, 15px value text and a 196px width. The
  /// default.
  size2,

  /// A 44px shell with 34px steps, 17px value text and a 228px width.
  size3,
}

bool _themeHighContrast(BuildContext context) =>
    FortalTheme.maybeOf(context)?.highContrast ?? false;

/// The shell's resting frame: the quiet border, or the control border once the
/// theme asks for high contrast.
final _restBorder = ContextToken<Color>(
  (context) => _themeHighContrast(context)
      ? FortalTokens.controlBorder.resolve(context)
      : FortalTokens.gray7.resolve(context),
);

final _pressFill = ContextToken<Color>(
  (context) => FortalTokens.gray12.resolve(context).withValues(alpha: .1),
);

final _selection = ContextToken<Color>(
  (context) => FortalTokens.gray12.resolve(context).withValues(alpha: .16),
);

/// The Fortal Number Field recipe: a rounded shell with a minus step, the
/// value centered in medium tabular figures, and a plus step.
///
/// It reads top to bottom: the column, the label and helper text, the shell
/// at rest, hovered, focused and disabled, the editor, both steps, then the
/// size.
///
/// The shell draws no focus ring: focus darkens its border to the text
/// color. The steps are quiet glyphs that gain a muted fill on hover and a
/// stronger one, with the glyph pressed in, while held. A step at its bound
/// fades.
///
/// [highContrast] moves the resting border to the control border and the
/// helper text to gray step 11. The theme's high contrast switch moves the
/// border too.
@MixWidget(target: RemixNumberField.new)
NumberFieldStyler fortalNumberFieldStyle({
  FortalNumberFieldSize size = .size2,
  bool highContrast = false,
  NumberFieldStyler style = const NumberFieldStyler.create(),
}) {
  final metrics = _metrics(size);
  final border = highContrast ? FortalTokens.controlBorder() : _restBorder();

  NumberFieldStepStyler step(IconData icon) => NumberFieldStepStyler()
      .size(metrics.step, metrics.step)
      .borderRadius(.circular(metrics.stepRadius))
      .color(const Color(0x00000000))
      .icon(IconStyler(icon: icon, size: _glyph, color: FortalTokens.gray11()))
      .iconScale(1)
      .onHovered(
        NumberFieldStepStyler()
            .color(FortalTokens.gray3())
            .icon(IconStyler(color: FortalTokens.gray12())),
      )
      .onPressed(
        NumberFieldStepStyler()
            .color(_pressFill())
            .icon(IconStyler(color: FortalTokens.gray12()))
            .iconScale(.82),
      )
      .onDisabled(NumberFieldStepStyler().wrap(.opacity(.32)))
      .animate(.easeOut(FortalMotion.fast));

  return NumberFieldStyler()
      .layout(FlexBoxStyler().spacing(8))
      .label(
        TextStyler()
            .fontSize(metrics.label)
            .fontWeight(FortalTokens.fontWeightMedium())
            .height(1.4)
            .letterSpacing(-.01 * metrics.label)
            .color(FortalTokens.gray12()),
      )
      .helperText(
        TextStyler()
            .fontSize(12)
            .height(1.4)
            .letterSpacing(-.12)
            .fontFeatures([const FontFeature.tabularFigures()])
            .color(
              highContrast ? FortalTokens.gray11() : FortalTokens.gray10(),
            ),
      )
      .container(
        BoxStyler()
            .width(metrics.width)
            .height(metrics.height)
            .padding(.all(metrics.inset))
            .borderRadius(.circular(14))
            .border(.all(.color(border).width(1)))
            .color(FortalTokens.gray2()),
      )
      .spacing(2)
      .onHovered(
        NumberFieldStyler().container(
          BoxStyler().border(.all(.color(FortalTokens.gray8()))),
        ),
      )
      .onFocused(
        NumberFieldStyler().container(
          BoxStyler().border(.all(.color(FortalTokens.gray12()))),
        ),
      )
      .onDisabled(
        NumberFieldStyler().container(
          BoxStyler()
              .border(.all(.color(border)))
              .color(FortalTokens.gray3())
              .wrap(.opacity(.5)),
        ),
      )
      .field(
        TextFieldStyler(
              textAlign: .center,
              cursorWidth: _cursorWidth,
              cursorColor: FortalTokens.gray12(),
            )
            // The editor keeps the caret's width plus 1px free at the end of the
            // line, which pulls centered text left by half of that. The same
            // inset at the start puts the value back on the shell's center.
            .container(BoxStyler().padding(.only(left: _cursorWidth + 1)))
            .text(
              TextStyler()
                  .fontSize(metrics.text)
                  .fontWeight(FortalTokens.fontWeightMedium())
                  .height(1.4)
                  .letterSpacing(-.01 * metrics.text)
                  .fontFeatures([const FontFeature.tabularFigures()])
                  .color(FortalTokens.gray12())
                  .selectionColor(_selection()),
            ),
      )
      .decrement(step(RemixIcons.minus))
      .increment(step(RemixIcons.plus))
      .animate(.easeOut(FortalMotion.fast))
      .merge(style);
}

const _cursorWidth = 1.5;

// The plus and minus glyphs fill most of their box, so a 12.5px box draws
// the 10.5px marks Fortal's steps call for.
const _glyph = 12.5;

typedef _Metrics = ({
  double height,
  double step,
  double inset,
  double text,
  double width,
  double stepRadius,
  double label,
});

_Metrics _metrics(FortalNumberFieldSize size) => switch (size) {
  .size1 => (
    height: 32,
    step: 24,
    inset: 3,
    text: 14,
    width: 164,
    stepRadius: 10,
    label: 12,
  ),
  .size2 => (
    height: 40,
    step: 30,
    inset: 3,
    text: 15,
    width: 196,
    stepRadius: 10,
    label: 13,
  ),
  .size3 => (
    height: 44,
    step: 34,
    inset: 4,
    text: 17,
    width: 228,
    stepRadius: 9,
    label: 13,
  ),
};
