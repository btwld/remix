import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:remix/src/components/avatar/avatar.dart';

void main() {
  group('XAvatar', () {
    testWidgets('renders with custom image', (WidgetTester tester) async {
      final image = MemoryImage(Uint8List.fromList([1, 2, 3]));
      await tester.pumpWidget(
        MaterialApp(
          home: Avatar(
            style: const AvatarStyle(),
            image: image,
            fallbackBuilder: (spec) => spec(''),
          ),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('renders fallback when image fails to load',
        (WidgetTester tester) async {
      const image = NetworkImage('https://example.com/invalid.jpg');
      await tester.pumpWidget(
        MaterialApp(
          home: Avatar(
            style: const AvatarStyle(),
            image: image,
            fallbackBuilder: (spec) => spec('AB'),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('AB'), findsOneWidget);
    });

    testWidgets('applies custom style', (WidgetTester tester) async {
      final color = Colors.redAccent.toDto();

      await tester.pumpWidget(
        MaterialApp(
          home: Avatar(
            style: FakeAvatarStyle(color.value!),
            fallbackBuilder: (TextSpec spec) => spec(''),
          ),
        ),
      );

      final specBuilder = tester.widget<SpecBuilder>(find.byType(SpecBuilder));

      final avatarAttr =
          specBuilder.style.styles.whereType<AvatarSpecAttribute>().first;

      expect(avatarAttr.container!.decoration!.color, color);
    });
  });
}

class FakeAvatarStyle extends AvatarStyle {
  final Color color;
  const FakeAvatarStyle(this.color);

  @override
  Style makeStyle(SpecConfiguration<AvatarSpecUtility> spec) {
    final $ = spec.utilities;

    final baseStyle = super.makeStyle(spec);
    return Style.create([
      baseStyle(),
      $.container.color(color),
    ]);
  }
}
