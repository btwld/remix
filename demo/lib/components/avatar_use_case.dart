import 'package:demo/helpers/knob_builder.dart';
import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final _key = GlobalKey();

@widgetbook.UseCase(
  name: 'Avatar Component',
  type: XAvatar,
)
Widget buildAvatarUseCase(BuildContext context) {
  final imageUrl = context.knobs.string(
    label: 'Image URL',
    initialValue: 'https://i.pravatar.cc/150?img=48',
  );

  return KeyedSubtree(
    key: _key,
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          XAvatar(
            variants: [
              context.knobs.variant(AvatarThemeVariant.values),
            ],
            image: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
            fallbackBuilder: (spec) => spec('CA'),
          ),
        ],
      ),
    ),
  );
}
