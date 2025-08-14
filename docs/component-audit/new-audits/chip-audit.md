# Chip Component Audit

## Summary
The Chip component has undergone a significant migration from RxChip to RemixChip, introducing new API patterns and functionality. The component now includes built-in delete functionality and has restructured parameter names for better clarity. The styling system has been completely migrated to the Mix framework while maintaining core selection behavior.

## API Changes

### Parameters Removed
- `variants: List<Variant>` - Removed from main component parameters but integrated into the style system

### Parameters Added  
- `onDeleted: VoidCallback?` - New callback for delete functionality
- `deleteIcon: IconData?` - Icon for delete button (defaults to Icons.close if onDeleted provided)

### Parameters Modified
- `style: RxChipStyle?` → `style: ChipStyle` (changed from nullable to non-nullable with default value `ChipStyle.create()`)
- `onChanged: ValueChanged<bool>?` → `onSelected: ValueChanged<bool>?` (renamed for clarity)
- `iconLeft: IconData?` → `leadingIcon: IconData?` (renamed for clarity)
- `iconRight: IconData?` → `deleteIcon: IconData?` (repurposed for delete functionality)
- Component class renamed: `RxChip` → `RemixChip`
- Default constructor now requires `label` parameter

### Parameters Deprecated
- `iconLeft` - Use `leadingIcon` instead
- `iconRight` - Use `deleteIcon` instead  
- `onChanged` - Use `onSelected` instead

## Styling System Changes

### Old Styling Approach
- FlexBoxSpec for container layout with automatic gap spacing
- Utility-based styling with direct property access
- Properties like `container.flex.gap(4)`, `container.animated.easeInOut(100.ms)`
- Separate icon styling without distinction between leading/trailing

### New Styling Approach
- BoxSpec for container layout with manual Row spacing
- Mix framework-based styling with Spec and Style pattern
- Separate styling for `leadingIcon` and `trailingIcon`
- Fixed 4px spacing between elements via SizedBox widgets
- Enhanced delete functionality with separate touch target

### Missing Style Features
- FlexBoxSpec layout properties (gap, mainAxisSize)
- Automatic spacing via `container.flex.gap(4)`
- Single icon styling (now split into leadingIcon/trailingIcon)

### New Style Features
- Distinct `leadingIcon` and `trailingIcon` styling
- Built-in delete functionality with proper touch targets
- Enhanced Mix framework integration
- Cleaner separation of concerns for different icon types

## Behavior Changes
- Layout changed from FlexBoxSpec to manual Row layout with SizedBox spacing
- Delete icon is now a separate interactive element with its own touch target
- Icon right functionality repurposed for delete operations
- Style resolution now uses StyleBuilder instead of RemixBuilder
- Fixed 4px spacing between all elements (leading icon, label, delete icon)

## Breaking Changes
1. **Class Name**: `RxChip` → `RemixChip`
2. **Style Parameter**: Style parameter is no longer nullable and has default value
3. **Variants**: Variants parameter removed from widget constructor, must be applied through style
4. **Parameter Names**: 
   - `onChanged` → `onSelected`
   - `iconLeft` → `leadingIcon`
   - `iconRight` → `deleteIcon` (functionality changed)
5. **Layout System**: Changed from FlexBoxSpec to manual Row layout
6. **Icon Right Behavior**: Now specifically for delete functionality instead of general trailing icon
7. **Required Parameters**: `label` is now required in default constructor
8. **Style Properties**: 
   - `icon: IconSpec` → `leadingIcon: IconSpec` + `trailingIcon: IconSpec`
   - `container: FlexBoxSpec` → `container: BoxSpec`

## Migration Guide
1. **Update class name**: 
   - `RxChip` → `RemixChip`

2. **Update parameter names**:
   - `onChanged` → `onSelected`
   - `iconLeft` → `leadingIcon`
   - `iconRight` → `deleteIcon` (if used for delete) or remove if used for display

3. **Update delete functionality**:
   - If `iconRight` was used for delete: change to `deleteIcon` and add `onDeleted` callback
   - If `iconRight` was used for display: remove and consider alternative approaches

4. **Update style parameter**:
   - Remove null checks for style parameter
   - Migrate from `RxChipStyle` to `ChipStyle`

5. **Migrate variants**:
   - Move variants from widget parameter to style system

6. **Update styling properties**:
   - Split single `icon` styling into `leadingIcon` and `trailingIcon`
   - Convert FlexBoxSpec to BoxSpec
   - Remove flex gap properties (now fixed at 4px)

## Code Examples

### Old Implementation
```dart
RxChip(
  label: 'Favorite',
  iconLeft: Icons.star_outline,
  iconRight: Icons.close,
  selected: isFavorite,
  onChanged: (selected) {
    if (!selected) {
      // Handle deletion logic
      removeFavorite();
    } else {
      toggleFavorite(selected);
    }
  },
  style: RxChipStyle()
    ..container.color.amber.shade50()
    ..container.flex.gap(6)
    ..icon.size(20)
    ..on.selected(
      RxChipStyle()..container.color.amber.shade200()
    ),
  variants: [PrimaryVariant()],
)
```

### New Implementation  
```dart
RemixChip(
  label: 'Favorite',
  leadingIcon: Icons.star_outline,
  deleteIcon: Icons.close,
  selected: isFavorite,
  onSelected: (selected) => toggleFavorite(selected),
  onDeleted: () => removeFavorite(), // Separate delete callback
  style: ChipStyle(
    container: BoxMix(
      decoration: BoxDecorationMix(color: Colors.amber[50]),
    ),
    leadingIcon: IconMix(size: 20),
    trailingIcon: IconMix(size: 18), // Delete icon styling
    // Note: 4px spacing is now fixed via SizedBox
    variants: [VariantStyle(PrimaryVariant(), ChipStyle())],
  ).variant(
    SelectedVariant(), 
    ChipStyle(container: BoxMix(
      decoration: BoxDecorationMix(color: Colors.amber[200]),
    )),
  ),
)
```