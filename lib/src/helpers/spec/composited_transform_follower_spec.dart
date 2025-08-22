import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

// Temporary stub for CompositedTransformFollowerSpec
// This will be replaced when Mix 2.0 migration is complete
class CompositedTransformFollowerSpec extends WidgetSpec<CompositedTransformFollowerSpec> {
  final LayerLink? link;
  final bool? showWhenUnlinked;
  final Offset? offset;
  final AlignmentGeometry? targetAnchor;
  final AlignmentGeometry? followerAnchor;

  const CompositedTransformFollowerSpec({
    this.link,
    this.showWhenUnlinked,
    this.offset,
    this.targetAnchor,
    this.followerAnchor,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  }) : super(animation: animation, widgetModifiers: widgetModifiers, inherit: inherit);

  static CompositedTransformFollowerSpec? of(BuildContext _) => null;
  
  @override
  CompositedTransformFollowerSpec copyWith({
    LayerLink? link,
    bool? showWhenUnlinked,
    Offset? offset,
    AlignmentGeometry? targetAnchor,
    AlignmentGeometry? followerAnchor,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  }) {
    return CompositedTransformFollowerSpec(
      link: link ?? this.link,
      showWhenUnlinked: showWhenUnlinked ?? this.showWhenUnlinked,
      offset: offset ?? this.offset,
      targetAnchor: targetAnchor ?? this.targetAnchor,
      followerAnchor: followerAnchor ?? this.followerAnchor,
      animation: animation ?? this.animation,
      widgetModifiers: widgetModifiers ?? this.widgetModifiers,
      inherit: inherit ?? this.inherit,
    );
  }
  
  @override
  CompositedTransformFollowerSpec lerp(CompositedTransformFollowerSpec? other, double t) {
    if (other == null) return this;
    
    return CompositedTransformFollowerSpec(
      link: t < 0.5 ? link : other.link,
      showWhenUnlinked: t < 0.5 ? showWhenUnlinked : other.showWhenUnlinked,
      offset: Offset.lerp(offset, other.offset, t),
      targetAnchor: AlignmentGeometry.lerp(targetAnchor, other.targetAnchor, t),
      followerAnchor: AlignmentGeometry.lerp(followerAnchor, other.followerAnchor, t),
      animation: MixOps.lerp(animation, other.animation, t),
      widgetModifiers: MixOps.lerp(widgetModifiers, other.widgetModifiers, t),
      inherit: MixOps.lerp(inherit, other.inherit, t),
    );
  }
  
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('link', link))
      ..add(DiagnosticsProperty('showWhenUnlinked', showWhenUnlinked))
      ..add(DiagnosticsProperty('offset', offset))
      ..add(DiagnosticsProperty('targetAnchor', targetAnchor))
      ..add(DiagnosticsProperty('followerAnchor', followerAnchor));
  }
  
  @override
  get props => [...super.props, link, showWhenUnlinked, offset, targetAnchor, followerAnchor];
}