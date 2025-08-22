import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'container_properties.dart';

/// Mix class for configuring [ContainerProperties] properties.
///
/// Encapsulates alignment, padding, margin, constraints, decoration,
/// and other styling properties for container layouts with support for
/// proper Mix framework integration. Note: BoxMix mixins require Style<T>
/// so they cannot be used here since this extends Mix<T>.
final class ContainerPropertiesMix extends Mix<ContainerProperties>
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
  ContainerPropertiesMix({
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
  const ContainerPropertiesMix.create({
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

  /// Constructor that accepts a [ContainerProperties] value and extracts its properties.
  ContainerPropertiesMix.value(ContainerProperties spec)
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
  factory ContainerPropertiesMix.color(Color value) {
    return ContainerPropertiesMix(decoration: DecorationMix.color(value));
  }

  /// Decoration factory
  factory ContainerPropertiesMix.decoration(DecorationMix value) {
    return ContainerPropertiesMix(decoration: value);
  }

  /// Foreground decoration factory
  factory ContainerPropertiesMix.foregroundDecoration(DecorationMix value) {
    return ContainerPropertiesMix(foregroundDecoration: value);
  }

  /// Alignment factory
  factory ContainerPropertiesMix.alignment(AlignmentGeometry value) {
    return ContainerPropertiesMix(alignment: value);
  }

  /// Padding factory
  factory ContainerPropertiesMix.padding(EdgeInsetsGeometryMix value) {
    return ContainerPropertiesMix(padding: value);
  }

  /// Margin factory
  factory ContainerPropertiesMix.margin(EdgeInsetsGeometryMix value) {
    return ContainerPropertiesMix(margin: value);
  }

  /// Transform factory
  factory ContainerPropertiesMix.transform(Matrix4 value) {
    return ContainerPropertiesMix(transform: value);
  }

  /// Transform alignment factory
  factory ContainerPropertiesMix.transformAlignment(AlignmentGeometry value) {
    return ContainerPropertiesMix(transformAlignment: value);
  }

  /// Clip behavior factory
  factory ContainerPropertiesMix.clipBehavior(Clip value) {
    return ContainerPropertiesMix(clipBehavior: value);
  }

  /// Constraints factory
  factory ContainerPropertiesMix.constraints(BoxConstraintsMix value) {
    return ContainerPropertiesMix(constraints: value);
  }


  /// Constructor that accepts a nullable [ContainerProperties] value.
  ///
  /// Returns null if the input is null, otherwise uses [ContainerPropertiesMix.value].
  static ContainerPropertiesMix? maybeValue(ContainerProperties? spec) {
    return spec != null ? ContainerPropertiesMix.value(spec) : null;
  }

  // Chainable instance methods

  /// Returns a copy with the specified color.
  ContainerPropertiesMix color(Color value) {
    return merge(ContainerPropertiesMix.color(value));
  }

  /// Returns a copy with the specified decoration.
  ContainerPropertiesMix decoration(DecorationMix value) {
    return merge(ContainerPropertiesMix.decoration(value));
  }

  /// Returns a copy with the specified foreground decoration.
  ContainerPropertiesMix foregroundDecoration(DecorationMix value) {
    return merge(ContainerPropertiesMix.foregroundDecoration(value));
  }

  /// Returns a copy with the specified alignment.
  ContainerPropertiesMix alignment(AlignmentGeometry value) {
    return merge(ContainerPropertiesMix.alignment(value));
  }

  /// Returns a copy with the specified padding.
  ContainerPropertiesMix padding(EdgeInsetsGeometryMix value) {
    return merge(ContainerPropertiesMix.padding(value));
  }

  /// Returns a copy with the specified margin.
  ContainerPropertiesMix margin(EdgeInsetsGeometryMix value) {
    return merge(ContainerPropertiesMix.margin(value));
  }

  /// Returns a copy with the specified transform.
  ContainerPropertiesMix transform(Matrix4 value) {
    return merge(ContainerPropertiesMix.transform(value));
  }

  /// Returns a copy with the specified transform alignment.
  ContainerPropertiesMix transformAlignment(AlignmentGeometry value) {
    return merge(ContainerPropertiesMix.transformAlignment(value));
  }

  /// Returns a copy with the specified clip behavior.
  ContainerPropertiesMix clipBehavior(Clip value) {
    return merge(ContainerPropertiesMix.clipBehavior(value));
  }

  /// Returns a copy with the specified constraints.
  ContainerPropertiesMix constraints(BoxConstraintsMix value) {
    return merge(ContainerPropertiesMix.constraints(value));
  }

  /// Resolves to [ContainerProperties] using the provided [BuildContext].
  @override
  ContainerProperties resolve(BuildContext context) {
    return ContainerProperties(
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

  /// Merges the properties of this [ContainerPropertiesMix] with the properties of [other].
  @override
  ContainerPropertiesMix merge(ContainerPropertiesMix? other) {
    if (other == null) return this;

    return ContainerPropertiesMix.create(
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