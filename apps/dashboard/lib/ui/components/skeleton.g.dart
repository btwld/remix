// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skeleton.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// Ui recipe for [RemixSkeleton].
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
  Widget build(BuildContext context) {
    return RemixSkeleton(
      key: this.key,
      style: uiSkeletonStyle(style: this.style),
      child: this.child,
      loading: this.loading,
    );
  }
}
