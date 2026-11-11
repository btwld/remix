import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import '../../agent/components/permission.dart';

import '../components/button.dart';
import '../components/card.dart';
import '../components/data_list.dart';
import '../components/disclosure.dart';
import '../theme/tokens.dart';

@immutable
final class VanillaAgentPermissionRecipe {
  const VanillaAgentPermissionRecipe({
    required this.style,
    required this.surfaceStyle,
    required this.detailsStyle,
    required this.parametersStyle,
    required this.allowOnceStyle,
    required this.alwaysAllowStyle,
    required this.denyStyle,
  });
  final AgentPermissionStyler style;
  final CardStyler surfaceStyle;
  final DisclosureStyler detailsStyle;
  final DataListStyler parametersStyle;
  final ButtonStyler allowOnceStyle;
  final ButtonStyler alwaysAllowStyle;
  final ButtonStyler denyStyle;
}

VanillaAgentPermissionRecipe vanillaAgentPermissionRecipe({
  AgentPermissionStyler style = const AgentPermissionStyler.create(),
  CardStyler surfaceStyle = const CardStyler.create(),
  DisclosureStyler detailsStyle = const DisclosureStyler.create(),
  DataListStyler parametersStyle = const DataListStyler.create(),
  ButtonStyler allowOnceStyle = const ButtonStyler.create(),
  ButtonStyler alwaysAllowStyle = const ButtonStyler.create(),
  ButtonStyler denyStyle = const ButtonStyler.create(),
}) => VanillaAgentPermissionRecipe(
  style: AgentPermissionStyler(
    header: FlexBoxStyler().spacing(8).crossAxisAlignment(.center),
    // Decisions sit at the trailing edge with the primary last, like Vanilla
    // dialog actions.
    actions: FlexBoxStyler()
        .mainAxisAlignment(.end)
        .spacing(8)
        .padding(.top(12)),
    title: TextStyler()
        .color(VanillaTokens.foreground())
        .fontWeight(FontWeight.w600),
    tool: TextStyler()
        .color(VanillaTokens.mutedForeground())
        .fontSize(12)
        .wrap(.padding(.top(4))),
    description: TextStyler()
        .color(VanillaTokens.mutedForeground())
        .wrap(.padding(.symmetric(vertical: 8))),
    status: TextStyler().color(VanillaTokens.mutedForeground()).fontSize(12),
    detailsLabel: TextStyler().color(VanillaTokens.foreground()).fontSize(13),
    toolIcon: IconStyler().color(VanillaTokens.foreground()).size(16),
    // The status mark takes its outcome's color from the status box below;
    // its glyph and label already name the outcome.
    statusIcon: IconStyler().size(12),
    indicator: IconStyler().color(VanillaTokens.foreground()).size(16),
    pendingStatus: _statusMark(VanillaTokens.primary),
    decidingStatus: _statusMark(VanillaTokens.primary),
    allowedStatus: _statusMark(VanillaTokens.primary),
    runningStatus: _statusMark(VanillaTokens.primary),
    completedStatus: _statusMark(VanillaTokens.primary),
    deniedStatus: _statusMark(VanillaTokens.mutedForeground),
    errorStatus: _statusMark(VanillaTokens.destructive),
  ).merge(style),
  surfaceStyle: vanillaCardStyle(
    style: CardStyler().padding(.all(VanillaTokens.s4)).merge(surfaceStyle),
  ),
  detailsStyle: vanillaDisclosureStyle(
    style: DisclosureStyler()
        .padding(.symmetric(vertical: VanillaTokens.s2))
        .content(BoxStyler().padding(.bottom(VanillaTokens.s2)))
        .merge(detailsStyle),
  ),
  parametersStyle: vanillaDataListStyle(style: parametersStyle),
  allowOnceStyle: vanillaButtonStyle(style: allowOnceStyle),
  alwaysAllowStyle: vanillaButtonStyle(
    variant: .outline,
    style: alwaysAllowStyle,
  ),
  denyStyle: vanillaButtonStyle(variant: .ghost, style: denyStyle),
);

BoxStyler _statusMark(ColorToken color) =>
    BoxStyler().wrap(.iconTheme(color: color()));
