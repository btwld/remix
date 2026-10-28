# HeroUI Reference

Rules for the HeroUI preset that are easy to get wrong from a widget's name or
dartdoc alone. The preset reproduces the look of HeroUI web 3.2.6 over Remix
components; behavior and widget parameters are Remix's. For a component's
variants, sizes, and defaults, the installed recipe's enum in
`lib/ui/components/<name>.dart` is authoritative, and this source is yours to
edit. For install commands, scope placement, and theme selection shared with
the other presets, see the [main skill](../SKILL.md).

Sections: [Recipes](#recipes) · [Compositions](#compositions) ·
[Overlays](#overlays) · [Theme](#theme) · [Tokens](#tokens) ·
[Not included](#not-included).

## Recipes

Each component ships a `heroUi<Name>Style(...)` function that returns the Remix
widget's `*Styler`, and a generated `HeroUi<Name>` widget that applies it:

```dart
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'ui/ui.dart';

// Generated widget: Remix's parameters plus HeroUI's variant and size.
Widget generated(VoidCallback save) =>
    HeroUiButton.secondary(label: 'Save', onPressed: save, size: .lg);

// Styler function: a ButtonStyler to extend.
Widget styled(VoidCallback save) => RemixButton(
  label: 'Save',
  onPressed: save,
  style: heroUiButtonStyle(variant: .secondary, size: .lg)
      .onHovered(ButtonStyler().scale(1.02)),
);
```

Recipes resolve `HeroUiTokens`, so a `HeroUiTheme` ancestor is required. Every
`variant` value has a named constructor; HeroUI's `default` becomes
`default<Component>` (`HeroUiCard.defaultCard`), and colour props use the
shared `HeroUiColor` (`defaultColor`, `accent`, `success`, `warning`,
`danger`).

HeroUI's React props map onto Remix rather than being copied:

| HeroUI | Here |
| --- | --- |
| `isPending` | Remix `loading: true` (dims like disabled, as upstream measures) |
| `isInvalid` on a text field | Remix `error: true`; the message goes in `helperText` |
| `isInvalid` on checkbox, select, switch option | the recipe's `invalid: true`; validation stays with the app |
| `isSelected` / `defaultSelected` | Remix's single `selected` value and `onChanged` |
| `isIconOnly` | `HeroUiIconButton` for buttons, `iconOnly` for toggle buttons |

Sizes follow HeroUI's responsive rules (`sm` 640px, `md` 768px), so a button
is taller on phones. A caller override of a responsive value must be an
`onBreakpoint` fragment too, or the breakpoint variant wins.

## Compositions

Where Remix has no widget, the preset composes Remix widgets and Mix
primitives with no behavior of their own: `HeroUiBadge` (a label pinned to its
child), `HeroUiAvatarGroup`, `HeroUiBreadcrumbs`, `HeroUiButtonGroup`,
`HeroUiKbd`, `HeroUiSurface`, `HeroUiTypography`, `HeroUiCardTitle` and
`HeroUiCardDescription`, `HeroUiAccordionGroup` (one surface card around
accordion items), and the field layouts `HeroUiCheckboxGroup`,
`HeroUiRadioGroup`, `HeroUiSwitchGroup`, `HeroUiFieldLayout`, and
`HeroUiDescribedControl`.

A checkbox's, radio's, or switch's label is the control's own `label`, inside
its tap target: pointing at it hovers, presses, and toggles the control, and
one accessibility node carries the name. Pass `semanticLabel` instead only when
you draw the label yourself. The groups compose the description beneath a
radio or switch outside the target, as HeroUI does.

A search field is `HeroUiSearchField` with `HeroUiSearchIcon` as `leading` and
a `HeroUiSearchClearButton` as `trailing`; the app clears its controller and
decides when the button shows.

## Overlays

- Open a popover from a `HeroUiButton` with `openOnTap: false`, a
  `MenuController` driven from the button's `onPressed`, and one `FocusNode`
  given to both the popover's `triggerFocusNode` and the button's `focusNode`,
  so the button is the only tab stop and takes focus back on close:

```dart
import 'package:flutter/widgets.dart';
import 'ui/ui.dart';

class ShareButton extends StatefulWidget {
  const ShareButton({super.key});

  @override
  State<ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends State<ShareButton> {
  final _controller = MenuController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => HeroUiPopover(
    controller: _controller,
    triggerFocusNode: _focusNode,
    openOnTap: false,
    popoverChild: const Text('Anyone with the link can view.'),
    child: HeroUiButton.secondary(
      label: 'Share',
      focusNode: _focusNode,
      onPressed: _controller.open,
    ),
  );
}
```

- A dropdown's trigger is a `HeroUiButton` through `RemixMenuTrigger.control`;
  give the button the handle's `focusNode` and `toggle`:

```dart
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'ui/ui.dart';

Widget actions() => HeroUiDropdown<String>(
  trigger: RemixMenuTrigger.control(
    builder: (context, menu) => HeroUiButton.secondary(
      label: 'Actions',
      focusNode: menu.focusNode,
      onPressed: menu.toggle,
    ),
  ),
  items: const [
    RemixMenuItem(value: 'edit', label: 'Edit'),
    RemixMenuItem(value: 'delete', label: 'Delete'),
  ],
);
```

  A label or builder trigger (`RemixMenuTrigger(label:)`) gets the bare
  `.dropdown__trigger` look instead.
- A select's popover is at least as wide as its trigger. Remix centers a wider
  popover under the trigger by default; pass
  `positioning: OverlayPositionConfig(side: .bottom, alignment: .start)` to
  align the edges.
- A toast puts its action under the message at 768px and below, and the action
  gains HeroUI's `mt-2` below 640px through a second `action`. An `action`
  replaces rather than merges, so a caller who styles it restates
  the button style, with its variant, in the base `action` and again, with the
  margin, below 640px; otherwise the recipe's own action wins there:

```dart
import 'package:remix/remix.dart';
import 'ui/ui.dart';

ToastStyler secondaryAction() => ToastStyler()
    .action(heroUiButtonStyle(variant: .secondary))
    .onNot(
      ContextVariant.breakpoint(
        const Breakpoint.minWidth(HeroUiTokens.breakpointSm),
      ),
      ToastStyler().action(
        heroUiButtonStyle(variant: .secondary).margin(.top(2)),
      ),
    );
```

- A modal's backdrop is the route barrier: pass `HeroUiTokens.backdrop`
  resolved from context as the dialog's barrier color.
- Overlays keep the theme through `HeroUiTheme`'s `InheritedTheme.wrap`;
  place the scope in `WidgetsApp.builder`, above the Navigator.

## Theme

`HeroUiTheme(theme:, darkTheme:, mode:)` selects between a light and a dark
`HeroUiThemeData`. HeroUI themes by overriding CSS variables, and so does this:

```dart
import 'package:flutter/widgets.dart';
import 'ui/ui.dart';

final brand = const HeroUiThemeData.light().copyWith(
  colors: {HeroUiTokens.accent: const Color(0xFF8000FF)},
  radius: 10,
);
```

Overriding a colour recomputes the colours HeroUI derives from it (accent's
hover, soft, and focus colours follow); `radius` drives the whole radius
scale. `fontFamily` is null by default, the platform font, as HeroUI uses the
system stack; code text uses Geist Mono from `remix_ui_fonts`.

## Tokens

`HeroUiTokens` keeps HeroUI's role names: `accent`, `defaultColor`,
`surface`, `overlay`, `fieldBackground`, `muted`, `focus`, the status colours
and their `*Foreground`, `*Hover`, and `*Soft` forms; radii `radiusXs` through
`radius4xl`, `radiusField`, `radiusPanel`; text `textXs`, `textSm`, `textBase`;
motion curves `easeSmooth`, `easeOut`, `easeOutQuart`, `easeOutFluid`; and
the transitions `fillMotion`, `smoothMotion`, `selectionMotion`, and
`transformMotion`. These transitions run whatever the OS motion setting: Mix
2.3.1's `.animate` does not read reduced motion. Remix's own select,
accordion, and dialog motion honors it. Essential spinner motion stays unchanged.
Derive a translucent colour with `heroUiAlpha(token, alpha)` held in a
top-level final, never `token().withValues(...)`.

## Not included

Families that need behavior Remix does not provide are not in the preset:
Form, Fieldset, NumberField, InputOTP, ListBox, ComboBox, Pagination, a
standalone Menu, and the date and color pickers. Each component's worksheet
lists its visual approximations (fonts, shadow softness, motion such as the
sliding tab indicator).
