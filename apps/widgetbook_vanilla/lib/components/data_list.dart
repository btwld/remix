import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_vanilla/ui/ui.dart';

@widgetbook.UseCase(name: 'Data List', type: VanillaDataList)
Widget buildVanillaDataListUseCase(BuildContext context) => Scaffold(
  body: Center(child: const VanillaDataList(items: [RemixDataListItem(label: 'Status', value: 'Active'), RemixDataListItem(label: 'Plan', value: 'Enterprise')])),
);
