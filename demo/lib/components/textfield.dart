import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final _key = GlobalKey();

@widgetbook.UseCase(
  name: 'TextField Component',
  type: RemixTextField,
)
Widget buildTextFieldUseCase(BuildContext context) {
  return KeyedSubtree(
    key: _key,
    child: Scaffold(
      body: Center(
        child: SizedBox(
          width: 300,
          child: RemixTextField(
            trailing: context.knobs
                    .boolean(label: 'Show Trailing', initialValue: false)
                ? RemixIconButton(
                    icon: Icons.close_rounded,
                    onPressed: () {},
                  )
                : null,
            leading: context.knobs
                    .boolean(label: 'Show Leading', initialValue: false)
                ? const Icon(Icons.search)
                : null,
            maxLines: context.knobs.int.input(
              label: 'Max Lines',
              initialValue: 1,
            ),
            hintText: context.knobs.string(
              label: 'Hint Text',
              initialValue: 'Hint Text',
            ),
            helperText: context.knobs.string(
              label: 'Helper Text',
              initialValue: 'Helper Text',
            ),
            enabled:
                context.knobs.boolean(label: 'Enabled', initialValue: true),
            style: FortalTextFieldStyles.create(
              variant: context.knobs.object.dropdown(
                label: 'variant',
                options: FortalTextFieldVariant.values,
                labelBuilder: (variant) => variant.name,
              ),
              size: context.knobs.object.dropdown(
                label: 'size',
                options: FortalTextFieldSize.values,
                labelBuilder: (size) => size.name,
                initialOption: FortalTextFieldSize.size2,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
