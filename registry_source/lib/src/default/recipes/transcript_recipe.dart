import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import '../../agent/components/transcript.dart';

/// Styles for the transcript: the spacing between its entries.
@immutable
final class VanillaAgentTranscriptRecipe {
  const VanillaAgentTranscriptRecipe({required this.style});

  /// Styles for the spacing between transcript entries.
  final AgentTranscriptStyler style;
}

/// Builds the recipe; each argument is merged last, so callers can override.
VanillaAgentTranscriptRecipe vanillaAgentTranscriptRecipe({
  AgentTranscriptStyler style = const AgentTranscriptStyler.create(),
}) => VanillaAgentTranscriptRecipe(
  style: AgentTranscriptStyler(
    viewport: BoxStyler(),
    item: BoxStyler(),
    spacing: 12,
  ).merge(style),
);
