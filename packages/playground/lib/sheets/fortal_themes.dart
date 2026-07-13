import 'package:flutter/material.dart';
import 'package:mix_sheets/mix_sheets.dart';
import 'package:remix/remix.dart';

final fortalThemes = [
  SheetTheme(
    'fortal-light',
    label: 'Light',
    background: const Color(0xFFFFFFFF),
    builder: (context, child) => FortalScope(child: child),
  ),
  SheetTheme(
    'fortal-dark',
    label: 'Dark',
    brightness: Brightness.dark,
    background: const Color(0xFF111113),
    builder: (context, child) =>
        FortalScope(brightness: Brightness.dark, child: child),
  ),
];
