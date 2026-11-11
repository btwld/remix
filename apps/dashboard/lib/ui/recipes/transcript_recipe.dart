import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../components/icon_button.dart';
import '../components/transcript.dart';
import '../theme/theme.dart';

@immutable
final class UiAgentTranscriptRecipe {
  const UiAgentTranscriptRecipe({
    required this.style,
    required this.latestStyle,
  });
  final UiTranscriptStyler style;
  final IconButtonStyler latestStyle;
}

UiAgentTranscriptRecipe uiAgentTranscriptRecipe({
  UiTranscriptStyler style = const UiTranscriptStyler.create(),
  IconButtonStyler latestStyle = const IconButtonStyler.create(),
}) => UiAgentTranscriptRecipe(
  style: UiTranscriptStyler(
    viewport: BoxStyler(),
    item: BoxStyler(),
    spacing: UiTokens.space3(),
    latest: BoxStyler().padding(.bottom(UiTokens.space3())),
  ).merge(style),
  // A round surface button over the newest output. Its fill is the opaque
  // panel, so the output beneath does not show through; Ui keeps shadows
  // for floating layers, so its accent frame alone sets it apart.
  latestStyle: uiIconButtonStyle(
    variant: .surface,
    size: .size2,
    style: IconButtonStyler()
        .color(UiTokens.colorPanelSolid())
        .borderRadius(.all(UiTokens.radiusCircle()))
        .onHovered(.color(UiTokens.colorPanelSolid()))
        .onPressed(.color(UiTokens.gray3()))
        .merge(latestStyle),
  ),
);
