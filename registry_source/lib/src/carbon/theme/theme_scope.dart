// Adapted from remix_carbon at commit 606bfbb36 and from design tokens in the
// IBM Carbon Design System. Copyright 2026 the Remix authors; IBM Carbon
// Design System copyright IBM Corp. and the Carbon authors. Apache-2.0.
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import 'theme_data.dart';

/// Provides IBM Carbon design tokens to its subtree via a [MixScope], and
/// exposes the active [CarbideTheme] to descendants.
///
/// Place a [CarbideScope] at the root of the app (or around any subtree that uses
/// Carbon widgets/styles) so that `CarbideTokens.*` resolve to concrete values.
///
/// ```dart
/// CarbideScope(
///   theme: CarbideTheme.g100,
///   child: app,
/// )
/// ```
///
/// Pass [overrides] to substitute specific colors or a bundled font family
/// (for example an `IBM Plex Sans` family the app ships) without mutating the
/// generated theme maps.
class CarbideScope extends StatelessWidget {
  const CarbideScope({
    super.key,
    this.theme = CarbideTheme.white,
    this.overrides = const CarbideThemeOverrides(),
    this.orderOfModifiers,
    required this.child,
  });

  /// The active Carbon theme.
  final CarbideTheme theme;

  /// Optional typed overrides (colors, font family).
  final CarbideThemeOverrides overrides;

  /// Optional Mix modifier ordering, forwarded to [MixScope].
  final List<Type>? orderOfModifiers;

  final Widget child;

  /// The active [CarbideTheme] for [context], or null if there is no scope.
  static CarbideTheme? maybeThemeOf(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<_CarbideInherited>();

    return scope?.theme;
  }

  /// The active [CarbideThemeOverrides] for [context] (empty with no scope).
  ///
  /// Lets font-aware helpers such as `CarbideType.fluidTextStyle` pick up the
  /// scope's configured font family without re-passing it at every call site.
  static CarbideThemeOverrides overridesOf(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<_CarbideInherited>();

    return scope?.overrides ?? const CarbideThemeOverrides();
  }

  /// The active [CarbideTheme] for [context].
  ///
  /// Throws if there is no enclosing [CarbideScope]; use [maybeThemeOf] when the
  /// scope may be absent.
  static CarbideTheme themeOf(BuildContext context) {
    final theme = maybeThemeOf(context);
    assert(theme != null, 'No CarbideScope found in the widget tree.');

    return theme ?? .white;
  }

  @override
  Widget build(BuildContext context) {
    return _CarbideInherited(
      theme: theme,
      overrides: overrides,
      child: MixScope(
        tokens: buildCarbideTokenMap(theme, overrides: overrides),
        orderOfModifiers: orderOfModifiers,
        child: child,
      ),
    );
  }
}

class _CarbideInherited extends InheritedWidget {
  const _CarbideInherited({
    required this.theme,
    required this.overrides,
    required super.child,
  });

  final CarbideTheme theme;
  final CarbideThemeOverrides overrides;

  @override
  bool updateShouldNotify(_CarbideInherited oldWidget) =>
      oldWidget.theme != theme || oldWidget.overrides != overrides;
}
