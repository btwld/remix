import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

/// A property bag for Flex widget configuration.
///
/// This Spec provides resolved flex layout values that can be applied 
/// to Row, Column, or Flex widgets. It encapsulates flex-specific properties
/// like direction, alignment, and spacing, as well as optional decoration
/// properties that will wrap the Flex when present.
class FlexProperties extends Spec<FlexProperties>
    with Diagnosticable {
  final Decoration? decoration;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;
  final Axis? direction;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisSize? mainAxisSize;
  final VerticalDirection? verticalDirection;
  final TextDirection? textDirection;
  final TextBaseline? textBaseline;
  final double? gap;

  const FlexProperties({
    this.decoration,
    this.padding,
    this.alignment,
    this.direction,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.mainAxisSize,
    this.verticalDirection,
    this.textDirection,
    this.textBaseline,
    this.gap,
  });

  @override
  FlexProperties copyWith({
    Decoration? decoration,
    EdgeInsetsGeometry? padding,
    AlignmentGeometry? alignment,
    Axis? direction,
    MainAxisAlignment? mainAxisAlignment,
    CrossAxisAlignment? crossAxisAlignment,
    MainAxisSize? mainAxisSize,
    VerticalDirection? verticalDirection,
    TextDirection? textDirection,
    TextBaseline? textBaseline,
    double? gap,
  }) {
    return FlexProperties(
      decoration: decoration ?? this.decoration,
      padding: padding ?? this.padding,
      alignment: alignment ?? this.alignment,
      direction: direction ?? this.direction,
      mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment ?? this.crossAxisAlignment,
      mainAxisSize: mainAxisSize ?? this.mainAxisSize,
      verticalDirection: verticalDirection ?? this.verticalDirection,
      textDirection: textDirection ?? this.textDirection,
      textBaseline: textBaseline ?? this.textBaseline,
      gap: gap ?? this.gap,
    );
  }

  @override
  FlexProperties lerp(FlexProperties? other, double t) {
    if (other == null) return this;

    return FlexProperties(
      decoration: MixOps.lerp(decoration, other.decoration, t),
      padding: MixOps.lerp(padding, other.padding, t),
      alignment: MixOps.lerp(alignment, other.alignment, t),
      direction: MixOps.lerpSnap(direction, other.direction, t),
      mainAxisAlignment: MixOps.lerpSnap(mainAxisAlignment, other.mainAxisAlignment, t),
      crossAxisAlignment: MixOps.lerpSnap(crossAxisAlignment, other.crossAxisAlignment, t),
      mainAxisSize: MixOps.lerpSnap(mainAxisSize, other.mainAxisSize, t),
      verticalDirection: MixOps.lerpSnap(verticalDirection, other.verticalDirection, t),
      textDirection: MixOps.lerpSnap(textDirection, other.textDirection, t),
      textBaseline: MixOps.lerpSnap(textBaseline, other.textBaseline, t),
      gap: MixOps.lerp(gap, other.gap, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('decoration', decoration))
      ..add(DiagnosticsProperty('padding', padding))
      ..add(DiagnosticsProperty('alignment', alignment))
      ..add(EnumProperty<Axis>('direction', direction))
      ..add(EnumProperty<MainAxisAlignment>('mainAxisAlignment', mainAxisAlignment))
      ..add(EnumProperty<CrossAxisAlignment>('crossAxisAlignment', crossAxisAlignment))
      ..add(EnumProperty<MainAxisSize>('mainAxisSize', mainAxisSize))
      ..add(EnumProperty<VerticalDirection>('verticalDirection', verticalDirection))
      ..add(EnumProperty<TextDirection>('textDirection', textDirection))
      ..add(EnumProperty<TextBaseline>('textBaseline', textBaseline))
      ..add(DoubleProperty('gap', gap));
  }

  @override
  List<Object?> get props => [
        decoration,
        padding,
        alignment,
        direction,
        mainAxisAlignment,
        crossAxisAlignment,
        mainAxisSize,
        verticalDirection,
        textDirection,
        textBaseline,
        gap,
      ];
}

/// Extension to convert [FlexProperties] directly to a [Flex] widget.
extension FlexPropertiesX on FlexProperties {
  /// Backward compatible call operator to build a Flex widget.
  Widget call({required Axis direction, List<Widget> children = const []}) {
    return toFlex(direction: direction, children: children);
  }

  /// Explicitly build a Flex widget with the specified properties.
  /// 
  /// If decoration, padding, or alignment are set, the Flex will be wrapped
  /// with the appropriate wrapper widgets (DecoratedBox, Padding, Align).
  /// 
  /// Gap is handled by interleaving SizedBox widgets between children along
  /// the main axis.
  Widget toFlex({required Axis direction, List<Widget> children = const []}) {
    final resolvedDirection = this.direction ?? direction;
    
    // Handle gap by interleaving SizedBox widgets
    List<Widget> childrenWithGaps = children;
    if (gap != null && gap! > 0 && children.length > 1) {
      childrenWithGaps = [];
      for (int i = 0; i < children.length; i++) {
        childrenWithGaps.add(children[i]);
        if (i < children.length - 1) {
          childrenWithGaps.add(
            SizedBox(
              width: resolvedDirection == Axis.horizontal ? gap : null,
              height: resolvedDirection == Axis.vertical ? gap : null,
            ),
          );
        }
      }
    }

    Widget flex = Flex(
      direction: resolvedDirection,
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
      mainAxisSize: mainAxisSize ?? MainAxisSize.max,
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
      textDirection: textDirection,
      verticalDirection: verticalDirection ?? VerticalDirection.down,
      textBaseline: textBaseline,
      children: childrenWithGaps,
    );

    // Apply wrappers if needed
    if (padding != null) {
      flex = Padding(
        padding: padding!,
        child: flex,
      );
    }

    if (decoration != null) {
      flex = DecoratedBox(
        decoration: decoration!,
        child: flex,
      );
    }

    if (alignment != null) {
      flex = Align(
        alignment: alignment!,
        child: flex,
      );
    }

    return flex;
  }
}