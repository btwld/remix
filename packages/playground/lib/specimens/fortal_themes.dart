import 'package:flutter/material.dart';
import 'package:mix_specimen/mix_specimen.dart';
import 'package:remix/remix.dart';

final fortalThemes = [
  SpecimenTheme(
    'fortal-light',
    label: 'Light',
    background: const Color(0xFFFFFFFF),
    builder: (context, child) => FortalScope(child: child),
  ),
  SpecimenTheme(
    'fortal-dark',
    label: 'Dark',
    brightness: Brightness.dark,
    background: const Color(0xFF111113),
    builder: (context, child) =>
        FortalScope(brightness: Brightness.dark, child: child),
  ),
];
