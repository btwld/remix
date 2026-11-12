import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:naked_ui/naked_ui.dart';

import '../../components/button/button.dart';
import '../../components/data_list/data_list.dart';
import '../../components/disclosure/disclosure.dart';
import '../../utilities/remix_style.dart';
import '../behavior/approval_guard.dart';
import '../behavior/disclosure.dart';
import '../behavior/live_edge.dart';
import '../models/message_part.dart';
import '../models/statuses.dart';
import '../models/tool_call.dart';
import 'glyphs.dart';
import 'internal.dart';

part 'tool_call.g.dart';

/// Renders one tool's calls as a host widget, from the call's input, output,
/// result and status.
typedef AgentToolRenderer =
    Widget Function(BuildContext context, AgentToolCallPart call);

/// Registers a renderer per tool name for the [AgentToolCall]s below it.
///
/// An [AgentToolCall] whose [AgentToolCallPart.name] has a renderer shows the
/// renderer's widget instead of the standard row, in every status except
/// [AgentToolCallStatus.awaitingApproval]: the approval card stays standard,
/// so every request gets the same guarded decision. Tools without a renderer
/// use the standard row.
///
/// ```dart
/// AgentToolRenderers(
///   renderers: {
///     'coverage': (context, call) => CoverageChart(call.result),
///   },
///   child: conversation,
/// )
/// ```
class AgentToolRenderers extends InheritedWidget {
  /// Registers [renderers] for [child].
  const AgentToolRenderers({
    super.key,
    required this.renderers,
    required super.child,
  });

  /// The renderers by tool name.
  final Map<String, AgentToolRenderer> renderers;

  /// The renderer registered for [name] in the nearest [AgentToolRenderers]
  /// above [context], if any.
  static AgentToolRenderer? maybeOf(BuildContext context, String name) =>
      context
          .dependOnInheritedWidgetOfExactType<AgentToolRenderers>()
          ?.renderers[name];

  @override
  bool updateShouldNotify(AgentToolRenderers oldWidget) =>
      !mapEquals(renderers, oldWidget.renderers);
}

/// One tool call, changing in place through its lifecycle.
///
/// Most of the time it is a quiet row: the tool's icon, the call's summary,
/// its meta (the detail, the duration and the recorded decision, such as
/// "Allowed once") with the tool id, then the status glyph and word. A call
/// with output opens an output well under the row, which follows the newest
/// line while the tool runs. The well opens while the call works, collapses
/// when it succeeds and stays open when it fails, under [policy]; a reader's
/// toggle wins for the rest of the run.
/// Output taller than [AgentToolCallSpec.outputMaxHeight] offers "Show all"
/// and "Show less" independently of opening or closing the well.
///
/// While the call is [AgentToolCallStatus.awaitingApproval], it shows the
/// approval card instead: a question, the tool id, the description, the
/// input as a data list, and a footer with "Always allow" for this tool on
/// the leading side and Deny and Allow once on the trailing side, primary
/// last. The card takes one decision per request and sends it to
/// [onDecision]; once the host moves the call on, focus returns to the row.
///
/// A renderer registered in [AgentToolRenderers] for the call's tool
/// replaces the row. Style a status with [AgentToolCallStylerStatus.onStatus].
class AgentToolCall extends StatefulWidget {
  /// Creates the row, or the approval card, of [call].
  const AgentToolCall({
    super.key,
    required this.call,
    this.onDecision,
    this.offerAlwaysAllow = true,
    this.icon,
    this.approvalTitle,
    this.policy = const AgentDisclosurePolicy(),
    this.expanded,
    this.defaultExpanded,
    this.onExpandedChanged,
    this.statusLabelBuilder,
    this.decisionLabelBuilder,
    this.allowOnceLabel = 'Allow once',
    this.alwaysAllowLabel = 'Always allow',
    this.denyLabel = 'Deny',
    this.outputLabel = 'Tool output',
    this.showAllLabel = 'Show all',
    this.showLessLabel = 'Show less',
    this.semanticLabel = 'Tool call',
    this.glyphBuilder,
    this.disclosureStyle = const DisclosureStyler.create(),
    this.inputStyle = const DataListStyler.create(),
    this.allowOnceStyle = const ButtonStyler.create(),
    this.alwaysAllowStyle = const ButtonStyler.create(),
    this.denyStyle = const ButtonStyler.create(),
    this.style = const AgentToolCallStyler.create(),
    this.styleSpec,
  });

  /// The call to show.
  final AgentToolCallPart call;

  /// Receives the reader's decision on an approval request, once per
  /// request. Without it, the card's actions are disabled.
  final ValueChanged<AgentApprovalDecision>? onDecision;

  /// Whether the card offers to always allow this tool.
  final bool offerAlwaysAllow;

  /// The tool's icon; defaults to [AgentGlyphs.toolIconBuilder], then
  /// [AgentGlyph.tool].
  final Widget? icon;

  /// The card's question; defaults to the call's summary as a question.
  final String? approvalTitle;

  /// When the output well opens and closes on its own.
  final AgentDisclosurePolicy policy;

  /// Whether the output well is open. Null lets the widget own the state.
  final bool? expanded;

  /// Whether the output well starts open when uncontrolled; defaults to
  /// open while the call works or after it failed.
  final bool? defaultExpanded;

  /// Receives every request to open or close the output well.
  final ValueChanged<bool>? onExpandedChanged;

  /// Names a status; defaults to [defaultStatusLabel].
  final String Function(AgentToolCallStatus status)? statusLabelBuilder;

  /// Names a recorded decision; defaults to [defaultDecisionLabel].
  final String Function(AgentApprovalDecision decision)? decisionLabelBuilder;

  /// The label of the card's primary action.
  final String allowOnceLabel;

  /// The label of the card's scoped action, followed by the tool id.
  final String alwaysAllowLabel;

  /// The label of the card's refusal.
  final String denyLabel;

  /// The accessible name of the output well.
  final String outputLabel;

  /// The action that removes the output well's height limit.
  final String showAllLabel;

  /// The action that restores the output well's height limit.
  final String showLessLabel;

  /// The call's accessible name.
  final String semanticLabel;

  /// Draws the glyphs; defaults to the nearest [AgentGlyphs].
  final AgentGlyphBuilder? glyphBuilder;

  /// The style of the disclosure behind the row and the output well.
  final DisclosureStyler disclosureStyle;

  /// The style of the card's input list.
  final DataListStyler inputStyle;

  /// The style of Allow once.
  final ButtonStyler allowOnceStyle;

  /// The style of Always allow.
  final ButtonStyler alwaysAllowStyle;

  /// The style of Deny.
  final ButtonStyler denyStyle;

  /// The style of the row, the well and the card.
  final AgentToolCallStyler style;

  /// A resolved spec that bypasses [style].
  final AgentToolCallSpec? styleSpec;

  /// The default name of a status.
  static String defaultStatusLabel(AgentToolCallStatus status) =>
      switch (status) {
        AgentToolCallStatus.inputStreaming => 'Preparing',
        AgentToolCallStatus.awaitingApproval => 'Needs approval',
        AgentToolCallStatus.denied => 'Denied',
        AgentToolCallStatus.running => 'Running',
        AgentToolCallStatus.succeeded => 'Completed',
        AgentToolCallStatus.failed => 'Failed',
        AgentToolCallStatus.cancelled => 'Cancelled',
      };

  /// The default name of a recorded decision.
  static String defaultDecisionLabel(AgentApprovalDecision decision) =>
      switch (decision) {
        AgentApprovalDecision.allowOnce => 'Allowed once',
        AgentApprovalDecision.alwaysAllow => 'Always allowed',
        AgentApprovalDecision.deny => 'Denied',
      };

  @override
  State<AgentToolCall> createState() => _AgentToolCallState();
}

final _toolCallLayout = AgentToolCallStyler(
  outputToggle: FlexBoxStyler().mainAxisSize(MainAxisSize.min),
  status: FlexBoxStyler().mainAxisSize(MainAxisSize.min),
  cardContent: FlexBoxStyler()
      .mainAxisSize(MainAxisSize.min)
      .crossAxisAlignment(CrossAxisAlignment.stretch),
  cardHeading: FlexBoxStyler()
      .mainAxisSize(MainAxisSize.min)
      .crossAxisAlignment(CrossAxisAlignment.stretch),
);

class _AgentToolCallState extends State<AgentToolCall>
    with AutomaticKeepAliveClientMixin {
  // Created on first read: the keep-alive mixin asks for it during initState.
  late final AgentApprovalGuard _guard = AgentApprovalGuard(
    id: widget.call.id,
    status: widget.call.status,
    recorded: widget.call.decision,
  );
  late final AgentDisclosureController _disclosure;
  late final AgentLiveEdgeController _outputEdge;
  final FocusNode _focus = FocusNode(debugLabel: 'AgentToolCall');
  final FocusNode _rowFocus = FocusNode(debugLabel: 'AgentToolCall row');
  final WidgetStatesController _rowStates = WidgetStatesController();
  bool _retainDisclosure = false;
  bool _showAllOutput = false;
  bool _outputOverflows = false;

  /// Whether focus was inside the card when the reader decided, so it moves
  /// to the row that replaces the card.
  bool _returnFocus = false;

  AgentToolCallPart get _call => widget.call;

  bool get _expandable => _call.output != null || _call.error != null;

  @override
  void initState() {
    super.initState();
    final call = _call;
    final phase = call.status.phase;
    _disclosure = AgentDisclosureController(
      phase: phase,
      expanded: widget.expanded,
      defaultExpanded: _defaultExpanded,
      policy: widget.policy,
      onExpandedChanged: widget.onExpandedChanged,
    )..addListener(_changed);
    _outputEdge = AgentLiveEdgeController(enabled: call.status.isWorking);
  }

  @override
  void didUpdateWidget(AgentToolCall oldWidget) {
    super.didUpdateWidget(oldWidget);
    final call = _call;
    if (oldWidget.call.id != call.id) {
      _showAllOutput = false;
      _outputOverflows = false;
    }
    _guard.update(id: call.id, status: call.status, recorded: call.decision);
    _disclosure
      ..policy = widget.policy
      ..onExpandedChanged = widget.onExpandedChanged
      ..updateExpanded(widget.expanded)
      ..updatePhase(call.status.phase);
    _updateDisclosureKeepAlive();
    _outputEdge.enabled = call.status.isWorking;
    if (oldWidget.call.status.needsDecision && !call.status.needsDecision) {
      if (_returnFocus) {
        _returnFocus = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          (_expandable ? _rowFocus : _focus).requestFocus();
        });
      }
    }
  }

  void _changed() {
    if (mounted) setState(() {});
  }

  bool get _defaultExpanded =>
      widget.defaultExpanded ??
      switch (_call.status.phase) {
        AgentWorkPhase.working => widget.policy.openWhileWorking,
        AgentWorkPhase.failed => widget.policy.keepOpenOnFailure,
        AgentWorkPhase.settled => !widget.policy.collapseWhenSettled,
        AgentWorkPhase.waiting => false,
      };

  void _toggle(bool expanded) {
    _disclosure.toggle(expanded);
    _updateDisclosureKeepAlive();
  }

  void _updateDisclosureKeepAlive() {
    _retainDisclosure =
        _disclosure.readerToggled &&
        widget.policy.respectReaderToggle &&
        (!_call.status.phase.isFinished ||
            _disclosure.expanded != _defaultExpanded);
    updateKeepAlive();
  }

  @override
  bool get wantKeepAlive =>
      _retainDisclosure ||
      (_guard.decision != null && _call.status.needsDecision);

  void _decide(AgentApprovalDecision decision) {
    final onDecision = widget.onDecision;
    if (onDecision == null || !_guard.decide(decision)) return;
    _returnFocus = _focus.hasFocus;
    setState(() {});
    updateKeepAlive();
    onDecision(decision);
  }

  String _statusLabel(AgentToolCallStatus status) =>
      (widget.statusLabelBuilder ?? AgentToolCall.defaultStatusLabel)(status);

  Widget? _glyph(AgentGlyph glyph, StyleSpec<IconSpec> spec) =>
      agentGlyph(context, widget.glyphBuilder, glyph, spec);

  Widget _status(AgentToolCallSpec spec) {
    final status = _call.status;
    final glyph = _glyph(switch (status) {
      AgentToolCallStatus.inputStreaming => AgentGlyph.toolPreparing,
      AgentToolCallStatus.awaitingApproval => AgentGlyph.toolWaiting,
      AgentToolCallStatus.denied => AgentGlyph.toolDenied,
      AgentToolCallStatus.running => AgentGlyph.toolRunning,
      AgentToolCallStatus.succeeded => AgentGlyph.toolSucceeded,
      AgentToolCallStatus.failed => AgentGlyph.toolFailed,
      AgentToolCallStatus.cancelled => AgentGlyph.toolCancelled,
    }, spec.statusIcon);

    return RowBox(
      styleSpec: spec.status,
      children: [
        ?glyph,
        StyledText(_statusLabel(status), styleSpec: spec.statusLabel),
      ],
    );
  }

  Widget _rowContent(AgentToolCallSpec spec, {required bool? expanded}) {
    final call = _call;
    final decision = call.decision;
    final duration = call.duration;
    final summary = call.summary;
    final meta = [
      ?call.detail,
      if (duration != null) agentFormatDuration(duration),
      if (decision != null)
        (widget.decisionLabelBuilder ?? AgentToolCall.defaultDecisionLabel)(
          decision,
        ),
    ].join(' · ');
    // Without a summary the tool id leads the row and is not repeated.
    final title = summary ?? call.name;
    final toolId = summary == null ? null : call.name;
    final trailing = [if (meta.isNotEmpty) meta, ?toolId].join(' · ');
    final icon = widget.icon;
    final leading = icon == null
        ? agentToolIcon(context, call.name, spec.icon) ??
              _glyph(AgentGlyph.tool, spec.icon)
        : RemixDefaultContentStyle(icon: spec.icon, child: icon);
    final indicator = expanded == null
        ? null
        : _glyph(
            expanded ? AgentGlyph.disclosureOpen : AgentGlyph.disclosureClosed,
            spec.indicator,
          );
    final gap = spec.row.spec.flex?.spec.spacing ?? 0;

    return RowBox(
      styleSpec: spec.row,
      children: [
        ?leading,
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: title, style: spec.summary.spec.style),
                if (trailing.isNotEmpty) ...[
                  // The gap matches the row's own spacing.
                  WidgetSpan(child: SizedBox(width: gap)),
                  TextSpan(
                    style: spec.meta.spec.style,
                    children: [
                      if (meta.isNotEmpty) TextSpan(text: meta),
                      if (meta.isNotEmpty && toolId != null)
                        const TextSpan(text: ' · '),
                      if (toolId != null)
                        TextSpan(text: toolId, style: spec.toolId.spec.style),
                    ],
                  ),
                ],
              ],
            ),
            semanticsLabel: trailing.isEmpty ? title : '$title, $trailing',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        _status(spec),
        ?indicator,
      ],
    );
  }

  Widget _output(AgentToolCallSpec spec) {
    final output = _call.output;
    final error = _call.error;
    final maxHeight = spec.outputMaxHeight;

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: widget.outputLabel,
      child: Box(
        styleSpec: spec.output,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: _showAllOutput
                    ? double.infinity
                    : maxHeight ?? double.infinity,
              ),
              child: AgentLiveEdge(
                controller: _outputEdge,
                builder: (context, scrollController, physics) =>
                    SingleChildScrollView(
                      controller: scrollController,
                      physics: physics,
                      child: AgentOverflowClip(
                        key: ValueKey(_call.id),
                        maxHeight: maxHeight,
                        clip: false,
                        onOverflowChanged: _handleOutputOverflow,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (output != null && output.isNotEmpty)
                              Box(
                                styleSpec: spec.outputContent,
                                child: StyledText(
                                  output,
                                  styleSpec: spec.outputText,
                                ),
                              ),
                            if (error != null && error.isNotEmpty)
                              Box(
                                styleSpec: spec.error,
                                child: StyledText(
                                  error,
                                  styleSpec: spec.errorText,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
              ),
            ),
            if (_outputOverflows && maxHeight != null)
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: _outputToggle(),
              ),
          ],
        ),
      ),
    );
  }

  void _handleOutputOverflow(bool overflows) {
    if (mounted && overflows != _outputOverflows) {
      setState(() => _outputOverflows = overflows);
    }
  }

  Widget _outputToggle() {
    final label = _showAllOutput ? widget.showLessLabel : widget.showAllLabel;
    return NakedButton(
      key: const ValueKey('agent-tool-call-output-toggle'),
      semanticLabel: label,
      onPressed: () => setState(() => _showAllOutput = !_showAllOutput),
      builder: (context, _, _) => RemixStyleSpecBuilder<AgentToolCallSpec>(
        style: _toolCallLayout.merge(widget.style),
        styleSpec: widget.styleSpec,
        controller: NakedButtonState.controllerOf(context),
        builder: (context, spec) => ExcludeSemantics(
          child: RowBox(
            styleSpec: spec.outputToggle,
            children: [
              Flexible(
                child: StyledText(label, styleSpec: spec.outputToggleLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _styledRow({bool? expanded}) =>
      RemixStyleSpecBuilder<AgentToolCallSpec>(
        style: _toolCallLayout.merge(widget.style),
        styleSpec: widget.styleSpec,
        controller: _rowStates,
        builder: (context, spec) => _rowContent(spec, expanded: expanded),
      );

  Widget _row(AgentToolCallSpec spec) {
    if (!_expandable) {
      return MouseRegion(
        onEnter: (_) => _rowStates.update(WidgetState.hovered, true),
        onExit: (_) => _rowStates.update(WidgetState.hovered, false),
        child: _styledRow(),
      );
    }

    return RemixDisclosure(
      expanded: _disclosure.expanded,
      onExpandedChanged: _toggle,
      focusNode: _rowFocus,
      onHoverChange: (value) => _rowStates.update(WidgetState.hovered, value),
      onPressChange: (value) => _rowStates.update(WidgetState.pressed, value),
      onFocusChange: (value) => _rowStates.update(WidgetState.focused, value),
      style: widget.disclosureStyle,
      trigger: const SizedBox.shrink(),
      triggerBuilder: (context, state, _) =>
          _styledRow(expanded: state.isExpanded),
      content: _output(spec),
    );
  }

  Widget _card(AgentToolCallSpec spec) {
    final call = _call;
    final summary = call.summary;
    final title =
        widget.approvalTitle ??
        (summary == null ? 'Run ${call.name}?' : '$summary?');
    final description = call.description;
    final canDecide = widget.onDecision != null && _guard.canDecide;
    final glyph = _glyph(AgentGlyph.approval, spec.cardGlyph);
    final toolStyle = spec.toolId.spec.style;

    return Box(
      styleSpec: spec.card,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RowBox(
            styleSpec: spec.cardBody,
            children: [
              if (glyph != null) Box(styleSpec: spec.cardIcon, child: glyph),
              Expanded(
                child: ColumnBox(
                  styleSpec: spec.cardContent,
                  children: [
                    ColumnBox(
                      styleSpec: spec.cardHeading,
                      children: [
                        RowBox(
                          styleSpec: spec.cardTitleRow,
                          children: [
                            Expanded(
                              child: StyledText(title, styleSpec: spec.title),
                            ),
                            _status(spec),
                          ],
                        ),
                        StyledText(call.name, styleSpec: spec.toolId),
                      ],
                    ),
                    if (description != null)
                      StyledText(description, styleSpec: spec.description),
                    if (call.input.isNotEmpty)
                      RemixDataList(
                        items: [
                          for (final input in call.input)
                            RemixDataListItem(
                              label: input.label,
                              value: input.value,
                            ),
                        ],
                        style: widget.inputStyle,
                      ),
                  ],
                ),
              ),
            ],
          ),
          RowBox(
            styleSpec: spec.footer,
            children: agentActionRowChildren(
              gap: spec.footer.spec.flex?.spec.spacing ?? 0,
              leading: !widget.offerAlwaysAllow
                  ? null
                  : RemixButton(
                      key: const ValueKey('agent-tool-call-always-allow'),
                      label: '${widget.alwaysAllowLabel} ${call.name}',
                      textBuilder: (context, textSpec, text) => Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: '${widget.alwaysAllowLabel} '),
                            TextSpan(text: call.name, style: toolStyle),
                          ],
                        ),
                        style: textSpec.style,
                      ),
                      enabled: canDecide,
                      onPressed: () =>
                          _decide(AgentApprovalDecision.alwaysAllow),
                      style: widget.alwaysAllowStyle,
                    ),
              trailing: [
                RemixButton(
                  key: const ValueKey('agent-tool-call-deny'),
                  label: widget.denyLabel,
                  enabled: canDecide,
                  onPressed: () => _decide(AgentApprovalDecision.deny),
                  style: widget.denyStyle,
                ),
                RemixButton(
                  key: const ValueKey('agent-tool-call-allow-once'),
                  label: widget.allowOnceLabel,
                  enabled: canDecide,
                  onPressed: () => _decide(AgentApprovalDecision.allowOnce),
                  style: widget.allowOnceStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final call = _call;
    if (!call.status.needsDecision) {
      final renderer = AgentToolRenderers.maybeOf(context, call.name);
      if (renderer != null) return renderer(context, call);
    }

    return AgentValueScope<AgentToolCallStatus>(
      value: call.status,
      child: RemixStyleSpecBuilder<AgentToolCallSpec>(
        style: _toolCallLayout.merge(widget.style),
        styleSpec: widget.styleSpec,
        builder: (context, spec) => Focus(
          focusNode: _focus,
          skipTraversal: true,
          // Only a landing spot for focus after a decision; the controls
          // inside carry the semantics.
          includeSemantics: false,
          child: Semantics(
            container: true,
            explicitChildNodes: true,
            label: widget.semanticLabel,
            child: call.status.needsDecision ? _card(spec) : _row(spec),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _disclosure.dispose();
    _outputEdge.dispose();
    _focus.dispose();
    _rowFocus.dispose();
    _rowStates.dispose();
    super.dispose();
  }
}

final _statusVariants = agentValueVariants<AgentToolCallStatus>(
  'agentToolCall.status',
  AgentToolCallStatus.values,
);

/// Status variants for [AgentToolCallStyler].
extension AgentToolCallStylerStatus on AgentToolCallStyler {
  /// Applies [value] while the call is in [status].
  AgentToolCallStyler onStatus(
    AgentToolCallStatus status,
    AgentToolCallStyler value,
  ) => variant(_statusVariants[status]!, value);
}

/// Resolved visual properties for an [AgentToolCall]: the row, the output
/// well and the approval card.
///
/// Every slot is empty by default; presets supply the look.
// No target: mix_generator 2.2.0-beta.3 emits InvalidType for constructor
// parameters typed with stylers generated in the same build (the nested
// component styles), as CalendarSpec notes.
@MixableSpec()
@immutable
final class AgentToolCallSpec with _$AgentToolCallSpec {
  /// The row: icon, text, status and indicator. Resolves hover, press and
  /// focus variants from the row's interaction state.
  @override
  final StyleSpec<FlexBoxSpec> row;

  /// The tool's icon on the row.
  @override
  final StyleSpec<IconSpec> icon;

  /// The call's summary.
  @override
  final StyleSpec<TextSpec> summary;

  /// The meta after the summary: detail, duration and decision.
  @override
  final StyleSpec<TextSpec> meta;

  /// The tool id, in the meta and on the card.
  @override
  final StyleSpec<TextSpec> toolId;

  /// The status: its glyph and word.
  @override
  final StyleSpec<FlexBoxSpec> status;

  /// The status glyph.
  @override
  final StyleSpec<IconSpec> statusIcon;

  /// The status word.
  @override
  final StyleSpec<TextSpec> statusLabel;

  /// The glyph that shows whether the output well is open.
  @override
  final StyleSpec<IconSpec> indicator;

  /// The output well.
  @override
  final StyleSpec<BoxSpec> output;

  /// The tallest the well's content grows before it scrolls and offers
  /// "Show all". Null leaves the content unbounded.
  @override
  final double? outputMaxHeight;

  /// The "Show all" / "Show less" button below overflowing output.
  @override
  final StyleSpec<FlexBoxSpec> outputToggle;

  /// The output toggle's label.
  @override
  final StyleSpec<TextSpec> outputToggleLabel;

  /// Wraps the output text.
  @override
  final StyleSpec<BoxSpec> outputContent;

  /// The output text.
  @override
  final StyleSpec<TextSpec> outputText;

  /// Wraps the error text, after the output.
  @override
  final StyleSpec<BoxSpec> error;

  /// The error text.
  @override
  final StyleSpec<TextSpec> errorText;

  /// The approval card.
  @override
  final StyleSpec<BoxSpec> card;

  /// The card's body: its icon beside its content.
  @override
  final StyleSpec<FlexBoxSpec> cardBody;

  /// The tile behind the card's icon.
  @override
  final StyleSpec<BoxSpec> cardIcon;

  /// The card's icon.
  @override
  final StyleSpec<IconSpec> cardGlyph;

  /// The card's content: heading, description and input.
  @override
  final StyleSpec<FlexBoxSpec> cardContent;

  /// The card's heading: the question row over the tool id.
  @override
  final StyleSpec<FlexBoxSpec> cardHeading;

  /// The question beside the status.
  @override
  final StyleSpec<FlexBoxSpec> cardTitleRow;

  /// The card's question.
  @override
  final StyleSpec<TextSpec> title;

  /// The card's description.
  @override
  final StyleSpec<TextSpec> description;

  /// The card's footer of actions.
  @override
  final StyleSpec<FlexBoxSpec> footer;

  /// Creates a spec; every slot defaults to empty.
  const AgentToolCallSpec({
    StyleSpec<FlexBoxSpec>? row,
    StyleSpec<IconSpec>? icon,
    StyleSpec<TextSpec>? summary,
    StyleSpec<TextSpec>? meta,
    StyleSpec<TextSpec>? toolId,
    StyleSpec<FlexBoxSpec>? status,
    StyleSpec<IconSpec>? statusIcon,
    StyleSpec<TextSpec>? statusLabel,
    StyleSpec<IconSpec>? indicator,
    StyleSpec<BoxSpec>? output,
    this.outputMaxHeight,
    StyleSpec<FlexBoxSpec>? outputToggle,
    StyleSpec<TextSpec>? outputToggleLabel,
    StyleSpec<BoxSpec>? outputContent,
    StyleSpec<TextSpec>? outputText,
    StyleSpec<BoxSpec>? error,
    StyleSpec<TextSpec>? errorText,
    StyleSpec<BoxSpec>? card,
    StyleSpec<FlexBoxSpec>? cardBody,
    StyleSpec<BoxSpec>? cardIcon,
    StyleSpec<IconSpec>? cardGlyph,
    StyleSpec<FlexBoxSpec>? cardContent,
    StyleSpec<FlexBoxSpec>? cardHeading,
    StyleSpec<FlexBoxSpec>? cardTitleRow,
    StyleSpec<TextSpec>? title,
    StyleSpec<TextSpec>? description,
    StyleSpec<FlexBoxSpec>? footer,
  }) : row = row ?? const StyleSpec(spec: FlexBoxSpec()),
       icon = icon ?? const StyleSpec(spec: IconSpec()),
       summary = summary ?? const StyleSpec(spec: TextSpec()),
       meta = meta ?? const StyleSpec(spec: TextSpec()),
       toolId = toolId ?? const StyleSpec(spec: TextSpec()),
       status = status ?? const StyleSpec(spec: FlexBoxSpec()),
       statusIcon = statusIcon ?? const StyleSpec(spec: IconSpec()),
       statusLabel = statusLabel ?? const StyleSpec(spec: TextSpec()),
       indicator = indicator ?? const StyleSpec(spec: IconSpec()),
       output = output ?? const StyleSpec(spec: BoxSpec()),
       outputToggle = outputToggle ?? const StyleSpec(spec: FlexBoxSpec()),
       outputToggleLabel =
           outputToggleLabel ?? const StyleSpec(spec: TextSpec()),
       outputContent = outputContent ?? const StyleSpec(spec: BoxSpec()),
       outputText = outputText ?? const StyleSpec(spec: TextSpec()),
       error = error ?? const StyleSpec(spec: BoxSpec()),
       errorText = errorText ?? const StyleSpec(spec: TextSpec()),
       card = card ?? const StyleSpec(spec: BoxSpec()),
       cardBody = cardBody ?? const StyleSpec(spec: FlexBoxSpec()),
       cardIcon = cardIcon ?? const StyleSpec(spec: BoxSpec()),
       cardGlyph = cardGlyph ?? const StyleSpec(spec: IconSpec()),
       cardContent = cardContent ?? const StyleSpec(spec: FlexBoxSpec()),
       cardHeading = cardHeading ?? const StyleSpec(spec: FlexBoxSpec()),
       cardTitleRow = cardTitleRow ?? const StyleSpec(spec: FlexBoxSpec()),
       title = title ?? const StyleSpec(spec: TextSpec()),
       description = description ?? const StyleSpec(spec: TextSpec()),
       footer = footer ?? const StyleSpec(spec: FlexBoxSpec());
}
