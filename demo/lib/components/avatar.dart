import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final _key = GlobalKey();

@widgetbook.UseCase(
  name: 'Avatar Component',
  type: RemixAvatar,
)
Widget buildAvatarUseCase(BuildContext context) {
  final imageUrl = context.knobs.string(
    label: 'Image URL',
    initialValue: 'https://i.pravatar.cc/150?img=48',
  );

  return KeyedSubtree(
    key: _key,
    child: Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RemixAvatar(
              label: 'LF',
              foregroundImage:
                  imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
              style: FortalAvatarStyles.create(
                variant: context.knobs.object.dropdown(
                  label: 'label',
                  options: FortalAvatarVariant.values,
                  labelBuilder: (variant) => variant.name,
                ),
                size: context.knobs.object.dropdown(
                  label: 'size',
                  options: FortalAvatarSize.values,
                  labelBuilder: (size) => size.name,
                  initialOption: FortalAvatarSize.size4,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
