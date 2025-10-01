import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

// Inspired by gov.br design system
// https://www.gov.br/ds/components/avatar?tab=desenvolvedor


void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        body: AvatarExample(),
      ),
    ),
  );
}

class AvatarExample extends StatelessWidget {
  const AvatarExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 16,
        children: [
          RemixAvatar(
            label: 'LF',
            style: labelStyle,
          ),
          RemixAvatar(
            icon: Icons.person,
            style: iconStyle,
          ),
          RemixAvatar(
            style: image,
          ),
        ],
      ),
    );
  }

  RemixAvatarStyle get labelStyle {
    return RemixAvatarStyle()
        .color(Colors.deepPurpleAccent)
        .size(50, 50)
        .shapeCircle()
        .wrapClipOval()
        .labelColor(Colors.white)
        .labelFontWeight(FontWeight.bold)
        .labelFontSize(15);
  }

  RemixAvatarStyle get iconStyle {
    return RemixAvatarStyle()
        .color(Colors.deepOrangeAccent)
        .size(70, 70)
        .iconColor(Colors.white)
        .iconSize(70)
        .icon(IconStyler().wrapTranslate(x: 0, y: 12))
        .shapeCircle()
        .wrapClipOval();
  }

  RemixAvatarStyle get image {
    return RemixAvatarStyle()
        .size(90, 90)
        .backgroundImageUrl('https://i.pravatar.cc/150?img=48')
        .shapeCircle();
  }
}
