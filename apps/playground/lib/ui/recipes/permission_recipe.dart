import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../components/button.dart';
import '../components/card.dart';
import '../components/data_list.dart';
import '../components/disclosure.dart';
import '../components/permission.dart';
import '../theme/tokens.dart';

/// Styles for a permission request: a card, a disclosure for its details, and
/// primary, outline, and ghost buttons for its three answers.
@immutable
final class PlaygroundAgentPermissionRecipe {
  const PlaygroundAgentPermissionRecipe({
    required this.style,
    required this.surfaceStyle,
    required this.detailsStyle,
    required this.parametersStyle,
    required this.allowOnceStyle,
    required this.alwaysAllowStyle,
    required this.denyStyle,
  });

  /// Styles for the header, actions, text and icons of a request.
  final PlaygroundPermissionStyler style;

  /// Styles for the card the request sits in.
  final CardStyler surfaceStyle;

  /// Styles for the disclosure that reveals the request details.
  final DisclosureStyler detailsStyle;

  /// Styles for the list of request parameters.
  final DataListStyler parametersStyle;

  /// Styles for the button that allows the request once.
  final ButtonStyler allowOnceStyle;

  /// Styles for the button that always allows the request.
  final ButtonStyler alwaysAllowStyle;

  /// Styles for the button that denies the request.
  final ButtonStyler denyStyle;
}

/// Builds the recipe; each argument is merged last, so callers can override.
PlaygroundAgentPermissionRecipe playgroundAgentPermissionRecipe({
  PlaygroundPermissionStyler style = const PlaygroundPermissionStyler.create(),
  CardStyler surfaceStyle = const CardStyler.create(),
  DisclosureStyler detailsStyle = const DisclosureStyler.create(),
  DataListStyler parametersStyle = const DataListStyler.create(),
  ButtonStyler allowOnceStyle = const ButtonStyler.create(),
  ButtonStyler alwaysAllowStyle = const ButtonStyler.create(),
  ButtonStyler denyStyle = const ButtonStyler.create(),
}) => PlaygroundAgentPermissionRecipe(
  style: PlaygroundPermissionStyler(
    header: FlexBoxStyler().spacing(8).crossAxisAlignment(.center),
    actions: FlexBoxStyler().spacing(8).padding(.top(12)),
    title: TextStyler()
        .color(PlaygroundTokens.foreground())
        .fontWeight(FontWeight.w600),
    tool: TextStyler()
        .color(PlaygroundTokens.mutedForeground())
        .fontSize(12)
        .wrap(.padding(.top(4))),
    description: TextStyler()
        .color(PlaygroundTokens.mutedForeground())
        .wrap(.padding(.symmetric(vertical: 8))),
    status: TextStyler().color(PlaygroundTokens.mutedForeground()).fontSize(12),
    detailsLabel: TextStyler()
        .color(PlaygroundTokens.foreground())
        .fontSize(13),
    toolIcon: IconStyler().color(PlaygroundTokens.foreground()).size(16),
    statusIcon: IconStyler().color(PlaygroundTokens.primary()).size(12),
    indicator: IconStyler().color(PlaygroundTokens.foreground()).size(16),
  ).merge(style),
  surfaceStyle: playgroundCardStyle(
    style: CardStyler().padding(.all(PlaygroundTokens.s4)).merge(surfaceStyle),
  ),
  detailsStyle: playgroundDisclosureStyle(
    style: DisclosureStyler()
        .padding(.symmetric(vertical: PlaygroundTokens.s2))
        .content(BoxStyler().padding(.bottom(PlaygroundTokens.s2)))
        .merge(detailsStyle),
  ),
  parametersStyle: playgroundDataListStyle(style: parametersStyle),
  allowOnceStyle: playgroundButtonStyle(style: allowOnceStyle),
  alwaysAllowStyle: playgroundButtonStyle(
    variant: .outline,
    style: alwaysAllowStyle,
  ),
  denyStyle: playgroundButtonStyle(variant: .ghost, style: denyStyle),
);
