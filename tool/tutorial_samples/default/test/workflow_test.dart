import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix_default_demo/main.dart';

void main() {
  Future<void> start(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1400, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const SampleApp());
    await tester.pumpAndSettle();
    expect(find.byType(WidgetsApp), findsOneWidget);
    expect(find.byType(MaterialApp), findsNothing);
  }

  testWidgets(
    'the form saves once while loading and keeps the entered values',
    (tester) async {
      await start(tester);
      await tester.enterText(find.byType(EditableText), 'Launchpad Studio');
      await tester.tap(find.text('Send a weekly summary'));
      await tester.tap(find.text('Save changes'));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.textContaining('Save count:'), findsNothing);
      await tester.tap(find.text('Save changes'), warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 1600));
      await tester.pumpAndSettle();
      expect(
        find.text('Saved Launchpad Studio. Save count: 1. Summary: off.'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'disabled actions stay inactive and the instance override works',
    (tester) async {
      await start(tester);
      await tester.tap(find.text('Delete workspace'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.text('ERROR: disabled action ran.'), findsNothing);
      await tester.tap(find.text('Run preview'));
      await tester.pumpAndSettle();
      expect(
        find.text(
          'Preview completed. The instance override keeps the callback.',
        ),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'the dialog returns its result and the theme changes at runtime',
    (tester) async {
      await start(tester);
      await tester.tap(find.text('Use dark theme'));
      await tester.pumpAndSettle();
      expect(find.text('Use light theme'), findsOneWidget);
      await tester.tap(find.text('Preview invitation'));
      await tester.pumpAndSettle();
      expect(find.text('Invite a teammate'), findsOneWidget);
      final title = tester.renderObject<RenderParagraph>(
        find.text('Invite a teammate'),
      );
      expect(
        title.text.style?.decoration?.contains(TextDecoration.underline) ??
            false,
        isFalse,
      );
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();
      expect(find.text('Invite a teammate'), findsNothing);
      expect(find.text('Invitation confirmed in this sample.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Sidebar changes the destination and skips the disabled destination',
    (tester) async {
      await start(tester);
      await tester.tap(find.text('Overview'));
      await tester.pumpAndSettle();
      expect(find.text('Workspace overview'), findsOneWidget);
      await tester.tap(find.text('Billing'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.text('Workspace overview'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
