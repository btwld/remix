---
name: remix-ui
description: Guide for building Flutter UIs with the Remix component library (Mix + Naked UI + Fortal theme). Use this skill whenever the user wants to create Flutter UI with Remix components, style Remix widgets, set up Fortal theming, customize component appearance, handle interaction states, or asks about any Remix widget (RemixButton, RemixCheckbox, RemixSelect, RemixTabs, etc.). Also trigger when the user mentions Remix styling, Fortal tokens, or wants help with Flutter component design using this design system — even if they just say "make a button" or "style this form" in a Remix project.
---

# Remix UI — Building Flutter Interfaces

Remix is a Flutter design-system library. It combines **Naked UI** (headless accessible behavior) with **Mix** (styling engine) to deliver fully styled, interaction-aware components. The built-in **Fortal** theme provides Radix-inspired design tokens out of the box.

## Quick Start

```dart
import 'package:remix/remix.dart';
```

Wrap your app (or a subtree) in `FortalScope` to enable the Fortal design tokens:

```dart
FortalScope(
  accent: FortalAccentColor.indigo,  // 31 color options
  gray: FortalGrayColor.slate,       // 6 neutral scales
  brightness: Brightness.light,      // or .dark
  child: MaterialApp(home: MyScreen()),
)
```

Every Remix component works without `FortalScope`, but generated Fortal widgets and Fortal preset stylers require it to resolve tokens. Prefer `Fortal*` widgets for standard Fortal UI; use `fortal*Styler` directly only when composing or extending a raw `Remix*` widget.

---

## Component Catalog

Remix ships 20 components. Each raw `Remix*` component accepts a `style` parameter for full visual control, and Fortal provides generated `Fortal*` widgets for preset design-system usage.

| Category | Components |
|----------|-----------|
| **Actions** | `RemixButton`, `RemixIconButton` |
| **Forms** | `RemixCheckbox`, `RemixRadio` + `RemixRadioGroup`, `RemixSwitch`, `RemixSlider`, `RemixTextField`, `RemixSelect` |
| **Data display** | `RemixAvatar`, `RemixBadge`, `RemixCard`, `RemixCallout`, `RemixProgress`, `RemixSpinner`, `RemixDivider` |
| **Overlays** | `RemixDialog` (+ `showRemixDialog`), `RemixTooltip`, `RemixMenu` |
| **Navigation** | `RemixTabs` + `RemixTabBar` + `RemixTab` + `RemixTabView`, `RemixAccordion` + `RemixAccordionGroup` |

See `references/components.md` for the full API of every component.

---

## Using Components

### Buttons

```dart
FortalButton(
  label: 'Submit',
  onPressed: () => handleSubmit(),
  variant: .solid,
  size: .size2,
)

FortalButton(
  label: 'Delete',
  leadingIcon: Icons.delete,
  loading: isDeleting,
  enabled: canDelete,
  onPressed: () => handleDelete(),
  variant: .outline,
)

FortalIconButton(
  icon: Icons.settings,
  onPressed: () => openSettings(),
  variant: .ghost,
)
```

### Form Controls

```dart
// Checkbox
FortalCheckbox(
  selected: isChecked,
  onChanged: (val) => setState(() => isChecked = val),
  variant: .surface,
)

// Radio group
RemixRadioGroup<String>(
  groupValue: selectedOption,
  onChanged: (val) => setState(() => selectedOption = val),
  child: Column(children: [
    FortalRadio(value: 'a'),
    FortalRadio(value: 'b'),
    FortalRadio(value: 'c'),
  ]),
)

// Switch
FortalSwitch(
  selected: isDarkMode,
  onChanged: (val) => toggleDarkMode(val),
  variant: .soft,
)

// Slider
FortalSlider(
  value: volume,
  onChanged: (val) => setState(() => volume = val),
  min: 0,
  max: 100,
)

// TextField
FortalTextField(
  controller: emailController,
  label: 'Email',
  hintText: 'you@example.com',
  helperText: 'We will never share your email',
  error: hasError,
  variant: .surface,
)
```

### Select & Menu

```dart
// Select (dropdown)
final itemStyle = fortalSelectMenuItemStyler(variant: .surface);

FortalSelect<String>(
  variant: .surface,
  trigger: RemixSelectTrigger(placeholder: 'Choose a fruit'),
  items: [
    RemixSelectItem(value: 'apple', label: 'Apple', style: itemStyle),
    RemixSelectItem(value: 'banana', label: 'Banana', style: itemStyle),
    RemixSelectItem(value: 'cherry', label: 'Cherry', style: itemStyle),
  ],
  selectedValue: selectedFruit,
  onChanged: (val) => setState(() => selectedFruit = val),
)

// Menu (action menu)
FortalMenu<String>(
  trigger: RemixMenuTrigger(label: 'Actions', icon: Icons.more_vert),
  items: [
    RemixMenuItem(value: 'edit', label: 'Edit', leadingIcon: Icons.edit),
    RemixMenuItem(value: 'copy', label: 'Copy', leadingIcon: Icons.copy),
    RemixMenuDivider(),
    RemixMenuItem(value: 'delete', label: 'Delete', leadingIcon: Icons.delete),
  ],
  onSelected: (action) => handleAction(action),
)
```

### Tabs

```dart
RemixTabs(
  selectedTabId: currentTab,
  onChanged: (id) => setState(() => currentTab = id),
  child: Column(children: [
    FortalTabBar(
      child: Row(children: [
        FortalTab(tabId: 'overview', label: 'Overview'),
        FortalTab(tabId: 'details', label: 'Details', icon: Icons.info),
        FortalTab(tabId: 'settings', label: 'Settings'),
      ]),
    ),
    Expanded(child: Column(children: [
      FortalTabView(tabId: 'overview', child: OverviewPanel()),
      FortalTabView(tabId: 'details', child: DetailsPanel()),
      FortalTabView(tabId: 'settings', child: SettingsPanel()),
    ])),
  ]),
)
```

### Accordion

```dart
RemixAccordionGroup<String>(
  controller: accordionController,
  child: Column(children: [
    FortalAccordion(value: 'faq1', title: 'What is Remix?', child: Text('...')),
    FortalAccordion(value: 'faq2', title: 'How does theming work?', child: Text('...')),
  ]),
)
```

### Data Display

```dart
// Avatar
FortalAvatar(
  label: 'JD',
  backgroundImage: NetworkImage('https://...'),
  variant: .soft,
  size: .size3,
)

// Badge
FortalBadge(
  label: 'New',
  variant: .solid,
)

// Card
FortalCard(
  variant: .surface,
  size: .size2,
  child: Column(children: [
    Text('Card Title'),
    Text('Card content goes here'),
  ]),
)

// Callout
FortalCallout(
  icon: Icons.info,
  text: 'This is an informational callout.',
  variant: .surface,
)

// Progress
FortalProgress(value: 0.65, variant: .surface)

// Spinner
FortalSpinner(size: .size2)

// Divider
FortalDivider(size: .size1)
```

### Overlays

```dart
// Dialog
showRemixDialog(
  context: context,
  builder: (_) => FortalDialog(
    title: 'Confirm',
    description: 'Are you sure you want to proceed?',
    actions: [
      FortalButton(label: 'Cancel', onPressed: () => Navigator.pop(context),
        variant: .outline),
      FortalButton(label: 'Confirm', onPressed: () { confirm(); Navigator.pop(context); },
        variant: .solid),
    ],
  ),
)

// Tooltip
FortalTooltip(
  tooltipChild: Text('This button saves your work'),
  child: FortalIconButton(icon: Icons.save, onPressed: save),
)
```

---

## Styling Components

Every raw `Remix*` component takes a fluent `style:` parameter (`RemixXStyler`) and optional raw `styleSpec:` (`RemixXSpec?`) that bypasses style resolution.

There are two styling approaches:

### 1. Fortal Widgets (Recommended for Consistency)

Fortal widgets give you pre-built variants and sizes that follow the design system without passing styles manually:

```dart
FortalButton(
  label: 'Save',
  variant: .solid,
  size: .size3,
  onPressed: save,
)

FortalButton(label: 'Cancel', variant: .outline, onPressed: cancel)
FortalIconButton(icon: Icons.settings, variant: .ghost, onPressed: openSettings)
```

See `references/fortal-reference.md` for all Fortal widget variants and sizes per component.

Use `fortal*Styler` directly when you need a custom raw `Remix*` composition or want to layer additional style changes on top of the preset.

### 2. Custom Styles (Full Control via Fluent API)

Build styles from scratch using the chainable fluent API:

```dart
RemixButtonStyler()
    .color(Colors.blue)
    .borderRounded(12)
    .paddingX(24)
    .paddingY(12)
    .labelColor(Colors.white)
    .labelFontSize(16)
    .labelFontWeight(FontWeight.w600)
    .iconColor(Colors.white)
    .iconSize(20)
    .spacing(8)
```

### Interaction States

Chain state modifiers to respond to hover, press, focus, and disabled:

```dart
RemixButtonStyler()
    .color(Colors.blue)
    .labelColor(Colors.white)
    .onHovered(
      RemixButtonStyler()
          .color(Colors.blue.shade700)
    )
    .onPressed(
      RemixButtonStyler()
          .scale(0.97)
    )
    .onFocused(
      RemixButtonStyler()
          .borderAll(color: Colors.white, width: 2)
    )
    .onDisabled(
      RemixButtonStyler()
          .color(Colors.grey)
          .labelColor(Colors.grey.shade400)
    )
```

Components that support selection (checkbox, radio, switch, tabs) also have `.onSelected()`:

```dart
RemixCheckboxStyler()
    .color(Colors.grey.shade200)
    .onSelected(
      RemixCheckboxStyler()
          .color(Colors.blue)
          .indicatorColor(Colors.white)
    )
```

### Animation

Add smooth transitions between states with `.animate()`:

```dart
RemixButtonStyler()
    .color(Colors.blue)
    .onHovered(RemixButtonStyler().color(Colors.blue.shade800))
    .animate(AnimationConfig.spring(300.ms))
```

`AnimationConfig.spring()` produces a natural feel. For linear/curve-based animation:

```dart
.animate(CurveAnimationConfig(
  duration: Duration(milliseconds: 200),
  curve: Curves.easeOut,
))
```

### Combining Fortal with Overrides

Start from a Fortal styler and layer custom modifications when a generated `Fortal*` widget is not enough:

```dart
final style = fortalButtonStyler(variant: .solid)
    .onHovered(RemixButtonStyler().scale(1.02))
    .animate(AnimationConfig.spring(200.ms));

RemixButton(label: 'Click', onPressed: doThing, style: style)
```

### Defining Styles in Widgets

When defining styles within a widget class, use a **getter** — this is idiomatic Dart for computed properties with no arguments:

```dart
class MyScreen extends StatelessWidget {
  RemixButtonStyler get _gradientButtonStyle {
    return RemixButtonStyler.create(
      container: FlexBoxStyler()
        ..gradient.linear(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6366F1), Color(0xFFEC4899)],
        ),
    )
        .borderRounded(16)
        .paddingX(32)
        .paddingY(14)
        .labelColor(Colors.white)
        .labelFontSize(16)
        .iconColor(Colors.white)
        .shadow(BoxShadow(
          color: Color(0x406366F1),
          blurRadius: 12,
          offset: Offset(0, 4),
        ))
        .onHovered(RemixButtonStyler().shadow(BoxShadow(
          color: Color(0x80EC4899),
          blurRadius: 28,
          spreadRadius: 4,
        )))
        .onPressed(RemixButtonStyler().scale(0.95))
        .animate(AnimationConfig.spring(250.ms));
  }

  @override
  Widget build(BuildContext context) {
    return RemixButton(
      label: 'Get Started',
      leadingIcon: Icons.rocket_launch,
      onPressed: () {},
      style: _gradientButtonStyle,
    );
  }
}
```

### Callable Styles

Styles with a `call()` method can be used as functions to create widgets directly:

```dart
final primaryButton = RemixButtonStyler()
    .color(Colors.blue)
    .labelColor(Colors.white)
    .paddingX(24)
    .paddingY(12)
    .borderRounded(8);

// Call it to produce a widget:
primaryButton(label: 'Save', onPressed: save)
```

This works on: `RemixButtonStyler`, `RemixIconButtonStyler`, `RemixCheckboxStyler`, `RemixSwitchStyler`, `RemixRadioStyler`, `RemixSliderStyler`, `RemixTextFieldStyler`, `RemixSelectStyler`, `RemixMenuStyler`, `RemixSpinnerStyler`.

---

## Fortal Theme System

Fortal is Remix's built-in design system, inspired by Radix UI's color system.

### FortalScope

Wrap your widget tree in `FortalScope` to provide design tokens:

```dart
FortalScope(
  accent: FortalAccentColor.blue,   // primary color family
  gray: FortalGrayColor.slate,      // neutral color family
  brightness: Brightness.light,     // light or dark mode
  child: MyApp(),
)
```

**Accent colors** (31): amber, blue, bronze, brown, crimson, cyan, gold, grass, green, indigo, iris, jade, lime, mint, orange, pink, plum, purple, red, ruby, sky, teal, tomato, violet, yellow, gray, mauve, slate, sage, olive, sand.

**Gray scales** (6): gray, mauve, slate, sage, olive, sand.

### Using FortalThemeConfig

For programmatic theme control:

```dart
final config = FortalThemeConfig(
  accent: FortalAccentColor.purple,
  gray: FortalGrayColor.mauve,
  brightness: Brightness.dark,
);

config.createScope(child: MyApp())
```

### Component Fortal Widgets

Every component with Fortal support exposes a generated widget wrapper for normal use:

```dart
FortalButton(variant: .solid, size: .size2, label: 'Save')
FortalButton(variant: .outline, size: .size3, label: 'Cancel')
FortalCheckbox(variant: .surface, selected: accepted)
FortalTab(tabId: 'details', label: 'Details')
```

### Fortal Tokens

When building custom styles that should respect the Fortal theme, reference tokens using `FortalTokens`:

```dart
RemixButtonStyler.create(
  container: FlexBoxStyler()
    ..color.ref(FortalTokens.accent9)
    ..borderRadius.ref(FortalTokens.radius3)
    ..padding.vertical.ref(FortalTokens.space2)
    ..padding.horizontal.ref(FortalTokens.space4),
  label: TextStyler()
    ..color.ref(FortalTokens.accentContrast)
    ..style.ref(FortalTokens.text2),
)
```

Key token families:
- **Colors**: `accent1`–`accent12`, `gray1`–`gray12`, plus alpha variants (`accentA1`–`accentA12`, `grayA1`–`grayA12`)
- **Functional**: `accentSurface`, `accentIndicator`, `accentContrast`, `colorBackground`, `colorSurface`
- **Space**: `space1` (4px) through `space9` (64px)
- **Radius**: `radius1` (3px) through `radius6` (16px), `radiusFull` (pill)
- **Typography**: `text1` (12px) through `text9` (60px)
- **Shadows**: `shadow1` through `shadow6`

See `references/fortal-reference.md` for the complete token catalog.

---

## Interaction Variants (not platform shims)

Prefer widget-state variants over platform/theme shims:

```dart
RemixButtonStyler()
    .paddingX(24)
    .onHovered(RemixButtonStyler().paddingX(16).labelFontSize(14))
    .onPressed(RemixButtonStyler().scale(0.98))
    .onFocused(RemixButtonStyler().borderAll(color: Colors.blue, width: 2))
    .onDisabled(RemixButtonStyler().color(Colors.grey))
```

Use `FortalScope(brightness: ...)` for light/dark theming rather than platform or theme-branch style variants.

---

## Style Hierarchy Quick Reference

All component styles inherit from a base that determines what convenience methods are available:

- **`RemixContainerStyler`** (box-based): `.color()`, `.padding()`, `.margin()`, `.borderRadius()`, `.border()`, `.shadow()`, `.size()`, `.width()`, `.height()`, `.constraints()`, `.alignment()`, `.transform()`, `.scale()`, `.rotate()`
- **`RemixFlexContainerStyler`** (flex-based): everything above + `.spacing()`, `.direction()`, `.mainAxisAlignment()`, `.crossAxisAlignment()`, `.row()`, `.column()`

Plus shared mixins on specific components:
- **`LabelStyleMixin`**: `.labelColor()`, `.labelFontSize()`, `.labelFontWeight()`, `.labelFontStyle()`, `.labelLetterSpacing()`
- **`IconStyleMixin`**: `.iconColor()`, `.iconSize()`, `.iconOpacity()`
- **`SpinnerStyleMixin`**: `.spinnerIndicatorColor()`, `.spinnerSize()`, `.spinnerStrokeWidth()`
- **`SelectedWidgetStateVariantMixin`**: `.onSelected()` (checkbox, radio, switch, tabs)

For deeper Mix-level styling (specs, `StyleSpec`, `BoxStyler`, `TextStyler`, `build_runner` codegen), consult the **Mix** skill.

---

## Common Patterns

### Reusable Style Tokens

Create a shared style file for your app. Use `static` getters for styles that chain multiple operations:

```dart
class AppStyles {
  static RemixButtonStyler get primaryButton => fortalButtonStyler(variant: .solid)
      .animate(AnimationConfig.spring(200.ms));

  static RemixButtonStyler get secondaryButton => fortalButtonStyler(variant: .outline)
      .animate(AnimationConfig.spring(200.ms));

  static RemixButtonStyler get dangerButton => fortalButtonStyler(variant: .solid)
      .color(Colors.red)
      .onHovered(RemixButtonStyler().color(Colors.red.shade700))
      .animate(AnimationConfig.spring(200.ms));
}
```

### Dark Mode Toggle

```dart
class MyApp extends StatefulWidget { ... }

class _MyAppState extends State<MyApp> {
  var _brightness = Brightness.light;

  @override
  Widget build(BuildContext context) {
    return FortalScope(
      accent: FortalAccentColor.indigo,
      brightness: _brightness,
      child: MaterialApp(
        theme: ThemeData(brightness: _brightness),
        home: Scaffold(
          body: Column(children: [
            FortalSwitch(
              selected: _brightness == Brightness.dark,
              onChanged: (val) => setState(() =>
                _brightness = val ? Brightness.dark : Brightness.light),
            ),
            // ... rest of your UI
          ]),
        ),
      ),
    );
  }
}
```

### Form Layout

```dart
Column(
  spacing: 16,
  children: [
    FortalTextField(
      controller: nameController,
      label: 'Name',
      hintText: 'Enter your name',
      variant: .surface,
    ),
    FortalTextField(
      controller: emailController,
      label: 'Email',
      hintText: 'you@example.com',
      error: emailError,
      variant: .surface,
    ),
    FortalSelect<String>(
      variant: .surface,
      trigger: RemixSelectTrigger(placeholder: 'Country'),
      items: countries.map((c) {
        return RemixSelectItem(
          value: c.code,
          label: c.name,
          style: fortalSelectMenuItemStyler(variant: .surface),
        );
      }).toList(),
      selectedValue: selectedCountry,
      onChanged: (val) => setState(() => selectedCountry = val),
    ),
    Row(children: [
      FortalCheckbox(
        selected: agreedToTerms,
        onChanged: (val) => setState(() => agreedToTerms = val ?? false),
      ),
      SizedBox(width: 8),
      Text('I agree to the terms'),
    ]),
    FortalButton(
      label: 'Submit',
      onPressed: agreedToTerms ? handleSubmit : null,
      variant: .solid,
      size: .size3,
    ),
  ],
)
```
