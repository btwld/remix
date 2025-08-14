# Radio Component Audit

## Summary
The Radio component has undergone a significant architectural change from RxRadioGroup/RxRadio system to a standalone RemixRadio component. The migration eliminates the group container pattern in favor of individual radio components that manage their own selection state through groupValue comparison, following standard Flutter Radio patterns more closely.

## API Changes

### Parameters Removed (Group Component)
- `RxRadioGroup<T>` component eliminated entirely
- `variants: List<Variant>` - Removed from main component parameters but integrated into the style system

### Parameters Added  
- `groupValue: T?` - Current selection value for the radio group (replaces group container)

### Parameters Modified
- `style: RxRadioStyle?` → `style: RadioStyle` (changed from nullable to non-nullable with default value)
- Component class renamed: `RxRadio<T>` → `RemixRadio<T>`
- Selection logic: individual component compares `value` with `groupValue` instead of group management
- `onChanged: ValueChanged<T?>?` now passes the radio's value instead of group managing state

### Architecture Changes
- **Old**: `RxRadioGroup` container with `RxRadio` children
- **New**: Independent `RemixRadio` components with shared `groupValue`

## Styling System Changes

### Old Styling Approach
- Group-level styling shared via StyleScope
- FlexBoxSpec for container layout with automatic gap spacing
- Two-level styling: group and individual radio
- Properties like `container.flex.gap(8)`, `indicator.wrap.opacity(0)`

### New Styling Approach
- Individual radio styling only
- Manual Row layout with SizedBox spacing for label
- Mix framework-based styling with Spec and Style pattern
- Direct selection state handling without opacity animations

### Missing Style Features
- Group-level style sharing
- FlexBoxSpec automatic gap spacing
- Opacity-based selection animations
- Complex flex configuration options

### New Style Features
- Simplified individual radio styling
- Enhanced Mix framework integration
- Direct selection state management
- Standard Flutter Radio behavior patterns

## Behavior Changes
- No group container - each radio manages its own selection state comparison
- Layout changed from FlexBoxSpec to manual Row with SizedBox
- Selection determined by `value == groupValue` comparison
- onChanged callback receives the radio's value when selected
- Fixed 8px spacing between radio and label

## Breaking Changes
1. **Architecture**: Complete elimination of `RxRadioGroup` container
2. **Class Names**: `RxRadio<T>` → `RemixRadio<T>`, `RxRadioGroup<T>` removed
3. **Style Parameter**: Style parameter is no longer nullable and has default value
4. **Variants**: Variants parameter removed from widget constructor, must be applied through style
5. **State Management**: Changed from group-managed to individual comparison-based
6. **Layout System**: Changed from FlexBoxSpec to manual Row layout
7. **Selection Logic**: Each radio compares its value with groupValue

## Migration Guide
1. **Eliminate group container**:
   - Remove `RxRadioGroup` wrapper
   - Add `groupValue` parameter to each `RemixRadio`
   - Update `onChanged` to handle individual radio selection

2. **Update class name**: 
   - `RxRadio<T>` → `RemixRadio<T>`

3. **Update selection logic**:
   - Pass current selection as `groupValue` to all radios
   - Update `onChanged` callback to set new selection value

4. **Update style parameter**:
   - Remove null checks for style parameter
   - Migrate from `RxRadioStyle` to `RadioStyle`

5. **Migrate variants**:
   - Move variants from group to individual radios
   - Apply same styling to related radios if needed

## Code Examples

### Old Implementation
```dart
RxRadioGroup<Options>(
  value: _selectedOption,
  onChanged: (value) {
    setState(() {
      _selectedOption = value;
    });
  },
  style: RxRadioStyle()
    ..indicator.color.blue.shade600()
    ..text.style.fontSize(16),
  variants: [PrimaryVariant()],
  child: Column(
    children: [
      RxRadio(
        label: 'Banana',
        value: Options.banana,
      ),
      RxRadio(
        label: 'Apple', 
        value: Options.apple,
      ),
      RxRadio(
        label: 'Orange',
        value: Options.orange,
      ),
    ],
  ),
)
```

### New Implementation  
```dart
Column(
  children: [
    RemixRadio<Options>(
      value: Options.banana,
      groupValue: _selectedOption,
      onChanged: (value) {
        setState(() {
          _selectedOption = value;
        });
      },
      label: 'Banana',
      style: RadioStyle(
        indicator: BoxMix(
          decoration: BoxDecorationMix(color: Colors.blue[600]),
        ),
        label: TextMix(style: TextStyleMix(fontSize: 16)),
        variants: [VariantStyle(PrimaryVariant(), RadioStyle())],
      ),
    ),
    RemixRadio<Options>(
      value: Options.apple,
      groupValue: _selectedOption,
      onChanged: (value) {
        setState(() {
          _selectedOption = value;
        });
      },
      label: 'Apple',
      style: RadioStyle(
        indicator: BoxMix(
          decoration: BoxDecorationMix(color: Colors.blue[600]),
        ),
        label: TextMix(style: TextStyleMix(fontSize: 16)),
        variants: [VariantStyle(PrimaryVariant(), RadioStyle())],
      ),
    ),
    RemixRadio<Options>(
      value: Options.orange,
      groupValue: _selectedOption,
      onChanged: (value) {
        setState(() {
          _selectedOption = value;
        });
      },
      label: 'Orange',
      style: RadioStyle(
        indicator: BoxMix(
          decoration: BoxDecorationMix(color: Colors.blue[600]),
        ),
        label: TextMix(style: TextStyleMix(fontSize: 16)),
        variants: [VariantStyle(PrimaryVariant(), RadioStyle())],
      ),
    ),
  ],
)
```