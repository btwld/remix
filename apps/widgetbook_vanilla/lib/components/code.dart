import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_vanilla/ui/ui.dart';

@widgetbook.UseCase(name: 'Code', type: VanillaCode)
Widget buildVanillaCodeUseCase(BuildContext context) => Scaffold(
  body: Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 16,
      children: [
        const VanillaCode('@radix-ui/react-alert-dialog'),
        // In running text the chip sits in a widget span.
        SizedBox(
          width: 360,
          child: Text.rich(
            TextSpan(
              text: 'Add ',
              children: const [
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: VanillaCode('remix_ui_fonts'),
                ),
                TextSpan(text: ' to pubspec.yaml, then run '),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: VanillaCode('flutter pub get'),
                ),
                TextSpan(text: '.'),
              ],
            ),
          ),
        ),
      ],
    ),
  ),
);
