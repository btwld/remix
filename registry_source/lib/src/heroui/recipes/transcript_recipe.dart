import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import '../../agent/components/transcript.dart';

/// Styles for the transcript: the spacing between its entries. Each entry
/// brings its own surface recipe.
@immutable
final class HeroUiAgentTranscriptRecipe {
  const HeroUiAgentTranscriptRecipe({required this.style});

  /// Styles for the spacing between transcript entries.
  final AgentTranscriptStyler style;
}

/// Builds the recipe; each argument is merged last, so callers can override.
HeroUiAgentTranscriptRecipe heroUiAgentTranscriptRecipe({
  AgentTranscriptStyler style = const AgentTranscriptStyler.create(),
}) => HeroUiAgentTranscriptRecipe(
  style: AgentTranscriptStyler(
    viewport: BoxStyler(),
    item: BoxStyler(),
    spacing: 12,
  ).merge(style),
);
