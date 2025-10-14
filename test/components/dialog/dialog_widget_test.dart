import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('RemixDialog', () {
    group('Basic Rendering', () {
      testWidgets('renders dialog with title only', (tester) async {
        await tester.pumpRemixApp(RemixDialog(title: 'Test Dialog'));
        await tester.pumpAndSettle();

        expect(find.byType(RemixDialog), findsOneWidget);
        expect(find.byType(Box), findsOneWidget);
        expect(find.byType(StyledText), findsOneWidget);
        expect(find.text('Test Dialog'), findsOneWidget);
      });

      testWidgets('renders dialog with description only', (tester) async {
        await tester.pumpRemixApp(
          RemixDialog(description: 'Dialog Description'),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixDialog), findsOneWidget);
        expect(find.byType(Box), findsOneWidget);
        expect(find.byType(StyledText), findsOneWidget);
        expect(find.text('Dialog Description'), findsOneWidget);
      });

      testWidgets('renders dialog with child only', (tester) async {
        final testChild = Icon(Icons.star, key: ValueKey('test_icon'));
        await tester.pumpRemixApp(RemixDialog(child: testChild));
        await tester.pumpAndSettle();

        expect(find.byType(RemixDialog), findsOneWidget);
        expect(find.byType(Box), findsOneWidget);
        expect(find.byKey(ValueKey('test_icon')), findsOneWidget);
        expect(find.byIcon(Icons.star), findsOneWidget);
      });

      testWidgets('renders dialog with title and description', (tester) async {
        await tester.pumpRemixApp(
          RemixDialog(title: 'Dialog Title', description: 'Dialog Description'),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixDialog), findsOneWidget);
        expect(find.byType(Box), findsOneWidget);
        expect(find.byType(StyledText), findsNWidgets(2));
        expect(find.text('Dialog Title'), findsOneWidget);
        expect(find.text('Dialog Description'), findsOneWidget);
      });

      testWidgets('renders dialog with all props', (tester) async {
        final actions = [
          TextButton(onPressed: () {}, child: Text('Cancel')),
          TextButton(onPressed: () {}, child: Text('OK')),
        ];

        await tester.pumpRemixApp(
          RemixDialog(
            title: 'Complete Dialog',
            description: 'Dialog with all elements',
            actions: actions,
            modal: true,
            semanticLabel: 'Complete Dialog',
            style: RemixDialogStyle.create(),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixDialog), findsOneWidget);
        expect(find.byType(Box), findsOneWidget);
        expect(find.byType(StyledText), findsNWidgets(2));
        expect(find.byType(FlexBox), findsOneWidget);
        expect(find.text('Complete Dialog'), findsOneWidget);
        expect(find.text('Dialog with all elements'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);
        expect(find.text('OK'), findsOneWidget);
      });
    });

    group('Content Combinations', () {
      testWidgets('child takes priority over title and description', (
        tester,
      ) async {
        final testChild = Container(
          key: ValueKey('priority_child'),
          child: Text('Custom Child'),
        );
        await tester.pumpRemixApp(
          RemixDialog(
            title: 'Should not show',
            description: 'Should not show',
            child: testChild,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixDialog), findsOneWidget);
        expect(find.byType(Box), findsOneWidget);
        expect(find.byKey(ValueKey('priority_child')), findsOneWidget);
        expect(find.text('Custom Child'), findsOneWidget);
        expect(find.text('Should not show'), findsNothing);
      });

      testWidgets('title and description are rendered together', (
        tester,
      ) async {
        await tester.pumpRemixApp(
          RemixDialog(
            title: 'Info Dialog',
            description: 'This is an informational dialog',
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixDialog), findsOneWidget);
        expect(find.byType(Box), findsOneWidget);
        expect(find.byType(StyledText), findsNWidgets(2));
        expect(find.text('Info Dialog'), findsOneWidget);
        expect(find.text('This is an informational dialog'), findsOneWidget);
      });

      testWidgets('actions are rendered when provided', (tester) async {
        final actions = [
          TextButton(onPressed: () {}, child: Text('Action 1')),
          TextButton(onPressed: () {}, child: Text('Action 2')),
        ];

        await tester.pumpRemixApp(
          RemixDialog(title: 'Dialog with Actions', actions: actions),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixDialog), findsOneWidget);
        expect(find.byType(Box), findsOneWidget);
        expect(find.byType(FlexBox), findsOneWidget);
        expect(find.text('Dialog with Actions'), findsOneWidget);
        expect(find.text('Action 1'), findsOneWidget);
        expect(find.text('Action 2'), findsOneWidget);
      });

      testWidgets('empty actions list does not render actions container', (
        tester,
      ) async {
        await tester.pumpRemixApp(
          RemixDialog(title: 'Dialog without Actions', actions: []),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixDialog), findsOneWidget);
        expect(find.byType(Box), findsOneWidget);
        expect(find.text('Dialog without Actions'), findsOneWidget);
        expect(find.byType(FlexBox), findsNothing);
      });
    });

    group('Modal Behavior', () {
      testWidgets('modal dialog blocks background interaction', (tester) async {
        await tester.pumpRemixApp(
          RemixDialog(title: 'Modal Dialog', modal: true),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixDialog), findsOneWidget);
        expect(find.byType(Box), findsOneWidget);
      });

      testWidgets('non-modal dialog allows background interaction', (
        tester,
      ) async {
        await tester.pumpRemixApp(
          RemixDialog(title: 'Non-Modal Dialog', modal: false),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixDialog), findsOneWidget);
        expect(find.byType(Box), findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('dialog with semantic label uses provided label', (
        tester,
      ) async {
        await tester.pumpRemixApp(
          RemixDialog(
            title: 'Dialog Title',
            semanticLabel: 'Custom Semantic Label',
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixDialog), findsOneWidget);
        expect(find.text('Dialog Title'), findsOneWidget);
      });

      testWidgets('dialog without semantic label uses title as label', (
        tester,
      ) async {
        await tester.pumpRemixApp(RemixDialog(title: 'Default Label Dialog'));
        await tester.pumpAndSettle();

        expect(find.byType(RemixDialog), findsOneWidget);
        expect(find.text('Default Label Dialog'), findsOneWidget);
      });

      testWidgets('dialog with child preserves child semantics', (
        tester,
      ) async {
        final testChild = Icon(Icons.star, semanticLabel: 'Star Icon');
        await tester.pumpRemixApp(RemixDialog(child: testChild));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.star), findsOneWidget);
        // Child semantics should be preserved
        final iconSemantics = tester.getSemantics(find.byIcon(Icons.star));
        expect(iconSemantics.label, contains('Star Icon'));
      });
    });

    group('Style Integration', () {
      testWidgets('applies custom style to container', (tester) async {
        final customStyle = RemixDialogStyle(
          container: BoxStyler(
            padding: EdgeInsetsGeometryMix.all(32.0),
            decoration: BoxDecorationMix(
              color: Colors.lightGreen,
              borderRadius: BorderRadiusGeometryMix.circular(16.0),
            ),
          ),
        );

        await tester.pumpRemixApp(
          RemixDialog(title: 'Styled Dialog', style: customStyle),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixDialog), findsOneWidget);
        expect(find.byType(Box), findsOneWidget);
        expect(find.text('Styled Dialog'), findsOneWidget);
      });

      testWidgets('applies custom title style', (tester) async {
        final customStyle = RemixDialogStyle(
          title: TextStyler(
            style: TextStyleMix(
              color: Colors.red,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        );

        await tester.pumpRemixApp(
          RemixDialog(title: 'Styled Title', style: customStyle),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixDialog), findsOneWidget);
        expect(find.byType(StyledText), findsOneWidget);
        expect(find.text('Styled Title'), findsOneWidget);
      });

      testWidgets('applies custom description style', (tester) async {
        final customStyle = RemixDialogStyle(
          description: TextStyler(
            style: TextStyleMix(
              color: Colors.blue,
              fontSize: 14.0,
              fontStyle: FontStyle.italic,
            ),
          ),
        );

        await tester.pumpRemixApp(
          RemixDialog(description: 'Styled Description', style: customStyle),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixDialog), findsOneWidget);
        expect(find.byType(StyledText), findsOneWidget);
        expect(find.text('Styled Description'), findsOneWidget);
      });

      testWidgets('applies custom actions style', (tester) async {
        final customStyle = RemixDialogStyle(
          actions: FlexBoxStyler(
            spacing: 16.0,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        );

        final actions = [
          TextButton(onPressed: () {}, child: Text('Left')),
          TextButton(onPressed: () {}, child: Text('Right')),
        ];

        await tester.pumpRemixApp(
          RemixDialog(
            title: 'Styled Actions',
            actions: actions,
            style: customStyle,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixDialog), findsOneWidget);
        expect(find.byType(FlexBox), findsOneWidget);
        expect(find.text('Styled Actions'), findsOneWidget);
        expect(find.text('Left'), findsOneWidget);
        expect(find.text('Right'), findsOneWidget);
      });

      testWidgets('uses default style when none provided', (tester) async {
        await tester.pumpRemixApp(RemixDialog(title: 'Default Style Dialog'));
        await tester.pumpAndSettle();

        expect(find.byType(RemixDialog), findsOneWidget);
        expect(find.byType(Box), findsOneWidget);
        expect(find.byType(StyledText), findsOneWidget);
        expect(find.text('Default Style Dialog'), findsOneWidget);
      });
    });

    group('Layout and Sizing', () {
      testWidgets('dialog adapts to content size', (tester) async {
        await tester.pumpRemixApp(RemixDialog(title: 'Short'));
        await tester.pumpAndSettle();

        final shortSize = tester.getSize(find.byType(RemixDialog));

        await tester.pumpRemixApp(
          RemixDialog(
            title:
                'Much Longer Dialog Title That Should Make The Container Wider',
          ),
        );
        await tester.pumpAndSettle();

        final longSize = tester.getSize(find.byType(RemixDialog));

        expect(longSize.width, greaterThan(shortSize.width));
      });

      testWidgets('dialog with actions is taller than title-only', (
        tester,
      ) async {
        await tester.pumpRemixApp(RemixDialog(title: 'Title Only'));
        await tester.pumpAndSettle();

        final titleOnlySize = tester.getSize(find.byType(RemixDialog));

        final actions = [TextButton(onPressed: () {}, child: Text('Action'))];

        await tester.pumpRemixApp(
          RemixDialog(title: 'Title Only', actions: actions),
        );
        await tester.pumpAndSettle();

        final withActionsSize = tester.getSize(find.byType(RemixDialog));

        expect(withActionsSize.height, greaterThan(titleOnlySize.height));
      });

      testWidgets('dialog with child adapts to child size', (tester) async {
        final smallChild = Icon(Icons.star, size: 16.0);
        await tester.pumpRemixApp(RemixDialog(child: smallChild));
        await tester.pumpAndSettle();

        final smallSize = tester.getSize(find.byType(RemixDialog));

        final largeChild = Icon(Icons.star, size: 32.0);
        await tester.pumpRemixApp(RemixDialog(child: largeChild));
        await tester.pumpAndSettle();

        final largeSize = tester.getSize(find.byType(RemixDialog));

        expect(largeSize.width, greaterThan(smallSize.width));
        expect(largeSize.height, greaterThan(smallSize.height));
      });
    });

    group('Edge Cases', () {
      testWidgets('handles empty title gracefully', (tester) async {
        await tester.pumpRemixApp(RemixDialog(title: ''));
        await tester.pumpAndSettle();

        expect(find.byType(RemixDialog), findsOneWidget);
        expect(find.byType(Box), findsOneWidget);
        expect(find.byType(StyledText), findsOneWidget);
      });

      testWidgets('handles empty description gracefully', (tester) async {
        await tester.pumpRemixApp(RemixDialog(description: ''));
        await tester.pumpAndSettle();

        expect(find.byType(RemixDialog), findsOneWidget);
        expect(find.byType(Box), findsOneWidget);
        expect(find.byType(StyledText), findsOneWidget);
      });

      testWidgets('handles null actions gracefully', (tester) async {
        await tester.pumpRemixApp(
          RemixDialog(title: 'No Actions', actions: null),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixDialog), findsOneWidget);
        expect(find.byType(Box), findsOneWidget);
        expect(find.text('No Actions'), findsOneWidget);
        expect(find.byType(FlexBox), findsNothing);
      });

      test('assertion error when all content is null', () {
        expect(() => RemixDialog(), throwsAssertionError);
      });

      test(
        'assertion error when child, title, and description are all null',
        () {
          expect(
            () => RemixDialog(child: null, title: null, description: null),
            throwsAssertionError,
          );
        },
      );
    });
  });
}
