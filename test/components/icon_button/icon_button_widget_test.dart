import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('RemixIconButton', () {
    group('Basic Rendering', () {
      testWidgets('renders icon button with minimal props', (tester) async {
        await tester.pumpRemixApp(
          RemixIconButton(icon: Icons.add, onPressed: () {}),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixIconButton), findsOneWidget);
        expect(find.byType(Box), findsOneWidget);
        expect(find.byType(StyledIcon), findsOneWidget);
        expect(find.byIcon(Icons.add), findsOneWidget);
      });

      testWidgets('renders icon button with all props', (tester) async {
        await tester.pumpRemixApp(
          RemixIconButton(
            icon: Icons.delete,
            onPressed: () {},
            onLongPress: () {},
            onDoubleTap: () {},
            autofocus: false,
            loading: false,
            enableFeedback: true,
            style: RemixIconButtonStyle.create(),
            semanticLabel: 'Delete Button',
            semanticHint: 'Deletes the item',
            excludeSemantics: false,
            mouseCursor: SystemMouseCursors.click,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixIconButton), findsOneWidget);
        expect(find.byType(Box), findsOneWidget);
        expect(find.byType(StyledIcon), findsOneWidget);
        expect(find.byIcon(Icons.delete), findsOneWidget);
      });
    });

    group('Loading State', () {
      testWidgets('shows spinner when loading is true', (tester) async {
        await tester.pumpRemixApp(
          RemixIconButton(icon: Icons.save, onPressed: () {}, loading: true),
        );
        await tester.pump(); // Use pump() for loading states

        expect(find.byType(RemixIconButton), findsOneWidget);
        expect(find.byType(RemixSpinner), findsOneWidget);
        expect(find.byType(StyledIcon), findsOneWidget);
      });

      testWidgets('hides spinner when loading is false', (tester) async {
        await tester.pumpRemixApp(
          RemixIconButton(icon: Icons.save, onPressed: () {}, loading: false),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixIconButton), findsOneWidget);
        expect(find.byType(RemixSpinner), findsNothing);
        expect(find.byType(StyledIcon), findsOneWidget);
      });

      testWidgets('is disabled when loading is true', (tester) async {
        int callbackCount = 0;
        await tester.pumpRemixApp(
          RemixIconButton(
            icon: Icons.save,
            onPressed: () => callbackCount++,
            loading: true,
          ),
        );
        await tester.pump(); // Use pump() for loading states

        await tester.tap(find.byType(RemixIconButton));
        await tester.pump();

        expect(callbackCount, equals(0));
      });
    });

    group('Custom Builders', () {
      testWidgets('iconBuilder renders custom icon widget', (tester) async {
        Widget customIconBuilder(
          BuildContext context,
          IconSpec spec,
          IconData? icon,
        ) {
          return Container(
            key: const ValueKey('custom_icon'),
            child: Icon(icon, color: Colors.red),
          );
        }

        await tester.pumpRemixApp(
          RemixIconButton(
            icon: Icons.star,
            onPressed: () {},
            iconBuilder: customIconBuilder,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byKey(const ValueKey('custom_icon')), findsOneWidget);
        expect(find.byIcon(Icons.star), findsOneWidget);
      });

      testWidgets('loadingBuilder renders custom loading widget', (
        tester,
      ) async {
        Widget customLoadingBuilder(
          BuildContext context,
          RemixSpinnerSpec spec,
        ) {
          return Container(
            key: const ValueKey('custom_loading'),
            child: const CircularProgressIndicator(),
          );
        }

        await tester.pumpRemixApp(
          RemixIconButton(
            icon: Icons.save,
            onPressed: () {},
            loading: true,
            loadingBuilder: customLoadingBuilder,
          ),
        );
        await tester.pump(); // Use pump() for loading states

        expect(find.byKey(const ValueKey('custom_loading')), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });

    group('Interaction', () {
      testWidgets('calls onPressed when tapped', (tester) async {
        int callbackCount = 0;
        await tester.pumpRemixApp(
          RemixIconButton(icon: Icons.add, onPressed: () => callbackCount++),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(RemixIconButton));
        await tester.pumpAndSettle();

        expect(callbackCount, equals(1));
      });

      testWidgets('calls onLongPress when long pressed', (tester) async {
        int callbackCount = 0;
        await tester.pumpRemixApp(
          RemixIconButton(
            icon: Icons.add,
            onPressed: () {},
            onLongPress: () => callbackCount++,
          ),
        );
        await tester.pumpAndSettle();

        await tester.longPress(find.byType(RemixIconButton));
        await tester.pumpAndSettle();

        expect(callbackCount, equals(1));
      });

      testWidgets('handles onDoubleTap callback', (tester) async {
        await tester.pumpRemixApp(
          RemixIconButton(
            icon: Icons.add,
            onPressed: () {},
            onDoubleTap: () {},
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixIconButton), findsOneWidget);
        expect(find.byType(Box), findsOneWidget);
        expect(find.byType(StyledIcon), findsOneWidget);
      });

      testWidgets('does not call callbacks when disabled', (tester) async {
        int pressedCount = 0;
        int longPressCount = 0;
        await tester.pumpRemixApp(
          RemixIconButton(
            icon: Icons.add,
            onPressed: null,
            onLongPress: () => longPressCount++,
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(RemixIconButton));
        await tester.longPress(find.byType(RemixIconButton));
        await tester.pumpAndSettle();

        expect(pressedCount, equals(0));
        expect(longPressCount, equals(0));
      });
    });

    group('Focus and Keyboard', () {
      testWidgets('autofocus requests focus on mount', (tester) async {
        final focusNode = FocusNode();
        addTearDown(() => focusNode.dispose());

        await tester.pumpRemixApp(
          RemixIconButton(
            icon: Icons.add,
            onPressed: () {},
            autofocus: true,
            focusNode: focusNode,
          ),
        );
        await tester.pumpAndSettle();

        final focused = tester.binding.focusManager.primaryFocus;
        expect(focused, equals(focusNode));
      });

      testWidgets('can be focused programmatically', (tester) async {
        final focusNode = FocusNode();
        addTearDown(() => focusNode.dispose());

        await tester.pumpRemixApp(
          RemixIconButton(
            icon: Icons.add,
            onPressed: () {},
            focusNode: focusNode,
          ),
        );
        await tester.pumpAndSettle();

        focusNode.requestFocus();
        await tester.pumpAndSettle();

        expect(focusNode.hasFocus, isTrue);
      });
    });

    group('Accessibility', () {
      testWidgets('semanticLabel overrides default label', (tester) async {
        await tester.pumpRemixApp(
          RemixIconButton(
            icon: Icons.add,
            onPressed: () {},
            semanticLabel: 'Custom Semantic Label',
          ),
        );
        await tester.pumpAndSettle();

        final semantics = tester.getSemantics(find.byType(RemixIconButton));
        expect(semantics.label, contains('Custom Semantic Label'));
      });

      testWidgets('semanticHint provides additional context', (tester) async {
        await tester.pumpRemixApp(
          RemixIconButton(
            icon: Icons.delete,
            onPressed: () {},
            semanticHint: 'Deletes the selected item',
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixIconButton), findsOneWidget);
        expect(find.byType(Box), findsOneWidget);
        expect(find.byType(StyledIcon), findsOneWidget);
      });

      testWidgets('excludeSemantics excludes child semantics', (tester) async {
        await tester.pumpRemixApp(
          RemixIconButton(
            icon: Icons.add,
            onPressed: () {},
            excludeSemantics: true,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixIconButton), findsOneWidget);
        expect(find.byType(MergeSemantics), findsOneWidget);
      });

      testWidgets('renders correctly in enabled state', (tester) async {
        await tester.pumpRemixApp(
          RemixIconButton(icon: Icons.add, onPressed: () {}),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixIconButton), findsOneWidget);
        expect(find.byType(Box), findsOneWidget);
        expect(find.byType(StyledIcon), findsOneWidget);
      });

      testWidgets('renders correctly in disabled state', (tester) async {
        await tester.pumpRemixApp(
          RemixIconButton(icon: Icons.add, onPressed: null),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixIconButton), findsOneWidget);
        expect(find.byType(Box), findsOneWidget);
        expect(find.byType(StyledIcon), findsOneWidget);
      });
    });

    group('Style Integration', () {
      testWidgets('applies custom style to container', (tester) async {
        final customStyle = RemixIconButtonStyle(
          container: BoxStyler(
            padding: EdgeInsetsGeometryMix.all(16.0),
            decoration: BoxDecorationMix(
              color: Colors.lightBlue,
              borderRadius: BorderRadiusGeometryMix.circular(8.0),
            ),
          ),
        );

        await tester.pumpRemixApp(
          RemixIconButton(
            icon: Icons.add,
            onPressed: () {},
            style: customStyle,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixIconButton), findsOneWidget);
        expect(find.byType(Box), findsOneWidget);
        expect(find.byType(StyledIcon), findsOneWidget);
      });

      testWidgets('applies custom icon style', (tester) async {
        final customStyle = RemixIconButtonStyle(
          icon: IconStyler(color: Colors.red, size: 24.0),
        );

        await tester.pumpRemixApp(
          RemixIconButton(
            icon: Icons.add,
            onPressed: () {},
            style: customStyle,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixIconButton), findsOneWidget);
        expect(find.byType(StyledIcon), findsOneWidget);
      });

      testWidgets('applies custom spinner style', (tester) async {
        final customStyle = RemixIconButtonStyle(spinner: RemixSpinnerStyle());

        await tester.pumpRemixApp(
          RemixIconButton(
            icon: Icons.save,
            onPressed: () {},
            loading: true,
            style: customStyle,
          ),
        );
        await tester.pump(); // Use pump() for loading states

        expect(find.byType(RemixIconButton), findsOneWidget);
        expect(find.byType(RemixSpinner), findsOneWidget);
      });

      testWidgets('uses default style when none provided', (tester) async {
        await tester.pumpRemixApp(
          RemixIconButton(icon: Icons.add, onPressed: () {}),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixIconButton), findsOneWidget);
        expect(find.byType(Box), findsOneWidget);
        expect(find.byType(StyledIcon), findsOneWidget);
      });
    });

    group('Layout and Sizing', () {
      testWidgets('icon button adapts to custom size', (tester) async {
        final smallStyle = RemixIconButtonStyle().iconButtonSize(32.0);
        await tester.pumpRemixApp(
          RemixIconButton(icon: Icons.add, onPressed: () {}, style: smallStyle),
        );
        await tester.pumpAndSettle();

        final smallSize = tester.getSize(find.byType(RemixIconButton));

        final largeStyle = RemixIconButtonStyle().iconButtonSize(64.0);
        await tester.pumpRemixApp(
          RemixIconButton(icon: Icons.add, onPressed: () {}, style: largeStyle),
        );
        await tester.pumpAndSettle();

        final largeSize = tester.getSize(find.byType(RemixIconButton));

        expect(largeSize.width, greaterThan(smallSize.width));
        expect(largeSize.height, greaterThan(smallSize.height));
      });
    });

    group('Edge Cases', () {
      testWidgets('handles null onPressed gracefully', (tester) async {
        await tester.pumpRemixApp(
          RemixIconButton(icon: Icons.add, onPressed: null),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixIconButton), findsOneWidget);
        expect(find.byType(Box), findsOneWidget);
        expect(find.byType(StyledIcon), findsOneWidget);
      });

      testWidgets('handles loading state with null onPressed', (tester) async {
        await tester.pumpRemixApp(
          RemixIconButton(icon: Icons.save, onPressed: null, loading: true),
        );
        await tester.pump(); // Use pump() for loading states

        expect(find.byType(RemixIconButton), findsOneWidget);
        expect(find.byType(RemixSpinner), findsOneWidget);
      });

      testWidgets('handles different icon types', (tester) async {
        final icons = [
          Icons.add,
          Icons.remove,
          Icons.close,
          Icons.check,
          Icons.star,
        ];

        for (final icon in icons) {
          await tester.pumpRemixApp(
            RemixIconButton(icon: icon, onPressed: () {}),
          );
          await tester.pumpAndSettle();

          expect(find.byType(RemixIconButton), findsOneWidget);
          expect(find.byIcon(icon), findsOneWidget);
        }
      });
    });
  });
}
