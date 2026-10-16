import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_vanilla/ui/ui.dart';

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
            sections: const [
              RemixSidebarSection(
                label: 'Workspace',
                destinations: [
                  RemixSidebarDestination(
                    value: 'overview',
                    label: 'Overview',
                    icon: Icons.space_dashboard_outlined,
                  ),
                  RemixSidebarDestination(
                    value: 'settings',
                    label: 'Settings',
                    icon: Icons.settings_outlined,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
