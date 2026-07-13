import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart' hide AnimationConfig;

/// Resolves [style] normally, or renders [styleSpec] directly when supplied.
///
/// This keeps component behavior wrappers identical while allowing specimen
/// sheets and other deterministic renderers to bypass state-driven resolution.
class RemixStyleBuilder<S extends Spec<S>> extends StatelessWidget {
  const RemixStyleBuilder({
    super.key,
    required this.style,
    required this.builder,
    this.styleSpec,
    this.controller,
  });

  final Style<S> style;
  final S? styleSpec;
  final WidgetStatesController? controller;
  final Widget Function(BuildContext context, S spec) builder;

  @override
  Widget build(BuildContext context) {
    final resolved = styleSpec;
    if (resolved != null) return builder(context, resolved);
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
/// - [WidgetModifierStyleMixin] for widget modifiers
/// - [AnimationStyleMixin] for animations
///
/// Usage: Extend this class for basic component styles.
/// ```dart
/// class MyStyle extends RemixStyle<MySpec> {
///   // your implementation
/// }
/// ```
abstract class RemixStyle<S extends Spec<S>, T extends RemixStyle<S, T>>
    extends Style<S>
    with
        VariantStyleMixin<T, S>,
        WidgetStateVariantMixin<T, S>,
        WidgetModifierStyleMixin<T, S>,
        AnimationStyleMixin<T, S> {
  const RemixStyle({super.variants, super.animation, super.modifier});
}

/// Abstract class for container-based component styles.
///
/// Extends [RemixStyle] with container-specific mixins:
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
/// class MyStyle extends RemixContainerStyle<MySpec> {
///   // your implementation
/// }
/// ```
abstract class RemixContainerStyle<
  S extends Spec<S>,
  T extends RemixContainerStyle<S, T>
>
    extends RemixStyle<S, T>
    with
        BorderStyleMixin<T>,
        BorderRadiusStyleMixin<T>,
        ShadowStyleMixin<T>,
        DecorationStyleMixin<T>,
        SpacingStyleMixin<T>,
        TransformStyleMixin<T>,
        ConstraintStyleMixin<T> {
  const RemixContainerStyle({super.variants, super.animation, super.modifier});

  T alignment(Alignment value);
}

/// Abstract class for flex container-based component styles.
///
/// Extends [RemixStyle] with container-specific mixins and flex layout mixins:
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
/// class MyStyle extends RemixFlexContainerStyle<MySpec> {
///   // your implementation
/// }
/// ```
abstract class RemixFlexContainerStyle<
  S extends Spec<S>,
  T extends RemixFlexContainerStyle<S, T>
>
    extends RemixStyle<S, T>
    with
        BorderStyleMixin<T>,
        BorderRadiusStyleMixin<T>,
        ShadowStyleMixin<T>,
        DecorationStyleMixin<T>,
        SpacingStyleMixin<T>,
        TransformStyleMixin<T>,
        ConstraintStyleMixin<T>,
        FlexStyleMixin<T> {
  const RemixFlexContainerStyle({
    super.variants,
    super.animation,
    super.modifier,
  });

  T alignment(Alignment value);
}
