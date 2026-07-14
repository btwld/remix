import 'dart:async';

import 'package:mix_atlas/golden.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // macOS versions can rasterize a handful of edge pixels differently while
  // preserving the rendered component. Structured capture hashes remain exact.
  AtlasGoldens.precisionTolerance = 0.0001;
  configureAtlasGoldenComparator();
  await loadAtlasFonts();
  await testMain();
}
