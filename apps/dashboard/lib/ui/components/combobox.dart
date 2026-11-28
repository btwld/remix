// Codegen validates the expanded optionsBuilder signature, including FutureOr,
// before emitting its typedef. Keep that type visible to the generator.
// ignore: unused_import
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../motion/motion.dart';
import '../theme/theme.dart';
import 'text_field.dart';

part 'combobox.g.dart';

/// The Fortal Combobox recipe: an editable field with a panel of suggestions.
///
/// The field takes TextField's recipe with its own frame: a quiet frame at
/// rest, the strong frame over the muted fill while hovered or open, and the
/// accent frame while focused with the panel closed. The panel is the raised
/// surface 8px below the field; it grows in on the snappy spring and leaves
/// faster than it came. Suggestions are 36px rows that take the muted fill
/// under the pointer, the keyboard and a press.
///
/// Remix owns filtering callbacks, traversal, acceptance and scrolling.
/// Eligible suggestions have no persistent selected or per-option disabled
/// state; acceptance writes the value into the field. A custom field builder
/// owns its editor styling. Caller overrides merge last.
@MixWidget(target: RemixCombobox.new)
ComboboxStyler uiComboboxStyle({
  UiTextFieldVariant variant = .surface,
  UiTextFieldSize size = .size2,
  ComboboxStyler style = const ComboboxStyler.create(),
}) {
  final highlighted = ComboboxOptionStyler().color(UiTokens.gray3());

  return ComboboxStyler()
      .field(
        uiTextFieldStyle(variant: variant, size: size).merge(_field(variant)),
      )
      .panel(
        ComboboxPanelStyler()
            .margin(.top(UiTokens.space2()))
            .maxHeight(300)
            .scrollbarColor(UiTokens.gray9())
            .scrollbarThickness(0)
            .borderRadius(.all(UiTokens.radius6()))
            .color(UiTokens.colorPanelSolid())
            .padding(.all(_panelInset()))
            .border(
              .all(.color(UiTokens.gray7()).width(UiTokens.borderWidth1())),
            )
            .decoration(
              BoxDecorationMix.create(boxShadow: UiTokens.shadow5.mix()),
            )
            .panelTransition(
              RemixPanelTransition(
                duration: UiSpringCurve.snappy.duration,
                reverseDuration: UiMotion.instant,
                reducedMotionDuration: UiMotion.instant,
                builder: _panelMotion,
              ),
            ),
      )
      .option(
        ComboboxOptionStyler()
            .minHeight(_optionHeight())
            .padding(
              .symmetric(
                horizontal: UiTokens.space3(),
                vertical: _optionPaddingY(),
              ),
            )
            .borderRadius(.all(_optionRadius()))
            .label(
              TextStyler(style: UiTokens.text2.mix()).color(UiTokens.gray12()),
            )
            .onHovered(highlighted)
            .onFocused(highlighted)
            .onPressed(highlighted)
            .animate(
              AnimationConfig.curve(
                duration: const Duration(milliseconds: 80),
                curve: UiMotion.easeStandard,
              ),
            ),
      )
      .merge(style);
}

/// The field's own frame over the text field look. Focus with the panel
/// closed draws the accent frame; the open panel and the pointer draw the
/// strong frame over the muted fill, and the pointer wins over focus.
TextFieldStyler _field(UiTextFieldVariant variant) {
  final engaged = _frame(UiTokens.gray8()).color(UiTokens.gray3());
  final rest = switch (variant) {
    .surface => _frame(UiTokens.gray7()),
    .soft => TextFieldStyler(),
  };

  return rest
      .onFocused(_frame(UiTokens.accent9()))
      .onSelected(engaged)
      .onHovered(engaged)
      .onDisabled(rest)
      .variant(ContextVariant.widgetState(.error), _frame(UiTokens.error8()));
}

TextFieldStyler _frame(Color color) => TextFieldStyler().containerEffects(
  RemixBoxEffectsMix.overContent(uiInsetSurface(strokes: [color])),
);

/// [px] at the theme's scaling.
ContextToken<double> _scaled(double px) => ContextToken<double>(
  (context) => px * UiTokens.space1.resolve(context) / 4,
);

final _panelInset = _scaled(5);
final _optionHeight = _scaled(36);

/// The panel's 20px corner less its 5px inset, so rows sit concentric.
final _optionRadius = ContextToken<Radius>(
  (context) =>
      UiTokens.radius6.resolve(context) -
      Radius.circular(_panelInset.resolve(context)),
);

// SpaceToken placeholders cannot participate in arithmetic before resolution.
final _optionPaddingY = ContextToken<double>(
  (context) => UiTokens.space3.resolve(context) / 2,
);

/// The panel rises 6px and grows from 0.97 at its top edge on the snappy
/// spring while it fades in over 150ms on the enter ease. It leaves 4px up
/// to 0.98 over 100ms on the standard ease. Under reduced motion it only
/// fades.
Widget _panelMotion(
  BuildContext context,
  RemixPanelTransitionInfo info,
  Widget panel,
) {
  final span = UiSpringCurve.snappy.duration;

  return RemixReducedMotionBuilder(
    builder: (context, reduceMotion) => AnimatedBuilder(
      animation: info.animation,
      builder: (context, child) {
        final t = info.animation.value;
        if (reduceMotion) return Opacity(opacity: t, child: child);
        final leaving =
            info.animation.status == .reverse ||
            info.animation.status == .dismissed;
        final double travel;
        final double opacity;
        if (leaving) {
          final gone = UiMotion.easeStandard.transform(1 - t);
          travel = gone;
          opacity = 1 - gone;
        } else {
          travel = 1 - UiSpringCurve.snappy.transform(t);
          final faded = (span.inMicroseconds * t / UiMotion.fast.inMicroseconds)
              .clamp(0.0, 1.0);
          opacity = UiMotion.easeEnter.transform(faded);
        }
        final scale = 1 - (leaving ? 0.02 : 0.03) * travel;

        return Opacity(
          opacity: opacity.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, (leaving ? -4 : -6) * travel),
            child: Transform.scale(
              scale: scale,
              alignment: Alignment.topCenter,
              child: child,
            ),
          ),
        );
      },
      child: panel,
    ),
  );
}
