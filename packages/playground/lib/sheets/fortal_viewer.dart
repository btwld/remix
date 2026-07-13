import 'package:flutter/material.dart';
import 'package:mix_sheets/mix_sheets.dart';

import 'fortal_catalog.dart';

/// Hosts the Fortal catalog viewer with URL-bound selection.
///
/// Uses the Router API so Flutter owns the address bar, browser history, and
/// back/forward: `?sheet=&theme=` deep links restore on load and survive
/// reloads, selection changes push history entries, and invalid IDs
/// canonicalize. A plain `MaterialApp(home:)` would instead announce `/` to the
/// engine on its first frame — dropping deep-link query params and forcing
/// single-entry history — which the Router path avoids entirely.
class FortalViewerApp extends StatefulWidget {
  const FortalViewerApp({super.key});

  @override
  State<FortalViewerApp> createState() => _FortalViewerAppState();
}

class _FortalViewerAppState extends State<FortalViewerApp> {
  final SheetRouterDelegate _routerDelegate = SheetRouterDelegate(
    fortalCatalog,
  );
  final SheetRouteInformationParser _routeInformationParser =
      const SheetRouteInformationParser();

  @override
  void dispose() {
    _routerDelegate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    routerDelegate: _routerDelegate,
    routeInformationParser: _routeInformationParser,
    title: 'Remix Playground',
    theme: ThemeData(useMaterial3: true),
    debugShowCheckedModeBanner: false,
  );
}

/// Parses a browser location into the raw [Uri]; the delegate interprets it.
class SheetRouteInformationParser extends RouteInformationParser<Uri> {
  const SheetRouteInformationParser();

  @override
  Future<Uri> parseRouteInformation(RouteInformation routeInformation) async =>
      routeInformation.uri;

  @override
  RouteInformation restoreRouteInformation(Uri configuration) =>
      RouteInformation(uri: configuration);
}

/// Binds a [SheetCatalogController] to the browser URL.
///
/// [currentConfiguration] is the canonical `?sheet=&theme=` URL for the
/// current selection, so the Router keeps the address bar in sync (and
/// canonicalizes unknown IDs, since the controller normalizes them before this
/// runs). [setNewRoutePath] applies deep links and back/forward navigations.
class SheetRouterDelegate extends RouterDelegate<Uri>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<Uri> {
  SheetRouterDelegate(this.catalog)
    : controller = SheetCatalogController(catalog) {
    // A freshly built controller resolves to the declared defaults; capture
    // them before any selection so the URL alone can restore full state.
    _defaults = controller.selection;
    controller.addListener(notifyListeners);
  }

  final SheetCatalog catalog;
  final SheetCatalogController controller;
  late final SheetCatalogSelection? _defaults;

  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Uri get currentConfiguration => _selectionUri();

  @override
  Future<void> setNewRoutePath(Uri configuration) async {
    // The URL is authoritative: a missing param means the default, not "keep
    // the current value". Falling back to the current selection would let a
    // stale theme survive a back/forward to a URL that omits `theme`.
    controller.select(
      sheetId: configuration.queryParameters['sheet'] ?? _defaults?.sheetId,
      themeId: configuration.queryParameters['theme'] ?? _defaults?.themeId,
    );
  }

  @override
  Widget build(BuildContext context) => Navigator(
    key: navigatorKey,
    onDidRemovePage: (_) {},
    pages: [
      MaterialPage(
        key: const ValueKey('fortal-viewer'),
        child: SheetCatalogViewer(catalog: catalog, controller: controller),
      ),
    ],
  );

  @override
  void dispose() {
    controller.removeListener(notifyListeners);
    controller.dispose();
    super.dispose();
  }

  /// The canonical URL for the current selection: defaults are omitted so the
  /// home state is a bare `/`, and only non-default IDs appear as query params.
  Uri _selectionUri() {
    final selection = controller.selection!;
    final query = <String, String>{};
    if (selection.sheetId != _defaults?.sheetId) {
      query['sheet'] = selection.sheetId;
    }
    if (selection.themeId != _defaults?.themeId) {
      query['theme'] = selection.themeId;
    }
    return Uri(path: '/', queryParameters: query.isEmpty ? null : query);
  }
}
