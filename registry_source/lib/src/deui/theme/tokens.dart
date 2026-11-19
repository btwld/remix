import 'package:flutter/animation.dart';
import 'package:remix/remix.dart';

/// A value that changes at a breakpoint: [mobile] by default, [desktop] from
/// the one the CSS names.
typedef DeuiResponsive = ({double mobile, double desktop});

/// Semantic names from the pinned Deui web theme.
abstract final class DeuiTokens {
  static const white = ColorToken('deui.color.white');
  static const black = ColorToken('deui.color.black');
  static const snow = ColorToken('deui.color.snow');
  static const eclipse = ColorToken('deui.color.eclipse');
  static const accent = ColorToken('deui.color.accent');
  static const accentForeground = ColorToken('deui.color.accent-foreground');
  static const success = ColorToken('deui.color.success');
  static const successForeground = ColorToken('deui.color.success-foreground');
  static const fieldBorder = ColorToken('deui.color.field-border');
  static const background = ColorToken('deui.color.background');
  static const foreground = ColorToken('deui.color.foreground');
  static const surface = ColorToken('deui.color.surface');
  static const surfaceForeground = ColorToken('deui.color.surface-foreground');
  static const surfaceSecondary = ColorToken('deui.color.surface-secondary');
  static const surfaceSecondaryForeground = ColorToken(
    'deui.color.surface-secondary-foreground',
  );
  static const surfaceTertiary = ColorToken('deui.color.surface-tertiary');
  static const surfaceTertiaryForeground = ColorToken(
    'deui.color.surface-tertiary-foreground',
  );
  static const overlay = ColorToken('deui.color.overlay');
  static const overlayForeground = ColorToken('deui.color.overlay-foreground');
  static const muted = ColorToken('deui.color.muted');
  static const defaultColor = ColorToken('deui.color.default');
  static const defaultForeground = ColorToken('deui.color.default-foreground');
  static const fieldBackground = ColorToken('deui.color.field-background');
  static const fieldForeground = ColorToken('deui.color.field-foreground');
  static const fieldPlaceholder = ColorToken('deui.color.field-placeholder');
  static const warning = ColorToken('deui.color.warning');
  static const warningForeground = ColorToken('deui.color.warning-foreground');
  static const danger = ColorToken('deui.color.danger');

  /// Deui's teal accent, distinct from the blue [accent] (deui's `primary`).
  static const highlight = ColorToken('deui.color.highlight');
  static const highlightForeground = ColorToken(
    'deui.color.highlight-foreground',
  );
  static const dangerForeground = ColorToken('deui.color.danger-foreground');
  static const segment = ColorToken('deui.color.segment');
  static const segmentForeground = ColorToken('deui.color.segment-foreground');
  static const border = ColorToken('deui.color.border');
  static const separator = ColorToken('deui.color.separator');
  static const focus = ColorToken('deui.color.focus');
  static const link = ColorToken('deui.color.link');
  static const backdrop = ColorToken('deui.color.backdrop');
  static const surfaceHover = ColorToken('deui.color.surface-hover');
  static const backgroundSecondary = ColorToken(
    'deui.color.background-secondary',
  );
  static const backgroundTertiary = ColorToken(
    'deui.color.background-tertiary',
  );
  static const backgroundInverse = ColorToken('deui.color.background-inverse');
  static const defaultHover = ColorToken('deui.color.default-hover');
  static const accentHover = ColorToken('deui.color.accent-hover');
  static const successHover = ColorToken('deui.color.success-hover');
  static const warningHover = ColorToken('deui.color.warning-hover');
  static const dangerHover = ColorToken('deui.color.danger-hover');
  static const fieldHover = ColorToken('deui.color.field-hover');
  static const fieldFocus = ColorToken('deui.color.field-focus');
  static const fieldBorderHover = ColorToken('deui.color.field-border-hover');
  static const fieldBorderFocus = ColorToken('deui.color.field-border-focus');
  static const defaultSoft = ColorToken('deui.color.default-soft');
  static const defaultSoftForeground = ColorToken(
    'deui.color.default-soft-foreground',
  );
  static const defaultSoftHover = ColorToken('deui.color.default-soft-hover');
  static const accentSoft = ColorToken('deui.color.accent-soft');
  static const accentSoftForeground = ColorToken(
    'deui.color.accent-soft-foreground',
  );
  static const accentSoftHover = ColorToken('deui.color.accent-soft-hover');
  static const dangerSoft = ColorToken('deui.color.danger-soft');
  static const dangerSoftForeground = ColorToken(
    'deui.color.danger-soft-foreground',
  );
  static const dangerSoftHover = ColorToken('deui.color.danger-soft-hover');
  static const warningSoft = ColorToken('deui.color.warning-soft');
  static const warningSoftForeground = ColorToken(
    'deui.color.warning-soft-foreground',
  );
  static const warningSoftHover = ColorToken('deui.color.warning-soft-hover');
  static const successSoft = ColorToken('deui.color.success-soft');
  static const successSoftForeground = ColorToken(
    'deui.color.success-soft-foreground',
  );
  static const successSoftHover = ColorToken('deui.color.success-soft-hover');
  static const separatorSecondary = ColorToken(
    'deui.color.separator-secondary',
  );
  static const separatorTertiary = ColorToken('deui.color.separator-tertiary');
  static const borderSecondary = ColorToken('deui.color.border-secondary');
  static const borderTertiary = ColorToken('deui.color.border-tertiary');
  static const radiusXs = RadiusToken('deui.radius.xs');
  static const radiusSm = RadiusToken('deui.radius.sm');
  static const radiusMd = RadiusToken('deui.radius.md');
  static const radiusLg = RadiusToken('deui.radius.lg');
  static const radiusXl = RadiusToken('deui.radius.xl');
  static const radius2xl = RadiusToken('deui.radius.2xl');
  static const radius3xl = RadiusToken('deui.radius.3xl');
  static const radius4xl = RadiusToken('deui.radius.4xl');
  static const radiusField = RadiusToken('deui.radius.field');
  static const radiusPanel = RadiusToken('deui.radius.panel');
  static const textXs = TextStyleToken('deui.text.xs');
  static const textSm = TextStyleToken('deui.text.sm');
  static const textBase = TextStyleToken('deui.text.base');

  /// Tailwind `sm` and `md`; responsive recipes are mobile-first.
  static const breakpointSm = 640.0;
  static const breakpointMd = 768.0;

  /// `--disabled-opacity`.
  static const disabledOpacity = 0.5;

  /// `focus-ring`: `ring-2` with `--ring-offset-width: 2px`.
  static const focusWidth = 2.0;
  static const ringOffset = 2.0;

  /// `invalid-field-ring`: a 1px outline.
  static const invalidWidth = 1.0;

  /// `--ease-smooth` (CSS `ease`) and Tailwind's `--ease-out`.
  static const easeSmooth = Curves.ease;
  static const easeOut = Cubic(0, 0, .2, 1);

  /// `--ease-out-quart` (themes/shared/theme.css:127).
  static const easeOutQuart = Cubic(0.165, 0.84, 0.44, 1);

  /// `--ease-out-quad` (themes/shared/theme.css:125).
  static const easeOutQuad = Cubic(0.25, 0.46, 0.45, 0.94);

  /// `--ease-out-fluid` (themes/shared/theme.css:132).
  static const easeOutFluid = Cubic(0.32, 0.72, 0, 1);

  /// Tailwind's default `transition` curve, `cubic-bezier(0.4, 0, 0.2, 1)`.
  static const easeDefault = Cubic(0.4, 0, 0.2, 1);

  /// `background-color 100ms var(--ease-out)`: the fill change of buttons and
  /// the controls styled like them.
  static const fillMotion = CurveAnimationConfig(
    duration: Duration(milliseconds: 100),
    curve: easeOut,
  );

  /// `150ms var(--ease-smooth)`: the state change of `input.css` and
  /// `select.css` (`background-color, border-color`) and of `tabs.css`, which
  /// also moves color, shadow, and opacity at this timing.
  static const smoothMotion = CurveAnimationConfig(
    duration: Duration(milliseconds: 150),
    curve: easeSmooth,
  );

  /// `background-color 200ms var(--ease-out)`: the fill of a checkbox or radio
  /// control (`checkbox.css`, `radio.css`).
  static const selectionMotion = CurveAnimationConfig(
    duration: Duration(milliseconds: 200),
    curve: easeOut,
  );

  /// `transform 250ms var(--ease-out-quart)`: the press scale of the close
  /// button, the dropdown trigger, and menu rows (`close-button.css`,
  /// `dropdown.css`, `menu-item.css`).
  static const transformMotion = CurveAnimationConfig(
    duration: Duration(milliseconds: 250),
    curve: easeOutQuart,
  );

  /// CSS `transparent`: the fill of the `ghost`, `outline`, and `tertiary`
  /// variants, and the resting colour of the secondary tab's indicator edge.
  static const transparent = Color(0x00000000);
}
