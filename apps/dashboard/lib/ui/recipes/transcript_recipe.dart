import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../components/transcript.dart';
import '../theme/theme.dart';

@immutable
final class UiAgentTranscriptRecipe {
  const UiAgentTranscriptRecipe({required this.style});
  final UiTranscriptStyler style;
}

UiAgentTranscriptRecipe uiAgentTranscriptRecipe({
  UiTranscriptStyler style = const UiTranscriptStyler.create(),
}) => UiAgentTranscriptRecipe(
  style: UiTranscriptStyler(
    viewport: BoxStyler(),
    item: BoxStyler(),
    spacing: UiTokens.space3(),
  ).merge(style),
);
