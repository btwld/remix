import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

// Inspired by alignui design system
// https://www.alignui.com/docs/v1.2/ui/accordion

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: AccordionExample(),
      ),
    ),
  );
}

class AccordionExample extends StatefulWidget {
  const AccordionExample({super.key});

  @override
  State<AccordionExample> createState() => _AccordionExampleState();
}

class _AccordionExampleState extends State<AccordionExample> {
  final controller = RemixAccordionController<String>(min: 0, max: 1);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 400,
        child: RemixAccordionGroup(
          controller: controller,
          style: RemixAccordionStyle().direction(Axis.vertical).spacing(24),
          children: [
            RemixAccordion(
              value: 'accordion1',
              title: 'How do I update my account information?',
              icon: Icons.add,
              style: itemStyle,
              child: const Text(
                'Insert the accordion description here. It would look better as two lines of text.',
              ),
            ),
            RemixAccordion(
              value: 'accordion2',
              title: 'What payment methods are accepted?',
              icon: Icons.add,
              style: itemStyle,
              child: const Text(
                  'Major credit and debit cards like Visa, MasterCard, and American Express, as well as digital payment options like PayPal and Apple Pay.'),
            ),
          ],
        ),
      ),
    );
  }

  RemixAccordionItemStyle get itemStyle {
    return RemixAccordionItemStyle()
        .content(
          BoxStyler()
              .color(Colors.grey.shade100)
              .paddingX(14)
              .paddingBottom(14),
        )
        .wrapClipRRect(borderRadius: BorderRadius.circular(8))
        .color(Colors.grey.shade100)
        .paddingAll(14)
        .borderRadiusAll(const Radius.circular(8))
        .title(TextStyler()
            .color(Colors.blueGrey.shade900)
            .fontWeight(FontWeight.w500));
  }
}
