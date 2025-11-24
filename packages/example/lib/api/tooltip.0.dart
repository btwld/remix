import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

// Inspired by Lemonsqueezy
// https://www.lemonsqueezy.com/wedges/docs/components/input

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(backgroundColor: Colors.white, body: TooltipExample()),
    ),
  );
}

class TooltipExample extends StatelessWidget {
  const TooltipExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 24,
        children: [
          RemixTooltip(
            tooltipChild: const Text('Default tooltip'),
            style: styleDefault,
            child: const _TriggerButton(label: 'Default'),
          ),
          RemixTooltip(
            tooltipChild: const Text('Quick tooltip!'),
            style: styleFast,
            child: const _TriggerButton(label: 'Fast'),
          ),
          RemixTooltip(
            tooltipChild: const Text('Slow tooltip'),
            style: styleSlow,
            child: const _TriggerButton(label: 'Slow'),
          ),
        ],
      ),
    );
  }

  RemixTooltipStyle get styleDefault {
    return RemixTooltipStyle()
        .padding(EdgeInsetsGeometryMix.symmetric(horizontal: 12, vertical: 8))
        .color(Colors.black87)
        .borderRadius(BorderRadiusGeometryMix.all(const .circular(6)))
        .wrap(.defaultTextStyle(style: .color(Colors.white).fontSize(14)));
  }

  RemixTooltipStyle get styleFast {
    return styleDefault
        .waitDuration(const Duration(milliseconds: 100))
        .showDuration(const Duration(milliseconds: 800));
  }

  RemixTooltipStyle get styleSlow {
    return styleDefault
        .waitDuration(const Duration(seconds: 1))
        .showDuration(const Duration(seconds: 3));
  }
}

class _TriggerButton extends StatelessWidget {
  const _TriggerButton({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }
}
