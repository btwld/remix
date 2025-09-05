import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

Widget buildTextFieldExample() {
  return SizedBox(
    width: 320,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RemixTextField(
          label: 'Label',
          hintText: 'Type something…',
        ),
        const SizedBox(height: 12),
        const RemixTextField(
          label: 'With helper',
          hintText: 'Email',
          helperText: 'We will not share your email',
        ),
        const SizedBox(height: 12),
        const RemixTextField(
          label: 'Error',
          hintText: 'Invalid input',
          error: true,
        ),
      ],
    ),
  );
}

