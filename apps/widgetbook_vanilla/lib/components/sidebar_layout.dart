import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_vanilla/ui/ui.dart';

import 'sidebar_sections.dart';

@widgetbook.UseCase(name: 'SidebarLayout', type: VanillaSidebarLayout)
Widget buildVanillaSidebarLayoutUseCase(BuildContext context) {
  var selected = 'overview';
  return Scaffold(
    body: StatefulBuilder(
      builder: (context, setState) => VanillaSidebarLayout(
        sidebar: VanillaSidebar<String>(
          selectedValue: selected,
          onSelected: (value) => setState(() => selected = value),
          semanticLabel: 'Workspace navigation',
          sections: vanillaSidebarSections,
        ),
        header: VanillaAppBar(title: selected.toUpperCase()),
        body: Center(child: Text('Active page: $selected')),
      ),
    ),
  );
}
