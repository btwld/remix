import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import '../../agent/components/permission.dart';

import '../components/button.dart';
import '../components/card.dart';
import '../components/data_list.dart';
import '../components/disclosure.dart';
import '../theme/theme.dart';

/// Styles for a permission request: a card, a disclosure for its details, and
/// primary, outline, and ghost buttons for its three answers.
@immutable
final class FortalAgentPermissionRecipe {
  const FortalAgentPermissionRecipe({
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
FortalAgentPermissionRecipe fortalAgentPermissionRecipe({
  AgentPermissionStyler style = const AgentPermissionStyler.create(),
  CardStyler surfaceStyle = const CardStyler.create(),
  DisclosureStyler detailsStyle = const DisclosureStyler.create(),
  DataListStyler parametersStyle = const DataListStyler.create(),
  ButtonStyler allowOnceStyle = const ButtonStyler.create(),
  ButtonStyler alwaysAllowStyle = const ButtonStyler.create(),
  ButtonStyler denyStyle = const ButtonStyler.create(),
}) => FortalAgentPermissionRecipe(
  style: AgentPermissionStyler(
    header: FlexBoxStyler()
        .spacing(FortalTokens.space2())
        .crossAxisAlignment(.center),
    actions: FlexBoxStyler()
        .spacing(FortalTokens.space2())
        .padding(.top(FortalTokens.space2())),
    title: TextStyler()
        .color(FortalTokens.gray12())
        .fontWeight(FortalTokens.fontWeightSemibold()),
    tool: TextStyler()
        .color(FortalTokens.gray11())
        .style(FortalTokens.text1.mix())
        .wrap(.padding(.top(FortalTokens.space1()))),
    description: TextStyler()
        .color(FortalTokens.gray11())
        .wrap(.padding(.vertical(FortalTokens.space2()))),
    status: TextStyler()
        .color(FortalTokens.gray11())
        .style(FortalTokens.text1.mix()),
    detailsLabel: TextStyler()
        .color(FortalTokens.gray12())
        .style(FortalTokens.text2.mix()),
    toolIcon: IconStyler()
        .color(FortalTokens.gray12())
        .size(FortalTokens.space4()),
    statusIcon: IconStyler()
        .color(FortalTokens.accentIndicator())
        .size(FortalTokens.space3()),
    indicator: IconStyler()
        .color(FortalTokens.gray12())
        .size(FortalTokens.space4()),
  ).merge(style),
  surfaceStyle: fortalCardStyle(size: .size2, style: surfaceStyle),
  detailsStyle: fortalDisclosureStyle(
    size: .size1,
    style: DisclosureStyler()
        .container(BoxStyler().margin(.top(FortalTokens.space1())))
        .merge(detailsStyle),
  ),
  parametersStyle: fortalDataListStyle(style: parametersStyle),
  allowOnceStyle: fortalButtonStyle(style: allowOnceStyle),
  alwaysAllowStyle: fortalButtonStyle(
    variant: .outline,
    style: alwaysAllowStyle,
  ),
  denyStyle: fortalButtonStyle(variant: .ghost, style: denyStyle),
);
