import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'checkbox.g.dart';

/// HeroUI checkbox variants.
enum UiCheckboxVariant {
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
CheckboxStyler uiCheckboxStyle({
  UiCheckboxVariant variant = .primary,
  bool invalid = false,
  Size minimumTapTargetSize = uiCheckboxTapTarget,
  CheckboxStyler style = const CheckboxStyler.create(),
}) {
  final field = switch (variant) {
    .primary => uiPrimaryFieldFill,
    .secondary => uiSecondaryFieldFill,
  };
  final fill = invalid ? UiTokens.danger : UiTokens.accent;
  final mark = invalid ? UiTokens.dangerForeground : UiTokens.accentForeground;
  final label = invalid ? UiTokens.danger : UiTokens.foreground;

  return CheckboxStyler()
      .size(_control, _control)
      .alignment(.center)
      .borderRadius(.all(UiTokens.radiusMd()))
      .color(field.rest())
      .indicator(.size(_checkmark).color(mark()))
      .label(uiLabelText.color(label()))
      .labelSpacing(uiControlGap)
      .onSelected(.color(fill()))
      .onIndeterminate(.color(fill()).indicator(.size(_indeterminate)))
      .onFocusVisible(.containerEffects(uiFocusRing()))
      .animate(UiTokens.selectionMotion)
      .merge(
        variant == .primary
            ? CheckboxStyler().containerEffects(uiSurfaceEffects())
            : null,
      )
      .merge(
        variant == .primary && !invalid
            ? CheckboxStyler().onHovered(
                CheckboxStyler().onSelected(.color(UiTokens.accentHover())),
              )
            : null,
      )
      .merge(
        invalid
            // The 1px danger outline shows only while unselected.
            ? CheckboxStyler()
                  .containerEffects(uiInvalidRing())
                  .onSelected(.containerEffects(.outline(.style(.none))))
                  .onIndeterminate(.containerEffects(.outline(.style(.none))))
            : CheckboxStyler().onIndeterminate(
                CheckboxStyler().onPressed(.color(UiTokens.accentHover())),
              ),
      )
      .onDisabled(
        CheckboxStyler()
            .label(.color(uiDisabledLabelColor(danger: invalid)()))
            .wrap(.opacity(UiTokens.disabledOpacity)),
      )
      .merge(style);
}

/// The 24px square of the `touch-target` utility (`utilities/index.css`)
/// around the 16px control. Upstream draws that utility as an overlay and
/// `checkbox.css` 3.2.6 does not apply it; here it is a layout minimum.
const uiCheckboxTapTarget = Size.square(24);

/// `.checkbox__control`: `size-4`.
const _control = 16.0;

/// The check mark svg's `size-2.5` and the indeterminate line's `size-3`
/// (`checkbox.css`). Remix's glyphs nearly fill their box, so the box sizes
/// the mark.
const _checkmark = 10.0;
const _indeterminate = 12.0;
