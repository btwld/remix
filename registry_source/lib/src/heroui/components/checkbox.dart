import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'checkbox.g.dart';

/// HeroUI checkbox variants.
enum HeroUiCheckboxVariant {
  /// The field surface fill, with its shadow.
  primary,

  /// The `default` fill.
  secondary,
}

/// HeroUI recipe for [RemixCheckbox].
///
/// [invalid] paints the error treatment; validation stays with the app.
/// [minimumTapTargetSize] sets the widget's default tap target to 24px, the
/// size of HeroUI's `touch-target` utility; the style itself does not read it.
@MixWidget(target: RemixCheckbox.new)
CheckboxStyler heroUiCheckboxStyle({
  HeroUiCheckboxVariant variant = .primary,
  bool invalid = false,
  Size minimumTapTargetSize = heroUiCheckboxTapTarget,
  CheckboxStyler style = const CheckboxStyler.create(),
}) {
  final field = switch (variant) {
    .primary => heroUiPrimaryFieldFill,
    .secondary => heroUiSecondaryFieldFill,
  };
  final fill = invalid ? HeroUiTokens.danger : HeroUiTokens.accent;
  final mark = invalid
      ? HeroUiTokens.dangerForeground
      : HeroUiTokens.accentForeground;
  final label = invalid ? HeroUiTokens.danger : HeroUiTokens.foreground;

  return CheckboxStyler()
      .size(_control, _control)
      .alignment(.center)
      .borderRadius(.all(HeroUiTokens.radiusMd()))
      .color(field.rest())
      .indicator(.size(_checkmark).color(mark()))
      .label(heroUiLabelText.color(label()))
      .labelSpacing(heroUiControlGap)
      .onSelected(.color(fill()))
      .onIndeterminate(.color(fill()).indicator(.size(_indeterminate)))
      .onFocusVisible(.containerEffects(heroUiFocusRing()))
      .animate(HeroUiTokens.selectionMotion)
      .merge(
        variant == .primary
            ? CheckboxStyler().containerEffects(heroUiSurfaceEffects())
            : null,
      )
      .merge(
        variant == .primary && !invalid
            ? CheckboxStyler().onHovered(
                CheckboxStyler().onSelected(.color(HeroUiTokens.accentHover())),
              )
            : null,
      )
      .merge(
        invalid
            // The 1px danger outline shows only while unselected.
            ? CheckboxStyler()
                  .containerEffects(heroUiInvalidRing())
                  .onSelected(.containerEffects(.outline(.style(.none))))
                  .onIndeterminate(.containerEffects(.outline(.style(.none))))
            : CheckboxStyler().onIndeterminate(
                CheckboxStyler().onPressed(.color(HeroUiTokens.accentHover())),
              ),
      )
      .onDisabled(
        CheckboxStyler()
            .label(.color(heroUiDisabledLabelColor(danger: invalid)()))
            .wrap(.opacity(HeroUiTokens.disabledOpacity)),
      )
      .merge(style);
}

/// The 24px square of the `touch-target` utility (`utilities/index.css`)
/// around the 16px control. Upstream draws that utility as an overlay and
/// `checkbox.css` 3.2.6 does not apply it; here it is a layout minimum.
const heroUiCheckboxTapTarget = Size.square(24);

/// `.checkbox__control`: `size-4`.
const _control = 16.0;

/// The check mark svg's `size-2.5` and the indeterminate line's `size-3`
/// (`checkbox.css`). Remix's glyphs nearly fill their box, so the box sizes
/// the mark.
const _checkmark = 10.0;
const _indeterminate = 12.0;
