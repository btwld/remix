import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(backgroundColor: Colors.black, body: ButtonExample()),
    ),
  );
}

class ButtonExample extends StatelessWidget {
  const ButtonExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: .center,
        spacing: 16,
        children: [
          RemixButton(
            onPressed: () {},
            label: 'Turn Off',
            style: destructiveStyle,
          ),
          RemixButton(onPressed: () {}, label: 'Turn on', style: successStyle),
        ],
      ),
    );
  }

  RemixButtonStyle get destructiveStyle {
    return RemixButtonStyle()
        .paddingX(16)
        .paddingY(10)
        .color(const Color(0xFF4D1919))
        .shadow(
          BoxShadowMix().color(Colors.redAccent).blurRadius(10).spreadRadius(0),
        )
        .label(TextStyler().uppercase().color(Colors.redAccent))
        .shapeBeveledRectangle(
          borderRadius: BorderRadiusMix()
              .bottomLeft(const Radius.circular(12))
              .topRight(const Radius.circular(12)),
          side: BorderSideMix.width(1).color(Colors.redAccent),
        )
        .wrap(WidgetModifierConfig.scale(x: 1, y: 1))
        .onPressed(
          RemixButtonStyle().wrap(WidgetModifierConfig.scale(x: 0.90, y: 0.90)),
        )
        .onHovered(
          RemixButtonStyle()
              .color(const Color(0xFF732D2D))
              .animate(.spring(300.ms)),
        )
        .onFocused(RemixButtonStyle().color(const Color(0xFF732D2D)));
  }

  RemixButtonStyle get successStyle {
    return destructiveStyle
        .color(const Color.fromARGB(255, 15, 61, 15))
        .label(TextStyler().uppercase().color(Colors.greenAccent))
        .shapeBeveledRectangle(side: BorderSideMix().color(Colors.greenAccent))
        .shadow(
          BoxShadowMix()
              .color(Colors.greenAccent)
              .blurRadius(10)
              .spreadRadius(0),
        )
        .onHovered(RemixButtonStyle().color(const Color(0xFF357857)))
        .onFocused(RemixButtonStyle().color(const Color(0xFF357857)));
  }
}
