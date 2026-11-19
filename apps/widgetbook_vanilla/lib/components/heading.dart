import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_vanilla/ui/ui.dart';

@widgetbook.UseCase(name: 'Heading', type: VanillaHeading)
Widget buildVanillaHeadingUseCase(BuildContext context) => const Scaffold(
  body: SingleChildScrollView(
    padding: EdgeInsets.all(24),
    child: Center(
      child: SizedBox(
        width: 560,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16,
          children: [
            VanillaHeading.h1('Taxing Laughter: The Joke Tax Chronicles'),
            VanillaHeading.h2('The People of the Kingdom'),
            VanillaHeading.h3('The Joke Tax'),
            VanillaHeading.h4('People stopped telling jokes'),
          ],
        ),
      ),
    ),
  ),
);
