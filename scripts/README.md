# Remix Scripts

This directory contains utility scripts for the Remix Flutter UI library.

## generate_style_docs.dart

Automatically generates documentation for style methods from `*_style.dart` files using the Dart analyzer.

### What it does

This script:
1. Scans all `*_style.dart` files in `lib/src/components/`
2. **Uses the Dart analyzer to parse files into AST (Abstract Syntax Tree)**
3. Extracts public methods from:
   - The style class itself
   - **Base classes it extends** (e.g., `RemixContainerStyle`, `RemixFlexContainerStyle`)
   - **Mixins applied with `with` clause** (e.g., `LabelStyleMixin`, `IconStyleMixin`)
4. Parses method signatures, parameters, and doc comments accurately
5. Deduplicates methods (class implementations override mixin implementations)
6. Generates markdown documentation for all methods
7. Updates corresponding `.mdx` files in `docs/components/`
8. Replaces everything after `## Properties` with generated content

### Usage

```bash
dart scripts/generate_style_docs.dart
```

### Output

The script will:
- Print progress for each component processed
- Show how many public methods were found
- Indicate whether documentation was updated
- Warn if a documentation file is missing

Example output:
```
Found 20 style files

Processing: button
  Found 15 public methods
  ✓ Updated documentation

Processing: spinner
  Found 9 public methods
  ✓ Updated documentation

Done!
```

### Documentation Structure

The script replaces **everything after** the `## Properties` section with the generated style methods:

```markdown
## Constructor

...

## Properties

### Style Methods

#### `padding(EdgeInsetsGeometryMix value)`

Sets padding

#### `margin(EdgeInsetsGeometryMix value)`

Sets margin

#### `size(double width, double height)`

Sets badge dimensions.

#### `label(TextStyler value)`

#### `icon(IconStyler value)`

...
```

**Note**: All content after `## Properties` is replaced, so any existing widget properties or manual documentation should be placed before the `## Properties` section.

### How it works

1. **Finding Style Files**: Recursively searches `lib/src/components/` for files ending in `_style.dart`

2. **AST Parsing**: Uses the Dart `analyzer` package to:
   - Parse each file into an Abstract Syntax Tree (AST)
   - Handle complex Dart syntax correctly
   - Avoid manual string parsing errors

3. **Extracting Class Structure**: Uses AST visitors to find:
   - Style class declarations (classes ending with `Style`)
   - Base class extensions (`extends` clause)
   - Applied mixins (`with` clause)

4. **Extracting Methods**: Collects methods from:
   - **The style class itself**: Public methods that return the style class type
   - **Mixins**: Methods from `LabelStyleMixin`, `IconStyleMixin`, `SpinnerStyleMixin`, etc.
   - **Base class mixins**: Methods from `BorderStyleMixin`, `DecorationStyleMixin`, `SpacingStyleMixin`, etc.
   - Method signatures with parameters (including optional, named, required)
   - Doc comments via the AST comment nodes
   - Skips internal methods: `resolve()`, `merge()`, `copyWith()`, `call()`
   - Deduplicates by name (class methods take precedence over mixin methods)

5. **Markdown Generation**: Creates formatted markdown with:
   - `### Style Methods` header
   - Each method as `#### \`methodName(parameters)\``
   - Doc comments as descriptions

6. **Documentation Update**: 
   - Finds `## Properties` section in `.mdx` files
   - **Replaces everything after `## Properties` with the generated style methods**
   - Clean, simple approach - no manual content preservation needed

### Mixin & Extension Support

The script automatically extracts methods from:

**Component-specific mixins** (from `lib/src/style/mixins/`):
- `LabelStyleMixin`: `label()`, `labelTextStyle()`, `labelColor()`, `labelFontSize()`, etc.
- `IconStyleMixin`: `icon()`, `iconColor()`, `iconSize()`, etc.
- `SpinnerStyleMixin`: `spinner()`, `spinnerSize()`, `spinnerIndicatorColor()`, etc.

**Base class mixins** (from Mix package):
- `BorderStyleMixin`: `border()`, `borderAll()`, etc.
- `BorderRadiusStyleMixin`: `borderRadius()`, `borderRadiusAll()`, etc.
- `ShadowStyleMixin`: `shadow()`, `shadows()`, etc.
- `DecorationStyleMixin`: `decoration()`, `color()`, etc.
- `SpacingStyleMixin`: `padding()`, `margin()`, `paddingX()`, `paddingY()`, etc.
- `TransformStyleMixin`: `transform()`, `scale()`, `rotate()`, etc.
- `ConstraintStyleMixin`: `constraints()`, `width()`, `height()`, etc.
- `FlexStyleMixin`: `flex()`, `mainAxisAlignment()`, `crossAxisAlignment()`, etc.

If a method is defined in both the class and a mixin, the class implementation is used.

### Dependencies

This script requires the `analyzer` package:

```yaml
dev_dependencies:
  analyzer: ^7.5.4
```

The package is already included in the project's `pubspec.yaml`.

### Maintenance

When adding new components:
1. Create the `*_style.dart` file with public methods
2. Create a corresponding `docs/components/[component].mdx` file
3. Run this script to auto-generate the style documentation

When modifying style methods:
1. Update the `*_style.dart` file
2. Run this script to refresh the documentation

### Benefits of Using the Analyzer

- **Accurate Parsing**: Handles all Dart syntax correctly (generics, nested types, etc.)
- **Robust**: No regex fragility or edge cases
- **Future-Proof**: Automatically supports new Dart language features
- **Type Safety**: Proper AST node types for all code elements
- **Doc Comments**: Correctly extracts documentation from AST

### Limitations

- Only processes files that end with `_style.dart`
- Only extracts methods that return the style class type
- Requires a `## Properties` section in the documentation file
- Requires the `analyzer` package dependency

