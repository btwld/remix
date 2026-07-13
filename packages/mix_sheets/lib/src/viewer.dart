import 'package:flutter/material.dart';

import 'component_sheet.dart';
import 'sheet_view.dart';
import 'theme.dart';

@immutable
class SheetCatalogSelection {
  const SheetCatalogSelection({required this.sheetId, required this.themeId});

  final String sheetId;
  final String themeId;

  @override
  bool operator ==(Object other) =>
      other is SheetCatalogSelection &&
      other.sheetId == sheetId &&
      other.themeId == themeId;

  @override
  int get hashCode => Object.hash(sheetId, themeId);
}

class SheetCatalogController extends ChangeNotifier {
  SheetCatalogController(this.catalog, {String? sheetId, String? themeId})
    : _selection = _normalize(catalog, sheetId, themeId);

  final SheetCatalog catalog;
  SheetCatalogSelection? _selection;

  SheetCatalogSelection? get selection => _selection;

  void select({String? sheetId, String? themeId}) {
    final next = _normalize(
      catalog,
      sheetId ?? _selection?.sheetId,
      themeId ?? _selection?.themeId,
    );
    if (next == _selection) return;
    _selection = next;
    notifyListeners();
  }

  static SheetCatalogSelection? _normalize(
    SheetCatalog catalog,
    String? sheetId,
    String? themeId,
  ) {
    if (catalog.sheets.isEmpty || catalog.themes.isEmpty) return null;
    final sheet = catalog.sheets.cast<ComponentSheet?>().firstWhere(
      (item) => item!.id == sheetId,
      orElse: () => catalog.sheets.first,
    )!;
    final theme = catalog.themes.cast<SheetTheme?>().firstWhere(
      (item) => item!.id == themeId,
      orElse: () => catalog.themes.first,
    )!;
    return SheetCatalogSelection(sheetId: sheet.id, themeId: theme.id);
  }
}

class SheetCatalogViewer extends StatefulWidget {
  const SheetCatalogViewer({super.key, required this.catalog, this.controller});

  final SheetCatalog catalog;
  final SheetCatalogController? controller;

  @override
  State<SheetCatalogViewer> createState() => _SheetCatalogViewerState();
}

class _SheetCatalogViewerState extends State<SheetCatalogViewer> {
  late SheetCatalogController _controller;
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? SheetCatalogController(widget.catalog);
    _controller.addListener(_changed);
  }

  @override
  void didUpdateWidget(covariant SheetCatalogViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller == widget.controller &&
        oldWidget.catalog == widget.catalog) {
      return;
    }
    _controller.removeListener(_changed);
    if (oldWidget.controller == null) _controller.dispose();
    _controller = widget.controller ?? SheetCatalogController(widget.catalog);
    _controller.addListener(_changed);
  }

  void _changed() => setState(() {});

  @override
  void dispose() {
    _controller.removeListener(_changed);
    if (widget.controller == null) _controller.dispose();
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.catalog.sheets.isEmpty || widget.catalog.themes.isEmpty) {
      return const ColoredBox(
        color: Color(0xfff4f6f8),
        child: Center(child: Text('No sheets to display')),
      );
    }
    final selection = _controller.selection!;
    final sheet = widget.catalog.sheets.firstWhere(
      (item) => item.id == selection.sheetId,
    );
    final theme = widget.catalog.themes.firstWhere(
      (item) => item.id == selection.themeId,
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 800;
        final sidebar = _Sidebar(
          catalog: widget.catalog,
          controller: _controller,
          search: _search,
          onSearch: (_) => setState(() {}),
        );
        return Scaffold(
          backgroundColor: const Color(0xffeef1f5),
          drawer: wide ? null : Drawer(child: SafeArea(child: sidebar)),
          appBar: AppBar(
            backgroundColor: const Color(0xff202733),
            foregroundColor: Colors.white,
            title: Text(widget.catalog.label ?? widget.catalog.id),
          ),
          body: Row(
            children: [
              if (wide) SizedBox(width: 280, child: sidebar),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _InspectorHeader(
                      sheet: sheet,
                      theme: theme,
                      themes: widget.catalog.themes,
                      onTheme: (id) => _controller.select(themeId: id),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: theme.builder(
                            context,
                            ColoredBox(
                              color: theme.background,
                              child: Padding(
                                padding: const EdgeInsets.all(32),
                                child: IgnorePointer(
                                  child: SheetView(
                                    // Key by sheet id so switching sheets
                                    // rebuilds a fresh sheet subtree. Overlay
                                    // cells host a local Navigator whose routes
                                    // (incl. imperatively pushed dialogs) would
                                    // otherwise survive element reuse and leak
                                    // into the next sheet's cells.
                                    key: ValueKey(sheet.id),
                                    sheet: sheet,
                                    title: sheet.label ?? sheet.id,
                                    labelColor:
                                        theme.brightness == Brightness.dark
                                        ? const Color(0x99ffffff)
                                        : const Color(0x99000000),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.catalog,
    required this.controller,
    required this.search,
    required this.onSearch,
  });
  final SheetCatalog catalog;
  final SheetCatalogController controller;
  final TextEditingController search;
  final ValueChanged<String> onSearch;

  @override
  Widget build(BuildContext context) {
    final query = search.text.trim().toLowerCase();
    final items = catalog.sheets.where((item) {
      return item.id.toLowerCase().contains(query) ||
          (item.label ?? '').toLowerCase().contains(query);
    }).toList();
    return Material(
      color: const Color(0xfff8fafc),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: search,
              onChanged: onSearch,
              decoration: const InputDecoration(
                labelText: 'Search components',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                for (final item in items)
                  ListTile(
                    selected: controller.selection?.sheetId == item.id,
                    title: Text(item.label ?? item.id),
                    subtitle: Text(
                      item.id,
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                    onTap: () {
                      controller.select(sheetId: item.id);
                      if (Scaffold.maybeOf(context)?.hasDrawer ?? false) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InspectorHeader extends StatelessWidget {
  const _InspectorHeader({
    required this.sheet,
    required this.theme,
    required this.themes,
    required this.onTheme,
  });
  final ComponentSheet sheet;
  final SheetTheme theme;
  final List<SheetTheme> themes;
  final ValueChanged<String> onTheme;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(20),
    child: Wrap(
      spacing: 24,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          sheet.label ?? sheet.id,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(
          '${sheet.rows.length} rows × ${sheet.scenarios.length} scenarios = '
          '${sheet.rows.length * sheet.scenarios.length} cells',
          style: const TextStyle(fontFamily: 'monospace'),
        ),
        DropdownButton<String>(
          value: theme.id,
          onChanged: (value) {
            if (value != null) onTheme(value);
          },
          items: [
            for (final item in themes)
              DropdownMenuItem(
                value: item.id,
                child: Text(item.label ?? item.id),
              ),
          ],
        ),
      ],
    ),
  );
}

/// A local Navigator and Overlay that keeps component overlays inside its box.
class SheetOverlayHost extends StatelessWidget {
  const SheetOverlayHost({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => ClipRect(
    child: Navigator(
      onGenerateRoute: (_) => PageRouteBuilder<void>(
        opaque: false,
        barrierColor: Colors.transparent,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, animation, secondaryAnimation) =>
            Material(type: MaterialType.transparency, child: child),
      ),
    ),
  );
}
