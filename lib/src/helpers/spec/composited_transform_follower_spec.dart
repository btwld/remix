import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

class RemixCompositedTransformFollowerSpec
    extends Spec<RemixCompositedTransformFollowerSpec> with Diagnosticable {
  final LayerLink? link;
  final bool? showWhenUnlinked;
  final Offset? offset;
  final AlignmentGeometry? targetAnchor;
  final AlignmentGeometry? followerAnchor;

  const RemixCompositedTransformFollowerSpec({
    this.link,
    this.showWhenUnlinked,
    this.offset,
    this.targetAnchor,
    this.followerAnchor,
  });

  static RemixCompositedTransformFollowerSpec? of(BuildContext _) => null;

  @override
  RemixCompositedTransformFollowerSpec copyWith({
    LayerLink? link,
    bool? showWhenUnlinked,
    Offset? offset,
    AlignmentGeometry? targetAnchor,
    AlignmentGeometry? followerAnchor,
  }) {
    return RemixCompositedTransformFollowerSpec(
      link: link ?? this.link,
      showWhenUnlinked: showWhenUnlinked ?? this.showWhenUnlinked,
      offset: offset ?? this.offset,
      targetAnchor: targetAnchor ?? this.targetAnchor,
      followerAnchor: followerAnchor ?? this.followerAnchor,
    );
  }

  @override
  RemixCompositedTransformFollowerSpec lerp(
    RemixCompositedTransformFollowerSpec? other,
    double t,
  ) {
    if (other == null) return this;

    return RemixCompositedTransformFollowerSpec(
      link: t < 0.5 ? link : other.link,
      showWhenUnlinked: t < 0.5 ? showWhenUnlinked : other.showWhenUnlinked,
      offset: Offset.lerp(offset, other.offset, t),
      targetAnchor: AlignmentGeometry.lerp(targetAnchor, other.targetAnchor, t),
      followerAnchor:
          AlignmentGeometry.lerp(followerAnchor, other.followerAnchor, t),
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
  List<Object?> get props =>
      [link, showWhenUnlinked, offset, targetAnchor, followerAnchor];
}
