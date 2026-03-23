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

Every Remix component works without `FortalScope`, but Fortal preset styles (like `FortalButtonStyle.solid()`) require it to resolve tokens.

---

## Component Catalog

Remix ships 20 components. Each accepts a `style` parameter for full visual control.

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
RemixButton(
  label: 'Submit',
  onPressed: () => handleSubmit(),
  style: FortalButtonStyle.solid(size: FortalButtonSize.size2),
)

RemixButton(
  label: 'Delete',
  leadingIcon: Icons.delete,
  loading: isDeleting,
  enabled: canDelete,
  onPressed: () => handleDelete(),
  style: FortalButtonStyle.outline(),
)

RemixIconButton(
  icon: Icons.settings,
  onPressed: () => openSettings(),
  style: FortalIconButtonStyle.ghost(),
)
```

### Form Controls

```dart
// Checkbox
RemixCheckbox(
  selected: isChecked,
  onChanged: (val) => setState(() => isChecked = val),
  style: FortalCheckboxStyles.surface(),
)

// Radio group
RemixRadioGroup<String>(
  groupValue: selectedOption,
  onChanged: (val) => setState(() => selectedOption = val),
  child: Column(children: [
    RemixRadio(value: 'a'),
    RemixRadio(value: 'b'),
    RemixRadio(value: 'c'),
  ]),
)

// Switch
RemixSwitch(
  selected: isDarkMode,
  onChanged: (val) => toggleDarkMode(val),
  style: FortalSwitchStyles.soft(),
)

// Slider
RemixSlider(
  value: volume,
  onChanged: (val) => setState(() => volume = val),
  min: 0,
  max: 100,
)

// TextField
RemixTextField(
  controller: emailController,
  label: 'Email',
  hintText: 'you@example.com',
  helperText: 'We will never share your email',
  error: hasError,
  style: FortalTextFieldStyles.surface(),
)
```

### Select & Menu

```dart
// Select (dropdown)
RemixSelect<String>(
  trigger: RemixSelectTrigger(placeholder: 'Choose a fruit'),
  items: [
    RemixSelectItem(value: 'apple', label: 'Apple'),
    RemixSelectItem(value: 'banana', label: 'Banana'),
    RemixSelectItem(value: 'cherry', label: 'Cherry'),
  ],
  selectedValue: selectedFruit,
  onChanged: (val) => setState(() => selectedFruit = val),
  style: FortalSelectStyles.surface(),
)

// Menu (action menu)
RemixMenu<String>(
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
    RemixTabBar(
      child: Row(children: [
        RemixTab(tabId: 'overview', label: 'Overview'),
        RemixTab(tabId: 'details', label: 'Details', icon: Icons.info),
        RemixTab(tabId: 'settings', label: 'Settings'),
      ]),
    ),
    Expanded(child: Column(children: [
      RemixTabView(tabId: 'overview', child: OverviewPanel()),
      RemixTabView(tabId: 'details', child: DetailsPanel()),
      RemixTabView(tabId: 'settings', child: SettingsPanel()),
    ])),
  ]),
)
```

### Accordion

```dart
RemixAccordionGroup<String>(
  controller: accordionController,
  child: Column(children: [
    RemixAccordion(value: 'faq1', title: 'What is Remix?', child: Text('...')),
    RemixAccordion(value: 'faq2', title: 'How does theming work?', child: Text('...')),
  ]),
)
```

### Data Display

```dart
// Avatar
RemixAvatar(
  label: 'JD',
  backgroundImage: NetworkImage('https://...'),
  style: FortalAvatarStyles.soft(size: FortalAvatarSize.size3),
)

// Badge
RemixBadge(
  label: 'New',
  style: FortalBadgeStyles.solid(),
)

// Card
RemixCard(
  style: FortalCardStyles.surface(size: FortalCardSize.size2),
  child: Column(children: [
    Text('Card Title'),
    Text('Card content goes here'),
  ]),
)

// Callout
RemixCallout(
  icon: Icons.info,
  text: 'This is an informational callout.',
  style: FortalCalloutStyles.surface(),
)

// Progress
RemixProgress(value: 0.65, style: FortalProgressStyles.surface())

// Spinner
RemixSpinner(style: FortalSpinnerStyles.create(size: FortalSpinnerSize.size2))

// Divider
RemixDivider(style: FortalDividerStyles.create(size: FortalDividerSize.size1))
```

### Overlays

```dart
// Dialog
showRemixDialog(
  context: context,
  builder: (_) => RemixDialog(
    title: 'Confirm',
    description: 'Are you sure you want to proceed?',
    actions: [
      RemixButton(label: 'Cancel', onPressed: () => Navigator.pop(context),
        style: FortalButtonStyle.outline()),
      RemixButton(label: 'Confirm', onPressed: () { confirm(); Navigator.pop(context); },
        style: FortalButtonStyle.solid()),
    ],
  ),
)

// Tooltip
RemixTooltip(
  tooltipChild: Text('This button saves your work'),
  child: RemixIconButton(icon: Icons.save, onPressed: save),
)
```

---

## Styling Components

Every component takes a `style` parameter. There are two approaches:

### 1. Fortal Presets (Recommended for Consistency)

Fortal styles give you pre-built variants and sizes that follow the design system:

```dart
// Variant + size
FortalButtonStyle.solid(size: FortalButtonSize.size3)
FortalButtonStyle.outline()
FortalButtonStyle.ghost()
FortalButtonStyle.soft()
FortalButtonStyle.surface()

// Or via create():
FortalButtonStyle.create(
  variant: FortalButtonVariant.solid,
  size: FortalButtonSize.size2,
)
```

See `references/fortal-reference.md` for all variants and sizes per component.

### 2. Custom Styles (Full Control via Fluent API)

Build styles from scratch using the chainable fluent API:

```dart
RemixButtonStyle()
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
RemixButtonStyle()
    .color(Colors.blue)
    .labelColor(Colors.white)
    .onHovered(
      RemixButtonStyle()
          .color(Colors.blue.shade700)
    )
    .onPressed(
      RemixButtonStyle()
          .scale(0.97)
    )
    .onFocused(
      RemixButtonStyle()
          .borderAll(color: Colors.white, width: 2)
    )
    .onDisabled(
      RemixButtonStyle()
          .color(Colors.grey)
          .labelColor(Colors.grey.shade400)
    )
```

Components that support selection (checkbox, radio, switch, tabs) also have `.onSelected()`:

```dart
RemixCheckboxStyle()
    .color(Colors.grey.shade200)
    .onSelected(
      RemixCheckboxStyle()
          .color(Colors.blue)
          .indicatorColor(Colors.white)
    )
```

### Animation

Add smooth transitions between states with `.animate()`:

```dart
RemixButtonStyle()
    .color(Colors.blue)
    .onHovered(RemixButtonStyle().color(Colors.blue.shade800))
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

Start from a Fortal preset and layer custom modifications:

```dart
final style = FortalButtonStyle.solid()
    .onHovered(RemixButtonStyle().scale(1.02))
    .animate(AnimationConfig.spring(200.ms));

RemixButton(label: 'Click', onPressed: doThing, style: style)
```

### Defining Styles in Widgets

When defining styles within a widget class, use a **getter** — this is idiomatic Dart for computed properties with no arguments:

```dart
class MyScreen extends StatelessWidget {
  RemixButtonStyle get _gradientButtonStyle {
    return RemixButtonStyle.create(
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
        .onHovered(RemixButtonStyle().shadow(BoxShadow(
          color: Color(0x80EC4899),
          blurRadius: 28,
          spreadRadius: 4,
        )))
        .onPressed(RemixButtonStyle().scale(0.95))
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
final primaryButton = RemixButtonStyle()
    .color(Colors.blue)
    .labelColor(Colors.white)
    .paddingX(24)
    .paddingY(12)
    .borderRounded(8);

// Call it to produce a widget:
primaryButton(label: 'Save', onPressed: save)
```

This works on: `RemixButtonStyle`, `RemixIconButtonStyle`, `RemixCheckboxStyle`, `RemixSwitchStyle`, `RemixRadioStyle`, `RemixSliderStyle`, `RemixTextFieldStyle`, `RemixSelectStyle`, `RemixMenuStyle`, `RemixSpinnerStyle`.

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

### Component Fortal Styles

Every component with Fortal support follows the same pattern:

```dart
Fortal<Component>Style.create(
  variant: Fortal<Component>Variant.<name>,
  size: Fortal<Component>Size.<name>,
)

// Or use named constructors for variants:
FortalButtonStyle.solid()
FortalButtonStyle.outline(size: FortalButtonSize.size3)
```

### Fortal Tokens

When building custom styles that should respect the Fortal theme, reference tokens using `FortalTokens`:

```dart
RemixButtonStyle.create(
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

## Responsive & Platform Variants

Styles support responsive and platform-aware overrides:

```dart
RemixButtonStyle()
    .paddingX(24)
    .onMobile(RemixButtonStyle().paddingX(16).labelFontSize(14))
    .onTablet(RemixButtonStyle().paddingX(20))
    .onDark(RemixButtonStyle().color(Colors.blue.shade800))
    .onLight(RemixButtonStyle().color(Colors.blue))
```

Available context variants: `.onDark()`, `.onLight()`, `.onMobile()`, `.onTablet()`, `.onDesktop()`, `.onPortrait()`, `.onLandscape()`, `.onIos()`, `.onAndroid()`, `.onMacos()`, `.onWindows()`, `.onLinux()`, `.onWeb()`.

---

## Style Hierarchy Quick Reference

All component styles inherit from a base that determines what convenience methods are available:

- **`RemixContainerStyle`** (box-based): `.color()`, `.padding()`, `.margin()`, `.borderRadius()`, `.border()`, `.shadow()`, `.size()`, `.width()`, `.height()`, `.constraints()`, `.alignment()`, `.transform()`, `.scale()`, `.rotate()`
- **`RemixFlexContainerStyle`** (flex-based): everything above + `.spacing()`, `.direction()`, `.mainAxisAlignment()`, `.crossAxisAlignment()`, `.row()`, `.column()`

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
  static RemixButtonStyle get primaryButton => FortalButtonStyle.solid()
      .animate(AnimationConfig.spring(200.ms));

  static RemixButtonStyle get secondaryButton => FortalButtonStyle.outline()
      .animate(AnimationConfig.spring(200.ms));

  static RemixButtonStyle get dangerButton => FortalButtonStyle.solid()
      .color(Colors.red)
      .onHovered(RemixButtonStyle().color(Colors.red.shade700))
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
            RemixSwitch(
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
    RemixTextField(
      controller: nameController,
      label: 'Name',
      hintText: 'Enter your name',
      style: FortalTextFieldStyles.surface(),
    ),
    RemixTextField(
      controller: emailController,
      label: 'Email',
      hintText: 'you@example.com',
      error: emailError,
      style: FortalTextFieldStyles.surface(),
    ),
    RemixSelect<String>(
      trigger: RemixSelectTrigger(placeholder: 'Country'),
      items: countries.map((c) =>
        RemixSelectItem(value: c.code, label: c.name)).toList(),
      selectedValue: selectedCountry,
      onChanged: (val) => setState(() => selectedCountry = val),
    ),
    Row(children: [
      RemixCheckbox(
        selected: agreedToTerms,
        onChanged: (val) => setState(() => agreedToTerms = val ?? false),
      ),
      SizedBox(width: 8),
      Text('I agree to the terms'),
    ]),
    RemixButton(
      label: 'Submit',
      onPressed: agreedToTerms ? handleSubmit : null,
      style: FortalButtonStyle.solid(size: FortalButtonSize.size3),
    ),
  ],
)
```
