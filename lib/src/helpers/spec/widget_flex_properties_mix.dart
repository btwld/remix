import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'widget_flex_properties.dart';

/// Mix class for configuring [WidgetFlexProperties] properties.
///
/// Encapsulates flex layout properties with support for proper Mix framework integration.
final class WidgetFlexPropertiesMix extends Mix<WidgetFlexProperties>
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
  WidgetFlexPropertiesMix({
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
  const WidgetFlexPropertiesMix.create({
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

  /// Constructor that accepts a [WidgetFlexProperties] value and extracts its properties.
  WidgetFlexPropertiesMix.value(WidgetFlexProperties spec)
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
  factory WidgetFlexPropertiesMix.color(Color value) {
    return WidgetFlexPropertiesMix(decoration: DecorationMix.color(value));
  }

  /// Decoration factory
  factory WidgetFlexPropertiesMix.decoration(DecorationMix value) {
    return WidgetFlexPropertiesMix(decoration: value);
  }

  /// Alignment factory
  factory WidgetFlexPropertiesMix.alignment(AlignmentGeometry value) {
    return WidgetFlexPropertiesMix(alignment: value);
  }

  /// Padding factory
  factory WidgetFlexPropertiesMix.padding(EdgeInsetsGeometryMix value) {
    return WidgetFlexPropertiesMix(padding: value);
  }

  /// Direction factory
  factory WidgetFlexPropertiesMix.direction(Axis value) {
    return WidgetFlexPropertiesMix(direction: value);
  }

  /// Gap factory
  factory WidgetFlexPropertiesMix.gap(double value) {
    return WidgetFlexPropertiesMix(gap: value);
  }

  // Flex-specific factories

  /// Horizontal flex factory
  factory WidgetFlexPropertiesMix.horizontal({
    MainAxisAlignment? mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment? crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize? mainAxisSize = MainAxisSize.max,
    double? gap,
  }) {
    return WidgetFlexPropertiesMix(
      direction: Axis.horizontal,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      gap: gap,
    );
  }

  /// Vertical flex factory
  factory WidgetFlexPropertiesMix.vertical({
    MainAxisAlignment? mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment? crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize? mainAxisSize = MainAxisSize.max,
    double? gap,
  }) {
    return WidgetFlexPropertiesMix(
      direction: Axis.vertical,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      gap: gap,
    );
  }

  /// Row factory (horizontal shorthand)
  factory WidgetFlexPropertiesMix.row({
    MainAxisAlignment? mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment? crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize? mainAxisSize = MainAxisSize.max,
    double? gap,
  }) {
    return WidgetFlexPropertiesMix.horizontal(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      gap: gap,
    );
  }

  /// Column factory (vertical shorthand)
  factory WidgetFlexPropertiesMix.column({
    MainAxisAlignment? mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment? crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize? mainAxisSize = MainAxisSize.max,
    double? gap,
  }) {
    return WidgetFlexPropertiesMix.vertical(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      gap: gap,
    );
  }

  /// Constructor that accepts a nullable [WidgetFlexProperties] value.
  ///
  /// Returns null if the input is null, otherwise uses [WidgetFlexPropertiesMix.value].
  static WidgetFlexPropertiesMix? maybeValue(WidgetFlexProperties? spec) {
    return spec != null ? WidgetFlexPropertiesMix.value(spec) : null;
  }

  // Chainable instance methods

  /// Returns a copy with the specified color.
  WidgetFlexPropertiesMix color(Color value) {
    return merge(WidgetFlexPropertiesMix.color(value));
  }

  /// Returns a copy with the specified decoration.
  WidgetFlexPropertiesMix decoration(DecorationMix value) {
    return merge(WidgetFlexPropertiesMix.decoration(value));
  }

  /// Returns a copy with the specified alignment.
  WidgetFlexPropertiesMix alignment(AlignmentGeometry value) {
    return merge(WidgetFlexPropertiesMix.alignment(value));
  }

  /// Returns a copy with the specified padding.
  WidgetFlexPropertiesMix padding(EdgeInsetsGeometryMix value) {
    return merge(WidgetFlexPropertiesMix.padding(value));
  }

  /// Returns a copy with the specified direction.
  WidgetFlexPropertiesMix direction(Axis value) {
    return merge(WidgetFlexPropertiesMix.direction(value));
  }

  /// Returns a copy with the specified gap.
  WidgetFlexPropertiesMix gap(double value) {
    return merge(WidgetFlexPropertiesMix.gap(value));
  }

  /// Returns a copy with the specified main axis alignment.
  WidgetFlexPropertiesMix mainAxisAlignment(MainAxisAlignment value) {
    return merge(WidgetFlexPropertiesMix(mainAxisAlignment: value));
  }

  /// Resolves to [WidgetFlexProperties] using the provided [BuildContext].
  @override
  WidgetFlexProperties resolve(BuildContext context) {
    return WidgetFlexProperties(
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

  /// Merges the properties of this [WidgetFlexPropertiesMix] with the properties of [other].
  @override
  WidgetFlexPropertiesMix merge(WidgetFlexPropertiesMix? other) {
    if (other == null) return this;

    return WidgetFlexPropertiesMix.create(
      decoration: MixOps.merge($decoration, other.$decoration),
      padding: MixOps.merge($padding, other.$padding),
      alignment: MixOps.merge($alignment, other.$alignment),
      direction: MixOps.merge($direction, other.$direction),
      mainAxisAlignment: MixOps.merge($mainAxisAlignment, other.$mainAxisAlignment),
      crossAxisAlignment: MixOps.merge($crossAxisAlignment, other.$crossAxisAlignment),
      mainAxisSize: MixOps.merge($mainAxisSize, other.$mainAxisSize),
      verticalDirection: MixOps.merge($verticalDirection, other.$verticalDirection),
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