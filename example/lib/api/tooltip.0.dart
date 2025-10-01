import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

// Inspired by Lemonsqueezy
// https://www.lemonsqueezy.com/wedges/docs/components/input

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: TooltipExample(),
      ),
    ),
  );
}

class TooltipExample extends StatefulWidget {
  const TooltipExample({super.key});

  @override
  State<TooltipExample> createState() => _TooltipExampleState();
}

class _TooltipExampleState extends State<TooltipExample> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 300,
        child: RemixTooltip(
          tooltipChild: Text('This is a tooltip'),
          child: Text('Hello'),
        ),
      ),
    );
  }

  RemixTextFieldStyle get style {
    return RemixTextFieldStyle()
        .color(Colors.blue)
        .backgroundColor(Colors.white)
        .borderRadiusAll(const Radius.circular(8.0))
        .height(44)
        .paddingX(12)
        .spacing(8)
        .label(
          TextStyler()
              .color(Colors.blueGrey.shade900)
              .fontWeight(FontWeight.w500),
        )
        .helperText(
          TextStyler()
              .fontWeight(FontWeight.w300)
              .color(Colors.blueGrey.shade600),
        )
        .hintColor(Colors.blueGrey.shade600)
        .shadow(
          BoxShadowMix()
              .blurRadius(4)
              .color(Colors.black12)
              .offset(const Offset(0, 2)),
        )
        .border(
          BoxBorderMix.all(BorderSideMix(color: Colors.grey.shade300)),
        )
        .onFocused(
          RemixTextFieldStyle().border(
            BoxBorderMix.all(
              BorderSideMix()
                  .color(Colors.deepPurpleAccent)
                  .width(3)
                  .strokeAlign(BorderSide.strokeAlignCenter),
            ),
          ),
        );
  }
}
