import 'package:remix/remix.dart';

/// Semantic design tokens owned by the application.
///
/// Remix ships no theme, so the names below are the application's vocabulary,
/// not a Remix contract. A [MixToken] is only an identity: the concrete value
/// comes from whichever `MixScope` is active, which `PlaygroundThemeScope` installs
/// from a `PlaygroundThemeData`. Editing, renaming, or adding a token here is a
/// local change — nothing in Remix reads these names.
///
/// The names follow the CSS variables of shadcn/ui's theme, which inspired
/// Playground's look, so a value read off one of those themes drops straight into
/// `PlaygroundThemeData`.
///
/// ```dart
/// ButtonStyler().color(PlaygroundTokens.primary());
/// ```
abstract final class PlaygroundTokens {
  /// Page background the application paints behind its content.
  static const background = ColorToken('playground.color.background');

  /// Default content color used on top of [background].
  static const foreground = ColorToken('playground.color.foreground');

  /// Surface of a card, a step apart from [background] in the dark theme.
  static const card = ColorToken('playground.color.card');

  /// Content color used on top of [card].
  static const cardForeground = ColorToken('playground.color.card-foreground');

  /// Surface of a floating panel: a popover, a menu, a select's options.
  static const popover = ColorToken('playground.color.popover');

  /// Content color used on top of [popover].
  static const popoverForeground = ColorToken(
    'playground.color.popover-foreground',
  );

  /// Highest-emphasis fill.
  static const primary = ColorToken('playground.color.primary');

  /// Content color used on top of [primary].
  static const primaryForeground = ColorToken(
    'playground.color.primary-foreground',
  );

  /// Medium-emphasis fill.
  static const secondary = ColorToken('playground.color.secondary');

  /// Content color used on top of [secondary].
  static const secondaryForeground = ColorToken(
    'playground.color.secondary-foreground',
  );

  /// De-emphasized surface.
  static const muted = ColorToken('playground.color.muted');

  /// De-emphasized content color.
  ///
  /// The shipped light theme sets it at `#707070`, a step darker than the usual
  /// neutral gray, so it clears the 4.5:1 text floor on [muted] as well as on
  /// [background]: a muted caption inside a muted surface stays readable.
  static const mutedForeground = ColorToken(
    'playground.color.muted-foreground',
  );

  /// Interaction surface for otherwise transparent controls: the hovered
  /// ghost button, the highlighted menu row, the toggle that is on.
  static const accent = ColorToken('playground.color.accent');

  /// Content color used on top of [accent].
  static const accentForeground = ColorToken(
    'playground.color.accent-foreground',
  );

  /// Destructive color for irreversible actions and errors.
  ///
  /// In the dark theme this is a light red that reads as text on the page but
  /// is too light to carry white text as a solid fill, which is why the dark
  /// recipes paint destructive fills at a reduced alpha (see `playgroundTint`).
  static const destructive = ColorToken('playground.color.destructive');

  /// Content color used on top of a [destructive] fill.
  ///
  /// White in both shipped themes, and a token rather than a constant so the
  /// pairing stays editable in one place.
  static const destructiveForeground = ColorToken(
    'playground.color.destructive-foreground',
  );

  /// Hairline separator and surface outline color.
  static const border = ColorToken('playground.color.border');

  /// Outline of a form control: a text field, a select trigger, a checkbox.
  ///
  /// The same value as [border] in the light theme and a step stronger in the
  /// dark one, where a control has to stand out from a card's hairline.
  static const input = ColorToken('playground.color.input');

  /// Focus color: the keyboard focus ring and a focused control's border.
  ///
  /// Recipes draw the ring at half strength and turn a bordered control's
  /// outline to full strength. Give it a brand color here and every control's
  /// focus treatment follows.
  static const ring = ColorToken('playground.color.ring');

  /// First categorical chart series color.
  ///
  /// Charts assign [chart1] through [chart5] to series in order; see [chart].
  /// The shipped themes use a neutral ramp, the same five grays in both
  /// brightnesses, so series are told apart by lightness rather than by hue.
  static const chart1 = ColorToken('playground.color.chart-1');

  /// Second categorical chart series color. See [chart1].
  static const chart2 = ColorToken('playground.color.chart-2');

  /// Third categorical chart series color. See [chart1].
  static const chart3 = ColorToken('playground.color.chart-3');

  /// Fourth categorical chart series color. See [chart1].
  static const chart4 = ColorToken('playground.color.chart-4');

  /// Fifth categorical chart series color. See [chart1].
  static const chart5 = ColorToken('playground.color.chart-5');

  /// Surface of the navigation sidebar, a step apart from [background].
  static const sidebar = ColorToken('playground.color.sidebar');

  /// Content color used on top of [sidebar].
  static const sidebarForeground = ColorToken(
    'playground.color.sidebar-foreground',
  );

  /// Highest-emphasis fill inside the sidebar.
  static const sidebarPrimary = ColorToken('playground.color.sidebar-primary');

  /// Content color used on top of [sidebarPrimary].
  static const sidebarPrimaryForeground = ColorToken(
    'playground.color.sidebar-primary-foreground',
  );

  /// Hovered and current destination surface inside the sidebar.
  static const sidebarAccent = ColorToken('playground.color.sidebar-accent');

  /// Content color used on top of [sidebarAccent].
  static const sidebarAccentForeground = ColorToken(
    'playground.color.sidebar-accent-foreground',
  );

  /// Hairline color inside and along the sidebar.
  static const sidebarBorder = ColorToken('playground.color.sidebar-border');

  /// Focus color inside the sidebar. See [ring].
  static const sidebarRing = ColorToken('playground.color.sidebar-ring');

  /// The small corner radius: menu rows and select options.
  ///
  /// Every radius step is derived from the one `radius` value on
  /// `PlaygroundThemeData`, so changing that value rounds the whole application
  /// consistently.
  static const radiusSm = RadiusToken('playground.radius.sm');

  /// The control corner radius: buttons, fields, toggles. See [radiusSm].
  static const radiusMd = RadiusToken('playground.radius.md');

  /// The panel corner radius: dialogs, callouts, the tab list. See
  /// [radiusSm].
  static const radiusLg = RadiusToken('playground.radius.lg');

  /// The card corner radius. See [radiusSm].
  static const radiusXl = RadiusToken('playground.radius.xl');

  /// 12px text on a 16px line: captions, badges, tooltips.
  ///
  /// Every text step carries the theme's font family, a size, and a line
  /// height, and nothing else: weight and color are the recipe's to choose.
  static const textXs = TextStyleToken('playground.text.xs');

  /// 14px text on a 20px line: body copy and control labels. See [textXs].
  static const textSm = TextStyleToken('playground.text.sm');

  /// 16px text on a 24px line. See [textXs].
  static const textBase = TextStyleToken('playground.text.base');

  /// 18px text on a 28px line. See [textXs].
  static const textLg = TextStyleToken('playground.text.lg');

  /// 20px text on a 28px line. See [textXs].
  static const textXl = TextStyleToken('playground.text.xl');

  /// 24px text on a 32px line. See [textXs].
  static const text2xl = TextStyleToken('playground.text.2xl');

  /// 30px text on a 36px line. See [textXs].
  static const text3xl = TextStyleToken('playground.text.3xl');

  /// Code: [textSm]'s size and line height in the theme's monospace family.
  static const textMono = TextStyleToken('playground.text.mono');

  /// The chart series colors in the order charts assign them.
  static const chart = <ColorToken>[chart1, chart2, chart3, chart4, chart5];

  /// Every color token this layer defines, in declaration order.
  ///
  /// The installed-app fixture checks that `PlaygroundThemeData`'s scope map
  /// resolves every entry, so a token added here and forgotten there fails.
  static const colors = <ColorToken>[
    background,
    foreground,
    card,
    cardForeground,
    popover,
    popoverForeground,
    primary,
    primaryForeground,
    secondary,
    secondaryForeground,
    muted,
    mutedForeground,
    accent,
    accentForeground,
    destructive,
    destructiveForeground,
    border,
    input,
    ring,
    chart1,
    chart2,
    chart3,
    chart4,
    chart5,
    sidebar,
    sidebarForeground,
    sidebarPrimary,
    sidebarPrimaryForeground,
    sidebarAccent,
    sidebarAccentForeground,
    sidebarBorder,
    sidebarRing,
  ];

  /// Every radius step, from the smallest.
  static const radii = <RadiusToken>[radiusSm, radiusMd, radiusLg, radiusXl];

  /// Every text step, from the smallest, then [textMono].
  static const textStyles = <TextStyleToken>[
    textXs,
    textSm,
    textBase,
    textLg,
    textXl,
    text2xl,
    text3xl,
    textMono,
  ];
}
