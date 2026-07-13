import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mix_specimen/mix_specimen.dart';

import 'fortal_catalog.dart';

class FortalViewer extends StatefulWidget {
  const FortalViewer({super.key});

  @override
  State<FortalViewer> createState() => _FortalViewerState();
}

class _FortalViewerState extends State<FortalViewer>
    with WidgetsBindingObserver {
  late final SpecimenViewerController controller;
  bool _applyingRoute = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final uri = kIsWeb ? Uri.base : Uri();
    controller = SpecimenViewerController(
      fortalCatalog,
      specimenId: uri.queryParameters['specimen'],
      themeId: uri.queryParameters['theme'],
    )..addListener(_selectionChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _canonicalize(uri));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller
      ..removeListener(_selectionChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Future<bool> didPushRouteInformation(
    RouteInformation routeInformation,
  ) async {
    _applyUri(routeInformation.uri);
    return true;
  }

  void _applyUri(Uri uri) {
    _applyingRoute = true;
    controller.select(
      specimenId: uri.queryParameters['specimen'],
      themeId: uri.queryParameters['theme'],
    );
    _applyingRoute = false;
    _canonicalize(uri);
  }

  void _selectionChanged() {
    if (_applyingRoute || !kIsWeb) return;
    SystemNavigator.routeInformationUpdated(
      uri: _selectionUri(),
      replace: false,
    );
  }

  void _canonicalize(Uri source) {
    if (!kIsWeb) return;
    final selection = controller.selection!;
    final requestedSpecimen = source.queryParameters['specimen'];
    final requestedTheme = source.queryParameters['theme'];
    final invalid =
        (requestedSpecimen != null &&
            requestedSpecimen != selection.specimenId) ||
        (requestedTheme != null && requestedTheme != selection.themeId);
    if (invalid) {
      SystemNavigator.routeInformationUpdated(
        uri: _selectionUri(),
        replace: true,
      );
    }
  }

  Uri _selectionUri() {
    final selection = controller.selection!;
    final defaults = SpecimenViewerController(fortalCatalog).selection!;
    final query = <String, String>{};
    if (selection.specimenId != defaults.specimenId) {
      query['specimen'] = selection.specimenId;
    }
    if (selection.themeId != defaults.themeId) {
      query['theme'] = selection.themeId;
    }
    return Uri(path: '/', queryParameters: query.isEmpty ? null : query);
  }

  @override
  Widget build(BuildContext context) =>
      SpecimenCatalogViewer(catalog: fortalCatalog, controller: controller);
}
