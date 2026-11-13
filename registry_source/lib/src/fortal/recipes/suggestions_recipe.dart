import 'package:flutter/widgets.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';

import '../components/button.dart';
import '../theme/theme.dart';

/// Styles for the suggestions: a centered row of outline buttons.
@immutable
final class FortalAgentSuggestionsRecipe {
  const FortalAgentSuggestionsRecipe({
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
FortalAgentSuggestionsRecipe fortalAgentSuggestionsRecipe({
  AgentSuggestionsStyler style = const AgentSuggestionsStyler.create(),
  ButtonStyler suggestionStyle = const ButtonStyler.create(),
}) => FortalAgentSuggestionsRecipe(
  style: AgentSuggestionsStyler(
    container: WrapBoxStyler()
        .alignment(.center)
        .spacing(FortalTokens.space2())
        .runSpacing(FortalTokens.space2()),
  ).merge(style),
  suggestionStyle: fortalButtonStyle(
    variant: .outline,
    size: .size2,
    style: suggestionStyle,
  ),
);
