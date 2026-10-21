import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

void main() {
  testWidgets(
    'onFocusVisible item styles follow focus visibility changes',
    (tester) async {
      await tester.pumpWidget(
        MixScope.empty(
          child: MaterialApp(
            home: Scaffold(
              body: Center(
                child: RemixMenu<String>(
                  trigger: const RemixMenuTrigger(label: 'Options'),
                  onSelected: (_) {},
                  items: const [
                    RemixMenuItem(value: 'copy', label: 'Copy'),
                    RemixMenuItem(value: 'paste', label: 'Paste'),
                  ],
                  style: MenuStyler().item(
                    MenuItemStyler()
                        .label(TextStyler().fontSize(12))
                        .onFocusVisible(
                          MenuItemStyler().label(TextStyler().fontSize(30)),
                        ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      double? fontSize(String label) => tester
          .widget<RichText>(
            find.descendant(
              of: find.text(label),
              matching: find.byType(RichText),
            ),
          )
          .text
          .style
          ?.fontSize;

      await tester.tap(find.text('Options'));
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      expect(fontSize('Copy'), 30);

      // Only visibility changes here, so only the scope can restyle the item.
      FocusManager.instance.highlightStrategy = .alwaysTouch;
      await tester.pump();
      expect(fontSize('Copy'), 12);
    },
    variant: const TargetPlatformVariant({.macOS}),
  );
}
