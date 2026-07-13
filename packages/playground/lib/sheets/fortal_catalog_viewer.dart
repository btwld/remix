import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mix_sheets/mix_sheets.dart';
import 'package:remix/remix.dart';

import 'fortal_sheet_canvas.dart';

/// A Fortal-native catalog shell around the generic sheet engine.
///
/// Catalog navigation belongs to the consumer package so the generic engine
/// remains independent from Remix and Fortal.
class FortalCatalogViewer extends StatefulWidget {
  const FortalCatalogViewer({
    super.key,
    required this.catalog,
    required this.controller,
  });

  final SheetCatalog catalog;
  final SheetCatalogController controller;

  @override
  State<FortalCatalogViewer> createState() => _FortalCatalogViewerState();
}

class _FortalCatalogViewerState extends State<FortalCatalogViewer> {
  static const _desktopBreakpoint = 1040.0;

  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode(debugLabel: 'Catalog search');
  bool _detailsOpen = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleSelectionChanged);
    _searchController.addListener(_handleSearchChanged);
  }

  @override
  void didUpdateWidget(covariant FortalCatalogViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller == widget.controller) return;
    oldWidget.controller.removeListener(_handleSelectionChanged);
    widget.controller.addListener(_handleSelectionChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleSelectionChanged);
    _searchController.removeListener(_handleSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _handleSelectionChanged() {
    setState(() => _detailsOpen = false);
  }

  void _handleSearchChanged() => setState(() {});

  void _focusSearch() => _searchFocusNode.requestFocus();

  void _clearSearch() {
    _searchController.clear();
    _searchFocusNode.requestFocus();
  }

  void _submitSearch(String query) {
    final results = _filterSheets(widget.catalog.sheets, query);
    if (results.isEmpty) return;
    widget.controller.select(sheetId: results.first.id);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _searchFocusNode.requestFocus();
    });
  }

  void _handleEscape() {
    if (_detailsOpen) {
      setState(() => _detailsOpen = false);
      return;
    }
    if (_searchController.text.isNotEmpty) {
      _clearSearch();
      return;
    }
    _searchFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final selection = widget.controller.selection;
    if (selection == null ||
        widget.catalog.sheets.isEmpty ||
        widget.catalog.themes.isEmpty) {
      return const ColoredBox(
        color: Color(0xfff8f9fa),
        child: Center(child: Text('No sheets to display')),
      );
    }

    final sheet = widget.catalog.sheets.firstWhere(
      (item) => item.id == selection.sheetId,
    );
    final theme = widget.catalog.themes.firstWhere(
      (item) => item.id == selection.themeId,
    );

    return theme.builder(
      context,
      Builder(
        builder: (context) {
          final background = _color(context, FortalTokens.colorBackground);
          final accent = _color(context, FortalTokens.accent9);
          return Theme(
            data: ThemeData(
              brightness: theme.brightness,
              useMaterial3: true,
              colorSchemeSeed: accent,
              scaffoldBackgroundColor: background,
              fontFamily: 'Roboto',
              splashFactory: NoSplash.splashFactory,
            ),
            child: DefaultTextStyle(
              style: TextStyle(
                color: _color(context, FortalTokens.gray12),
                fontFamily: 'Roboto',
                fontSize: 14,
                height: 1.35,
              ),
              child: CallbackShortcuts(
                bindings: {
                  const SingleActivator(LogicalKeyboardKey.slash): _focusSearch,
                  const SingleActivator(LogicalKeyboardKey.escape):
                      _handleEscape,
                },
                child: Focus(
                  autofocus: true,
                  child: ColoredBox(
                    color: background,
                    child: SafeArea(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final desktop =
                              constraints.maxWidth >= _desktopBreakpoint;
                          return desktop
                              ? _DesktopLayout(
                                  catalog: widget.catalog,
                                  controller: widget.controller,
                                  sheet: sheet,
                                  theme: theme,
                                  searchController: _searchController,
                                  searchFocusNode: _searchFocusNode,
                                  detailsOpen: _detailsOpen,
                                  onClearSearch: _clearSearch,
                                  onSubmitSearch: _submitSearch,
                                  onToggleDetails: () => setState(
                                    () => _detailsOpen = !_detailsOpen,
                                  ),
                                )
                              : _CompactLayout(
                                  catalog: widget.catalog,
                                  controller: widget.controller,
                                  sheet: sheet,
                                  theme: theme,
                                  searchController: _searchController,
                                  searchFocusNode: _searchFocusNode,
                                  detailsOpen: _detailsOpen,
                                  onClearSearch: _clearSearch,
                                  onSubmitSearch: _submitSearch,
                                  onToggleDetails: () => setState(
                                    () => _detailsOpen = !_detailsOpen,
                                  ),
                                );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({
    required this.catalog,
    required this.controller,
    required this.sheet,
    required this.theme,
    required this.searchController,
    required this.searchFocusNode,
    required this.detailsOpen,
    required this.onClearSearch,
    required this.onSubmitSearch,
    required this.onToggleDetails,
  });

  final SheetCatalog catalog;
  final SheetCatalogController controller;
  final ComponentSheet sheet;
  final SheetTheme theme;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final bool detailsOpen;
  final VoidCallback onClearSearch;
  final ValueChanged<String> onSubmitSearch;
  final VoidCallback onToggleDetails;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SizedBox(
        width: 256,
        child: _CatalogSidebar(
          catalog: catalog,
          controller: controller,
          searchController: searchController,
          searchFocusNode: searchFocusNode,
          onClearSearch: onClearSearch,
          onSubmitSearch: onSubmitSearch,
        ),
      ),
      Container(width: 1, color: _color(context, FortalTokens.gray6)),
      Expanded(
        child: _Inspector(
          sheet: sheet,
          theme: theme,
          compact: false,
          detailsOpen: detailsOpen,
          onToggleDetails: onToggleDetails,
        ),
      ),
    ],
  );
}

class _CompactLayout extends StatelessWidget {
  const _CompactLayout({
    required this.catalog,
    required this.controller,
    required this.sheet,
    required this.theme,
    required this.searchController,
    required this.searchFocusNode,
    required this.detailsOpen,
    required this.onClearSearch,
    required this.onSubmitSearch,
    required this.onToggleDetails,
  });

  final SheetCatalog catalog;
  final SheetCatalogController controller;
  final ComponentSheet sheet;
  final SheetTheme theme;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final bool detailsOpen;
  final VoidCallback onClearSearch;
  final ValueChanged<String> onSubmitSearch;
  final VoidCallback onToggleDetails;

  @override
  Widget build(BuildContext context) {
    final results = _filterSheets(catalog.sheets, searchController.text);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
          child: Row(
            children: [
              Expanded(child: _CatalogHeading(catalog: catalog, compact: true)),
              _ThemeControl(catalog: catalog, controller: controller),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: _CatalogSearch(
            controller: searchController,
            focusNode: searchFocusNode,
            onClear: onClearSearch,
            onSubmitted: onSubmitSearch,
          ),
        ),
        _CompactCatalogRail(
          catalog: catalog,
          controller: controller,
          sheets: results,
          searching: searchController.text.trim().isNotEmpty,
        ),
        Container(height: 1, color: _color(context, FortalTokens.gray6)),
        Expanded(
          child: _Inspector(
            sheet: sheet,
            theme: theme,
            compact: true,
            detailsOpen: detailsOpen,
            onToggleDetails: onToggleDetails,
          ),
        ),
      ],
    );
  }
}

class _CatalogSidebar extends StatelessWidget {
  const _CatalogSidebar({
    required this.catalog,
    required this.controller,
    required this.searchController,
    required this.searchFocusNode,
    required this.onClearSearch,
    required this.onSubmitSearch,
  });

  final SheetCatalog catalog;
  final SheetCatalogController controller;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final VoidCallback onClearSearch;
  final ValueChanged<String> onSubmitSearch;

  @override
  Widget build(BuildContext context) {
    final searching = searchController.text.trim().isNotEmpty;
    final sheets = _filterSheets(catalog.sheets, searchController.text);
    return ColoredBox(
      color: _color(context, FortalTokens.gray2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: _CatalogHeading(catalog: catalog),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: _CatalogSearch(
              controller: searchController,
              focusNode: searchFocusNode,
              onClear: onClearSearch,
              onSubmitted: onSubmitSearch,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: _NavigationHeading(
              label: searching ? 'Results' : 'Sheets',
              count: sheets.length,
            ),
          ),
          Expanded(
            child: sheets.isEmpty
                ? const _EmptySearch()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
                    itemCount: sheets.length,
                    itemBuilder: (context, index) {
                      final sheet = sheets[index];
                      final declaredIndex = catalog.sheets.indexOf(sheet);
                      return _CatalogItem(
                        sheet: sheet,
                        index: declaredIndex,
                        selected: controller.selection?.sheetId == sheet.id,
                        onPressed: () => controller.select(sheetId: sheet.id),
                      );
                    },
                  ),
          ),
          Container(height: 1, color: _color(context, FortalTokens.gray6)),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Row(
              children: [
                Text(
                  'Theme',
                  style: _textStyle(
                    color: _color(context, FortalTokens.gray11),
                    fontSize: 12,
                    weight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                _ThemeControl(catalog: catalog, controller: controller),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CatalogHeading extends StatelessWidget {
  const _CatalogHeading({required this.catalog, this.compact = false});

  final SheetCatalog catalog;
  final bool compact;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        'Components',
        style: _textStyle(
          color: _color(context, FortalTokens.gray12),
          fontSize: compact ? 16 : 18,
          weight: FontWeight.w700,
          height: 1.2,
        ),
      ),
      const SizedBox(height: 3),
      Text(
        '${catalog.sheets.length} sheets',
        style: _textStyle(
          color: _color(context, FortalTokens.gray10),
          fontSize: 11,
        ),
      ),
    ],
  );
}

class _CatalogSearch extends StatelessWidget {
  const _CatalogSearch({
    required this.controller,
    required this.focusNode,
    required this.onClear,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onClear;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) => Focus(
    onKeyEvent: (node, event) {
      if (event is! KeyDownEvent ||
          event.logicalKey != LogicalKeyboardKey.escape) {
        return KeyEventResult.ignored;
      }
      if (controller.text.isNotEmpty) {
        onClear();
      } else {
        focusNode.unfocus();
      }
      return KeyEventResult.handled;
    },
    child: SizedBox(
      height: 40,
      child: RemixTextField(
        key: const ValueKey('catalog-search'),
        style: fortalTextFieldStyle(variant: .surface, size: .size1)
            .text(TextStyler().fontFamily('Roboto'))
            .hintText(TextStyler().fontFamily('Roboto')),
        controller: controller,
        focusNode: focusNode,
        hintText: 'Search sheets',
        semanticLabel: 'Search sheets',
        textInputAction: TextInputAction.search,
        onSubmitted: onSubmitted,
        trailing: controller.text.isEmpty
            ? const _SlashShortcut()
            : FortalButton(
                key: const ValueKey('clear-catalog-search'),
                variant: .ghost,
                size: .size1,
                label: 'Clear',
                onPressed: onClear,
              ),
      ),
    ),
  );
}

class _SlashShortcut extends StatelessWidget {
  const _SlashShortcut();

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Press slash to search',
    excludeSemantics: true,
    child: Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _color(context, FortalTokens.gray3),
        border: Border.all(color: _color(context, FortalTokens.gray7)),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        '/',
        style: _textStyle(
          color: _color(context, FortalTokens.gray10),
          fontSize: 11,
          weight: FontWeight.w600,
          height: 1,
        ),
      ),
    ),
  );
}

class _NavigationHeading extends StatelessWidget {
  const _NavigationHeading({required this.label, required this.count});

  final String label;
  final int count;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Text(
        label,
        style: _textStyle(
          color: _color(context, FortalTokens.gray11),
          fontSize: 12,
          weight: FontWeight.w600,
        ),
      ),
      const Spacer(),
      Text(
        '$count',
        key: const ValueKey('catalog-results-count'),
        style: _textStyle(
          color: _color(context, FortalTokens.gray10),
          fontSize: 11,
        ),
      ),
    ],
  );
}

class _CatalogItem extends StatelessWidget {
  const _CatalogItem({
    required this.sheet,
    required this.index,
    required this.selected,
    required this.onPressed,
  });

  final ComponentSheet sheet;
  final int index;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 44,
    width: double.infinity,
    child: Stack(
      children: [
        Positioned.fill(
          child: RemixToggle(
            key: ValueKey('catalog-item-${sheet.id}'),
            selected: selected,
            onChanged: (_) => onPressed(),
            semanticLabel: '${sheet.label ?? sheet.id} sheet',
            label:
                '${(index + 1).toString().padLeft(2, '0')}  ${sheet.label ?? sheet.id}',
            style: fortalToggleStyle(size: .size2)
                .container(
                  FlexBoxStyler()
                      .mainAxisSize(.max)
                      .crossAxisAlignment(.center)
                      .borderRadiusAll(FortalTokens.radius3()),
                )
                .label(TextStyler().fontFamily('Roboto').fontSize(13)),
          ),
        ),
        if (selected)
          Positioned(
            left: 0,
            top: 10,
            child: Container(
              width: 2,
              height: 24,
              color: _color(context, FortalTokens.accent9),
            ),
          ),
      ],
    ),
  );
}

class _CompactCatalogRail extends StatelessWidget {
  const _CompactCatalogRail({
    required this.catalog,
    required this.controller,
    required this.sheets,
    required this.searching,
  });

  final SheetCatalog catalog;
  final SheetCatalogController controller;
  final List<ComponentSheet> sheets;
  final bool searching;

  @override
  Widget build(BuildContext context) {
    if (sheets.isEmpty) {
      return const SizedBox(height: 60, child: _EmptySearch(compact: true));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (searching)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
            child: _NavigationHeading(label: 'Results', count: sheets.length),
          ),
        SizedBox(
          key: const ValueKey('compact-catalog-rail'),
          height: 48,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            scrollDirection: Axis.horizontal,
            itemCount: sheets.length,
            separatorBuilder: (_, _) => const SizedBox(width: 4),
            itemBuilder: (context, index) {
              final sheet = sheets[index];
              return FortalToggle(
                key: ValueKey('catalog-item-${sheet.id}'),
                size: .size1,
                selected: controller.selection?.sheetId == sheet.id,
                onChanged: (_) => controller.select(sheetId: sheet.id),
                label: sheet.label ?? sheet.id,
                semanticLabel: '${sheet.label ?? sheet.id} sheet',
              );
            },
          ),
        ),
      ],
    );
  }
}

class _EmptySearch extends StatelessWidget {
  const _EmptySearch({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: EdgeInsets.all(compact ? 8 : 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'No sheets found',
            style: _textStyle(
              color: _color(context, FortalTokens.gray11),
              fontSize: 12,
              weight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'Try another name',
            style: _textStyle(
              color: _color(context, FortalTokens.gray9),
              fontSize: 11,
            ),
          ),
        ],
      ),
    ),
  );
}

class _ThemeControl extends StatelessWidget {
  const _ThemeControl({required this.catalog, required this.controller});

  final SheetCatalog catalog;
  final SheetCatalogController controller;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      for (var index = 0; index < catalog.themes.length; index++) ...[
        if (index > 0) const SizedBox(width: 4),
        FortalToggle(
          key: ValueKey('theme-${catalog.themes[index].id}'),
          variant: .outline,
          size: .size1,
          selected: controller.selection?.themeId == catalog.themes[index].id,
          onChanged: (_) =>
              controller.select(themeId: catalog.themes[index].id),
          label: catalog.themes[index].label ?? catalog.themes[index].id,
          semanticLabel:
              '${catalog.themes[index].label ?? catalog.themes[index].id} theme',
        ),
      ],
    ],
  );
}

class _Inspector extends StatelessWidget {
  const _Inspector({
    required this.sheet,
    required this.theme,
    required this.compact,
    required this.detailsOpen,
    required this.onToggleDetails,
  });

  final ComponentSheet sheet;
  final SheetTheme theme;
  final bool compact;
  final bool detailsOpen;
  final VoidCallback onToggleDetails;

  @override
  Widget build(BuildContext context) {
    final detailsRegion = Object();
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _InspectorHeader(
                sheet: sheet,
                compact: compact,
                detailsOpen: detailsOpen,
                detailsRegion: detailsRegion,
                onToggleDetails: onToggleDetails,
              ),
              Expanded(
                child: _SheetViewport(
                  sheet: sheet,
                  theme: theme,
                  compact: compact,
                ),
              ),
            ],
          ),
        ),
        if (detailsOpen)
          Positioned(
            key: const ValueKey('sheet-details-popover'),
            top: compact ? 74 : 82,
            right: compact ? 16 : 28,
            child: TapRegion(
              groupId: detailsRegion,
              onTapOutside: (_) => onToggleDetails(),
              child: _SheetDetailsCard(sheet: sheet),
            ),
          ),
      ],
    );
  }
}

class _InspectorHeader extends StatelessWidget {
  const _InspectorHeader({
    required this.sheet,
    required this.compact,
    required this.detailsOpen,
    required this.detailsRegion,
    required this.onToggleDetails,
  });

  final ComponentSheet sheet;
  final bool compact;
  final bool detailsOpen;
  final Object detailsRegion;
  final VoidCallback onToggleDetails;

  @override
  Widget build(BuildContext context) {
    final cells = sheet.rows.length * sheet.scenarios.length;
    return Container(
      height: compact ? 102 : 116,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 16 : 28,
        vertical: compact ? 14 : 20,
      ),
      decoration: BoxDecoration(
        color: _color(context, FortalTokens.colorBackground),
        border: Border(
          bottom: BorderSide(color: _color(context, FortalTokens.gray6)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sheet.label ?? sheet.id,
                  key: const ValueKey('selected-sheet-title'),
                  style: _textStyle(
                    color: _color(context, FortalTokens.gray12),
                    fontSize: compact ? 25 : 30,
                    weight: FontWeight.w700,
                    height: 1.1,
                    letterSpacing: compact ? -0.4 : -0.7,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _axisDescription(sheet),
                  style: _textStyle(
                    color: _color(context, FortalTokens.gray10),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          TapRegion(
            groupId: detailsRegion,
            child: RemixButton(
              key: const ValueKey('sheet-details-trigger'),
              label: '$cells cells',
              semanticLabel:
                  '${detailsOpen ? 'Hide' : 'Show'} sheet details, $cells cells',
              onPressed: onToggleDetails,
              style: fortalButtonStyle(variant: .outline, size: .size1)
                  .borderAll(
                    color: FortalTokens.gray7(),
                    width: FortalTokens.borderWidth1(),
                  )
                  .label(.color(FortalTokens.gray11()))
                  .merge(
                    detailsOpen
                        ? RemixButtonStyler()
                              .color(FortalTokens.accent3())
                              .borderAll(
                                color: FortalTokens.accent7(),
                                width: FortalTokens.borderWidth1(),
                              )
                              .label(.color(FortalTokens.accent11()))
                        : null,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetDetailsCard extends StatelessWidget {
  const _SheetDetailsCard({required this.sheet});

  final ComponentSheet sheet;

  @override
  Widget build(BuildContext context) {
    final rows = _sheetDetails(sheet);
    return Semantics(
      container: true,
      label: 'Sheet details',
      child: Container(
        width: 232,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _color(context, FortalTokens.colorBackground),
          border: Border.all(color: _color(context, FortalTokens.gray7)),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: _color(context, FortalTokens.grayA5),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Sheet details',
              style: _textStyle(
                color: _color(context, FortalTokens.gray12),
                fontSize: 13,
                weight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Container(height: 1, color: _color(context, FortalTokens.gray6)),
            const SizedBox(height: 8),
            for (final row in rows)
              SizedBox(
                height: 22,
                child: Row(
                  children: [
                    Text(
                      row.label,
                      style: _textStyle(
                        color: _color(context, FortalTokens.gray10),
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      row.value,
                      style: _textStyle(
                        color: _color(context, FortalTokens.gray12),
                        fontSize: 12,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SheetViewport extends StatelessWidget {
  const _SheetViewport({
    required this.sheet,
    required this.theme,
    required this.compact,
  });

  final ComponentSheet sheet;
  final SheetTheme theme;
  final bool compact;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: _color(context, FortalTokens.gray2),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final inset = compact ? 12.0 : 24.0;
        final available = math.max(0.0, constraints.maxWidth - (inset * 2));
        final width = math.max(
          available,
          FortalSheetCanvas.minimumWidth(sheet, compact: compact),
        );
        return SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: EdgeInsets.all(inset),
              child: SizedBox(
                width: width,
                child: FortalSheetCanvas(
                  sheet: sheet,
                  theme: theme,
                  compact: compact,
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}

List<ComponentSheet> _filterSheets(List<ComponentSheet> sheets, String query) {
  final terms = query
      .trim()
      .toLowerCase()
      .split(RegExp(r'\s+'))
      .where((term) => term.isNotEmpty)
      .toList();
  if (terms.isEmpty) return sheets;
  return sheets.where((sheet) {
    final haystack = '${sheet.id} ${sheet.label ?? ''}'.toLowerCase();
    return terms.every(haystack.contains);
  }).toList();
}

String _axisDescription(ComponentSheet sheet) {
  if (sheet.rowAxes.isEmpty) return 'Rows / Scenarios';
  return sheet.rowAxes.map((axis) => axis.label).join(' / ');
}

List<({String label, String value})> _sheetDetails(ComponentSheet sheet) {
  final result = <({String label, String value})>[];
  if (sheet.scenarios.length == 1) {
    final scenario = sheet.scenarios.first;
    result.add((
      label: 'Scenario',
      value: scenario.label ?? _humanize(scenario.id),
    ));
  } else {
    result.add((label: 'Scenarios', value: '${sheet.scenarios.length}'));
  }
  for (final axis in sheet.rowAxes) {
    final values = <String>{};
    for (final row in sheet.rows) {
      values.add(row.values[axis.id]!.id);
    }
    result.add((label: _pluralize(axis.label), value: '${values.length}'));
  }
  result.add((
    label: 'Cells',
    value: '${sheet.rows.length * sheet.scenarios.length}',
  ));
  return result;
}

String _pluralize(String value) => value.endsWith('s') ? value : '${value}s';

String _humanize(String value) => value
    .split('-')
    .where((part) => part.isNotEmpty)
    .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
    .join(' ');

Color _color(BuildContext context, ColorToken token) =>
    MixScope.tokenOf(token, context);

TextStyle _textStyle({
  required Color color,
  required double fontSize,
  FontWeight weight = FontWeight.w400,
  double height = 1.35,
  double letterSpacing = 0,
}) => TextStyle(
  color: color,
  fontFamily: 'Roboto',
  fontSize: fontSize,
  fontWeight: weight,
  height: height,
  letterSpacing: letterSpacing,
);
