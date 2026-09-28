# Vanilla Reference

Rules for the Vanilla preset that are easy to get wrong from a widget's name
alone. Vanilla is the `remix_cli` default — a compact, shadcn-style starter
theme and recipe set, editable the same way as Fortal's. For install
commands, scope placement, and the preset chooser, see the
[main skill](../SKILL.md).

## Tokens

`<Prefix>Tokens` is a flat, shadcn-style role list — there are no text-style
or spacing tokens, unlike Fortal's larger scale families:

- `background`, `foreground`
- `primary`, `primaryForeground`
- `secondary`, `secondaryForeground`
- `muted`, `mutedForeground`
- `accent`, `accentForeground`
- `destructive`, `destructiveForeground`
- `border`, `focusRing`
- `chart1`–`chart5` (plus a `chart` list of all five, and a `colors` list of
  every color token)
- `radius`

`accent` is the interaction surface for otherwise transparent controls, not a
brand hue — the scope has no `accent:` parameter. Set a brand color with
`copyWith(primary: ...)` on the theme instead.

`mutedForeground` on `muted` measures 4.35:1, below the 4.5:1 text floor: use
it for text on `background`, and use `foreground` for text that lands on a
`muted` surface.

`<Prefix>ThemeScope` sets no `DefaultTextStyle` for bare Flutter `Text` —
unlike Fortal's outermost scope, which installs one as a courtesy fallback.

## Theme values

`<Prefix>ThemeData.light()`/`.dark()` are the named constructors;
`copyWith(...)` derives a changed theme. Read the active theme with
`<Prefix>Theme.of(context)` or `<Prefix>Theme.maybeOf(context)`.

## Components

The installed recipe's enums in `lib/ui/components/<name>.dart` are
authoritative for a component's variants and sizes; do not assume Fortal's
families carry over.

- **Button** — `<Prefix>ButtonVariant { primary, secondary, outline, ghost,
  destructive }`; `<Prefix>ButtonSize { small, medium, large }` (32/36/40px
  minimum height). Use `<Prefix>Button.destructive(...)` for irreversible
  actions.
- **Toast** — style lives on the scope:
  `RemixToastScope(style: uiToastStyle(), child: ...)`. A per-toast
  `RemixToastData.style` (for example `uiToastStyle(variant: .destructive)`)
  merges over it. `<Prefix>ToastVariant { neutral, destructive }`.
- **Tabs** — compose `RemixTabs` (the behavioral root) with `<Prefix>TabBar`,
  `<Prefix>Tab`, and `<Prefix>TabView`, the same shape as Fortal.

## Styling with tokens

```dart
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'ui/ui.dart';

final primaryButton = ButtonStyler()
    .color(UiTokens.primary())
    .label(TextStyler().color(UiTokens.primaryForeground()));

Widget background(BuildContext context) =>
    Container(color: UiTokens.background.resolve(context));
```

Call the token inside a styler chain, `.resolve(context)` for a direct value
in widget code. Vanilla has no text-style tokens, so `.mix()` does not apply
here — see [Styling](styling.md) for that call form and general token/`Prop`
mechanics.
