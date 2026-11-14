import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../components/accordion.dart';
import '../../components/range_slider.dart';
import '../../components/toggle_group.dart';
import 'dashboard_demo_data.dart';
import 'dashboard_demo_page_header.dart';
import 'dashboard_demo_typography.dart';
import 'dashboard_demo_ui.dart';
import 'dashboard_demo_widgets.dart';
import 'dashboard_overview.dart';

/// The statuses the Collection page filters by, after everything.
enum _StatusFilter {
  all('All'),
  live('Live'),
  lowStock('Low stock'),
  soldOut('Sold out'),
  draft('Draft');

  const _StatusFilter(this.label);

  final String label;

  bool matches(UiDashboardEditionStatus status) =>
      this == all || name == status.name;
}

/// How the Collection page lays out its editions.
enum UiCollectionLayout { grid, list }

/// The Collection page: every edition as a cover card or a table row.
///
/// The featured edition leads on a wide split card. Below it, a status
/// filter, a search field and a layout switch narrow and re-present the rest.
/// Activating a card opens the edition in a dialog.
class UiDashboardCollectionPage extends StatefulWidget {
  const UiDashboardCollectionPage({
    super.key,
    this.data,
    this.searchController,
    this.filterReset,
  });

  /// The records the page shows. Defaults to [uiDashboardSampleData].
  final UiDashboardData? data;

  /// Controls the search field, so a host can fill it. The page creates its
  /// own when null.
  final TextEditingController? searchController;

  /// Notifies when the page should drop every filter but its search. A host
  /// that fills the search to show one record fires it, so a filter left on
  /// from earlier cannot hide that record.
  final Listenable? filterReset;

  @override
  State<UiDashboardCollectionPage> createState() =>
      _UiDashboardCollectionPageState();
}

class _UiDashboardCollectionPageState extends State<UiDashboardCollectionPage> {
  static final _grid = GridBoxStyler.equalColumns(4)
      .gap(uiDashboardGap)
      .onConstraints(
        const .maxWidth(1079),
        .equalColumns(3).gap(uiDashboardGap),
      )
      .onConstraints(const .maxWidth(799), .equalColumns(2).gap(uiDashboardGap))
      .onConstraints(
        const .maxWidth(499),
        .equalColumns(1).gap(uiDashboardGap),
      );

  TextEditingController? _ownSearch;
  _StatusFilter _status = .all;
  UiCollectionLayout _layout = .grid;

  /// The price range shown, as fractions of the collection's own range.
  List<double> _price = const [0, 1];

  TextEditingController get _search =>
      widget.searchController ?? (_ownSearch ??= TextEditingController());

  @override
  void initState() {
    super.initState();
    _search.addListener(_onSearchChanged);
    widget.filterReset?.addListener(_resetFilters);
  }

  @override
  void didUpdateWidget(UiDashboardCollectionPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filterReset != oldWidget.filterReset) {
      oldWidget.filterReset?.removeListener(_resetFilters);
      widget.filterReset?.addListener(_resetFilters);
    }
    if (widget.searchController == oldWidget.searchController) return;
    (oldWidget.searchController ?? _ownSearch)?.removeListener(
      _onSearchChanged,
    );
    _search.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _search.removeListener(_onSearchChanged);
    widget.filterReset?.removeListener(_resetFilters);
    _ownSearch?.dispose();
    super.dispose();
  }

  void _onSearchChanged() => setState(() {});

  void _resetFilters() => setState(() {
    _status = .all;
    _price = const [0, 1];
  });

  @override
  Widget build(BuildContext context) {
    final data = widget.data ?? uiDashboardSampleData;
    final query = _search.text.trim().toLowerCase();
    final prices = [for (final edition in data.editions) edition.price];
    final cheapest = prices.fold(double.infinity, math.min);
    final dearest = prices.fold(0.0, math.max);
    double priceAt(double fraction) =>
        prices.isEmpty ? 0 : cheapest + (dearest - cheapest) * fraction;
    final editions = [
      for (final edition in data.editions)
        if (_status.matches(edition.status) &&
            edition.price >= priceAt(_price.first) - 0.5 &&
            edition.price <= priceAt(_price.last) + 0.5 &&
            '${edition.title} ${edition.artist} ${edition.series}'
                .toLowerCase()
                .contains(query))
          edition,
    ];
    final series = {for (final edition in data.editions) edition.series};

    return UiPage(
      key: const ValueKey('dashboard-collection'),
      title: 'Collection',
      description:
          '${data.editions.length} editions across ${series.length} series.',
      actions: [
        UiButton(
          label: 'New edition',
          leadingIcon: RemixIcons.plus,
          onPressed: () => uiDashboardToast(context, 'Draft edition created'),
        ),
      ],
      children: [
        if (data.editions.isNotEmpty)
          UiEditionSpotlight(
            edition: data.editions.first,
            onPressed: () => showUiEditionDialog(context, data.editions.first),
          ),
        WrapBox(
          style: WrapBoxStyler()
              .wrapAlignment(.spaceBetween)
              .crossAxisAlignment(.center)
              .spacing(UiTokens.space3())
              .runSpacing(UiTokens.space3()),
          children: [
            UiFilterTabs<_StatusFilter>(
              key: const ValueKey('collection-status'),
              semanticLabel: 'Filter editions by status',
              values: _StatusFilter.values,
              selected: _status,
              labelOf: (status) => status.label,
              onChanged: (status) => setState(() => _status = status),
            ),
            WrapBox(
              style: WrapBoxStyler()
                  .crossAxisAlignment(.center)
                  .spacing(UiTokens.space3())
                  .runSpacing(UiTokens.space3()),
              children: [
                Box(
                  style: BoxStyler().width(240),
                  child: UiTextField(
                    key: const ValueKey('collection-search'),
                    controller: _search,
                    leading: const StyledIcon(icon: RemixIcons.search),
                    hintText: 'Search editions…',
                    semanticLabel: 'Search editions',
                  ),
                ),
                UiToggleGroup<UiCollectionLayout>(
                  key: const ValueKey('collection-layout'),
                  semanticLabel: 'Collection layout',
                  selectedValue: _layout,
                  items: const [
                    RemixToggleGroupItem(value: .grid, label: 'Grid'),
                    RemixToggleGroupItem(value: .list, label: 'List'),
                  ],
                  onChanged: (layout) {
                    if (layout != null) setState(() => _layout = layout);
                  },
                ),
              ],
            ),
          ],
        ),
        if (prices.length > 1)
          RowBox(
            key: const ValueKey('collection-price'),
            style: FlexBoxStyler()
                .crossAxisAlignment(.center)
                .spacing(UiTokens.space4()),
            children: [
              StyledText(
                'Price',
                style: dashboardText(.size2, weight: .medium),
              ),
              Flexible(
                child: Box(
                  style: BoxStyler().maxWidth(320),
                  child: UiRangeSlider(
                    values: _price,
                    snapDivisions: 13,
                    semanticLabels: const ['Lowest price', 'Highest price'],
                    onChanged: (values) => setState(() => _price = values),
                  ),
                ),
              ),
              Flexible(
                child: StyledText(
                  '${uiDashboardCurrency(priceAt(_price.first), cents: false)}'
                  ' – '
                  '${uiDashboardCurrency(priceAt(_price.last), cents: false)}',
                  style: dashboardTextLine(.size2, tone: .muted),
                ),
              ),
            ],
          ),
        if (editions.isEmpty)
          UiSurface(
            emphasis: .quiet,
            child: UiEmptyState(
              icon: RemixIcons.search,
              title: 'No editions found',
              body: 'Try another title, artist, status or price.',
              action: UiButton.soft(
                size: .size1,
                label: 'Clear filters',
                onPressed: () {
                  _search.clear();
                  setState(() {
                    _status = .all;
                    _price = const [0, 1];
                  });
                },
              ),
            ),
          )
        else if (_layout == .grid)
          GridBox(
            key: const ValueKey('collection-grid'),
            style: _grid,
            children: [
              for (final edition in editions)
                UiEditionCard(
                  key: ValueKey('edition-${edition.id}'),
                  edition: edition,
                  onPressed: () => showUiEditionDialog(context, edition),
                ),
            ],
          )
        else
          UiEditionTable(
            editions: editions,
            onOpen: (edition) => showUiEditionDialog(context, edition),
          ),
      ],
    );
  }
}

/// The featured edition on a wide card: its cover on one side, its story and
/// sales on the other. They stack when the card is narrow.
class UiEditionSpotlight extends StatelessWidget {
  const UiEditionSpotlight({
    super.key,
    required this.edition,
    required this.onPressed,
  });

  static final _split = GridBoxStyler.columns(const [
    .fr(5),
    .fr(6),
  ]).onConstraints(const .maxWidth(719), .equalColumns(1));

  /// The edition featured.
  final UiDashboardEdition edition;

  /// Called when the user asks for the edition's details.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => UiSurface(
    key: const ValueKey('collection-spotlight'),
    size: .size3,
    padded: false,
    child: GridBox(
      style: _split,
      children: [
        Stack(
          children: [
            SizedBox(height: 260 * UiTheme.of(context).scaling.factor),
            Positioned.fill(child: UiEditionCover(edition, described: true)),
          ],
        ),
        Box(
          style: BoxStyler().padding(.all(UiTokens.space5())),
          child: ColumnBox(
            style: FlexBoxStyler()
                .crossAxisAlignment(.start)
                .spacing(UiTokens.space4()),
            children: [
              ColumnBox(
                style: FlexBoxStyler()
                    .crossAxisAlignment(.start)
                    .spacing(UiTokens.space2()),
                children: [
                  WrapBox(
                    style: WrapBoxStyler()
                        .spacing(UiTokens.space2())
                        .runSpacing(UiTokens.space2()),
                    children: [
                      const UiBadge.solid(label: 'Featured'),
                      UiStatusBadge.edition(edition.status),
                    ],
                  ),
                  UiHeading(
                    edition.title,
                    headingLevel: 2,
                    size: .size7,
                    weight: .bold,
                  ),
                  StyledText(
                    edition.description,
                    style: dashboardText(.size3, tone: .muted),
                  ),
                ],
              ),
              UiDataList(
                size: .size1,
                semanticLabel: '${edition.title} details',
                items: [
                  RemixDataListItem(label: 'Artist', value: edition.artist),
                  RemixDataListItem(label: 'Format', value: edition.format),
                  RemixDataListItem(
                    label: 'Price',
                    value: uiDashboardCurrency(edition.price, cents: false),
                  ),
                ],
              ),
              UiEditionProgress(edition),
              WrapBox(
                style: WrapBoxStyler()
                    .spacing(UiTokens.space2())
                    .runSpacing(UiTokens.space2()),
                children: [
                  UiButton(
                    key: const ValueKey('collection-spotlight-open'),
                    label: 'View edition',
                    onPressed: onPressed,
                  ),
                  UiButton.soft(
                    label: 'Share',
                    onPressed: () => uiDashboardToast(
                      context,
                      'Link to ${edition.title} copied',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

/// How much of an edition has sold: a bar, and the count beside what is left.
class UiEditionProgress extends StatelessWidget {
  const UiEditionProgress(this.edition, {super.key});

  /// The edition measured.
  final UiDashboardEdition edition;

  @override
  Widget build(BuildContext context) => ColumnBox(
    style: FlexBoxStyler()
        .mainAxisSize(.min)
        .crossAxisAlignment(.stretch)
        .spacing(UiTokens.space2()),
    children: [
      UiProgress(
        value: edition.soldFraction,
        size: .size1,
        semanticsLabel: '${edition.title} edition sold',
      ),
      RowBox(
        children: [
          Expanded(
            child: StyledText(
              '${edition.sold} of ${edition.editionSize} sold',
              style: dashboardTextLine(.size1, tone: .muted),
            ),
          ),
          StyledText(
            edition.remaining == 0 ? 'None left' : '${edition.remaining} left',
            style: dashboardText(.size1, tone: .subtle),
          ),
        ],
      ),
    ],
  );
}

/// One edition as a cover card. The whole card is a button.
class UiEditionCard extends StatelessWidget {
  const UiEditionCard({
    super.key,
    required this.edition,
    required this.onPressed,
  });

  /// The edition shown.
  final UiDashboardEdition edition;

  /// Called when the card is activated.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final inset = UiTokens.space2.resolve(context);
    return UiPressableSurface(
      onPressed: onPressed,
      semanticLabel:
          '${edition.title} by ${edition.artist}, '
          '${uiDashboardCurrency(edition.price, cents: false)}, '
          '${edition.status.label}, '
          '${edition.sold} of ${edition.editionSize} sold',
      padded: false,
      child: ColumnBox(
        style: FlexBoxStyler().crossAxisAlignment(.stretch),
        children: [
          AspectRatio(
            aspectRatio: 4 / 3,
            child: Stack(
              fit: StackFit.expand,
              children: [
                UiEditionCover(edition),
                PositionedDirectional(
                  top: inset,
                  start: inset,
                  child: UiStatusBadge.edition(edition.status),
                ),
              ],
            ),
          ),
          Box(
            style: BoxStyler().padding(.all(UiTokens.space3())),
            child: ColumnBox(
              style: FlexBoxStyler()
                  .crossAxisAlignment(.stretch)
                  .spacing(UiTokens.space3()),
              children: [
                RowBox(
                  style: FlexBoxStyler()
                      .crossAxisAlignment(.start)
                      .spacing(UiTokens.space2()),
                  children: [
                    Expanded(
                      child: ColumnBox(
                        style: FlexBoxStyler().crossAxisAlignment(.start),
                        children: [
                          UiText(
                            edition.title,
                            size: .size3,
                            weight: .medium,
                            truncate: true,
                          ),
                          StyledText(
                            '${edition.artist} · ${edition.series}',
                            style: dashboardTextLine(.size1, tone: .muted),
                          ),
                        ],
                      ),
                    ),
                    UiText(
                      uiDashboardCurrency(edition.price, cents: false),
                      size: .size3,
                      weight: .medium,
                    ),
                  ],
                ),
                UiEditionProgress(edition),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The collection as a table, one edition per row.
class UiEditionTable extends StatelessWidget {
  const UiEditionTable({
    super.key,
    required this.editions,
    required this.onOpen,
  });

  /// The editions listed.
  final List<UiDashboardEdition> editions;

  /// Called with the edition whose row asks to be opened.
  final ValueChanged<UiDashboardEdition> onOpen;

  @override
  Widget build(BuildContext context) => UiDataTable<UiDashboardEdition>.surface(
    key: const ValueKey('collection-table'),
    semanticLabel: 'Editions',
    rows: editions,
    minimumWidth: 860,
    columns: [
      RemixDataTableColumn(
        id: 'edition',
        label: 'Edition',
        width: const FlexColumnWidth(3),
        cellBuilder: (_, edition) => RowBox(
          style: FlexBoxStyler()
              .crossAxisAlignment(.center)
              .spacing(UiTokens.space3()),
          children: [
            UiEditionThumbnail(edition, extent: 36),
            Flexible(child: UiDataTableCellText(edition.title, primary: true)),
          ],
        ),
      ),
      RemixDataTableColumn(
        id: 'artist',
        label: 'Artist',
        width: const FlexColumnWidth(2),
        cellBuilder: (_, edition) => UiDataTableCellText(edition.artist),
      ),
      RemixDataTableColumn(
        id: 'price',
        label: 'Price',
        width: const FixedColumnWidth(96),
        alignment: AlignmentDirectional.centerEnd,
        cellBuilder: (_, edition) => UiDataTableCellText(
          uiDashboardCurrency(edition.price, cents: false),
          primary: true,
        ),
      ),
      RemixDataTableColumn(
        id: 'sold',
        label: 'Sold',
        width: const FixedColumnWidth(180),
        cellBuilder: (_, edition) => RowBox(
          style: FlexBoxStyler()
              .crossAxisAlignment(.center)
              .spacing(UiTokens.space2()),
          children: [
            Expanded(
              child: UiProgress(
                value: edition.soldFraction,
                size: .size1,
                semanticsLabel: '${edition.title} edition sold',
              ),
            ),
            UiDataTableCellText('${edition.sold}/${edition.editionSize}'),
          ],
        ),
      ),
      RemixDataTableColumn(
        id: 'status',
        label: 'Status',
        width: const FixedColumnWidth(116),
        cellBuilder: (_, edition) => UiStatusBadge.edition(edition.status),
      ),
      RemixDataTableColumn(
        id: 'actions',
        header: const SizedBox.shrink(),
        semanticLabel: 'Actions',
        width: const FixedColumnWidth(64),
        alignment: AlignmentDirectional.centerEnd,
        cellBuilder: (context, edition) => UiActionMenu(
          key: ValueKey('edition-actions-${edition.id}'),
          positioning: uiDataTableActionsPositioning,
          trigger: uiDataTableActionsTrigger('Actions for ${edition.title}'),
          actions: const [
            UiAction(value: 'view', label: 'View edition'),
            UiAction(value: 'duplicate', label: 'Duplicate'),
            UiAction(value: 'archive', label: 'Archive', dividerBefore: true),
          ],
          onSelected: (value) => value == 'view'
              ? onOpen(edition)
              : uiDashboardToast(
                  context,
                  '$value selected for ${edition.title}',
                ),
        ),
      ),
    ],
  );
}

/// Opens [edition] in a dialog: its cover, its story and its numbers.
Future<void> showUiEditionDialog(
  BuildContext context,
  UiDashboardEdition edition,
) => showRemixDialog<void>(
  context: context,
  barrierLabel: 'Dismiss',
  builder: (context) => UiDialog(
    key: const ValueKey('edition-dialog'),
    title: edition.title,
    description: '${edition.artist} · ${edition.series}',
    scrollable: true,
    actions: [
      UiButton.soft(
        label: 'Close',
        onPressed: () => Navigator.of(context).pop(),
      ),
      UiButton(
        label: 'Edit edition',
        onPressed: () {
          Navigator.of(context).pop();
          uiDashboardToast(context, 'Editing ${edition.title}');
        },
      ),
    ],
    child: ColumnBox(
      style: FlexBoxStyler()
          .mainAxisSize(.min)
          .crossAxisAlignment(.stretch)
          .spacing(UiTokens.space4()),
      children: [
        Box(
          style: BoxStyler()
              .borderRadius(.all(UiTokens.radius3()))
              .clipBehavior(.antiAlias),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: UiEditionCover(edition, described: true),
          ),
        ),
        StyledText(
          edition.description,
          style: dashboardText(.size2, tone: .muted),
        ),
        UiEditionProgress(edition),
        const _EditionNotes(),
        UiDataList(
          size: .size1,
          semanticLabel: '${edition.title} details',
          items: [
            RemixDataListItem(label: 'Format', value: edition.format),
            RemixDataListItem(
              label: 'Price',
              value: uiDashboardCurrency(edition.price, cents: false),
            ),
            RemixDataListItem(
              label: 'Revenue',
              value: uiDashboardCurrency(edition.revenue, cents: false),
            ),
            RemixDataListItem(label: 'Status', value: edition.status.label),
          ],
        ),
      ],
    ),
  ),
);

/// What every edition shares, folded away until asked for.
class _EditionNotes extends StatefulWidget {
  const _EditionNotes();

  @override
  State<_EditionNotes> createState() => _EditionNotesState();
}

class _EditionNotesState extends State<_EditionNotes> {
  final _controller = RemixAccordionController<String>(min: 0, max: 1);

  static const _notes = [
    (
      'signing',
      'Signed and numbered',
      'Each print is signed and numbered by the artist, with a certificate.',
    ),
    (
      'shipping',
      'Shipping',
      'Rolled in a tube within five working days, tracked worldwide.',
    ),
    ('care', 'Care', 'Frame behind UV glass and keep out of direct sun.'),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => RemixAccordionGroup(
    controller: _controller,
    child: ColumnBox(
      style: FlexBoxStyler()
          .crossAxisAlignment(.stretch)
          .spacing(UiTokens.space2()),
      children: [
        for (final (value, title, body) in _notes)
          UiAccordion<String>(
            value: value,
            title: title,
            child: StyledText(body, style: dashboardText(.size2, tone: .muted)),
          ),
      ],
    ),
  );
}
