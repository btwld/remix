import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../models/activity_item.dart';
import '../models/statuses.dart';
import '../support/disclosure.dart';
import '../support/functional_glyph.dart';
import '../support/live_edge.dart';

part 'activity.g.dart';

/// Builds a row's status icon in place of the default glyph.
typedef UiActivityStatusBuilder =
    Widget Function(BuildContext context, UiActivityItem item);

/// Returns the accessible status text announced for a row.
typedef UiActivityStatusLabelBuilder = String Function(UiActivityItem item);

/// Builds the disclosure indicator in place of the default chevron.
typedef UiActivityIndicatorBuilder =
    Widget Function(BuildContext context, bool expanded);

/// Activity ledger that opens when work starts and collapses when it completes.
///
/// Like [UiPlan] and [UiExecution], the reader can collapse or reopen it
/// at any time, so its header keeps the enabled look of every other ledger
/// while work runs.
class UiActivity extends StatefulWidget {
  const UiActivity({
    super.key,
    required this.items,
    this.status = UiRunStatus.working,
    this.title = 'Activity',
    this.semanticLabel = 'Activity',
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
    this.style = const UiActivityStyler.create(),
    this.styleSpec,
  });

  /// The ledger's rows, in display order.
  final List<UiActivityItem> items;

  /// The run's status. The ledger opens when it becomes
  /// [UiRunStatus.working] and, with [collapseOnComplete], closes when it
  /// leaves that status.
  final UiRunStatus status;

  /// The disclosure's title and accessible label.
  final String title;

  /// Accessible label of the whole ledger.
  final String semanticLabel;

  /// Whether the ledger closes itself when [status] leaves
  /// [UiRunStatus.working].
  final bool collapseOnComplete;

  /// Controls the disclosure. When null, the ledger manages it.
  final bool? expanded;

  /// Whether the disclosure starts open when uncontrolled.
  final bool defaultExpanded;

  /// Called when the disclosure is asked to open or close.
  final ValueChanged<bool>? onExpandedChanged;

  /// Replaces a row's default status icon.
  final UiActivityStatusBuilder? statusBuilder;

  /// Replaces the default status text announced for a row.
  final UiActivityStatusLabelBuilder? statusLabelBuilder;

  /// Replaces the disclosure's default chevron.
  final UiActivityIndicatorBuilder? indicatorBuilder;

  /// Whether growing content keeps the newest row in view.
  final bool followOutput;

  /// Distance from the end, in logical pixels, that still counts as near it.
  final double followThreshold;

  /// Called when the reader leaves or returns to the end of the list.
  final ValueChanged<bool>? onFollowChanged;

  /// Style of the disclosure.
  final DisclosureStyler disclosureStyle;

  /// Style of the ledger's own slots.
  final UiActivityStyler style;

  /// A resolved spec that is used instead of resolving [style].
  final UiActivitySpec? styleSpec;

  /// Whether [status] is [UiRunStatus.working].
  bool get isWorking => status == UiRunStatus.working;

  /// Number of completed rows in the activity ledger.
  int get settledCount => items
      .where((item) => item.status == UiActivityItemStatus.complete)
      .length;

  @override
  State<UiActivity> createState() => _UiActivityState();
}

class _UiActivityState extends State<UiActivity> {
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
  void didUpdateWidget(UiActivity oldWidget) {
    super.didUpdateWidget(oldWidget);
    _disclosure.reconcile(widget.expanded);
    if (!oldWidget.isWorking && widget.isWorking) {
      _request(true);
    } else if (oldWidget.isWorking &&
        !widget.isWorking &&
        widget.collapseOnComplete) {
      _request(false);
    }
  }

  void _request(bool next) {
    if (_disclosure.request(next)) setState(() {});
    widget.onExpandedChanged?.call(next);
  }

  String _statusLabel(UiActivityItem item) =>
      widget.statusLabelBuilder?.call(item) ??
      switch (item.status) {
        UiActivityItemStatus.pending => 'Pending',
        UiActivityItemStatus.active => 'Active',
        UiActivityItemStatus.complete => 'Complete',
      };

  UiFunctionalGlyphKind _statusGlyph(UiActivityItemStatus status) =>
      switch (status) {
        UiActivityItemStatus.pending => .pending,
        UiActivityItemStatus.active => .active,
        UiActivityItemStatus.complete => .completed,
      };

  StyleSpec<BoxSpec> _statusContainer(
    UiActivitySpec spec,
    UiActivityItemStatus status,
  ) => switch (status) {
    UiActivityItemStatus.pending => spec.pendingItem,
    UiActivityItemStatus.active => spec.activeItem,
    UiActivityItemStatus.complete => spec.completedItem,
  };

  StyleSpec<IconSpec> _statusStyle(
    UiActivitySpec spec,
    UiActivityItemStatus status,
  ) => switch (status) {
    UiActivityItemStatus.pending => spec.pendingStatus,
    UiActivityItemStatus.active => spec.activeStatus,
    UiActivityItemStatus.complete => spec.completedStatus,
  };

  Widget _defaultStatus(
    BuildContext context,
    UiActivitySpec spec,
    UiActivityItem item,
  ) => StyleSpecBuilder<IconSpec>(
    styleSpec: _statusStyle(spec, item.status),
    builder: (context, iconSpec) =>
        UiFunctionalGlyph(kind: _statusGlyph(item.status), spec: iconSpec),
  );

  @override
  Widget build(BuildContext context) {
    return RemixStyleSpecBuilder<UiActivitySpec>(
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
            child: UiLiveEdgeScrollView(
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
                      explicitChildNodes: true,
                      label: [
                        item.title,
                        if (item.detail != null) item.detail!,
                        _statusLabel(item),
                      ].join(', '),
                      child: Box(
                        styleSpec: _statusContainer(spec, item.status),
                        child: RowBox(
                          key: ValueKey('ui-activity-item-${item.id}'),
                          styleSpec: spec.item,
                          children: [
                            ExcludeSemantics(
                              child:
                                  widget.statusBuilder?.call(context, item) ??
                                  _defaultStatus(context, spec, item),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ExcludeSemantics(
                                    child: StyledText(
                                      item.title,
                                      styleSpec: spec.itemTitle,
                                    ),
                                  ),
                                  if (item.detail != null)
                                    ExcludeSemantics(
                                      child: StyledText(
                                        item.detail!,
                                        styleSpec: spec.itemDetail,
                                      ),
                                    ),
                                  if (item.child != null) item.child!,
                                ],
                              ),
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

@MixableSpec(target: UiActivity.new)
@immutable
final class UiActivitySpec with _$UiActivitySpec {
  /// Bounds the scrolling list of rows.
  @override
  final StyleSpec<BoxSpec> viewport;

  /// Lays out one row: status icon, title, detail and child.
  @override
  final StyleSpec<FlexBoxSpec> item;

  /// The title in the disclosure trigger.
  @override
  final StyleSpec<TextSpec> summaryTitle;

  /// A row's title.
  @override
  final StyleSpec<TextSpec> itemTitle;

  /// A row's detail text.
  @override
  final StyleSpec<TextSpec> itemDetail;

  /// The complete/total count in the trigger.
  @override
  final StyleSpec<TextSpec> count;

  /// The disclosure chevron.
  @override
  final StyleSpec<IconSpec> indicator;

  /// Wraps a pending row.
  @override
  final StyleSpec<BoxSpec> pendingItem;

  /// Wraps the active row.
  @override
  final StyleSpec<BoxSpec> activeItem;

  /// Wraps a complete row.
  @override
  final StyleSpec<BoxSpec> completedItem;

  /// The status icon of a pending row.
  @override
  final StyleSpec<IconSpec> pendingStatus;

  /// The status icon of the active row.
  @override
  final StyleSpec<IconSpec> activeStatus;

  /// The status icon of a complete row.
  @override
  final StyleSpec<IconSpec> completedStatus;

  const UiActivitySpec({
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
    StyleSpec<IconSpec>? pendingStatus,
    StyleSpec<IconSpec>? activeStatus,
    StyleSpec<IconSpec>? completedStatus,
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
       pendingStatus = pendingStatus ?? const StyleSpec(spec: IconSpec()),
       activeStatus = activeStatus ?? const StyleSpec(spec: IconSpec()),
       completedStatus = completedStatus ?? const StyleSpec(spec: IconSpec());
}
