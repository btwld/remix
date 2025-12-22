import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final _key = GlobalKey();

@widgetbook.UseCase(
  name: 'Accordion Component',
  type: RemixAccordion,
)
Widget buildAccordionUseCase(BuildContext context) {
  return KeyedSubtree(
    key: _key,
    child: Scaffold(
      body: Center(
        child: SizedBox(
          width: 400,
          child: RemixAccordionGroup(
              controller: RemixAccordionController<String>(min: 0, max: 1),
              child: Box(
                style: BoxStyler()
                    .borderAll(
                        color: FortalTokens.gray7(),
                        strokeAlign: BorderSide.strokeAlignOutside)
                    .borderRadiusAll(FortalTokens.radius4())
                    .clipBehavior(Clip.hardEdge),
                child: ColumnBox(
                  style: FlexBoxStyler().mainAxisSize(MainAxisSize.min),
                  children: [
                    RemixAccordion(
                      value: 'accordion1',
                      title: 'Is it accessible?',
                      style: FortalAccordionStyles.base<String>(),
                      child: const Text('Yes, it is accessible.'),
                    ),
                    RemixDivider(
                      style: FortalDividerStyles.create(),
                    ),
                    RemixAccordion(
                      value: 'accordion2',
                      title: 'What payment methods are accepted?',
                      style: FortalAccordionStyles.base<String>(),
                      child: const Text(
                          'Major credit and debit cards like Visa, MasterCard, and American Express, as well as digital payment options like PayPal and Apple Pay.'),
                    ),
                  ],
                ),
              )),
        ),
      ),
    ),
  );
}
