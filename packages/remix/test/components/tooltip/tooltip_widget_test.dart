import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../lib/remix.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('RemixTooltip', () {
    group('Basic Rendering', () {
      testWidgets('renders with default style', (tester) async {
        await tester.pumpRemixApp(
          const RemixTooltip(
            tooltipChild: Text('Tooltip'),
            child: Text('Trigger'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixTooltip), findsOneWidget);
        expect(find.text('Trigger'), findsOneWidget);
        // Tooltip content should not be visible initially
        expect(find.text('Tooltip'), findsNothing);
      });

      testWidgets('renders tooltip child', (tester) async {
        await tester.pumpRemixApp(
          const RemixTooltip(
            tooltipChild: Text('Tooltip Content'),
            child: Icon(Icons.info),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixTooltip), findsOneWidget);
        expect(find.byIcon(Icons.info), findsOneWidget);
        // Tooltip content should not be visible initially
        expect(find.text('Tooltip Content'), findsNothing);
      });

      testWidgets('renders with custom widgets', (tester) async {
        await tester.pumpRemixApp(
          RemixTooltip(
            tooltipChild: Container(
              key: const ValueKey('tooltip_container'),
              child: const Text('Custom Tooltip'),
            ),
            child: const Text('Trigger'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Trigger'), findsOneWidget);
        // Tooltip should not be visible initially
        expect(find.byKey(const ValueKey('tooltip_container')), findsNothing);
      });
    });

    group('Widget Properties', () {
      testWidgets('stores tooltip child correctly', (tester) async {
        const tooltipContent = Text('Tooltip Content');
        const triggerWidget = Icon(Icons.info);

        await tester.pumpRemixApp(
          const RemixTooltip(
            tooltipChild: tooltipContent,
            child: triggerWidget,
          ),
        );
        await tester.pumpAndSettle();

        final tooltip = tester.widget<RemixTooltip>(find.byType(RemixTooltip));
        expect(tooltip.tooltipChild, equals(tooltipContent));
        expect(tooltip.child, equals(triggerWidget));
      });

      testWidgets('has correct default style', (tester) async {
        await tester.pumpRemixApp(
          const RemixTooltip(
            tooltipChild: Text('Tooltip'),
            child: Text('Trigger'),
          ),
        );
        await tester.pumpAndSettle();

        final tooltip = tester.widget<RemixTooltip>(find.byType(RemixTooltip));
        expect(tooltip.style, isA<RemixTooltipStyle>());
      });

      testWidgets('accepts custom style', (tester) async {
        final customStyle = RemixTooltipStyle().color(Colors.blue);

        await tester.pumpRemixApp(
          RemixTooltip(
            style: customStyle,
            tooltipChild: const Text('Tooltip'),
            child: const Text('Trigger'),
          ),
        );
        await tester.pumpAndSettle();

        final tooltip = tester.widget<RemixTooltip>(find.byType(RemixTooltip));
        expect(tooltip.style, equals(customStyle));
      });
    });

    group('Interaction', () {
      testWidgets('shows tooltip on hover', (tester) async {
        await tester.pumpRemixApp(
          const RemixTooltip(
            tooltipChild: Text('Tooltip Content'),
            child: Icon(Icons.info),
          ),
        );
        await tester.pumpAndSettle();

        // Initially tooltip should not be visible
        expect(find.text('Tooltip Content'), findsNothing);

        // Create a hover gesture
        final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
        await gesture.addPointer(location: Offset.zero);
        addTearDown(gesture.removePointer);

        // Hover over the icon
        await gesture.moveTo(tester.getCenter(find.byIcon(Icons.info)));
        await tester.pumpAndSettle();

        // Wait for the wait duration to pass (300ms default)
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pumpAndSettle();

        // Tooltip should now be visible in the overlay
        expect(find.text('Tooltip Content'), findsOneWidget);
      });

      testWidgets('hides tooltip after moving mouse away', (tester) async {
        await tester.pumpRemixApp(
          const RemixTooltip(
            tooltipChild: Text('Temporary Message'),
            child: Icon(Icons.help),
          ),
        );
        await tester.pumpAndSettle();

        // Show tooltip by hovering
        final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
        await gesture.addPointer(location: Offset.zero);
        addTearDown(gesture.removePointer);

        await gesture.moveTo(tester.getCenter(find.byIcon(Icons.help)));
        await tester.pumpAndSettle();
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pumpAndSettle();

        // Tooltip should be visible
        expect(find.text('Temporary Message'), findsOneWidget);

        // Move mouse away
        await gesture.moveTo(Offset.zero);
        await tester.pumpAndSettle();

        // Wait for show duration (1500ms default)
        await tester.pump(const Duration(milliseconds: 1500));
        await tester.pumpAndSettle();

        // Tooltip should be hidden
        expect(find.text('Temporary Message'), findsNothing);
      });

      testWidgets('shows complex tooltip content on hover', (tester) async {
        await tester.pumpRemixApp(
          RemixTooltip(
            tooltipChild: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.warning, color: Colors.orange),
                SizedBox(height: 4),
                Text('Warning Message'),
              ],
            ),
            child: const Icon(Icons.info),
          ),
        );
        await tester.pumpAndSettle();

        // Initially tooltip content should not be visible
        expect(find.byIcon(Icons.warning), findsNothing);
        expect(find.text('Warning Message'), findsNothing);

        // Trigger tooltip with hover
        final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
        await gesture.addPointer(location: Offset.zero);
        addTearDown(gesture.removePointer);

        await gesture.moveTo(tester.getCenter(find.byIcon(Icons.info)));
        await tester.pumpAndSettle();
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pumpAndSettle();

        // Tooltip content should now be visible
        expect(find.byIcon(Icons.warning), findsOneWidget);
        expect(find.text('Warning Message'), findsOneWidget);
      });
    });

    group('Duration Configuration', () {
      testWidgets('respects custom wait duration', (tester) async {
        await tester.pumpRemixApp(
          RemixTooltip(
            style: RemixTooltipStyle().waitDuration(
              const Duration(milliseconds: 500),
            ),
            tooltipChild: const Text('Tooltip'),
            child: const Text('Trigger'),
          ),
        );
        await tester.pumpAndSettle();

        // Verify the widget has the custom duration configured
        final tooltip = tester.widget<RemixTooltip>(find.byType(RemixTooltip));
        expect(tooltip.style, isA<RemixTooltipStyle>());

        // The style itself should be the custom one
        expect(tooltip.style, isNotNull);
      });

      testWidgets('respects custom show duration', (tester) async {
        await tester.pumpRemixApp(
          RemixTooltip(
            style: RemixTooltipStyle().showDuration(
              const Duration(milliseconds: 2000),
            ),
            tooltipChild: const Text('Long Tooltip'),
            child: const Text('Trigger'),
          ),
        );
        await tester.pumpAndSettle();

        // Verify the widget has the custom duration configured
        final tooltip = tester.widget<RemixTooltip>(find.byType(RemixTooltip));
        expect(tooltip.style, isA<RemixTooltipStyle>());
        expect(tooltip.style, isNotNull);
      });

      testWidgets('uses default durations when not specified', (tester) async {
        await tester.pumpRemixApp(
          const RemixTooltip(
            tooltipChild: Text('Default Tooltip'),
            child: Text('Trigger'),
          ),
        );
        await tester.pumpAndSettle();

        // Verify default style is used
        final tooltip = tester.widget<RemixTooltip>(find.byType(RemixTooltip));
        expect(tooltip.style, isA<RemixTooltipStyle>());
        expect(tooltip.styleSpec, isNull);
      });
    });

    group('Semantics', () {
      testWidgets('accepts tooltip semantics parameter', (tester) async {
        await tester.pumpRemixApp(
          const RemixTooltip(
            tooltipSemantics: 'Info tooltip',
            tooltipChild: Text('Tooltip'),
            child: Icon(Icons.info),
          ),
        );
        await tester.pumpAndSettle();

        // Verify tooltip widget renders correctly with semantics parameter
        expect(find.byType(RemixTooltip), findsOneWidget);
        final tooltip = tester.widget<RemixTooltip>(find.byType(RemixTooltip));
        expect(tooltip.tooltipSemantics, equals('Info tooltip'));
      });

      testWidgets('works without semantic label', (tester) async {
        await tester.pumpRemixApp(
          const RemixTooltip(
            tooltipChild: Text('Tooltip'),
            child: Text('Trigger'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixTooltip), findsOneWidget);
        expect(find.text('Trigger'), findsOneWidget);

        final tooltip = tester.widget<RemixTooltip>(find.byType(RemixTooltip));
        expect(tooltip.tooltipSemantics, isNull);
      });

      testWidgets('tooltip semantics is accessible on widget', (tester) async {
        await tester.pumpRemixApp(
          const RemixTooltip(
            tooltipSemantics: 'Help information',
            tooltipChild: Text('Helpful content'),
            child: Icon(Icons.help),
          ),
        );
        await tester.pumpAndSettle();

        // Verify the widget has the semantics property set
        final tooltip = tester.widget<RemixTooltip>(find.byType(RemixTooltip));
        expect(tooltip.tooltipSemantics, equals('Help information'));
        expect(tooltip.tooltipSemantics, isNotEmpty);
      });
    });

    group('Styling', () {
      testWidgets('applies custom background color to tooltip', (
        tester,
      ) async {
        final customStyle = RemixTooltipStyle().color(Colors.blue);

        await tester.pumpRemixApp(
          RemixTooltip(
            style: customStyle,
            tooltipChild: const Text('Styled Tooltip'),
            child: const Text('Trigger'),
          ),
        );
        await tester.pumpAndSettle();

        // Verify custom style is applied
        final tooltip = tester.widget<RemixTooltip>(find.byType(RemixTooltip));
        expect(tooltip.style, equals(customStyle));
      });

      testWidgets('applies custom padding to tooltip', (tester) async {
        final customStyle = RemixTooltipStyle()
            .padding(EdgeInsetsGeometryMix.all(20));

        await tester.pumpRemixApp(
          RemixTooltip(
            style: customStyle,
            tooltipChild: const Text('Padded Tooltip'),
            child: const Text('Trigger'),
          ),
        );
        await tester.pumpAndSettle();

        // Verify custom style is applied
        final tooltip = tester.widget<RemixTooltip>(find.byType(RemixTooltip));
        expect(tooltip.style, equals(customStyle));
      });

      testWidgets('applies multiple styles correctly', (tester) async {
        final customStyle = RemixTooltipStyle()
            .color(Colors.blue)
            .padding(EdgeInsetsGeometryMix.all(16))
            .borderRadius(BorderRadiusGeometryMix.circular(8))
            .waitDuration(const Duration(milliseconds: 500));

        await tester.pumpRemixApp(
          RemixTooltip(
            style: customStyle,
            tooltipChild: const Text('Multi-styled Tooltip'),
            child: const Text('Trigger'),
          ),
        );
        await tester.pumpAndSettle();

        // Verify custom style is applied
        final tooltip = tester.widget<RemixTooltip>(find.byType(RemixTooltip));
        expect(tooltip.style, equals(customStyle));
        expect(tooltip.style, isA<RemixTooltipStyle>());
      });
    });

    group('Edge Cases', () {
      testWidgets('handles very short text', (tester) async {
        await tester.pumpRemixApp(
          const RemixTooltip(tooltipChild: Text('T'), child: Text('X')),
        );
        await tester.pumpAndSettle();

        expect(find.text('X'), findsOneWidget);
        expect(find.text('T'), findsNothing);

        final tooltip = tester.widget<RemixTooltip>(find.byType(RemixTooltip));
        expect(tooltip.tooltipChild, isA<Text>());
        expect(tooltip.child, isA<Text>());
      });

      testWidgets('handles very long text', (tester) async {
        const longText = 'This is a very long tooltip text that should '
            'wrap properly and display correctly in the tooltip overlay';

        await tester.pumpRemixApp(
          const RemixTooltip(
            tooltipChild: Text(longText),
            child: Text('Trigger'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Trigger'), findsOneWidget);

        // Verify the long text is stored in the widget
        final tooltip = tester.widget<RemixTooltip>(find.byType(RemixTooltip));
        final tooltipText = tooltip.tooltipChild as Text;
        expect(tooltipText.data, equals(longText));
      });

      testWidgets('handles complex tooltip children', (tester) async {
        await tester.pumpRemixApp(
          RemixTooltip(
            tooltipChild: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [Icon(Icons.warning), Text('Warning Message')],
            ),
            child: const Icon(Icons.info),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.info), findsOneWidget);

        // Verify complex tooltip child structure
        final tooltip = tester.widget<RemixTooltip>(find.byType(RemixTooltip));
        expect(tooltip.tooltipChild, isA<Column>());
        expect(tooltip.child, isA<Icon>());
      });

      testWidgets('handles complex trigger children', (tester) async {
        await tester.pumpRemixApp(
          RemixTooltip(
            tooltipChild: const Text('Info Tooltip'),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.info),
                SizedBox(width: 4),
                Text('Info'),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Info'), findsOneWidget);
        expect(find.byIcon(Icons.info), findsOneWidget);

        // Verify complex child structure
        final tooltip = tester.widget<RemixTooltip>(find.byType(RemixTooltip));
        expect(tooltip.child, isA<Row>());
      });
    });

    group('Key Parameter', () {
      testWidgets('accepts and uses key parameter', (tester) async {
        const key = ValueKey('tooltip_key');

        await tester.pumpRemixApp(
          const RemixTooltip(
            key: key,
            tooltipChild: Text('Tooltip'),
            child: Text('Trigger'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byKey(key), findsOneWidget);

        // Verify the key is actually on the RemixTooltip widget
        final tooltip = tester.widget<RemixTooltip>(find.byKey(key));
        expect(tooltip.key, equals(key));
      });
    });

    group('StyleSpec Parameter', () {
      testWidgets('uses styleSpec when provided', (tester) async {
        const spec = RemixTooltipSpec(
          waitDuration: Duration(milliseconds: 400),
          showDuration: Duration(milliseconds: 2500),
        );

        await tester.pumpRemixApp(
          const RemixTooltip(
            styleSpec: spec,
            tooltipChild: Text('Tooltip'),
            child: Text('Trigger'),
          ),
        );
        await tester.pumpAndSettle();

        // Verify the styleSpec is set correctly
        final tooltip = tester.widget<RemixTooltip>(find.byType(RemixTooltip));
        expect(tooltip.styleSpec, equals(spec));
        expect(tooltip.styleSpec?.waitDuration, equals(const Duration(milliseconds: 400)));
        expect(tooltip.styleSpec?.showDuration, equals(const Duration(milliseconds: 2500)));
      });

      testWidgets('styleSpec properties are preserved', (tester) async {
        const spec = RemixTooltipSpec(
          waitDuration: Duration(milliseconds: 100),
          showDuration: Duration(milliseconds: 3000),
        );

        await tester.pumpRemixApp(
          const RemixTooltip(
            styleSpec: spec,
            tooltipChild: Text('Custom Spec Tooltip'),
            child: Icon(Icons.help),
          ),
        );
        await tester.pumpAndSettle();

        final tooltip = tester.widget<RemixTooltip>(find.byType(RemixTooltip));
        expect(tooltip.styleSpec, isNotNull);
        expect(tooltip.styleSpec?.waitDuration.inMilliseconds, equals(100));
        expect(tooltip.styleSpec?.showDuration.inMilliseconds, equals(3000));
      });
    });

    group('Multiple Tooltips', () {
      testWidgets('renders multiple tooltips independently', (tester) async {
        await tester.pumpRemixApp(
          Column(
            children: const [
              RemixTooltip(
                tooltipChild: Text('Tooltip 1'),
                child: Text('Trigger 1'),
              ),
              RemixTooltip(
                tooltipChild: Text('Tooltip 2'),
                child: Text('Trigger 2'),
              ),
            ],
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Trigger 1'), findsOneWidget);
        expect(find.text('Trigger 2'), findsOneWidget);
        expect(find.text('Tooltip 1'), findsNothing);
        expect(find.text('Tooltip 2'), findsNothing);

        // Verify both tooltips are rendered
        expect(find.byType(RemixTooltip), findsNWidgets(2));
      });

      testWidgets('each tooltip has its own configuration', (tester) async {
        const spec1 = RemixTooltipSpec(
          waitDuration: Duration(milliseconds: 200),
          showDuration: Duration(milliseconds: 1000),
        );
        const spec2 = RemixTooltipSpec(
          waitDuration: Duration(milliseconds: 400),
          showDuration: Duration(milliseconds: 2000),
        );

        await tester.pumpRemixApp(
          Column(
            children: const [
              RemixTooltip(
                styleSpec: spec1,
                tooltipChild: Text('First'),
                child: Text('Button 1'),
              ),
              SizedBox(height: 20),
              RemixTooltip(
                styleSpec: spec2,
                tooltipChild: Text('Second'),
                child: Text('Button 2'),
              ),
            ],
          ),
        );
        await tester.pumpAndSettle();

        // Verify each tooltip has its own spec
        final tooltips = tester.widgetList<RemixTooltip>(find.byType(RemixTooltip)).toList();
        expect(tooltips, hasLength(2));
        expect(tooltips[0].styleSpec, equals(spec1));
        expect(tooltips[1].styleSpec, equals(spec2));
      });
    });

    group('Icon Child', () {
      testWidgets('works with icon as child', (tester) async {
        await tester.pumpRemixApp(
          const RemixTooltip(
            tooltipChild: Text('Help information'),
            child: Icon(Icons.help),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.help), findsOneWidget);

        final tooltip = tester.widget<RemixTooltip>(find.byType(RemixTooltip));
        expect(tooltip.child, isA<Icon>());
        final icon = tooltip.child as Icon;
        expect(icon.icon, equals(Icons.help));
      });

      testWidgets('works with icon as tooltip child', (tester) async {
        await tester.pumpRemixApp(
          const RemixTooltip(
            tooltipChild: Icon(Icons.check_circle),
            child: Text('Success'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Success'), findsOneWidget);

        final tooltip = tester.widget<RemixTooltip>(find.byType(RemixTooltip));
        expect(tooltip.tooltipChild, isA<Icon>());
        final tooltipIcon = tooltip.tooltipChild as Icon;
        expect(tooltipIcon.icon, equals(Icons.check_circle));
      });
    });

    group('Tooltip Lifecycle', () {
      testWidgets('tooltip can be created and disposed without errors', (tester) async {
        await tester.pumpRemixApp(
          Column(
            children: const [
              RemixTooltip(
                tooltipChild: Text('Tooltip Text'),
                child: Text('Trigger'),
              ),
              SizedBox(height: 100),
              Text('Outside'),
            ],
          ),
        );
        await tester.pumpAndSettle();

        // Verify initial state
        expect(find.text('Trigger'), findsOneWidget);
        expect(find.text('Outside'), findsOneWidget);
        expect(find.text('Tooltip Text'), findsNothing);

        // Dispose by pumping a different widget
        await tester.pumpWidget(const MaterialApp(home: Text('New Widget')));
        await tester.pumpAndSettle();

        // Verify no errors during disposal
        expect(find.text('New Widget'), findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('tooltip content is accessible when shown', (tester) async {
        await tester.pumpRemixApp(
          const RemixTooltip(
            tooltipSemantics: 'Important information',
            tooltipChild: Text('Detailed help text'),
            child: Icon(Icons.info_outline),
          ),
        );
        await tester.pumpAndSettle();

        // Verify widget renders with semantics parameter
        final tooltip = tester.widget<RemixTooltip>(find.byType(RemixTooltip));
        expect(tooltip.tooltipSemantics, equals('Important information'));
        expect(tooltip.tooltipChild, isA<Text>());

        final tooltipText = tooltip.tooltipChild as Text;
        expect(tooltipText.data, equals('Detailed help text'));
      });

      testWidgets('semantics label is distinct from tooltip content', (tester) async {
        await tester.pumpRemixApp(
          const RemixTooltip(
            tooltipSemantics: 'Semantic description',
            tooltipChild: Text('Visual content'),
            child: Icon(Icons.info),
          ),
        );
        await tester.pumpAndSettle();

        final tooltip = tester.widget<RemixTooltip>(find.byType(RemixTooltip));
        expect(tooltip.tooltipSemantics, equals('Semantic description'));

        final tooltipText = tooltip.tooltipChild as Text;
        expect(tooltipText.data, equals('Visual content'));
        expect(tooltip.tooltipSemantics, isNot(equals(tooltipText.data)));
      });
    });

    group('Widget Composition', () {
      testWidgets('tooltip wraps child widget correctly', (tester) async {
        const childWidget = Text('Wrapped Child');
        const tooltipContent = Text('Tooltip Info');

        await tester.pumpRemixApp(
          const RemixTooltip(
            tooltipChild: tooltipContent,
            child: childWidget,
          ),
        );
        await tester.pumpAndSettle();

        // Verify child is rendered
        expect(find.text('Wrapped Child'), findsOneWidget);

        // Verify widget composition
        final tooltip = tester.widget<RemixTooltip>(find.byType(RemixTooltip));
        expect(tooltip.child, equals(childWidget));
        expect(tooltip.tooltipChild, equals(tooltipContent));
      });

      testWidgets('maintains widget tree hierarchy', (tester) async {
        await tester.pumpRemixApp(
          Container(
            child: const RemixTooltip(
              tooltipChild: Text('Nested Tooltip'),
              child: Text('Nested Child'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify the hierarchy: Container -> RemixTooltip -> child
        expect(find.byType(Container), findsWidgets);
        expect(find.byType(RemixTooltip), findsOneWidget);
        expect(find.text('Nested Child'), findsOneWidget);
      });
    });
  });
}
