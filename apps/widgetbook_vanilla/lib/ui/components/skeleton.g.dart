// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skeleton.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's Skeleton recipe.
///
/// An `accent` block with `radiusMd` corners that pulses to half strength, so a
/// loading block reads as scenery rather than content. It takes no size: the
/// child it wraps, or explicit constraints on [style], measure it:
///
/// ```dart
/// VanillaSkeleton(
///   style: SkeletonStyler().container(.size(160, 20)),
/// )
/// ```
class VanillaSkeleton extends StatelessWidget {
  const VanillaSkeleton({
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
      style: vanillaSkeletonStyle(style: this.style),
      child: this.child,
      loading: this.loading,
    );
  }
}
