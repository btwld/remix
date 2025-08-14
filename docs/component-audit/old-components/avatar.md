# Avatar - Old Component Documentation

## Overview
The RxAvatar is a customizable avatar component that displays user profile images or text labels. It supports both background and foreground images with error handling, custom styling through the Mix system, and flexible content options. The component can display text labels, custom widgets, or just images, making it suitable for various avatar presentation needs.

## API Parameters

### RxAvatar Parameters

#### Required Parameters
None - all parameters are optional, making the component highly flexible.

#### Optional Parameters
| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| backgroundImage | ImageProvider? | Image to display behind the avatar content | null |
| foregroundImage | ImageProvider? | Image to display in front of the avatar content | null |
| onBackgroundImageError | ImageErrorListener? | Callback when background image fails to load | null |
| onForegroundImageError | ImageErrorListener? | Callback when foreground image fails to load | null |
| variants | List<Variant> | Style variants to apply | const [] |
| style | RxAvatarStyle? | Custom styling configuration | null |
| label | String? | Text to display (default constructor only) | null |
| child | Widget? | Custom widget content (raw constructor only) | null |

## Styling Configuration

### Default Theme Values
```dart
// Default styling from RxAvatarStyle._default()
container.size(50)
container.shape.circle()
container.clipBehavior.antiAlias()
container.color.grey.shade300()
textStyle.fontSize(18)
textStyle.fontWeight.w400()
textStyle.color.black()
```

### Style Properties
| Property | Type | Description | Default Value |
|----------|------|-------------|---------------|
| container | BoxSpec | Container styling (size, shape, color, etc.) | BoxSpec() |
| textStyle | TextStyle | Text styling for labels | TextStyle() |
| icon | IconThemeData | Icon theme configuration | IconThemeData() |
| animated | AnimatedData | Animation configuration | null |

## Behavior Documentation

### Interactions
- **Image Loading**: Automatically handles image loading with fit: BoxFit.cover
- **Error Handling**: Calls error callbacks when images fail to load
- **Content Display**: Centers child content within the avatar container
- **Layering**: Background image renders behind content, foreground image renders in front

### Animation/Transitions
- Supports animated properties via AnimatedData configuration
- Image transitions handled by Flutter's decoration system
- Smooth interpolation between different avatar specs via AvatarSpecTween
- Lerp support for container, textStyle, and icon properties

### State Management
- Static widget with no internal state management
- Image loading states handled by Flutter's image system
- Style changes trigger rebuilds through SpecBuilder
- Error states communicated via callback functions

## Variants and Configurations

### Constructors

#### RxAvatar (Default Constructor)
- Standard avatar with optional label text
```dart
RxAvatar(
  backgroundImage: NetworkImage('url'),
  label: 'JD',
  variants: [PrimaryVariant()],
)
```

#### RxAvatar.raw (Raw Constructor) 
- Avatar with custom widget content
```dart
RxAvatar.raw(
  foregroundImage: NetworkImage('url'),
  child: Icon(Icons.person),
  style: customStyle,
)
```

### Visual Configurations
- **Text Avatar**: Display initials or short text
- **Image Avatar**: Display profile pictures with optional overlays
- **Icon Avatar**: Display icons as avatar content
- **Hybrid Avatar**: Combine background image with text/icon overlay

### Size Variations
- Controlled through `style.container.size(value)`
- Maintains circular shape by default
- Custom shapes via `style.container.shape`

## Accessibility Features
- Proper semantic structure through Flutter's widget hierarchy
- Image alt text support through ImageProvider system
- Text content accessible to screen readers
- Focus management inherited from container widget
- Error states can be announced through callback implementations

## Dependencies
- **Required components**:
  - SpecBuilder (Mix framework integration)
  - ContainerWidget (from BoxSpec)
  - IconTheme (icon theming)
  - DefaultTextStyle (text theming)

- **Utility dependencies**:
  - AvatarSpec (specification pattern)
  - AvatarSpecUtility (styling utilities)
  - MixContext (style resolution)
  - Variant system (style variants)

- **Flutter dependencies**:
  - Container (layout and decoration)
  - BoxDecoration (image handling)
  - DecorationImage (image positioning)
  - Alignment.center (content centering)

## Usage Examples
```dart
// Basic text avatar
RxAvatar(
  label: 'JD',
  style: RxAvatarStyle()..container.size(60),
)

// Profile image avatar
RxAvatar(
  backgroundImage: NetworkImage('https://example.com/profile.jpg'),
  onBackgroundImageError: (error, stackTrace) {
    print('Failed to load avatar image: $error');
  },
)

// Avatar with image and text overlay
RxAvatar(
  backgroundImage: NetworkImage('https://example.com/background.jpg'),
  foregroundImage: NetworkImage('https://example.com/badge.png'),
  label: 'VIP',
)

// Custom icon avatar
RxAvatar.raw(
  child: Icon(Icons.person, size: 24),
  style: RxAvatarStyle()
    ..container.color.blue.shade200()
    ..container.size(48),
)

// Styled avatar with variants
RxAvatar(
  label: 'AD',
  variants: [PrimaryVariant(), LargeVariant()],
  style: RxAvatarStyle()
    ..textStyle.fontWeight.w600()
    ..textStyle.color.white(),
)

// Avatar with custom styling
RxAvatar(
  backgroundImage: NetworkImage('https://example.com/profile.jpg'),
  style: RxAvatarStyle()
    ..container.size(80)
    ..container.shape.squircle()
    ..container.border.all.color.blue.shade300()
    ..container.border.all.width(2),
)
```

## Notes
- Uses assertion checks to ensure error callbacks are only provided when corresponding images are provided
- Image decoration uses BoxFit.cover for consistent aspect ratio handling
- Style merging: default style → custom style → variants applied via Mix framework
- The raw constructor provides maximum flexibility for custom avatar content
- Both constructors support the same styling and image parameters
- Error callbacks receive both exception and stack trace for comprehensive error handling
- Container alignment ensures content is always centered regardless of avatar size
- Generated code includes utilities for copying, equality checking, and animation tweening
- Supports complex layering with both background and foreground images simultaneously