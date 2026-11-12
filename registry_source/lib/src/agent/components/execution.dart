import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../models/statuses.dart';
import '../support/disclosure.dart';
import '../support/functional_glyph.dart';
import '../support/live_edge.dart';

part 'execution.g.dart';

/// Returns the status text shown and announced for an execution.
typedef AgentExecutionStatusLabelBuilder =
    String Function(AgentExecutionStatus status);

/// Builds the status icon in place of the default glyph.
typedef AgentExecutionStatusBuilder =
    Widget Function(BuildContext context, AgentExecutionStatus status);

/// Builds the disclosure indicator in place of the default chevron.
typedef AgentExecutionIndicatorBuilder =
    Widget Function(BuildContext context, bool expanded);

/// Toggleable tool execution output with lifecycle-driven open requests.
class AgentExecution extends StatefulWidget {
  const AgentExecution({
    super.key,
    required this.tool,
    required this.title,
    required this.child,
    this.status = AgentExecutionStatus.running,
    this.meta,
    this.icon,
    this.onCopy,
    this.onRetry,
    this.copyIconBuilder,
    this.retryIconBuilder,
    this.indicatorBuilder,
    this.statusBuilder,
    this.statusLabelBuilder,
    this.copyLabel = 'Copy output',
    this.retryLabel = 'Retry execution',
    this.outputLabel = 'Tool output',
    this.showActions = true,
    this.collapseOnComplete = true,
    this.expanded,
    this.defaultExpanded = true,
    this.onExpandedChanged,
    this.semanticLabel = 'Tool execution',
    this.surfaceStyle = const CardStyler.create(),
    this.disclosureStyle = const DisclosureStyler.create(),
    this.copyStyle = const IconButtonStyler.create(),
    this.retryStyle = const IconButtonStyler.create(),
    this.style = const AgentExecutionStyler.create(),
    this.styleSpec,
  });

  /// The tool's identifier, such as `terminal.run`.
  final String tool;

  /// A human-readable name for this call.
  final String title;

  /// The tool's output, rendered by the host.
  final Widget child;

  /// Where the execution is in its lifecycle.
  final AgentExecutionStatus status;

  /// Compact trailing text in the header, such as elapsed time.
  final String? meta;

  /// Replaces the default tool icon.
  final Widget? icon;

  /// Called by the copy action, which is shown only when this is set.
  final VoidCallback? onCopy;

  /// Called by the retry action, which is shown only when this is set.
  final VoidCallback? onRetry;

  /// Replaces the copy action's default icon.
  final RemixIconButtonIconBuilder? copyIconBuilder;

  /// Replaces the retry action's default icon.
  final RemixIconButtonIconBuilder? retryIconBuilder;

  /// Replaces the disclosure's default chevron.
  final AgentExecutionIndicatorBuilder? indicatorBuilder;

  /// Replaces the default status icon.
  final AgentExecutionStatusBuilder? statusBuilder;

  /// Replaces the default status text.
  final AgentExecutionStatusLabelBuilder? statusLabelBuilder;

  /// Accessible label of the copy action.
  final String copyLabel;

  /// Accessible label of the retry action.
  final String retryLabel;

  /// Accessible label of the output region.
  final String outputLabel;

  /// Whether the copy and retry actions appear once the execution settles.
  final bool showActions;

  /// Whether the output closes itself when the tool finishes.
  ///
  /// A failed execution stays open.
  final bool collapseOnComplete;

  /// Controls the disclosure. When null, the execution manages it.
  final bool? expanded;

  /// Whether the disclosure starts open when uncontrolled.
  final bool defaultExpanded;

  /// Called when the disclosure is asked to open or close.
  final ValueChanged<bool>? onExpandedChanged;

  /// Accessible label of the whole execution.
  final String semanticLabel;

  /// Style of the card around the execution.
  final CardStyler surfaceStyle;

  /// Style of the disclosure.
  final DisclosureStyler disclosureStyle;

  /// Style of the copy action.
  final IconButtonStyler copyStyle;

  /// Style of the retry action.
  final IconButtonStyler retryStyle;

  /// Style of the execution's own slots.
  final AgentExecutionStyler style;

  /// A resolved spec that is used instead of resolving [style].
  final AgentExecutionSpec? styleSpec;

  @override
  State<AgentExecution> createState() => _AgentExecutionState();
}

class _AgentExecutionState extends State<AgentExecution> {
  late final AgentDisclosureEngine _disclosure;

  bool get _expanded => _disclosure.value;

  @override
  void initState() {
    super.initState();
    _disclosure = AgentDisclosureEngine(
      value: widget.expanded,
      defaultValue: widget.defaultExpanded,
    );
  }

  @override
  void didUpdateWidget(AgentExecution oldWidget) {
    super.didUpdateWidget(oldWidget);
    _disclosure.reconcile(widget.expanded);
    if (!oldWidget.status.isWorking && widget.status.isWorking) {
      _request(true);
    } else if (oldWidget.status.isWorking &&
        !widget.status.isWorking &&
        widget.collapseOnComplete &&
        // A failure stays open: its output is what the reader needs next.
        widget.status != AgentExecutionStatus.error) {
      _request(false);
    }
  }

  void _request(bool next) {
    if (_disclosure.request(next)) setState(() {});
    widget.onExpandedChanged?.call(next);
  }

  String get _statusLabel =>
      widget.statusLabelBuilder?.call(widget.status) ??
      switch (widget.status) {
        AgentExecutionStatus.running => 'Running',
        AgentExecutionStatus.success => 'Completed',
        AgentExecutionStatus.error => 'Failed',
        AgentExecutionStatus.cancelled => 'Cancelled',
      };

  StyleSpec<BoxSpec> _statusContainer(AgentExecutionSpec spec) =>
      switch (widget.status) {
        AgentExecutionStatus.running => spec.runningStatus,
        AgentExecutionStatus.success => spec.successStatus,
        AgentExecutionStatus.error => spec.errorStatus,
        AgentExecutionStatus.cancelled => spec.cancelledStatus,
      };

  AgentFunctionalGlyphKind get _statusGlyph => switch (widget.status) {
    AgentExecutionStatus.running => .loading,
    AgentExecutionStatus.success => .completedCircle,
    AgentExecutionStatus.error => .errorCircle,
    AgentExecutionStatus.cancelled => .cancelledCircle,
  };

  Widget _toolIcon(AgentExecutionSpec spec) {
    final icon = widget.icon;
    if (icon != null) return icon;
    return StyleSpecBuilder<IconSpec>(
      styleSpec: spec.toolIcon,
      builder: (context, iconSpec) =>
          AgentFunctionalGlyph(kind: .tool, spec: iconSpec),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RemixStyleSpecBuilder<AgentExecutionSpec>(
      style: widget.style,
      styleSpec: widget.styleSpec,
      builder: (context, spec) => Semantics(
        container: true,
        explicitChildNodes: true,
        label: widget.semanticLabel,
        value: '${widget.tool}, $_statusLabel',
        child: RemixCard(
          style: widget.surfaceStyle,
          child: RemixDisclosure(
            expanded: _expanded,
            onExpandedChanged: _request,
            semanticLabel: widget.title,
            style: widget.disclosureStyle,
            triggerBuilder: (context, state, trigger) => Row(
              spacing: 8,
              children: [
                Expanded(child: trigger!),
                AgentDisclosureIndicator(
                  styleSpec: spec.indicator,
                  expanded: state.isExpanded,
                  builder: widget.indicatorBuilder,
                ),
              ],
            ),
            trigger: RowBox(
              styleSpec: spec.header,
              children: [
                _toolIcon(spec),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 2,
                    children: [
                      StyledText(widget.title, styleSpec: spec.title),
                      StyledText(widget.tool, styleSpec: spec.tool),
                    ],
                  ),
                ),
                if (widget.meta != null)
                  StyledText(widget.meta!, styleSpec: spec.meta),
                Box(
                  styleSpec: _statusContainer(spec),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 6,
                    children: [
                      widget.statusBuilder?.call(context, widget.status) ??
                          StyleSpecBuilder<IconSpec>(
                            styleSpec: spec.statusIcon,
                            builder: (context, iconSpec) =>
                                AgentFunctionalGlyph(
                                  kind: _statusGlyph,
                                  spec: iconSpec,
                                ),
                          ),
                      StyledText(_statusLabel, styleSpec: spec.status),
                    ],
                  ),
                ),
              ],
            ),
            content: Box(
              styleSpec: spec.output,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Deliberately not an AgentTranscript. That installs
                  // Arrow/Page/Home/End shortcuts and its own Semantics
                  // container, and an execution card is normally nested inside
                  // a host transcript: the inner list shrink-wraps to a zero
                  // scroll extent but its action still consumes those intents,
                  // so focus landing here stopped the outer transcript from
                  // scrolling, and its `busy` value announced the status a
                  // second time. This is the primitive plan and activity use.
                  Semantics(
                    label: widget.outputLabel,
                    // A bounded viewport keeps long output scrolling inside
                    // its own box, following the end while the tool runs.
                    child: Box(
                      styleSpec: spec.viewport,
                      child: AgentLiveEdgeScrollView(
                        followOutput: widget.status.isWorking,
                        child: widget.child,
                      ),
                    ),
                  ),
                  if (widget.showActions && widget.status.isSettled)
                    RowBox(
                      styleSpec: spec.actions,
                      children: [
                        if (widget.onCopy != null)
                          RemixIconButton(
                            icon: null,
                            iconBuilder:
                                widget.copyIconBuilder ??
                                (context, iconSpec, icon) =>
                                    AgentFunctionalGlyph(
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
                                    AgentFunctionalGlyph(
                                      kind: .retry,
                                      spec: iconSpec,
                                    ),
                            semanticLabel: widget.retryLabel,
                            onPressed: widget.onRetry,
                            style: widget.retryStyle,
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

@MixableSpec(target: AgentExecution.new)
@immutable
final class AgentExecutionSpec with _$AgentExecutionSpec {
  /// Lays out the trigger: icon, title, tool, meta and status.
  @override
  final StyleSpec<FlexBoxSpec> header;

  /// Wraps the disclosure's content: the output and the actions.
  @override
  final StyleSpec<BoxSpec> output;

  /// Bounds the scrolling output inside [output], for example with a
  /// maximum height.
  @override
  final StyleSpec<BoxSpec> viewport;

  /// Lays out the copy and retry actions.
  @override
  final StyleSpec<FlexBoxSpec> actions;

  /// The tool identifier text.
  @override
  final StyleSpec<TextSpec> tool;

  /// The title text.
  @override
  final StyleSpec<TextSpec> title;

  /// The trailing meta text.
  @override
  final StyleSpec<TextSpec> meta;

  /// The status text.
  @override
  final StyleSpec<TextSpec> status;

  /// The default tool icon.
  @override
  final StyleSpec<IconSpec> toolIcon;

  /// The default status icon.
  @override
  final StyleSpec<IconSpec> statusIcon;

  /// The disclosure chevron.
  @override
  final StyleSpec<IconSpec> indicator;

  /// The status badge while running.
  @override
  final StyleSpec<BoxSpec> runningStatus;

  /// The status badge after success.
  @override
  final StyleSpec<BoxSpec> successStatus;

  /// The status badge after an error.
  @override
  final StyleSpec<BoxSpec> errorStatus;

  /// The status badge after cancellation.
  @override
  final StyleSpec<BoxSpec> cancelledStatus;

  const AgentExecutionSpec({
    StyleSpec<FlexBoxSpec>? header,
    StyleSpec<BoxSpec>? output,
    StyleSpec<BoxSpec>? viewport,
    StyleSpec<FlexBoxSpec>? actions,
    StyleSpec<TextSpec>? tool,
    StyleSpec<TextSpec>? title,
    StyleSpec<TextSpec>? meta,
    StyleSpec<TextSpec>? status,
    StyleSpec<IconSpec>? toolIcon,
    StyleSpec<IconSpec>? statusIcon,
    StyleSpec<IconSpec>? indicator,
    StyleSpec<BoxSpec>? runningStatus,
    StyleSpec<BoxSpec>? successStatus,
    StyleSpec<BoxSpec>? errorStatus,
    StyleSpec<BoxSpec>? cancelledStatus,
  }) : header = header ?? const StyleSpec(spec: FlexBoxSpec()),
       output = output ?? const StyleSpec(spec: BoxSpec()),
       viewport = viewport ?? const StyleSpec(spec: BoxSpec()),
       actions = actions ?? const StyleSpec(spec: FlexBoxSpec()),
       tool = tool ?? const StyleSpec(spec: TextSpec()),
       title = title ?? const StyleSpec(spec: TextSpec()),
       meta = meta ?? const StyleSpec(spec: TextSpec()),
       status = status ?? const StyleSpec(spec: TextSpec()),
       toolIcon = toolIcon ?? const StyleSpec(spec: IconSpec()),
       statusIcon = statusIcon ?? const StyleSpec(spec: IconSpec()),
       indicator = indicator ?? const StyleSpec(spec: IconSpec()),
       runningStatus = runningStatus ?? const StyleSpec(spec: BoxSpec()),
       successStatus = successStatus ?? const StyleSpec(spec: BoxSpec()),
       errorStatus = errorStatus ?? const StyleSpec(spec: BoxSpec()),
       cancelledStatus = cancelledStatus ?? const StyleSpec(spec: BoxSpec());
}
