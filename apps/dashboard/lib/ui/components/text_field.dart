// `DragStartBehavior` and `MaxLengthEnforcement` appear in the generated
// `UiTextField`/`UiTextArea` constructors, so they must be visible from
// this library even though nothing here references them directly.
import 'dart:ui' show ImageFilter;

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../motion/motion.dart';
import '../theme/theme.dart';

part 'text_field.g.dart';

/// The sizes a text field comes in. Pixel values are at 100% theme scaling.
///
/// Typed text is 14px at every size.
enum UiTextFieldSize {
  /// 32px tall.
  size1,

  /// 40px tall. The default.
  size2,

  /// 44px tall.
  size3,
}

/// The looks a text field comes in.
enum UiTextFieldVariant {
  /// The surface fill inside a 1px strong frame.
  surface,

  /// The muted surface fill with no frame until hovered or focused.
  soft,
}

/// The Fortal TextField recipe.
///
/// It reads top to bottom: what every text input shares, then the size, then
/// the variant's colors for rest, hover, focus and disabled, then the error
/// state.
///
/// Focus darkens the frame to the text color; the focus ring shows only under
/// the theme's high contrast switch. An error frame holds through hover and
/// focus, and the label keeps its color. The helper and error rows open on a
/// spring, fade in and settle up into place, and close on the same spring.
@MixWidget(target: RemixTextField.new)
TextFieldStyler uiTextFieldStyle({
  UiTextFieldVariant variant = .surface,
  UiTextFieldSize size = .size2,
  TextFieldStyler style = const TextFieldStyler.create(),
}) => _input(
  size: _fieldSize(size),
  look: _look(variant),
  disabledOpacity: 0.5,
).merge(style);

/// The sizes a text area comes in. Pixel values are at 100% theme scaling.
///
/// Typed text is 14px at every size.
enum UiTextAreaSize {
  /// At least 88px tall.
  size1,

  /// At least 110px tall. The default.
  size2,

  /// At least 121px tall.
  size3,
}

/// The Fortal TextArea recipe: the text field's looks on a taller box whose
/// content starts at the top, with 12px padding on every side.
@MixWidget(target: RemixTextArea.new)
TextFieldStyler uiTextAreaStyle({
  UiTextFieldVariant variant = .surface,
  UiTextAreaSize size = .size2,
  TextFieldStyler style = const TextFieldStyler.create(),
}) => _input(
  size: _areaSize(size),
  look: _look(variant),
  disabledOpacity: 0.6,
).merge(style);

TextFieldStyler _look(UiTextFieldVariant variant) => switch (variant) {
  .surface => _framed(rest: UiTokens.controlBorder(), fill: UiTokens.gray2()),
  .soft => _framed(rest: _softFrame(), fill: UiTokens.gray3()),
};

/// A text field or area: the shared base, then [size] and [look], then the
/// error and disabled states.
TextFieldStyler _input({
  required TextFieldStyler size,
  required TextFieldStyler look,
  required double disabledOpacity,
}) => _base()
    .merge(size)
    .merge(look)
    .variant(ContextVariant.widgetState(.error), _error())
    .onDisabled(
      TextFieldStyler()
          .containerEffects(.outline(.style(.none)))
          .container(BoxStyler().wrap(.opacity(disabledOpacity))),
    )
    // The input container sits inside Remix's chrome gesture detector.
    // An outer wrapper would reserve space without accepting its taps.
    .container(BoxStyler().wrap(uiTouchTarget()))
    .animate(
      AnimationConfig.curve(
        duration: UiMotion.fast,
        curve: UiMotion.easeStandard,
      ),
    );

/// What every text input shares: label and message rows, cursor, icon color,
/// and the focus ring the theme's high contrast switch turns on.
///
/// The layout has no gap of its own. The label carries the space below it
/// and each message row the space above it, so a row that closes takes its
/// gap with it.
///
/// The empty effect layers give the variant's state fragments layers to
/// replace.
TextFieldStyler _base() =>
    TextFieldStyler(
          label: TextStyler(style: UiTokens.text2.mix())
              .color(UiTokens.gray12())
              .fontWeight(UiTokens.fontWeightMedium())
              .wrap(.padding(.only(bottom: UiTokens.space2()))),
          helperText: _message(_mutedContent()),
          errorText: _message(UiTokens.error11()),
          text: TextStyler(
            style: UiTokens.textField.mix(),
          ).color(UiTokens.gray12()).selectionColor(UiTokens.focusA5()),
          hintText: TextStyler(style: UiTokens.textField.mix())
              .color(_mutedContent())
              .textHeightBehavior(
                TextHeightBehaviorMix()
                    .applyHeightToFirstAscent(false)
                    .applyHeightToLastDescent(true),
              ),
          cursorColor: UiTokens.gray12(),
          cursorWidth: 1.5,
          containerEffects: RemixBoxEffectsMix(
            behindContent: RemixBoxEffectLayerMix(),
            overContent: RemixBoxEffectLayerMix(),
          ),
          messageTransition: RemixFieldMessageTransition(
            duration: UiSpringCurve.smooth.duration,
            builder: _messageMotion,
          ),
        )
        .layout(FlexBoxStyler().spacing(0))
        .wrap(.iconTheme(color: _mutedContent(), size: UiTokens.space4()))
        .onFocused(.containerEffects(_highContrastFocusOutline()));

/// A helper or error row: 12px text with the row's gap above it.
TextStyler _message(Color color) => TextStyler(
  style: UiTokens.text1.mix(),
).color(color).wrap(.padding(.only(top: UiTokens.space2())));

/// The box of a text field: one line, centered.
TextFieldStyler _fieldSize(UiTextFieldSize size) => _sized(
  minHeight: _fieldHeight(size)(),
  padding: EdgeInsetsMix.symmetric(
    horizontal: _framedInset(),
    vertical: _fieldPaddingY(size)(),
  ),
  crossAxisAlignment: .center,
);

/// The box of a text area: a fixed share of the field height, with its
/// content starting at the top.
TextFieldStyler _areaSize(UiTextAreaSize size) => _sized(
  minHeight: _areaMinHeight(size)(),
  padding: EdgeInsetsMix.all(_framedInset()),
  crossAxisAlignment: .start,
);

TextFieldStyler _sized({
  required double minHeight,
  required EdgeInsetsMix padding,
  required CrossAxisAlignment crossAxisAlignment,
}) => TextFieldStyler(
  container: BoxStyler()
      .minHeight(minHeight)
      .padding(padding)
      .borderRadius(.all(UiTokens.radius4OrFull()))
      .clipBehavior(.antiAlias),
  spacing: UiTokens.space2(),
  crossAxisAlignment: crossAxisAlignment,
);

ContextToken<double> _fieldHeight(UiTextFieldSize size) => ContextToken<double>(
  (context) => switch (size) {
    .size1 => UiTokens.controlHeight1,
    .size2 => UiTokens.controlHeight2,
    .size3 => UiTokens.controlHeight3,
  }.resolve(context),
);

/// A text area is 2.75 field heights tall at rest: 110px beside the 40px field.
ContextToken<double> _areaMinHeight(UiTextAreaSize size) =>
    ContextToken<double>(
      (context) =>
          _fieldHeight(switch (size) {
            .size1 => UiTextFieldSize.size1,
            .size2 => UiTextFieldSize.size2,
            .size3 => UiTextFieldSize.size3,
          }).resolve(context) *
          2.75,
    );

/// The 12px content inset plus the 1px frame, which is painted inset and
/// takes no layout space of its own.
final _framedInset = ContextToken<double>(
  (context) =>
      UiTokens.space3.resolve(context) + UiTokens.borderWidth1.resolve(context),
);

/// Vertical padding that centers one line of text in a field's height.
///
/// The engine lays a 19.6px line out on 20 pixels, so the padding is measured
/// against the rounded-up line. This keeps the 32, 40 and 44px field heights
/// and a centered baseline at 1x, while leaving the text line unconstrained
/// as MediaQuery text scaling increases.
ContextToken<double> _fieldPaddingY(UiTextFieldSize size) =>
    ContextToken<double>((context) {
      final style = UiTokens.textField.resolve(context);

      return (_fieldHeight(size).resolve(context) -
              (style.fontSize! * style.height!).ceilToDouble()) /
          2;
    });

/// The variant's [fill] inside a 1px frame that is [rest] at rest and the
/// text color while hovered or focused. Disabled moves the fill to the muted
/// surface and keeps the resting frame.
TextFieldStyler _framed({required Color rest, required Color fill}) =>
    TextFieldStyler()
        .color(fill)
        .merge(_frame(rest))
        .onHovered(_frame(UiTokens.gray12()))
        .onFocused(_frame(UiTokens.gray12()))
        .onDisabled(
          TextFieldStyler().color(UiTokens.gray3()).merge(_frame(rest)),
        );

/// The error frame, over whichever variant is active. It holds through hover
/// and focus; the label keeps its color.
TextFieldStyler _error() =>
    _frame(UiTokens.error8()).cursorColor(UiTokens.error9());

/// A 1px inset frame of [color] over the content, with nothing behind it.
TextFieldStyler _frame(Color color) => TextFieldStyler()
    .containerEffects(
      RemixBoxEffectsMix.behindContent(RemixBoxEffectLayerMix()),
    )
    .containerEffects(
      RemixBoxEffectsMix.overContent(uiInsetSurface(strokes: [color])),
    );

bool _themeHighContrast(BuildContext context) =>
    UiTheme.maybeOf(context)?.highContrast ?? false;

/// A soft field shows no frame at rest, or the control border once the theme
/// asks for high contrast so an unlabelled field can still be found.
final _softFrame = ContextToken<Color>(
  (context) => _themeHighContrast(context)
      ? UiTokens.controlBorder.resolve(context)
      : UiTokens.gray3.resolve(context).withValues(alpha: 0),
);

/// Hint, helper and icon content: gray 10, or gray 11 once the theme asks for
/// high contrast so it reads at 4.5:1.
final _mutedContent = ContextToken<Color>(
  (context) => _themeHighContrast(context)
      ? UiTokens.gray11.resolve(context)
      : UiTokens.gray10.resolve(context),
);

/// The focus ring, drawn only under the theme's high contrast switch.
RemixBoxEffectsMix _highContrastFocusOutline() => uiFocusOutline().merge(
  RemixBoxEffectsMix(outline: BorderSideMix(color: _focusRingColor())),
);

final _focusRingColor = ContextToken<Color>(
  (context) => _themeHighContrast(context)
      ? UiTokens.focus8.resolve(context)
      : UiTokens.focus8.resolve(context).withValues(alpha: 0),
);

/// A message row opens its height on the smooth spring while it fades in over
/// 150ms and its copy rises 0.35em out of a 4px blur over 200ms. It closes
/// its height on the same spring and fades out over 100ms.
Widget _messageMotion(
  BuildContext context,
  RemixFieldMessageTransitionInfo info,
  Widget row,
) {
  final span = UiSpringCurve.smooth.duration;
  final rise = UiTokens.text1.resolve(context).fontSize! * 0.35;

  double progress(Duration elapsed, Duration over) =>
      (elapsed.inMicroseconds / over.inMicroseconds).clamp(0.0, 1.0);

  return AnimatedBuilder(
    animation: info.animation,
    builder: (context, child) {
      final t = info.animation.value;
      final leaving = info.animation.status == .reverse;
      final elapsed = span * (leaving ? 1 - t : t);
      final double height;
      final double opacity;
      var settle = 1.0;
      if (leaving) {
        height = 1 - UiSpringCurve.smooth.transform(1 - t);
        opacity = 1 - progress(elapsed, UiMotion.instant);
      } else {
        height = UiSpringCurve.smooth.transform(t);
        opacity = progress(elapsed, UiMotion.fast);
        settle = UiMotion.easeEnter.transform(
          progress(elapsed, UiMotion.standard),
        );
      }
      final blur = (1 - settle) * UiMotion.blurSoft;

      return ClipRect(
        child: Align(
          alignment: AlignmentDirectional.topStart,
          heightFactor: height.clamp(0.0, 1.0),
          child: Opacity(
            opacity: opacity,
            child: Transform.translate(
              offset: Offset(0, (1 - settle) * rise),
              child: blur > 0
                  ? ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                      child: child,
                    )
                  : child,
            ),
          ),
        ),
      );
    },
    child: row,
  );
}
