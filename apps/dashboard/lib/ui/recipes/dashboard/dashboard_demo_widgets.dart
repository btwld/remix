import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import 'dashboard_demo_page_header.dart';
import 'dashboard_demo_records.dart';
import 'dashboard_demo_text.dart';
import 'dashboard_demo_theme.dart';
import 'dashboard_demo_typography.dart';
import 'dashboard_demo_ui.dart';

/// Tag row under a stat card's value: delta badge plus caption.
final uiStatTagsStyle = WrapBoxStyler()
    .spacing(8)
    .runSpacing(6)
    .crossAxisAlignment(.center);

/// Metric card used on the dashboard overview page.
class UiStatCard extends StatelessWidget {
  const UiStatCard({
    super.key,
    required this.label,
    required this.value,
    this.caption = 'vs last month',
    this.delta,
    this.positive = true,
    this.icon,
    this.progress,
  });

  /// The metric name.
  final String label;

  /// The metric's current value.
  final String value;

  /// Text beside the delta, naming the period it compares to.
  final String caption;

  /// The change over that period, shown as a badge. Omitted when null.
  final String? delta;

  /// Whether the change is good. It chooses the badge color.
  final bool positive;

  /// Replaces the icon otherwise chosen from [label].
  final IconData? icon;

  /// Completion shown as a bar, as a fraction or a percentage. Omitted when null.
  final double? progress;

  @override
  Widget build(BuildContext context) {
    final resolvedIcon =
        icon ??
        switch (label) {
          'Revenue' => RemixIcons.chart,
          'Active customers' => RemixIcons.user,
          'Open orders' => RemixIcons.box,
          'Fulfillment' => RemixIcons.activity,
          _ => RemixIcons.activity,
        };
    final column = ColumnBox(
      style: FlexBoxStyler()
          .mainAxisSize(.min)
          .crossAxisAlignment(.stretch)
          .spacing(12),
      children: [
        RowBox(
          style: FlexBoxStyler().crossAxisAlignment(.center),
          children: [
            Expanded(
              child: StyledText(
                label,
                style: dashboardText(.size2, tone: .muted),
              ),
            ),
            UiAvatar.soft(icon: resolvedIcon, size: .size2),
          ],
        ),
        UiText(value, size: .size7, weight: .bold),
        uiStatTagsStyle(
          children: [
            if (delta case final delta?)
              positive
                  ? UiAccentScope(
                      accent: .serra,
                      child: UiBadge(highContrast: true, label: delta),
                    )
                  : UiAccentScope.error(
                      child: UiBadge(highContrast: true, label: delta),
                    ),
            StyledText(caption, style: dashboardText(.size1, tone: .muted)),
          ],
        ),
        if (progress case final value?)
          UiProgress(
            value: value <= 1 ? value : value / 100,
            size: .size1,
            semanticsLabel: label,
          ),
      ],
    );

    return UiCard(size: .size2, child: column);
  }
}

/// Domain status badge. Its text label carries the status; the color only
/// reinforces it. Negative statuses use the dedicated error red.
class UiStatusBadge extends StatelessWidget {
  const UiStatusBadge._({super.key, required this.label, this.accent});

  factory UiStatusBadge.order(UiDashboardOrderStatus status, {Key? key}) =>
      UiStatusBadge._(
        key: key,
        label: capitalize(status.name),
        accent: switch (status) {
          .paid => .serra,
          .pending => .sol,
          .refunded => null,
          .cancelled => .orla,
        },
      );

  factory UiStatusBadge.customer(
    UiDashboardCustomerStatus status, {
    Key? key,
  }) => UiStatusBadge._(
    key: key,
    label: capitalize(status.name),
    accent: switch (status) {
      .active => .serra,
      .invited => .ceu,
      .suspended => null,
    },
  );

  factory UiStatusBadge.label(String status, {Key? key}) {
    final normalized = status.trim().toLowerCase();
    return UiStatusBadge._(
      key: key,
      label: capitalize(normalized),
      accent: switch (normalized) {
        'paid' || 'active' || 'fulfilled' || 'ready' => .serra,
        'pending' || 'processing' || 'review' => .sol,
        'refunded' || 'suspended' => null,
        'cancelled' => .orla,
        'invited' => .ceu,
        _ => .mar,
      },
    );
  }

  /// The status text.
  final String label;

  /// The status accent, or null for the dedicated error red.
  final UiAccentColor? accent;

  @override
  Widget build(BuildContext context) {
    final badge = UiBadge(highContrast: true, label: label);
    return switch (accent) {
      final accent? => UiAccentScope(accent: accent, child: badge),
      null => UiAccentScope.error(child: badge),
    };
  }
}

/// Compact single-line cell text for a [RemixDataTable] body cell.
class UiDataTableCellText extends StatelessWidget {
  const UiDataTableCellText(this.text, {super.key, this.primary = false});

  static final _primary = dashboardTextLine(.size2, weight: .medium);
  static final _secondary = dashboardTextLine(
    .size2,
    weight: .regular,
    tone: .muted,
  );

  /// The cell text.
  final String text;

  /// Whether the text is the row's main value, which is emphasized.
  final bool primary;

  @override
  Widget build(BuildContext context) =>
      StyledText(text, style: primary ? _primary : _secondary);
}

/// Shared animation style for standalone disclosures.
const uiDisclosureAnimationStyle = AnimationStyle(
  curve: Curves.ease,
  duration: Duration(milliseconds: 200),
  reverseDuration: Duration(milliseconds: 200),
);

/// Disclosure trigger composition with an animated rotating chevron.
class UiDisclosureTrigger extends StatelessWidget {
  const UiDisclosureTrigger({
    super.key,
    required this.expanded,
    required this.child,
  });

  /// Whether the disclosure is open. An open disclosure turns the chevron.
  final bool expanded;

  /// The trigger label, shown before the chevron.
  final Widget child;

  @override
  Widget build(BuildContext context) => RowBox(
    style: FlexBoxStyler().crossAxisAlignment(.center),
    children: [
      Expanded(child: child),
      Box(
        style: BoxStyler()
            .transform(
              Matrix4.rotationZ(expanded ? math.pi : 0),
              alignment: .center,
            )
            .animate(
              AnimationConfig.curve(
                duration: uiDisclosureAnimationStyle.duration!,
                curve: uiDisclosureAnimationStyle.curve!,
              ),
            ),
        child: const StyledIcon(icon: RemixIcons.chevronDown),
      ),
    ],
  );
}

/// Action entry displayed in a [UiActionMenu].
@immutable
class UiAction {
  const UiAction({
    required this.value,
    required this.label,
    this.dividerBefore = false,
  });

  /// The value passed to [UiActionMenu.onSelected] when chosen.
  final String value;

  /// The text shown for the action.
  final String label;

  /// Whether a divider precedes the action.
  final bool dividerBefore;
}

/// Action menu for dashboard triggers such as avatars, account rows, and
/// data-table kebab menus.
class UiActionMenu extends StatelessWidget {
  const UiActionMenu({
    super.key,
    required this.trigger,
    required this.actions,
    required this.onSelected,
    this.positioning = const OverlayPositionConfig(
      side: .bottom,
      alignment: .start,
      sideOffset: 4,
      collisionPadding: EdgeInsets.all(10),
    ),
    this.width = 180,
  });

  /// The control that opens the menu.
  final RemixMenuTrigger trigger;

  /// The actions listed in the menu.
  final List<UiAction> actions;

  /// Called with the chosen action's value.
  final ValueChanged<String> onSelected;

  /// Where the menu opens relative to the trigger.
  final OverlayPositionConfig positioning;

  /// The menu width.
  final double width;

  @override
  Widget build(BuildContext context) {
    final contentInset = UiTokens.space1.resolve(context);
    final itemWidth = width - contentInset * 2;

    return UiMenu<String>(
      size: .size1,
      positioning: positioning,
      trigger: trigger,
      items: [
        for (final action in actions) ...[
          if (action.dividerBefore) const RemixMenuDivider(),
          RemixMenuItem(
            key: ValueKey('dashboard-action-${action.value}'),
            value: action.value,
            label: action.label,
            style: MenuItemStyler().width(itemWidth),
          ),
        ],
      ],
      onSelected: onSelected,
    );
  }
}

/// Positioning for a [UiActionMenu] anchored to a data table's trailing
/// actions column.
const uiDataTableActionsPositioning = OverlayPositionConfig(
  side: .bottom,
  alignment: .end,
  sideOffset: 4,
);

/// Kebab button shared by data-table actions columns.
RemixMenuTrigger uiDataTableActionsTrigger(String semanticLabel) =>
    RemixMenuTrigger.control(
      builder: (_, menu) => UiIconButton.ghost(
        icon: RemixIcons.more,
        semanticLabel: semanticLabel,
        focusNode: menu.focusNode,
        onPressed: menu.toggle,
        style: IconButtonStyler().margin(.all(0)).icon(.size(18)),
      ),
    );

/// Empty state card used when search or filter queries match no rows.
class UiEmptyState extends StatelessWidget {
  const UiEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.action,
  });

  /// The icon above the message.
  final IconData icon;

  /// The heading of the message.
  final String title;

  /// The explanation under the heading.
  final String body;

  /// A control shown under the message. Omitted when null.
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Box(
      style: BoxStyler().alignment(.center),
      child: ColumnBox(
        style: FlexBoxStyler()
            .maxWidth(340)
            .padding(.symmetric(vertical: 44, horizontal: 24))
            .mainAxisSize(.min)
            .crossAxisAlignment(.center)
            .spacing(10),
        children: [
          Box(
            style: BoxStyler()
                .width(46)
                .height(46)
                .alignment(.center)
                .color(UiTokens.gray4())
                .shape(.circle()),
            child: StyledIcon(
              icon: icon,
              style: IconStyler().color(UiTokens.gray9()),
            ),
          ),
          UiHeading(
            title,
            headingLevel: 2,
            size: .size3,
            weight: .medium,
            align: .center,
          ),
          StyledText(
            body,
            style: dashboardText(.size2, tone: .muted).textAlign(.center),
          ),
          if (action case final action?)
            Box(style: BoxStyler().padding(.top(4)), child: action),
        ],
      ),
    );
  }
}

/// Dashboard chart card surface shared by overview and analytics charts.
class UiChartCard extends StatelessWidget {
  const UiChartCard({
    super.key,
    required this.title,
    required this.description,
    required this.chart,
    this.legend,
    this.chartPadding,
    this.chartPaddingKey,
  });

  static const _plotHeight = 220.0;

  /// The card title.
  final String title;

  /// A line of supporting copy under the title.
  final String description;

  /// The chart, drawn in a plot area of fixed height.
  final Widget chart;

  /// The legend shown under the chart. Omitted when null.
  final Widget? legend;

  /// Padding around the chart. Defaults to a vertical inset.
  final EdgeInsets? chartPadding;

  /// The key of the box that holds the chart and its padding.
  final Key? chartPaddingKey;

  @override
  Widget build(BuildContext context) {
    final scaledPlot = _plotHeight * UiTheme.of(context).scaling.factor;

    return UiCard(
      size: .size2,
      child: ColumnBox(
        style: FlexBoxStyler()
            .mainAxisSize(.min)
            .crossAxisAlignment(.stretch)
            .spacing(UiTokens.space4()),
        children: [
          UiCardHeading(title: title, description: description),
          Box(
            key: chartPaddingKey,
            style: BoxStyler()
                .height(scaledPlot)
                .padding(
                  EdgeInsetsGeometryMix.maybeValue(chartPadding) ??
                      .symmetric(vertical: UiTokens.space2()),
                ),
            child: chart,
          ),
          ?legend,
        ],
      ),
    );
  }
}

/// Visual swatch style for a [UiDashboardChartLegendItem].
enum UiDashboardChartLegendPattern { solid, dashed, outlined, dot }

/// Single legend item rendered in a [UiDashboardChartLegend].
@immutable
final class UiDashboardChartLegendItem {
  const UiDashboardChartLegendItem({
    required this.id,
    required this.label,
    required this.color,
    this.value,
    this.pattern = .solid,
  });

  /// Identifies the item.
  final String id;

  /// The name of the series.
  final String label;

  /// A value shown after the label, such as a percentage.
  final String? value;

  /// The swatch color.
  final Color color;

  /// The swatch shape.
  final UiDashboardChartLegendPattern pattern;

  String get displayLabel => value == null ? label : '$label $value';
}

/// Builds legend items for percentage pie/donut charts.
List<UiDashboardChartLegendItem> uiPercentagePieLegendItems({
  required List<PieSlice> slices,
  required List<Color> palette,
  UiDashboardChartLegendPattern pattern = .dot,
}) {
  assert(
    palette.length >= slices.length,
    'The palette must provide a color for every pie slice.',
  );

  return List.unmodifiable([
    for (final (index, slice) in slices.indexed)
      UiDashboardChartLegendItem(
        id: slice.id.toString(),
        label: slice.label,
        value: '${slice.value.toInt()}%',
        color: palette[index],
        pattern: pattern,
      ),
  ]);
}

/// Accessible legend row for dashboard charts.
class UiDashboardChartLegend extends StatelessWidget {
  const UiDashboardChartLegend({
    super.key,
    required this.items,
    required this.semanticLabel,
  });

  /// The items listed, in order.
  final List<UiDashboardChartLegendItem> items;

  /// The legend's accessible label.
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final itemGap = MixScope.tokenOf(UiTokens.space2, context);
    final groupGap = MixScope.tokenOf(UiTokens.space4, context);

    return Semantics(
      container: true,
      label: semanticLabel,
      child: ExcludeSemantics(
        child: WrapBox(
          style: WrapBoxStyler().spacing(groupGap).runSpacing(itemGap),
          children: [
            for (final item in items)
              RowBox(
                style: FlexBoxStyler()
                    .spacing(itemGap)
                    .mainAxisSize(.min)
                    .crossAxisAlignment(.center),
                children: [
                  _LegendMark(item),
                  Flexible(
                    child: StyledText(
                      item.displayLabel,
                      style: dashboardText(
                        .size1,
                        weight: .medium,
                        tone: .muted,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _LegendMark extends StatelessWidget {
  const _LegendMark(this.item);

  final UiDashboardChartLegendItem item;

  @override
  Widget build(BuildContext context) {
    final radius = MixScope.tokenOf(UiTokens.radius2, context).x;
    final key = ValueKey('legend-pattern-${item.id}-${item.pattern.name}');

    return switch (item.pattern) {
      .solid => Box(
        key: key,
        style: BoxStyler()
            .size(18, 4)
            .color(item.color)
            .borderRadius(.circular(radius)),
      ),
      .dashed => RowBox(
        key: key,
        style: FlexBoxStyler()
            .mainAxisSize(.min)
            .spacing(3)
            .crossAxisAlignment(.center),
        children: [
          for (var index = 0; index < 2; index++)
            Box(
              style: BoxStyler()
                  .size(7, 4)
                  .color(item.color)
                  .borderRadius(.circular(radius)),
            ),
        ],
      ),
      .outlined => Box(
        key: key,
        style: BoxStyler()
            .size(14, 14)
            .border(.color(item.color).width(2))
            .borderRadius(.circular(radius)),
      ),
      .dot => Box(
        key: key,
        style: BoxStyler()
            .size(10, 10)
            .color(item.color)
            .borderRadius(.circular(99)),
      ),
    };
  }
}
