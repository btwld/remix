import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../tokens/generated/carbon_tokens.g.dart';

/// Carbon's contextual color aliases.
///
/// Their concrete value depends on the current [CarbonLayer] level, so a widget
/// asks for `layer` rather than hard-coding `layer01`. See
/// <https://carbondesignsystem.com/elements/color/tokens/#layer-tokens>.
enum CarbonContextualColor {
  layer,
  layerHover,
  layerActive,
  layerSelected,
  layerSelectedHover,
  layerAccent,
  field,
  fieldHover,
  borderSubtle,
  borderStrong,
  borderTile,
}

/// Selects, or increments, Carbon's contextual layer level (1–3) for a subtree
/// and resolves contextual aliases to the matching indexed role token.
///
/// The page background is level 1. Nesting a [CarbonLayer] with no explicit
/// [level] increments the parent level (clamped to 3), mirroring Carbon's layer
/// model where each nested surface steps up one layer.
///
/// ```dart
/// CarbonLayer(               // level 2 inside a level-1 subtree
///   child: Builder(builder: (context) {
///     final token = CarbonLayer.of(context).color(CarbonContextualColor.layer);
///     // -> CarbonTokens.layer02
///   }),
/// )
/// ```
class CarbonLayer extends StatelessWidget {
  const CarbonLayer({super.key, this.level, required this.child});

  /// Explicit layer level (1–3). When null, increments the enclosing level.
  final int? level;

  final Widget child;

  /// The nearest layer level for [context] (defaults to 1 with no scope).
  static int levelOf(BuildContext context) => _of(context)?.level ?? 1;

  /// The nearest [CarbonLayerData] for [context].
  static CarbonLayerData of(BuildContext context) =>
      CarbonLayerData(levelOf(context));

  static _CarbonLayerInherited? _of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_CarbonLayerInherited>();

  @override
  Widget build(BuildContext context) {
    final parent = _of(context)?.level ?? 0;
    final resolved = (level ?? parent + 1).clamp(1, 3).toInt();

    return _CarbonLayerInherited(level: resolved, child: child);
  }
}

/// Resolves contextual aliases to indexed role tokens for a fixed layer [level].
@immutable
class CarbonLayerData {
  const CarbonLayerData(this.level);

  /// Current layer level, 1–3.
  final int level;

  /// The indexed [ColorToken] for [alias] at this layer level.
  ///
  /// `borderSubtle` has a level-0 variant (`borderSubtle00`) used on the page
  /// background; every other alias is defined for levels 1–3.
  ColorToken color(CarbonContextualColor alias) {
    final n = level.clamp(1, 3).toInt();

    return switch (alias) {
      CarbonContextualColor.layer => _pick(n, [
          CarbonTokens.layer01,
          CarbonTokens.layer02,
          CarbonTokens.layer03,
        ]),
      CarbonContextualColor.layerHover => _pick(n, [
          CarbonTokens.layerHover01,
          CarbonTokens.layerHover02,
          CarbonTokens.layerHover03,
        ]),
      CarbonContextualColor.layerActive => _pick(n, [
          CarbonTokens.layerActive01,
          CarbonTokens.layerActive02,
          CarbonTokens.layerActive03,
        ]),
      CarbonContextualColor.layerSelected => _pick(n, [
          CarbonTokens.layerSelected01,
          CarbonTokens.layerSelected02,
          CarbonTokens.layerSelected03,
        ]),
      CarbonContextualColor.layerSelectedHover => _pick(n, [
          CarbonTokens.layerSelectedHover01,
          CarbonTokens.layerSelectedHover02,
          CarbonTokens.layerSelectedHover03,
        ]),
      CarbonContextualColor.layerAccent => _pick(n, [
          CarbonTokens.layerAccent01,
          CarbonTokens.layerAccent02,
          CarbonTokens.layerAccent03,
        ]),
      CarbonContextualColor.field => _pick(n, [
          CarbonTokens.field01,
          CarbonTokens.field02,
          CarbonTokens.field03,
        ]),
      CarbonContextualColor.fieldHover => _pick(n, [
          CarbonTokens.fieldHover01,
          CarbonTokens.fieldHover02,
          CarbonTokens.fieldHover03,
        ]),
      CarbonContextualColor.borderSubtle => _pick(n, [
          CarbonTokens.borderSubtle01,
          CarbonTokens.borderSubtle02,
          CarbonTokens.borderSubtle03,
        ]),
      CarbonContextualColor.borderStrong => _pick(n, [
          CarbonTokens.borderStrong01,
          CarbonTokens.borderStrong02,
          CarbonTokens.borderStrong03,
        ]),
      CarbonContextualColor.borderTile => _pick(n, [
          CarbonTokens.borderTile01,
          CarbonTokens.borderTile02,
          CarbonTokens.borderTile03,
        ]),
    };
  }

  ColorToken _pick(int level, List<ColorToken> tokens) => tokens[level - 1];
}

class _CarbonLayerInherited extends InheritedWidget {
  const _CarbonLayerInherited({required this.level, required super.child});

  final int level;

  @override
  bool updateShouldNotify(_CarbonLayerInherited oldWidget) =>
      oldWidget.level != level;
}
