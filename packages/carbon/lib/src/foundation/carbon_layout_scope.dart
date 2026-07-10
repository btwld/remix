import 'package:flutter/widgets.dart';

import '../tokens/generated/carbon_layout.g.dart';
import '../tokens/carbon_token_types.dart';

/// Carbon contextual sizes (`xs`–`2xl`).
///
/// Each component declares the subset it supports plus a default, and clamps an
/// inherited size into that range — mirroring Carbon's `layout.use()` behavior.
enum CarbonSize {
  xs,
  sm,
  md,
  lg,
  xl,
  x2l;

  /// Default control height in logical pixels (from `@carbon/layout` sizes).
  double get height => carbonControlSizePx[_key]!;

  String get _key => switch (this) {
        CarbonSize.xs => 'xSmall',
        CarbonSize.sm => 'small',
        CarbonSize.md => 'medium',
        CarbonSize.lg => 'large',
        CarbonSize.xl => 'xLarge',
        CarbonSize.x2l => 'xxLarge',
      };

  /// Clamps this size into the inclusive `[min, max]` range.
  CarbonSize clampTo(CarbonSize min, CarbonSize max) =>
      CarbonSize.values[index.clamp(min.index, max.index).toInt()];
}

/// Carbon layout density.
enum CarbonDensity { condensed, normal }

/// Immutable size/density pair carried by [CarbonLayoutScope].
@immutable
class CarbonLayoutData {
  const CarbonLayoutData({
    this.size = CarbonSize.md,
    this.density = CarbonDensity.normal,
  });

  final CarbonSize size;
  final CarbonDensity density;

  CarbonLayoutData copyWith({CarbonSize? size, CarbonDensity? density}) =>
      CarbonLayoutData(
        size: size ?? this.size,
        density: density ?? this.density,
      );
}

/// Provides a contextual [CarbonSize] and [CarbonDensity] to a subtree.
///
/// ```dart
/// CarbonLayoutScope(
///   size: CarbonSize.sm,
///   density: CarbonDensity.condensed,
///   child: content,
/// )
/// ```
class CarbonLayoutScope extends StatelessWidget {
  const CarbonLayoutScope({
    super.key,
    this.size,
    this.density,
    required this.child,
  });

  /// Overrides the inherited size; inherits (or defaults to `md`) when null.
  final CarbonSize? size;

  /// Overrides the inherited density; inherits (or defaults to `normal`) when null.
  final CarbonDensity? density;

  final Widget child;

  /// The nearest [CarbonLayoutData], or null when there is no enclosing scope.
  ///
  /// Components with their own Carbon default size (e.g. Button's `lg`) use
  /// this to distinguish "no scope" from "scope chose the default".
  static CarbonLayoutData? maybeOf(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<_CarbonLayoutInherited>();

    return scope?.data;
  }

  /// The nearest [CarbonLayoutData], defaulting to `md` / `normal`.
  static CarbonLayoutData of(BuildContext context) =>
      maybeOf(context) ?? const CarbonLayoutData();

  @override
  Widget build(BuildContext context) {
    final parent = CarbonLayoutScope.of(context);

    return _CarbonLayoutInherited(
      data: parent.copyWith(size: size, density: density),
      child: child,
    );
  }
}

/// The active Carbon breakpoint for a viewport [width] (logical pixels).
///
/// Returns the largest breakpoint whose minimum width has been reached.
CarbonBreakpointData carbonBreakpointFor(double width) {
  var active = carbonBreakpoints.first;
  for (final bp in carbonBreakpoints) {
    if (width >= bp.width) active = bp;
  }

  return active;
}

class _CarbonLayoutInherited extends InheritedWidget {
  const _CarbonLayoutInherited({required this.data, required super.child});

  final CarbonLayoutData data;

  @override
  bool updateShouldNotify(_CarbonLayoutInherited oldWidget) =>
      oldWidget.data.size != data.size || oldWidget.data.density != data.density;
}
