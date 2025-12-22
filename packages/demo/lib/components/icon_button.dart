import 'package:demo/addons/icon_data_knob.dart';
import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final _key = GlobalKey();

void _showToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(milliseconds: 1200),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Icon Button Component',
  type: RemixIconButton,
)
Widget buildIconButtonUseCase(BuildContext context) {
  return KeyedSubtree(
    key: _key,
    child: Scaffold(
      body: Center(
        child: RemixIconButton(
          onPressed: () {
            _showToast(context, 'RemixIconButton pressed');
          },
          loading: context.knobs.boolean(
            label: 'Loading',
            initialValue: false,
          ),
          icon: context.knobs.iconData(
            label: 'Icon',
            initialValue: Icons.add,
          )!,
          style: FortalIconButtonStyles.create(
            size: context.knobs.object.dropdown(
              label: 'size',
              options: FortalIconButtonSize.values,
              labelBuilder: (size) => size.name,
              initialOption: FortalIconButtonSize.size2,
            ),
            variant: context.knobs.object.dropdown(
              label: 'variant',
              options: FortalIconButtonVariant.values,
              labelBuilder: (variant) => variant.name,
            ),
          ),
        ),
      ),
    ),
  );
}
