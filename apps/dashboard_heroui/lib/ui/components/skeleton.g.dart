// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skeleton.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// HeroUI recipe for [RemixSkeleton].
///
/// The placeholder has no size of its own, as in HeroUI: give it one through
/// [style] or its parent. Remix pulses the fill's opacity to half and back,
/// which is Tailwind's `animate-pulse`.
class UiSkeleton extends StatelessWidget {
  const UiSkeleton({
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
      style: uiSkeletonStyle(style: style),
      loading: loading,
      child: child,
    );
  }
}
