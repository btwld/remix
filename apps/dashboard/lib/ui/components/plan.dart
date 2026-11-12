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
typedef UiPlanStatusBuilder =
    Widget Function(BuildContext context, UiPlanItem item);

/// Returns the accessible status text announced for an item.
typedef UiPlanStatusLabelBuilder = String Function(UiPlanItem item);

/// Builds the disclosure indicator in place of the default chevron.
typedef UiPlanIndicatorBuilder =
    Widget Function(BuildContext context, bool expanded);

/// Toggleable task plan with lifecycle-aware uncontrolled disclosure state.
class UiPlan extends StatefulWidget {
  const UiPlan({
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
    this.style = const UiPlanStyler.create(),
    this.styleSpec,
  });

  /// The plan's rows, in display order.
  final List<UiPlanItem> items;

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
  final UiPlanStatusBuilder? statusBuilder;

  /// Replaces the default status text announced for an item.
  final UiPlanStatusLabelBuilder? statusLabelBuilder;

  /// Replaces the disclosure's default chevron.
  final UiPlanIndicatorBuilder? indicatorBuilder;

  /// Whether growing content keeps the newest row in view.
  final bool followOutput;

  /// Distance from the end, in logical pixels, that still counts as near it.
  final double followThreshold;

  /// Called when the reader leaves or returns to the end of the list.
  final ValueChanged<bool>? onFollowChanged;

  /// Style of the disclosure.
  final DisclosureStyler disclosureStyle;

  /// Style of the plan's own slots.
  final UiPlanStyler style;

  /// A resolved spec that is used instead of resolving [style].
  final UiPlanSpec? styleSpec;

  /// Number of items that are completed or canceled.
  int get settledCount => items.where((item) => item.status.isDone).length;

  /// Whether any item is still pending or in progress.
  bool get isWorking => items.any((item) => !item.status.isDone);

  @override
  State<UiPlan> createState() => _UiPlanState();
}

class _UiPlanState extends State<UiPlan> {
  late final UiDisclosureEngine _disclosure;

  bool get _expanded => _disclosure.value;

  @override
  void initState() {
    super.initState();
    _disclosure = UiDisclosureEngine(
      value: widget.expanded,
      defaultValue: widget.defaultExpanded,
    );
  }

  @override
  void didUpdateWidget(UiPlan oldWidget) {
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

  String _statusLabel(UiPlanItem item) =>
      widget.statusLabelBuilder?.call(item) ??
      switch (item.status) {
        UiPlanItemStatus.pending => 'Pending',
        UiPlanItemStatus.inProgress => 'In progress',
        UiPlanItemStatus.completed => 'Completed',
        UiPlanItemStatus.cancelled => 'Cancelled',
      };

  UiFunctionalGlyphKind _statusGlyph(UiPlanItemStatus status) =>
      switch (status) {
        UiPlanItemStatus.pending => .pending,
        UiPlanItemStatus.inProgress => .active,
        UiPlanItemStatus.completed => .completed,
        UiPlanItemStatus.cancelled => .cancelled,
      };

  StyleSpec<BoxSpec> _statusContainer(
    UiPlanSpec spec,
    UiPlanItemStatus status,
  ) => switch (status) {
    UiPlanItemStatus.pending => spec.pendingItem,
    UiPlanItemStatus.inProgress => spec.activeItem,
    UiPlanItemStatus.completed => spec.completedItem,
    UiPlanItemStatus.cancelled => spec.cancelledItem,
  };

  StyleSpec<IconSpec> _statusStyle(UiPlanSpec spec, UiPlanItemStatus status) =>
      switch (status) {
        UiPlanItemStatus.pending => spec.pendingStatus,
        UiPlanItemStatus.inProgress => spec.activeStatus,
        UiPlanItemStatus.completed => spec.completedStatus,
        UiPlanItemStatus.cancelled => spec.cancelledStatus,
      };

  Widget _defaultStatus(
    BuildContext context,
    UiPlanSpec spec,
    UiPlanItem item,
  ) {
    return StyleSpecBuilder<IconSpec>(
      styleSpec: _statusStyle(spec, item.status),
      builder: (context, iconSpec) =>
          UiFunctionalGlyph(kind: _statusGlyph(item.status), spec: iconSpec),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RemixStyleSpecBuilder<UiPlanSpec>(
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
              UiDisclosureIndicator(
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
                : UiLiveEdgeScrollView(
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
                                key: ValueKey('ui-plan-item-${item.id}'),
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

@MixableSpec(target: UiPlan.new)
@immutable
final class UiPlanSpec with _$UiPlanSpec {
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

  const UiPlanSpec({
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
