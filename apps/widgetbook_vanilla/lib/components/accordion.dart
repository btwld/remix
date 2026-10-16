import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_vanilla/ui/ui.dart';

@widgetbook.UseCase(name: 'Accordion', type: VanillaAccordion)
Widget buildVanillaAccordionUseCase(BuildContext context) {
  final controller = RemixAccordionController<String>(min: 0, max: 1)
    ..values.add('shipping');
  return Scaffold(
    body: Center(
      child: SizedBox(
        width: 360,
        child: RemixAccordionGroup<String>(
          controller: controller,
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              VanillaAccordion<String>(
                value: 'shipping',
                title: 'Shipping details',
                child: Text('Orders ship within two to four business days.'),
              ),
              VanillaAccordion<String>(
                value: 'returns',
                title: 'Returns & exchanges',
                child: Text('Free returns within 30 days of delivery.'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
