import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../components/transcript.dart';

/// Styles for the transcript: the spacing between its entries.
@immutable
final class PlaygroundAgentTranscriptRecipe {
  const PlaygroundAgentTranscriptRecipe({required this.style});

  /// Styles for the spacing between transcript entries.
  final PlaygroundTranscriptStyler style;
}

/// Builds the recipe; each argument is merged last, so callers can override.
PlaygroundAgentTranscriptRecipe playgroundAgentTranscriptRecipe({
  PlaygroundTranscriptStyler style = const PlaygroundTranscriptStyler.create(),
}) => PlaygroundAgentTranscriptRecipe(
  style: PlaygroundTranscriptStyler(
    viewport: BoxStyler(),
    item: BoxStyler(),
    spacing: 12,
  ).merge(style),
);
