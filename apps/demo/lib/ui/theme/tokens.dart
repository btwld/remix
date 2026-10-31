import 'package:remix/remix.dart';

import 'theme_scope.dart' show FortalTheme;

/// Design tokens for the Fortal UI system (Fortal-owned palettes).
///
/// Provides color scales (12-step accent/gray), spacing (9-step), radius (6-step),
/// shadows (6-level), typography (9-size), and functional colors.
///
/// Example:
/// ```dart
/// ButtonStyler().color(FortalTokens.accent9())
/// ```
///
/// Must be used within [FortalTheme] to resolve actual values.
class FortalTokens {
  static const activityMaxHeight = DoubleToken('fortal.activity.max-height');
  static const planMaxHeight = DoubleToken('fortal.plan.max-height');
  static const messageAvatarSize = DoubleToken('fortal.message.avatar-size');
  static const messageContentMaxWidth = DoubleToken(
    'fortal.message.content-max-width',
  );
  static const messageCollapsedHeight = DoubleToken(
    'fortal.message.collapsed-height',
  );
  static const composerFieldMinHeight = DoubleToken(
    'fortal.composer-field-min-height',
  );
  static const touchTargetMin = DoubleToken('fortal.touch-target-min');
  static const popoverMaxWidth = DoubleToken('fortal.popover-max-width');
  static const dialogMaxWidth = DoubleToken('fortal.dialog-max-width');
  static const toastMaxWidth = DoubleToken('fortal.toast-max-width');
  static const sidebarDestinationMinHeight = DoubleToken(
    'fortal.sidebar.destination-min-height',
  );

  /// Sort icons retain their optical sizes where the spacing scale has no step.
  static const dataTableSortIconSize1 = DoubleToken(
    'fortal.data-table.sort-icon-size.1',
  );
  static const dataTableSortIconSize3 = DoubleToken(
    'fortal.data-table.sort-icon-size.3',
  );

  /// Page background color selected for the active brightness.
  static const colorBackground = ColorToken('fortal.color.background');

  /// Neutral surface color for input fields and controls.
  static const colorSurface = ColorToken('fortal.color.surface');

  /// Selected SegmentedControl surface for the active brightness.
  static const segmentedControlIndicatorBackground = ColorToken(
    'fortal.segmented-control.indicator-background',
  );

  /// Solid panel background selected for the active brightness.
  static const colorPanelSolid = ColorToken('fortal.color.panel.solid');

  /// Translucent panel background with alpha transparency.
  static const colorPanelTranslucent = ColorToken(
    'fortal.color.panel.translucent',
  );

  /// Panel background selected by [FortalPanelBackground].
  static const colorPanel = ColorToken('fortal.color.panel');

  /// Backdrop blur applied to translucent floating panels.
  static const panelBlur = DoubleToken('fortal.panel.blur');

  /// Dark overlay for modals and dialogs.
  static const colorOverlay = ColorToken('fortal.color.overlay');

  /// Subtle accent surface for soft button variants and chips.
  static const accentSurface = ColorToken('fortal.accent.surface');

  /// Active indicator color for progress bars and sliders.
  static const accentIndicator = ColorToken('fortal.accent.indicator');

  /// Track/rail background color for sliders and progress bars.
  static const accentTrack = ColorToken('fortal.accent.track');

  /// Mode-aware overlay used by high-contrast slider ranges.
  static const sliderHighContrastOverlay = ColorToken(
    'fortal.slider.high-contrast-overlay',
  );

  /// High contrast foreground for solid accent backgrounds.
  static const accentContrast = ColorToken('fortal.accent.contrast');

  /// Outline of a white switch or slider thumb: the on-solid ink where that
  /// ink is darker than the solid fill, otherwise [controlBorder].
  static const accentThumbRing = ColorToken('fortal.accent.thumb-ring');

  /// Neutral boundary of active empty controls (unchecked checkbox and radio,
  /// off switch, surface text input), at least 3:1 against page and panel.
  static const controlBorder = ColorToken('fortal.control.border');

  /// Solid focus ring color (accent step 8).
  static const focus8 = ColorToken('fortal.focus.8');

  /// Translucent text-selection color (accent alpha step 5).
  static const focusA5 = ColorToken('fortal.focus.a5');

  /// Translucent focus ring color with alpha transparency.
  static const focusA8 = ColorToken('fortal.focus.a8');

  /// Mode-aware red roles used by documented validation extensions.
  static const error3 = ColorToken('fortal.error.3');
  static const error7 = ColorToken('fortal.error.7');
  static const error8 = ColorToken('fortal.error.8');
  static const error9 = ColorToken('fortal.error.9');
  static const error11 = ColorToken('fortal.error.11');
  static const error12 = ColorToken('fortal.error.12');
  static const errorA7 = ColorToken('fortal.error.a7');

  /// Accent step 1 - App background, most subtle.
  static const accent1 = ColorToken('fortal.accent.1');

  /// Accent step 2 - Subtle background.
  static const accent2 = ColorToken('fortal.accent.2');

  /// Accent step 3 - Component background at rest.
  static const accent3 = ColorToken('fortal.accent.3');

  /// Accent step 4 - Component background on hover.
  static const accent4 = ColorToken('fortal.accent.4');

  /// Accent step 5 - Component background when active/pressed.
  static const accent5 = ColorToken('fortal.accent.5');

  /// Accent step 6 - Subtle borders and separators.
  static const accent6 = ColorToken('fortal.accent.6');

  /// Accent step 7 - Component borders at rest.
  static const accent7 = ColorToken('fortal.accent.7');

  /// Accent step 8 - Component borders on hover and focus.
  static const accent8 = ColorToken('fortal.accent.8');

  /// Accent step 9 - Primary solid background.
  static const accent9 = ColorToken('fortal.accent.9');

  /// Accent step 10 - Solid background on hover.
  static const accent10 = ColorToken('fortal.accent.10');

  /// Accent step 11 - Low contrast text.
  static const accent11 = ColorToken('fortal.accent.11');

  /// Accent step 12 - High contrast text.
  static const accent12 = ColorToken('fortal.accent.12');

  /// Gray step 1 - Page background.
  static const gray1 = ColorToken('fortal.gray.1');

  /// Gray step 2 - Panel and card backgrounds.
  static const gray2 = ColorToken('fortal.gray.2');

  /// Gray step 3 - Input backgrounds and pressed states.
  static const gray3 = ColorToken('fortal.gray.3');

  /// Gray step 4 - Input backgrounds on hover.
  static const gray4 = ColorToken('fortal.gray.4');

  /// Gray step 5 - Active states and disabled backgrounds.
  static const gray5 = ColorToken('fortal.gray.5');

  /// Gray step 6 - Subtle borders and dividers.
  static const gray6 = ColorToken('fortal.gray.6');

  /// Gray step 7 - Standard borders and outlines.
  static const gray7 = ColorToken('fortal.gray.7');

  /// Gray step 8 - Borders on hover and focus.
  static const gray8 = ColorToken('fortal.gray.8');

  /// Gray step 9 - Solid neutral backgrounds.
  static const gray9 = ColorToken('fortal.gray.9');

  /// Gray step 10 - Solid neutral backgrounds on hover.
  static const gray10 = ColorToken('fortal.gray.10');

  /// Gray step 11 - Low contrast text and secondary content.
  static const gray11 = ColorToken('fortal.gray.11');

  /// Gray step 12 - High contrast text and primary content.
  static const gray12 = ColorToken('fortal.gray.12');

  /// Neutral surface baseline for the selected gray scale (matches JSON surface)
  static const graySurface = ColorToken('fortal.gray.surface');

  /// Neutral indicator color (typically gray step 9)
  static const grayIndicator = ColorToken('fortal.gray.indicator');

  /// Neutral track color (typically gray step 9)
  static const grayTrack = ColorToken('fortal.gray.track');

  /// Contrast color for content over neutral solid backgrounds (white)
  static const grayContrast = ColorToken('fortal.gray.contrast');

  // Accent alpha steps a1..a12
  static const accentA1 = ColorToken('fortal.accent.a1');
  static const accentA2 = ColorToken('fortal.accent.a2');
  static const accentA3 = ColorToken('fortal.accent.a3');
  static const accentA4 = ColorToken('fortal.accent.a4');
  static const accentA5 = ColorToken('fortal.accent.a5');
  static const accentA6 = ColorToken('fortal.accent.a6');
  static const accentA7 = ColorToken('fortal.accent.a7');
  static const accentA8 = ColorToken('fortal.accent.a8');
  static const accentA9 = ColorToken('fortal.accent.a9');
  static const accentA10 = ColorToken('fortal.accent.a10');
  static const accentA11 = ColorToken('fortal.accent.a11');
  static const accentA12 = ColorToken('fortal.accent.a12');

  // Gray alpha steps a1..a12
  static const grayA1 = ColorToken('fortal.gray.a1');
  static const grayA2 = ColorToken('fortal.gray.a2');
  static const grayA3 = ColorToken('fortal.gray.a3');
  static const grayA4 = ColorToken('fortal.gray.a4');
  static const grayA5 = ColorToken('fortal.gray.a5');
  static const grayA6 = ColorToken('fortal.gray.a6');
  static const grayA7 = ColorToken('fortal.gray.a7');
  static const grayA8 = ColorToken('fortal.gray.a8');
  static const grayA9 = ColorToken('fortal.gray.a9');
  static const grayA10 = ColorToken('fortal.gray.a10');
  static const grayA11 = ColorToken('fortal.gray.a11');
  static const grayA12 = ColorToken('fortal.gray.a12');

  /// Black alpha steps used in layered shadows.
  static const blackA1 = ColorToken('fortal.black.a1');
  static const blackA2 = ColorToken('fortal.black.a2');
  static const blackA3 = ColorToken('fortal.black.a3');
  static const blackA4 = ColorToken('fortal.black.a4');
  static const blackA5 = ColorToken('fortal.black.a5');
  static const blackA6 = ColorToken('fortal.black.a6');
  static const blackA7 = ColorToken('fortal.black.a7');
  static const blackA8 = ColorToken('fortal.black.a8');
  static const blackA9 = ColorToken('fortal.black.a9');
  static const blackA10 = ColorToken('fortal.black.a10');
  static const blackA11 = ColorToken('fortal.black.a11');
  static const blackA12 = ColorToken('fortal.black.a12');

  /// White alpha steps for transparent decoration and overlays.
  static const whiteA1 = ColorToken('fortal.white.a1');
  static const whiteA2 = ColorToken('fortal.white.a2');
  static const whiteA3 = ColorToken('fortal.white.a3');
  static const whiteA4 = ColorToken('fortal.white.a4');
  static const whiteA5 = ColorToken('fortal.white.a5');
  static const whiteA6 = ColorToken('fortal.white.a6');
  static const whiteA7 = ColorToken('fortal.white.a7');
  static const whiteA8 = ColorToken('fortal.white.a8');
  static const whiteA9 = ColorToken('fortal.white.a9');
  static const whiteA10 = ColorToken('fortal.white.a10');
  static const whiteA11 = ColorToken('fortal.white.a11');
  static const whiteA12 = ColorToken('fortal.white.a12');

  /// Mode-aware mixed shadow stroke.
  static const shadowStroke = ColorToken('fortal.shadow.stroke');

  static const grayStroke3 = ColorToken('fortal.gray.stroke.3');
  static const grayStroke4 = ColorToken('fortal.gray.stroke.4');
  static const grayStroke5 = ColorToken('fortal.gray.stroke.5');
  static const grayStroke6 = ColorToken('fortal.gray.stroke.6');
  static const grayStroke7 = ColorToken('fortal.gray.stroke.7');

  /// Space step 1 - 4px.
  static const space1 = SpaceToken('fortal.space.1');

  /// Space step 2 - 8px.
  static const space2 = SpaceToken('fortal.space.2');

  /// Space step 3 - 12px.
  static const space3 = SpaceToken('fortal.space.3');

  /// Space step 4 - 16px.
  static const space4 = SpaceToken('fortal.space.4');

  /// Space step 5 - 24px.
  static const space5 = SpaceToken('fortal.space.5');

  /// Space step 6 - 32px.
  static const space6 = SpaceToken('fortal.space.6');

  /// Space step 7 - 40px.
  static const space7 = SpaceToken('fortal.space.7');

  /// Space step 8 - 48px.
  static const space8 = SpaceToken('fortal.space.8');

  /// Space step 9 - 64px.
  static const space9 = SpaceToken('fortal.space.9');

  /// Spinner size 3 - 20px at 100% scaling.
  static const spinnerSize3 = DoubleToken('fortal.spinner.size.3');

  /// Avatar sizes expressed as scaled pixels rather than spacing steps.
  static const avatarSize6 = DoubleToken('fortal.avatar.size.6');
  static const avatarSize7 = DoubleToken('fortal.avatar.size.7');
  static const avatarSize8 = DoubleToken('fortal.avatar.size.8');
  static const avatarSize9 = DoubleToken('fortal.avatar.size.9');

  static const avatarIconSize3 = DoubleToken('fortal.avatar.icon-size.3');
  static const avatarIconSize9 = DoubleToken('fortal.avatar.icon-size.9');

  static const badgePaddingY1 = DoubleToken('fortal.badge.padding-y.1');

  /// Checkbox dimensions expressed as scaled pixels by Fortal.
  static const checkboxSize1 = DoubleToken('fortal.checkbox.size.1');
  static const checkboxSize3 = DoubleToken('fortal.checkbox.size.3');
  static const checkboxIndicatorSize1 = DoubleToken(
    'fortal.checkbox.indicator-size.1',
  );
  static const checkboxIndicatorSize2 = DoubleToken(
    'fortal.checkbox.indicator-size.2',
  );

  /// Radio indicators are 40% of their control size in Fortal.
  ///
  /// These values need dedicated tokens because arithmetic on an unresolved
  /// token reference would destroy its identity before Mix can resolve it.
  static const radioIndicatorSize1 = DoubleToken(
    'fortal.radio.indicator-size.1',
  );
  static const radioIndicatorSize2 = DoubleToken(
    'fortal.radio.indicator-size.2',
  );

  /// Checkbox radii derived from fractional radius-step expressions.
  static const checkboxRadius1 = RadiusToken('fortal.checkbox.radius.1');
  static const checkboxRadius3 = RadiusToken('fortal.checkbox.radius.3');

  /// Switch geometry that cannot be derived from unresolved token references.
  static const switchHeight2 = DoubleToken('fortal.switch.height.2');
  static const switchWidth1 = DoubleToken('fortal.switch.width.1');
  static const switchWidth2 = DoubleToken('fortal.switch.width.2');
  static const switchWidth3 = DoubleToken('fortal.switch.width.3');
  static const switchThumbSize1 = DoubleToken('fortal.switch.thumb-size.1');
  static const switchThumbSize2 = DoubleToken('fortal.switch.thumb-size.2');
  static const switchThumbSize3 = DoubleToken('fortal.switch.thumb-size.3');

  static const progressHeight2 = DoubleToken('fortal.progress.height.2');
  static const progressRadius1 = RadiusToken('fortal.progress.radius.1');
  static const progressRadius2 = RadiusToken('fortal.progress.radius.2');
  static const progressRadius3 = RadiusToken('fortal.progress.radius.3');

  static const sliderTrackSize1 = DoubleToken('fortal.slider.track-size.1');
  static const sliderTrackSize3 = DoubleToken('fortal.slider.track-size.3');
  static const sliderThumbSize1 = DoubleToken('fortal.slider.thumb-size.1');
  static const sliderThumbSize3 = DoubleToken('fortal.slider.thumb-size.3');
  static const sliderTrackRadius1 = RadiusToken('fortal.slider.track-radius.1');
  static const sliderTrackRadius2 = RadiusToken('fortal.slider.track-radius.2');
  static const sliderTrackRadius3 = RadiusToken('fortal.slider.track-radius.3');

  /// TextArea metrics that cannot be expressed by existing spacing tokens.
  static const textAreaMinHeight3 = DoubleToken(
    'fortal.text-area.min-height.3',
  );

  /// DataList metrics that cannot be expressed by existing spacing tokens.
  static const dataListRowGap3 = DoubleToken('fortal.data-list.row-gap.3');
  static const dataListLabelMinWidth = DoubleToken(
    'fortal.data-list.label-min-width',
  );

  /// Exact uppercase fallback typography for each Avatar size.
  static const avatarFallback1One = TextStyleToken(
    'fortal.avatar.fallback.1.one',
  );
  static const avatarFallback1Two = TextStyleToken(
    'fortal.avatar.fallback.1.two',
  );
  static const avatarFallback2One = TextStyleToken(
    'fortal.avatar.fallback.2.one',
  );
  static const avatarFallback2Two = TextStyleToken(
    'fortal.avatar.fallback.2.two',
  );
  static const avatarFallback3One = TextStyleToken(
    'fortal.avatar.fallback.3.one',
  );
  static const avatarFallback3Two = TextStyleToken(
    'fortal.avatar.fallback.3.two',
  );
  static const avatarFallback4One = TextStyleToken(
    'fortal.avatar.fallback.4.one',
  );
  static const avatarFallback4Two = TextStyleToken(
    'fortal.avatar.fallback.4.two',
  );
  static const avatarFallback5 = TextStyleToken('fortal.avatar.fallback.5');
  static const avatarFallback6 = TextStyleToken('fortal.avatar.fallback.6');
  static const avatarFallback7 = TextStyleToken('fortal.avatar.fallback.7');
  static const avatarFallback8 = TextStyleToken('fortal.avatar.fallback.8');
  static const avatarFallback9 = TextStyleToken('fortal.avatar.fallback.9');

  /// Tabs size 1 inner vertical padding - 2px at 100% scaling.
  static const tabInnerPaddingY1 = DoubleToken('fortal.tabs.inner-padding-y.1');

  /// Tabs size 1 active tracking - -0.12px at 100% scaling.
  static const tabActiveLetterSpacing1 = DoubleToken(
    'fortal.tabs.active-letter-spacing.1',
  );

  /// Tabs size 2 active tracking - -0.14px at 100% scaling.
  static const tabActiveLetterSpacing2 = DoubleToken(
    'fortal.tabs.active-letter-spacing.2',
  );

  /// Table surface border - `color-mix(in oklab, gray-a5, gray-6)`.
  ///
  /// The existing `grayStroke*` tokens blend an alpha step with the *same*
  /// numbered solid step at 25%; Table blends step 5 with step 6 at 50%.
  static const dataTableBorder = ColorToken('fortal.data-table.border');

  /// Select size-1 indicator column width (20px at 100% scaling).
  static const selectIndicatorWidth1 = DoubleToken(
    'fortal.select.indicator-width.1',
  );

  /// Select size-2/3 check size (10px at 100% scaling).
  static const selectIndicatorSize2 = DoubleToken(
    'fortal.select.indicator-size.2',
  );

  /// Negative margins that cancel Select ghost-trigger padding.
  static const selectGhostMarginX12 = DoubleToken(
    'fortal.select.ghost-margin-x.1-2',
  );
  static const selectGhostMarginY12 = DoubleToken(
    'fortal.select.ghost-margin-y.1-2',
  );
  static const selectGhostMarginX3 = DoubleToken(
    'fortal.select.ghost-margin-x.3',
  );
  static const selectGhostMarginY3 = DoubleToken(
    'fortal.select.ghost-margin-y.3',
  );

  /// Radius step 1 - 3px.
  static const radius1 = RadiusToken('fortal.radius.1');

  /// Radius step 2 - 4px.
  static const radius2 = RadiusToken('fortal.radius.2');

  /// Radius step 3 - 6px.
  static const radius3 = RadiusToken('fortal.radius.3');

  /// Radius step 4 - 8px.
  static const radius4 = RadiusToken('fortal.radius.4');

  /// Radius step 5 - 12px.
  static const radius5 = RadiusToken('fortal.radius.5');

  /// Radius step 6 - 16px.
  static const radius6 = RadiusToken('fortal.radius.6');

  /// Theme-level full radius, enabled only by [FortalRadius.full].
  static const radiusFull = RadiusToken('fortal.radius.full');

  /// Radius used by control thumbs.
  static const radiusThumb = RadiusToken('fortal.radius.thumb');

  /// Fixed circle radius for shapes that stay circular across theme presets.
  static const radiusCircle = RadiusToken('fortal.radius.circle');

  /// Radius step 1 promoted to a pill when the theme radius is full.
  static const radius1OrFull = RadiusToken('fortal.radius.1-or-full');

  /// Radius step 2 promoted to a pill when the theme radius is full.
  static const radius2OrFull = RadiusToken('fortal.radius.2-or-full');

  /// Radius step 3 promoted to a pill when the theme radius is full.
  static const radius3OrFull = RadiusToken('fortal.radius.3-or-full');

  /// Radius step 4 promoted to a pill when the theme radius is full.
  static const radius4OrFull = RadiusToken('fortal.radius.4-or-full');

  /// Radius step 5 promoted to a pill when the theme radius is full.
  static const radius5OrFull = RadiusToken('fortal.radius.5-or-full');

  /// Radius step 6 promoted to a pill when the theme radius is full.
  static const radius6OrFull = RadiusToken('fortal.radius.6-or-full');

  /// Radius step 1 promoted to the control-thumb radius when larger.
  static const radius1OrThumb = RadiusToken('fortal.radius.1-or-thumb');

  /// Radius step 2 promoted to the control-thumb radius when larger.
  static const radius2OrThumb = RadiusToken('fortal.radius.2-or-thumb');

  /// Shadow level 1 - Subtle elevation.
  static const shadow1 = BoxShadowToken('fortal.shadow.1');

  /// Exact layered shadow level 1, including inset layers.
  static const shadow1Layers = RemixBoxShadowListToken(
    'fortal.shadow.1.layers',
  );

  /// Shadow level 2 - Low elevation.
  static const shadow2 = BoxShadowToken('fortal.shadow.2');

  /// Shadow level 3 - Medium elevation.
  static const shadow3 = BoxShadowToken('fortal.shadow.3');

  /// Shadow level 4 - High elevation.
  static const shadow4 = BoxShadowToken('fortal.shadow.4');

  /// Shadow level 5 - Very high elevation.
  static const shadow5 = BoxShadowToken('fortal.shadow.5');

  /// Shadow level 6 - Maximum elevation.
  static const shadow6 = BoxShadowToken('fortal.shadow.6');

  static const baseButtonGhostMarginX12 = DoubleToken(
    'fortal.base-button.ghost.margin-x.1-2',
  );
  static const baseButtonGhostMarginY12 = DoubleToken(
    'fortal.base-button.ghost.margin-y.1-2',
  );
  static const baseButtonGhostMarginX3 = DoubleToken(
    'fortal.base-button.ghost.margin-x.3',
  );
  static const baseButtonGhostMarginY3 = DoubleToken(
    'fortal.base-button.ghost.margin-y.3',
  );
  static const baseButtonGhostMarginX4 = DoubleToken(
    'fortal.base-button.ghost.margin-x.4',
  );
  static const baseButtonGhostMarginY4 = DoubleToken(
    'fortal.base-button.ghost.margin-y.4',
  );
  static const iconButtonGhostMargin1 = DoubleToken(
    'fortal.icon-button.ghost.margin.1',
  );
  static const iconButtonGhostMargin2 = DoubleToken(
    'fortal.icon-button.ghost.margin.2',
  );
  static const iconButtonGhostMargin3 = DoubleToken(
    'fortal.icon-button.ghost.margin.3',
  );
  static const iconButtonGhostMargin4 = DoubleToken(
    'fortal.icon-button.ghost.margin.4',
  );
  static const cardGhostMargin1 = DoubleToken('fortal.card.ghost.margin.1');
  static const cardGhostMargin2 = DoubleToken('fortal.card.ghost.margin.2');
  static const cardGhostMargin3 = DoubleToken('fortal.card.ghost.margin.3');
  static const cardGhostMargin4 = DoubleToken('fortal.card.ghost.margin.4');
  static const cardGhostMargin5 = DoubleToken('fortal.card.ghost.margin.5');

  /// Standard border width (1px).
  static const borderWidth1 = SpaceToken('fortal.border.width.1');

  /// Thick border width (2px).
  static const borderWidth2 = SpaceToken('fortal.border.width.2');

  /// Focus ring border width (2px).
  static const focusRingWidth = SpaceToken('fortal.focus.ring.width');

  /// Focus ring offset distance from element edge.
  static const focusRingOffset = SpaceToken('fortal.focus.ring.offset');

  /// Text size 1 - 12px (Small labels and metadata).
  static const text1 = TextStyleToken('fortal.text.1');

  /// Text size 2 - 14px (Standard UI text).
  static const text2 = TextStyleToken('fortal.text.2');

  /// Text size 3 - 16px (Body text and primary content).
  static const text3 = TextStyleToken('fortal.text.3');

  /// Text size 4 - 18px (Prominent body text).
  static const text4 = TextStyleToken('fortal.text.4');

  /// Text size 5 - 20px (Small headings).
  static const text5 = TextStyleToken('fortal.text.5');

  /// Text size 6 - 24px (Medium headings).
  static const text6 = TextStyleToken('fortal.text.6');

  /// Text size 7 - 28px (Large headings).
  static const text7 = TextStyleToken('fortal.text.7');

  /// Text size 8 - 36px (Extra large headings).
  static const text8 = TextStyleToken('fortal.text.8');

  /// Text size 9 - 60px (Display text).
  static const text9 = TextStyleToken('fortal.text.9');

  /// Light font weight (300).
  static const fontWeightLight = FontWeightToken('fortal.font.weight.light');

  /// Regular font weight (400).
  static const fontWeightRegular = FontWeightToken(
    'fortal.font.weight.regular',
  );

  /// Medium font weight (500).
  static const fontWeightMedium = FontWeightToken('fortal.font.weight.medium');

  /// Semibold font weight (600).
  static const fontWeightSemibold = FontWeightToken(
    'fortal.font.weight.semibold',
  );

  /// Bold font weight (700).
  static const fontWeightBold = FontWeightToken('fortal.font.weight.bold');

  /// Fast animation duration (100ms).
  static const transitionFast = DurationToken('fortal.transition.fast');

  /// Slow animation duration (300ms).
  static const transitionSlow = DurationToken('fortal.transition.slow');

  static const skeletonPulseDuration = DurationToken(
    'fortal.skeleton.pulse-duration',
  );
}
