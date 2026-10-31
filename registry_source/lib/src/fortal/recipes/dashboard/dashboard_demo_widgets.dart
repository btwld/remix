import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../../dashboard/dashboard_demo_records.dart';
import 'dashboard_demo_page_header.dart';
import 'dashboard_demo_text.dart';
import 'dashboard_demo_theme.dart';
import 'dashboard_demo_typography.dart';
import 'dashboard_demo_ui.dart';

/// Tag row under a stat card's value: delta badge plus caption.
final fortalStatTagsStyle = WrapBoxStyler()
    .spacing(8)
    .runSpacing(6)
    .crossAxisAlignment(.center);

/// Metric card used on the Fortal dashboard overview page.
class FortalStatCard extends StatelessWidget {
  const FortalStatCard({
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
            FortalAvatar.soft(icon: resolvedIcon, size: .size2),
          ],
        ),
        FortalText(value, size: .size7, weight: .bold),
        fortalStatTagsStyle(
          children: [
            if (delta case final delta?)
              FortalAccentScope(
                accent: positive ? .mangue : .caju,
                child: FortalBadge(highContrast: true, label: delta),
              ),
            StyledText(caption, style: dashboardText(.size1, tone: .muted)),
          ],
        ),
        if (progress case final value?)
          FortalProgress(
            value: value <= 1 ? value : value / 100,
            size: .size1,
            semanticsLabel: '$label progress',
          ),
      ],
    );

    return FortalCard(size: .size2, child: column);
  }
}

/// Domain status badge rendered with a status-specific Fortal accent.
class FortalStatusBadge extends StatelessWidget {
  const FortalStatusBadge._({
    super.key,
    required this.label,
    required this.accent,
  });

  factory FortalStatusBadge.order(
    RegistryDashboardOrderStatus status, {
    Key? key,
  }) => FortalStatusBadge._(
    key: key,
    label: capitalize(status.name),
    accent: switch (status) {
      .paid => .mangue,
      .pending => .sol,
      .refunded => .caju,
      .cancelled => .calcadao,
    },
  );

  factory FortalStatusBadge.customer(
    RegistryDashboardCustomerStatus status, {
    Key? key,
  }) => FortalStatusBadge._(
    key: key,
    label: capitalize(status.name),
    accent: switch (status) {
      .active => .mangue,
      .invited => .ceu,
      .suspended => .caju,
    },
  );

  factory FortalStatusBadge.label(String status, {Key? key}) {
    final normalized = status.trim().toLowerCase();
    return FortalStatusBadge._(
      key: key,
      label: capitalize(normalized),
      accent: switch (normalized) {
        'paid' || 'active' || 'fulfilled' || 'ready' => .mangue,
        'pending' || 'processing' || 'review' => .sol,
        'refunded' || 'suspended' => .caju,
        'cancelled' => .calcadao,
        'invited' => .ceu,
        _ => .mar,
      },
    );
  }

  final String label;
  final FortalAccentColor accent;

  @override
  Widget build(BuildContext context) => FortalAccentScope(
    accent: accent,
    child: FortalBadge(highContrast: true, label: label),
  );
}

/// Compact single-line cell text for a [RemixDataTable] body cell.
class FortalDataTableCellText extends StatelessWidget {
  const FortalDataTableCellText(this.text, {super.key, this.primary = false});

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

/// Shared animation style for standalone Fortal disclosures.
const fortalDisclosureAnimationStyle = AnimationStyle(
  curve: Curves.ease,
  duration: Duration(milliseconds: 200),
  reverseDuration: Duration(milliseconds: 200),
);

/// Disclosure trigger composition with an animated rotating chevron.
class FortalDisclosureTrigger extends StatelessWidget {
  const FortalDisclosureTrigger({
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
                duration: fortalDisclosureAnimationStyle.duration!,
                curve: fortalDisclosureAnimationStyle.curve!,
              ),
            ),
        child: const StyledIcon(icon: RemixIcons.chevronDown),
      ),
    ],
  );
}

/// Action entry displayed in a [FortalActionMenu].
@immutable
class FortalAction {
  const FortalAction({
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
class FortalActionMenu extends StatelessWidget {
  const FortalActionMenu({
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

  final RemixMenuTrigger trigger;
  final List<FortalAction> actions;
  final ValueChanged<String> onSelected;
  final OverlayPositionConfig positioning;
  final double width;

  @override
  Widget build(BuildContext context) {
    final contentInset = FortalTokens.space1.resolve(context);
    final itemWidth = width - contentInset * 2;

    return FortalMenu<String>(
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

/// Positioning for a [FortalActionMenu] anchored to a data table's trailing
/// actions column.
const fortalDataTableActionsPositioning = OverlayPositionConfig(
  side: .bottom,
  alignment: .end,
  sideOffset: 4,
);

/// Kebab button shared by data-table actions columns.
RemixMenuTrigger fortalDataTableActionsTrigger(String semanticLabel) =>
    RemixMenuTrigger.control(
      builder: (_, menu) => FortalIconButton.ghost(
        icon: RemixIcons.dotsHorizontal,
        semanticLabel: semanticLabel,
        focusNode: menu.focusNode,
        onPressed: menu.toggle,
        style: IconButtonStyler().margin(.all(0)).icon(.size(18)),
      ),
    );

/// Empty state card used when search or filter queries match no rows.
class FortalEmptyState extends StatelessWidget {
  const FortalEmptyState({
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
                .color(FortalTokens.gray4())
                .shape(.circle()),
            child: StyledIcon(
              icon: icon,
              style: IconStyler().color(FortalTokens.gray9()),
            ),
          ),
          FortalHeading(
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
class FortalChartCard extends StatelessWidget {
  const FortalChartCard({
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
    final scaledPlot = _plotHeight * FortalTheme.of(context).scaling.factor;

    return FortalCard(
      size: .size2,
      child: ColumnBox(
        style: FlexBoxStyler()
            .mainAxisSize(.min)
            .crossAxisAlignment(.stretch)
            .spacing(FortalTokens.space4()),
        children: [
          FortalCardHeading(title: title, description: description),
          Box(
            key: chartPaddingKey,
            style: BoxStyler()
                .height(scaledPlot)
                .padding(
                  EdgeInsetsGeometryMix.maybeValue(chartPadding) ??
                      .symmetric(vertical: FortalTokens.space2()),
                ),
            child: chart,
          ),
          ?legend,
        ],
      ),
    );
  }
}

/// Visual swatch style for a [FortalDashboardChartLegendItem].
enum FortalDashboardChartLegendPattern { solid, dashed, outlined, dot }

/// Single legend item rendered in a [FortalDashboardChartLegend].
@immutable
final class FortalDashboardChartLegendItem {
  const FortalDashboardChartLegendItem({
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
  final FortalDashboardChartLegendPattern pattern;

  String get displayLabel => value == null ? label : '$label $value';
}

/// Builds legend items for percentage pie/donut charts.
List<FortalDashboardChartLegendItem> fortalPercentagePieLegendItems({
  required List<PieSlice> slices,
  required List<Color> palette,
  FortalDashboardChartLegendPattern pattern = .dot,
}) {
  assert(
    palette.length >= slices.length,
    'The palette must provide a color for every pie slice.',
  );

  return List.unmodifiable([
    for (final (index, slice) in slices.indexed)
      FortalDashboardChartLegendItem(
        id: slice.id.toString(),
        label: slice.label,
        value: '${slice.value.toInt()}%',
        color: palette[index],
        pattern: pattern,
      ),
  ]);
}

/// Accessible legend row for Fortal dashboard charts.
class FortalDashboardChartLegend extends StatelessWidget {
  const FortalDashboardChartLegend({
    super.key,
    required this.items,
    required this.semanticLabel,
  });

  final List<FortalDashboardChartLegendItem> items;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final itemGap = MixScope.tokenOf(FortalTokens.space2, context);
    final groupGap = MixScope.tokenOf(FortalTokens.space4, context);

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

  final FortalDashboardChartLegendItem item;

  @override
  Widget build(BuildContext context) {
    final radius = MixScope.tokenOf(FortalTokens.radius2, context).x;
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
