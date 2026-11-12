import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import '../theme/theme.dart';
import '../../agent/components/transcript.dart';

/// Styles for the transcript: the spacing between its entries.
@immutable
final class FortalAgentTranscriptRecipe {
  const FortalAgentTranscriptRecipe({required this.style});

  /// Styles for the spacing between transcript entries.
  final AgentTranscriptStyler style;
}

/// Builds the recipe; each argument is merged last, so callers can override.
FortalAgentTranscriptRecipe fortalAgentTranscriptRecipe({
  AgentTranscriptStyler style = const AgentTranscriptStyler.create(),
}) => FortalAgentTranscriptRecipe(
  style: AgentTranscriptStyler(
    viewport: BoxStyler(),
    item: BoxStyler(),
    spacing: FortalTokens.space3(),
  ).merge(style),
);
