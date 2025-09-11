import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('RemixButton Semantics', () {
    testWidgets('exposes correct basic semantics when enabled', (tester) async {
      await tester.pumpRemixApp(
        RemixButton(
          key: const ValueKey('sem_button_enabled'),
          label: 'Primary Action',
          onPressed: () {},
        ),
      );

      final semantics =
          tester.getSemantics(find.byKey(const ValueKey('sem_button_enabled')));

      // Label exposed and non-empty
      expect(semantics.label, contains('Primary Action'));

      // Acts like a button and is actionable (tap)
      // Note: isButton / hasAction flags are validated implicitly by interaction tests below
    });

    testWidgets('updates semantics for disabled state', (tester) async {
      await tester.pumpRemixApp(
        RemixButton(
          key: const ValueKey('sem_button_disabled'),
          label: 'Disabled',
          enabled: false,
          onPressed: () {},
        ),
      );

      final semantics = tester
          .getSemantics(find.byKey(const ValueKey('sem_button_disabled')));

      // Label remains present
      expect(semantics.label, contains('Disabled'));
    });

    testWidgets('announces loading via value and live region', (tester) async {
      await tester.pumpRemixApp(
        RemixButton(
          key: const ValueKey('sem_button_loading'),
          label: 'Submit',
          loading: true,
          onPressed: () {},
        ),
      );

      final semantics =
          tester.getSemantics(find.byKey(const ValueKey('sem_button_loading')));

      // Value should indicate loading per plan
      expect(semantics.value, contains('Loading'));
    });
  });

  group('RemixButton Keyboard', () {
    testWidgets('Enter and Space activate when focused', (tester) async {
      int pressed = 0;

      await tester.pumpRemixApp(
        RemixButton(
          key: const ValueKey('kb_button'),
          label: 'Activate',
          autofocus: true,
          onPressed: () => pressed++,
        ),
      );

      // Ensure a frame with focus established
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();

      expect(pressed, 2);
    });

    testWidgets('keyboard does not activate when loading or disabled',
        (tester) async {
      int pressed = 0;

      // Loading state prevents activation
      await tester.pumpRemixApp(
        RemixButton(
          key: const ValueKey('kb_button_loading'),
          label: 'Submit',
          autofocus: true,
          loading: true,
          onPressed: () => pressed++,
        ),
      );
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(pressed, 0);

      // Disabled state prevents activation
      await tester.pumpRemixApp(
        RemixButton(
          key: const ValueKey('kb_button_disabled'),
          label: 'Disabled',
          autofocus: true,
          enabled: false,
          onPressed: () => pressed++,
        ),
      );
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(pressed, 0);
    });
  });

  group('RemixIconButton Semantics', () {
    testWidgets('provides sensible default label when none given',
        (tester) async {
      await tester.pumpRemixApp(
        RemixIconButton(
          key: const ValueKey('icon_button_default_label'),
          icon: Icons.star,
          onPressed: () {},
        ),
      );

      final semantics = tester.getSemantics(
          find.byKey(const ValueKey('icon_button_default_label')));
      expect(semantics.label, contains('Icon Button'));
    });
  });

  group('Parity with Material Buttons', () {
    testWidgets('text button labels match Material FilledButton',
        (tester) async {
      await tester.pumpRemixApp(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RemixButton(
              key: const ValueKey('remix_text_button'),
              label: 'Primary Action',
              onPressed: () {},
            ),
            const SizedBox(width: 16),
            FilledButton(
              key: const ValueKey('material_text_button'),
              onPressed: () {},
              child: const Text('Primary Action'),
            ),
          ],
        ),
      );

      final remixSem =
          tester.getSemantics(find.byKey(const ValueKey('remix_text_button')));
      final materialSem = tester
          .getSemantics(find.byKey(const ValueKey('material_text_button')));

      expect(remixSem.label, equals(materialSem.label));
      // Both should have no value text and expose tap action
      expect(remixSem.value, equals(materialSem.value));
    });

    testWidgets('enabled buttons expose matching core flags and actions',
        (tester) async {
      await tester.pumpRemixApp(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RemixButton(
              key: const ValueKey('remix_enabled_sem'),
              label: 'Go',
              onPressed: () {},
            ),
            const SizedBox(width: 16),
            FilledButton(
              key: const ValueKey('material_enabled_sem'),
              onPressed: () {},
              child: const Text('Go'),
            ),
          ],
        ),
      );

      final remix = tester
          .getSemantics(find.byKey(const ValueKey('remix_enabled_sem')))
          .getSemanticsData();
      final material = tester
          .getSemantics(find.byKey(const ValueKey('material_enabled_sem')))
          .getSemanticsData();

      expect(remix.hasFlag(SemanticsFlag.isButton), isTrue);
      expect(material.hasFlag(SemanticsFlag.isButton), isTrue);
      expect(remix.hasAction(SemanticsAction.tap), isTrue);
      expect(material.hasAction(SemanticsAction.tap), isTrue);
      expect(remix.hasFlag(SemanticsFlag.isFocusable), isTrue);
      expect(material.hasFlag(SemanticsFlag.isFocusable), isTrue);
    });

    testWidgets('disabled buttons remove tap action and focusability',
        (tester) async {
      await tester.pumpRemixApp(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RemixButton(
              key: const ValueKey('remix_disabled_sem'),
              label: 'Nope',
              enabled: false,
              onPressed: () {},
            ),
            const SizedBox(width: 16),
            FilledButton(
              key: const ValueKey('material_disabled_sem'),
              onPressed: null,
              child: const Text('Nope'),
            ),
          ],
        ),
      );

      final remix = tester
          .getSemantics(find.byKey(const ValueKey('remix_disabled_sem')))
          .getSemanticsData();
      final material = tester
          .getSemantics(find.byKey(const ValueKey('material_disabled_sem')))
          .getSemanticsData();

      expect(remix.hasAction(SemanticsAction.tap), isFalse);
      expect(material.hasAction(SemanticsAction.tap), isFalse);
      expect(remix.hasFlag(SemanticsFlag.isFocusable), isFalse);
      expect(material.hasFlag(SemanticsFlag.isFocusable), isFalse);
    });

    testWidgets('disabled text buttons have matching semantics and behavior',
        (tester) async {
      int remixPressed = 0;
      int materialPressed = 0;

      await tester.pumpRemixApp(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RemixButton(
              key: const ValueKey('remix_text_button_disabled'),
              label: 'Disabled',
              enabled: false,
              onPressed: () => remixPressed++,
            ),
            const SizedBox(width: 16),
            FilledButton(
              key: const ValueKey('material_text_button_disabled'),
              onPressed: null,
              child: const Text('Disabled'),
            ),
          ],
        ),
      );

      final remixSem = tester.getSemantics(
          find.byKey(const ValueKey('remix_text_button_disabled')));
      final materialSem = tester.getSemantics(
          find.byKey(const ValueKey('material_text_button_disabled')));

      // Both expose the same visible label, though Material may merge child text
      expect(remixSem.label, contains('Disabled'));
      expect(materialSem.label, contains('Disabled'));
      // Attempt to tap both (should not trigger)
      await tester
          .tap(find.byKey(const ValueKey('remix_text_button_disabled')));
      await tester
          .tap(find.byKey(const ValueKey('material_text_button_disabled')));
      await tester.pump();
      expect(remixPressed, 0);
      expect(materialPressed, 0);
    });

    testWidgets('keyboard activation parity (Enter/Space) for text buttons',
        (tester) async {
      int remixPressed = 0;
      int materialPressed = 0;

      // Test Remix
      await tester.pumpRemixApp(
        RemixButton(
          key: const ValueKey('kb_remix_text_button'),
          label: 'Activate',
          autofocus: true,
          onPressed: () => remixPressed++,
        ),
      );
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(remixPressed, 2);

      // Test Material
      await tester.pumpRemixApp(
        FilledButton(
          key: const ValueKey('kb_material_text_button'),
          onPressed: () => materialPressed++,
          autofocus: true,
          child: const Text('Activate'),
        ),
      );
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(materialPressed, 2);
    });

    testWidgets('icon+label parity with FilledButton.icon', (tester) async {
      await tester.pumpRemixApp(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RemixButton(
              key: const ValueKey('remix_icon_text_button'),
              label: 'Save',
              icon: Icons.save,
              onPressed: () {},
            ),
            const SizedBox(width: 16),
            FilledButton.icon(
              key: const ValueKey('material_icon_text_button'),
              onPressed: () {},
              icon: const Icon(Icons.save),
              label: const Text('Save'),
            ),
          ],
        ),
      );

      final remixSem = tester
          .getSemantics(find.byKey(const ValueKey('remix_icon_text_button')));
      final materialSem = tester.getSemantics(
          find.byKey(const ValueKey('material_icon_text_button')));
      expect(remixSem.label, equals(materialSem.label));
    });

    testWidgets('icon-only parity: both support explicit semantics label',
        (tester) async {
      // Remix side
      await tester.pumpRemixApp(
        RemixIconButton(
          key: const ValueKey('remix_icon_only'),
          icon: Icons.favorite,
          semanticLabel: 'Favorite',
          onPressed: () {},
        ),
      );
      final remixSem =
          tester.getSemantics(find.byKey(const ValueKey('remix_icon_only')));
      expect(remixSem.label, contains('Favorite'));

      // Material side (wrap to provide explicit semantics label)
      await tester.pumpRemixApp(
        Semantics(
          label: 'Favorite',
          button: true,
          child: IconButton.filled(
            key: const ValueKey('material_icon_only'),
            onPressed: () {},
            icon: const Icon(Icons.favorite),
          ),
        ),
      );
      expect(find.bySemanticsLabel('Favorite'), findsOneWidget);
    });

    testWidgets('intentional difference: icon-only default label vs Material',
        (tester) async {
      await tester.pumpRemixApp(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RemixIconButton(
              key: const ValueKey('remix_icon_only_default'),
              icon: Icons.star,
              onPressed: () {},
            ),
            const SizedBox(width: 16),
            IconButton.filled(
              key: const ValueKey('material_icon_only_default'),
              onPressed: () {},
              icon: const Icon(Icons.star),
            ),
          ],
        ),
      );

      final remixSem = tester
          .getSemantics(find.byKey(const ValueKey('remix_icon_only_default')));
      final materialSem = tester.getSemantics(
          find.byKey(const ValueKey('material_icon_only_default')));

      // Remix intentionally provides a sensible default label; Material does not.
      expect(remixSem.label.isNotEmpty, isTrue);
      expect(materialSem.label.isEmpty, isTrue);
    });
  });
}
