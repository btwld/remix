# Remix Design System Guidelines

## Design Pattern Consistency Rules

Based on audit findings, all components MUST follow these consistent patterns:

### 1. **SPACING PATTERNS**
- **Padding**: Always use `RemixTokens.spaceXs/Sm/Md/Lg/Xl/Xxl` (4px/8px/12px/16px/24px/32px)
- **Gaps**: Always use `RemixTokens.spaceSm` (8px) for standard gaps, `RemixTokens.spaceXs` (4px) for compact
- **Margins**: Use spacing tokens consistently

#### Standard Spacing Usage:
- **Small components** (badges, chips): `RemixTokens.spaceXs` to `RemixTokens.spaceSm`
- **Medium components** (buttons, inputs): `RemixTokens.spaceSm` to `RemixTokens.spaceMd`  
- **Large components** (cards, callouts): `RemixTokens.spaceMd` to `RemixTokens.spaceLg`

### 2. **BORDER RADIUS PATTERNS**
- **Small elements** (badges, chips): `RemixTokens.radiusSm` (4px)
- **Input elements** (textfields, selects): `RemixTokens.radiusMd` (6px)
- **Container elements** (buttons, cards): `RemixTokens.radiusLg` (8px)
- **Prominent elements** (modals, large containers): `RemixTokens.radiusXl` (12px)

#### Special Cases:
- **Pills/Rounded buttons**: Use `99px` or calculated circular radius
- **Circular elements**: Use programmatic circular radius (avatars)

### 3. **COLOR PATTERNS**
**NEVER use hardcoded colors. Always use semantic tokens:**

#### Primary Colors:
- `RemixTokens.primary()` - Main brand actions
- `RemixTokens.secondary()` - Supporting actions  
- `RemixTokens.success()` - Positive states
- `RemixTokens.danger()` - Error/destructive states
- `RemixTokens.warning()` - Cautionary states

#### Surface Colors:
- `RemixTokens.background()` - Main app background
- `RemixTokens.surface()` - Card/elevated surfaces
- `RemixTokens.surfaceVariant()` - Subtle background variations

#### Text Colors:
- `RemixTokens.textPrimary()` - Main content text
- `RemixTokens.textSecondary()` - Supporting text
- `RemixTokens.textTertiary()` - Least prominent text
- `RemixTokens.textDisabled()` - Disabled text

#### Border Colors:
- `RemixTokens.border()` - Standard borders
- `RemixTokens.borderSubtle()` - Subtle dividers

### 4. **TYPOGRAPHY PATTERNS**
**Always use typography tokens:**
- `RemixTokens.fontSizeSm()` (12px) - Helper text, captions
- `RemixTokens.fontSizeMd()` (14px) - Body text, labels
- `RemixTokens.fontSizeLg()` (16px) - Emphasized text
- `RemixTokens.fontSizeXl()` (18px) - Headings, large text

### 5. **ICON SIZE PATTERNS**
**Always use icon tokens:**
- `RemixTokens.iconSizeSm()` (14px) - Small icons, badges
- `RemixTokens.iconSizeMd()` (16px) - Standard icons
- `RemixTokens.iconSizeLg()` (18px) - Button icons
- `RemixTokens.iconSizeXl()` (20px) - Large icons, list items

### 6. **ELEVATION PATTERNS**
**Use elevation tokens for shadows:**
- `RemixTokens.elevationLow()` - Subtle elevation (buttons on hover)
- `RemixTokens.elevationMd()` - Standard elevation (cards)
- `RemixTokens.elevationHigh()` - High elevation (modals, dropdowns)

### 7. **STATE HANDLING PATTERNS**
**All interactive components MUST include:**
- **Hover state**: Slightly darken/brighten colors
- **Focus state**: Add border ring using primary color
- **Pressed state**: Further darken/brighten
- **Disabled state**: Use `RemixTokens.textDisabled()` and reduce opacity

#### State Color Calculation Pattern:
```dart
.onHovered(color.withValues(alpha: 0.8))
.onPressed(color.withValues(alpha: 0.7))
.onDisabled(RemixTokens.textDisabled())
```

### 8. **ANIMATION PATTERNS**
**Consistent animation durations:**
- **Fast interactions** (hover, focus): 150ms
- **Standard interactions** (state changes): 200ms
- **Complex animations** (expanding, sliding): 300ms

### 9. **COMPONENT SIZE VARIANTS**
**Standard size scale for all components:**
- **Small**: Use `RemixTokens.spaceXs` padding, `RemixTokens.fontSizeSm`, `RemixTokens.iconSizeSm`
- **Medium** (default): Use `RemixTokens.spaceSm` padding, `RemixTokens.fontSizeMd`, `RemixTokens.iconSizeMd`
- **Large**: Use `RemixTokens.spaceMd` padding, `RemixTokens.fontSizeLg`, `RemixTokens.iconSizeLg`

### 10. **CONTAINER PATTERNS**
**Standard container structure:**
```dart
container: ContainerSpecMix(
  decoration: BoxDecorationMix(
    color: RemixTokens.surface(),
    borderRadius: BorderRadiusMix.circular(RemixTokens.radiusLg()),
    border: BoxBorderMix.all(BorderSideMix(color: RemixTokens.border(), width: 1)),
    boxShadow: RemixTokens.elevationMd(),
  ),
  padding: EdgeInsetsGeometryMix.all(RemixTokens.spaceMd()),
),
```

## REFACTORING PRIORITY

### High Priority (Core Components):
1. Card - Most used container
2. Badge - Simple utility component  
3. Chip - Similar to badge pattern
4. Callout - Important feedback component

### Medium Priority (Form Components):
5. Checkbox - Form controls consistency
6. Radio - Form controls consistency  
7. Switch - Form controls consistency
8. Select - Complex input component

### Lower Priority (Specialized Components):
9. Avatar - Visual component
10. Accordion - Layout component
11. List Item - Layout component
12. Progress - Feedback component
13. Slider - Complex input
14. Spinner - Simple feedback
15. Divider - Layout utility
16. Tooltip - Overlay component

Each component refactoring MUST:
- Replace ALL hardcoded values with appropriate tokens
- Implement consistent state handling
- Follow spacing and sizing patterns
- Use semantic color tokens
- Include proper elevation/shadow patterns