import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'switch.g.dart';

/// Fortal switch size presets.
enum FortalSwitchSize {
  /// Compact switch.
  size1,

  /// Default switch.
  size2,

  /// Large switch.
  size3,
}

/// Fortal switch color variants.
enum FortalSwitchVariant {
  /// Surface treatment with a visible border.
  surface,

  /// Softer accent treatment.
  soft,
}

/// Fortal-themed preset for [RemixSwitch].
@MixWidget(target: RemixSwitch.new)
SwitchStyler fortalSwitchStyle({
  FortalSwitchVariant variant = .surface,
  FortalSwitchSize size = .size2,
  bool highContrast = false,
  SwitchStyler style = const SwitchStyler.create(),
}) {
  return (switch (variant) {
    .surface => _fortalSwitchSurfaceStyler(size, highContrast: highContrast),
    .soft => _fortalSwitchSoftStyler(size, highContrast: highContrast),
  }).wrap(fortalTouchTarget()).merge(style);
}

SwitchStyler _fortalSwitchBaseStyler(FortalSwitchSize size) {
  final metrics = _fortalSwitchMetrics(size);
  return SwitchStyler(
        container: .size(
          metrics.width,
          metrics.height,
        ).padding(.all(1)).borderRadius(.all(metrics.radius)),
        thumb: .size(
          metrics.thumbSize,
          metrics.thumbSize,
        ).borderRadius(.all(metrics.radius)),
        trackEffects: RemixBoxEffectsMix(
          behindContent: _fortalSwitchLayer(),
          overContent: _fortalSwitchLayer(),
        ),
      )
      .thumbColor(const Color(0xFFFFFFFF))
      .onFocusVisible(.trackEffects(fortalFocusOutline()));
}

SwitchStyler _fortalSwitchSurfaceStyler(
  FortalSwitchSize size, {
  required bool highContrast,
}) {
  return _fortalSwitchBaseStyler(size)
      .trackColor(FortalTokens.grayA3())
      .trackEffects(RemixBoxEffectsMix.behindContent(_fortalSwitchLayer()))
      .trackEffects(
        RemixBoxEffectsMix.overContent(
          _fortalSwitchInsetRing(FortalTokens.grayA5()),
        ),
      )
      .thumb(
        _fortalSwitchThumbStyler(selected: false, highContrast: highContrast),
      )
      .onSelected(
        SwitchStyler()
            .trackColor(
              highContrast
                  ? FortalTokens.accent12()
                  : FortalTokens.accentTrack(),
            )
            .trackEffects(
              RemixBoxEffectsMix.behindContent(_fortalSwitchLayer()),
            )
            .thumb(
              _fortalSwitchThumbStyler(
                selected: true,
                highContrast: highContrast,
              ),
            ),
      )
      .onPressed(
        SwitchStyler()
            .trackColor(FortalTokens.grayA4())
            .onSelected(
              SwitchStyler().trackColor(
                highContrast
                    ? FortalTokens.accent12()
                    : FortalTokens.accent10(),
              ),
            )
            .trackEffects(
              RemixBoxEffectsMix.behindContent(_fortalSwitchLayer()),
            ),
      )
      .onDisabled(_fortalSwitchDisabledStyler());
}

SwitchStyler _fortalSwitchSoftStyler(
  FortalSwitchSize size, {
  required bool highContrast,
}) {
  return _fortalSwitchBaseStyler(size)
      .trackColor(FortalTokens.grayA3())
      .trackEffects(RemixBoxEffectsMix.behindContent(_fortalSwitchLayer()))
      .thumb(
        _fortalSwitchSoftThumbStyler(
          selected: false,
          highContrast: highContrast,
        ),
      )
      .onSelected(
        SwitchStyler()
            .trackColor(
              highContrast ? FortalTokens.accentA6() : FortalTokens.accentA4(),
            )
            .trackEffects(
              RemixBoxEffectsMix.behindContent(_fortalSwitchLayer()),
            )
            .thumb(
              _fortalSwitchSoftThumbStyler(
                selected: true,
                highContrast: highContrast,
              ),
            ),
      )
      .onPressed(
        SwitchStyler()
            .trackColor(FortalTokens.grayA4())
            .onSelected(
              SwitchStyler().trackColor(
                highContrast
                    ? FortalTokens.accentA7()
                    : FortalTokens.accentA5(),
              ),
            )
            .trackEffects(
              RemixBoxEffectsMix.behindContent(_fortalSwitchLayer()),
            ),
      )
      .onDisabled(_fortalSwitchDisabledStyler(soft: true));
}

({double width, double height, double thumbSize, Radius radius})
_fortalSwitchMetrics(FortalSwitchSize size) {
  final height = switch (size) {
    .size1 => FortalTokens.space4(),
    .size2 => FortalTokens.switchHeight2(),
    .size3 => FortalTokens.space5(),
  };
  final width = switch (size) {
    .size1 => FortalTokens.switchWidth1(),
    .size2 => FortalTokens.switchWidth2(),
    .size3 => FortalTokens.switchWidth3(),
  };
  final thumbSize = switch (size) {
    .size1 => FortalTokens.switchThumbSize1(),
    .size2 => FortalTokens.switchThumbSize2(),
    .size3 => FortalTokens.switchThumbSize3(),
  };
  final radius = switch (size) {
    .size1 => FortalTokens.radius1OrThumb(),
    .size2 || .size3 => FortalTokens.radius2OrThumb(),
  };
  return (width: width, height: height, thumbSize: thumbSize, radius: radius);
}

SwitchStyler _fortalSwitchDisabledStyler({bool soft = false}) => SwitchStyler()
    .trackColor(soft ? FortalTokens.grayA4() : FortalTokens.grayA3())
    .thumbColor(FortalTokens.gray2())
    .thumb(
      .border(
        .all(.color(FortalTokens.gray6()).width(FortalTokens.borderWidth1())),
      ),
    )
    .trackEffects(RemixBoxEffectsMix(outline: BorderSideMix(style: .none)));

BoxStyler _fortalSwitchThumbStyler({
  required bool selected,
  required bool highContrast,
}) => BoxStyler()
    .color(
      selected
          ? (highContrast
                ? FortalTokens.accent1()
                : FortalTokens.accentContrast())
          : const Color(0xFFFFFFFF),
    )
    .border(
      .all(.color(FortalTokens.gray7()).width(FortalTokens.borderWidth1())),
    );

BoxStyler _fortalSwitchSoftThumbStyler({
  required bool selected,
  required bool highContrast,
}) => BoxStyler()
    .color(
      selected
          ? (highContrast ? FortalTokens.accent12() : FortalTokens.accent11())
          : const Color(0xFFFFFFFF),
    )
    .border(
      .all(.color(FortalTokens.gray7()).width(FortalTokens.borderWidth1())),
    );

RemixBoxEffectLayerMix _fortalSwitchInsetRing(Color color) =>
    _fortalSwitchLayer(
      shadows: [RemixBoxShadowMix(kind: .inset, color: color, spreadRadius: 1)],
    );

RemixBoxEffectLayerMix _fortalSwitchLayer({
  List<RemixBoxShadowMix>? shadows,
  RemixBoxShadowListToken? shadowToken,
}) => RemixBoxEffectLayerMix(shadows: shadows, shadowToken: shadowToken);
