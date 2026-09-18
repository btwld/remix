// Adapted from remix_carbon at commit 606bfbb36 and from design tokens in the
// IBM Carbon Design System. Copyright 2026 the Remix authors; IBM Carbon
// Design System copyright IBM Corp. and the Carbon authors. Apache-2.0.
// SPDX-License-Identifier: Apache-2.0

import 'package:remix/remix.dart';

/// The Carbon role tokens required by the initial Button slice.
///
/// Token keys intentionally retain Carbon's domain vocabulary. The `Carbide`
/// Dart identifier is the registry's authoring prefix and is replaced with the
/// consumer-selected prefix during installation.
abstract final class CarbideTokens {
  static const backgroundActive = ColorToken('carbon.color.backgroundActive');
  static const backgroundHover = ColorToken('carbon.color.backgroundHover');
  static const borderDisabled = ColorToken('carbon.color.borderDisabled');
  static const focus = ColorToken('carbon.color.focus');
  static const focusInset = ColorToken('carbon.color.focusInset');
  static const linkPrimary = ColorToken('carbon.color.linkPrimary');
  static const linkPrimaryHover = ColorToken('carbon.color.linkPrimaryHover');
  static const textDisabled = ColorToken('carbon.color.textDisabled');
  static const textInverse = ColorToken('carbon.color.textInverse');
  static const textOnColor = ColorToken('carbon.color.textOnColor');
  static const textOnColorDisabled = ColorToken(
    'carbon.color.textOnColorDisabled',
  );

  static const spacing03 = SpaceToken('carbon.space.spacing03');
  static const spacing05 = SpaceToken('carbon.space.spacing05');
  static const spacing07 = SpaceToken('carbon.space.spacing07');
  static const iconSize01 = SpaceToken('carbon.space.iconSize01');

  static const bodyCompact01 = TextStyleToken('carbon.type.bodyCompact01');
}

/// The Carbon component tokens required by the initial Button slice.
abstract final class CarbideComponentTokens {
  static const buttonDangerActive = ColorToken(
    'carbon.comp.buttonDangerActive',
  );
  static const buttonDangerHover = ColorToken('carbon.comp.buttonDangerHover');
  static const buttonDangerPrimary = ColorToken(
    'carbon.comp.buttonDangerPrimary',
  );
  static const buttonDangerSecondary = ColorToken(
    'carbon.comp.buttonDangerSecondary',
  );
  static const buttonDisabled = ColorToken('carbon.comp.buttonDisabled');
  static const buttonPrimary = ColorToken('carbon.comp.buttonPrimary');
  static const buttonPrimaryActive = ColorToken(
    'carbon.comp.buttonPrimaryActive',
  );
  static const buttonPrimaryHover = ColorToken(
    'carbon.comp.buttonPrimaryHover',
  );
  static const buttonSecondary = ColorToken('carbon.comp.buttonSecondary');
  static const buttonSecondaryActive = ColorToken(
    'carbon.comp.buttonSecondaryActive',
  );
  static const buttonSecondaryHover = ColorToken(
    'carbon.comp.buttonSecondaryHover',
  );
  static const buttonTertiary = ColorToken('carbon.comp.buttonTertiary');
  static const buttonTertiaryActive = ColorToken(
    'carbon.comp.buttonTertiaryActive',
  );
  static const buttonTertiaryHover = ColorToken(
    'carbon.comp.buttonTertiaryHover',
  );
}
