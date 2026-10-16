import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_vanilla/ui/ui.dart';

@widgetbook.UseCase(name: 'Skeleton', type: VanillaSkeleton)
Widget buildVanillaSkeletonUseCase(BuildContext context) => Scaffold(
  body: Center(child: const VanillaSkeleton(loading: true, child: VanillaAvatar(label: 'LF'))),
);
