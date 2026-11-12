import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../components/icon_button/icon_button.dart';
import '../../utilities/remix_style.dart';
import '../models/statuses.dart';
import 'glyphs.dart';

part 'answer.g.dart';

/// The reader's verdict on an answer.
enum AgentAnswerFeedback {
  /// The answer helped (thumbs up).
  positive,

  /// The answer did not help (thumbs down).
  negative,
}

/// The assistant's answer: a body, its sources and an actions bar.
///
/// [child] is the body, such as the answer's markdown. It is never a live
/// region, so a screen reader does not read the answer token by token; the
/// host announces it once it is ready (see `AgentAnnouncer`).
///
/// Once the answer stops streaming, the actions bar offers copy, thumbs up,
/// thumbs down and retry, each when its callback is set. Copying shows
/// [copiedLabel] for [copiedDuration] as a status message, announced without
/// moving focus. The thumbs are toggles that report through [onFeedback].
///
/// [sources] sits between the body and the actions, usually an
/// [AgentSources]. A new streaming run, such as a retry, rebuilds it, so it
/// starts collapsed again.
class AgentAnswer extends StatefulWidget {
  /// Creates an answer with the body [child].
  const AgentAnswer({
    super.key,
    required this.child,
    this.status = AgentAnswerStatus.complete,
    this.id,
    this.sources,
    this.showActions,
    this.onCopy,
    this.feedback,
    this.onFeedback,
    this.onRetry,
    this.copyLabel = 'Copy',
    this.copiedLabel = 'Copied',
    this.positiveLabel = 'Good response',
    this.negativeLabel = 'Bad response',
    this.retryLabel = 'Retry',
    this.copiedDuration = const Duration(seconds: 2),
    this.semanticLabel = 'Answer',
    this.glyphBuilder,
    this.actionStyle = const IconButtonStyler.create(),
    this.style = const AgentAnswerStyler.create(),
    this.styleSpec,
  });

  /// The answer's body.
  final Widget child;

  /// Whether the answer streams, is complete or failed.
  final AgentAnswerStatus status;

  /// The answer's identity; a new identity that streams starts a new run.
  final Object? id;

  /// The answer's sources, usually an [AgentSources].
  final Widget? sources;

  /// Whether the actions bar shows once the answer stops streaming; defaults
  /// to [AgentAnswerStatus.showsActions].
  final bool? showActions;

  /// Copies the answer; the bar then shows [copiedLabel].
  final VoidCallback? onCopy;

  /// The reader's current verdict.
  final AgentAnswerFeedback? feedback;

  /// Receives the reader's new verdict, or null when they take it back.
  final ValueChanged<AgentAnswerFeedback?>? onFeedback;

  /// Asks for the answer again.
  final VoidCallback? onRetry;

  /// The accessible name of copy.
  final String copyLabel;

  /// The status message after copying.
  final String copiedLabel;

  /// The accessible name of thumbs up.
  final String positiveLabel;

  /// The accessible name of thumbs down.
  final String negativeLabel;

  /// The accessible name of retry.
  final String retryLabel;

  /// How long [copiedLabel] shows.
  final Duration copiedDuration;

  /// The answer's accessible name.
  final String semanticLabel;

  /// Draws the glyphs; defaults to the nearest [AgentGlyphs].
  final AgentGlyphBuilder? glyphBuilder;

  /// The style of every action.
  final IconButtonStyler actionStyle;

  /// The answer's style.
  final AgentAnswerStyler style;

  /// A resolved spec that bypasses [style].
  final AgentAnswerSpec? styleSpec;

  @override
  State<AgentAnswer> createState() => _AgentAnswerState();
}

final _answerLayout = AgentAnswerStyler(
  container: FlexBoxStyler()
      .mainAxisSize(MainAxisSize.min)
      .crossAxisAlignment(CrossAxisAlignment.stretch),
);

class _AgentAnswerState extends State<AgentAnswer> {
  /// Counts streaming runs; the sources rebuild for each one.
  int _run = 0;
  bool _copied = false;
  Timer? _copiedTimer;

  @override
  void didUpdateWidget(AgentAnswer oldWidget) {
    super.didUpdateWidget(oldWidget);
    final streaming = widget.status.isStreaming;
    final began = !oldWidget.status.isStreaming && streaming;
    final replaced = oldWidget.id != widget.id && streaming;
    if (began || replaced) {
      _run++;
      _clearCopied();
    }
  }

  void _copy() {
    widget.onCopy?.call();
    _copiedTimer?.cancel();
    _copiedTimer = Timer(widget.copiedDuration, () {
      if (mounted) setState(_clearCopied);
    });
    setState(() => _copied = true);
  }

  void _clearCopied() {
    _copiedTimer?.cancel();
    _copiedTimer = null;
    _copied = false;
  }

  void _toggleFeedback(AgentAnswerFeedback value) =>
      widget.onFeedback?.call(widget.feedback == value ? null : value);

  Widget _action({
    required String key,
    required AgentGlyph glyph,
    AgentGlyph? fallback,
    required String label,
    required VoidCallback onPressed,
  }) => RemixIconButton(
    key: ValueKey('agent-answer-$key'),
    icon: null,
    iconBuilder: (context, iconSpec, icon) {
      final spec = StyleSpec(spec: iconSpec);
      Widget? draw(AgentGlyph glyph) =>
          agentGlyph(context, widget.glyphBuilder, glyph, spec);

      return draw(glyph) ??
          (fallback == null ? null : draw(fallback)) ??
          const SizedBox.shrink();
    },
    semanticLabel: label,
    onPressed: onPressed,
    style: widget.actionStyle,
  );

  Widget _verdict(AgentAnswerFeedback value) {
    final positive = value == AgentAnswerFeedback.positive;

    return MergeSemantics(
      child: Semantics(
        toggled: widget.feedback == value,
        child: _action(
          key: value.name,
          glyph: positive ? AgentGlyph.positive : AgentGlyph.negative,
          label: positive ? widget.positiveLabel : widget.negativeLabel,
          onPressed: () => _toggleFeedback(value),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.status;
    final showActions =
        !status.isStreaming && (widget.showActions ?? status.showsActions);
    final sources = widget.sources;

    return RemixStyleSpecBuilder<AgentAnswerSpec>(
      style: _answerLayout.merge(widget.style),
      styleSpec: widget.styleSpec,
      builder: (context, spec) => Semantics(
        container: true,
        explicitChildNodes: true,
        label: widget.semanticLabel,
        child: ColumnBox(
          styleSpec: spec.container,
          children: [
            Box(
              styleSpec: spec.body,
              child: RemixDefaultContentStyle(
                text: spec.text,
                child: widget.child,
              ),
            ),
            if (sources != null)
              Box(
                styleSpec: spec.sources,
                child: KeyedSubtree(key: ValueKey(_run), child: sources),
              ),
            if (showActions)
              RowBox(
                styleSpec: spec.actions,
                children: [
                  if (widget.onCopy != null)
                    _action(
                      key: 'copy',
                      glyph: _copied ? AgentGlyph.copied : AgentGlyph.copy,
                      fallback: AgentGlyph.copy,
                      label: widget.copyLabel,
                      onPressed: _copy,
                    ),
                  if (widget.onFeedback != null) ...[
                    _verdict(AgentAnswerFeedback.positive),
                    _verdict(AgentAnswerFeedback.negative),
                  ],
                  if (widget.onRetry != null)
                    _action(
                      key: 'retry',
                      glyph: AgentGlyph.retry,
                      label: widget.retryLabel,
                      onPressed: widget.onRetry!,
                    ),
                  if (_copied)
                    // A status message, announced without moving focus
                    // (WCAG 2.2 SC 4.1.3).
                    Semantics(
                      container: true,
                      liveRegion: true,
                      child: StyledText(
                        widget.copiedLabel,
                        styleSpec: spec.feedback,
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _copiedTimer?.cancel();
    super.dispose();
  }
}

/// Resolved visual properties for an [AgentAnswer].
///
/// Every slot is empty by default; presets supply the look.
// No target: mix_generator 2.2.0-beta.3 emits InvalidType for constructor
// parameters typed with stylers generated in the same build (the nested
// component styles), as CalendarSpec notes.
@MixableSpec()
@immutable
final class AgentAnswerSpec with _$AgentAnswerSpec {
  /// The answer: body, sources and actions, top to bottom.
  @override
  final StyleSpec<FlexBoxSpec> container;

  /// Wraps the body.
  @override
  final StyleSpec<BoxSpec> body;

  /// The default text style of the body.
  @override
  final StyleSpec<TextSpec> text;

  /// Wraps the sources.
  @override
  final StyleSpec<BoxSpec> sources;

  /// The actions bar.
  @override
  final StyleSpec<FlexBoxSpec> actions;

  /// The status message after an action, such as "Copied".
  @override
  final StyleSpec<TextSpec> feedback;

  /// Creates a spec; every slot defaults to empty.
  const AgentAnswerSpec({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<BoxSpec>? body,
    StyleSpec<TextSpec>? text,
    StyleSpec<BoxSpec>? sources,
    StyleSpec<FlexBoxSpec>? actions,
    StyleSpec<TextSpec>? feedback,
  }) : container = container ?? const StyleSpec(spec: FlexBoxSpec()),
       body = body ?? const StyleSpec(spec: BoxSpec()),
       text = text ?? const StyleSpec(spec: TextSpec()),
       sources = sources ?? const StyleSpec(spec: BoxSpec()),
       actions = actions ?? const StyleSpec(spec: FlexBoxSpec()),
       feedback = feedback ?? const StyleSpec(spec: TextSpec());
}
