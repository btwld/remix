import 'package:flutter/widgets.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';

import '../components/button.dart';

/// Styles for the suggestions: a centered row of outline buttons.
@immutable
final class UiAgentSuggestionsRecipe {
  const UiAgentSuggestionsRecipe({
    required this.style,
    required this.suggestionStyle,
  });

  /// Styles for the wrapping row of suggestions.
  final AgentSuggestionsStyler style;

  /// Styles for each suggestion.
  final ButtonStyler suggestionStyle;
}

/// Builds the recipe; each argument is merged last, so callers can override.
///
/// Suggestions are outline buttons, so the only filled shape in a conversation
/// is the reader's own message.
UiAgentSuggestionsRecipe uiAgentSuggestionsRecipe({
  AgentSuggestionsStyler style = const AgentSuggestionsStyler.create(),
  ButtonStyler suggestionStyle = const ButtonStyler.create(),
}) => UiAgentSuggestionsRecipe(
  style: AgentSuggestionsStyler(
    container: WrapBoxStyler().alignment(.center).spacing(8).runSpacing(8),
  ).merge(style),
  suggestionStyle: uiButtonStyle(
    variant: .outline,
    size: .sm,
    style: suggestionStyle,
  ),
);
