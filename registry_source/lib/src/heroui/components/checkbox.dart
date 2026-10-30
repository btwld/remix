import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'checkbox.g.dart';

/// HeroUI checkbox variants: `primary` on the field surface with its shadow,
/// `secondary` on the default fill.
enum HeroUiCheckboxVariant { primary, secondary }

/// HeroUI recipe for [RemixCheckbox].
///
/// [invalid] paints the error treatment; validation stays with the app.
/// [minimumTapTargetSize] sets the widget's default tap target to HeroUI's 24px
/// `touch-target`; the style itself does not read it.
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

  var result = CheckboxStyler()
      .size(_control, _control)
      .alignment(.center)
      .borderRadius(.all(HeroUiTokens.radiusMd()))
      .color(field.rest())
      .indicator(.size(_checkmark).color(mark()))
      .label(heroUiLabelText.color(label()))
      .labelSpacing(_gap)
      .onSelected(.color(fill()))
      .onIndeterminate(.color(fill()).indicator(.size(_indeterminate)))
      .onFocusVisible(.containerEffects(heroUiFocusRing()))
      .animate(HeroUiTokens.selectionMotion);

  if (variant == .primary) {
    result = result.containerEffects(heroUiSurfaceEffects());
    if (!invalid) {
      result = result.onHovered(
        CheckboxStyler().onSelected(.color(HeroUiTokens.accentHover())),
      );
    }
  }
  if (invalid) {
    // The 1px danger outline shows only while unselected.
    result = result
        .containerEffects(heroUiInvalidRing())
        .onSelected(.containerEffects(.outline(.style(.none))))
        .onIndeterminate(.containerEffects(.outline(.style(.none))));
  } else {
    result = result.onIndeterminate(
      CheckboxStyler().onPressed(.color(HeroUiTokens.accentHover())),
    );
  }

  return result
      .onDisabled(
        CheckboxStyler()
            .label(.color(heroUiDisabledLabelColor(danger: invalid)()))
            .wrap(.opacity(HeroUiTokens.disabledOpacity)),
      )
      .merge(style);
}

/// `touch-target`: the 24px square around the 16px control.
const heroUiCheckboxTapTarget = Size.square(24);

/// `.checkbox__control`'s `size-4` and the content row's `gap-3`.
const _control = 16.0;
const _gap = 12.0;

/// The check mark svg's `size-2.5` and the indeterminate line's `size-3`
/// (`checkbox.css`). Remix's glyphs nearly fill their box, so the box sizes
/// the mark.
const _checkmark = 10.0;
const _indeterminate = 12.0;
