import 'package:flutter/material.dart';
import 'package:mix_specimen/mix_specimen.dart';

import 'fortal_catalog.dart';

/// Hosts the Fortal catalog viewer with URL-bound selection.
///
/// Uses the Router API so Flutter owns the address bar, browser history, and
/// back/forward: `?specimen=&theme=` deep links restore on load and survive
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
  final SpecimenRouterDelegate _routerDelegate = SpecimenRouterDelegate(
    fortalCatalog,
  );
  final SpecimenRouteInformationParser _routeInformationParser =
      const SpecimenRouteInformationParser();

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
class SpecimenRouteInformationParser extends RouteInformationParser<Uri> {
  const SpecimenRouteInformationParser();

  @override
  Future<Uri> parseRouteInformation(RouteInformation routeInformation) async =>
      routeInformation.uri;

  @override
  RouteInformation restoreRouteInformation(Uri configuration) =>
      RouteInformation(uri: configuration);
}

/// Binds a [SpecimenViewerController] to the browser URL.
///
/// [currentConfiguration] is the canonical `?specimen=&theme=` URL for the
/// current selection, so the Router keeps the address bar in sync (and
/// canonicalizes unknown IDs, since the controller normalizes them before this
/// runs). [setNewRoutePath] applies deep links and back/forward navigations.
class SpecimenRouterDelegate extends RouterDelegate<Uri>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<Uri> {
  SpecimenRouterDelegate(this.catalog)
    : controller = SpecimenViewerController(catalog) {
    // A freshly built controller resolves to the declared defaults; capture
    // them before any selection so the URL alone can restore full state.
    _defaults = controller.selection;
    controller.addListener(notifyListeners);
  }

  final SpecimenCatalog catalog;
  final SpecimenViewerController controller;
  late final SpecimenViewerSelection? _defaults;

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
      specimenId:
          configuration.queryParameters['specimen'] ?? _defaults?.specimenId,
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
        child: SpecimenCatalogViewer(catalog: catalog, controller: controller),
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
    if (selection.specimenId != _defaults?.specimenId) {
      query['specimen'] = selection.specimenId;
    }
    if (selection.themeId != _defaults?.themeId) {
      query['theme'] = selection.themeId;
    }
    return Uri(path: '/', queryParameters: query.isEmpty ? null : query);
  }
}
