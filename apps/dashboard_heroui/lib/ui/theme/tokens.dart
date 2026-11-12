import 'package:flutter/animation.dart';
import 'package:remix/remix.dart';

/// A value that changes at a breakpoint: [mobile] by default, [desktop] from
/// the one the CSS names.
typedef UiResponsive = ({double mobile, double desktop});

/// Semantic names from the pinned HeroUI web theme.
abstract final class UiTokens {
  static const white = ColorToken('ui.color.white');
  static const black = ColorToken('ui.color.black');
  static const snow = ColorToken('ui.color.snow');
  static const eclipse = ColorToken('ui.color.eclipse');
  static const accent = ColorToken('ui.color.accent');
  static const accentForeground = ColorToken('ui.color.accent-foreground');
  static const success = ColorToken('ui.color.success');
  static const successForeground = ColorToken('ui.color.success-foreground');
  static const fieldBorder = ColorToken('ui.color.field-border');
  static const background = ColorToken('ui.color.background');
  static const foreground = ColorToken('ui.color.foreground');
  static const surface = ColorToken('ui.color.surface');
  static const surfaceForeground = ColorToken('ui.color.surface-foreground');
  static const surfaceSecondary = ColorToken('ui.color.surface-secondary');
  static const surfaceSecondaryForeground = ColorToken(
    'ui.color.surface-secondary-foreground',
  );
  static const surfaceTertiary = ColorToken('ui.color.surface-tertiary');
  static const surfaceTertiaryForeground = ColorToken(
    'ui.color.surface-tertiary-foreground',
  );
  static const overlay = ColorToken('ui.color.overlay');
  static const overlayForeground = ColorToken('ui.color.overlay-foreground');
  static const muted = ColorToken('ui.color.muted');
  static const defaultColor = ColorToken('ui.color.default');
  static const defaultForeground = ColorToken('ui.color.default-foreground');
  static const fieldBackground = ColorToken('ui.color.field-background');
  static const fieldForeground = ColorToken('ui.color.field-foreground');
  static const fieldPlaceholder = ColorToken('ui.color.field-placeholder');
  static const warning = ColorToken('ui.color.warning');
  static const warningForeground = ColorToken('ui.color.warning-foreground');
  static const danger = ColorToken('ui.color.danger');
  static const dangerForeground = ColorToken('ui.color.danger-foreground');
  static const segment = ColorToken('ui.color.segment');
  static const segmentForeground = ColorToken('ui.color.segment-foreground');
  static const border = ColorToken('ui.color.border');
  static const separator = ColorToken('ui.color.separator');
  static const focus = ColorToken('ui.color.focus');
  static const link = ColorToken('ui.color.link');
  static const backdrop = ColorToken('ui.color.backdrop');
  static const surfaceHover = ColorToken('ui.color.surface-hover');
  static const backgroundSecondary = ColorToken(
    'ui.color.background-secondary',
  );
  static const backgroundTertiary = ColorToken('ui.color.background-tertiary');
  static const backgroundInverse = ColorToken('ui.color.background-inverse');
  static const defaultHover = ColorToken('ui.color.default-hover');
  static const accentHover = ColorToken('ui.color.accent-hover');
  static const successHover = ColorToken('ui.color.success-hover');
  static const warningHover = ColorToken('ui.color.warning-hover');
  static const dangerHover = ColorToken('ui.color.danger-hover');
  static const fieldHover = ColorToken('ui.color.field-hover');
  static const fieldFocus = ColorToken('ui.color.field-focus');
  static const fieldBorderHover = ColorToken('ui.color.field-border-hover');
  static const fieldBorderFocus = ColorToken('ui.color.field-border-focus');
  static const defaultSoft = ColorToken('ui.color.default-soft');
  static const defaultSoftForeground = ColorToken(
    'ui.color.default-soft-foreground',
  );
  static const defaultSoftHover = ColorToken('ui.color.default-soft-hover');
  static const accentSoft = ColorToken('ui.color.accent-soft');
  static const accentSoftForeground = ColorToken(
    'ui.color.accent-soft-foreground',
  );
  static const accentSoftHover = ColorToken('ui.color.accent-soft-hover');
  static const dangerSoft = ColorToken('ui.color.danger-soft');
  static const dangerSoftForeground = ColorToken(
    'ui.color.danger-soft-foreground',
  );
  static const dangerSoftHover = ColorToken('ui.color.danger-soft-hover');
  static const warningSoft = ColorToken('ui.color.warning-soft');
  static const warningSoftForeground = ColorToken(
    'ui.color.warning-soft-foreground',
  );
  static const warningSoftHover = ColorToken('ui.color.warning-soft-hover');
  static const successSoft = ColorToken('ui.color.success-soft');
  static const successSoftForeground = ColorToken(
    'ui.color.success-soft-foreground',
  );
  static const successSoftHover = ColorToken('ui.color.success-soft-hover');
  static const separatorSecondary = ColorToken('ui.color.separator-secondary');
  static const separatorTertiary = ColorToken('ui.color.separator-tertiary');
  static const borderSecondary = ColorToken('ui.color.border-secondary');
  static const borderTertiary = ColorToken('ui.color.border-tertiary');
  static const radiusXs = RadiusToken('ui.radius.xs');
  static const radiusSm = RadiusToken('ui.radius.sm');
  static const radiusMd = RadiusToken('ui.radius.md');
  static const radiusLg = RadiusToken('ui.radius.lg');
  static const radiusXl = RadiusToken('ui.radius.xl');
  static const radius2xl = RadiusToken('ui.radius.2xl');
  static const radius3xl = RadiusToken('ui.radius.3xl');
  static const radius4xl = RadiusToken('ui.radius.4xl');
  static const radiusField = RadiusToken('ui.radius.field');
  static const radiusPanel = RadiusToken('ui.radius.panel');
  static const textXs = TextStyleToken('ui.text.xs');
  static const textSm = TextStyleToken('ui.text.sm');
  static const textBase = TextStyleToken('ui.text.base');

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
