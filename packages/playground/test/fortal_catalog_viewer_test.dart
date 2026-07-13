import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_sheets/mix_sheets.dart';
import 'package:playground/sheets/fortal_catalog.dart';
import 'package:playground/sheets/fortal_catalog_viewer.dart';
import 'package:remix/remix.dart';

void main() {
  testWidgets('uses Fortal controls to search and select a sheet', (
    tester,
  ) async {
    await _setViewport(tester, const Size(1440, 900));
    final controller = SheetCatalogController(fortalCatalog);
    addTearDown(controller.dispose);

    await tester.pumpWidget(_ViewerHarness(controller: controller));
    await tester.pump();

    expect(find.byType(RemixTextField), findsOneWidget);
    expect(find.byType(RemixToggle), findsWidgets);
    expect(find.byKey(const ValueKey('selected-sheet-title')), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('catalog-search')),
      'missing-sheet',
    );
    await tester.pump();

    expect(find.text('No sheets found'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('clear-catalog-search')));
    await tester.pump();
    expect(
      find.byKey(const ValueKey('catalog-item-accordion')),
      findsOneWidget,
    );

    await tester.enterText(
      find.byKey(const ValueKey('catalog-search')),
      'button',
    );
    await tester.pump();

    expect(find.byKey(const ValueKey('catalog-item-button')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('catalog-item-icon-button')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('catalog-item-avatar')), findsNothing);
    expect(find.text('Results'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('catalog-item-button')));
    await tester.pump();

    expect(controller.selection?.sheetId, 'button');
    expect(find.text('Button'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('supports slash, enter, escape, and clearing search', (
    tester,
  ) async {
    await _setViewport(tester, const Size(1440, 900));
    final controller = SheetCatalogController(fortalCatalog);
    addTearDown(controller.dispose);

    await tester.pumpWidget(_ViewerHarness(controller: controller));
    await tester.pump();

    await tester.sendKeyEvent(LogicalKeyboardKey.slash);
    await tester.pump();

    var editable = tester.widget<EditableText>(find.byType(EditableText));
    expect(editable.focusNode.hasFocus, isTrue);

    await tester.enterText(
      find.byKey(const ValueKey('catalog-search')),
      'button',
    );
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();

    expect(controller.selection?.sheetId, 'button');
    editable = tester.widget<EditableText>(find.byType(EditableText));
    expect(
      editable.focusNode.hasFocus,
      isTrue,
      reason: 'Submitting search should keep keyboard focus in the field.',
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();

    editable = tester.widget<EditableText>(find.byType(EditableText));
    expect(editable.controller.text, isEmpty);
    expect(find.text('Sheets'), findsOneWidget);
    expect(find.text('${fortalCatalog.sheets.length}'), findsOneWidget);
  });

  testWidgets('shows sheet details and keeps size cells on the same row', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await _setViewport(tester, const Size(1440, 900));
    final controller = SheetCatalogController(fortalCatalog, sheetId: 'badge');
    addTearDown(controller.dispose);

    await tester.pumpWidget(_ViewerHarness(controller: controller));
    await tester.pump();

    final size1 = find.byKey(const ValueKey('story-cell-default-solid-size1'));
    final size2 = find.byKey(const ValueKey('story-cell-default-solid-size2'));
    final size3 = find.byKey(const ValueKey('story-cell-default-solid-size3'));
    expect(size1, findsOneWidget);
    expect(size2, findsOneWidget);
    expect(size3, findsOneWidget);
    expect(tester.getCenter(size1).dy, tester.getCenter(size2).dy);
    expect(tester.getCenter(size2).dy, tester.getCenter(size3).dy);
    expect(tester.getTopLeft(size1).dx, lessThan(tester.getTopLeft(size2).dx));
    expect(tester.getTopLeft(size2).dx, lessThan(tester.getTopLeft(size3).dx));
    expect(
      find.bySemanticsLabel('Show sheet details, 12 cells'),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('sheet-details-trigger')));
    await tester.pump();

    final popover = find.byKey(const ValueKey('sheet-details-popover'));
    expect(popover, findsOneWidget);
    for (final label in [
      'Sheet details',
      'Scenario',
      'Variants',
      'Sizes',
      'Cells',
    ]) {
      expect(
        find.descendant(of: popover, matching: find.text(label)),
        findsOneWidget,
      );
    }
    for (final value in ['Default', '4', '3', '12']) {
      expect(
        find.descendant(of: popover, matching: find.text(value)),
        findsOneWidget,
      );
    }

    await tester.tapAt(const Offset(500, 700));
    await tester.pump();
    expect(popover, findsNothing);

    await tester.tap(find.byKey(const ValueKey('sheet-details-trigger')));
    await tester.pump();
    expect(popover, findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    expect(popover, findsNothing);
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });

  testWidgets('compact layout keeps catalog navigation available', (
    tester,
  ) async {
    await _setViewport(tester, const Size(720, 900));
    final controller = SheetCatalogController(
      fortalCatalog,
      sheetId: 'toggle',
      themeId: 'fortal-dark',
    );
    addTearDown(controller.dispose);

    await tester.pumpWidget(_ViewerHarness(controller: controller));
    await tester.pump();

    expect(find.byKey(const ValueKey('compact-catalog-rail')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('catalog-item-accordion')),
      findsOneWidget,
    );
    expect(find.text('Toggle'), findsOneWidget);
    expect(find.byKey(const ValueKey('theme-fortal-dark')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('canvas renders every declared sheet without overflow', (
    tester,
  ) async {
    await _setViewport(tester, const Size(1440, 900));
    final controller = SheetCatalogController(fortalCatalog);
    addTearDown(controller.dispose);

    await tester.pumpWidget(_ViewerHarness(controller: controller));
    await tester.pump();

    for (final sheet in fortalCatalog.sheets) {
      controller.select(sheetId: sheet.id);
      await tester.pump();
      expect(
        tester.takeException(),
        isNull,
        reason: '${sheet.id} should render without a Flutter layout exception.',
      );
      expect(find.byType(SheetView), findsNothing);
      expect(find.byKey(const ValueKey('sheet-story-canvas')), findsOneWidget);
    }

    tester.view.physicalSize = const Size(720, 900);
    await tester.pump();
    for (final sheet in fortalCatalog.sheets) {
      controller.select(sheetId: sheet.id);
      await tester.pump();
      expect(
        tester.takeException(),
        isNull,
        reason:
            '${sheet.id} should render compact without a Flutter layout exception.',
      );
    }
  });

  testWidgets('desktop light viewer matches its reference image', (
    tester,
  ) async {
    await _setViewport(tester, const Size(1440, 900));
    final controller = SheetCatalogController(fortalCatalog, sheetId: 'badge');
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _ViewerHarness(controller: controller, captureKey: _captureKey),
    );
    await tester.pump();

    await expectLater(
      find.byKey(_captureKey),
      matchesGoldenFile('viewer_goldens/fortal-viewer-desktop-light.png'),
    );
  });

  testWidgets('compact dark viewer matches its reference image', (
    tester,
  ) async {
    await _setViewport(tester, const Size(720, 900));
    final controller = SheetCatalogController(
      fortalCatalog,
      sheetId: 'toggle',
      themeId: 'fortal-dark',
    );
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _ViewerHarness(controller: controller, captureKey: _captureKey),
    );
    await tester.pump();

    await expectLater(
      find.byKey(_captureKey),
      matchesGoldenFile('viewer_goldens/fortal-viewer-compact-dark.png'),
    );
  });

  testWidgets('desktop search and details match their reference image', (
    tester,
  ) async {
    await _setViewport(tester, const Size(1440, 900));
    final controller = SheetCatalogController(fortalCatalog, sheetId: 'badge');
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _ViewerHarness(controller: controller, captureKey: _captureKey),
    );
    await tester.pump();

    await tester.enterText(
      find.byKey(const ValueKey('catalog-search')),
      'button',
    );
    final searchField = tester.widget<EditableText>(find.byType(EditableText));
    searchField.controller.selection = TextSelection.collapsed(
      offset: searchField.controller.text.length,
    );
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('sheet-details-trigger')));
    await tester.pump();

    await expectLater(
      find.byKey(_captureKey),
      matchesGoldenFile(
        'viewer_goldens/fortal-viewer-desktop-search-details-light.png',
      ),
    );
  });
}

const _captureKey = ValueKey('viewer-capture');

class _ViewerHarness extends StatelessWidget {
  const _ViewerHarness({required this.controller, this.captureKey});

  final SheetCatalogController controller;
  final Key? captureKey;

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    home: RepaintBoundary(
      key: captureKey,
      child: FortalCatalogViewer(
        catalog: fortalCatalog,
        controller: controller,
      ),
    ),
  );
}

Future<void> _setViewport(WidgetTester tester, Size size) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
}
