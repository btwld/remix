# Fortal authoring package

An independent, city-inspired design system for [Remix](https://pub.dev/packages/remix).

This private workspace package is the analyzed authoring source for the
application-owned `fortal` preset, not a published consumer package. It owns
seven paired Radix color themes, Orla defaults, flat controls,
solid panels, a shared focus ring, and contrast-tested soft labels.
Consumers install editable source with the CLI.

Orla uses dark primary actions in light mode and white actions in dark mode,
with matching selected-control roles. Its panels and secondary content retain
the Radix gray hierarchy. Raw scales remain exact; this is Fortal's default
primary-role policy, separate from explicit `highContrast` component variants.

## Installation

```bash
flutter pub add dev:remix_cli:^1.0.0-beta.1
dart run remix_cli:remix init --prefix Fortal --preset fortal
dart run remix_cli:remix add button
```

The `Fortal` prefix preserves the API names in this guide. Add each additional
item when you use it, then import the generated `lib/ui/ui.dart` barrel from
application code.

## Quick Start

Wrap your app with `FortalTheme` to provide the design tokens, then use the
`Fortal*` widgets. Named constructors select a fixed variant; use the unnamed
constructor with `variant:` when the choice is dynamic:

```dart
import 'package:flutter/widgets.dart';
import 'ui/ui.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FortalTheme(
      child: WidgetsApp(
        color: const Color(0xFFFFFFFF),
        builder: (_, _) => Center(
          child: FortalButton.solid(
            onPressed: () {},
            label: 'Fortal Button',
          ),
        ),
      ),
    );
  }
}
```

`FortalTheme` is a `MixScope`. The outermost `FortalTheme` provides design tokens
and sets default text and icon styles (`DefaultTextStyle` using `text3` and
`IconTheme` using `gray12`). Fortal typography components (`FortalText`,
`FortalCode`, `FortalKbd`, and `FortalLink`) resolve their defaults directly from
active scope tokens. A nested scope updates design tokens for its subtree; when
`brightness` changes, it updates `DefaultTextStyle` and `IconTheme` to
the new `gray12` color while preserving font metrics. Transparent, non-accent
`FortalCode.ghost` is an exception and inherits surrounding text color unless
restyled.

Each scope installs a complete token set instead of merging with the scope above
it, so a token override made with `MixScope.inherit`, such as a custom
`focusRingWidth`, does not apply below a nested `FortalTheme`; place the
override inside the nested scope.

Use `WidgetsApp` as the application host. Put the scope in `builder` above the
Navigator so routes, dialogs, and overlays inherit the same theme:

```dart
import 'package:flutter/widgets.dart';
import 'ui/ui.dart';

final app = WidgetsApp(
  color: const Color(0xFFF8FAFC),
  pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
    settings: settings,
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
  ),
  builder: (context, child) => FortalTheme(child: child!),
  home: const Center(child: FortalText('Themed')),
);
```

This is a fallback, not a forced global style. A nearer `DefaultTextStyle`,
including one installed by `Material` or `Scaffold`, still wins for bare
Flutter `Text`. Fortal typography ignores that ambient run for token metrics
and default roles: an omitted size uses `text3`, while an explicit `size:`
selects another token size. The sole ambient field retained by Fortal
typography is the foreground of transparent, non-accent `FortalCode.ghost`.

## Light, dark, and system appearance

`FortalTheme` supplies light and dark preset defaults and follows the system at
the root. Nested scopes inherit the configured pair and active selection.
Customize the pair with `theme` and `darkTheme`, or force `mode` to `.light` or
`.dark`. `mode: .system` follows live platform brightness changes.

```dart
FortalTheme(
  theme: const FortalThemeData.light(accent: FortalAccentColor.orla),
  darkTheme: const FortalThemeData.dark(accent: FortalAccentColor.orla),
  mode: FortalThemeMode.system,
  child: child,
)
```

Supplying only `theme` makes it the fallback for both modes. Supplying only
`darkTheme` retains the default or inherited base theme. Direct scope options
such as `accent` apply to both appearances. Appearance selection uses `mode`;
the scope no longer accepts a `brightness` parameter.

Installed Fortal source uses your prefix: `AcmeTheme`, `AcmeThemeData`, and
`AcmeThemeMode` expose the same behavior. No Material application host is needed.

## Customizing Fortal styles

Fortal widgets call the matching `fortal*Style` recipe internally. Use those
recipes directly when you need a custom Remix widget composition:

```dart
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'ui/ui.dart';

final style = fortalButtonStyle(variant: FortalButtonVariant.solid)
  .borderRadius(.all(const Radius.circular(8)))
  .padding(.horizontal(32))
  .onHovered(.scale(1.05));
```

## Icons

Install the optional application-owned icon aliases through the configured
preset:

```bash
dart run remix_cli:remix add icons
```

That item adds `remix_ui_icons` and creates a small `FortalIcons` alias set you
can edit as the application's vocabulary evolves:

```dart
const Icon(FortalIcons.check)
```

Import `package:remix_ui_icons/remix_ui_icons.dart` and use `RemixIcons`
directly for the rest of the Vector UI pack: the Outline family in outline and
filled styles at native 24, 16, and 12 px masters, with `RoundedIcons`
beside it. There is deliberately no runtime name-to-icon map on
`RemixIcons` itself because dynamic lookup would keep the full font reachable.
Fortal controls otherwise use Remix's inline vector defaults.

Catalogs, galleries, and drift tests that must enumerate every glyph can import
the opt-in index. An application that never imports it keeps full font
subsetting:

```dart
import 'package:remix_ui_icons/icons_index.dart';

final search = remixIconEntries.firstWhere((entry) => entry.name == 'search');
```

## Paired theme colors

Select only the Fortal theme; its neutral family follows automatically.
The public option keeps the `accent:` spelling, for example `.mar`.
There is no separate `gray:` option or `FortalGrayColor` enum.

| Theme | Dart value | Radix accent | Paired neutral |
| --- | --- | --- | --- |
| Orla | `orla` | Gray | Gray |
| Mar | `mar` | Teal | Sage |
| Céu | `ceu` | Blue | Slate |
| Serra | `serra` | Gold | Olive |
| Sol | `sol` | Amber | Sand |
| Duna | `duna` | Brown | Sand |
| Caju | `caju` | Orange | Sand |

The data comes from @radix-ui/colors 3.0.0, including the MIT notice in installed
source. Raw steps remain exact; functional content, labelled fills, marks and
focus roles retain Fortal's contrast contract. See the [Fortal guide](https://docs.page/btwld/remix/fortal)
for light/dark swatches and migration details. A custom `accentPalette` inherits
the selected named theme's neutral, defaulting to Orla.

## Soft variants and contrast

Default `fortalBadgeStyle(variant: .soft)` pairs fill `accentA3` with label
`accentContentAlpha`. All seven themes meet WCAG AA 4.5:1 on soft fills in light and
dark mode, including compositing on the page and solid panels. The optional
`highContrast: true` promotes the label to `accent12` for stronger emphasis;
it is not required to make default soft labels readable.

## Charts

Fortal includes themed line, bar, and pie chart recipes backed by
[`mix_chart`](https://pub.dev/packages/mix_chart). The chart item adds that
dependency automatically; import it directly when constructing chart data
because the application-owned barrel does not re-export it.

```bash
dart run remix_cli:remix add chart
```

```dart
import 'package:mix_chart/mix_chart.dart';
import 'ui/ui.dart';

final chart = FortalLineChart(
  semanticsLabel: 'Weekly revenue',
  series: [
    LineSeries(
      id: 'revenue',
      label: 'Revenue',
      points: [
        ChartPoint(id: 'mon', x: 0, y: 18),
        ChartPoint(id: 'tue', x: 1, y: 31),
      ],
    ),
  ],
);
```

The generated widgets are `FortalLineChart`, `FortalBarChart`, and
`FortalPieChart`. Use `fortalLineChartStyle`, `fortalBarChartStyle`, or
`fortalPieChartStyle` when composing the underlying `mix_chart` widgets. Keep
shared geometry on the chart-level slice style so individual slices remain
data-only:

```dart
final donut = PieChart(
  style: fortalPieChartStyle(centerRadius: 40)
      .slice(PieSliceStyler().radius(36)),
  slices: [
    PieSlice(id: 'core', label: 'Core', value: 54),
    PieSlice(id: 'teams', label: 'Teams', value: 46),
  ],
);
```

## Design tokens

Fortal styles are built on a token system that includes:

- **Colors**: seven paired 12-step Radix accent/neutral themes, with Orla as the default
- **Spacing**: 9-step spacing scale
- **Border Radius**: 6-step radius scale
- **Shadows**: 6-level shadow system
- **Typography**: 9-size type scale
- **Border Widths**: Consistent stroke weights

You can use these tokens directly in your own styles:

```dart
import 'package:remix/remix.dart';
import 'ui/ui.dart';

final style = ButtonStyler()
  .color(FortalTokens.accentSolid())
  .padding(.all(FortalTokens.space4()))
  .borderRadius(.all(FortalTokens.radius3()))
  .label(TextStyler().color(FortalTokens.accentContrast()));
```

## Covered components

Every Remix component has a matching Fortal recipe and preset widget:

### Typography
- **FortalText**, **FortalHeading**, **FortalCode**, **FortalKbd**, **FortalLink**

These five families exist only in Fortal — base Remix ships no `RemixText` — and
they share one nine-step `FortalTextSize` scale plus one `FortalTextWeight`
enum. See the [Typography guide](https://docs.page/btwld/remix/fortal/typography)
for controls, semantics, and composition guidance.

### Interactive Elements
- **FortalButton**, **FortalIconButton**, **FortalSwitch**, **FortalToggle**
- **FortalCheckbox**, **FortalCheckboxGroupItem**, **FortalRadio**, **FortalSlider**

### Input Components
- **FortalTextField**, **FortalTextArea**, **FortalSelect**

### Display Components
- **FortalAvatar**, **FortalBadge**, **FortalCard**, **FortalDataList**
- **FortalDataTable**, **FortalDivider**, **FortalProgress**
- **FortalSkeleton**, **FortalSpinner**
- **FortalLineChart**, **FortalBarChart**, **FortalPieChart**

### Layout & Navigation
- **FortalTabBar**, **FortalTab**, **FortalTabView**, **FortalAccordion**
- **FortalAppBar**, **FortalDisclosure**, **FortalSidebar**, **FortalSidebarLayout**, **FortalDashboardShell**
- **FortalMenu**, **FortalSegmentedControl**, **FortalToggleGroup**

There is no `FortalTabs`: the behavioral root stays `RemixTabs`, which takes no
style. The same applies to the other behavioral roots (`RemixRadioGroup`,
`RemixCheckboxGroup`, `RemixAccordionGroup`).

`FortalSidebar` is part of the owned Fortal catalog. It applies the solid panel surface, the scrolling-region padding, the
footer divider, compact uppercase section headings, and the ghost `size2`
toggle treatment to the public `RemixSidebar` behavior. It sets no panel width
and no header padding, because the host owns placement and usually has to match
its own top bar. Its optional `panelPadding` keeps host-provided display insets
inside the painted surface when that surface must extend to the display edge.

`FortalAppBar` provides a styled app bar using Fortal design tokens. It configures
a solid panel background, a 64px (`space9`) toolbar height with an inset bottom
border, `space4` horizontal padding, and bold `size4` title typography. This
toolbar height and border match the sidebar header in `FortalDashboardShell`,
ensuring horizontal alignment across scaling settings.

### Overlays
- **FortalDialog**, **FortalTooltip**, **FortalPopover**, **FortalToast**, **FortalCallout**

## Owned contract and review

`specs/fortal.md` defines tokens, defaults, variants, geometry, and contrast;
`specs/fortal_catalog.json` owns the machine-readable API/test inventory.
`dart run tool/check_fortal.dart` from the repository root checks that inventory.
Palette/geometry/focus tests and the demo polish-board goldens protect the
visual contract; the pinned Radix snapshot checks exact source color data.

Run `fvm flutter run -d chrome -t lib/polish_main.dart` in `apps/demo` for the
39-family board: every size and variant, seven accents, both modes, a 4px
grid, and hover/pressed/focused/disabled review states. See the
[Fortal guide](https://docs.page/btwld/remix/fortal) for palettes, contrast,
and custom seed generation.

## Built on Remix

Fortal is a preset, not a fork. Every `Fortal*` widget is a thin generated
wrapper that calls the corresponding `Remix*` constructor with a `fortal*Style()`
recipe. Anything you can do with Remix, you can do with Fortal — and you can drop
down to plain Remix stylers at any point.

- [Remix CLI on pub.dev](https://pub.dev/packages/remix_cli)
- [Documentation](https://docs.page/btwld/remix/fortal)
- [GitHub](https://github.com/btwld/remix)

## License

BSD-3-Clause. See [LICENSE](../../LICENSE).
