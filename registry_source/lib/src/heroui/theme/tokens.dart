import 'package:flutter/animation.dart';
import 'package:remix/remix.dart';

/// A value that changes at a breakpoint: [mobile] by default, [desktop] from
/// the one the CSS names.
typedef HeroUiResponsive = ({double mobile, double desktop});

/// Semantic names from the pinned HeroUI web theme.
abstract final class HeroUiTokens {
  static const white = ColorToken('heroUi.color.white');
  static const black = ColorToken('heroUi.color.black');
  static const snow = ColorToken('heroUi.color.snow');
  static const eclipse = ColorToken('heroUi.color.eclipse');
  static const accent = ColorToken('heroUi.color.accent');
  static const accentForeground = ColorToken('heroUi.color.accent-foreground');
  static const success = ColorToken('heroUi.color.success');
  static const successForeground = ColorToken(
    'heroUi.color.success-foreground',
  );
  static const fieldBorder = ColorToken('heroUi.color.field-border');
  static const background = ColorToken('heroUi.color.background');
  static const foreground = ColorToken('heroUi.color.foreground');
  static const surface = ColorToken('heroUi.color.surface');
  static const surfaceForeground = ColorToken(
    'heroUi.color.surface-foreground',
  );
  static const surfaceSecondary = ColorToken('heroUi.color.surface-secondary');
  static const surfaceSecondaryForeground = ColorToken(
    'heroUi.color.surface-secondary-foreground',
  );
  static const surfaceTertiary = ColorToken('heroUi.color.surface-tertiary');
  static const surfaceTertiaryForeground = ColorToken(
    'heroUi.color.surface-tertiary-foreground',
  );
  static const overlay = ColorToken('heroUi.color.overlay');
  static const overlayForeground = ColorToken(
    'heroUi.color.overlay-foreground',
  );
  static const muted = ColorToken('heroUi.color.muted');
  static const defaultColor = ColorToken('heroUi.color.default');
  static const defaultForeground = ColorToken(
    'heroUi.color.default-foreground',
  );
  static const fieldBackground = ColorToken('heroUi.color.field-background');
  static const fieldForeground = ColorToken('heroUi.color.field-foreground');
  static const fieldPlaceholder = ColorToken('heroUi.color.field-placeholder');
  static const warning = ColorToken('heroUi.color.warning');
  static const warningForeground = ColorToken(
    'heroUi.color.warning-foreground',
  );
  static const danger = ColorToken('heroUi.color.danger');
  static const dangerForeground = ColorToken('heroUi.color.danger-foreground');
  static const segment = ColorToken('heroUi.color.segment');
  static const segmentForeground = ColorToken(
    'heroUi.color.segment-foreground',
  );
  static const border = ColorToken('heroUi.color.border');
  static const separator = ColorToken('heroUi.color.separator');
  static const focus = ColorToken('heroUi.color.focus');
  static const link = ColorToken('heroUi.color.link');
  static const backdrop = ColorToken('heroUi.color.backdrop');
  static const surfaceHover = ColorToken('heroUi.color.surface-hover');
  static const backgroundSecondary = ColorToken(
    'heroUi.color.background-secondary',
  );
  static const backgroundTertiary = ColorToken(
    'heroUi.color.background-tertiary',
  );
  static const backgroundInverse = ColorToken(
    'heroUi.color.background-inverse',
  );
  static const defaultHover = ColorToken('heroUi.color.default-hover');
  static const accentHover = ColorToken('heroUi.color.accent-hover');
  static const successHover = ColorToken('heroUi.color.success-hover');
  static const warningHover = ColorToken('heroUi.color.warning-hover');
  static const dangerHover = ColorToken('heroUi.color.danger-hover');
  static const fieldHover = ColorToken('heroUi.color.field-hover');
  static const fieldFocus = ColorToken('heroUi.color.field-focus');
  static const fieldBorderHover = ColorToken('heroUi.color.field-border-hover');
  static const fieldBorderFocus = ColorToken('heroUi.color.field-border-focus');
  static const defaultSoft = ColorToken('heroUi.color.default-soft');
  static const defaultSoftForeground = ColorToken(
    'heroUi.color.default-soft-foreground',
  );
  static const defaultSoftHover = ColorToken('heroUi.color.default-soft-hover');
  static const accentSoft = ColorToken('heroUi.color.accent-soft');
  static const accentSoftForeground = ColorToken(
    'heroUi.color.accent-soft-foreground',
  );
  static const accentSoftHover = ColorToken('heroUi.color.accent-soft-hover');
  static const dangerSoft = ColorToken('heroUi.color.danger-soft');
  static const dangerSoftForeground = ColorToken(
    'heroUi.color.danger-soft-foreground',
  );
  static const dangerSoftHover = ColorToken('heroUi.color.danger-soft-hover');
  static const warningSoft = ColorToken('heroUi.color.warning-soft');
  static const warningSoftForeground = ColorToken(
    'heroUi.color.warning-soft-foreground',
  );
  static const warningSoftHover = ColorToken('heroUi.color.warning-soft-hover');
  static const successSoft = ColorToken('heroUi.color.success-soft');
  static const successSoftForeground = ColorToken(
    'heroUi.color.success-soft-foreground',
  );
  static const successSoftHover = ColorToken('heroUi.color.success-soft-hover');
  static const separatorSecondary = ColorToken(
    'heroUi.color.separator-secondary',
  );
  static const separatorTertiary = ColorToken(
    'heroUi.color.separator-tertiary',
  );
  static const borderSecondary = ColorToken('heroUi.color.border-secondary');
  static const borderTertiary = ColorToken('heroUi.color.border-tertiary');
  static const radiusXs = RadiusToken('heroUi.radius.xs');
  static const radiusSm = RadiusToken('heroUi.radius.sm');
  static const radiusMd = RadiusToken('heroUi.radius.md');
  static const radiusLg = RadiusToken('heroUi.radius.lg');
  static const radiusXl = RadiusToken('heroUi.radius.xl');
  static const radius2xl = RadiusToken('heroUi.radius.2xl');
  static const radius3xl = RadiusToken('heroUi.radius.3xl');
  static const radius4xl = RadiusToken('heroUi.radius.4xl');
  static const radiusField = RadiusToken('heroUi.radius.field');
  static const radiusPanel = RadiusToken('heroUi.radius.panel');
  static const textXs = TextStyleToken('heroUi.text.xs');
  static const textSm = TextStyleToken('heroUi.text.sm');
  static const textBase = TextStyleToken('heroUi.text.base');

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
  /// variants, and the resting colour of a focus-ring border.
  static const transparent = Color(0x00000000);
}
