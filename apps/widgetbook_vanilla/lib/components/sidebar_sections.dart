import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';
import 'package:widgetbook_vanilla/ui/ui.dart';

const vanillaSidebarSections = <RemixSidebarSection<String>>[
  RemixSidebarSection(
    label: 'Workspace',
    destinations: [
      RemixSidebarDestination(
        value: 'overview',
        label: 'Overview',
        icon: VanillaIcons.dashboard,
      ),
      RemixSidebarDestination(
        value: 'settings',
        label: 'Settings',
        icon: RemixIcons.gear,
      ),
    ],
  ),
];
