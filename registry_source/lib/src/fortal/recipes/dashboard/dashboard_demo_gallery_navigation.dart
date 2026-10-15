import 'package:flutter/widgets.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';
import 'package:remix/remix.dart';
import 'dashboard_demo_ui.dart';

import 'dashboard_demo_text.dart';
import 'dashboard_demo_gallery_scaffold.dart';

class FortalGalleryNavigationPage extends StatelessWidget {
  const FortalGalleryNavigationPage({super.key});

  @override
  Widget build(BuildContext context) => FortalGalleryPage(
    title: 'Navigation',
    intro:
        'Page headers, sectioned navigation, tabs, disclosures, and accordions for organizing dense interfaces.',
    sections: [
      const FortalGallerySection(
        label: 'App bar',
        description:
            'A Fortal page header with a leading button, a title heading, and actions.',
        child: _AppBarDemo(),
      ),
      const FortalGallerySection(
        label: 'Sidebar',
        description:
            'A controlled Fortal sidebar with a fixed header and footer, a scrolling destination region, headings, selected state, and ordinary Tab traversal.',
        child: _SidebarDemo(),
      ),
      FortalGallerySection(
        label: 'Tabs',
        description: 'Both tab sizes with live keyboard and pointer selection.',
        child: FortalGalleryMatrix<String, FortalTabsSize>(
          rows: const ['Tabs'],
          columns: FortalTabsSize.values,
          rowLabelBuilder: (label) => label,
          columnLabelBuilder: enumLabel,
          cellWidth: 320,
          cellBuilder: (_, _, size) => _TabsDemo(size: size),
        ),
      ),
      FortalGallerySection(
        label: 'Disclosure',
        description:
            'Independent expandable panels in every Fortal variant and size.',
        child: FortalGalleryEnumMatrix(
          rows: FortalDisclosureVariant.values,
          columns: FortalDisclosureSize.values,
          cellWidth: 300,
          cellBuilder: (_, variant, size) =>
              _DisclosureDemo(variant: variant, size: size),
        ),
      ),
      FortalGallerySection(
        label: 'Accordion',
        description:
            'Coordinated disclosure items where only one panel stays open.',
        child: FortalGalleryEnumMatrix(
          rows: FortalAccordionVariant.values,
          columns: FortalAccordionSize.values,
          cellWidth: 300,
          cellBuilder: (_, variant, size) =>
              _AccordionDemo(variant: variant, size: size),
        ),
      ),
    ],
  );
}

class _AppBarDemo extends StatelessWidget {
  const _AppBarDemo();

  @override
  Widget build(BuildContext context) => FortalAppBar(
    // A sample inside a card: it neither touches the screen edge nor names
    // the page.
    safeArea: false,
    namesRoute: false,
    leading: FortalIconButton.ghost(
      size: .size3,
      icon: RemixIcons.hamburgerMenu,
      semanticLabel: 'Open navigation',
      onPressed: () {},
    ),
    title: 'Orders',
    actions: [
      FortalIconButton.ghost(
        size: .size3,
        icon: RemixIcons.magnifyingGlass,
        semanticLabel: 'Search orders',
        onPressed: () {},
      ),
      FortalIconButton.ghost(
        size: .size3,
        icon: RemixIcons.bell,
        semanticLabel: 'Notifications',
        onPressed: () {},
      ),
    ],
  );
}

class _SidebarDemo extends StatefulWidget {
  const _SidebarDemo();

  @override
  State<_SidebarDemo> createState() => _SidebarDemoState();
}

class _SidebarDemoState extends State<_SidebarDemo> {
  static const _sections = <RemixSidebarSection<String>>[
    RemixSidebarSection(
      label: 'Workspace',
      destinations: [
        RemixSidebarDestination(
          value: 'overview',
          label: 'Overview',
          icon: RemixIcons.dashboard,
        ),
        RemixSidebarDestination(
          value: 'activity',
          label: 'Activity',
          icon: RemixIcons.activityLog,
        ),
      ],
    ),
    RemixSidebarSection(
      label: 'Manage',
      destinations: [
        RemixSidebarDestination(
          value: 'settings',
          label: 'Settings',
          icon: RemixIcons.mixerHorizontal,
        ),
      ],
    ),
  ];

  String _selected = 'overview';

  @override
  // Align loosens the stretched section constraints so the panel keeps the
  // width and height a host would give it. The bounded height shows the
  // destination region scrolling while the header and footer stay put.
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: Box(
      style: BoxStyler().width(280).height(320),
      child: FortalSidebar<String>(
        header: const _SidebarDemoHeader(),
        sections: _sections,
        selectedValue: _selected,
        onSelected: (value) => setState(() => _selected = value),
        footer: const _SidebarDemoFooter(),
        semanticLabel: 'Gallery navigation example',
      ),
    ),
  );
}

class _SidebarDemoHeader extends StatelessWidget {
  const _SidebarDemoHeader();

  @override
  Widget build(BuildContext context) => Box(
    style: BoxStyler().padding(.symmetric(horizontal: 16, vertical: 14)),
    child: const FortalText('Acme', size: .size4, weight: .bold),
  );
}

class _SidebarDemoFooter extends StatelessWidget {
  const _SidebarDemoFooter();

  @override
  Widget build(BuildContext context) => RowBox(
    style: FlexBoxStyler()
        .padding(.all(14))
        .crossAxisAlignment(.center)
        .spacing(10),
    children: const [
      FortalAvatar(label: 'AC', size: .size1),
      FortalText('Ada Chen', size: .size2, weight: .medium),
    ],
  );
}

class _DisclosureDemo extends StatelessWidget {
  const _DisclosureDemo({required this.variant, required this.size});

  final FortalDisclosureVariant variant;
  final FortalDisclosureSize size;

  @override
  Widget build(BuildContext context) => Box(
    style: BoxStyler().width(280),
    child: FortalDisclosure(
      key: ValueKey('disclosure-${variant.name}-${size.name}'),
      variant: variant,
      size: size,
      defaultExpanded: true,
      semanticLabel:
          '${enumLabel(variant)} ${enumLabel(size)} shipping details',
      semanticHint: 'Toggles shipping details',
      trigger: const Text('Shipping details'),
      content: const Text('Delivery takes 3–5 business days.'),
    ),
  );
}

class _TabsDemo extends StatefulWidget {
  const _TabsDemo({required this.size});
  final FortalTabsSize size;

  @override
  State<_TabsDemo> createState() => _TabsDemoState();
}

class _TabsDemoState extends State<_TabsDemo> {
  String _selected = 'overview';

  @override
  Widget build(BuildContext context) => RemixTabs(
    selectedTabId: _selected,
    onChanged: (value) => setState(() => _selected = value),
    child: ColumnBox(
      style: FlexBoxStyler().crossAxisAlignment(.stretch).spacing(10),
      children: [
        FortalTabBar(
          child: RowBox(
            style: FlexBoxStyler().mainAxisSize(.min),
            children: [
              FortalTab(
                size: widget.size,
                tabId: 'overview',
                label: 'Overview',
              ),
              FortalTab(
                size: widget.size,
                tabId: 'activity',
                label: 'Activity',
              ),
            ],
          ),
        ),
        FortalTabView(
          tabId: 'overview',
          child: Box(
            style: BoxStyler().padding(.all(8)),
            child: const FortalText('Overview content'),
          ),
        ),
        FortalTabView(
          tabId: 'activity',
          child: Box(
            style: BoxStyler().padding(.all(8)),
            child: const FortalText('Activity content'),
          ),
        ),
      ],
    ),
  );
}

class _AccordionDemo extends StatefulWidget {
  const _AccordionDemo({required this.variant, required this.size});
  final FortalAccordionVariant variant;
  final FortalAccordionSize size;

  @override
  State<_AccordionDemo> createState() => _AccordionDemoState();
}

class _AccordionDemoState extends State<_AccordionDemo> {
  final _controller = RemixAccordionController<String>(max: 1);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => RemixAccordionGroup<String>(
    controller: _controller,
    initialExpandedValues: const ['details'],
    child: ColumnBox(
      style: FlexBoxStyler().crossAxisAlignment(.stretch).spacing(8),
      children: [
        FortalAccordion<String>(
          variant: widget.variant,
          size: widget.size,
          value: 'details',
          title: 'What is Fortal?',
          child: const FortalText(
            'A Radix-inspired theme and component system for Flutter.',
          ),
        ),
        FortalAccordion<String>(
          variant: widget.variant,
          size: widget.size,
          value: 'tokens',
          title: 'Does it support tokens?',
          child: const FortalText(
            'Every recipe resolves through the active Mix scope.',
          ),
        ),
      ],
    ),
  );
}
