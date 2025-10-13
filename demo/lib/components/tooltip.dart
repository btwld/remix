import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final _key = GlobalKey();

@widgetbook.UseCase(
  name: 'Tooltip Component',
  type: RemixTooltip,
)
Widget buildTooltipUseCase(BuildContext context) {
  return KeyedSubtree(
    key: _key,
    child: Scaffold(
      body: Center(
        child: SizedBox(
          height: 300,
          width: 300,
          child: Center(
            child: RemixTooltip(
              style: FortalTooltipStyles.create(),
              tooltipChild: const Text('Tooltip content'),
              child: RemixButton(
                label: 'Hover me',
                onPressed: () {},
                style: FortalButtonStyle.create(),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
