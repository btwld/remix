import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../models/statuses.dart';
import '../support/disclosure.dart';
import '../support/functional_glyph.dart';

part 'permission.g.dart';

/// Returns the status text shown and announced for a permission.
typedef UiPermissionStatusLabelBuilder =
    String Function(UiPermissionStatus status);

/// Builds the status icon in place of the default glyph.
typedef UiPermissionStatusBuilder =
    Widget Function(BuildContext context, UiPermissionStatus status);

/// Builds the details disclosure indicator in place of the default chevron.
typedef UiPermissionIndicatorBuilder =
    Widget Function(BuildContext context, bool expanded);

/// In-transcript permission request composed from Remix controls.
class UiPermission extends StatefulWidget {
  const UiPermission({
    super.key,
    required this.tool,
    this.requestId,
    this.title = 'Allow this tool to run?',
    this.description,
    this.status = UiPermissionStatus.pending,
    this.parameters = const [],
    this.showParameters = true,
    this.detailsExpanded,
    this.defaultDetailsExpanded = false,
    this.onDetailsExpandedChanged,
    this.onAllowOnce,
    this.onAlwaysAllow,
    this.onDeny,
    this.statusLabelBuilder,
    this.statusBuilder,
    this.indicatorBuilder,
    this.allowOnceLabel = 'Allow once',
    this.alwaysAllowLabel = 'Always allow',
    this.denyLabel = 'Deny',
    this.detailsLabel = 'View details',
    this.semanticLabel = 'Tool permission',
    this.parameterOrientation = Axis.horizontal,
    this.surfaceStyle = const CardStyler.create(),
    this.detailsStyle = const DisclosureStyler.create(),
    this.parametersStyle = const DataListStyler.create(),
    this.allowOnceStyle = const ButtonStyler.create(),
    this.alwaysAllowStyle = const ButtonStyler.create(),
    this.denyStyle = const ButtonStyler.create(),
    this.style = const UiPermissionStyler.create(),
    this.styleSpec,
  });

  /// Identifies this request; a new id while pending re-enables the actions.
  final Object? requestId;

  /// The tool's identifier, such as `terminal.run`.
  final String tool;

  /// The question the card asks.
  final String title;

  /// Optional explanation of what the tool will do.
  final String? description;

  /// Where the request is in its lifecycle.
  ///
  /// The decision actions show only while it is pending. Once decided, the
  /// card collapses to a one-line receipt.
  final UiPermissionStatus status;

  /// The tool's arguments, listed in the details disclosure.
  final List<RemixDataListItem> parameters;

  /// Whether the details disclosure is offered when [parameters] is not empty.
  final bool showParameters;

  /// Controls the details disclosure. When null, the card manages it.
  final bool? detailsExpanded;

  /// Whether the details start open when uncontrolled.
  final bool defaultDetailsExpanded;

  /// Called when the details disclosure is asked to open or close.
  final ValueChanged<bool>? onDetailsExpandedChanged;

  /// Called by the "Allow once" action, which is disabled when this is null.
  final VoidCallback? onAllowOnce;

  /// Called by the "Always allow" action, which is shown only when this is set.
  final VoidCallback? onAlwaysAllow;

  /// Called by the "Deny" action, which is disabled when this is null.
  final VoidCallback? onDeny;

  /// Replaces the default status text.
  final UiPermissionStatusLabelBuilder? statusLabelBuilder;

  /// Replaces the default status icon.
  final UiPermissionStatusBuilder? statusBuilder;

  /// Replaces the details disclosure's default chevron.
  final UiPermissionIndicatorBuilder? indicatorBuilder;

  /// Label of the "Allow once" action.
  final String allowOnceLabel;

  /// Label of the "Always allow" action.
  final String alwaysAllowLabel;

  /// Label of the "Deny" action.
  final String denyLabel;

  /// The details disclosure's trigger text and accessible label.
  final String detailsLabel;

  /// Accessible label of the whole permission.
  final String semanticLabel;

  /// Layout direction of each parameter's label and value.
  final Axis parameterOrientation;

  /// Style of the card around the request.
  final CardStyler surfaceStyle;

  /// Style of the details disclosure.
  final DisclosureStyler detailsStyle;

  /// Style of the parameter list.
  final DataListStyler parametersStyle;

  /// Style of the "Allow once" action.
  final ButtonStyler allowOnceStyle;

  /// Style of the "Always allow" action.
  final ButtonStyler alwaysAllowStyle;

  /// Style of the "Deny" action.
  final ButtonStyler denyStyle;

  /// Style of the permission's own slots.
  final UiPermissionStyler style;

  /// A resolved spec that is used instead of resolving [style].
  final UiPermissionSpec? styleSpec;

  @override
  State<UiPermission> createState() => _UiPermissionState();
}

class _UiPermissionState extends State<UiPermission> {
  late final UiDisclosureEngine _disclosure;
  bool _decisionSubmitted = false;

  bool get _detailsExpanded => _disclosure.value;

  @override
  void initState() {
    super.initState();
    _disclosure = UiDisclosureEngine(
      value: widget.detailsExpanded,
      defaultValue:
          widget.status.keepsDetailsOpen || widget.defaultDetailsExpanded,
    );
  }

  @override
  void didUpdateWidget(UiPermission oldWidget) {
    super.didUpdateWidget(oldWidget);
    _disclosure.reconcile(widget.detailsExpanded);
    final returnedToPending =
        oldWidget.status != UiPermissionStatus.pending &&
        widget.status == UiPermissionStatus.pending;
    final newPendingRequest =
        oldWidget.requestId != widget.requestId &&
        widget.status == UiPermissionStatus.pending;
    if (returnedToPending || newPendingRequest) _decisionSubmitted = false;

    if (!oldWidget.status.keepsDetailsOpen && widget.status.keepsDetailsOpen) {
      _requestDetails(true);
    } else if (!oldWidget.status.isSettled && widget.status.isSettled) {
      _requestDetails(false);
    }
  }

  void _requestDetails(bool next) {
    if (_disclosure.request(next)) setState(() {});
    widget.onDetailsExpandedChanged?.call(next);
  }

  void _submit(VoidCallback? callback) {
    if (_decisionSubmitted ||
        widget.status != UiPermissionStatus.pending ||
        callback == null) {
      return;
    }
    setState(() => _decisionSubmitted = true);
    callback();
  }

  String get _statusLabel =>
      widget.statusLabelBuilder?.call(widget.status) ??
      switch (widget.status) {
        UiPermissionStatus.pending => 'Needs approval',
        UiPermissionStatus.deciding => 'Recording',
        UiPermissionStatus.allowed => 'Allowed',
        UiPermissionStatus.running => 'Running',
        UiPermissionStatus.complete => 'Complete',
        UiPermissionStatus.denied => 'Denied',
        UiPermissionStatus.error => 'Error',
      };

  UiFunctionalGlyphKind get _statusGlyph => switch (widget.status) {
    UiPermissionStatus.pending => .permission,
    UiPermissionStatus.deciding => .loading,
    UiPermissionStatus.allowed => .completed,
    UiPermissionStatus.running => .loading,
    UiPermissionStatus.complete => .completed,
    UiPermissionStatus.denied => .cancelled,
    UiPermissionStatus.error => .error,
  };

  StyleSpec<BoxSpec> _statusContainer(UiPermissionSpec spec) =>
      switch (widget.status) {
        UiPermissionStatus.pending => spec.pendingStatus,
        UiPermissionStatus.deciding => spec.decidingStatus,
        UiPermissionStatus.allowed => spec.allowedStatus,
        UiPermissionStatus.running => spec.runningStatus,
        UiPermissionStatus.complete => spec.completedStatus,
        UiPermissionStatus.denied => spec.deniedStatus,
        UiPermissionStatus.error => spec.errorStatus,
      };

  // Horizontal by default; callers may stack actions without losing the
  // action slot's box, modifiers, or nested style resolution.
  StyleSpec<FlexBoxSpec> _actionsStyle(UiPermissionSpec spec) {
    final actions = spec.actions.spec;
    final flex = actions.flex ?? const StyleSpec(spec: FlexSpec());
    return spec.actions.copyWith(
      spec: actions.copyWith(
        flex: flex.copyWith(
          spec: flex.spec.copyWith(
            direction: flex.spec.direction ?? Axis.horizontal,
          ),
        ),
      ),
    );
  }

  bool get _awaitingDecision =>
      widget.status == UiPermissionStatus.pending ||
      widget.status == UiPermissionStatus.deciding;

  Widget _status(BuildContext context, UiPermissionSpec spec) => Box(
    styleSpec: _statusContainer(spec),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 6,
      children: [
        widget.statusBuilder?.call(context, widget.status) ??
            StyleSpecBuilder<IconSpec>(
              styleSpec: spec.statusIcon,
              builder: (context, iconSpec) =>
                  UiFunctionalGlyph(kind: _statusGlyph, spec: iconSpec),
            ),
        Flexible(child: StyledText(_statusLabel, styleSpec: spec.status)),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return RemixStyleSpecBuilder<UiPermissionSpec>(
      style: widget.style,
      styleSpec: widget.styleSpec,
      builder: (context, spec) => Semantics(
        container: true,
        explicitChildNodes: true,
        label: widget.semanticLabel,
        // Once decided, the request is history: a one-line receipt of the
        // decision, without the card, so it does not repeat the tool call
        // that follows it.
        child: !_awaitingDecision
            ? RowBox(
                styleSpec: spec.header,
                children: [
                  _status(context, spec),
                  Flexible(
                    child: StyledText(widget.tool, styleSpec: spec.tool),
                  ),
                ],
              )
            : RemixCard(
                style: widget.surfaceStyle,
                child: Box(
                  styleSpec: spec.content,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      RowBox(
                        styleSpec: spec.header,
                        children: [
                          StyleSpecBuilder<IconSpec>(
                            styleSpec: spec.toolIcon,
                            builder: (context, iconSpec) =>
                                UiFunctionalGlyph(kind: .tool, spec: iconSpec),
                          ),
                          Expanded(
                            child: StyledText(
                              widget.title,
                              styleSpec: spec.title,
                            ),
                          ),
                          // The state reads as a badge at the header's trailing
                          // edge, where the eye lands after the question.
                          _status(context, spec),
                        ],
                      ),
                      StyledText(widget.tool, styleSpec: spec.tool),
                      if (widget.description != null)
                        StyledText(
                          widget.description!,
                          styleSpec: spec.description,
                        ),
                      if (widget.showParameters && widget.parameters.isNotEmpty)
                        RemixDisclosure(
                          expanded: _detailsExpanded,
                          onExpandedChanged: _requestDetails,
                          semanticLabel: widget.detailsLabel,
                          style: widget.detailsStyle,
                          triggerBuilder: (context, state, trigger) => Row(
                            // The indicator follows its label, as a link-like line,
                            // rather than sitting at the far edge of the row.
                            mainAxisSize: MainAxisSize.min,
                            spacing: 8,
                            children: [
                              Flexible(child: trigger!),
                              UiDisclosureIndicator(
                                styleSpec: spec.indicator,
                                expanded: state.isExpanded,
                                builder: widget.indicatorBuilder,
                              ),
                            ],
                          ),
                          trigger: StyledText(
                            widget.detailsLabel,
                            styleSpec: spec.detailsLabel,
                          ),
                          content: RemixDataList(
                            items: widget.parameters,
                            orientation: widget.parameterOrientation,
                            style: widget.parametersStyle,
                          ),
                        ),
                      if (widget.status == UiPermissionStatus.pending)
                        // The primary decision comes last, in reading and focus
                        // order, like the dialog footers of every preset; recipes
                        // place the row at the trailing edge.
                        FlexBox(
                          styleSpec: _actionsStyle(spec),
                          children: [
                            RemixButton(
                              key: const ValueKey('ui-permission-deny'),
                              label: widget.denyLabel,
                              enabled: !_decisionSubmitted,
                              onPressed: widget.onDeny == null
                                  ? null
                                  : () => _submit(widget.onDeny),
                              style: widget.denyStyle,
                            ),
                            if (widget.onAlwaysAllow != null)
                              RemixButton(
                                key: const ValueKey(
                                  'ui-permission-always-allow',
                                ),
                                label: widget.alwaysAllowLabel,
                                enabled: !_decisionSubmitted,
                                onPressed: () => _submit(widget.onAlwaysAllow),
                                style: widget.alwaysAllowStyle,
                              ),
                            RemixButton(
                              key: const ValueKey('ui-permission-allow-once'),
                              label: widget.allowOnceLabel,
                              enabled: !_decisionSubmitted,
                              onPressed: widget.onAllowOnce == null
                                  ? null
                                  : () => _submit(widget.onAllowOnce),
                              style: widget.allowOnceStyle,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

@MixableSpec(target: UiPermission.new)
@immutable
final class UiPermissionSpec with _$UiPermissionSpec {
  /// Wraps the card's content.
  @override
  final StyleSpec<BoxSpec> content;

  /// Lays out the header row, and the one-line receipt after a decision.
  @override
  final StyleSpec<FlexBoxSpec> header;

  /// Lays out the decision actions; horizontal unless a direction is set.
  @override
  final StyleSpec<FlexBoxSpec> actions;

  /// The question text.
  @override
  final StyleSpec<TextSpec> title;

  /// The tool identifier text.
  @override
  final StyleSpec<TextSpec> tool;

  /// The description text.
  @override
  final StyleSpec<TextSpec> description;

  /// The status text.
  @override
  final StyleSpec<TextSpec> status;

  /// The details trigger text.
  @override
  final StyleSpec<TextSpec> detailsLabel;

  /// The default tool icon.
  @override
  final StyleSpec<IconSpec> toolIcon;

  /// The default status icon.
  @override
  final StyleSpec<IconSpec> statusIcon;

  /// The details disclosure chevron.
  @override
  final StyleSpec<IconSpec> indicator;

  /// The status badge while waiting for a decision.
  @override
  final StyleSpec<BoxSpec> pendingStatus;

  /// The status badge while a decision is being recorded.
  @override
  final StyleSpec<BoxSpec> decidingStatus;

  /// The status badge once the invocation is allowed.
  @override
  final StyleSpec<BoxSpec> allowedStatus;

  /// The status badge while the approved tool runs.
  @override
  final StyleSpec<BoxSpec> runningStatus;

  /// The status badge after the tool finishes.
  @override
  final StyleSpec<BoxSpec> completedStatus;

  /// The status badge after a denial.
  @override
  final StyleSpec<BoxSpec> deniedStatus;

  /// The status badge after an error.
  @override
  final StyleSpec<BoxSpec> errorStatus;

  const UiPermissionSpec({
    StyleSpec<BoxSpec>? content,
    StyleSpec<FlexBoxSpec>? header,
    StyleSpec<FlexBoxSpec>? actions,
    StyleSpec<TextSpec>? title,
    StyleSpec<TextSpec>? tool,
    StyleSpec<TextSpec>? description,
    StyleSpec<TextSpec>? status,
    StyleSpec<TextSpec>? detailsLabel,
    StyleSpec<IconSpec>? toolIcon,
    StyleSpec<IconSpec>? statusIcon,
    StyleSpec<IconSpec>? indicator,
    StyleSpec<BoxSpec>? pendingStatus,
    StyleSpec<BoxSpec>? decidingStatus,
    StyleSpec<BoxSpec>? allowedStatus,
    StyleSpec<BoxSpec>? runningStatus,
    StyleSpec<BoxSpec>? completedStatus,
    StyleSpec<BoxSpec>? deniedStatus,
    StyleSpec<BoxSpec>? errorStatus,
  }) : content = content ?? const StyleSpec(spec: BoxSpec()),
       header = header ?? const StyleSpec(spec: FlexBoxSpec()),
       actions = actions ?? const StyleSpec(spec: FlexBoxSpec()),
       title = title ?? const StyleSpec(spec: TextSpec()),
       tool = tool ?? const StyleSpec(spec: TextSpec()),
       description = description ?? const StyleSpec(spec: TextSpec()),
       status = status ?? const StyleSpec(spec: TextSpec()),
       detailsLabel = detailsLabel ?? const StyleSpec(spec: TextSpec()),
       toolIcon = toolIcon ?? const StyleSpec(spec: IconSpec()),
       statusIcon = statusIcon ?? const StyleSpec(spec: IconSpec()),
       indicator = indicator ?? const StyleSpec(spec: IconSpec()),
       pendingStatus = pendingStatus ?? const StyleSpec(spec: BoxSpec()),
       decidingStatus = decidingStatus ?? const StyleSpec(spec: BoxSpec()),
       allowedStatus = allowedStatus ?? const StyleSpec(spec: BoxSpec()),
       runningStatus = runningStatus ?? const StyleSpec(spec: BoxSpec()),
       completedStatus = completedStatus ?? const StyleSpec(spec: BoxSpec()),
       deniedStatus = deniedStatus ?? const StyleSpec(spec: BoxSpec()),
       errorStatus = errorStatus ?? const StyleSpec(spec: BoxSpec());
}
