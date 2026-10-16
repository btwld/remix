import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../components/accordion.dart';
import '../../components/app_bar.dart';
import '../../components/disclosure.dart';
import '../../components/icon_button.dart';
import '../../components/sidebar.dart';
import '../../components/tabs.dart';
import '../../theme/tokens.dart';
import 'dashboard_demo_gallery_scaffold.dart';

class VanillaGalleryNavigationPage extends StatefulWidget {
  const VanillaGalleryNavigationPage({super.key});

  @override
  State<VanillaGalleryNavigationPage> createState() =>
      _VanillaGalleryNavigationPageState();
}

class _VanillaGalleryNavigationPageState
    extends State<VanillaGalleryNavigationPage> {
  String _sidebar = 'overview';
  String _tab = 'overview';
  bool _disclosureExpanded = true;
  final _accordion = RemixAccordionController<String>(max: 1);

  @override
  void dispose() {
    _accordion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => VanillaGalleryPage(
    title: 'Navigation',
    intro:
        'Page headers, sectioned navigation, tabs, disclosures, and accordions for organizing dense interfaces.',
    sections: [
      VanillaGallerySection(
        label: 'App bar',
        description:
            'A page header with a leading button, a title heading, and actions.',
        child: VanillaAppBar(
          // A sample inside a card: it neither touches the screen edge nor
          // names the page.
          safeArea: false,
          namesRoute: false,
          leading: VanillaIconButton.ghost(
            size: .large,
            icon: RemixIcons.hamburgerMenu,
            semanticLabel: 'Open navigation',
            onPressed: () =>
                showVanillaGalleryToast(context, 'Navigation is the caller\'s'),
          ),
          title: 'Orders',
          actions: [
            VanillaIconButton.ghost(
              size: .large,
              icon: RemixIcons.magnifyingGlass,
              semanticLabel: 'Search orders',
              onPressed: () =>
                  showVanillaGalleryToast(context, 'Search orders'),
            ),
            VanillaIconButton.ghost(
              size: .large,
              icon: RemixIcons.bell,
              semanticLabel: 'Notifications',
              onPressed: () =>
                  showVanillaGalleryToast(context, 'No new notifications'),
            ),
          ],
        ),
      ),
      VanillaGallerySection(
        label: 'Sidebar',
        description:
            'A controlled native sidebar with fixed header and footer.',
        child: Box(
          style: BoxStyler().alignment(.centerStart),
          child: Box(
            style: BoxStyler().width(280).height(320),
            child: VanillaSidebar<String>(
              header: Box(
                style: BoxStyler().padding(.all(VanillaTokens.s3_5)),
                child: const VanillaGalleryHeading(
                  'Acme',
                  token: VanillaTokens.textBase,
                  weight: FontWeight.w700,
                ),
              ),
              sections: const [
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
              ],
              selectedValue: _sidebar,
              onSelected: (value) => setState(() => _sidebar = value),
              footer: const VanillaGalleryText('Ada Chen', emphasized: true),
              semanticLabel: 'Gallery navigation example',
            ),
          ),
        ),
      ),
      VanillaGallerySection(
        label: 'Tabs',
        description: 'Live keyboard and pointer selection.',
        child: RemixTabs(
          selectedTabId: _tab,
          onChanged: (value) => setState(() => _tab = value),
          child: ColumnBox(
            style: FlexBoxStyler().crossAxisAlignment(.stretch),
            children: [
              const VanillaTabBar(
                child: RowBox(
                  children: [
                    VanillaTab(tabId: 'overview', label: 'Overview'),
                    VanillaTab(tabId: 'activity', label: 'Activity'),
                  ],
                ),
              ),
              VanillaTabView(
                tabId: 'overview',
                child: Box(
                  style: BoxStyler().padding(.all(VanillaTokens.s3)),
                  child: const VanillaGalleryText('Overview content'),
                ),
              ),
              VanillaTabView(
                tabId: 'activity',
                child: Box(
                  style: BoxStyler().padding(.all(VanillaTokens.s3)),
                  child: const VanillaGalleryText('Activity content'),
                ),
              ),
            ],
          ),
        ),
      ),
      VanillaGallerySection(
        label: 'Disclosure',
        description: 'An independent expandable native panel.',
        child: VanillaDisclosure(
          key: const ValueKey('vanilla-gallery-disclosure'),
          expanded: _disclosureExpanded,
          onExpandedChanged: (value) =>
              setState(() => _disclosureExpanded = value),
          semanticLabel: 'Shipping details',
          trigger: VanillaDisclosureTrigger(
            expanded: _disclosureExpanded,
            child: const VanillaGalleryText(
              'Shipping details',
              emphasized: true,
            ),
          ),
          content: const VanillaGalleryText(
            'Delivery takes 3–5 business days.',
          ),
        ),
      ),
      VanillaGallerySection(
        label: 'Accordion',
        description: 'Coordinated panels keep one section open.',
        child: RemixAccordionGroup<String>(
          controller: _accordion,
          initialExpandedValues: const ['details'],
          child: ColumnBox(
            style: FlexBoxStyler().crossAxisAlignment(.stretch),
            children: const [
              VanillaAccordion<String>(
                value: 'details',
                title: 'What is Vanilla?',
                trailingIcon: RemixIcons.chevronDown,
                child: VanillaGalleryText(
                  'A neutral starter theme, installed as source you own.',
                ),
              ),
              VanillaAccordion<String>(
                value: 'tokens',
                title: 'Does it support tokens?',
                trailingIcon: RemixIcons.chevronDown,
                child: VanillaGalleryText(
                  'Every recipe resolves through the active Mix scope.',
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
