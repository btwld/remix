import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../components/transcript.dart';
import '../theme/theme.dart';

/// Styles for the transcript: the spacing between its entries.
@immutable
final class UiAgentTranscriptRecipe {
  const UiAgentTranscriptRecipe({required this.style});

  /// Styles for the spacing between transcript entries.
  final UiTranscriptStyler style;
}

/// Builds the recipe; each argument is merged last, so callers can override.
UiAgentTranscriptRecipe uiAgentTranscriptRecipe({
  UiTranscriptStyler style = const UiTranscriptStyler.create(),
}) => UiAgentTranscriptRecipe(
  style: UiTranscriptStyler(
    viewport: BoxStyler(),
    item: BoxStyler(),
    spacing: UiTokens.space3(),
  ).merge(style),
);
