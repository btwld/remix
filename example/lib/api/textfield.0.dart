import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

// Inspired by Lemonsqueezy
// https://www.lemonsqueezy.com/wedges/docs/components/input

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: TextfieldExample(),
      ),
    ),
  );
}

class TextfieldExample extends StatefulWidget {
  const TextfieldExample({super.key});

  @override
  State<TextfieldExample> createState() => _TextfieldExampleState();
}

class _TextfieldExampleState extends State<TextfieldExample> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        child: RemixTextField(
          controller: controller,
          hintText: 'Placeholder',
          label: 'Label',
          helperText: 'Required field',
          style: style,
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
        .hintColor(Colors.blueGrey.shade500)
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
