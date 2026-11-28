import 'package:flutter/foundation.dart' show internal;
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart' hide AnimationConfig;
import 'package:mix/mix.dart' as mix show AnimationConfig;

import 'remix_reduced_motion.dart';

/// Drops [spec]'s animation while motion is reduced under [context], so Mix's
/// driver jumps to the target instead of interpolating toward it.
///
/// For child drivers that resolve a style outside [RemixStyleSpecBuilder].
@internal
StyleSpec<S> remixReducedMotionSpec<S extends Spec<S>>(
  BuildContext context,
  StyleSpec<S> spec,
) => remixReducedMotionOf(context) ? _withoutAnimation(spec) : spec;

StyleSpec<S> _withoutAnimation<S extends Spec<S>>(StyleSpec<S> spec) =>
    spec.animation == null
    ? spec
    : StyleSpec(spec: spec.spec, widgetModifiers: spec.widgetModifiers);

/// Resolves [inner] as Mix does, minus its animation when [reduceMotion].
///
/// Stripping the resolved spec, rather than merging an instant `.animate`
/// over the style, also drops timing that an active variant contributes,
/// because variants merge after the base style.
final class _ReducedMotionStyle<S extends Spec<S>> extends Style<S> {
  _ReducedMotionStyle(this.inner, {required this.reduceMotion})
    : super(
        variants: inner.$variants,
        modifier: inner.$modifier,
        animation: inner.$animation,
      );

  final Style<S> inner;
  final bool reduceMotion;

  StyleSpec<S> _apply(StyleSpec<S> spec) =>
      reduceMotion ? _withoutAnimation(spec) : spec;

  @override
  StyleSpec<S> build(
    BuildContext context, {
    Set<NamedVariant> namedVariants = const {},
  }) => _apply(inner.build(context, namedVariants: namedVariants));

  @override
  StyleSpec<S> resolve(BuildContext context) => _apply(inner.resolve(context));

  /// Mirrors how [StyleBuilder] merges an inherited style into its own.
  @override
  Style<S> merge(covariant Style<S>? other) {
    final next = other is _ReducedMotionStyle<S> ? other.inner : other;
    if (next == null || next is IdentityStyle<S>) return this;
    if (inner is IdentityStyle<S>) {
      return _ReducedMotionStyle(next, reduceMotion: reduceMotion);
    }

    return _ReducedMotionStyle(inner.merge(next), reduceMotion: reduceMotion);
  }

  @override
  Object get mergeKey => inner.mergeKey;

  @override
  List<Object?> get props => [inner, reduceMotion];
}

/// Keeps root completion callbacks on the aggregate renderer while child
/// frame drivers animate the same values. Nested slot configs are unchanged.
@internal
mix.AnimationConfig? remixChildAnimation<S extends Spec<S>>(
  mix.AnimationConfig? config,
) {
  if (config == null) return null;

  final mix.AnimationConfig stripped = switch (config) {
    CurveAnimationConfig() => CurveAnimationConfig(
      duration: config.duration,
      curve: config.curve,
      delay: config.delay,
    ),
    SpringAnimationConfig() => SpringAnimationConfig(spring: config.spring),
    PhaseAnimationConfig<S, Style<S>>() => PhaseAnimationConfig<S, Style<S>>(
      styles: config.styles,
      curveConfigs: [
        for (final curve in config.curveConfigs)
          CurveAnimationConfig(
            duration: curve.duration,
            curve: curve.curve,
            delay: curve.delay,
          ),
      ],
      trigger: config.trigger,
    ),
    _ => config,
  };
  final reverse = remixChildAnimation<S>(mix.AnimationConfig.reverseOf(config));

  return reverse == null
      ? stripped
      : mix.AnimationConfig.reversible(stripped, reverse: reverse);
}

/// Applies resolved Remix text and icon specs as inherited defaults for
/// arbitrary component content.
///
/// Explicit styles on descendants still win, matching the way Radix styles
/// arbitrary button, badge, and callout children through inherited CSS.
@internal
final class RemixDefaultContentStyle extends StatelessWidget {
  const RemixDefaultContentStyle({
    super.key,
    required this.child,
    this.text,
    this.icon,
  });

  final Widget child;
  final StyleSpec<TextSpec>? text;
  final StyleSpec<IconSpec>? icon;

  @override
  Widget build(BuildContext context) {
    final textSpec = text?.spec;
    final iconSpec = icon?.spec;

    Widget current = child;
    if (iconSpec != null) {
      current = IconTheme.merge(
        data: IconThemeData(
          color: iconSpec.color,
          opacity: iconSpec.opacity,
          size: iconSpec.size,
          fill: iconSpec.fill,
          weight: iconSpec.weight,
          grade: iconSpec.grade,
          opticalSize: iconSpec.opticalSize,
          shadows: iconSpec.shadows,
          applyTextScaling: iconSpec.applyTextScaling,
        ),
        child: current,
      );
    }
    if (textSpec != null) {
      current = DefaultTextStyle.merge(
        style: textSpec.style ?? const TextStyle(),
        textAlign: textSpec.textAlign,
        softWrap: textSpec.softWrap,
        overflow: textSpec.overflow,
        maxLines: textSpec.maxLines,
        textWidthBasis: textSpec.textWidthBasis,
        textHeightBehavior: textSpec.textHeightBehavior,
        child: current,
      );
    }
    return current;
  }
}

/// Builds from a raw spec when supplied, otherwise resolves the fluent style.
///
/// While motion is reduced (see [RemixReducedMotionBuilder]), the style's
/// `.animate(...)` timing is dropped and state changes land on their end
/// value in the same frame. When the preference changes, a transition already
/// running finishes on its own timing.
class RemixStyleSpecBuilder<S extends Spec<S>> extends StatelessWidget {
  const RemixStyleSpecBuilder({
    super.key,
    required this.style,
    required this.styleSpec,
    required this.builder,
    this.controller,
    this.trackFocusVisibility = false,
  });

  /// The fluent style to resolve when [styleSpec] is null.
  final Style<S> style;

  /// Optional raw spec that bypasses style resolution when provided.
  final S? styleSpec;

  /// Optional widget state controller for fluent style resolution.
  final WidgetStatesController? controller;

  /// Whether to mount a [FocusVisibilityScope] around the builder.
  ///
  /// Mix-managed controller scopes already provide one. Set this for composite
  /// widgets that publish focus through a manual [WidgetStateProvider], or for
  /// visuals that read [FocusVisibility.of] directly, so they update when
  /// input switches between pointer and keyboard.
  final bool trackFocusVisibility;

  final Widget Function(BuildContext context, S spec) builder;

  @override
  Widget build(BuildContext context) {
    final spec = styleSpec;
    final Widget result = spec != null
        ? StyleSpecBuilder<S>(
            styleSpec: StyleSpec(spec: spec),
            builder: builder,
          )
        : _buildFluent(context);

    if (!trackFocusVisibility) return result;

    return FocusVisibilityScope(child: result);
  }

  // The preference builder rebuilds on platform `reduceMotion` changes, which
  // notify no inherited widget. Mix animates the first change after a toggle
  // with the outgoing spec's timing, so a stale spec would animate once more.
  Widget _buildFluent(BuildContext context) => RemixReducedMotionBuilder(
    builder: (context, reduceMotion) {
      final inherited = Style.maybeOf<S>(context);
      final fluent = StyleBuilder<S>(
        style: _ReducedMotionStyle(style, reduceMotion: reduceMotion),
        controller: controller,
        builder: inherited == null
            ? builder
            : (_, spec) => StyleProvider<S>(
                style: inherited,
                child: Builder(builder: (context) => builder(context, spec)),
              ),
      );
      if (inherited == null) return fluent;

      // StyleBuilder merges the inherited style into ours, and a generated
      // styler cannot merge the wrapper. Offer it a wrapped copy, then
      // restore the original for the builder and its descendants.
      return StyleProvider<S>(
        style: _ReducedMotionStyle(inherited, reduceMotion: reduceMotion),
        child: fluent,
      );
    },
  );
}

/// Canonical Box-style anchors supplied by a forwarded nested styler.
abstract interface class RemixBoxStylerAnchors<T extends Mix<Object?>> {
  T padding(EdgeInsetsGeometryMix value);

  T margin(EdgeInsetsGeometryMix value);

  T constraints(BoxConstraintsMix value);

  T border(BoxBorderMix value);

  T borderRadius(BorderRadiusGeometryMix value);

  T shape(ShapeBorderMix value);

  T decoration(DecorationMix value);

  T transform(Matrix4 value, {Alignment alignment = .center});
}

/// Marks generated Remix stylers that forward a Box-compatible surface.
mixin RemixBoxStylerMixin<T extends Mix<Object?>>
    implements RemixBoxStylerAnchors<T> {}
