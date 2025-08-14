# ListItem Component Audit

## Summary
The ListItem component has undergone a streamlined migration from RxListItem to RemixListItem, maintaining core functionality while adopting the Mix framework and simplifying the interaction system. The component moved from using Pressable to GestureDetector, and restructured the layout system from FlexBox to manual Row/Column layout with SizedBox spacing.

## API Changes

### Parameters Removed
- `variants: List<Variant>` - Removed from main component parameters but integrated into the style system
- `enabled: bool` - Removed (interaction control now only through onTap presence)
- `focusNode: FocusNode?` - Removed (no longer supports focus management)
- `onPress: VoidCallback?` - Renamed to `onTap: VoidCallback?`

### Parameters Added  
- None (parameter changes were renames/removals)

### Parameters Modified
- `style: RxListItemStyle?` → `style: ListItemStyle` (changed from nullable to non-nullable with default value)
- `onPress: VoidCallback?` → `onTap: VoidCallback?` (renamed)
- `title: String` → `title: String?` (changed from required to optional)
- Component class renamed: `RxListItem` → `RemixListItem`

## Styling System Changes

### Old Styling Approach
- FlexBoxSpec for container and title/subtitle container layout
- Pressable wrapper for interaction handling
- Automatic gap spacing via `container.flex.gap()` and `titleSubtitleContainer.flex.gap()`
- Complex flex configuration with expand wrappers
- Properties like `container.flex.gap(12)`, `titleSubtitleContainer.wrap.expanded()`

### New Styling Approach
- Manual Row/Column layout with SizedBox spacing
- GestureDetector for interaction handling
- Fixed 16px spacing via SizedBox widgets
- Separate IconTheme contexts for leading and trailing icons
- BoxSpec for container, separate styling for content container

### Missing Style Features
- FlexBoxSpec layout properties and automatic gap spacing
- Pressable interaction states (hover, press, focus)
- Focus management capabilities
- `enabled` parameter and disable state handling
- Complex flex configuration options

### New Style Features
- Distinct `leadingIcon` and `trailingIcon` styling
- Separate `contentContainer` styling for title/subtitle area
- Simplified interaction model
- Enhanced Icon theming for leading/trailing elements

## Behavior Changes
- Interaction changed from Pressable to GestureDetector (loses hover, focus, press states)
- Layout changed from FlexBoxSpec to manual Row/Column with SizedBox
- Focus management removed entirely
- No disabled state handling
- Fixed spacing instead of configurable gaps

## Breaking Changes
1. **Class Name**: `RxListItem` → `RemixListItem`
2. **Style Parameter**: Style parameter is no longer nullable and has default value
3. **Variants**: Variants parameter removed from widget constructor, must be applied through style
4. **Interaction System**: Changed from Pressable to GestureDetector
5. **Parameter Changes**:
   - `onPress` → `onTap` (renamed)
   - `title` became optional instead of required
   - `enabled` parameter removed
   - `focusNode` parameter removed
6. **Layout System**: Changed from FlexBoxSpec to manual layout
7. **Focus Management**: Completely removed

## Migration Guide
1. **Update class name**: 
   - `RxListItem` → `RemixListItem`

2. **Update callback parameter**:
   - `onPress` → `onTap`

3. **Handle disabled state**:
   - Remove `enabled` parameter
   - Control interaction by setting `onTap` to null

4. **Remove focus management**:
   - Remove `focusNode` parameter
   - Handle focus differently if needed

5. **Update style parameter**:
   - Remove null checks for style parameter
   - Migrate from `RxListItemStyle` to `ListItemStyle`

6. **Update styling properties**:
   - Replace FlexBoxSpec properties with BoxSpec equivalents
   - Remove gap configuration (now fixed at 16px)
   - Add distinct icon styling if needed

## Code Examples

### Old Implementation
```dart
RxListItem(
  title: 'Settings',
  subtitle: 'Manage your preferences',
  leading: Icon(Icons.settings),
  trailing: Icon(Icons.chevron_right),
  enabled: true,
  focusNode: myFocusNode,
  onPress: () => Navigator.pushNamed(context, '/settings'),
  style: RxListItemStyle()
    ..container.padding(16)
    ..container.flex.gap(16)
    ..titleSubtitleContainer.flex.gap(4)
    ..title.style.fontWeight.w600()
    ..subtitle.style.color.grey.shade600(),
  variants: [PrimaryVariant()],
)
```

### New Implementation  
```dart
RemixListItem(
  title: 'Settings',
  subtitle: 'Manage your preferences',
  leading: Icon(Icons.settings),
  trailing: Icon(Icons.chevron_right),
  onTap: () => Navigator.pushNamed(context, '/settings'),
  style: ListItemStyle(
    container: BoxMix(
      padding: EdgeInsetsMix.all(16),
    ),
    contentContainer: BoxMix(), // New container for title/subtitle
    title: TextMix(style: TextStyleMix(
      fontWeight: FontWeight.w600,
    )),
    subtitle: TextMix(style: TextStyleMix(
      color: Colors.grey[600],
    )),
    leadingIcon: IconMix(), // New distinct icon styling
    trailingIcon: IconMix(), // New distinct icon styling
    // Note: 16px spacing is now fixed via SizedBox
    variants: [VariantStyle(PrimaryVariant(), ListItemStyle())],
  ),
)
```