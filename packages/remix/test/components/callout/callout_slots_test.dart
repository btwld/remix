import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('RemixCallout title and dismiss', () {
    testWidgets('stacks the title over the text, aligned to the start', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        RemixCallout(
          title: 'Update available',
          text: 'Restart to finish installing a much longer description.',
          style: CalloutStyler()
              .title(TextStyler().fontSize(20))
              .content(FlexBoxStyler().spacing(6)),
        ),
      );

      final title = tester.getRect(find.text('Update available'));
      final text = tester.getRect(
        find.text('Restart to finish installing a much longer description.'),
      );
      expect(title.left, text.left);
      expect(text.top, title.bottom + 6);
      expect(
        tester.widget<Text>(find.text('Update available')).style?.fontSize,
        20,
      );
    });

    testWidgets('a title alone renders without text', (tester) async {
      await tester.pumpRemixApp(const RemixCallout(title: 'Saved'));

      expect(find.text('Saved'), findsOneWidget);
      expect(find.byType(StyledText), findsOneWidget);
    });

    testWidgets('onDismiss ends the row with a labeled close button', (
      tester,
    ) async {
      var dismissals = 0;
      await tester.pumpRemixApp(
        SizedBox(
          width: 300,
          child: RemixCallout(
            icon: Icons.info,
            text: 'Heads up',
            onDismiss: () => dismissals++,
            dismissLabel: 'Dismiss callout',
            style: CalloutStyler().closeButton(IconButtonStyler().size(28, 28)),
          ),
        ),
      );

      final close = find.byType(RemixIconButton);
      expect(find.bySemanticsLabel('Dismiss callout'), findsOneWidget);
      expect(tester.getSize(close), const Size(28, 28));
      expect(
        tester.getTopLeft(close).dx,
        greaterThanOrEqualTo(tester.getTopRight(find.text('Heads up')).dx),
      );

      await tester.tap(close);
      expect(dismissals, 1);
    });

    testWidgets('a custom child keeps the close button', (tester) async {
      await tester.pumpRemixApp(
        RemixCallout(
          onDismiss: () {},
          dismissLabel: 'Dismiss callout',
          child: const Text('Custom'),
        ),
      );

      expect(find.text('Custom'), findsOneWidget);
      expect(find.bySemanticsLabel('Dismiss callout'), findsOneWidget);
    });

    testWidgets('without title or onDismiss the row holds only the text', (
      tester,
    ) async {
      await tester.pumpRemixApp(const RemixCallout(text: 'Plain'));

      expect(find.byType(ColumnBox), findsNothing);
      expect(find.byType(RemixIconButton), findsNothing);
    });
  });
}
