import 'package:flutter/material.dart';
import 'package:naked_ui/naked_ui.dart';

import '../src/example_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleApp(
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Simple Button',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Interact with the button to see its states',
              style: TextStyle(color: Color(0xFF616161)),
            ),
            SizedBox(height: 24),
            ButtonExample(),
          ],
        ),
      ),
    );
  }
}

class ButtonExample extends StatelessWidget {
  const ButtonExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Material's SnackBar needs a Scaffold and this example hosts on
    // WidgetsApp. What this example demonstrates is the button's hover, press
    // and focus surface, so the press just reports.
    return NakedButton(
      onPressed: () => debugPrint('Button pressed!'),
      builder: (context, buttonState, child) {
        const baseColor = Color(0xFF3D3D3D);

        final backgroundColor = buttonState.when(
          pressed: baseColor.withValues(alpha: 0.8),
          hovered: baseColor.withValues(alpha: 0.9),
          orElse: baseColor,
        );

        final scale = buttonState.isPressed ? 0.95 : 1.0;

        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: buttonState.isFocused ? Colors.black : Colors.transparent,
              width: 1,
            ),
          ),
          child: AnimatedScale(
            scale: scale,
            duration: const Duration(milliseconds: 200),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Button',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }
}
