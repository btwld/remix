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
enum UiSettingsSection {
  profile('Profile'),
  notifications('Notifications'),
  appearance('Appearance'),
  plan('Plan');

  const UiSettingsSection(this.label);

  /// The tab label.
  final String label;
}

/// The Settings page: profile, notifications, appearance and plan, one tab
/// each.
///
/// The Appearance tab edits the nearest [UiDashboardThemeScope], so the
/// whole dashboard restyles as the controls change.
class UiDashboardSettingsPage extends StatefulWidget {
  const UiDashboardSettingsPage({
    super.key,
    this.data,
    this.initialSection = .profile,
  });

  /// The records the page shows. Defaults to [uiDashboardSampleData].
  final UiDashboardData? data;

  /// The tab shown first.
  final UiSettingsSection initialSection;

  @override
  State<UiDashboardSettingsPage> createState() =>
      _UiDashboardSettingsPageState();
}

class _UiDashboardSettingsPageState extends State<UiDashboardSettingsPage> {
  late UiSettingsSection _section = widget.initialSection;

  @override
  Widget build(BuildContext context) {
    final data = widget.data ?? uiDashboardSampleData;
    return RemixTabs(
      selectedTabId: _section.name,
      onChanged: (id) =>
          setState(() => _section = UiSettingsSection.values.byName(id)),
      child: UiPage(
        key: const ValueKey('dashboard-settings'),
        maxWidth: 760,
        title: 'Settings',
        description: 'Your profile, your notifications and how it all looks.',
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: UiTabBar(
              child: RowBox(
                style: FlexBoxStyler().mainAxisSize(.min),
                children: [
                  for (final section in UiSettingsSection.values)
                    UiTab(
                      key: ValueKey('settings-tab-${section.name}'),
                      tabId: section.name,
                      label: section.label,
                    ),
                ],
              ),
            ),
          ),
          UiTabView(
            tabId: UiSettingsSection.profile.name,
            child: const _ProfileSection(),
          ),
          UiTabView(
            tabId: UiSettingsSection.notifications.name,
            child: const _NotificationsSection(),
          ),
          UiTabView(
            tabId: UiSettingsSection.appearance.name,
            child: const _AppearanceSection(),
          ),
          UiTabView(
            tabId: UiSettingsSection.plan.name,
            child: _PlanSection(data: data),
          ),
        ],
      ),
    );
  }
}

final _sectionColumn = FlexBoxStyler()
    .crossAxisAlignment(.stretch)
    .spacing(UiTokens.space4());

class _ProfileSection extends StatefulWidget {
  const _ProfileSection();

  @override
  State<_ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<_ProfileSection> {
  static final _fields = GridBoxStyler.equalColumns(2)
      .gap(uiDashboardGap)
      .onConstraints(
        const .maxWidth(519),
        .equalColumns(1).gap(uiDashboardGap),
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
      UiSurface(
        size: .size3,
        child: ColumnBox(
          style: _sectionColumn,
          children: [
            const UiCardHeader(
              title: 'Profile',
              description: 'How you appear to collectors and the team.',
            ),
            RowBox(
              style: FlexBoxStyler()
                  .crossAxisAlignment(.center)
                  .spacing(UiTokens.space4()),
              children: [
                const UiAvatar(label: 'LF', size: .size5, fallbackLength: 2),
                Expanded(
                  child: ColumnBox(
                    style: FlexBoxStyler()
                        .crossAxisAlignment(.start)
                        .spacing(UiTokens.space2()),
                    children: [
                      UiButton.soft(
                        size: .size1,
                        label: 'Change photo',
                        onPressed: () =>
                            uiDashboardToast(context, 'Photo picker opened'),
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
                UiTextField(
                  controller: _nameController,
                  label: 'Name',
                  hintText: 'Your name',
                ),
                UiTextField(
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
            UiTextArea(
              controller: _bioController,
              label: 'Bio',
              hintText: 'A sentence about you',
            ),
            ColumnBox(
              style: FlexBoxStyler()
                  .crossAxisAlignment(.stretch)
                  .spacing(UiTokens.space2()),
              children: [
                // The select below carries the accessible name.
                const ExcludeSemantics(
                  child: UiText('Language', size: .size2, weight: .medium),
                ),
                UiSelect<String>(
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
              child: UiButton(
                key: const ValueKey('settings-save'),
                onPressed: () =>
                    uiDashboardToast(context, 'Profile settings saved'),
                label: 'Save changes',
              ),
            ),
          ],
        ),
      ),
      UiAccentScope.error(
        child: UiDisclosure.soft(
          key: const ValueKey('settings-danger-zone'),
          size: .size3,
          animationStyle: uiDisclosureAnimationStyle,
          semanticHint: 'Shows destructive workspace actions',
          trigger: const StyledText('Danger zone'),
          triggerBuilder: (context, state, child) =>
              UiDisclosureTrigger(expanded: state.isExpanded, child: child!),
          content: ColumnBox(
            style: FlexBoxStyler()
                .crossAxisAlignment(.stretch)
                .spacing(UiTokens.space3()),
            children: [
              const StyledText(
                'Destructive workspace actions cannot be undone.',
              ),
              Box(
                style: BoxStyler().alignment(.centerStart),
                child: UiButton.outline(
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
      builder: (context) => UiDialog(
        title: 'Delete workspace?',
        description:
            'This demo keeps your data safe, but a real action would be permanent.',
        actions: [
          UiButton.soft(
            onPressed: () => Navigator.of(context).pop(false),
            label: 'Cancel',
          ),
          UiAccentScope.error(
            child: UiButton(
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
      UiSurface(
        size: .size3,
        child: ColumnBox(
          style: _sectionColumn,
          children: [
            const UiCardHeader(
              title: 'Alerts',
              description: 'Choose which studio activity reaches your inbox.',
            ),
            _PreferenceRow(
              title: 'New orders',
              description: 'Each time a collector checks out.',
              trailing: UiSwitch(
                selected: _orders,
                semanticLabel: 'Notify me about new orders',
                onChanged: (value) => setState(() => _orders = value),
              ),
            ),
            const UiDivider(size: .size4),
            _PreferenceRow(
              title: 'Low stock',
              description:
                  'When an edition has ${_threshold.round()} prints left.',
              trailing: UiSwitch(
                selected: _lowStock,
                semanticLabel: 'Notify me about low stock',
                onChanged: (value) => setState(() => _lowStock = value),
              ),
            ),
            UiSlider(
              key: const ValueKey('settings-threshold'),
              value: _threshold,
              min: 5,
              max: 50,
              snapDivisions: 9,
              enabled: _lowStock,
              semanticLabel: 'Low stock threshold, in prints',
              onChanged: (value) => setState(() => _threshold = value),
            ),
            const UiDivider(size: .size4),
            _PreferenceRow(
              title: 'Release reminders',
              description: 'The day before a scheduled release.',
              trailing: UiSwitch(
                selected: _releases,
                semanticLabel: 'Notify me about releases',
                onChanged: (value) => setState(() => _releases = value),
              ),
            ),
            const UiDivider(size: .size4),
            _PreferenceRow(
              title: 'Product updates',
              description: 'News about features and improvements.',
              trailing: UiCheckbox(
                selected: _productUpdates,
                semanticLabel: 'Receive product updates',
                onChanged: (value) =>
                    setState(() => _productUpdates = value ?? false),
              ),
            ),
          ],
        ),
      ),
      UiSurface(
        size: .size3,
        child: ColumnBox(
          style: _sectionColumn,
          children: [
            const UiCardHeader(
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
                    .spacing(UiTokens.space3()),
                children: [
                  for (final digest in _Digest.values)
                    RowBox(
                      style: FlexBoxStyler()
                          .crossAxisAlignment(.start)
                          .spacing(UiTokens.space3()),
                      children: [
                        UiRadio(
                          key: ValueKey('settings-digest-${digest.name}'),
                          value: digest,
                          semanticLabel: '${digest.label} digest',
                        ),
                        Expanded(
                          child: ColumnBox(
                            style: FlexBoxStyler().crossAxisAlignment(.start),
                            children: [
                              UiText(
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
  Widget build(BuildContext context) => UiSurface(
    size: .size3,
    child: ColumnBox(
      style: _sectionColumn,
      children: [
        const UiCardHeader(
          title: 'Appearance',
          description: 'Tune every theme parameter in real time.',
        ),
        const UiCallout(
          icon: RemixIcons.wand,
          text: 'Changes apply live across the entire dashboard.',
        ),
        if (UiDashboardThemeScope.maybeOf(context) == null)
          const UiCallout.outline(
            icon: RemixIcons.info,
            text: 'Place a theme scope above this page to edit its appearance.',
          )
        else
          const SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: UiThemePanel(),
          ),
      ],
    ),
  );
}

class _PlanSection extends StatelessWidget {
  const _PlanSection({required this.data});

  final UiDashboardData data;

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
        UiSurface(
          emphasis: .tinted,
          size: .size3,
          child: ColumnBox(
            style: _sectionColumn,
            children: [
              UiCardHeader(
                title: 'Studio plan',
                description: r'$49 a month, renews on Aug 1, 2026.',
                trailing: UiButton(
                  size: .size1,
                  label: 'Upgrade',
                  onPressed: () =>
                      uiDashboardToast(context, 'Plan options opened'),
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
        UiSurface(
          emphasis: .quiet,
          size: .size3,
          child: ColumnBox(
            style: FlexBoxStyler()
                .crossAxisAlignment(.stretch)
                .spacing(UiTokens.space3()),
            children: [
              const UiCardHeader(
                title: 'Developers',
                description: 'Connect the studio to your own tools.',
              ),
              RowBox(
                style: FlexBoxStyler()
                    .crossAxisAlignment(.center)
                    .spacing(UiTokens.space2()),
                children: [
                  const Expanded(
                    child: UiCode('nst_live_7f3a…c91e', truncate: true),
                  ),
                  UiTooltip(
                    tooltipChild: const StyledText('Copy key'),
                    child: UiIconButton.ghost(
                      icon: RemixIcons.copy,
                      semanticLabel: 'Copy API key',
                      onPressed: () =>
                          uiDashboardToast(context, 'API key copied'),
                    ),
                  ),
                ],
              ),
              RowBox(
                style: FlexBoxStyler()
                    .crossAxisAlignment(.center)
                    .spacing(UiTokens.space2()),
                children: [
                  Expanded(
                    child: StyledText(
                      'Search or jump anywhere',
                      style: dashboardText(.size2, tone: .muted),
                    ),
                  ),
                  UiKbd(uiQuickFindShortcut),
                ],
              ),
              Box(
                style: BoxStyler().alignment(.centerStart),
                child: UiLink(
                  'Read the API guide',
                  size: .size2,
                  onPressed: () =>
                      uiDashboardToast(context, 'API guide opened'),
                ),
              ),
            ],
          ),
        ),
        UiSurface(
          size: .size3,
          child: ColumnBox(
            style: FlexBoxStyler()
                .crossAxisAlignment(.stretch)
                .spacing(UiTokens.space3()),
            children: [
              const UiCardHeader(
                title: 'Invoices',
                description: 'The last three, newest first.',
              ),
              for (final (number, date, amount) in _invoices)
                RowBox(
                  style: FlexBoxStyler()
                      .crossAxisAlignment(.center)
                      .spacing(UiTokens.space3()),
                  children: [
                    Expanded(
                      child: ColumnBox(
                        style: FlexBoxStyler().crossAxisAlignment(.start),
                        children: [
                          UiText(number, size: .size2, weight: .medium),
                          StyledText(
                            date,
                            style: dashboardText(.size1, tone: .muted),
                          ),
                        ],
                      ),
                    ),
                    UiText(amount, size: .size2, weight: .medium),
                    UiIconButton.ghost(
                      icon: RemixIcons.download,
                      semanticLabel: 'Download $number',
                      onPressed: () =>
                          uiDashboardToast(context, '$number downloaded'),
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
        .spacing(UiTokens.space2()),
    children: [
      RowBox(
        children: [
          Expanded(
            child: UiText(label, size: .size2, weight: .medium),
          ),
          StyledText(detail, style: dashboardText(.size1, tone: .muted)),
        ],
      ),
      UiProgress(
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
        .spacing(UiTokens.space3()),
    children: [
      Expanded(
        child: ColumnBox(
          style: FlexBoxStyler().crossAxisAlignment(.start).spacing(2),
          children: [
            UiText(title, size: .size2, weight: .medium),
            StyledText(description, style: dashboardText(.size1, tone: .muted)),
          ],
        ),
      ),
      trailing,
    ],
  );
}
