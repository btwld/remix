// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skeleton.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Fortal Skeleton recipe: a gray placeholder block that pulses.
class FortalSkeleton extends StatelessWidget {
  const FortalSkeleton({
    super.key,
    this.style = const SkeletonStyler.create(),
    this.child,
    this.loading = true,
  });

  final SkeletonStyler style;

  final Widget? child;

  final bool loading;

  @override
  Widget build(BuildContext _) {
    return RemixSkeleton(
      style: fortalSkeletonStyle(style: style),
      loading: loading,
      child: child,
    );
  }
}
