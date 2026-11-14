import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../components/code.dart';
import '../../components/kbd.dart';
import '../../components/link.dart';
import '../../components/slider.dart';
import 'dashboard_demo_data.dart';
import 'dashboard_demo_page_header.dart';
import 'dashboard_demo_text.dart';
import 'dashboard_demo_theme.dart';
import 'dashboard_demo_theme_panel.dart';
import 'dashboard_demo_typography.dart';
import 'dashboard_demo_ui.dart';
import 'dashboard_demo_widgets.dart';
import 'dashboard_overview.dart';

/// The sections of the Settings page, one tab each.
enum FortalSettingsSection {
  profile('Profile'),
  notifications('Notifications'),
  appearance('Appearance'),
  plan('Plan');

  const FortalSettingsSection(this.label);

  /// The tab label.
  final String label;
}

/// The Settings page: profile, notifications, appearance and plan, one tab
/// each.
///
/// The Appearance tab edits the nearest [FortalDashboardThemeScope], so the
/// whole dashboard restyles as the controls change.
class FortalDashboardSettingsPage extends StatefulWidget {
  const FortalDashboardSettingsPage({
    super.key,
    this.data,
    this.initialSection = .profile,
  });

  /// The records the page shows. Defaults to [fortalDashboardSampleData].
  final FortalDashboardData? data;

  /// The tab shown first.
  final FortalSettingsSection initialSection;

  @override
  State<FortalDashboardSettingsPage> createState() =>
      _FortalDashboardSettingsPageState();
}

class _FortalDashboardSettingsPageState
    extends State<FortalDashboardSettingsPage> {
  late FortalSettingsSection _section = widget.initialSection;

  @override
  Widget build(BuildContext context) {
    final data = widget.data ?? fortalDashboardSampleData;
    return RemixTabs(
      selectedTabId: _section.name,
      onChanged: (id) =>
          setState(() => _section = FortalSettingsSection.values.byName(id)),
      child: FortalPage(
        key: const ValueKey('dashboard-settings'),
        maxWidth: 760,
        title: 'Settings',
        description: 'Your profile, your notifications and how it all looks.',
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: FortalTabBar(
              child: RowBox(
                style: FlexBoxStyler().mainAxisSize(.min),
                children: [
                  for (final section in FortalSettingsSection.values)
                    FortalTab(
                      key: ValueKey('settings-tab-${section.name}'),
                      tabId: section.name,
                      label: section.label,
                    ),
                ],
              ),
            ),
          ),
          FortalTabView(
            tabId: FortalSettingsSection.profile.name,
            child: const _ProfileSection(),
          ),
          FortalTabView(
            tabId: FortalSettingsSection.notifications.name,
            child: const _NotificationsSection(),
          ),
          FortalTabView(
            tabId: FortalSettingsSection.appearance.name,
            child: const _AppearanceSection(),
          ),
          FortalTabView(
            tabId: FortalSettingsSection.plan.name,
            child: _PlanSection(data: data),
          ),
        ],
      ),
    );
  }
}

final _sectionColumn = FlexBoxStyler()
    .crossAxisAlignment(.stretch)
    .spacing(FortalTokens.space4());

class _ProfileSection extends StatefulWidget {
  const _ProfileSection();

  @override
  State<_ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<_ProfileSection> {
  static final _fields = GridBoxStyler.equalColumns(2)
      .gap(fortalDashboardGap)
      .onConstraints(
        const .maxWidth(519),
        .equalColumns(1).gap(fortalDashboardGap),
      );

  final _nameController = TextEditingController(text: 'Leo Farias');
  final _emailController = TextEditingController(text: 'leo@northstar.co');
  final _bioController = TextEditingController(
    text: 'Runs the studio, signs every certificate.',
  );
  bool _emailEdited = false;
  String _language = 'English (US)';

  bool get _emailInvalid =>
      _emailEdited && !_emailController.text.trim().contains('@');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ColumnBox(
    style: _sectionColumn,
    children: [
      FortalSurface(
        size: .size3,
        child: ColumnBox(
          style: _sectionColumn,
          children: [
            const FortalCardHeader(
              title: 'Profile',
              description: 'How you appear to collectors and the team.',
            ),
            RowBox(
              style: FlexBoxStyler()
                  .crossAxisAlignment(.center)
                  .spacing(FortalTokens.space4()),
              children: [
                const FortalAvatar(
                  label: 'LF',
                  size: .size5,
                  fallbackLength: 2,
                ),
                Expanded(
                  child: ColumnBox(
                    style: FlexBoxStyler()
                        .crossAxisAlignment(.start)
                        .spacing(FortalTokens.space2()),
                    children: [
                      FortalButton.soft(
                        size: .size1,
                        label: 'Change photo',
                        onPressed: () => fortalDashboardToast(
                          context,
                          'Photo picker opened',
                        ),
                      ),
                      StyledText(
                        'PNG or JPG, at least 256 pixels square.',
                        style: dashboardText(.size1, tone: .muted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            GridBox(
              style: _fields,
              children: [
                FortalTextField(
                  controller: _nameController,
                  label: 'Name',
                  hintText: 'Your name',
                ),
                FortalTextField(
                  controller: _emailController,
                  label: 'Email',
                  // Validation shows only after the person edits it.
                  helperText: _emailInvalid
                      ? 'Enter a valid email address.'
                      : 'Used for receipts and sign-in.',
                  error: _emailInvalid,
                  onChanged: (_) => setState(() => _emailEdited = true),
                  keyboardType: TextInputType.emailAddress,
                ),
              ],
            ),
            FortalTextArea(
              controller: _bioController,
              label: 'Bio',
              hintText: 'A sentence about you',
            ),
            ColumnBox(
              style: FlexBoxStyler()
                  .crossAxisAlignment(.stretch)
                  .spacing(FortalTokens.space2()),
              children: [
                // The select below carries the accessible name.
                const ExcludeSemantics(
                  child: FortalText('Language', size: .size2, weight: .medium),
                ),
                FortalSelect<String>(
                  semanticLabel: 'Language',
                  trigger: const RemixSelectTrigger(placeholder: 'Language'),
                  selectedValue: _language,
                  items: const [
                    RemixSelectItem(
                      value: 'English (US)',
                      label: 'English (US)',
                    ),
                    RemixSelectItem(
                      value: 'English (UK)',
                      label: 'English (UK)',
                    ),
                    RemixSelectItem(value: 'Spanish', label: 'Spanish'),
                    RemixSelectItem(value: 'Portuguese', label: 'Portuguese'),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _language = value);
                  },
                ),
              ],
            ),
            Box(
              style: BoxStyler().alignment(.centerStart),
              child: FortalButton(
                key: const ValueKey('settings-save'),
                onPressed: () =>
                    fortalDashboardToast(context, 'Profile settings saved'),
                label: 'Save changes',
              ),
            ),
          ],
        ),
      ),
      FortalAccentScope.error(
        child: FortalDisclosure.soft(
          key: const ValueKey('settings-danger-zone'),
          size: .size3,
          animationStyle: fortalDisclosureAnimationStyle,
          semanticHint: 'Shows destructive workspace actions',
          trigger: const StyledText('Danger zone'),
          triggerBuilder: (context, state, child) => FortalDisclosureTrigger(
            expanded: state.isExpanded,
            child: child!,
          ),
          content: ColumnBox(
            style: FlexBoxStyler()
                .crossAxisAlignment(.stretch)
                .spacing(FortalTokens.space3()),
            children: [
              const StyledText(
                'Destructive workspace actions cannot be undone.',
              ),
              Box(
                style: BoxStyler().alignment(.centerStart),
                child: FortalButton.outline(
                  onPressed: _confirmDelete,
                  label: 'Delete workspace',
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );

  Future<void> _confirmDelete() async {
    final confirmed = await showRemixDialog<bool>(
      context: context,
      barrierLabel: 'Dismiss',
      builder: (context) => FortalDialog(
        title: 'Delete workspace?',
        description:
            'This demo keeps your data safe, but a real action would be permanent.',
        actions: [
          FortalButton.soft(
            onPressed: () => Navigator.of(context).pop(false),
            label: 'Cancel',
          ),
          FortalAccentScope.error(
            child: FortalButton(
              onPressed: () => Navigator.of(context).pop(true),
              label: 'Delete',
            ),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    showRemixToast(
      context,
      const RemixToastData(
        title: 'Demo workspace was not deleted',
        icon: RemixIcons.info,
      ),
    );
  }
}

/// How often the activity summary is sent.
enum _Digest {
  daily('Daily', 'Every morning at 8:00.'),
  weekly('Weekly', 'Mondays, with the week ahead.'),
  never('Never', 'Only the alerts chosen above.');

  const _Digest(this.label, this.description);

  final String label;
  final String description;
}

class _NotificationsSection extends StatefulWidget {
  const _NotificationsSection();

  @override
  State<_NotificationsSection> createState() => _NotificationsSectionState();
}

class _NotificationsSectionState extends State<_NotificationsSection> {
  bool _orders = true;
  bool _lowStock = true;
  bool _releases = false;
  bool _productUpdates = false;
  double _threshold = 10;
  _Digest _digest = .weekly;

  @override
  Widget build(BuildContext context) => ColumnBox(
    style: _sectionColumn,
    children: [
      FortalSurface(
        size: .size3,
        child: ColumnBox(
          style: _sectionColumn,
          children: [
            const FortalCardHeader(
              title: 'Alerts',
              description: 'Choose which studio activity reaches your inbox.',
            ),
            _PreferenceRow(
              title: 'New orders',
              description: 'Each time a collector checks out.',
              trailing: FortalSwitch(
                selected: _orders,
                semanticLabel: 'Notify me about new orders',
                onChanged: (value) => setState(() => _orders = value),
              ),
            ),
            const FortalDivider(size: .size4),
            _PreferenceRow(
              title: 'Low stock',
              description:
                  'When an edition has ${_threshold.round()} prints left.',
              trailing: FortalSwitch(
                selected: _lowStock,
                semanticLabel: 'Notify me about low stock',
                onChanged: (value) => setState(() => _lowStock = value),
              ),
            ),
            FortalSlider(
              key: const ValueKey('settings-threshold'),
              value: _threshold,
              min: 5,
              max: 50,
              snapDivisions: 9,
              enabled: _lowStock,
              semanticLabel: 'Low stock threshold, in prints',
              onChanged: (value) => setState(() => _threshold = value),
            ),
            const FortalDivider(size: .size4),
            _PreferenceRow(
              title: 'Release reminders',
              description: 'The day before a scheduled release.',
              trailing: FortalSwitch(
                selected: _releases,
                semanticLabel: 'Notify me about releases',
                onChanged: (value) => setState(() => _releases = value),
              ),
            ),
            const FortalDivider(size: .size4),
            _PreferenceRow(
              title: 'Product updates',
              description: 'News about features and improvements.',
              trailing: FortalCheckbox(
                selected: _productUpdates,
                semanticLabel: 'Receive product updates',
                onChanged: (value) =>
                    setState(() => _productUpdates = value ?? false),
              ),
            ),
          ],
        ),
      ),
      FortalSurface(
        size: .size3,
        child: ColumnBox(
          style: _sectionColumn,
          children: [
            const FortalCardHeader(
              title: 'Digest',
              description: 'A summary of the studio, on a schedule.',
            ),
            RemixRadioGroup<_Digest>(
              groupValue: _digest,
              onChanged: (value) {
                if (value != null) setState(() => _digest = value);
              },
              child: ColumnBox(
                style: FlexBoxStyler()
                    .crossAxisAlignment(.stretch)
                    .spacing(FortalTokens.space3()),
                children: [
                  for (final digest in _Digest.values)
                    RowBox(
                      style: FlexBoxStyler()
                          .crossAxisAlignment(.start)
                          .spacing(FortalTokens.space3()),
                      children: [
                        FortalRadio(
                          key: ValueKey('settings-digest-${digest.name}'),
                          value: digest,
                          semanticLabel: '${digest.label} digest',
                        ),
                        Expanded(
                          child: ColumnBox(
                            style: FlexBoxStyler().crossAxisAlignment(.start),
                            children: [
                              FortalText(
                                digest.label,
                                size: .size2,
                                weight: .medium,
                              ),
                              StyledText(
                                digest.description,
                                style: dashboardText(.size1, tone: .muted),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _AppearanceSection extends StatelessWidget {
  const _AppearanceSection();

  @override
  Widget build(BuildContext context) => FortalSurface(
    size: .size3,
    child: ColumnBox(
      style: _sectionColumn,
      children: [
        const FortalCardHeader(
          title: 'Appearance',
          description: 'Tune every theme parameter in real time.',
        ),
        const FortalCallout(
          icon: RemixIcons.wand,
          text: 'Changes apply live across the entire dashboard.',
        ),
        if (FortalDashboardThemeScope.maybeOf(context) == null)
          const FortalCallout.outline(
            icon: RemixIcons.info,
            text: 'Place a theme scope above this page to edit its appearance.',
          )
        else
          const SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: FortalThemePanel(),
          ),
      ],
    ),
  );
}

class _PlanSection extends StatelessWidget {
  const _PlanSection({required this.data});

  final FortalDashboardData data;

  static const _invoices = [
    ('INV-0718', 'Jul 1, 2026', r'$49.00'),
    ('INV-0617', 'Jun 1, 2026', r'$49.00'),
    ('INV-0519', 'May 1, 2026', r'$49.00'),
  ];

  @override
  Widget build(BuildContext context) {
    final released = data.editions
        .where((edition) => edition.status != .draft)
        .length;
    return ColumnBox(
      style: _sectionColumn,
      children: [
        FortalSurface(
          emphasis: .tinted,
          size: .size3,
          child: ColumnBox(
            style: _sectionColumn,
            children: [
              FortalCardHeader(
                title: 'Studio plan',
                description: r'$49 a month, renews on Aug 1, 2026.',
                trailing: FortalButton(
                  size: .size1,
                  label: 'Upgrade',
                  onPressed: () =>
                      fortalDashboardToast(context, 'Plan options opened'),
                ),
              ),
              _Usage(
                label: 'Editions',
                detail: '$released of 12',
                value: released / 12,
              ),
              _Usage(
                label: 'Team seats',
                detail: '${data.team.length} of 8',
                value: data.team.length / 8,
              ),
              const _Usage(
                label: 'Storage',
                detail: '18.4 of 50 GB',
                value: 0.368,
              ),
            ],
          ),
        ),
        FortalSurface(
          emphasis: .quiet,
          size: .size3,
          child: ColumnBox(
            style: FlexBoxStyler()
                .crossAxisAlignment(.stretch)
                .spacing(FortalTokens.space3()),
            children: [
              const FortalCardHeader(
                title: 'Developers',
                description: 'Connect the studio to your own tools.',
              ),
              RowBox(
                style: FlexBoxStyler()
                    .crossAxisAlignment(.center)
                    .spacing(FortalTokens.space2()),
                children: [
                  const Expanded(
                    child: FortalCode('nst_live_7f3a…c91e', truncate: true),
                  ),
                  FortalTooltip(
                    tooltipChild: const StyledText('Copy key'),
                    child: FortalIconButton.ghost(
                      icon: RemixIcons.copy,
                      semanticLabel: 'Copy API key',
                      onPressed: () =>
                          fortalDashboardToast(context, 'API key copied'),
                    ),
                  ),
                ],
              ),
              RowBox(
                style: FlexBoxStyler()
                    .crossAxisAlignment(.center)
                    .spacing(FortalTokens.space2()),
                children: [
                  Expanded(
                    child: StyledText(
                      'Search or jump anywhere',
                      style: dashboardText(.size2, tone: .muted),
                    ),
                  ),
                  FortalKbd(fortalQuickFindShortcut),
                ],
              ),
              Box(
                style: BoxStyler().alignment(.centerStart),
                child: FortalLink(
                  'Read the API guide',
                  size: .size2,
                  onPressed: () =>
                      fortalDashboardToast(context, 'API guide opened'),
                ),
              ),
            ],
          ),
        ),
        FortalSurface(
          size: .size3,
          child: ColumnBox(
            style: FlexBoxStyler()
                .crossAxisAlignment(.stretch)
                .spacing(FortalTokens.space3()),
            children: [
              const FortalCardHeader(
                title: 'Invoices',
                description: 'The last three, newest first.',
              ),
              for (final (number, date, amount) in _invoices)
                RowBox(
                  style: FlexBoxStyler()
                      .crossAxisAlignment(.center)
                      .spacing(FortalTokens.space3()),
                  children: [
                    Expanded(
                      child: ColumnBox(
                        style: FlexBoxStyler().crossAxisAlignment(.start),
                        children: [
                          FortalText(number, size: .size2, weight: .medium),
                          StyledText(
                            date,
                            style: dashboardText(.size1, tone: .muted),
                          ),
                        ],
                      ),
                    ),
                    FortalText(amount, size: .size2, weight: .medium),
                    FortalIconButton.ghost(
                      icon: RemixIcons.download,
                      semanticLabel: 'Download $number',
                      onPressed: () =>
                          fortalDashboardToast(context, '$number downloaded'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Usage extends StatelessWidget {
  const _Usage({
    required this.label,
    required this.detail,
    required this.value,
  });

  final String label;
  final String detail;
  final double value;

  @override
  Widget build(BuildContext context) => ColumnBox(
    style: FlexBoxStyler()
        .crossAxisAlignment(.stretch)
        .spacing(FortalTokens.space2()),
    children: [
      RowBox(
        children: [
          Expanded(
            child: FortalText(label, size: .size2, weight: .medium),
          ),
          StyledText(detail, style: dashboardText(.size1, tone: .muted)),
        ],
      ),
      FortalProgress(
        value: value.clamp(0, 1).toDouble(),
        semanticsLabel: '$label used',
      ),
    ],
  );
}

class _PreferenceRow extends StatelessWidget {
  const _PreferenceRow({
    required this.title,
    required this.description,
    required this.trailing,
  });

  final String title;
  final String description;
  final Widget trailing;

  @override
  Widget build(BuildContext context) => RowBox(
    style: FlexBoxStyler()
        .crossAxisAlignment(.center)
        .spacing(FortalTokens.space3()),
    children: [
      Expanded(
        child: ColumnBox(
          style: FlexBoxStyler().crossAxisAlignment(.start).spacing(2),
          children: [
            FortalText(title, size: .size2, weight: .medium),
            StyledText(description, style: dashboardText(.size1, tone: .muted)),
          ],
        ),
      ),
      trailing,
    ],
  );
}
