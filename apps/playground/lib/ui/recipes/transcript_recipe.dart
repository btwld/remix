import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../components/transcript.dart';

@immutable
final class PlaygroundAgentTranscriptRecipe {
  const PlaygroundAgentTranscriptRecipe({required this.style});
  final PlaygroundTranscriptStyler style;
}

PlaygroundAgentTranscriptRecipe playgroundAgentTranscriptRecipe({
  PlaygroundTranscriptStyler style = const PlaygroundTranscriptStyler.create(),
}) => PlaygroundAgentTranscriptRecipe(
  style: PlaygroundTranscriptStyler(
    viewport: BoxStyler(),
    item: BoxStyler(),
    spacing: 12,
  ).merge(style),
);
