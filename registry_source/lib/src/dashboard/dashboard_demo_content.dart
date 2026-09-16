import 'package:flutter/widgets.dart';

import 'dashboard_demo_base.dart';
import 'dashboard_sample_data.dart';

/// Preset-specific widgets used by the shared dashboard demo content.
///
/// The content and information architecture stay identical across presets;
/// each implementation maps these slots to its own public recipes and enums.
abstract interface class RegistryDashboardDemoKit {
  Widget pageHeader(String title, String description);

  Widget section(String title, String description, Widget child);

  Widget surface(Widget child);

  Widget text(String value, {bool emphasized = false, bool muted = false});

  Widget button(String label, {int emphasis = 0, VoidCallback? onPressed});

  Widget badge(String label, {int emphasis = 0});

  Widget textField({required String hintText, ValueChanged<String>? onChanged});

  Widget checkbox({required bool value, required ValueChanged<bool> onChanged});

  Widget switchControl({
    required bool value,
    required ValueChanged<bool> onChanged,
  });

  Widget progress(double value);

  Widget charts(RegistryDashboardSampleData data);

  Widget records({required bool orders, required String query});

  Widget overlays(VoidCallback onAction);

  Widget navigation();

  Widget typography(VoidCallback onAction);
}

/// Shared content for the eleven non-overview destinations.
class RegistryDashboardDemoContent extends StatefulWidget {
  const RegistryDashboardDemoContent({
    super.key,
    required this.page,
    required this.searchQuery,
    required this.kit,
    required this.onSelected,
    this.data = registryDashboardSampleData,
  });

  final RegistryDashboardDemoPage page;
  final String searchQuery;
  final RegistryDashboardDemoKit kit;
  final ValueChanged<RegistryDashboardDemoPage> onSelected;
  final RegistryDashboardSampleData data;

  @override
  State<RegistryDashboardDemoContent> createState() =>
      _RegistryDashboardDemoContentState();
}

class _RegistryDashboardDemoContentState
    extends State<RegistryDashboardDemoContent> {
  bool _productUpdates = true;
  bool _weeklyDigest = false;
  bool _checked = true;
  String _draft = '';
  String _notice = '';

  RegistryDashboardDemoKit get kit => widget.kit;

  @override
  Widget build(BuildContext context) => RegistryDashboardDemoPageFrame(
    key: ValueKey('dashboard-demo-${widget.page.name}'),
    header: kit.pageHeader(widget.page.label, _description(widget.page)),
    children: [
      if (_notice.isNotEmpty)
        kit.surface(
          Row(
            children: [
              Expanded(child: kit.text(_notice, emphasized: true)),
              kit.button('Dismiss', emphasis: 3, onPressed: _dismissNotice),
            ],
          ),
        ),
      ..._pageChildren(),
    ],
  );

  List<Widget> _pageChildren() => switch (widget.page) {
    .overview => const [],
    .chat => [_chat()],
    .customers => [_customers()],
    .orders => [_orders()],
    .settings => [_settings()],
    .charts => [_charts()],
    .actions => [_actions()],
    .forms => [_forms()],
    .dataDisplay => [_dataDisplay()],
    .overlays => [_overlays()],
    .navigation => [_navigation()],
    .typography => [_typography()],
  };

  Widget _chat() => kit.section(
    'Workspace assistant',
    'A stateful conversation surface for plans, progress, and results.',
    Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        kit.surface(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              kit.text('You', emphasized: true),
              const SizedBox(height: 6),
              kit.text('Summarize the latest customer and order activity.'),
              const SizedBox(height: 16),
              kit.text('Assistant', emphasized: true),
              const SizedBox(height: 6),
              kit.text(
                'Revenue is up 12.4%. Twelve orders need review, and three '
                'customer invitations are still pending.',
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: kit.textField(
                hintText: 'Ask about this workspace…',
                onChanged: (value) => _draft = value,
              ),
            ),
            const SizedBox(width: 12),
            kit.button(
              'Send',
              onPressed: () => _showNotice(
                _draft.trim().isEmpty
                    ? 'Write a message before sending.'
                    : 'Demo message sent.',
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _customers() => kit.section(
    'Customer directory',
    'Manage customer access, plans, and account status.',
    Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: kit.button(
            'Invite customer',
            onPressed: () => _showNotice('Customer invitation started.'),
          ),
        ),
        const SizedBox(height: 12),
        kit.records(orders: false, query: widget.searchQuery),
      ],
    ),
  );

  Widget _orders() => kit.section(
    'Transactions',
    'Review transactions and fulfillment status.',
    Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: kit.button(
            'Export orders',
            emphasis: 2,
            onPressed: () => _showNotice('Order export prepared.'),
          ),
        ),
        const SizedBox(height: 12),
        kit.records(orders: true, query: widget.searchQuery),
      ],
    ),
  );

  Widget _settings() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      kit.section(
        'Profile',
        'This information appears across your workspace.',
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            kit.textField(hintText: 'Workspace name'),
            const SizedBox(height: 12),
            kit.textField(hintText: 'Contact email'),
            const SizedBox(height: 12),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: kit.button(
                'Save changes',
                onPressed: () => _showNotice('Profile settings saved.'),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      kit.section(
        'Notifications',
        'Choose which workspace activity reaches your inbox.',
        Column(
          children: [
            _settingRow(
              'Product updates',
              'News about features and improvements.',
              kit.switchControl(
                value: _productUpdates,
                onChanged: (value) => setState(() => _productUpdates = value),
              ),
            ),
            const SizedBox(height: 16),
            _settingRow(
              'Weekly digest',
              'A summary of customer and order activity.',
              kit.switchControl(
                value: _weeklyDigest,
                onChanged: (value) => setState(() => _weeklyDigest = value),
              ),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _charts() => kit.section(
    'Analytics collection',
    'Line, grouped bar, and donut patterns for real dashboard data.',
    kit.charts(widget.data),
  );

  Widget _actions() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      kit.section(
        'Buttons',
        'Every action emphasis offered by this preset.',
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (var index = 0; index < 5; index++)
              kit.button(
                _actionLabels[index],
                emphasis: index,
                onPressed: () =>
                    _showNotice('${_actionLabels[index]} pressed.'),
              ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      kit.section(
        'Action states',
        'Loading, progress, and status feedback stay visible.',
        Row(
          children: [
            Expanded(child: kit.progress(.68)),
            const SizedBox(width: 16),
            kit.badge('68% complete', emphasis: 1),
          ],
        ),
      ),
    ],
  );

  Widget _forms() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      kit.section(
        'Text fields',
        'Default, validation, and longer-form entry surfaces.',
        Column(
          children: [
            kit.textField(hintText: 'Email address'),
            const SizedBox(height: 12),
            kit.textField(hintText: 'Search customers…'),
          ],
        ),
      ),
      const SizedBox(height: 16),
      kit.section(
        'Selection controls',
        'Checkbox and switch controls keep their state in the gallery.',
        Row(
          children: [
            kit.checkbox(
              value: _checked,
              onChanged: (value) => setState(() => _checked = value),
            ),
            const SizedBox(width: 10),
            Expanded(child: kit.text('Receive account alerts')),
            kit.switchControl(
              value: _productUpdates,
              onChanged: (value) => setState(() => _productUpdates = value),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _dataDisplay() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      kit.section(
        'Badges',
        'Contextual information in every preset-native emphasis.',
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            kit.badge('Active'),
            kit.badge('Processing', emphasis: 1),
            kit.badge('Review', emphasis: 2),
            kit.badge('Blocked', emphasis: 3),
          ],
        ),
      ),
      const SizedBox(height: 16),
      kit.section(
        'Cards and progress',
        'Grouped content and completion indicators for dense pages.',
        Row(
          children: [
            Expanded(child: kit.progress(.42)),
            const SizedBox(width: 16),
            kit.text('42%', emphasized: true),
          ],
        ),
      ),
    ],
  );

  Widget _overlays() => kit.section(
    'Dialogs, popovers, and menus',
    'Anchored and modal surfaces keep actions close to their trigger.',
    kit.overlays(() => _showNotice('Overlay action selected.')),
  );

  Widget _navigation() => kit.section(
    'Tabs, disclosure, and sidebar',
    'Selection, expansion, and focus behavior remain with Remix primitives.',
    kit.navigation(),
  );

  Widget _typography() => kit.section(
    'Type scale and inline text',
    'Headings, body copy, links, code, and keyboard hints.',
    kit.typography(() => _showNotice('Typography action activated.')),
  );

  Widget _settingRow(String title, String description, Widget control) => Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            kit.text(title, emphasized: true),
            const SizedBox(height: 4),
            kit.text(description, muted: true),
          ],
        ),
      ),
      const SizedBox(width: 16),
      control,
    ],
  );

  void _showNotice(String message) => setState(() => _notice = message);

  void _dismissNotice() => setState(() => _notice = '');
}

const _actionLabels = [
  'Primary',
  'Secondary',
  'Outline',
  'Ghost',
  'Destructive',
];

String _description(RegistryDashboardDemoPage page) => switch (page) {
  .overview => 'A snapshot of your workspace performance.',
  .chat => 'Work with an assistant without leaving the dashboard.',
  .customers => 'Manage customer access, plans, and account status.',
  .orders => 'Review transactions and fulfillment status.',
  .settings => 'Manage your profile, preferences, and workspace.',
  .charts => 'Production chart patterns, states, and interactions.',
  .actions => 'Buttons, toggles, and actionable feedback.',
  .forms => 'Fields, selectors, and validation-ready controls.',
  .dataDisplay => 'Cards, badges, lists, tables, and progress.',
  .overlays => 'Dialogs, popovers, menus, tooltips, and toasts.',
  .navigation => 'Tabs, disclosures, and wayfinding patterns.',
  .typography => 'The preset type scale and inline text treatments.',
};
