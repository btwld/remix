import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'flex_properties.dart';

/// Mix class for configuring [FlexProperties] properties.
///
/// Encapsulates flex layout properties with support for proper Mix framework integration.
final class FlexPropertiesMix extends Mix<FlexProperties>
    with Diagnosticable {
  final Prop<Decoration>? $decoration;
  final Prop<EdgeInsetsGeometry>? $padding;
  final Prop<AlignmentGeometry>? $alignment;
  final Prop<Axis>? $direction;
  final Prop<MainAxisAlignment>? $mainAxisAlignment;
  final Prop<CrossAxisAlignment>? $crossAxisAlignment;
  final Prop<MainAxisSize>? $mainAxisSize;
  final Prop<VerticalDirection>? $verticalDirection;
  final Prop<TextDirection>? $textDirection;
  final Prop<TextBaseline>? $textBaseline;
  final Prop<double>? $gap;

  /// Main constructor with user-friendly Mix types
  FlexPropertiesMix({
    DecorationMix? decoration,
    EdgeInsetsGeometryMix? padding,
    AlignmentGeometry? alignment,
    Axis? direction,
    MainAxisAlignment? mainAxisAlignment,
    CrossAxisAlignment? crossAxisAlignment,
    MainAxisSize? mainAxisSize,
    VerticalDirection? verticalDirection,
    TextDirection? textDirection,
    TextBaseline? textBaseline,
    double? gap,
  }) : this.create(
          decoration: Prop.maybeMix(decoration),
          padding: Prop.maybeMix(padding),
          alignment: Prop.maybe(alignment),
          direction: Prop.maybe(direction),
          mainAxisAlignment: Prop.maybe(mainAxisAlignment),
          crossAxisAlignment: Prop.maybe(crossAxisAlignment),
          mainAxisSize: Prop.maybe(mainAxisSize),
          verticalDirection: Prop.maybe(verticalDirection),
          textDirection: Prop.maybe(textDirection),
          textBaseline: Prop.maybe(textBaseline),
          gap: Prop.maybe(gap),
        );

  /// Create constructor with Prop<T> types for internal use
  const FlexPropertiesMix.create({
    Prop<Decoration>? decoration,
    Prop<EdgeInsetsGeometry>? padding,
    Prop<AlignmentGeometry>? alignment,
    Prop<Axis>? direction,
    Prop<MainAxisAlignment>? mainAxisAlignment,
    Prop<CrossAxisAlignment>? crossAxisAlignment,
    Prop<MainAxisSize>? mainAxisSize,
    Prop<VerticalDirection>? verticalDirection,
    Prop<TextDirection>? textDirection,
    Prop<TextBaseline>? textBaseline,
    Prop<double>? gap,
  })  : $decoration = decoration,
        $padding = padding,
        $alignment = alignment,
        $direction = direction,
        $mainAxisAlignment = mainAxisAlignment,
        $crossAxisAlignment = crossAxisAlignment,
        $mainAxisSize = mainAxisSize,
        $verticalDirection = verticalDirection,
        $textDirection = textDirection,
        $textBaseline = textBaseline,
        $gap = gap;

  /// Constructor that accepts a [FlexProperties] value and extracts its properties.
  FlexPropertiesMix.value(FlexProperties spec)
      : this(
          decoration: DecorationMix.maybeValue(spec.decoration),
          padding: EdgeInsetsGeometryMix.maybeValue(spec.padding),
          alignment: spec.alignment,
          direction: spec.direction,
          mainAxisAlignment: spec.mainAxisAlignment,
          crossAxisAlignment: spec.crossAxisAlignment,
          mainAxisSize: spec.mainAxisSize,
          verticalDirection: spec.verticalDirection,
          textDirection: spec.textDirection,
          textBaseline: spec.textBaseline,
          gap: spec.gap,
        );

  // Factory constructors for common use cases

  /// Color factory
  factory FlexPropertiesMix.color(Color value) {
    return FlexPropertiesMix(decoration: DecorationMix.color(value));
  }

  /// Decoration factory
  factory FlexPropertiesMix.decoration(DecorationMix value) {
    return FlexPropertiesMix(decoration: value);
  }

  /// Alignment factory
  factory FlexPropertiesMix.alignment(AlignmentGeometry value) {
    return FlexPropertiesMix(alignment: value);
  }

  /// Padding factory
  factory FlexPropertiesMix.padding(EdgeInsetsGeometryMix value) {
    return FlexPropertiesMix(padding: value);
  }

  /// Direction factory
  factory FlexPropertiesMix.direction(Axis value) {
    return FlexPropertiesMix(direction: value);
  }

  /// Gap factory
  factory FlexPropertiesMix.gap(double value) {
    return FlexPropertiesMix(gap: value);
  }

  // Flex-specific factories

  /// Horizontal flex factory
  factory FlexPropertiesMix.horizontal({
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    double? gap,
  }) {
    return FlexPropertiesMix(
      direction: Axis.horizontal,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      gap: gap,
    );
  }

  /// Vertical flex factory
  factory FlexPropertiesMix.vertical({
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    double? gap,
  }) {
    return FlexPropertiesMix(
      direction: Axis.vertical,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      gap: gap,
    );
  }

  /// Row factory (horizontal shorthand)
  factory FlexPropertiesMix.row({
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    double? gap,
  }) {
    return FlexPropertiesMix.horizontal(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      gap: gap,
    );
  }

  /// Column factory (vertical shorthand)
  factory FlexPropertiesMix.column({
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    double? gap,
  }) {
    return FlexPropertiesMix.vertical(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      gap: gap,
    );
  }

  /// Constructor that accepts a nullable [FlexProperties] value.
  ///
  /// Returns null if the input is null, otherwise uses [FlexPropertiesMix.value].
  static FlexPropertiesMix? maybeValue(FlexProperties? spec) {
    return spec != null ? FlexPropertiesMix.value(spec) : null;
  }

  // Chainable instance methods

  /// Returns a copy with the specified color.
  FlexPropertiesMix color(Color value) {
    return merge(FlexPropertiesMix.color(value));
  }

  /// Returns a copy with the specified decoration.
  FlexPropertiesMix decoration(DecorationMix value) {
    return merge(FlexPropertiesMix.decoration(value));
  }

  /// Returns a copy with the specified alignment.
  FlexPropertiesMix alignment(AlignmentGeometry value) {
    return merge(FlexPropertiesMix.alignment(value));
  }

  /// Returns a copy with the specified padding.
  FlexPropertiesMix padding(EdgeInsetsGeometryMix value) {
    return merge(FlexPropertiesMix.padding(value));
  }

  /// Returns a copy with the specified direction.
  FlexPropertiesMix direction(Axis value) {
    return merge(FlexPropertiesMix.direction(value));
  }

  /// Returns a copy with the specified gap.
  FlexPropertiesMix gap(double value) {
    return merge(FlexPropertiesMix.gap(value));
  }

  /// Returns a copy with the specified main axis alignment.
  FlexPropertiesMix mainAxisAlignment(MainAxisAlignment value) {
    return merge(FlexPropertiesMix(mainAxisAlignment: value));
  }

  /// Resolves to [FlexProperties] using the provided [BuildContext].
  @override
  FlexProperties resolve(BuildContext context) {
    return FlexProperties(
      decoration: MixOps.resolve(context, $decoration),
      padding: MixOps.resolve(context, $padding),
      alignment: MixOps.resolve(context, $alignment),
      direction: MixOps.resolve(context, $direction),
      mainAxisAlignment: MixOps.resolve(context, $mainAxisAlignment),
      crossAxisAlignment: MixOps.resolve(context, $crossAxisAlignment),
      mainAxisSize: MixOps.resolve(context, $mainAxisSize),
      verticalDirection: MixOps.resolve(context, $verticalDirection),
      textDirection: MixOps.resolve(context, $textDirection),
      textBaseline: MixOps.resolve(context, $textBaseline),
      gap: MixOps.resolve(context, $gap),
    );
  }

  /// Merges the properties of this [FlexPropertiesMix] with the properties of [other].
  @override
  FlexPropertiesMix merge(FlexPropertiesMix? other) {
    if (other == null) return this;

    return FlexPropertiesMix.create(
      decoration: MixOps.merge($decoration, other.$decoration),
      padding: MixOps.merge($padding, other.$padding),
      alignment: MixOps.merge($alignment, other.$alignment),
      direction: MixOps.merge($direction, other.$direction),
      mainAxisAlignment:
          MixOps.merge($mainAxisAlignment, other.$mainAxisAlignment),
      crossAxisAlignment:
          MixOps.merge($crossAxisAlignment, other.$crossAxisAlignment),
      mainAxisSize: MixOps.merge($mainAxisSize, other.$mainAxisSize),
      verticalDirection:
          MixOps.merge($verticalDirection, other.$verticalDirection),
      textDirection: MixOps.merge($textDirection, other.$textDirection),
      textBaseline: MixOps.merge($textBaseline, other.$textBaseline),
      gap: MixOps.merge($gap, other.$gap),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('decoration', $decoration))
      ..add(DiagnosticsProperty('padding', $padding))
      ..add(DiagnosticsProperty('alignment', $alignment))
      ..add(DiagnosticsProperty('direction', $direction))
      ..add(DiagnosticsProperty('mainAxisAlignment', $mainAxisAlignment))
      ..add(DiagnosticsProperty('crossAxisAlignment', $crossAxisAlignment))
      ..add(DiagnosticsProperty('mainAxisSize', $mainAxisSize))
      ..add(DiagnosticsProperty('verticalDirection', $verticalDirection))
      ..add(DiagnosticsProperty('textDirection', $textDirection))
      ..add(DiagnosticsProperty('textBaseline', $textBaseline))
      ..add(DiagnosticsProperty('gap', $gap));
  }

  @override
  List<Object?> get props => [
        $decoration,
        $padding,
        $alignment,
        $direction,
        $mainAxisAlignment,
        $crossAxisAlignment,
        $mainAxisSize,
        $verticalDirection,
        $textDirection,
        $textBaseline,
        $gap,
      ];
}