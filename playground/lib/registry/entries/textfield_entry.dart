import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

Widget buildTextFieldExample() {
  return const SizedBox(
    width: 320,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RemixTextField(
          label: 'Label',
          hintText: 'Type something…',
        ),
        SizedBox(height: 12),
        RemixTextField(
          label: 'With helper',
          hintText: 'Email',
          helperText: 'We will not share your email',
        ),
        SizedBox(height: 12),
        RemixTextField(
          label: 'Error',
          hintText: 'Invalid input',
          error: true,
        ),
      ],
    ),
  );
}
