import 'package:flutter/widgets.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import 'dashboard_demo_page_header.dart';
import 'dashboard_demo_theme.dart';
import 'dashboard_demo_theme_panel.dart';
import 'dashboard_demo_typography.dart';
import 'dashboard_demo_ui.dart';
import 'dashboard_demo_widgets.dart';

class UiDashboardSettingsPage extends StatefulWidget {
  const UiDashboardSettingsPage({
    super.key,
    this.darkMode,
    this.onDarkModeChanged,
  });

  final bool? darkMode;
  final ValueChanged<bool?>? onDarkModeChanged;

  @override
  State<UiDashboardSettingsPage> createState() =>
      _UiDashboardSettingsPageState();
}

class _UiDashboardSettingsPageState extends State<UiDashboardSettingsPage> {
  final _nameController = TextEditingController(text: 'Leo Farias');
  final _emailController = TextEditingController(text: 'leo@remix.dev');
  String _language = 'English (US)';
  bool _productUpdates = true;
  bool _weeklyDigest = false;
  UiThemeSettings _fallbackSettings = const UiThemeSettings();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ambientScope = UiDashboardThemeScope.maybeOf(context);
    final effectiveSettings =
        ambientScope?.settings ??
        _fallbackSettings.copyWith(
          appearance: switch (widget.darkMode) {
            false => UiThemeMode.light,
            true => UiThemeMode.dark,
            null => _fallbackSettings.appearance,
          },
        );
    final GridBoxStyler profileFields = .equalColumns(
      2,
    ).gap(14).onConstraints(const .maxWidth(560), .equalColumns(1).gap(14));

    final content = SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Box(
        style: BoxStyler().alignment(.topStart),
        child: ColumnBox(
          style: FlexBoxStyler()
              .maxWidth(680)
              .crossAxisAlignment(.stretch)
              .spacing(20),
          children: [
            const UiPageHeader(
              title: 'Settings',
              description: 'Manage your profile, preferences, and workspace.',
            ),
            UiCard(
              size: .size3,
              child: ColumnBox(
                style: FlexBoxStyler().crossAxisAlignment(.stretch).spacing(16),
                children: [
                  const UiCardHeading(
                    title: 'Profile',
                    description:
                        'Your personal details and communication preferences.',
                  ),
                  GridBox(
                    style: profileFields,
                    children: [
                      UiTextField(
                        controller: _nameController,
                        label: 'Name',
                        hintText: 'Your name',
                      ),
                      UiTextField(
                        controller: _emailController,
                        label: 'Email',
                        helperText: 'Domain verification is pending.',
                        error: true,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ],
                  ),
                  UiSelect<String>(
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
                  const UiCardHeading(
                    title: 'Preferences',
                    description:
                        'Choose which workspace activity reaches your inbox.',
                  ),
                  _PreferenceRow(
                    title: 'Product updates',
                    description: 'News about features and improvements.',
                    trailing: UiSwitch(
                      selected: _productUpdates,
                      semanticLabel: 'Receive product updates',
                      onChanged: (value) =>
                          setState(() => _productUpdates = value),
                    ),
                  ),
                  _PreferenceRow(
                    title: 'Weekly digest',
                    description: 'A summary of workspace activity each Monday.',
                    trailing: UiCheckbox(
                      selected: _weeklyDigest,
                      semanticLabel: 'Receive weekly digest',
                      onChanged: (value) =>
                          setState(() => _weeklyDigest = value ?? false),
                    ),
                  ),
                  Box(
                    style: BoxStyler().alignment(.centerStart),
                    child: UiButton(
                      onPressed: () => showRemixToast(
                        context,
                        const RemixToastData(
                          title: 'Profile settings saved',
                          icon: LucideIcons.circleCheck,
                        ),
                      ),
                      label: 'Save changes',
                    ),
                  ),
                ],
              ),
            ),
            UiCard(
              size: .size3,
              child: ColumnBox(
                style: FlexBoxStyler().crossAxisAlignment(.stretch).spacing(16),
                children: const [
                  UiCardHeading(
                    title: 'Appearance',
                    description: 'Tune every Ui theme parameter in real time.',
                  ),
                  UiCallout(
                    icon: LucideIcons.wandSparkles,
                    text: 'Changes apply live across the entire dashboard.',
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: UiThemePanel(),
                  ),
                ],
              ),
            ),
            UiAccentScope(
              accent: .red,
              child: UiDisclosure.soft(
                key: const ValueKey('settings-danger-zone'),
                size: .size3,
                animationStyle: uiDisclosureAnimationStyle,
                semanticHint: 'Shows destructive workspace actions',
                trigger: const StyledText('Danger zone'),
                triggerBuilder: (context, state, child) => UiDisclosureTrigger(
                  expanded: state.isExpanded,
                  child: child!,
                ),
                content: ColumnBox(
                  style: FlexBoxStyler()
                      .crossAxisAlignment(.stretch)
                      .spacing(12),
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
        ),
      ),
    );

    if (ambientScope != null) return content;
    return UiDashboardThemeScope(
      settings: effectiveSettings,
      onChanged: (next) {
        setState(() => _fallbackSettings = next);
        widget.onDarkModeChanged?.call(switch (next.appearance) {
          .light => false,
          .dark => true,
          .system => null,
        });
      },
      child: content,
    );
  }

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
          UiAccentScope(
            accent: .red,
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
    style: FlexBoxStyler().crossAxisAlignment(.center),
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
