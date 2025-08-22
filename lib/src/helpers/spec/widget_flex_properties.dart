import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

/// A Spec class for widget flex properties.
///
/// This extends Spec to provide resolved flex layout values for widgets.
class WidgetFlexProperties extends Spec<WidgetFlexProperties>
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

  const WidgetFlexProperties({
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
  WidgetFlexProperties copyWith({
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
    return WidgetFlexProperties(
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
  WidgetFlexProperties lerp(WidgetFlexProperties? other, double t) {
    if (other == null) return this;

    return WidgetFlexProperties(
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

/// Extension to convert [WidgetFlexProperties] directly to a [Flex] widget.
extension WidgetFlexPropertiesWidget on WidgetFlexProperties {
  Flex call({required Axis direction, List<Widget> children = const []}) {
    return Flex(
      direction: this.direction ?? direction,
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
      mainAxisSize: mainAxisSize ?? MainAxisSize.max,
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
      textDirection: textDirection,
      verticalDirection: verticalDirection ?? VerticalDirection.down,
      textBaseline: textBaseline,
      spacing: gap ?? 0.0,
      children: children,
    );
  }
}