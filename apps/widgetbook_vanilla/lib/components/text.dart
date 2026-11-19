import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_vanilla/ui/ui.dart';

@widgetbook.UseCase(name: 'Text', type: VanillaText)
Widget buildVanillaTextUseCase(BuildContext context) {
  final rtl = Directionality.of(context) == TextDirection.rtl;
  return Scaffold(
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: SizedBox(
          width: 480,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 16,
            children: [
              VanillaText.lead(
                rtl
                    ? 'نافذة حوار تقاطع المستخدم بمحتوى مهم وتنتظر ردًا.'
                    : 'A modal dialog that interrupts the user with important '
                          'content and expects a response.',
              ),
              VanillaText.p(
                rtl
                    ? 'أدرك الملك خطأه عندما رأى رعاياه أسعد، فألغى ضريبة النكات.'
                    : 'The king, seeing how much happier his subjects were, '
                          'realized the error of his ways and repealed the joke '
                          'tax.',
              ),
              VanillaText.blockquote(
                rtl
                    ? '«الجميع يحب نكتة جيدة، فمن العدل أن يدفعوا ثمنها.»'
                    : '"After all," he said, "everyone enjoys a good joke, so '
                          'it\'s only fair that they should pay for the '
                          'privilege."',
              ),
              VanillaText.large(
                rtl ? 'هل أنت متأكد تمامًا؟' : 'Are you absolutely sure?',
              ),
              VanillaText.small(rtl ? 'البريد الإلكتروني' : 'Email address'),
              VanillaText.muted(
                rtl ? 'أدخل بريدك الإلكتروني.' : 'Enter your email address.',
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
