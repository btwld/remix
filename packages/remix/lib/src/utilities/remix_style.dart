import 'package:flutter/foundation.dart' show internal;
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart' hide AnimationConfig;

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
        softWrap: textSpec.softWrap ?? true,
        overflow: textSpec.overflow ?? TextOverflow.clip,
        maxLines: textSpec.maxLines,
        textWidthBasis: textSpec.textWidthBasis ?? TextWidthBasis.parent,
        textHeightBehavior: textSpec.textHeightBehavior,
        child: current,
      );
    }
    return current;
  }
}

/// Builds from a raw spec when supplied, otherwise resolves the fluent style.
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
        : StyleBuilder<S>(
            style: style,
            controller: controller,
            builder: builder,
          );

    if (!trackFocusVisibility) return result;

    return FocusVisibilityScope(child: result);
  }
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
