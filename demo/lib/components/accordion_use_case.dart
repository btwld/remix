import 'package:demo/addons/icon_data_knob.dart';
import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Accordion Component',
  type: RemixAccordion,
)
Widget buildAccordionUseCase(BuildContext context) {
  return Scaffold(
    body: Center(
      child: SizedBox(
        width: 300,
        child: RemixAccordion(
          defaultTrailing: context.knobs.iconData(label: 'Trailing Icon') ??
              Icons.keyboard_arrow_down_rounded,
          children: const [
            RemixAccordionItem(
              title: 'Section 1',
              value: 'section1',
              child: Text('Content for section 1'),
            ),
            RemixAccordionItem(
              title: 'Section 2',
              value: 'section2',
              child: Text('Content for section 2'),
            ),
            RemixAccordionItem(
              title: 'Section 3',
              value: 'section3',
              child: Text('Content for section 3'),
            ),
          ],
        ),
      ),
    ),
  );
}
