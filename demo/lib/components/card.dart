import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final _key = GlobalKey();

@widgetbook.UseCase(
  name: 'Card Component',
  type: RemixCard,
)
Widget buildCardUseCase(BuildContext context) {
  return KeyedSubtree(
    key: _key,
    child: Scaffold(
      body: Center(
        child: RemixCard(
          style: FortalCardStyles.create(
            variant: context.knobs.object.dropdown(
              label: 'variant',
              options: FortalCardVariant.values,
              labelBuilder: (variant) => variant.name,
            ),
            size: context.knobs.object.dropdown(
              label: 'size',
              options: FortalCardSize.values,
              labelBuilder: (size) => size.name,
              initialOption: FortalCardSize.size1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              RemixAvatar(
                label: 'LF',
                style: FortalAvatarStyles.create(
                  variant: FortalAvatarVariant.solid,
                  size: FortalAvatarSize.size3,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StyledText(
                    context.knobs.string(
                      label: 'Name',
                      initialValue: 'Leo Farias',
                    ),
                    style: TextStyler()
                        .fontSize(14)
                        .fontWeight(FontWeight.bold)
                        .color(Colors.black),
                  ),
                  StyledText(
                    context.knobs.string(
                      label: 'Title',
                      initialValue: 'Flutter Engineer',
                    ),
                    style: TextStyler().fontSize(12).color(Colors.black54),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
