import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

/// A Spec class for widget container properties.
///
/// This extends Spec to provide resolved container styling values for widgets.
class WidgetContainerProperties extends Spec<WidgetContainerProperties>
    with Diagnosticable {
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final AlignmentGeometry? alignment;
  final BoxConstraints? constraints;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final Clip? clipBehavior;

  const WidgetContainerProperties({
    this.decoration,
    this.foregroundDecoration,
    this.padding,
    this.margin,
    this.alignment,
    this.constraints,
    this.transform,
    this.transformAlignment,
    this.clipBehavior,
  });

  @override
  WidgetContainerProperties copyWith({
    Decoration? decoration,
    Decoration? foregroundDecoration,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    AlignmentGeometry? alignment,
    BoxConstraints? constraints,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Clip? clipBehavior,
  }) {
    return WidgetContainerProperties(
      decoration: decoration ?? this.decoration,
      foregroundDecoration: foregroundDecoration ?? this.foregroundDecoration,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      alignment: alignment ?? this.alignment,
      constraints: constraints ?? this.constraints,
      transform: transform ?? this.transform,
      transformAlignment: transformAlignment ?? this.transformAlignment,
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  @override
  WidgetContainerProperties lerp(WidgetContainerProperties? other, double t) {
    if (other == null) return this;

    return WidgetContainerProperties(
      decoration: MixOps.lerp(decoration, other.decoration, t),
      foregroundDecoration: MixOps.lerp(foregroundDecoration, other.foregroundDecoration, t),
      padding: MixOps.lerp(padding, other.padding, t),
      margin: MixOps.lerp(margin, other.margin, t),
      alignment: MixOps.lerp(alignment, other.alignment, t),
      constraints: MixOps.lerp(constraints, other.constraints, t),
      transform: MixOps.lerp(transform, other.transform, t),
      transformAlignment: MixOps.lerp(transformAlignment, other.transformAlignment, t),
      clipBehavior: t < 0.5 ? clipBehavior : other.clipBehavior,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('decoration', decoration))
      ..add(DiagnosticsProperty('foregroundDecoration', foregroundDecoration))
      ..add(DiagnosticsProperty('padding', padding))
      ..add(DiagnosticsProperty('margin', margin))
      ..add(DiagnosticsProperty('alignment', alignment))
      ..add(DiagnosticsProperty('constraints', constraints))
      ..add(DiagnosticsProperty('transform', transform))
      ..add(DiagnosticsProperty('transformAlignment', transformAlignment))
      ..add(EnumProperty<Clip>('clipBehavior', clipBehavior));
  }

  @override
  List<Object?> get props => [
        decoration,
        foregroundDecoration,
        padding,
        margin,
        alignment,
        constraints,
        transform,
        transformAlignment,
        clipBehavior,
      ];
}

/// Extension to convert [WidgetContainerProperties] directly to a [Container] widget.
extension WidgetContainerPropertiesWidget on WidgetContainerProperties {
  Container call({Widget? child}) {
    return Container(
      alignment: alignment,
      padding: padding,
      decoration: decoration,
      foregroundDecoration: foregroundDecoration,
      constraints: constraints,
      margin: margin,
      transform: transform,
      transformAlignment: transformAlignment,
      clipBehavior: clipBehavior ?? Clip.none,
      child: child,
    );
  }
}
