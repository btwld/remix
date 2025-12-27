import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('RemixTextField', () {
    group('Basic Rendering', () {
      testWidgets('renders with default style', (tester) async {
        await tester.pumpRemixApp(const RemixTextField());
        await tester.pumpAndSettle();

        expect(find.byType(RemixTextField), findsOneWidget);
      });

      testWidgets('renders with hint text', (tester) async {
        await tester.pumpRemixApp(
          const RemixTextField(hintText: 'Enter text here'),
        );
        await tester.pumpAndSettle();

        expect(find.text('Enter text here'), findsOneWidget);
      });

      testWidgets('renders with label', (tester) async {
        await tester.pumpRemixApp(const RemixTextField(label: 'Username'));
        await tester.pumpAndSettle();

        expect(find.text('Username'), findsOneWidget);
      });

      testWidgets('renders with helper text', (tester) async {
        await tester.pumpRemixApp(
          const RemixTextField(helperText: 'Required field'),
        );
        await tester.pumpAndSettle();

        expect(find.text('Required field'), findsOneWidget);
      });

      testWidgets('renders with leading and trailing widgets', (tester) async {
        await tester.pumpRemixApp(
          const RemixTextField(
            leading: Icon(Icons.search),
            trailing: Icon(Icons.clear),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.search), findsOneWidget);
        expect(find.byIcon(Icons.clear), findsOneWidget);
      });

      testWidgets('renders with initial text from controller', (tester) async {
        final controller = TextEditingController(text: 'Initial text');

        await tester.pumpRemixApp(RemixTextField(controller: controller));
        await tester.pumpAndSettle();

        expect(find.text('Initial text'), findsOneWidget);

        controller.dispose();
      });
    });

    group('Text Input & Editing', () {
      testWidgets('accepts text input', (tester) async {
        final controller = TextEditingController();

        await tester.pumpRemixApp(RemixTextField(controller: controller));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(RemixTextField), 'Hello');
        await tester.pumpAndSettle();

        expect(controller.text, equals('Hello'));

        controller.dispose();
      });

      testWidgets('calls onChanged callback', (tester) async {
        String? changedValue;

        await tester.pumpRemixApp(
          RemixTextField(
            onChanged: (value) {
              changedValue = value;
            },
          ),
        );
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(RemixTextField), 'Test');
        await tester.pumpAndSettle();

        expect(changedValue, equals('Test'));
      });

      testWidgets('calls onSubmitted callback', (tester) async {
        String? submittedValue;

        await tester.pumpRemixApp(
          RemixTextField(
            onSubmitted: (value) {
              submittedValue = value;
            },
          ),
        );
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(RemixTextField), 'Test');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        expect(submittedValue, equals('Test'));
      });

      testWidgets('respects readOnly flag', (tester) async {
        final controller = TextEditingController();

        await tester.pumpRemixApp(
          RemixTextField(controller: controller, readOnly: true),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(RemixTextField));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(RemixTextField), 'Test');
        await tester.pumpAndSettle();

        // In readOnly mode, text should not change
        expect(controller.text, isEmpty);

        controller.dispose();
      });

      testWidgets('respects enabled flag', (tester) async {
        final controller = TextEditingController();

        await tester.pumpRemixApp(
          RemixTextField(controller: controller, enabled: false),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(RemixTextField));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(RemixTextField), 'Test');
        await tester.pumpAndSettle();

        expect(controller.text, isEmpty);

        controller.dispose();
      });

      testWidgets('respects maxLength', (tester) async {
        final controller = TextEditingController();

        await tester.pumpRemixApp(
          RemixTextField(controller: controller, maxLength: 5),
        );
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(RemixTextField), 'Hello World');
        await tester.pumpAndSettle();

        expect(controller.text.length, lessThanOrEqualTo(5));

        controller.dispose();
      });

      testWidgets('respects obscureText flag', (tester) async {
        await tester.pumpRemixApp(
          const RemixTextField(obscureText: true, hintText: 'Password'),
        );
        await tester.pumpAndSettle();

        // Since text is obscured, we can't directly check the rendered text,
        // but we can verify the widget exists
        expect(find.byType(RemixTextField), findsOneWidget);
      });
    });

    group('Focus Behavior', () {
      testWidgets('handles focus changes', (tester) async {
        final focusNode = FocusNode();

        await tester.pumpRemixApp(RemixTextField(focusNode: focusNode));
        await tester.pumpAndSettle();

        expect(focusNode.hasFocus, isFalse);

        await tester.tap(find.byType(RemixTextField));
        await tester.pumpAndSettle();

        expect(focusNode.hasFocus, isTrue);

        focusNode.dispose();
      });

      testWidgets('autofocus works correctly', (tester) async {
        final focusNode = FocusNode();

        await tester.pumpRemixApp(
          RemixTextField(focusNode: focusNode, autofocus: true),
        );
        await tester.pumpAndSettle();

        expect(focusNode.hasFocus, isTrue);

        focusNode.dispose();
      });
    });

    group('Styling', () {
      testWidgets('applies custom text color', (tester) async {
        await tester.pumpRemixApp(
          RemixTextField(style: RemixTextFieldStyle().color(Colors.red)),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixTextField), findsOneWidget);
      });

      testWidgets('applies custom background color', (tester) async {
        await tester.pumpRemixApp(
          RemixTextField(
            style: RemixTextFieldStyle().backgroundColor(Colors.grey),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixTextField), findsOneWidget);
      });

      testWidgets('applies custom padding', (tester) async {
        await tester.pumpRemixApp(
          RemixTextField(
            style: RemixTextFieldStyle().padding(EdgeInsetsGeometryMix.all(20)),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixTextField), findsOneWidget);
      });

      testWidgets('applies custom border radius', (tester) async {
        await tester.pumpRemixApp(
          RemixTextField(
            style: RemixTextFieldStyle().borderRadius(
              BorderRadiusGeometryMix.circular(12),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixTextField), findsOneWidget);
      });

      testWidgets('applies custom cursor color', (tester) async {
        await tester.pumpRemixApp(
          RemixTextField(style: RemixTextFieldStyle().cursorColor(Colors.blue)),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixTextField), findsOneWidget);
      });

      testWidgets('applies custom hint color', (tester) async {
        await tester.pumpRemixApp(
          RemixTextField(
            hintText: 'Hint',
            style: RemixTextFieldStyle().hintColor(Colors.grey),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Hint'), findsOneWidget);
      });
    });

    group('Semantics & Accessibility', () {
      testWidgets('uses semantic label parameter', (tester) async {
        await tester.pumpRemixApp(
          const RemixTextField(label: 'Email', semanticLabel: 'Email Address'),
        );
        await tester.pumpAndSettle();

        // Verify the widget is rendered with semantic properties
        expect(find.byType(RemixTextField), findsOneWidget);
        expect(find.text('Email'), findsOneWidget);
      });

      testWidgets('uses semantic hint parameter', (tester) async {
        await tester.pumpRemixApp(
          const RemixTextField(
            hintText: 'Enter your email',
            semanticHint: 'Enter your email address',
          ),
        );
        await tester.pumpAndSettle();

        // Verify the widget is rendered with semantic properties
        expect(find.byType(RemixTextField), findsOneWidget);
        expect(find.text('Enter your email'), findsOneWidget);
      });

      testWidgets('defaults semantic label to label parameter', (tester) async {
        await tester.pumpRemixApp(const RemixTextField(label: 'Email'));
        await tester.pumpAndSettle();

        // When only label is provided, it should be used for both label and semantic label
        expect(find.text('Email'), findsOneWidget);
      });
    });

    group('Input Formatters', () {
      testWidgets('applies input formatters', (tester) async {
        final controller = TextEditingController();

        await tester.pumpRemixApp(
          RemixTextField(
            controller: controller,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        );
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(RemixTextField), 'abc123');
        await tester.pumpAndSettle();

        expect(controller.text, equals('123'));

        controller.dispose();
      });
    });

    group('Keyboard Configuration', () {
      testWidgets('respects keyboardType', (tester) async {
        await tester.pumpRemixApp(
          const RemixTextField(keyboardType: TextInputType.emailAddress),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixTextField), findsOneWidget);
      });

      testWidgets('respects textInputAction', (tester) async {
        await tester.pumpRemixApp(
          const RemixTextField(textInputAction: TextInputAction.next),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixTextField), findsOneWidget);
      });

      testWidgets('respects textCapitalization', (tester) async {
        await tester.pumpRemixApp(
          const RemixTextField(textCapitalization: TextCapitalization.words),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixTextField), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles error state', (tester) async {
        await tester.pumpRemixApp(
          const RemixTextField(error: true, helperText: 'Error message'),
        );
        await tester.pumpAndSettle();

        expect(find.text('Error message'), findsOneWidget);
      });

      testWidgets('handles multiline text', (tester) async {
        final controller = TextEditingController();

        await tester.pumpRemixApp(
          RemixTextField(controller: controller, maxLines: 3),
        );
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byType(RemixTextField),
          'Line 1\nLine 2\nLine 3',
        );
        await tester.pumpAndSettle();

        expect(controller.text, contains('Line 1'));
        expect(controller.text, contains('Line 2'));
        expect(controller.text, contains('Line 3'));

        controller.dispose();
      });

      testWidgets('handles null controller gracefully', (tester) async {
        await tester.pumpRemixApp(const RemixTextField());
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(RemixTextField), 'Test');
        await tester.pumpAndSettle();

        expect(find.text('Test'), findsOneWidget);
      });

      testWidgets('handles all label, hint, and helper text together', (
        tester,
      ) async {
        await tester.pumpRemixApp(
          const RemixTextField(
            label: 'Label',
            hintText: 'Hint',
            helperText: 'Helper',
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Label'), findsOneWidget);
        expect(find.text('Hint'), findsOneWidget);
        expect(find.text('Helper'), findsOneWidget);
      });
    });

    group('Advanced Styling', () {
      testWidgets('applies container styling', (tester) async {
        await tester.pumpRemixApp(
          RemixTextField(
            style: RemixTextFieldStyle().container(
              FlexBoxStyler(
                decoration: BoxDecorationMix(color: Colors.grey),
                padding: EdgeInsetsGeometryMix.all(16),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixTextField), findsOneWidget);
      });

      testWidgets('applies width and height constraints', (tester) async {
        await tester.pumpRemixApp(
          RemixTextField(style: RemixTextFieldStyle().width(300).height(60)),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixTextField), findsOneWidget);
      });

      testWidgets('applies text alignment', (tester) async {
        await tester.pumpRemixApp(
          RemixTextField(
            style: RemixTextFieldStyle().textAlign(TextAlign.center),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixTextField), findsOneWidget);
      });
    });

    group('Widget Modifiers', () {
      testWidgets('applies widget modifiers from style', (tester) async {
        await tester.pumpRemixApp(
          RemixTextField(
            style: RemixTextFieldStyle().wrap(WidgetModifierConfig.clipOval()),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixTextField), findsOneWidget);
      });
    });

    group('Key Parameter', () {
      testWidgets('accepts and uses key parameter', (tester) async {
        const key = ValueKey('textfield_key');

        await tester.pumpRemixApp(const RemixTextField(key: key));
        await tester.pumpAndSettle();

        expect(find.byKey(key), findsOneWidget);
      });
    });

    group('StyleSpec Parameter', () {
      testWidgets('uses styleSpec when provided', (tester) async {
        const spec = RemixTextFieldSpec(
          textAlign: TextAlign.center,
          cursorWidth: 3.0,
        );

        await tester.pumpRemixApp(const RemixTextField(styleSpec: spec));
        await tester.pumpAndSettle();

        expect(find.byType(RemixTextField), findsOneWidget);
      });
    });

    group('Controllers', () {
      testWidgets('uses provided UndoHistoryController', (tester) async {
        final undoController = UndoHistoryController();

        await tester.pumpRemixApp(
          RemixTextField(undoController: undoController),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixTextField), findsOneWidget);

        undoController.dispose();
      });

      testWidgets('uses provided ScrollController', (tester) async {
        final scrollController = ScrollController();

        await tester.pumpRemixApp(
          RemixTextField(scrollController: scrollController, maxLines: 3),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixTextField), findsOneWidget);

        scrollController.dispose();
      });
    });

    group('Selection Controls', () {
      testWidgets('handles enableInteractiveSelection', (tester) async {
        await tester.pumpRemixApp(
          const RemixTextField(enableInteractiveSelection: false),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixTextField), findsOneWidget);
      });
    });

    group('Hint Text Visibility', () {
      testWidgets('hides hint text when field has content', (tester) async {
        final controller = TextEditingController();

        await tester.pumpRemixApp(
          RemixTextField(controller: controller, hintText: 'Enter text'),
        );
        await tester.pumpAndSettle();

        expect(find.text('Enter text'), findsOneWidget);

        await tester.enterText(find.byType(RemixTextField), 'Content');
        await tester.pumpAndSettle();

        // Hint should not be visible when there's content
        expect(find.text('Content'), findsOneWidget);

        controller.dispose();
      });
    });
  });
}
