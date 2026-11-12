import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../models/statuses.dart';
import '../support/disclosure.dart';
import '../support/functional_glyph.dart';

part 'answer.g.dart';

/// Builds the sources disclosure indicator in place of the default chevron.
typedef PlaygroundAnswerSourcesIndicatorBuilder =
    Widget Function(BuildContext context, bool expanded);

/// Streaming answer surface with host-owned content and feedback.
class PlaygroundAnswer extends StatefulWidget {
  const PlaygroundAnswer({
    super.key,
    required this.child,
    this.streamId,
    this.status = PlaygroundAnswerStatus.streaming,
    this.onCopy,
    this.onRetry,
    this.copyIconBuilder,
    this.retryIconBuilder,
    this.sourcesIndicatorBuilder,
    this.copyLabel = 'Copy answer',
    this.retryLabel = 'Retry answer',
    this.showActions,
    this.feedback,
    this.sourcesContent,
    this.sourcesExpanded,
    this.defaultSourcesExpanded = false,
    this.onSourcesExpandedChanged,
    this.sourcesLabel = 'Sources',
    this.semanticLabel = 'Answer',
    this.surfaceStyle = const CardStyler.create(),
    this.sourcesStyle = const DisclosureStyler.create(),
    this.copyStyle = const IconButtonStyler.create(),
    this.retryStyle = const IconButtonStyler.create(),
    this.style = const PlaygroundAnswerStyler.create(),
    this.styleSpec,
  });

  /// The answer body, rendered by the host.
  final Widget child;

  /// Identifies the current stream; a new id while streaming closes sources.
  final Object? streamId;

  /// Where the answer is in its lifecycle.
  final PlaygroundAnswerStatus status;

  /// Called by the copy action, which is shown only when this is set.
  final VoidCallback? onCopy;

  /// Called by the retry action, which is shown only when this is set.
  final VoidCallback? onRetry;

  /// Replaces the copy action's default icon.
  final RemixIconButtonIconBuilder? copyIconBuilder;

  /// Replaces the retry action's default icon.
  final RemixIconButtonIconBuilder? retryIconBuilder;

  /// Replaces the sources disclosure's default chevron.
  final PlaygroundAnswerSourcesIndicatorBuilder? sourcesIndicatorBuilder;

  /// Accessible label of the copy action.
  final String copyLabel;

  /// Accessible label of the retry action.
  final String retryLabel;

  /// Forces the actions on or off once streaming ends.
  ///
  /// When null, [status] decides.
  final bool? showActions;

  /// A status message, such as "Copied", announced beside the actions once the
  /// answer completes.
  final Widget? feedback;

  /// The sources disclosure's content. The disclosure is omitted when null.
  final Widget? sourcesContent;

  /// Controls the sources disclosure. When null, the answer manages it.
  final bool? sourcesExpanded;

  /// Whether the sources disclosure starts open when uncontrolled.
  final bool defaultSourcesExpanded;

  /// Called when the sources disclosure is asked to open or close.
  final ValueChanged<bool>? onSourcesExpandedChanged;

  /// The sources disclosure's trigger text and accessible label.
  final String sourcesLabel;

  /// Accessible label of the whole answer.
  final String semanticLabel;

  /// Style of the card around the answer.
  final CardStyler surfaceStyle;

  /// Style of the sources disclosure.
  final DisclosureStyler sourcesStyle;

  /// Style of the copy action.
  final IconButtonStyler copyStyle;

  /// Style of the retry action.
  final IconButtonStyler retryStyle;

  /// Style of the answer's own slots.
  final PlaygroundAnswerStyler style;

  /// A resolved spec that is used instead of resolving [style].
  final PlaygroundAnswerSpec? styleSpec;

  @override
  State<PlaygroundAnswer> createState() => _PlaygroundAnswerState();
}

class _PlaygroundAnswerState extends State<PlaygroundAnswer> {
  late final PlaygroundDisclosureEngine _disclosure;

  bool get _sourcesExpanded => _disclosure.value;

  @override
  void initState() {
    super.initState();
    _disclosure = PlaygroundDisclosureEngine(
      value: widget.sourcesExpanded,
      defaultValue: widget.defaultSourcesExpanded,
    );
  }

  @override
  void didUpdateWidget(PlaygroundAnswer oldWidget) {
    super.didUpdateWidget(oldWidget);
    _disclosure.reconcile(widget.sourcesExpanded);
    final beganStreaming =
        !oldWidget.status.isStreaming && widget.status.isStreaming;
    final newStreamingIdentity =
        oldWidget.streamId != widget.streamId && widget.status.isStreaming;
    if (beganStreaming || newStreamingIdentity) _requestSources(false);
  }

  void _requestSources(bool next) {
    if (_disclosure.request(next)) setState(() {});
    widget.onSourcesExpandedChanged?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    final revealActions =
        !widget.status.isStreaming &&
        (widget.showActions ?? widget.status.showsActions);
    return RemixStyleSpecBuilder<PlaygroundAnswerSpec>(
      style: widget.style,
      styleSpec: widget.styleSpec,
      builder: (context, spec) => Semantics(
        container: true,
        explicitChildNodes: true,
        label: widget.semanticLabel,
        child: RemixCard(
          style: widget.surfaceStyle,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Semantics(
                liveRegion: widget.status.isStreaming,
                child: Box(styleSpec: spec.body, child: widget.child),
              ),
              if (widget.sourcesContent != null)
                RemixDisclosure(
                  expanded: _sourcesExpanded,
                  onExpandedChanged: _requestSources,
                  semanticLabel: widget.sourcesLabel,
                  style: widget.sourcesStyle,
                  triggerBuilder: (context, state, trigger) => Row(
                    // The indicator follows its label, as a link-like line,
                    // rather than sitting at the far edge of the row.
                    mainAxisSize: MainAxisSize.min,
                    spacing: 8,
                    children: [
                      Flexible(child: trigger!),
                      PlaygroundDisclosureIndicator(
                        styleSpec: spec.indicator,
                        expanded: state.isExpanded,
                        builder: widget.sourcesIndicatorBuilder,
                      ),
                    ],
                  ),
                  trigger: StyledText(
                    widget.sourcesLabel,
                    styleSpec: spec.sourcesLabel,
                  ),
                  content: widget.sourcesContent!,
                ),
              if (revealActions)
                RowBox(
                  styleSpec: spec.actions,
                  children: [
                    if (widget.onCopy != null)
                      RemixIconButton(
                        icon: null,
                        iconBuilder:
                            widget.copyIconBuilder ??
                            (context, iconSpec, icon) =>
                                PlaygroundFunctionalGlyph(
                                  kind: .copy,
                                  spec: iconSpec,
                                ),
                        semanticLabel: widget.copyLabel,
                        onPressed: widget.onCopy,
                        style: widget.copyStyle,
                      ),
                    if (widget.onRetry != null)
                      RemixIconButton(
                        icon: null,
                        iconBuilder:
                            widget.retryIconBuilder ??
                            (context, iconSpec, icon) =>
                                PlaygroundFunctionalGlyph(
                                  kind: .retry,
                                  spec: iconSpec,
                                ),
                        semanticLabel: widget.retryLabel,
                        onPressed: widget.onRetry,
                        style: widget.retryStyle,
                      ),
                    if (widget.status == PlaygroundAnswerStatus.complete &&
                        widget.feedback != null)
                      // A status message such as "Copied" is announced
                      // without moving focus (WCAG 2.2 SC 4.1.3).
                      Semantics(
                        container: true,
                        liveRegion: true,
                        child: Box(
                          styleSpec: spec.feedback,
                          child: widget.feedback,
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

@MixableSpec(target: PlaygroundAnswer.new)
@immutable
final class PlaygroundAnswerSpec with _$PlaygroundAnswerSpec {
  /// Wraps the answer body.
  @override
  final StyleSpec<BoxSpec> body;

  /// Lays out the copy and retry actions and the feedback.
  @override
  final StyleSpec<FlexBoxSpec> actions;

  /// Wraps the feedback message.
  @override
  final StyleSpec<BoxSpec> feedback;

  /// The sources trigger text.
  @override
  final StyleSpec<TextSpec> sourcesLabel;

  /// The sources disclosure chevron.
  @override
  final StyleSpec<IconSpec> indicator;

  const PlaygroundAnswerSpec({
    StyleSpec<BoxSpec>? body,
    StyleSpec<FlexBoxSpec>? actions,
    StyleSpec<BoxSpec>? feedback,
    StyleSpec<TextSpec>? sourcesLabel,
    StyleSpec<IconSpec>? indicator,
  }) : body = body ?? const StyleSpec(spec: BoxSpec()),
       actions = actions ?? const StyleSpec(spec: FlexBoxSpec()),
       feedback = feedback ?? const StyleSpec(spec: BoxSpec()),
       sourcesLabel = sourcesLabel ?? const StyleSpec(spec: TextSpec()),
       indicator = indicator ?? const StyleSpec(spec: IconSpec());
}
