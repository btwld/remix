// Adapted from remix_carbon at commit 606bfbb36 and from design tokens in the
// IBM Carbon Design System. Copyright 2026 the Remix authors; IBM Carbon
// Design System copyright IBM Corp. and the Carbon authors. Apache-2.0.
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import 'generated/carbon_tokens.dart';

/// Carbon's contextual color aliases.
///
/// Their concrete value depends on the current [CarbideLayer] level, so a widget
/// asks for `layer` rather than hard-coding `layer01`. Covers every indexed
/// role family in the generated token set (asserted by test). See
/// <https://carbondesignsystem.com/elements/color/tokens/#layer-tokens>.
enum CarbideContextualColor {
  layer,
  layerHover,
  layerActive,
  layerSelected,
  layerSelectedHover,
  layerAccent,
  layerAccentHover,
  layerAccentActive,
  layerBackground,
  field,
  fieldHover,
  borderSubtle,
  borderSubtleSelected,
  borderStrong,
  borderTile,
}

/// Selects, or increments, Carbon's contextual layer level (1–3) for a subtree
/// and resolves contextual aliases to the matching indexed role token.
///
/// The page background is level 1. A [CarbideLayer] with no explicit [level]
/// steps up one from its surroundings (clamped to 3), mirroring Carbon's layer
/// model where each nested surface increments the layer.
///
/// ```dart
/// CarbideLayer(               // level 2: one step above the page (level 1)
///   child: Builder(builder: (context) {
///     final token = CarbideLayer.of(context).color(CarbideContextualColor.layer);
///     // -> CarbideTokens.layer02
///   }),
/// )
/// ```
class CarbideLayer extends StatelessWidget {
  const CarbideLayer({super.key, this.level, required this.child});

  /// Explicit layer level (1–3). When null, increments the enclosing level.
  final int? level;

  final Widget child;

  /// The nearest layer level for [context] (defaults to 1 with no scope).
  static int levelOf(BuildContext context) => _of(context)?.level ?? 1;

  /// The nearest [CarbideLayerData] for [context].
  static CarbideLayerData of(BuildContext context) => .new(levelOf(context));

  static _CarbonLayerInherited? _of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType();

  @override
  Widget build(BuildContext context) {
    // No enclosing layer means the page itself (level 1), so the first
    // CarbideLayer in a tree resolves to level 2.
    final parent = _of(context)?.level ?? 1;
    final resolved = (level ?? (parent + 1)).clamp(1, 3).toInt();

    return _CarbonLayerInherited(level: resolved, child: child);
  }
}

/// Resolves contextual aliases to indexed role tokens for a fixed layer [level].
@immutable
class CarbideLayerData {
  const CarbideLayerData(this.level);

  /// Current layer level, 1–3.
  final int level;

  /// The indexed [ColorToken] for [alias] at this layer level.
  ///
  /// `borderSubtle` also has a level-0 variant (`borderSubtle00`) used directly
  /// on the page background; every alias here is defined for levels 1–3.
  ColorToken color(CarbideContextualColor alias) {
    final targetLevel = level.clamp(1, 3).toInt();
    var currentLevel = 1;
    for (final token in carbideIndexedRoleFamilies[alias.name]!) {
      if (currentLevel == targetLevel) return token;
      currentLevel++;
    }

    throw StateError(
      'Missing Carbon token for ${alias.name} at level $targetLevel.',
    );
  }
}

class _CarbonLayerInherited extends InheritedWidget {
  const _CarbonLayerInherited({required this.level, required super.child});

  final int level;

  @override
  bool updateShouldNotify(_CarbonLayerInherited oldWidget) =>
      oldWidget.level != level;
}
