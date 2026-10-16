import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import '../../agent/components/transcript.dart';

@immutable
final class FortalAgentTranscriptRecipe {
  const FortalAgentTranscriptRecipe({required this.style});
  final AgentTranscriptStyler style;
}

FortalAgentTranscriptRecipe fortalAgentTranscriptRecipe({
  AgentTranscriptStyler style = const AgentTranscriptStyler.create(),
}) => FortalAgentTranscriptRecipe(
  style: AgentTranscriptStyler(
    viewport: BoxStyler(),
    item: BoxStyler(),
    spacing: 12,
  ).merge(style),
);
