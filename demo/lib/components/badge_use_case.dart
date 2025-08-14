import 'package:flutter/material.dart' hide Badge;
import 'package:remix/remix_new.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Badge Component',
  type: RemixBadge,
)
Widget buildAvatarUseCase(BuildContext context) {
  return Scaffold(
    body: Center(
      child: RemixBadge(
        label: context.knobs.string(
          label: 'Label',
          initialValue: 'New',
        ),
      ),
    ),
  );
}
