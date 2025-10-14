import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final _key = GlobalKey();

@widgetbook.UseCase(
  name: 'Spinner Component',
  type: RemixSpinner,
)
Widget buildSpinnerUseCase(BuildContext context) {
  return KeyedSubtree(
    key: _key,
    child: Scaffold(
      body: Center(
        child: RemixSpinner(
          style: FortalSpinnerStyles.create(
            size: context.knobs.object.dropdown(
              label: 'size',
              options: FortalSpinnerSize.values,
              labelBuilder: (size) => size.name,
            ),
          ),
        ),
      ),
    ),
  );
}
