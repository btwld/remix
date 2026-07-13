import 'package:flutter/material.dart';

import 'sheet.dart';
import 'specimen.dart';
import 'theme.dart';

@immutable
class SpecimenViewerSelection {
  const SpecimenViewerSelection({
    required this.specimenId,
    required this.themeId,
  });

  final String specimenId;
  final String themeId;

  @override
  bool operator ==(Object other) =>
      other is SpecimenViewerSelection &&
      other.specimenId == specimenId &&
      other.themeId == themeId;

  @override
  int get hashCode => Object.hash(specimenId, themeId);
}

class SpecimenViewerController extends ChangeNotifier {
  SpecimenViewerController(this.catalog, {String? specimenId, String? themeId})
    : _selection = _normalize(catalog, specimenId, themeId);

  final SpecimenCatalog catalog;
  SpecimenViewerSelection? _selection;

  SpecimenViewerSelection? get selection => _selection;

  void select({String? specimenId, String? themeId}) {
    final next = _normalize(
      catalog,
      specimenId ?? _selection?.specimenId,
      themeId ?? _selection?.themeId,
    );
    if (next == _selection) return;
    _selection = next;
    notifyListeners();
  }

  static SpecimenViewerSelection? _normalize(
    SpecimenCatalog catalog,
    String? specimenId,
    String? themeId,
  ) {
    if (catalog.specimens.isEmpty || catalog.themes.isEmpty) return null;
    final specimen = catalog.specimens.cast<Specimen?>().firstWhere(
      (item) => item!.id == specimenId,
      orElse: () => catalog.specimens.first,
    )!;
    final theme = catalog.themes.cast<SpecimenTheme?>().firstWhere(
      (item) => item!.id == themeId,
      orElse: () => catalog.themes.first,
    )!;
    return SpecimenViewerSelection(specimenId: specimen.id, themeId: theme.id);
  }
}

class SpecimenCatalogViewer extends StatefulWidget {
  const SpecimenCatalogViewer({
    super.key,
    required this.catalog,
    this.controller,
  });

  final SpecimenCatalog catalog;
  final SpecimenViewerController? controller;

  @override
  State<SpecimenCatalogViewer> createState() => _SpecimenCatalogViewerState();
}

class _SpecimenCatalogViewerState extends State<SpecimenCatalogViewer> {
  late SpecimenViewerController _controller;
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? SpecimenViewerController(widget.catalog);
    _controller.addListener(_changed);
  }

  @override
  void didUpdateWidget(covariant SpecimenCatalogViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller == widget.controller &&
        oldWidget.catalog == widget.catalog) {
      return;
    }
    _controller.removeListener(_changed);
    if (oldWidget.controller == null) _controller.dispose();
    _controller = widget.controller ?? SpecimenViewerController(widget.catalog);
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
    if (widget.catalog.specimens.isEmpty || widget.catalog.themes.isEmpty) {
      return const ColoredBox(
        color: Color(0xfff4f6f8),
        child: Center(child: Text('No specimens to display')),
      );
    }
    final selection = _controller.selection!;
    final specimen = widget.catalog.specimens.firstWhere(
      (item) => item.id == selection.specimenId,
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
                      specimen: specimen,
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
                                  child: SpecimenSheet(
                                    // Key by specimen id so switching specimens
                                    // rebuilds a fresh sheet subtree. Overlay
                                    // cells host a local Navigator whose routes
                                    // (incl. imperatively pushed dialogs) would
                                    // otherwise survive element reuse and leak
                                    // into the next specimen's cells.
                                    key: ValueKey(specimen.id),
                                    specimen: specimen,
                                    title: specimen.label ?? specimen.id,
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
  final SpecimenCatalog catalog;
  final SpecimenViewerController controller;
  final TextEditingController search;
  final ValueChanged<String> onSearch;

  @override
  Widget build(BuildContext context) {
    final query = search.text.trim().toLowerCase();
    final items = catalog.specimens.where((item) {
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
                    selected: controller.selection?.specimenId == item.id,
                    title: Text(item.label ?? item.id),
                    subtitle: Text(
                      item.id,
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                    onTap: () {
                      controller.select(specimenId: item.id);
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
    required this.specimen,
    required this.theme,
    required this.themes,
    required this.onTheme,
  });
  final Specimen specimen;
  final SpecimenTheme theme;
  final List<SpecimenTheme> themes;
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
          specimen.label ?? specimen.id,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(
          '${specimen.rows.length} rows × ${specimen.scenarios.length} scenarios = '
          '${specimen.rows.length * specimen.scenarios.length} cells',
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
class SpecimenOverlayHost extends StatelessWidget {
  const SpecimenOverlayHost({super.key, required this.child});
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
