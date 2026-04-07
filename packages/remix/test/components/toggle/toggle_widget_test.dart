import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('RemixToggle', () {
    group('Basic Rendering', () {
      testWidgets('renders toggle with label only', (tester) async {
        await tester.pumpRemixApp(
          RemixToggle(
            selected: false,
            onChanged: (value) {},
            label: 'Bold',
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixToggle), findsOneWidget);
        expect(find.text('Bold'), findsOneWidget);
      });

      testWidgets('renders toggle with icon only', (tester) async {
        await tester.pumpRemixApp(
          RemixToggle(
            selected: false,
            onChanged: (value) {},
            icon: Icons.format_bold,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixToggle), findsOneWidget);
      });

      testWidgets('renders toggle with both icon and label', (tester) async {
        await tester.pumpRemixApp(
          RemixToggle(
            selected: false,
            onChanged: (value) {},
            label: 'Bold',
            icon: Icons.format_bold,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixToggle), findsOneWidget);
        expect(find.text('Bold'), findsOneWidget);
      });

      testWidgets('renders in selected state', (tester) async {
        await tester.pumpRemixApp(
          RemixToggle(
            selected: true,
            onChanged: (value) {},
            label: 'Bold',
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixToggle), findsOneWidget);
      });

      testWidgets('renders with custom style', (tester) async {
        await tester.pumpRemixApp(
          RemixToggle(
            selected: false,
            onChanged: (value) {},
            label: 'Bold',
            style: RemixToggleStyle().backgroundColor(Colors.blue),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixToggle), findsOneWidget);
      });
    });

    group('Interaction', () {
      testWidgets('calls onChanged when tapped', (tester) async {
        bool wasChanged = false;
        bool newValue = false;

        await tester.pumpRemixApp(
          RemixToggle(
            selected: false,
            onChanged: (value) {
              wasChanged = true;
              newValue = value;
            },
            label: 'Bold',
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(RemixToggle));
        await tester.pumpAndSettle();

        expect(wasChanged, isTrue);
        expect(newValue, isTrue);
      });

      testWidgets('toggles between states', (tester) async {
        bool toggleValue = false;

        await tester.pumpRemixApp(
          StatefulBuilder(
            builder: (context, setState) {
              return RemixToggle(
                selected: toggleValue,
                onChanged: (value) {
                  setState(() {
                    toggleValue = value;
                  });
                },
                label: 'Bold',
              );
            },
          ),
        );
        await tester.pumpAndSettle();

        expect(toggleValue, isFalse);

        await tester.tap(find.byType(RemixToggle));
        await tester.pumpAndSettle();

        expect(toggleValue, isTrue);

        await tester.tap(find.byType(RemixToggle));
        await tester.pumpAndSettle();

        expect(toggleValue, isFalse);
      });

      testWidgets('does not call onChanged when disabled', (tester) async {
        bool wasChanged = false;

        await tester.pumpRemixApp(
          RemixToggle(
            selected: false,
            onChanged: (value) {
              wasChanged = true;
            },
            label: 'Bold',
            enabled: false,
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(RemixToggle));
        await tester.pumpAndSettle();

        expect(wasChanged, isFalse);
      });
    });

    group('Focus', () {
      testWidgets('accepts focusNode parameter', (tester) async {
        final focusNode = FocusNode();

        await tester.pumpRemixApp(
          RemixToggle(
            selected: false,
            onChanged: (value) {},
            label: 'Bold',
            focusNode: focusNode,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixToggle), findsOneWidget);
        focusNode.dispose();
      });

      testWidgets('handles autofocus parameter', (tester) async {
        await tester.pumpRemixApp(
          RemixToggle(
            selected: false,
            onChanged: (value) {},
            label: 'Bold',
            autofocus: true,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixToggle), findsOneWidget);
      });

      testWidgets('can request focus programmatically', (tester) async {
        final focusNode = FocusNode();

        await tester.pumpRemixApp(
          RemixToggle(
            selected: false,
            onChanged: (value) {},
            label: 'Bold',
            focusNode: focusNode,
          ),
        );
        await tester.pumpAndSettle();

        focusNode.requestFocus();
        await tester.pumpAndSettle();

        expect(focusNode.hasFocus, isTrue);
        focusNode.dispose();
      });
    });

    group('Styling', () {
      testWidgets('applies padding styling', (tester) async {
        final customStyle = RemixToggleStyle().padding(
          EdgeInsetsGeometryMix.all(16.0),
        );

        await tester.pumpRemixApp(
          RemixToggle(
            selected: false,
            onChanged: (value) {},
            label: 'Bold',
            style: customStyle,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixToggle), findsOneWidget);
      });

      testWidgets('applies multiple style methods', (tester) async {
        final customStyle = RemixToggleStyle()
            .backgroundColor(Colors.blue)
            .labelColor(Colors.white)
            .iconColor(Colors.white)
            .padding(EdgeInsetsGeometryMix.all(8.0))
            .decoration(
              BoxDecorationMix(
                borderRadius: BorderRadiusMix.circular(8.0),
              ),
            );

        await tester.pumpRemixApp(
          RemixToggle(
            selected: false,
            onChanged: (value) {},
            label: 'Bold',
            icon: Icons.format_bold,
            style: customStyle,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixToggle), findsOneWidget);
      });

      testWidgets('applies animation config', (tester) async {
        final customStyle = RemixToggleStyle().animate(
          AnimationConfig.linear(const Duration(milliseconds: 200)),
        );

        await tester.pumpRemixApp(
          RemixToggle(
            selected: false,
            onChanged: (value) {},
            label: 'Bold',
            style: customStyle,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixToggle), findsOneWidget);
      });
    });

    group('Fortal Styles', () {
      testWidgets('renders with ghost variant', (tester) async {
        await tester.pumpRemixApp(
          RemixToggle(
            selected: false,
            onChanged: (value) {},
            label: 'Bold',
            style: FortalToggleStyles.ghost(),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixToggle), findsOneWidget);
      });

      testWidgets('renders with outline variant', (tester) async {
        await tester.pumpRemixApp(
          RemixToggle(
            selected: false,
            onChanged: (value) {},
            label: 'Bold',
            style: FortalToggleStyles.outline(),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixToggle), findsOneWidget);
      });

      testWidgets('renders with all sizes', (tester) async {
        for (final size in FortalToggleSize.values) {
          await tester.pumpRemixApp(
            RemixToggle(
              selected: false,
              onChanged: (value) {},
              label: 'Bold',
              style: FortalToggleStyles.ghost(size: size),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.byType(RemixToggle), findsOneWidget);
        }
      });

      testWidgets('create factory works for all variant/size combos', (
        tester,
      ) async {
        for (final variant in FortalToggleVariant.values) {
          for (final size in FortalToggleSize.values) {
            await tester.pumpRemixApp(
              RemixToggle(
                selected: false,
                onChanged: (value) {},
                label: 'Bold',
                style: FortalToggleStyles.create(
                  variant: variant,
                  size: size,
                ),
              ),
            );
            await tester.pumpAndSettle();

            expect(find.byType(RemixToggle), findsOneWidget);
          }
        }
      });
    });

    group('Semantics and Accessibility', () {
      testWidgets('accepts semanticLabel parameter', (tester) async {
        await tester.pumpRemixApp(
          RemixToggle(
            selected: false,
            onChanged: (value) {},
            label: 'Bold',
            semanticLabel: 'Toggle bold formatting',
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixToggle), findsOneWidget);
      });
    });

    group('Mouse Cursor', () {
      testWidgets('accepts mouseCursor parameter', (tester) async {
        await tester.pumpRemixApp(
          RemixToggle(
            selected: false,
            onChanged: (value) {},
            label: 'Bold',
            mouseCursor: SystemMouseCursors.forbidden,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixToggle), findsOneWidget);
      });
    });

    group('Haptic Feedback', () {
      testWidgets('handles disabled feedback', (tester) async {
        await tester.pumpRemixApp(
          RemixToggle(
            selected: false,
            onChanged: (value) {},
            label: 'Bold',
            enableFeedback: false,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixToggle), findsOneWidget);
      });
    });

    group('Key Parameter', () {
      testWidgets('accepts and respects key parameter', (tester) async {
        const key = ValueKey('toggle_key');

        await tester.pumpRemixApp(
          RemixToggle(
            key: key,
            selected: false,
            onChanged: (value) {},
            label: 'Bold',
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byKey(key), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles rapid toggling', (tester) async {
        bool toggleValue = false;

        await tester.pumpRemixApp(
          StatefulBuilder(
            builder: (context, setState) {
              return RemixToggle(
                selected: toggleValue,
                onChanged: (value) {
                  setState(() {
                    toggleValue = value;
                  });
                },
                label: 'Bold',
              );
            },
          ),
        );
        await tester.pumpAndSettle();

        for (int i = 0; i < 10; i++) {
          await tester.tap(find.byType(RemixToggle));
          await tester.pump();
        }
        await tester.pumpAndSettle();

        expect(find.byType(RemixToggle), findsOneWidget);
      });
    });

    group('State Changes', () {
      testWidgets('updates when selected value changes programmatically', (
        tester,
      ) async {
        bool toggleValue = false;

        await tester.pumpRemixApp(
          StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: [
                  RemixToggle(
                    selected: toggleValue,
                    onChanged: (value) {
                      setState(() {
                        toggleValue = value;
                      });
                    },
                    label: 'Bold',
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        toggleValue = !toggleValue;
                      });
                    },
                    child: const Text('Toggle Programmatically'),
                  ),
                ],
              );
            },
          ),
        );
        await tester.pumpAndSettle();

        expect(toggleValue, isFalse);

        await tester.tap(find.text('Toggle Programmatically'));
        await tester.pumpAndSettle();

        expect(toggleValue, isTrue);
      });
    });
  });
}
