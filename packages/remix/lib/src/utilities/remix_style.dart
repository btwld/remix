import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart' hide AnimationConfig;

/// Builds from a raw spec when supplied, otherwise resolves the fluent style.
class RemixStyleSpecBuilder<S extends Spec<S>> extends StatelessWidget {
  /// Creates a builder that supports both style and raw spec inputs.
  const RemixStyleSpecBuilder({
    super.key,
    required this.style,
    required this.styleSpec,
    required this.builder,
    this.controller,
  });

  /// The fluent style to resolve when [styleSpec] is null.
  final Style<S> style;

  /// Optional raw spec that bypasses style resolution when provided.
  final S? styleSpec;

  /// Optional widget state controller for fluent style resolution.
  final WidgetStatesController? controller;

  /// Builds the widget with the resolved or supplied spec.
  final Widget Function(BuildContext context, S spec) builder;

  @override
  Widget build(BuildContext context) {
    final spec = styleSpec;
    if (spec != null) {
      return StyleSpecBuilder<S>(
        styleSpec: StyleSpec(spec: spec),
        builder: builder,
      );
    }

    return StyleBuilder<S>(
      style: style,
      controller: controller,
      builder: builder,
    );
  }
}

/// Base abstract class for all Remix component styles.
///
/// Provides universal mixins that all components share:
/// - [VariantStyleMixin] for style variants
/// - [WidgetStateVariantMixin] for widget-state variants
/// - [WidgetModifierStyleMixin] for widget modifiers
/// - [AnimationStyleMixin] for animations
///
/// Usage: Extend this class for basic component styles.
/// ```dart
/// class MyStyle extends RemixStyler<MySpec, MyStyle> {
///   // your implementation
/// }
/// ```
abstract class RemixStyler<S extends Spec<S>, T extends RemixStyler<S, T>>
    extends Style<S>
    with
        VariantStyleMixin<T, S>,
        WidgetStateVariantMixin<T, S>,
        WidgetModifierStyleMixin<T, S>,
        AnimationStyleMixin<T, S> {
  const RemixStyler({super.variants, super.animation, super.modifier});
}

/// Abstract class for container-based component styles.
///
/// Extends [RemixStyler] with container-specific mixins:
/// - [BorderStyleMixin] for border styling
/// - [BorderRadiusStyleMixin] for border radius
/// - [ShadowStyleMixin] for shadows
/// - [DecorationStyleMixin] for background decorations
/// - [SpacingStyleMixin] for padding and margin
/// - [TransformStyleMixin] for transformations
/// - [ConstraintStyleMixin] for size constraints
///
/// Usage: Extend this class for component styles that use BoxSpec containers.
/// ```dart
/// class MyStyle extends RemixContainerStyler<MySpec, MyStyle> {
///   // your implementation
/// }
/// ```
abstract class RemixContainerStyler<
  S extends Spec<S>,
  T extends RemixContainerStyler<S, T>
>
    extends RemixStyler<S, T>
    with
        BorderStyleMixin<T>,
        BorderRadiusStyleMixin<T>,
        ShadowStyleMixin<T>,
        DecorationStyleMixin<T>,
        SpacingStyleMixin<T>,
        TransformStyleMixin<T>,
        ConstraintStyleMixin<T> {
  const RemixContainerStyler({super.variants, super.animation, super.modifier});

  T alignment(Alignment value);
}

/// Abstract class for flex container-based component styles.
///
/// Extends [RemixStyler] with container-specific mixins and flex layout mixins:
/// - [BorderStyleMixin] for border styling
/// - [BorderRadiusStyleMixin] for border radius
/// - [ShadowStyleMixin] for shadows
/// - [DecorationStyleMixin] for background decorations
/// - [SpacingStyleMixin] for padding and margin
/// - [TransformStyleMixin] for transformations
/// - [ConstraintStyleMixin] for size constraints
/// - [FlexStyleMixin] for flex layout properties
///
/// Usage: Extend this class for component styles that use FlexBoxSpec containers.
/// ```dart
/// class MyStyle extends RemixFlexContainerStyler<MySpec, MyStyle> {
///   // your implementation
/// }
/// ```
abstract class RemixFlexContainerStyler<
  S extends Spec<S>,
  T extends RemixFlexContainerStyler<S, T>
>
    extends RemixStyler<S, T>
    with
        BorderStyleMixin<T>,
        BorderRadiusStyleMixin<T>,
        ShadowStyleMixin<T>,
        DecorationStyleMixin<T>,
        SpacingStyleMixin<T>,
        TransformStyleMixin<T>,
        ConstraintStyleMixin<T>,
        FlexStyleMixin<T> {
  const RemixFlexContainerStyler({
    super.variants,
    super.animation,
    super.modifier,
  });

  T alignment(Alignment value);
}
