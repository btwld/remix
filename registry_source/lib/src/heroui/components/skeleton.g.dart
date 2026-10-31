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
class HeroUiSkeleton extends StatelessWidget {
  const HeroUiSkeleton({
    super.key,
    this.style = const SkeletonStyler.create(),
    this.child,
    this.loading = true,
  });

  final SkeletonStyler style;

  final Widget? child;

  final bool loading;

  @override
  Widget build(BuildContext context) {
    return RemixSkeleton(
      key: this.key,
      style: heroUiSkeletonStyle(style: this.style),
      child: this.child,
      loading: this.loading,
    );
  }
}
