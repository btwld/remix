import 'package:flutter/material.dart' as m;
import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final _key = GlobalKey();

@widgetbook.UseCase(
  name: 'Callout Component',
  type: RemixCallout,
)
Widget buildCalloutUseCase(BuildContext context) {
  return KeyedSubtree(
    key: _key,
    child: Scaffold(
      body: Center(
        child: SizedBox(
          width: 300,
          child: RemixCallout(
            icon: m.Icons.info_outline,
            style: FortalCalloutStyles.create(
              variant: context.knobs.object.dropdown(
                label: 'variant',
                options: FortalCalloutVariant.values,
                labelBuilder: (variant) => variant.name,
              ),
              size: context.knobs.object.dropdown(
                label: 'size',
                options: FortalCalloutSize.values,
                labelBuilder: (size) => size.name,
                initialOption: FortalCalloutSize.size2,
              ),
            ),
            text: context.knobs.string(
              label: 'Text',
              initialValue: 'This is a callout message',
            ),
          ),
        ),
      ),
    ),
  );
}
