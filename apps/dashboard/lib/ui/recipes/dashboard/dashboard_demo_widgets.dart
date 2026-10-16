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

/// Metric card used on the Ui dashboard overview page.
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

  final String label;
  final String value;
  final String caption;
  final String? delta;
  final bool positive;
  final IconData? icon;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    final resolvedIcon =
        icon ??
        switch (label) {
          'Revenue' => RemixIcons.barChart,
          'Active customers' => RemixIcons.person,
          'Open orders' => RemixIcons.box,
          'Fulfillment' => RemixIcons.activityLog,
          _ => RemixIcons.activityLog,
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
        WrapBox(
          style: WrapBoxStyler()
              .spacing(8)
              .runSpacing(6)
              .crossAxisAlignment(.center),
          children: [
            if (delta case final delta?)
              UiAccentScope(
                accent: positive ? .green : .red,
                child: UiBadge(highContrast: true, label: delta),
              ),
            StyledText(caption, style: dashboardText(.size1, tone: .muted)),
          ],
        ),
        if (progress case final value?)
          UiProgress(
            value: value <= 1 ? value : value / 100,
            size: .size1,
            semanticsLabel: '$label progress',
          ),
      ],
    );

    return UiCard(size: .size2, child: column);
  }
}

/// Domain status badge rendered with a status-specific Ui accent.
class UiStatusBadge extends StatelessWidget {
  const UiStatusBadge._({super.key, required this.label, required this.accent});

  factory UiStatusBadge.order(UiDashboardOrderStatus status, {Key? key}) =>
      UiStatusBadge._(
        key: key,
        label: capitalize(status.name),
        accent: switch (status) {
          .paid => .green,
          .pending => .amber,
          .refunded => .red,
          .cancelled => .gray,
        },
      );

  factory UiStatusBadge.customer(
    UiDashboardCustomerStatus status, {
    Key? key,
  }) => UiStatusBadge._(
    key: key,
    label: capitalize(status.name),
    accent: switch (status) {
      .active => .green,
      .invited => .blue,
      .suspended => .red,
    },
  );

  factory UiStatusBadge.label(String status, {Key? key}) {
    final normalized = status.trim().toLowerCase();
    return UiStatusBadge._(
      key: key,
      label: capitalize(normalized),
      accent: switch (normalized) {
        'paid' || 'active' || 'fulfilled' || 'ready' => .green,
        'pending' || 'processing' || 'review' => .amber,
        'refunded' || 'suspended' => .red,
        'cancelled' => .gray,
        'invited' => .blue,
        _ => .indigo,
      },
    );
  }

  final String label;
  final UiAccentColor accent;

  @override
  Widget build(BuildContext context) => UiAccentScope(
    accent: accent,
    child: UiBadge(highContrast: true, label: label),
  );
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

  final String text;
  final bool primary;

  @override
  Widget build(BuildContext context) =>
      StyledText(text, style: primary ? _primary : _secondary);
}

/// Shared animation style for standalone Ui disclosures.
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

  final bool expanded;
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

  final String value;
  final String label;
  final bool dividerBefore;
}

/// Action menu for dashboard triggers such as avatars, account rows, and
/// data-table kebab menus.
class UiActionMenu extends StatelessWidget {
  const UiActionMenu({
    super.key,
    required this.semanticLabel,
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

  final String semanticLabel;
  final Widget trigger;
  final List<UiAction> actions;
  final ValueChanged<String> onSelected;
  final OverlayPositionConfig positioning;
  final double width;

  @override
  Widget build(BuildContext context) {
    final contentInset = UiTokens.space1.resolve(context);
    final itemWidth = width - contentInset * 2;

    return UiMenu<String>(
      size: .size1,
      positioning: positioning,
      trigger: RemixMenuTrigger.builder(
        label: semanticLabel,
        builder: (_, _, _) => trigger,
      ),
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

/// Compact kebab trigger shared by data-table actions columns.
final uiDataTableActionsTrigger = Box(
  style: BoxStyler().padding(.all(6)),
  child: StyledIcon(
    icon: RemixIcons.dotsHorizontal,
    style: IconStyler().size(18),
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

  final IconData icon;
  final String title;
  final String body;
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

  final String title;
  final String description;
  final Widget chart;
  final Widget? legend;
  final EdgeInsets? chartPadding;
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

  final String id;
  final String label;
  final String? value;
  final Color color;
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

/// Accessible legend row for Ui dashboard charts.
class UiDashboardChartLegend extends StatelessWidget {
  const UiDashboardChartLegend({
    super.key,
    required this.items,
    required this.semanticLabel,
  });

  final List<UiDashboardChartLegendItem> items;
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
