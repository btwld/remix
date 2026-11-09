import 'dart:ui' as ui;

import 'package:demo/main.dart';
import 'package:demo/main.directories.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgetbook/widgetbook.dart';

void main() {
  final routes = WidgetbookRoot(children: directories).leaves
      .whereType<WidgetbookUseCase>()
      .map((useCase) => useCase.path)
      .toList();

  test('generated catalog has executable routes', () {
    expect(routes, isNotEmpty);
    expect(routes.toSet(), hasLength(routes.length));
  });

  for (final path in routes) {
    testWidgets('Widgetbook route $path renders', (tester) async {
      tester.view.devicePixelRatio = 1;
      // Catalog stories intentionally show all enum combinations at once.
      tester.view.physicalSize = const Size(4000, 3000);
      addTearDown(tester.view.reset);
      if (path.contains('avatar')) await _seedAvatarImage(tester);

      await tester.pumpWidget(
        Widgetbook(
          initialRoute: Uri(
            path: '/',
            queryParameters: {'path': path, 'preview': ''},
          ).toString(),
          addons: [FortalThemeAddon()],
          appBuilder: (context, child) => child,
          directories: directories,
        ),
      );
      // Spinner and Skeleton are intentionally continuous animations.
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      final state = WidgetbookState.of(
        tester.element(find.byType(MaterialApp)),
      );
      expect(state.useCase?.path, path);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }
}

Future<void> _seedAvatarImage(WidgetTester tester) async {
  // Keep the default story's image knob while making the smoke test offline.
  final recorder = ui.PictureRecorder();
  Canvas(recorder).drawRect(const Rect.fromLTWH(0, 0, 1, 1), Paint());
  final picture = recorder.endRecording();
  final image = await tester.runAsync(() => picture.toImage(1, 1));
  picture.dispose();
  PaintingBinding.instance.imageCache.putIfAbsent(
    const NetworkImage('https://i.pravatar.cc/150?img=48'),
    () => OneFrameImageStreamCompleter(Future.value(ImageInfo(image: image!))),
  );
  addTearDown(PaintingBinding.instance.imageCache.clear);
}
