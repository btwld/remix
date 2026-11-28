import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

Finder _inScroll(String text) => find.descendant(
  of: find.byType(SingleChildScrollView),
  matching: find.text(text),
);

void main() {
  group('RemixDialog header', () {
    testWidgets('keeps the single column without a header or onClose', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        const SizedBox(
          width: 400,
          child: RemixDialog(
            title: 'Title',
            description: 'Description',
            scrollable: true,
            child: Text('Body'),
          ),
        ),
      );

      expect(find.byType(RemixIconButton), findsNothing);
      expect(find.byType(RowBox), findsNothing);
      expect(_inScroll('Description'), findsOneWidget);
      expect(_inScroll('Body'), findsOneWidget);
    });

    testWidgets('onClose adds a labeled close button at the header end', (
      tester,
    ) async {
      var closes = 0;
      await tester.pumpRemixApp(
        SizedBox(
          width: 400,
          child: RemixDialog(
            title: 'Title',
            description: 'Description',
            scrollable: true,
            onClose: () => closes++,
            closeLabel: 'Close dialog',
            child: const Text('Body'),
          ),
        ),
      );

      final close = find.byType(RemixIconButton);
      expect(find.bySemanticsLabel('Close dialog'), findsOneWidget);
      expect(
        tester.getTopRight(close).dx,
        tester.getTopRight(find.byType(RemixDialog)).dx,
      );
      expect(
        tester.getBottomLeft(close).dy,
        lessThanOrEqualTo(tester.getTopLeft(find.text('Body')).dy),
      );
      expect(_inScroll('Description'), findsNothing);
      expect(_inScroll('Body'), findsOneWidget);

      await tester.tap(close);
      expect(closes, 1);
    });

    testWidgets('a header style alone lays out the header and body slots', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        SizedBox(
          width: 400,
          child: RemixDialog(
            title: 'Title',
            description: 'Description',
            style: DialogStyler()
                .header(FlexBoxStyler().padding(.all(20)))
                .body(BoxStyler().padding(.all(12))),
            child: const Text('Body'),
          ),
        ),
      );

      final dialog = tester.getTopLeft(find.byType(RemixDialog));
      expect(
        tester.getTopLeft(find.text('Title')),
        dialog + const Offset(20, 20),
      );
      expect(tester.getTopLeft(find.text('Body')).dx, dialog.dx + 12);
      expect(
        tester.getTopLeft(find.text('Body')).dy,
        tester.getBottomLeft(find.text('Description')).dy + 20 + 12,
      );
      expect(find.byType(RemixIconButton), findsNothing);
    });

    testWidgets('the close button inherits DialogSpec.closeButton', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        SizedBox(
          width: 400,
          child: RemixDialog(
            title: 'Title',
            onClose: () {},
            closeLabel: 'Close dialog',
            style: DialogStyler().closeButton(IconButtonStyler().size(44, 44)),
          ),
        ),
      );

      expect(tester.getSize(find.byType(RemixIconButton)), const Size(44, 44));
    });

    testWidgets('onClose with only a child still draws the header', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        SizedBox(
          width: 400,
          child: RemixDialog(
            semanticLabel: 'Settings',
            onClose: () {},
            closeLabel: 'Close dialog',
            child: const Text('Body'),
          ),
        ),
      );

      expect(find.bySemanticsLabel('Close dialog'), findsOneWidget);
      expect(
        tester.getBottomLeft(find.byType(RemixIconButton)).dy,
        lessThanOrEqualTo(tester.getTopLeft(find.text('Body')).dy),
      );
    });
  });
}
