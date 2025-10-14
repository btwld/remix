import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final _key = GlobalKey();

@widgetbook.UseCase(
  name: 'Menu Component',
  type: RemixMenu,
)
Widget buildMenuUseCase(BuildContext context) {
  final variant = context.knobs.object.dropdown(
    label: 'Variant',
    options: FortalMenuVariant.values,
    initialOption: FortalMenuVariant.solid,
    labelBuilder: (value) => value.name,
  );

  final size = context.knobs.object.dropdown(
    label: 'Size',
    options: FortalMenuSize.values,
    initialOption: FortalMenuSize.size2,
    labelBuilder: (value) => value.name,
  );

  return KeyedSubtree(
    key: _key,
    child: Scaffold(
      body: Center(
        child: SizedBox(
          height: 300,
          width: 300,
          child: Center(
            child: RemixMenu(
              positioning: const OverlayPositionConfig(
                followerAnchor: Alignment.topCenter,
                targetAnchor: Alignment.bottomCenter,
              ),
              trigger: const RemixMenuTrigger(
                label: 'Menu',
                icon: Icons.keyboard_arrow_down,
              ),
              style: FortalMenuStyles.create(variant: variant, size: size),
              items: [
                RemixMenuItem(
                  label: 'Item 1',
                  value: 'item1',
                  style:
                      FortalMenuItemStyles.create(variant: variant, size: size),
                ),
                RemixMenuItem(
                  label: 'Item 2',
                  value: 'item2',
                  style:
                      FortalMenuItemStyles.create(variant: variant, size: size),
                ),
                RemixMenuItem(
                  label: 'Item 3',
                  value: 'item3',
                  style:
                      FortalMenuItemStyles.create(variant: variant, size: size),
                ),
              ],
              onSelected: (value) {},
            ),
          ),
        ),
      ),
    ),
  );
}
