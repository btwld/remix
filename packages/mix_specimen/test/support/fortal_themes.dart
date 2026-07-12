import 'package:flutter/material.dart';
import 'package:mix_specimen/mix_specimen.dart';
import 'package:remix/remix.dart';

/// Theme axis shared by all Fortal specimen tests: one sheet per entry.
final fortalThemes = [
  SpecimenTheme(
    'fortal-light',
    background: const Color(0xFFFFFFFF),
    builder: (context, child) => FortalScope(child: child),
  ),
  SpecimenTheme(
    'fortal-dark',
    brightness: Brightness.dark,
    background: const Color(0xFF111113),
    builder: (context, child) =>
        FortalScope(brightness: Brightness.dark, child: child),
  ),
];
