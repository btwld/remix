import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

// Inspired by alignui design system
// https://www.alignui.com/docs/v1.2/ui/accordion

void main() {
  // Enable semantics for web testing/automation
  WidgetsFlutterBinding.ensureInitialized();
  // ignore: deprecated_member_use
  WidgetsBinding.instance.ensureSemantics();
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
        child: FlexBox(
          style: FlexBoxStyler().direction(Axis.vertical).spacing(24),
          children: [
            RemixAccordionGroup(
              controller: controller,
              children: [
                RemixAccordion(
                  value: 'accordion1',
                  title: 'How do I update my account information?',
                  leadingIcon: Icons.help_outline,
                  style: itemStyle,
                  child: const Text(
                    'Insert the accordion description here. It would look better as two lines of text.',
                  ),
                ),
                RemixAccordion(
                  value: 'accordion2',
                  title: 'What payment methods are accepted?',
                  leadingIcon: Icons.help_outline,
                  style: itemStyle,
                  child: const Text(
                      'Major credit and debit cards like Visa, MasterCard, and American Express, as well as digital payment options like PayPal and Apple Pay.'),
                ),
                RemixAccordion(
                  value: 'accordion3',
                  title: 'How can I track my order?',
                  leadingIcon: Icons.help_outline,
                  style: itemStyle,
                  child: const Text(
                      'You can track your order status in the "My Orders" section of your account.'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  RemixAccordionStyle get itemStyle {
    return RemixAccordionStyle()
        .content(
          BoxStyler()
              .color(Colors.white)
              .paddingX(16)
              .paddingBottom(16)
              .paddingTop(8),
        )
        .wrapClipRRect(borderRadius: BorderRadius.circular(8))
        .color(Colors.white)
        .paddingAll(16)
        .borderRadiusAll(const Radius.circular(8))
        .decoration(
          BoxDecorationMix(
            color: Colors.white,
            border: BoxBorderMix.all(
              BorderSideMix()
                  .color(Colors.grey.shade300)
                  .width(1),
            ),
            borderRadius: BorderRadiusMix.circular(8),
          ),
        )
        .trigger(
          FlexBoxStyler()
              .direction(Axis.horizontal)
              .mainAxisAlignment(MainAxisAlignment.spaceBetween)
              .spacing(12),
        )
        .leadingIcon(
          IconStyler()
              .color(Colors.grey.shade700)
              .size(20),
        )
        .title(
          TextStyler()
              .color(Colors.grey.shade900)
              .fontWeight(FontWeight.w500)
              .fontSize(14),
        )
        .trailingIcon(
          IconStyler()
              .color(Colors.grey.shade700)
              .size(20),
        );
  }
}
