import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Card Component',
  type: RemixCard,
)
Widget buildCard(BuildContext context) {
  return Scaffold(
    body: Center(
      child: RemixCard(
        child: RowBox(
          style: $flexbox
            ..spacing(12)
            ..mainAxisSize(MainAxisSize.min),
          children: [
            RemixAvatar(label: 'LF'),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StyledText(
                  'Leo Farias',
                  style: $text
                    ..style.fontSize(14)
                    ..style.fontWeight(FontWeight.bold)
                    ..style.color.black87(),
                ),
                StyledText(
                  'Flutter Engineer',
                  style: $text
                    ..style.fontSize(12)
                    ..style.color.black54(),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
