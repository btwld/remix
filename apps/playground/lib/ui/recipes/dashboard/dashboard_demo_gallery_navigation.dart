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

class PlaygroundGalleryNavigationPage extends StatefulWidget {
  const PlaygroundGalleryNavigationPage({super.key});

  @override
  State<PlaygroundGalleryNavigationPage> createState() =>
      _PlaygroundGalleryNavigationPageState();
}

class _PlaygroundGalleryNavigationPageState
    extends State<PlaygroundGalleryNavigationPage> {
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
  Widget build(BuildContext context) => PlaygroundGalleryPage(
    title: 'Navigation',
    intro:
        'Page headers, sectioned navigation, tabs, disclosures, and accordions for organizing dense interfaces.',
    sections: [
      PlaygroundGallerySection(
        label: 'App bar',
        description:
            'A page header with a leading button, a title heading, and actions.',
        child: PlaygroundAppBar(
          // A sample inside a card: it neither touches the screen edge nor
          // names the page.
          safeArea: false,
          namesRoute: false,
          leading: PlaygroundIconButton.ghost(
            size: .large,
            icon: RemixIcons.hamburgerMenu,
            semanticLabel: 'Open navigation',
            onPressed: () => showPlaygroundGalleryToast(
              context,
              'Navigation is the caller\'s',
            ),
          ),
          title: 'Orders',
          actions: [
            PlaygroundIconButton.ghost(
              size: .large,
              icon: RemixIcons.magnifyingGlass,
              semanticLabel: 'Search orders',
              onPressed: () =>
                  showPlaygroundGalleryToast(context, 'Search orders'),
            ),
            PlaygroundIconButton.ghost(
              size: .large,
              icon: RemixIcons.bell,
              semanticLabel: 'Notifications',
              onPressed: () =>
                  showPlaygroundGalleryToast(context, 'No new notifications'),
            ),
          ],
        ),
      ),
      PlaygroundGallerySection(
        label: 'Sidebar',
        description:
            'A controlled native sidebar with fixed header and footer.',
        child: Box(
          style: BoxStyler().alignment(.centerStart),
          child: Box(
            style: BoxStyler().width(280).height(320),
            child: PlaygroundSidebar<String>(
              header: Box(
                style: BoxStyler().padding(.all(PlaygroundTokens.s3_5)),
                child: const PlaygroundGalleryHeading(
                  'Acme',
                  token: PlaygroundTokens.textBase,
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
              footer: const PlaygroundGalleryText('Ada Chen', emphasized: true),
              semanticLabel: 'Gallery navigation example',
            ),
          ),
        ),
      ),
      PlaygroundGallerySection(
        label: 'Tabs',
        description: 'Live keyboard and pointer selection.',
        child: RemixTabs(
          selectedTabId: _tab,
          onChanged: (value) => setState(() => _tab = value),
          child: ColumnBox(
            style: FlexBoxStyler().crossAxisAlignment(.stretch),
            children: [
              const PlaygroundTabBar(
                child: RowBox(
                  children: [
                    PlaygroundTab(tabId: 'overview', label: 'Overview'),
                    PlaygroundTab(tabId: 'activity', label: 'Activity'),
                  ],
                ),
              ),
              PlaygroundTabView(
                tabId: 'overview',
                child: Box(
                  style: BoxStyler().padding(.all(PlaygroundTokens.s3)),
                  child: const PlaygroundGalleryText('Overview content'),
                ),
              ),
              PlaygroundTabView(
                tabId: 'activity',
                child: Box(
                  style: BoxStyler().padding(.all(PlaygroundTokens.s3)),
                  child: const PlaygroundGalleryText('Activity content'),
                ),
              ),
            ],
          ),
        ),
      ),
      PlaygroundGallerySection(
        label: 'Disclosure',
        description: 'An independent expandable native panel.',
        child: PlaygroundDisclosure(
          key: const ValueKey('playground-gallery-disclosure'),
          expanded: _disclosureExpanded,
          onExpandedChanged: (value) =>
              setState(() => _disclosureExpanded = value),
          semanticLabel: 'Shipping details',
          trigger: PlaygroundDisclosureTrigger(
            expanded: _disclosureExpanded,
            child: const PlaygroundGalleryText(
              'Shipping details',
              emphasized: true,
            ),
          ),
          content: const PlaygroundGalleryText(
            'Delivery takes 3–5 business days.',
          ),
        ),
      ),
      PlaygroundGallerySection(
        label: 'Accordion',
        description: 'Coordinated panels keep one section open.',
        child: RemixAccordionGroup<String>(
          controller: _accordion,
          initialExpandedValues: const ['details'],
          child: ColumnBox(
            style: FlexBoxStyler().crossAxisAlignment(.stretch),
            children: const [
              PlaygroundAccordion<String>(
                value: 'details',
                title: 'What is Playground?',
                trailingIcon: RemixIcons.chevronDown,
                child: PlaygroundGalleryText(
                  'A neutral starter theme, installed as source you own.',
                ),
              ),
              PlaygroundAccordion<String>(
                value: 'tokens',
                title: 'Does it support tokens?',
                trailingIcon: RemixIcons.chevronDown,
                child: PlaygroundGalleryText(
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
