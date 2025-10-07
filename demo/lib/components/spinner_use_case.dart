import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Spinner Component',
  type: RemixSpinner,
)
Widget buildSpinnerUseCase(BuildContext context) {
  return const Scaffold(
    body: Center(
      child: RemixSpinner(),
    ),
  );
}
