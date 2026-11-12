import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../models/plan_item.dart';
import '../models/statuses.dart';
import '../support/disclosure.dart';
import '../support/functional_glyph.dart';
import '../support/live_edge.dart';

part 'plan.g.dart';

/// Builds an item's status icon in place of the default glyph.
typedef AgentPlanStatusBuilder =
    Widget Function(BuildContext context, AgentPlanItem item);

/// Returns the accessible status text announced for an item.
typedef AgentPlanStatusLabelBuilder = String Function(AgentPlanItem item);

/// Builds the disclosure indicator in place of the default chevron.
typedef AgentPlanIndicatorBuilder =
    Widget Function(BuildContext context, bool expanded);

/// Toggleable task plan with lifecycle-aware uncontrolled disclosure state.
class AgentPlan extends StatefulWidget {
  const AgentPlan({
    super.key,
    required this.items,
    this.title = 'Plan',
    this.emptyLabel = 'No tasks yet',
    this.semanticLabel = 'Task plan',
    this.collapseOnComplete = true,
    this.expanded,
    this.defaultExpanded = true,
    this.onExpandedChanged,
    this.statusBuilder,
    this.statusLabelBuilder,
    this.indicatorBuilder,
    this.followOutput = true,
    this.followThreshold = 48,
    this.onFollowChanged,
    this.disclosureStyle = const DisclosureStyler.create(),
    this.style = const AgentPlanStyler.create(),
    this.styleSpec,
  });

  /// The plan's rows, in display order.
  final List<AgentPlanItem> items;

  /// The disclosure's title and accessible label.
  final String title;

  /// Shown in place of the rows when [items] is empty.
  final String emptyLabel;

  /// Accessible label of the whole plan.
  final String semanticLabel;

  /// Whether the plan closes itself when its last open item finishes.
  final bool collapseOnComplete;

  /// Controls the disclosure. When null, the plan manages it.
  final bool? expanded;

  /// Whether the disclosure starts open when uncontrolled.
  final bool defaultExpanded;

  /// Called when the disclosure is asked to open or close.
  final ValueChanged<bool>? onExpandedChanged;

  /// Replaces an item's default status icon.
  final AgentPlanStatusBuilder? statusBuilder;

  /// Replaces the default status text announced for an item.
  final AgentPlanStatusLabelBuilder? statusLabelBuilder;

  /// Replaces the disclosure's default chevron.
  final AgentPlanIndicatorBuilder? indicatorBuilder;

  /// Whether growing content keeps the newest row in view.
  final bool followOutput;

  /// Distance from the end, in logical pixels, that still counts as near it.
  final double followThreshold;

  /// Called when the reader leaves or returns to the end of the list.
  final ValueChanged<bool>? onFollowChanged;

  /// Style of the disclosure.
  final DisclosureStyler disclosureStyle;

  /// Style of the plan's own slots.
  final AgentPlanStyler style;

  /// A resolved spec that is used instead of resolving [style].
  final AgentPlanSpec? styleSpec;

  /// Number of items that are completed or canceled.
  int get settledCount => items.where((item) => item.status.isDone).length;

  /// Whether any item is still pending or in progress.
  bool get isWorking => items.any((item) => !item.status.isDone);

  @override
  State<AgentPlan> createState() => _AgentPlanState();
}

class _AgentPlanState extends State<AgentPlan> {
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
  void didUpdateWidget(AgentPlan oldWidget) {
    super.didUpdateWidget(oldWidget);
    _disclosure.reconcile(widget.expanded);
    final wasWorking = oldWidget.isWorking;
    final working = widget.isWorking;
    if (wasWorking && !working && widget.collapseOnComplete) {
      _request(false);
    } else if (!wasWorking && working) {
      _request(true);
    }
  }

  void _request(bool next) {
    if (_disclosure.request(next)) setState(() {});
    widget.onExpandedChanged?.call(next);
  }

  String _statusLabel(AgentPlanItem item) =>
      widget.statusLabelBuilder?.call(item) ??
      switch (item.status) {
        AgentPlanItemStatus.pending => 'Pending',
        AgentPlanItemStatus.inProgress => 'In progress',
        AgentPlanItemStatus.completed => 'Completed',
        AgentPlanItemStatus.cancelled => 'Cancelled',
      };

  AgentFunctionalGlyphKind _statusGlyph(AgentPlanItemStatus status) =>
      switch (status) {
        AgentPlanItemStatus.pending => .pending,
        AgentPlanItemStatus.inProgress => .active,
        AgentPlanItemStatus.completed => .completed,
        AgentPlanItemStatus.cancelled => .cancelled,
      };

  StyleSpec<BoxSpec> _statusContainer(
    AgentPlanSpec spec,
    AgentPlanItemStatus status,
  ) => switch (status) {
    AgentPlanItemStatus.pending => spec.pendingItem,
    AgentPlanItemStatus.inProgress => spec.activeItem,
    AgentPlanItemStatus.completed => spec.completedItem,
    AgentPlanItemStatus.cancelled => spec.cancelledItem,
  };

  StyleSpec<IconSpec> _statusStyle(
    AgentPlanSpec spec,
    AgentPlanItemStatus status,
  ) => switch (status) {
    AgentPlanItemStatus.pending => spec.pendingStatus,
    AgentPlanItemStatus.inProgress => spec.activeStatus,
    AgentPlanItemStatus.completed => spec.completedStatus,
    AgentPlanItemStatus.cancelled => spec.cancelledStatus,
  };

  Widget _defaultStatus(
    BuildContext context,
    AgentPlanSpec spec,
    AgentPlanItem item,
  ) {
    return StyleSpecBuilder<IconSpec>(
      styleSpec: _statusStyle(spec, item.status),
      builder: (context, iconSpec) =>
          AgentFunctionalGlyph(kind: _statusGlyph(item.status), spec: iconSpec),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RemixStyleSpecBuilder<AgentPlanSpec>(
      style: widget.style,
      styleSpec: widget.styleSpec,
      builder: (context, spec) => Semantics(
        container: true,
        explicitChildNodes: true,
        label: widget.semanticLabel,
        child: RemixDisclosure(
          expanded: _expanded,
          onExpandedChanged: _request,
          semanticLabel: widget.title,
          style: widget.disclosureStyle,
          triggerBuilder: (context, state, trigger) => Row(
            children: [
              Expanded(child: trigger!),
              AgentDisclosureIndicator(
                styleSpec: spec.indicator,
                expanded: state.isExpanded,
                builder: widget.indicatorBuilder,
              ),
            ],
          ),
          trigger: Row(
            children: [
              Expanded(
                child: StyledText(widget.title, styleSpec: spec.summaryTitle),
              ),
              StyledText(
                '${widget.settledCount}/${widget.items.length}',
                styleSpec: spec.count,
              ),
            ],
          ),
          content: Box(
            styleSpec: spec.viewport,
            child: widget.items.isEmpty
                ? StyledText(widget.emptyLabel, styleSpec: spec.itemDetail)
                : AgentLiveEdgeScrollView(
                    followOutput: widget.followOutput,
                    followThreshold: widget.followThreshold,
                    onFollowChanged: widget.onFollowChanged,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final item in widget.items)
                          Semantics(
                            container: true,
                            excludeSemantics: true,
                            label: [
                              item.title,
                              if (item.detail != null) item.detail!,
                              _statusLabel(item),
                            ].join(', '),
                            child: Box(
                              styleSpec: _statusContainer(spec, item.status),
                              child: RowBox(
                                key: ValueKey('agent-plan-item-${item.id}'),
                                styleSpec: spec.item,
                                children: [
                                  widget.statusBuilder?.call(context, item) ??
                                      _defaultStatus(context, spec, item),
                                  Expanded(
                                    child: StyledText(
                                      item.title,
                                      styleSpec: spec.itemTitle,
                                    ),
                                  ),
                                  if (item.detail != null)
                                    StyledText(
                                      item.detail!,
                                      styleSpec: spec.itemDetail,
                                    ),
                                ],
                              ),
                            ),
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

@MixableSpec(target: AgentPlan.new)
@immutable
final class AgentPlanSpec with _$AgentPlanSpec {
  /// Bounds the scrolling list of rows.
  @override
  final StyleSpec<BoxSpec> viewport;

  /// Lays out one row: status icon, title and detail.
  @override
  final StyleSpec<FlexBoxSpec> item;

  /// The title in the disclosure trigger.
  @override
  final StyleSpec<TextSpec> summaryTitle;

  /// A row's title.
  @override
  final StyleSpec<TextSpec> itemTitle;

  /// A row's detail, and the empty label.
  @override
  final StyleSpec<TextSpec> itemDetail;

  /// The settled/total count in the trigger.
  @override
  final StyleSpec<TextSpec> count;

  /// The disclosure chevron.
  @override
  final StyleSpec<IconSpec> indicator;

  /// Wraps a pending row.
  @override
  final StyleSpec<BoxSpec> pendingItem;

  /// Wraps the in-progress row.
  @override
  final StyleSpec<BoxSpec> activeItem;

  /// Wraps a completed row.
  @override
  final StyleSpec<BoxSpec> completedItem;

  /// Wraps a canceled row.
  @override
  final StyleSpec<BoxSpec> cancelledItem;

  /// The status icon of a pending row.
  @override
  final StyleSpec<IconSpec> pendingStatus;

  /// The status icon of the in-progress row.
  @override
  final StyleSpec<IconSpec> activeStatus;

  /// The status icon of a completed row.
  @override
  final StyleSpec<IconSpec> completedStatus;

  /// The status icon of a canceled row.
  @override
  final StyleSpec<IconSpec> cancelledStatus;

  const AgentPlanSpec({
    StyleSpec<BoxSpec>? viewport,
    StyleSpec<FlexBoxSpec>? item,
    StyleSpec<TextSpec>? summaryTitle,
    StyleSpec<TextSpec>? itemTitle,
    StyleSpec<TextSpec>? itemDetail,
    StyleSpec<TextSpec>? count,
    StyleSpec<IconSpec>? indicator,
    StyleSpec<BoxSpec>? pendingItem,
    StyleSpec<BoxSpec>? activeItem,
    StyleSpec<BoxSpec>? completedItem,
    StyleSpec<BoxSpec>? cancelledItem,
    StyleSpec<IconSpec>? pendingStatus,
    StyleSpec<IconSpec>? activeStatus,
    StyleSpec<IconSpec>? completedStatus,
    StyleSpec<IconSpec>? cancelledStatus,
  }) : viewport = viewport ?? const StyleSpec(spec: BoxSpec()),
       item = item ?? const StyleSpec(spec: FlexBoxSpec()),
       summaryTitle = summaryTitle ?? const StyleSpec(spec: TextSpec()),
       itemTitle = itemTitle ?? const StyleSpec(spec: TextSpec()),
       itemDetail = itemDetail ?? const StyleSpec(spec: TextSpec()),
       count = count ?? const StyleSpec(spec: TextSpec()),
       indicator = indicator ?? const StyleSpec(spec: IconSpec()),
       pendingItem = pendingItem ?? const StyleSpec(spec: BoxSpec()),
       activeItem = activeItem ?? const StyleSpec(spec: BoxSpec()),
       completedItem = completedItem ?? const StyleSpec(spec: BoxSpec()),
       cancelledItem = cancelledItem ?? const StyleSpec(spec: BoxSpec()),
       pendingStatus = pendingStatus ?? const StyleSpec(spec: IconSpec()),
       activeStatus = activeStatus ?? const StyleSpec(spec: IconSpec()),
       completedStatus = completedStatus ?? const StyleSpec(spec: IconSpec()),
       cancelledStatus = cancelledStatus ?? const StyleSpec(spec: IconSpec());
}
