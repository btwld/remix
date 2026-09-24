# Styling Remix

Remix-specific styling only. For the general Mix mental model — Spec/Styler/
Prop resolution, the full fluent surface (`.color()`, `.border()`,
`.padding()`, `.shadow()`, ...), context variants (`.onDark()`,
`.onMobile()`, ...), animation (`.animate(AnimationConfig...)`), and token
call-form mechanics — see the `mix` skill. This reference covers only what is
specific to Remix component stylers.

Sections: [Component-part stylers](#component-part-stylers) ·
[.onSelected()](#onselected) · [Callable styles](#callable-styles) ·
[Styling with installed tokens](#styling-with-installed-tokens) ·
[Canonical spellings](#canonical-spellings) ·
[Reusable and dynamic app styles](#reusable-and-dynamic-app-styles).

## Component-part stylers

Remix component stylers add part-specific fluent methods beyond the generic
Mix surface: `.label*()` (color, fontSize, fontWeight, letterSpacing, …),
`.icon*()` (color, size, opacity, …), and `.spinner*()` (indicatorColor,
size, strokeWidth, …) where the component has those parts. Use the canonical
`.color()` for the component's own surface fill; keep the slot-specific
methods for the corresponding part.

```dart
ButtonStyler()
    .color(const Color(0xFF3E63DD))
    .labelColor(const Color(0xFFFFFFFF))
    .labelFontWeight(FontWeight.w600)
    .iconColor(const Color(0xFFFFFFFF))
    .spacing(8)                      // icon↔label gap
```

## `.onSelected()`

`onSelected()` is a generic extension available on every `MixStyler`, not a
method scoped to selection components — but it only has an effect on a
widget that actually reports `WidgetState.selected` (Checkbox, Radio,
Switch, Toggle, Tab). Calling it on, say, a `ButtonStyler` compiles but never
resolves, because `RemixButton` never enters that state — the same is true of
`RemixTabView`, which never reports `selected` itself.

```dart
CheckboxStyler()
    .color(const Color(0xFFE0E0E0))
    .onSelected(CheckboxStyler().color(const Color(0xFF3E63DD)))
```

## Callable styles

Every leaf component styler has a `call()` method that builds the widget
directly:

```dart
final primaryButton = ButtonStyler()
    .color(const Color(0xFF3E63DD))
    .labelColor(const Color(0xFFFFFFFF))
    .padding(.horizontal(24))
    .borderRadius(.circular(8));

primaryButton(label: 'Save', onPressed: save)   // → RemixButton
```

Eight stylers use a generic `call<T>()` instead: Accordion, Radio,
SegmentedControl, Select, Menu, ToggleGroup, DataTable, and Sidebar. Dart
usually infers `T` from the required values or item/row lists. Every other
leaf component styler uses a non-generic `call()`. Behavioral group/root
widgets — `RemixAccordionGroup`, `RemixRadioGroup`, `RemixTabs`,
`RemixCheckboxGroup` — are constructed directly; they have no styler.

## Styling with installed tokens

Reference the installed theme's tokens in custom styles so they respect the
active theme, whichever preset is installed:

```dart
ButtonStyler()
    .color(FortalTokens.accent9())
    .label(TextStyler().style(FortalTokens.text2.mix())
        .color(FortalTokens.accentContrast()))

Container(color: FortalTokens.colorBackground.resolve(context))
```

Call the token inside a styler chain, `.mix()` for text-style tokens,
`.resolve(context)` for a direct value in widget code. See
[Fortal token rules](fortal.md#token-rules) for the catalog and non-obvious
resolution rules, and the `mix` skill for general token/`Prop` call-form
mechanics.

## Canonical spellings

Some retired spellings below still compile on plain Mix stylers, so the
analyzer does not always catch them. These override the `mix` skill where it
differs:

| Use | Not |
| --- | --- |
| `.padding(.all(...))`, `.padding(.horizontal(...))` | `paddingAll`, `paddingX`, `paddingY` |
| `.margin(...)` shorthands | `marginAll`, `marginX`, `marginY` |
| `.borderRadius(.circular(x))`, `.borderRadius(.all(...))` | `borderRounded*` |
| `.border(.all(...))` | `borderAll` |
| `.color()` | `.backgroundColor()` |
| `items:` (Menu/Select) | `entries:` |
| `ButtonStyler` | the deprecated `RemixButtonStyler` alias |

## Reusable and dynamic app styles

```dart
class AppStyles {
  static ButtonStyler get primaryButton => fortalButtonStyle(variant: .solid)
      .animate(AnimationConfig.spring(200.ms));
}

RemixButton(label: 'Save', onPressed: save, style: AppStyles.primaryButton)
```

A destructive action needs the accent itself to change, not just the idle
fill: overriding `.color()`/`.onHovered()` alone misses the Fortal recipe's
own `.onPressed` fill, so the button flashes the theme accent on press. Scope
the accent instead of hard-coding palette values:

```dart
// Fortal
FortalScope(
  accent: .red,
  child: FortalButton.solid(label: 'Delete', onPressed: delete),
)

// Vanilla
UiButton.destructive(label: 'Delete', onPressed: delete)
```

Keep an appearance preference as `FortalThemeMode` (or `<Prefix>ThemeMode`
for the Vanilla preset) and pass it to the scope's `mode` — see
[theme selection](../SKILL.md#place-the-theme-scope) for persistence and
system-brightness rules.
