import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import '../../agent/components/permission.dart';

import '../components/button.dart';
import '../components/card.dart';
import '../components/disclosure.dart';
import '../theme/theme.dart';

/// Styles for a permission request: a HeroUI card, a disclosure for its
/// details, and primary, outline, and ghost buttons for its three answers.
///
/// HeroUI has no data list, so the parameters are styled here from the theme:
/// `text-sm` labels in `muted` beside values in `foreground`.
@immutable
final class HeroUiAgentPermissionRecipe {
  const HeroUiAgentPermissionRecipe({
    required this.style,
    required this.surfaceStyle,
    required this.detailsStyle,
    required this.parametersStyle,
    required this.allowOnceStyle,
    required this.alwaysAllowStyle,
    required this.denyStyle,
  });

  /// Styles for the header, actions, text and icons of a request.
  final AgentPermissionStyler style;

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
HeroUiAgentPermissionRecipe heroUiAgentPermissionRecipe({
  AgentPermissionStyler style = const AgentPermissionStyler.create(),
  CardStyler surfaceStyle = const CardStyler.create(),
  DisclosureStyler detailsStyle = const DisclosureStyler.create(),
  DataListStyler parametersStyle = const DataListStyler.create(),
  ButtonStyler allowOnceStyle = const ButtonStyler.create(),
  ButtonStyler alwaysAllowStyle = const ButtonStyler.create(),
  ButtonStyler denyStyle = const ButtonStyler.create(),
}) => HeroUiAgentPermissionRecipe(
  style: AgentPermissionStyler(
    header: FlexBoxStyler().spacing(8).crossAxisAlignment(.center),
    actions: FlexBoxStyler().spacing(8).padding(.top(12)),
    title: TextStyler()
        .style(HeroUiTokens.textSm.mix())
        .fontWeight(.w600)
        .color(HeroUiTokens.foreground()),
    tool: TextStyler()
        .style(HeroUiTokens.textXs.mix())
        .color(HeroUiTokens.muted())
        .wrap(.padding(.top(4))),
    description: TextStyler()
        .style(HeroUiTokens.textSm.mix())
        .color(HeroUiTokens.muted())
        .wrap(.padding(.symmetric(vertical: 8))),
    status: TextStyler()
        .style(HeroUiTokens.textXs.mix())
        .color(HeroUiTokens.muted()),
    detailsLabel: TextStyler()
        .style(HeroUiTokens.textSm.mix())
        .color(HeroUiTokens.foreground()),
    toolIcon: IconStyler().color(HeroUiTokens.foreground()).size(16),
    statusIcon: IconStyler().color(HeroUiTokens.accent()).size(12),
    indicator: IconStyler().color(HeroUiTokens.foreground()).size(16),
  ).merge(style),
  surfaceStyle: heroUiCardStyle(style: surfaceStyle),
  detailsStyle: heroUiDisclosureStyle(
    style: DisclosureStyler()
        .padding(.symmetric(vertical: 8))
        .content(BoxStyler().padding(.bottom(8)))
        .merge(detailsStyle),
  ),
  parametersStyle: DataListStyler()
      .label(.style(HeroUiTokens.textSm.mix()).color(HeroUiTokens.muted()))
      .value(.style(HeroUiTokens.textSm.mix()).color(HeroUiTokens.foreground()))
      .rowSpacing(12)
      .columnSpacing(24)
      .labelValueSpacing(8)
      .minLabelWidth(96)
      .merge(parametersStyle),
  allowOnceStyle: heroUiButtonStyle(style: allowOnceStyle),
  alwaysAllowStyle: heroUiButtonStyle(
    variant: .outline,
    style: alwaysAllowStyle,
  ),
  denyStyle: heroUiButtonStyle(variant: .ghost, style: denyStyle),
);
