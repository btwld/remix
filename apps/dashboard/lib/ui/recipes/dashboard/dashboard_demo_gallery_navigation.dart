import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import 'dashboard_demo_gallery_scaffold.dart';
import 'dashboard_demo_text.dart';
import 'dashboard_demo_ui.dart';

class UiGalleryNavigationPage extends StatelessWidget {
  const UiGalleryNavigationPage({super.key});

  @override
  Widget build(BuildContext context) => UiGalleryPage(
    title: 'Navigation',
    intro:
        'Page headers, sectioned navigation, tabs, disclosures, and accordions for organizing dense interfaces.',
    sections: [
      const UiGallerySection(
        label: 'App bar',
        description:
            'A Ui page header with a leading button, a title heading, and actions.',
        child: _AppBarDemo(),
      ),
      const UiGallerySection(
        label: 'Sidebar',
        description:
            'A controlled Ui sidebar with a fixed header and footer, a scrolling destination region, headings, selected state, and ordinary Tab traversal.',
        child: _SidebarDemo(),
      ),
      UiGallerySection(
        label: 'Tabs',
        description: 'Both tab sizes with live keyboard and pointer selection.',
        child: UiGalleryMatrix<String, UiTabsSize>(
          rows: const ['Tabs'],
          columns: UiTabsSize.values,
          rowLabelBuilder: (label) => label,
          columnLabelBuilder: enumLabel,
          cellWidth: 320,
          cellBuilder: (_, _, size) => _TabsDemo(size: size),
        ),
      ),
      UiGallerySection(
        label: 'Disclosure',
        description:
            'Independent expandable panels in every Ui variant and size.',
        child: UiGalleryEnumMatrix(
          rows: UiDisclosureVariant.values,
          columns: UiDisclosureSize.values,
          cellWidth: 300,
          cellBuilder: (_, variant, size) =>
              _DisclosureDemo(variant: variant, size: size),
        ),
      ),
      UiGallerySection(
        label: 'Accordion',
        description:
            'Coordinated disclosure items where only one panel stays open.',
        child: UiGalleryEnumMatrix(
          rows: UiAccordionVariant.values,
          columns: UiAccordionSize.values,
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
  Widget build(BuildContext context) => UiAppBar(
    // A sample inside a card: it neither touches the screen edge nor names
    // the page.
    safeArea: false,
    namesRoute: false,
    leading: UiIconButton.ghost(
      size: .size3,
      icon: RemixIcons.hamburgerMenu,
      semanticLabel: 'Open navigation',
      onPressed: () {},
    ),
    title: 'Orders',
    actions: [
      UiIconButton.ghost(
        size: .size3,
        icon: RemixIcons.magnifyingGlass,
        semanticLabel: 'Search orders',
        onPressed: () {},
      ),
      UiIconButton.ghost(
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
      child: UiSidebar<String>(
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
    child: const UiText('Acme', size: .size4, weight: .bold),
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
      UiAvatar(label: 'AC', size: .size1),
      UiText('Ada Chen', size: .size2, weight: .medium),
    ],
  );
}

class _DisclosureDemo extends StatelessWidget {
  const _DisclosureDemo({required this.variant, required this.size});

  final UiDisclosureVariant variant;
  final UiDisclosureSize size;

  @override
  Widget build(BuildContext context) => Box(
    style: BoxStyler().width(280),
    child: UiDisclosure(
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
  final UiTabsSize size;

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
        UiTabBar(
          child: RowBox(
            style: FlexBoxStyler().mainAxisSize(.min),
            children: [
              UiTab(size: widget.size, tabId: 'overview', label: 'Overview'),
              UiTab(size: widget.size, tabId: 'activity', label: 'Activity'),
            ],
          ),
        ),
        UiTabView(
          tabId: 'overview',
          child: Box(
            style: BoxStyler().padding(.all(8)),
            child: const UiText('Overview content'),
          ),
        ),
        UiTabView(
          tabId: 'activity',
          child: Box(
            style: BoxStyler().padding(.all(8)),
            child: const UiText('Activity content'),
          ),
        ),
      ],
    ),
  );
}

class _AccordionDemo extends StatefulWidget {
  const _AccordionDemo({required this.variant, required this.size});
  final UiAccordionVariant variant;
  final UiAccordionSize size;

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
        UiAccordion<String>(
          variant: widget.variant,
          size: widget.size,
          value: 'details',
          title: 'What is Ui?',
          child: const UiText(
            'A Radix-inspired theme and component system for Flutter.',
          ),
        ),
        UiAccordion<String>(
          variant: widget.variant,
          size: widget.size,
          value: 'tokens',
          title: 'Does it support tokens?',
          child: const UiText(
            'Every recipe resolves through the active Mix scope.',
          ),
        ),
      ],
    ),
  );
}
