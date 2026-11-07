import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:remix/src/utilities/remix_path_icon.dart';

import '../../helpers/test_helpers.dart';
import '../../helpers/test_methods.dart';

void main() {
  group('RemixCheckbox', () {
    group('Basic Rendering', () {
      testWidgets('renders checkbox with minimal props', (tester) async {
        await tester.pumpRemixApp(
          RemixCheckbox(selected: false, onChanged: (value) {}),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixCheckbox), findsOneWidget);
        expect(find.byType(Box), findsOneWidget);
      });

      testWidgets('renders checkbox with all props', (tester) async {
        await tester.pumpRemixApp(
          RemixCheckbox(
            selected: true,
            onChanged: (value) {},
            enabled: true,
            tristate: false,
            autofocus: false,
            checkedIcon: Icons.check,
            uncheckedIcon: Icons.close,
            indeterminateIcon: Icons.remove,
            enableFeedback: true,
            style: CheckboxStyler.create(),
            semanticLabel: 'Test Checkbox',
            mouseCursor: SystemMouseCursors.click,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixCheckbox), findsOneWidget);
        expect(find.byType(Box), findsOneWidget);
        expect(find.byType(StyledIcon), findsOneWidget);
      });
    });

    group('State Handling', () {
      testWidgets('renders unchecked state', (tester) async {
        await tester.pumpRemixApp(
          RemixCheckbox(selected: false, onChanged: (value) {}),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixCheckbox), findsOneWidget);
        expect(find.byType(Box), findsOneWidget);
        expect(find.byType(StyledIcon), findsNothing);
      });

      testWidgets('renders checked state', (tester) async {
        await tester.pumpRemixApp(
          RemixCheckbox(selected: true, onChanged: (value) {}),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixCheckbox), findsOneWidget);
        expect(find.byType(Box), findsOneWidget);
        expect(_pathGlyph(RemixPathGlyph.thickCheck), findsOneWidget);
      });

      testWidgets('renders indeterminate state when tristate is true', (
        tester,
      ) async {
        await tester.pumpRemixApp(
          RemixCheckbox(selected: null, tristate: true, onChanged: (value) {}),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixCheckbox), findsOneWidget);
        expect(find.byType(Box), findsOneWidget);
        expect(
          _pathGlyph(RemixPathGlyph.thickDividerHorizontal),
          findsOneWidget,
        );
      });
    });

    group('WidgetStateController', () {
      widgetControllerTest<CheckboxSpec>(
        'contains disabled state when enabled is false',
        build: () => RemixCheckbox(
          selected: false,
          enabled: false,
          onChanged: (value) {},
        ),
        expectedStates: {WidgetState.disabled},
      );

      widgetControllerTest<CheckboxSpec>(
        'contains hovered state when hovered',
        build: () => RemixCheckbox(selected: false, onChanged: (value) {}),
        act: hoverAction<RemixCheckbox>,
        expectedStates: {WidgetState.hovered},
      );

      widgetControllerTest<CheckboxSpec>(
        'contains focused state when focused',
        build: () => RemixCheckbox(selected: false, onChanged: (value) {}),
        act: focusAction<RemixCheckbox>,
        expectedStates: {WidgetState.focused},
      );

      widgetControllerTest<CheckboxSpec>(
        'contains pressed state when pressed',
        build: () => RemixCheckbox(selected: false, onChanged: (value) {}),
        act: pressAction<RemixCheckbox>,
        expectedStates: {WidgetState.pressed},
      );
    });

    group('Icon Handling', () {
      testWidgets('uses default checked path', (tester) async {
        await tester.pumpRemixApp(
          RemixCheckbox(selected: true, onChanged: (value) {}),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixCheckbox), findsOneWidget);
        expect(find.byType(StyledIcon), findsNothing);
        expect(_pathGlyph(RemixPathGlyph.thickCheck), findsOneWidget);
      });

      testWidgets('uses custom checked icon', (tester) async {
        await tester.pumpRemixApp(
          RemixCheckbox(
            selected: true,
            checkedIcon: Icons.done,
            onChanged: (value) {},
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixCheckbox), findsOneWidget);
        expect(find.byType(StyledIcon), findsOneWidget);
        expect(find.byIcon(Icons.done), findsOneWidget);
      });

      testWidgets('uses custom unchecked icon', (tester) async {
        await tester.pumpRemixApp(
          RemixCheckbox(
            selected: false,
            uncheckedIcon: Icons.radio_button_unchecked,
            onChanged: (value) {},
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixCheckbox), findsOneWidget);
        expect(find.byType(StyledIcon), findsOneWidget);
        expect(find.byIcon(Icons.radio_button_unchecked), findsOneWidget);
      });

      testWidgets('uses custom indeterminate icon', (tester) async {
        await tester.pumpRemixApp(
          RemixCheckbox(
            selected: null,
            tristate: true,
            indeterminateIcon: Icons.minimize,
            onChanged: (value) {},
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixCheckbox), findsOneWidget);
        expect(find.byType(StyledIcon), findsOneWidget);
        expect(find.byIcon(Icons.minimize), findsOneWidget);
      });

      testWidgets('renders no icon when uncheckedIcon is null', (tester) async {
        await tester.pumpRemixApp(
          RemixCheckbox(
            selected: false,
            uncheckedIcon: null,
            onChanged: (value) {},
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixCheckbox), findsOneWidget);
        expect(find.byType(Box), findsOneWidget);
        expect(find.byType(StyledIcon), findsNothing);
      });
    });

    group('Interaction', () {
      testWidgets('calls onChanged when tapped', (tester) async {
        bool? receivedValue;
        await tester.pumpRemixApp(
          RemixCheckbox(
            selected: false,
            onChanged: (value) => receivedValue = value,
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(RemixCheckbox));
        await tester.pumpAndSettle();

        expect(receivedValue, equals(true));
      });

      testWidgets('does not call onChanged when disabled', (tester) async {
        bool? receivedValue;
        await tester.pumpRemixApp(
          RemixCheckbox(
            selected: false,
            enabled: false,
            onChanged: (value) => receivedValue = value,
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(RemixCheckbox));
        await tester.pumpAndSettle();

        expect(receivedValue, isNull);
      });

      testWidgets('handles tristate onChanged correctly', (tester) async {
        bool? receivedValue;
        await tester.pumpRemixApp(
          RemixCheckbox(
            selected: false,
            tristate: true,
            onChanged: (value) => receivedValue = value,
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(RemixCheckbox));
        await tester.pumpAndSettle();

        expect(receivedValue, equals(true));
      });

      testWidgets('handles non-tristate onChanged correctly', (tester) async {
        bool? receivedValue;
        await tester.pumpRemixApp(
          RemixCheckbox(
            selected: false,
            tristate: false,
            onChanged: (value) => receivedValue = value,
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(RemixCheckbox));
        await tester.pumpAndSettle();

        expect(receivedValue, equals(true));
      });
    });

    group('Focus and Keyboard', () {
      testWidgets('autofocus requests focus on mount', (tester) async {
        final focusNode = FocusNode();
        addTearDown(() => focusNode.dispose());

        await tester.pumpRemixApp(
          RemixCheckbox(
            selected: false,
            onChanged: (value) {},
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
          RemixCheckbox(
            selected: false,
            onChanged: (value) {},
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
        final semantics = tester.ensureSemantics();
        try {
          await tester.pumpRemixApp(
            RemixCheckbox(
              selected: false,
              onChanged: (value) {},
              semanticLabel: 'Custom Semantic Label',
            ),
          );
          await tester.pumpAndSettle();

          expect(find.byType(RemixCheckbox), findsOneWidget);
          expect(find.byType(Box), findsOneWidget);
          expect(
            find.bySemanticsLabel('Custom Semantic Label'),
            findsOneWidget,
          );
        } finally {
          semantics.dispose();
        }
      });

      testWidgets('renders correctly in checked state', (tester) async {
        await tester.pumpRemixApp(
          RemixCheckbox(selected: true, onChanged: (value) {}),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixCheckbox), findsOneWidget);
        expect(find.byType(Box), findsOneWidget);
        expect(_pathGlyph(RemixPathGlyph.thickCheck), findsOneWidget);
      });
    });

    group('Layout and Sizing', () {
      for (final (name, selected, customIcon) in [
        ('checked path', true, false),
        ('indeterminate path', null, false),
        ('checked icon', true, true),
        ('indeterminate icon', null, true),
        ('unchecked icon', false, true),
      ]) {
        testWidgets('$name keeps its size and is centered', (tester) async {
          await tester.pumpRemixApp(
            RemixCheckbox(
              selected: selected,
              tristate: true,
              checkedIcon: customIcon ? Icons.check : null,
              indeterminateIcon: customIcon ? Icons.remove : null,
              uncheckedIcon: customIcon ? Icons.close : null,
              onChanged: (_) {},
              style: CheckboxStyler().size(20, 20).iconSize(12),
            ),
          );

          final indicator = find.byType(
            customIcon ? StyledIcon : RemixPathIcon,
          );
          final box = find.byType(Box);
          expect(tester.getSize(indicator), const Size.square(12));
          expect(tester.getSize(box), const Size.square(20));
          expect(tester.getCenter(indicator), tester.getCenter(box));
          expect(
            tester.getSize(find.byType(RemixCheckbox)),
            const Size.square(48),
          );
        });
      }

      testWidgets('unsized checkbox shrink-wraps its indicator', (
        tester,
      ) async {
        await tester.pumpRemixApp(
          RemixCheckbox(
            selected: true,
            onChanged: (_) {},
            style: CheckboxStyler().iconSize(12),
          ),
        );

        expect(tester.getSize(find.byType(Box)), const Size.square(12));
        expect(
          tester.getSize(find.byType(RemixCheckbox)),
          const Size.square(48),
        );
      });

      testWidgets('preserves explicit indicator alignment', (tester) async {
        await tester.pumpRemixApp(
          RemixCheckbox(
            selected: true,
            onChanged: (_) {},
            style: CheckboxStyler()
                .size(20, 20)
                .iconSize(12)
                .alignment(.topLeft),
          ),
        );

        final indicator = find.byType(RemixPathIcon);
        expect(tester.getSize(indicator), const Size.square(12));
        expect(
          tester.getTopLeft(indicator),
          tester.getTopLeft(find.byType(Box)),
        );
      });

      testWidgets('centers within the padded content area', (tester) async {
        await tester.pumpRemixApp(
          RemixCheckbox(
            selected: true,
            onChanged: (_) {},
            style: CheckboxStyler()
                .size(24, 24)
                .iconSize(12)
                .padding(.only(left: 4, top: 2)),
          ),
        );

        final indicator = find.byType(RemixPathIcon);
        expect(tester.getSize(indicator), const Size.square(12));
        expect(
          tester.getCenter(indicator),
          tester.getCenter(find.byType(Box)) + const Offset(2, 1),
        );
      });

      testWidgets('respects indicator size from a raw styleSpec', (
        tester,
      ) async {
        await tester.pumpRemixApp(
          RemixCheckbox(
            selected: true,
            onChanged: (_) {},
            styleSpec: const CheckboxSpec(
              container: StyleSpec(
                spec: BoxSpec(
                  constraints: BoxConstraints.tightFor(width: 20, height: 20),
                ),
              ),
              indicator: StyleSpec(spec: IconSpec(size: 12)),
            ),
          ),
        );

        final indicator = find.byType(RemixPathIcon);
        expect(tester.getSize(indicator), const Size.square(12));
        expect(tester.getCenter(indicator), tester.getCenter(find.byType(Box)));
      });

      testWidgets('checkbox adapts to custom size', (tester) async {
        final smallStyle = CheckboxStyler().size(16.0, 16.0);
        await tester.pumpRemixApp(
          RemixCheckbox(
            selected: false,
            onChanged: (value) {},
            style: smallStyle,
          ),
        );
        await tester.pumpAndSettle();

        final smallSize = tester.getSize(find.byType(Box));

        final largeStyle = CheckboxStyler().size(32.0, 32.0);
        await tester.pumpRemixApp(
          RemixCheckbox(
            selected: false,
            onChanged: (value) {},
            style: largeStyle,
          ),
        );
        await tester.pumpAndSettle();

        final largeSize = tester.getSize(find.byType(Box));

        expect(largeSize.width, greaterThan(smallSize.width));
        expect(largeSize.height, greaterThan(smallSize.height));
      });
    });

    group('StyleSpec Parameter', () {
      testWidgets('applies raw styleSpec when provided', (tester) async {
        const spec = CheckboxSpec(
          container: StyleSpec(
            spec: BoxSpec(decoration: BoxDecoration(color: Colors.red)),
          ),
        );

        await tester.pumpRemixApp(
          RemixCheckbox(
            selected: false,
            onChanged: (value) {},
            styleSpec: spec,
          ),
        );
        await tester.pumpAndSettle();

        final decorations = tester
            .widgetList<Box>(find.byType(Box))
            .map((box) => box.styleSpec?.spec.decoration);

        expect(
          decorations,
          contains(equals(const BoxDecoration(color: Colors.red))),
        );
      });
    });

    group('Edge Cases', () {
      testWidgets('handles null onChanged gracefully', (tester) async {
        await tester.pumpRemixApp(
          RemixCheckbox(selected: false, onChanged: null),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixCheckbox), findsOneWidget);
        expect(find.byType(Box), findsOneWidget);
      });

      testWidgets('handles tristate with null selected', (tester) async {
        await tester.pumpRemixApp(
          RemixCheckbox(selected: null, tristate: true, onChanged: (value) {}),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixCheckbox), findsOneWidget);
        expect(find.byType(Box), findsOneWidget);
        expect(
          _pathGlyph(RemixPathGlyph.thickDividerHorizontal),
          findsOneWidget,
        );
      });

      testWidgets('handles tristate with true selected', (tester) async {
        await tester.pumpRemixApp(
          RemixCheckbox(selected: true, tristate: true, onChanged: (value) {}),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixCheckbox), findsOneWidget);
        expect(find.byType(Box), findsOneWidget);
        expect(_pathGlyph(RemixPathGlyph.thickCheck), findsOneWidget);
      });
    });
  });
}

Finder _pathGlyph(RemixPathGlyph glyph) => find.byWidgetPredicate(
  (widget) => widget is RemixPathIcon && widget.glyph == glyph,
);
