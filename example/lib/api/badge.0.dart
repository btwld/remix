import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

// Inspired by line design system
// https://designsystem.line.me/LDSG/components/indicators/badge-en

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: BadgeExample(),
      ),
    ),
  );
}

class BadgeExample extends StatelessWidget {
  const BadgeExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 16,
        children: [
          RemixBadge(
            label: '8',
            style: styleLabel,
          ),
          RemixBadge(
            style: styleIcon,
            child: const Icon(
              Icons.camera_alt,
            ),
          ),
        ],
      ),
    );
  }

  RemixBadgeStyle get styleLabel {
    return RemixBadgeStyle()
        .size(24, 24)
        .wrapClipOval()
        .label(
          TextStyler()
              .fontSize(15)
              .wrapAlign(Alignment.center)
              .fontFeatures([const FontFeature.tabularFigures()]),
        )
        .color(Colors.greenAccent.shade700)
        .labelColor(Colors.white)
        .labelFontWeight(FontWeight.bold)
        .labelFontSize(15);
  }

  RemixBadgeStyle get styleIcon {
    return RemixBadgeStyle()
        .size(24, 24)
        .wrapClipOval()
        .label(
          TextStyler()
              .fontSize(15)
              .wrapAlign(Alignment.center)
              .fontFeatures([const FontFeature.tabularFigures()]),
        )
        .color(Colors.redAccent)
        .wrapIconTheme(const IconThemeData(color: Colors.white, size: 15));
  }
}
