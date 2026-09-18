// Adapted from remix_carbon at commit 606bfbb36 and from design tokens in the
// IBM Carbon Design System. Copyright 2026 the Remix authors; IBM Carbon
// Design System copyright IBM Corp. and the Carbon authors. Apache-2.0.
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import 'theme_data.dart';

/// Provides Carbon tokens and the active [CarbideTheme] to a subtree.
class CarbideScope extends StatelessWidget {
  const CarbideScope({
    super.key,
    this.theme = CarbideTheme.white,
    this.overrides = const CarbideThemeOverrides(),
    this.orderOfModifiers,
    required this.child,
  });

  final CarbideTheme theme;
  final CarbideThemeOverrides overrides;
  final List<Type>? orderOfModifiers;
  final Widget child;

  static CarbideTheme? maybeThemeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_CarbideInherited>()?.theme;

  static CarbideTheme themeOf(BuildContext context) {
    final theme = maybeThemeOf(context);
    assert(theme != null, 'No CarbideScope found in the widget tree.');
    return theme ?? .white;
  }

  static CarbideThemeOverrides overridesOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<_CarbideInherited>()
          ?.overrides ??
      const CarbideThemeOverrides();

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
