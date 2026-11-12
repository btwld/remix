import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../components/button/button.dart';
import '../../utilities/remix_style.dart';
import '../behavior/composer.dart';

part 'suggestions.g.dart';

/// A prompt offered to start or continue a conversation.
@immutable
final class AgentSuggestion {
  /// Creates a suggestion shown as [label] that fills the composer with
  /// [prompt], or with [label] when [prompt] is null.
  const AgentSuggestion({required this.label, String? prompt, this.icon})
    : prompt = prompt ?? label;

  /// The visible label.
  final String label;

  /// The text the suggestion puts in the composer.
  final String prompt;

  /// An optional leading icon; it inherits the suggestion's icon style.
  final Widget? icon;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AgentSuggestion &&
          other.label == label &&
          other.prompt == prompt &&
          identical(other.icon, icon);

  @override
  int get hashCode => Object.hash(label, prompt, identityHashCode(icon));

  @override
  String toString() => 'AgentSuggestion(label: $label, prompt: $prompt)';
}

/// Suggested prompts, such as the starters of an empty conversation.
///
/// Tapping a suggestion fills the composer through [controller], with the
/// cursor at the end, and focuses it through [focusNode]. It never sends:
/// the reader reviews the prompt and sends it.
///
/// The suggestions are disabled while [enabled] is false and while
/// [controller] is running, since a run in progress cannot take a new prompt.
class AgentSuggestions extends StatelessWidget {
  /// Creates suggestions that fill [controller].
  const AgentSuggestions({
    super.key,
    required this.suggestions,
    required this.controller,
    this.focusNode,
    this.onSelected,
    this.enabled = true,
    this.semanticLabel = 'Suggestions',
    this.suggestionStyle = const ButtonStyler.create(),
    this.style = const AgentSuggestionsStyler.create(),
    this.styleSpec,
  });

  /// The suggestions in order.
  final List<AgentSuggestion> suggestions;

  /// The composer's draft, which a tapped suggestion replaces.
  final AgentComposerController controller;

  /// The composer's focus node, focused after a suggestion fills it.
  final FocusNode? focusNode;

  /// Receives the tapped suggestion, after it filled the composer.
  final ValueChanged<AgentSuggestion>? onSelected;

  /// Whether the suggestions can be tapped. They are also disabled while
  /// [controller] is [AgentComposerController.running].
  final bool enabled;

  /// The group's accessible name.
  final String semanticLabel;

  /// The style of each suggestion.
  final ButtonStyler suggestionStyle;

  /// The style of the group.
  final AgentSuggestionsStyler style;

  /// A resolved spec that bypasses [style].
  final AgentSuggestionsSpec? styleSpec;

  void _select(AgentSuggestion suggestion) {
    final prompt = suggestion.prompt;
    controller.value = TextEditingValue(
      text: prompt,
      selection: TextSelection.collapsed(offset: prompt.length),
    );
    focusNode?.requestFocus();
    onSelected?.call(suggestion);
  }

  @override
  Widget build(BuildContext context) {
    return RemixStyleSpecBuilder<AgentSuggestionsSpec>(
      style: style,
      styleSpec: styleSpec,
      builder: (context, spec) => ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          final active = enabled && !controller.running;

          return Semantics(
            container: true,
            explicitChildNodes: true,
            label: semanticLabel,
            child: WrapBox(
              styleSpec: spec.container,
              children: [
                for (final (index, suggestion) in suggestions.indexed)
                  RemixButton(
                    key: ValueKey('agent-suggestion-$index'),
                    label: suggestion.label,
                    leadingIconBuilder: suggestion.icon == null
                        ? null
                        : (context, iconSpec, icon) => RemixDefaultContentStyle(
                            icon: StyleSpec(spec: iconSpec),
                            child: suggestion.icon!,
                          ),
                    enabled: active,
                    onPressed: () => _select(suggestion),
                    style: suggestionStyle,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Resolved visual properties for [AgentSuggestions].
///
/// Every slot is empty by default; presets supply the look.
// No target: mix_generator 2.2.0-beta.3 emits InvalidType for constructor
// parameters typed with stylers generated in the same build (the nested
// component styles), as CalendarSpec notes.
@MixableSpec()
@immutable
final class AgentSuggestionsSpec with _$AgentSuggestionsSpec {
  /// The group, which wraps its suggestions onto lines.
  @override
  final StyleSpec<WrapBoxSpec> container;

  /// Creates a spec; every slot defaults to empty.
  const AgentSuggestionsSpec({StyleSpec<WrapBoxSpec>? container})
    : container = container ?? const StyleSpec(spec: WrapBoxSpec());
}
