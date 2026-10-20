import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_vanilla/ui/ui.dart';

import 'sidebar_sections.dart';

@widgetbook.UseCase(name: 'Sidebar', type: VanillaSidebar)
Widget buildVanillaSidebarUseCase(BuildContext context) {
  var selected = 'overview';
  return Scaffold(
    body: Center(
      child: SizedBox(
        width: 240,
        height: 280,
        child: StatefulBuilder(
          builder: (context, setState) => VanillaSidebar<String>(
            selectedValue: selected,
            onSelected: (value) => setState(() => selected = value),
            semanticLabel: 'Workspace navigation',
            sections: vanillaSidebarSections,
          ),
        ),
      ),
    ),
  );
}
