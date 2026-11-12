import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../components/button.dart';
import '../components/card.dart';
import '../components/disclosure.dart';
import '../components/permission.dart';
import '../theme/theme.dart';

/// Styles for a permission request: a HeroUI card, a disclosure for its
/// details, and primary, outline, and ghost buttons for its three answers.
///
/// HeroUI has no data list, so the parameters are styled here from the theme:
/// `text-sm` labels in `muted` beside values in `foreground`.
@immutable
final class UiAgentPermissionRecipe {
  const UiAgentPermissionRecipe({
    required this.style,
    required this.surfaceStyle,
    required this.detailsStyle,
    required this.parametersStyle,
    required this.allowOnceStyle,
    required this.alwaysAllowStyle,
    required this.denyStyle,
  });

  /// Styles for the header, actions, text and icons of a request.
  final UiPermissionStyler style;

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
UiAgentPermissionRecipe uiAgentPermissionRecipe({
  UiPermissionStyler style = const UiPermissionStyler.create(),
  CardStyler surfaceStyle = const CardStyler.create(),
  DisclosureStyler detailsStyle = const DisclosureStyler.create(),
  DataListStyler parametersStyle = const DataListStyler.create(),
  ButtonStyler allowOnceStyle = const ButtonStyler.create(),
  ButtonStyler alwaysAllowStyle = const ButtonStyler.create(),
  ButtonStyler denyStyle = const ButtonStyler.create(),
}) => UiAgentPermissionRecipe(
  style: UiPermissionStyler(
    header: FlexBoxStyler().spacing(8).crossAxisAlignment(.center),
    actions: FlexBoxStyler().spacing(8).padding(.top(12)),
    title: TextStyler()
        .style(UiTokens.textSm.mix())
        .fontWeight(.w600)
        .color(UiTokens.foreground()),
    tool: TextStyler()
        .style(UiTokens.textXs.mix())
        .color(UiTokens.muted())
        .wrap(.padding(.top(4))),
    description: TextStyler()
        .style(UiTokens.textSm.mix())
        .color(UiTokens.muted())
        .wrap(.padding(.symmetric(vertical: 8))),
    status: TextStyler().style(UiTokens.textXs.mix()).color(UiTokens.muted()),
    detailsLabel: TextStyler()
        .style(UiTokens.textSm.mix())
        .color(UiTokens.foreground()),
    toolIcon: IconStyler().color(UiTokens.foreground()).size(16),
    statusIcon: IconStyler().color(UiTokens.accent()).size(12),
    indicator: IconStyler().color(UiTokens.foreground()).size(16),
  ).merge(style),
  surfaceStyle: uiCardStyle(style: surfaceStyle),
  detailsStyle: uiDisclosureStyle(
    style: DisclosureStyler()
        .padding(.symmetric(vertical: 8))
        .content(BoxStyler().padding(.bottom(8)))
        .merge(detailsStyle),
  ),
  parametersStyle: DataListStyler()
      .label(.style(UiTokens.textSm.mix()).color(UiTokens.muted()))
      .value(.style(UiTokens.textSm.mix()).color(UiTokens.foreground()))
      .rowSpacing(12)
      .columnSpacing(24)
      .labelValueSpacing(8)
      .minLabelWidth(96)
      .merge(parametersStyle),
  allowOnceStyle: uiButtonStyle(style: allowOnceStyle),
  alwaysAllowStyle: uiButtonStyle(variant: .outline, style: alwaysAllowStyle),
  denyStyle: uiButtonStyle(variant: .ghost, style: denyStyle),
);
