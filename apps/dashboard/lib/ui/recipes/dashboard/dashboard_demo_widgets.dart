import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import 'dashboard_demo_artwork.dart';
import 'dashboard_demo_data.dart';
import 'dashboard_demo_text.dart';
import 'dashboard_demo_theme.dart';
import 'dashboard_demo_typography.dart';
import 'dashboard_demo_ui.dart';

/// How loudly a [UiSurface] speaks.
///
/// The preset's card has one resting look, so a page built from it alone is
/// flat: every block asks for the same attention. The dashboard settles the
/// hierarchy here, once, instead of restyling cards page by page. Ui cards
/// never cast a shadow, so emphasis comes from fill and contrast alone.
enum UiSurfaceEmphasis {
  /// The preset's surface card: a panel inside a hairline frame. The default
  /// for content of ordinary weight.
  standard,

  /// An accent wash, for supporting content that belongs to the accent: a
  /// goal, a tip, a plan.
  tinted,

  /// A faint neutral wash, for content that should recede behind its
  /// neighbours.
  quiet,

  /// The opposite appearance: a dark panel in light mode and a light one in
  /// dark mode. Reserve it for the one thing a page leads with.
  ///
  /// Everything inside resolves its tokens for that opposite appearance, so
  /// text, controls and charts keep their contrast without special cases.
  inverse,
}

/// A card at one of the dashboard's [UiSurfaceEmphasis] levels.
class UiSurface extends StatelessWidget {
  const UiSurface({
    super.key,
    this.emphasis = .standard,
    this.size = .size2,
    this.padded = true,
    required this.child,
  });

  static final _tinted = CardStyler()
      .color(UiTokens.accentA3())
      .border(.all(.color(UiTokens.accentA4())));

  static final _quiet = CardStyler()
      .color(UiTokens.grayA2())
      .border(.all(.color(UiTokens.grayA3())));

  static final _flush = CardStyler().padding(.all(0));

  /// How much attention the surface asks for.
  final UiSurfaceEmphasis emphasis;

  /// The padding and corner size, as for [UiCard].
  final UiCardSize size;

  /// Whether the surface pads its [child]. Turn it off for content that runs
  /// to the edge, such as a cover image or a table.
  final bool padded;

  /// The surface's content.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final card = UiCard(
      size: size,
      style: switch (emphasis) {
        .tinted => _tinted,
        .quiet => _quiet,
        .standard || .inverse => const CardStyler.create(),
      }.merge(padded ? null : _flush),
      child: child,
    );
    if (emphasis != .inverse) return card;

    return UiTheme(
      mode: UiTheme.of(context).isDark ? .light : .dark,
      hasBackground: false,
      child: card,
    );
  }
}

/// A [UiCard] that is one button: the whole surface takes the press, the
/// hover and the focus ring.
class UiPressableSurface extends StatelessWidget {
  const UiPressableSurface({
    super.key,
    required this.onPressed,
    required this.semanticLabel,
    this.size = .size2,
    this.padded = true,
    required this.child,
  });

  static final _flush = CardStyler().padding(.all(0));

  /// Called when the surface is activated.
  final VoidCallback onPressed;

  /// The button's accessible name.
  final String semanticLabel;

  /// The padding and corner size, as for [UiCard].
  final UiCardSize size;

  /// Whether the surface pads its [child].
  final bool padded;

  /// The surface's content. It is described by [semanticLabel], so its own
  /// text is hidden from assistive technology.
  final Widget child;

  @override
  Widget build(BuildContext context) => Pressable(
    onPress: onPressed,
    semanticsLabel: semanticLabel,
    mouseCursor: SystemMouseCursors.click,
    child: ExcludeSemantics(
      child: UiCard(
        size: size,
        style: padded ? const CardStyler.create() : _flush,
        child: child,
      ),
    ),
  );
}

/// Confirms an action with a toast. The demo has no backend, so this is how
/// every action on every page reports that it ran.
void uiDashboardToast(BuildContext context, String title) => showRemixToast(
  context,
  RemixToastData(title: title, icon: RemixIcons.checkCircle),
);

/// The title of a card, with optional supporting copy and a trailing control.
class UiCardHeader extends StatelessWidget {
  const UiCardHeader({
    super.key,
    required this.title,
    this.description,
    this.trailing,
  });

  /// The card title, published as a level-two heading.
  final String title;

  /// A line of supporting copy under the title.
  final String? description;

  /// A control at the end of the header, such as a range switch or a link.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => RowBox(
    style: FlexBoxStyler()
        .crossAxisAlignment(.start)
        .spacing(UiTokens.space3()),
    children: [
      Expanded(
        child: UiCardTitle(title: title, description: description),
      ),
      ?trailing,
    ],
  );
}

/// A card's title over its supporting copy: the text of a
/// [UiCardHeader], for a header laid out another way.
class UiCardTitle extends StatelessWidget {
  const UiCardTitle({super.key, required this.title, this.description});

  /// The card title, published as a level-two heading.
  final String title;

  /// A line of supporting copy under the title.
  final String? description;

  @override
  Widget build(BuildContext context) => ColumnBox(
    style: FlexBoxStyler()
        .mainAxisSize(.min)
        .crossAxisAlignment(.start)
        .spacing(2),
    children: [
      UiHeading(title, headingLevel: 2, size: .size3, weight: .medium),
      if (description case final description?)
        StyledText(description, style: dashboardText(.size2, tone: .muted)),
    ],
  );
}

/// A change over a period. Its sign carries the meaning; the color only
/// reinforces it: the Mar accent for good news, the error red for bad.
class UiDeltaBadge extends StatelessWidget {
  const UiDeltaBadge(this.delta, {super.key, this.positive = true});

  /// The change, such as `+12.4%`.
  final String delta;

  /// Whether the change is good news.
  final bool positive;

  @override
  Widget build(BuildContext context) {
    final badge = UiBadge(highContrast: true, label: delta);
    return positive
        ? UiAccentScope(accent: .mar, child: badge)
        : UiAccentScope.error(child: badge);
  }
}

/// A status as a badge. Its text label carries the status; the color only
/// reinforces it. Negative statuses use the dedicated error red.
class UiStatusBadge extends StatelessWidget {
  const UiStatusBadge._({super.key, required this.label, this.accent});

  factory UiStatusBadge.order(UiDashboardOrderStatus status, {Key? key}) =>
      UiStatusBadge._(
        key: key,
        label: capitalize(status.name),
        accent: switch (status) {
          .paid => .mar,
          .pending => .sol,
          .shipped => .ceu,
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
      .active => .mar,
      .invited => .ceu,
      .paused => .orla,
    },
  );

  factory UiStatusBadge.edition(UiDashboardEditionStatus status, {Key? key}) =>
      UiStatusBadge._(
        key: key,
        label: status.label,
        accent: switch (status) {
          .live => .mar,
          .lowStock => .sol,
          .soldOut => .orla,
          .draft => .ceu,
        },
      );

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

/// A headline figure with its change, trend line and optional progress.
class UiStatCard extends StatelessWidget {
  const UiStatCard({super.key, required this.metric});

  /// The figure the card reports.
  final UiDashboardMetric metric;

  @override
  Widget build(BuildContext context) => UiSurface(
    child: ColumnBox(
      style: FlexBoxStyler()
          .mainAxisSize(.min)
          .crossAxisAlignment(.stretch)
          .spacing(UiTokens.space3()),
      children: [
        RowBox(
          style: FlexBoxStyler()
              .crossAxisAlignment(.center)
              .spacing(UiTokens.space2()),
          children: [
            Expanded(
              child: StyledText(
                metric.label,
                style: dashboardTextLine(.size2, tone: .muted),
              ),
            ),
            UiDeltaBadge(metric.delta, positive: metric.positive),
          ],
        ),
        UiText(metric.value, size: .size7, weight: .bold, truncate: true),
        UiSparkline(
          values: metric.trend,
          semanticLabel: '${metric.label} trend',
        ),
        if (metric.progress case final progress?)
          UiProgress(
            value: progress,
            size: .size1,
            semanticsLabel: metric.label,
          )
        else
          StyledText(
            metric.caption,
            style: dashboardTextLine(.size1, tone: .subtle),
          ),
      ],
    ),
  );
}

/// A small trend line with a soft fill beneath it and a dot on the last
/// value.
///
/// It draws [values] in the accent's mark color unless [color] is set, sits in
/// its own layer, and repaints only when the values or the color change.
class UiSparkline extends StatelessWidget {
  const UiSparkline({
    super.key,
    required this.values,
    this.color,
    this.height = 36,
    this.semanticLabel,
  });

  /// The values to plot, oldest first.
  final List<double> values;

  /// The line color. Defaults to the accent's mark color.
  final Color? color;

  /// The height of the plot, before theme scaling.
  final double height;

  /// Names the trend for assistive technology. Hidden from it when null.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final plot = RepaintBoundary(
      child: CustomPaint(
        size: Size(
          double.infinity,
          height * UiTheme.of(context).scaling.factor,
        ),
        painter: _SparklinePainter(
          values: values,
          color: color ?? MixScope.tokenOf(UiTokens.accentIndicator, context),
        ),
      ),
    );

    return switch (semanticLabel) {
      final label? => Semantics(image: true, label: label, child: plot),
      null => ExcludeSemantics(child: plot),
    };
  }
}

class _SparklinePainter extends CustomPainter {
  const _SparklinePainter({required this.values, required this.color});

  final List<double> values;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2 || size.isEmpty) return;
    const stroke = 1.75;
    const dot = 3.0;
    final low = values.reduce(math.min);
    final span = math.max(values.reduce(math.max) - low, 1e-9);
    final plot = Rect.fromLTRB(
      stroke,
      dot,
      size.width - dot,
      size.height - stroke,
    );
    final points = [
      for (final (index, value) in values.indexed)
        Offset(
          plot.left + plot.width * index / (values.length - 1),
          plot.bottom - plot.height * (value - low) / span,
        ),
    ];

    // Each segment eases through the midpoint of its ends, so the line bends
    // without overshooting a value.
    final line = Path()..moveTo(points.first.dx, points.first.dy);
    for (var index = 1; index < points.length; index++) {
      final from = points[index - 1];
      final to = points[index];
      final middle = (from.dx + to.dx) / 2;
      line.cubicTo(middle, from.dy, middle, to.dy, to.dx, to.dy);
    }

    canvas.drawPath(
      Path.from(line)
        ..lineTo(points.last.dx, size.height)
        ..lineTo(points.first.dx, size.height)
        ..close(),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0)],
        ).createShader(Offset.zero & size),
    );
    canvas.drawPath(
      line,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.drawCircle(points.last, dot, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_SparklinePainter oldDelegate) =>
      color != oldDelegate.color || !identical(values, oldDelegate.values);
}

/// An edition's cover: its photograph when it has one, or the cover generated
/// from its motif and palette.
class UiEditionCover extends StatelessWidget {
  const UiEditionCover(this.edition, {super.key, this.described = false});

  /// The edition pictured.
  final UiDashboardEdition edition;

  /// Whether the cover names the work to assistive technology. Leave it off
  /// when the title is read from text beside the cover.
  final bool described;

  @override
  Widget build(BuildContext context) {
    final label = described ? 'Cover of ${edition.title}' : null;
    return switch (edition.image) {
      final image? => Image(
        image: image,
        fit: BoxFit.cover,
        semanticLabel: label,
        excludeFromSemantics: !described,
      ),
      null => UiArtwork(
        motif: edition.motif,
        accent: edition.accent,
        seed: edition.seed,
        semanticLabel: label,
      ),
    };
  }
}

/// A small square [UiEditionCover] for a list row or a table cell.
class UiEditionThumbnail extends StatelessWidget {
  const UiEditionThumbnail(this.edition, {super.key, this.extent = 44});

  /// The edition pictured.
  final UiDashboardEdition edition;

  /// The side of the square, before theme scaling.
  final double extent;

  @override
  Widget build(BuildContext context) {
    final side = extent * UiTheme.of(context).scaling.factor;
    return Box(
      style: BoxStyler()
          .size(side, side)
          .borderRadius(.all(UiTokens.radius3()))
          .clipBehavior(.antiAlias),
      child: UiEditionCover(edition),
    );
  }
}

/// A row of small avatars, each tinted with its member's accent. Members past
/// [limit] collapse into a count.
class UiAvatarStack extends StatelessWidget {
  const UiAvatarStack({super.key, required this.members, this.limit = 4});

  /// The people shown, in order.
  final List<UiDashboardMember> members;

  /// How many avatars to show before the rest collapse into a count.
  final int limit;

  @override
  Widget build(BuildContext context) {
    final rest = members.length - limit;
    return Semantics(
      label: members.map((member) => member.name).join(', '),
      container: true,
      child: ExcludeSemantics(
        child: RowBox(
          style: FlexBoxStyler().mainAxisSize(.min).spacing(UiTokens.space1()),
          children: [
            for (final member in members.take(limit))
              UiAccentScope(
                accent: member.accent,
                child: UiAvatar(
                  label: member.initials,
                  size: .size1,
                  fallbackLength: 2,
                ),
              ),
            if (rest > 0) UiAvatar.solid(label: '+$rest', size: .size1),
          ],
        ),
      ),
    );
  }
}

/// A row of underlined tabs that filters the list below it.
///
/// A segmented control suits two or three short options. Past that its
/// equal segments read as a strip of words, and the selected one is easy to
/// lose, so the dashboard filters longer sets with tabs: the selected filter
/// carries the accent underline in both appearances.
class UiFilterTabs<T extends Object> extends StatelessWidget {
  const UiFilterTabs({
    super.key,
    required this.values,
    required this.selected,
    required this.labelOf,
    required this.onChanged,
    required this.semanticLabel,
  });

  /// The filters, in display order.
  final List<T> values;

  /// The filter in effect.
  final T selected;

  /// The label of a filter.
  final String Function(T value) labelOf;

  /// Called with the filter the user picks.
  final ValueChanged<T> onChanged;

  /// Names the group for assistive technology.
  final String semanticLabel;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    label: semanticLabel,
    child: RemixTabs(
      selectedTabId: '${values.indexOf(selected)}',
      onChanged: (id) => onChanged(values[int.parse(id)]),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: UiTabBar(
          child: RowBox(
            style: FlexBoxStyler().mainAxisSize(.min),
            children: [
              for (final (index, value) in values.indexed)
                UiTab(tabId: '$index', label: labelOf(value)),
            ],
          ),
        ),
      ),
    ),
  );
}

/// One calendar event: its day on a tile, then what and when.
class UiEventTile extends StatelessWidget {
  const UiEventTile(this.event, {super.key, this.showKind = false});

  /// The event shown.
  final UiDashboardEvent event;

  /// Whether to end the row with the event's kind as a badge.
  final bool showKind;

  @override
  Widget build(BuildContext context) => RowBox(
    style: FlexBoxStyler()
        .crossAxisAlignment(.center)
        .spacing(UiTokens.space3()),
    children: [
      Box(
        style: BoxStyler()
            .width(44)
            .padding(.vertical(UiTokens.space1()))
            .color(UiTokens.colorPanelSolid())
            .border(.all(.color(UiTokens.gray6())))
            .borderRadius(.all(UiTokens.radius3())),
        child: ColumnBox(
          style: FlexBoxStyler().mainAxisSize(.min),
          children: [
            StyledText(
              uiDashboardMonth(event.date).toUpperCase(),
              style: dashboardText(.size1, weight: .medium, tone: .muted),
            ),
            UiText('${event.date.day}', size: .size3, weight: .bold),
          ],
        ),
      ),
      Expanded(
        child: ColumnBox(
          style: FlexBoxStyler().crossAxisAlignment(.start),
          children: [
            UiText(event.title, size: .size2, weight: .medium, truncate: true),
            StyledText(
              '${uiDashboardDay(event.date)} · ${event.time}',
              style: dashboardTextLine(.size1, tone: .muted),
            ),
          ],
        ),
      ),
      if (showKind) UiBadge.outline(label: event.kind.label),
    ],
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

/// Empty state shown when a search or filter matches nothing.
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
  Widget build(BuildContext context) => Box(
    style: BoxStyler().alignment(.center),
    child: ColumnBox(
      style: FlexBoxStyler()
          .maxWidth(340)
          .padding(.symmetric(vertical: 44, horizontal: 24))
          .mainAxisSize(.min)
          .crossAxisAlignment(.center)
          .spacing(10),
      children: [
        UiAvatar.soft(icon: icon, size: .size4),
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

/// How a [UiDashboardChartLegendItem] draws its swatch.
enum UiDashboardChartLegendPattern { solid, dashed, dot }

/// One series or slice named by a [UiDashboardChartLegend].
@immutable
final class UiDashboardChartLegendItem {
  const UiDashboardChartLegendItem({
    required this.id,
    required this.label,
    required this.color,
    this.value,
    this.pattern = .dot,
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
}

/// The key to a chart's series: one swatch, name and optional value each.
class UiDashboardChartLegend extends StatelessWidget {
  const UiDashboardChartLegend({
    super.key,
    required this.items,
    required this.semanticLabel,
    this.axis = Axis.horizontal,
  });

  /// The items listed, in order.
  final List<UiDashboardChartLegendItem> items;

  /// The legend's accessible label.
  final String semanticLabel;

  /// Whether the items wrap in a row or stack in a column with each value at
  /// the far edge.
  final Axis axis;

  @override
  Widget build(BuildContext context) {
    final rows = [for (final item in items) _row(item)];
    return Semantics(
      container: true,
      label:
          '$semanticLabel: '
          '${items.map((item) => [item.label, ?item.value].join(' ')).join(', ')}',
      child: ExcludeSemantics(
        child: axis == Axis.horizontal
            ? WrapBox(
                style: WrapBoxStyler()
                    .spacing(UiTokens.space4())
                    .runSpacing(UiTokens.space2()),
                children: rows,
              )
            : ColumnBox(
                style: FlexBoxStyler()
                    .crossAxisAlignment(.stretch)
                    .spacing(UiTokens.space2()),
                children: rows,
              ),
      ),
    );
  }

  Widget _row(UiDashboardChartLegendItem item) => RowBox(
    style: FlexBoxStyler()
        .spacing(UiTokens.space2())
        .mainAxisSize(axis == Axis.horizontal ? .min : .max)
        .crossAxisAlignment(.center),
    children: [
      _LegendMark(item),
      Flexible(
        fit: axis == Axis.horizontal ? .loose : .tight,
        child: StyledText(
          item.label,
          style: dashboardTextLine(.size1, weight: .medium, tone: .muted),
        ),
      ),
      if (item.value case final value?)
        StyledText(value, style: dashboardText(.size1, weight: .medium)),
    ],
  );
}

class _LegendMark extends StatelessWidget {
  const _LegendMark(this.item);

  final UiDashboardChartLegendItem item;

  @override
  Widget build(BuildContext context) {
    final key = ValueKey('legend-pattern-${item.id}-${item.pattern.name}');
    BoxStyler mark(double width, double height) => BoxStyler()
        .size(width, height)
        .color(item.color)
        .borderRadius(.circular(height / 2));

    return switch (item.pattern) {
      .solid => Box(key: key, style: mark(16, 4)),
      .dot => Box(key: key, style: mark(8, 8)),
      .dashed => RowBox(
        key: key,
        style: FlexBoxStyler().mainAxisSize(.min).spacing(3),
        children: [
          Box(style: mark(6, 4)),
          Box(style: mark(6, 4)),
        ],
      ),
    };
  }
}
