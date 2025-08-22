import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'widget_container_properties.dart';

/// Mix class for configuring [WidgetContainerProperties] properties.
///
/// Encapsulates alignment, padding, margin, constraints, decoration,
/// and other styling properties for container layouts with support for
/// proper Mix framework integration. Note: BoxMix mixins require Style<T>
/// so they cannot be used here since this extends Mix<T>.
final class WidgetContainerPropertiesMix extends Mix<WidgetContainerProperties>
    with Diagnosticable {
  final Prop<Decoration>? $decoration;
  final Prop<Decoration>? $foregroundDecoration;
  final Prop<EdgeInsetsGeometry>? $padding;
  final Prop<EdgeInsetsGeometry>? $margin;
  final Prop<AlignmentGeometry>? $alignment;
  final Prop<BoxConstraints>? $constraints;
  final Prop<Matrix4>? $transform;
  final Prop<AlignmentGeometry>? $transformAlignment;
  final Prop<Clip>? $clipBehavior;

  /// Main constructor with user-friendly Mix types
  WidgetContainerPropertiesMix({
    DecorationMix? decoration,
    DecorationMix? foregroundDecoration,
    EdgeInsetsGeometryMix? padding,
    EdgeInsetsGeometryMix? margin,
    AlignmentGeometry? alignment,
    BoxConstraintsMix? constraints,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Clip? clipBehavior,
  }) : this.create(
          decoration: Prop.maybeMix(decoration),
          foregroundDecoration: Prop.maybeMix(foregroundDecoration),
          padding: Prop.maybeMix(padding),
          margin: Prop.maybeMix(margin),
          alignment: Prop.maybe(alignment),
          constraints: Prop.maybeMix(constraints),
          transform: Prop.maybe(transform),
          transformAlignment: Prop.maybe(transformAlignment),
          clipBehavior: Prop.maybe(clipBehavior),
        );

  /// Create constructor with Prop<T> types for internal use
  const WidgetContainerPropertiesMix.create({
    Prop<Decoration>? decoration,
    Prop<Decoration>? foregroundDecoration,
    Prop<EdgeInsetsGeometry>? padding,
    Prop<EdgeInsetsGeometry>? margin,
    Prop<AlignmentGeometry>? alignment,
    Prop<BoxConstraints>? constraints,
    Prop<Matrix4>? transform,
    Prop<AlignmentGeometry>? transformAlignment,
    Prop<Clip>? clipBehavior,
  })  : $decoration = decoration,
        $foregroundDecoration = foregroundDecoration,
        $padding = padding,
        $margin = margin,
        $alignment = alignment,
        $constraints = constraints,
        $transform = transform,
        $transformAlignment = transformAlignment,
        $clipBehavior = clipBehavior;

  /// Constructor that accepts a [WidgetContainerProperties] value and extracts its properties.
  WidgetContainerPropertiesMix.value(WidgetContainerProperties spec)
      : this(
          decoration: DecorationMix.maybeValue(spec.decoration),
          foregroundDecoration:
              DecorationMix.maybeValue(spec.foregroundDecoration),
          padding: EdgeInsetsGeometryMix.maybeValue(spec.padding),
          margin: EdgeInsetsGeometryMix.maybeValue(spec.margin),
          alignment: spec.alignment,
          constraints: BoxConstraintsMix.maybeValue(spec.constraints),
          transform: spec.transform,
          transformAlignment: spec.transformAlignment,
          clipBehavior: spec.clipBehavior,
        );

  // Factory constructors for common use cases

  /// Color factory
  factory WidgetContainerPropertiesMix.color(Color value) {
    return WidgetContainerPropertiesMix(decoration: DecorationMix.color(value));
  }

  /// Decoration factory
  factory WidgetContainerPropertiesMix.decoration(DecorationMix value) {
    return WidgetContainerPropertiesMix(decoration: value);
  }

  /// Foreground decoration factory
  factory WidgetContainerPropertiesMix.foregroundDecoration(DecorationMix value) {
    return WidgetContainerPropertiesMix(foregroundDecoration: value);
  }

  /// Alignment factory
  factory WidgetContainerPropertiesMix.alignment(AlignmentGeometry value) {
    return WidgetContainerPropertiesMix(alignment: value);
  }

  /// Padding factory
  factory WidgetContainerPropertiesMix.padding(EdgeInsetsGeometryMix value) {
    return WidgetContainerPropertiesMix(padding: value);
  }

  /// Margin factory
  factory WidgetContainerPropertiesMix.margin(EdgeInsetsGeometryMix value) {
    return WidgetContainerPropertiesMix(margin: value);
  }

  /// Transform factory
  factory WidgetContainerPropertiesMix.transform(Matrix4 value) {
    return WidgetContainerPropertiesMix(transform: value);
  }

  /// Transform alignment factory
  factory WidgetContainerPropertiesMix.transformAlignment(AlignmentGeometry value) {
    return WidgetContainerPropertiesMix(transformAlignment: value);
  }

  /// Clip behavior factory
  factory WidgetContainerPropertiesMix.clipBehavior(Clip value) {
    return WidgetContainerPropertiesMix(clipBehavior: value);
  }

  /// Constraints factory
  factory WidgetContainerPropertiesMix.constraints(BoxConstraintsMix value) {
    return WidgetContainerPropertiesMix(constraints: value);
  }


  /// Constructor that accepts a nullable [WidgetContainerProperties] value.
  ///
  /// Returns null if the input is null, otherwise uses [WidgetContainerPropertiesMix.value].
  static WidgetContainerPropertiesMix? maybeValue(WidgetContainerProperties? spec) {
    return spec != null ? WidgetContainerPropertiesMix.value(spec) : null;
  }

  // Chainable instance methods

  /// Returns a copy with the specified color.
  WidgetContainerPropertiesMix color(Color value) {
    return merge(WidgetContainerPropertiesMix.color(value));
  }

  /// Returns a copy with the specified decoration.
  WidgetContainerPropertiesMix decoration(DecorationMix value) {
    return merge(WidgetContainerPropertiesMix.decoration(value));
  }

  /// Returns a copy with the specified foreground decoration.
  WidgetContainerPropertiesMix foregroundDecoration(DecorationMix value) {
    return merge(WidgetContainerPropertiesMix.foregroundDecoration(value));
  }

  /// Returns a copy with the specified alignment.
  WidgetContainerPropertiesMix alignment(AlignmentGeometry value) {
    return merge(WidgetContainerPropertiesMix.alignment(value));
  }

  /// Returns a copy with the specified padding.
  WidgetContainerPropertiesMix padding(EdgeInsetsGeometryMix value) {
    return merge(WidgetContainerPropertiesMix.padding(value));
  }

  /// Returns a copy with the specified margin.
  WidgetContainerPropertiesMix margin(EdgeInsetsGeometryMix value) {
    return merge(WidgetContainerPropertiesMix.margin(value));
  }

  /// Returns a copy with the specified transform.
  WidgetContainerPropertiesMix transform(Matrix4 value) {
    return merge(WidgetContainerPropertiesMix.transform(value));
  }

  /// Returns a copy with the specified transform alignment.
  WidgetContainerPropertiesMix transformAlignment(AlignmentGeometry value) {
    return merge(WidgetContainerPropertiesMix.transformAlignment(value));
  }

  /// Returns a copy with the specified clip behavior.
  WidgetContainerPropertiesMix clipBehavior(Clip value) {
    return merge(WidgetContainerPropertiesMix.clipBehavior(value));
  }

  /// Returns a copy with the specified constraints.
  WidgetContainerPropertiesMix constraints(BoxConstraintsMix value) {
    return merge(WidgetContainerPropertiesMix.constraints(value));
  }

  /// Resolves to [WidgetContainerProperties] using the provided [BuildContext].
  @override
  WidgetContainerProperties resolve(BuildContext context) {
    return WidgetContainerProperties(
      decoration: MixOps.resolve(context, $decoration),
      foregroundDecoration: MixOps.resolve(context, $foregroundDecoration),
      padding: MixOps.resolve(context, $padding),
      margin: MixOps.resolve(context, $margin),
      alignment: MixOps.resolve(context, $alignment),
      constraints: MixOps.resolve(context, $constraints),
      transform: MixOps.resolve(context, $transform),
      transformAlignment: MixOps.resolve(context, $transformAlignment),
      clipBehavior: MixOps.resolve(context, $clipBehavior),
    );
  }

  /// Merges the properties of this [WidgetContainerPropertiesMix] with the properties of [other].
  @override
  WidgetContainerPropertiesMix merge(WidgetContainerPropertiesMix? other) {
    if (other == null) return this;

    return WidgetContainerPropertiesMix.create(
      decoration: MixOps.merge($decoration, other.$decoration),
      foregroundDecoration:
          MixOps.merge($foregroundDecoration, other.$foregroundDecoration),
      padding: MixOps.merge($padding, other.$padding),
      margin: MixOps.merge($margin, other.$margin),
      alignment: MixOps.merge($alignment, other.$alignment),
      constraints: MixOps.merge($constraints, other.$constraints),
      transform: MixOps.merge($transform, other.$transform),
      transformAlignment:
          MixOps.merge($transformAlignment, other.$transformAlignment),
      clipBehavior: MixOps.merge($clipBehavior, other.$clipBehavior),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('decoration', $decoration))
      ..add(DiagnosticsProperty('foregroundDecoration', $foregroundDecoration))
      ..add(DiagnosticsProperty('padding', $padding))
      ..add(DiagnosticsProperty('margin', $margin))
      ..add(DiagnosticsProperty('alignment', $alignment))
      ..add(DiagnosticsProperty('constraints', $constraints))
      ..add(DiagnosticsProperty('transform', $transform))
      ..add(DiagnosticsProperty('transformAlignment', $transformAlignment))
      ..add(DiagnosticsProperty('clipBehavior', $clipBehavior));
  }

  @override
  List<Object?> get props => [
        $decoration,
        $foregroundDecoration,
        $padding,
        $margin,
        $alignment,
        $constraints,
        $transform,
        $transformAlignment,
        $clipBehavior,
      ];
}