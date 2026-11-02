import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../components/button.dart';
import '../../components/callout.dart';
import '../../components/card.dart';
import '../../components/checkbox.dart';
import '../../components/dialog.dart';
import '../../components/disclosure.dart';
import '../../components/segmented_control.dart';
import '../../components/select.dart';
import '../../components/slider.dart';
import '../../components/switch.dart';
import '../../components/textfield.dart';
import '../../theme/theme_data.dart';
import '../../theme/theme_scope.dart';
import '../../theme/tokens.dart';
import 'dashboard_demo_text.dart';

enum _Appearance { light, dark, system }

class VanillaDashboardSettingsPage extends StatefulWidget {
  const VanillaDashboardSettingsPage({
    super.key,
    this.darkMode,
    this.onDarkModeChanged,
    this.onRadiusChanged,
  });

  final bool? darkMode;
  final ValueChanged<bool?>? onDarkModeChanged;

  /// Called with the base corner radius, in logical pixels, as the slider moves.
  final ValueChanged<double>? onRadiusChanged;

  @override
  State<VanillaDashboardSettingsPage> createState() =>
      _VanillaDashboardSettingsPageState();
}

class _VanillaDashboardSettingsPageState
    extends State<VanillaDashboardSettingsPage> {
  bool _productUpdates = true;
  bool _weeklyDigest = false;
  String _language = 'en';
  _Appearance _appearance = .system;
  double? _radius;
  bool _dangerZoneExpanded = false;

  _Appearance get _resolvedAppearance => widget.onDarkModeChanged == null
      ? _appearance
      : switch (widget.darkMode) {
          false => .light,
          true => .dark,
          null => .system,
        };

  /// The slider's value: the user's drag, otherwise the active theme's
  /// [VanillaThemeData.radius].
  double _resolvedRadius(BuildContext context) =>
      _radius ??
      VanillaTheme.maybeOf(context)?.radius.x ??
      const VanillaThemeData.light().radius.x;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(VanillaTokens.s8),
    child: Box(
      style: BoxStyler().alignment(.topStart),
      child: ColumnBox(
        style: FlexBoxStyler()
            .maxWidth(880)
            .crossAxisAlignment(.stretch)
            .spacing(VanillaTokens.s4),
        children: [
          ColumnBox(
            style: FlexBoxStyler()
                .crossAxisAlignment(.start)
                .spacing(VanillaTokens.s1),
            children: const [
              VanillaDashboardText(
                'Settings',
                token: VanillaTokens.text3xl,
                emphasized: true,
              ),
              VanillaDashboardText(
                'Manage your profile, preferences, and workspace.',
                muted: true,
              ),
            ],
          ),
          _section(
            'Profile',
            'This information appears across your workspace.',
            ColumnBox(
              style: FlexBoxStyler()
                  .crossAxisAlignment(.stretch)
                  .spacing(VanillaTokens.s3),
              children: [
                GridBox(
                  style: GridBoxStyler.equalColumns(2)
                      .gap(VanillaTokens.s3)
                      .onConstraints(
                        const .maxWidth(559),
                        .equalColumns(1).gap(VanillaTokens.s3),
                      ),
                  children: const [
                    VanillaTextField(label: 'Full name', hintText: 'Ada Chen'),
                    VanillaTextField(
                      label: 'Email address',
                      hintText: 'ada@northstar.co',
                    ),
                  ],
                ),
                VanillaSelect<String>(
                  trigger: const RemixSelectTrigger(placeholder: 'Language'),
                  items: const [
                    RemixSelectItem(value: 'en', label: 'English'),
                    RemixSelectItem(value: 'es', label: 'Spanish'),
                    RemixSelectItem(value: 'fr', label: 'French'),
                  ],
                  selectedValue: _language,
                  onChanged: (value) {
                    if (value != null) setState(() => _language = value);
                  },
                ),
                Box(
                  style: BoxStyler().alignment(.centerStart),
                  child: VanillaButton(
                    label: 'Save changes',
                    onPressed: () => vanillaDashboardToast(
                      context,
                      'Profile settings saved',
                    ),
                  ),
                ),
              ],
            ),
          ),
          _section(
            'Preferences',
            'Choose which workspace activity reaches your inbox.',
            ColumnBox(
              style: FlexBoxStyler()
                  .crossAxisAlignment(.stretch)
                  .spacing(VanillaTokens.s4),
              children: [
                _preference(
                  'Product updates',
                  'News about features and improvements.',
                  VanillaSwitch(
                    selected: _productUpdates,
                    semanticLabel: 'Receive product updates',
                    onChanged: (value) =>
                        setState(() => _productUpdates = value),
                  ),
                ),
                _preference(
                  'Weekly digest',
                  'A summary of workspace activity each Monday.',
                  VanillaCheckbox(
                    selected: _weeklyDigest,
                    semanticLabel: 'Receive weekly digest',
                    onChanged: (value) =>
                        setState(() => _weeklyDigest = value ?? false),
                  ),
                ),
              ],
            ),
          ),
          _section(
            'Appearance',
            'Choose light, dark, or match the system.',
            ColumnBox(
              style: FlexBoxStyler()
                  .crossAxisAlignment(.stretch)
                  .spacing(VanillaTokens.s4),
              children: [
                const VanillaCallout(
                  icon: RemixIcons.wand,
                  text:
                      'Changes are deterministic and remain local to the demo.',
                ),
                ColumnBox(
                  style: FlexBoxStyler()
                      .crossAxisAlignment(.start)
                      .spacing(VanillaTokens.s2),
                  children: [
                    const VanillaDashboardText('Color mode', emphasized: true),
                    VanillaSegmentedControl<_Appearance>(
                      semanticLabel: 'Color mode',
                      selectedValue: _resolvedAppearance,
                      items: const [
                        RemixSegmentedControlItem(
                          value: .light,
                          label: 'Light',
                        ),
                        RemixSegmentedControlItem(value: .dark, label: 'Dark'),
                        RemixSegmentedControlItem(
                          value: .system,
                          label: 'System',
                        ),
                      ],
                      onChanged: (value) {
                        setState(() => _appearance = value);
                        widget.onDarkModeChanged?.call(switch (value) {
                          .light => false,
                          .dark => true,
                          .system => null,
                        });
                      },
                    ),
                  ],
                ),
                ColumnBox(
                  style: FlexBoxStyler()
                      .crossAxisAlignment(.stretch)
                      .spacing(VanillaTokens.s2),
                  children: [
                    VanillaDashboardText(
                      'Control radius · ${_resolvedRadius(context).round()}px',
                      emphasized: true,
                    ),
                    VanillaSlider(
                      value: _resolvedRadius(context),
                      min: 0,
                      max: 16,
                      snapDivisions: 16,
                      onChanged: (value) {
                        setState(() => _radius = value);
                        widget.onRadiusChanged?.call(value);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          VanillaDisclosure(
            key: const ValueKey('settings-danger-zone'),
            expanded: _dangerZoneExpanded,
            onExpandedChanged: (value) =>
                setState(() => _dangerZoneExpanded = value),
            semanticHint: 'Shows destructive workspace actions',
            trigger: VanillaDisclosureTrigger(
              expanded: _dangerZoneExpanded,
              child: const VanillaDashboardText(
                'Danger zone',
                emphasized: true,
              ),
            ),
            content: ColumnBox(
              style: FlexBoxStyler()
                  .crossAxisAlignment(.stretch)
                  .spacing(VanillaTokens.s3),
              children: [
                const VanillaDashboardText(
                  'Destructive workspace actions cannot be undone.',
                ),
                Box(
                  style: BoxStyler().alignment(.centerStart),
                  child: VanillaButton.destructive(
                    label: 'Delete workspace',
                    onPressed: _confirmDelete,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Future<void> _confirmDelete() async {
    final confirmed = await showRemixDialog<bool>(
      context: context,
      barrierLabel: 'Dismiss',
      builder: (dialogContext) => VanillaDialog(
        title: 'Delete workspace?',
        description:
            'This demo keeps your data safe, but a real action would be permanent.',
        actions: [
          VanillaButton.secondary(
            label: 'Cancel',
            onPressed: () => Navigator.of(dialogContext).pop(false),
          ),
          VanillaButton.destructive(
            label: 'Delete',
            onPressed: () => Navigator.of(dialogContext).pop(true),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    vanillaDashboardToast(context, 'Demo workspace was not deleted');
  }
}

Widget _section(String title, String description, Widget child) => VanillaCard(
  child: ColumnBox(
    style: FlexBoxStyler()
        .crossAxisAlignment(.stretch)
        .spacing(VanillaTokens.s4),
    children: [
      ColumnBox(
        style: FlexBoxStyler()
            .crossAxisAlignment(.start)
            .spacing(VanillaTokens.s1),
        children: [
          VanillaDashboardText(
            title,
            token: VanillaTokens.textLg,
            emphasized: true,
          ),
          VanillaDashboardText(description, muted: true),
        ],
      ),
      child,
    ],
  ),
);

Widget _preference(String title, String description, Widget trailing) => RowBox(
  style: FlexBoxStyler().crossAxisAlignment(.center).spacing(VanillaTokens.s4),
  children: [
    Expanded(
      child: ColumnBox(
        style: FlexBoxStyler()
            .crossAxisAlignment(.start)
            .spacing(VanillaTokens.s0_5),
        children: [
          VanillaDashboardText(title, emphasized: true),
          VanillaDashboardText(description, muted: true),
        ],
      ),
    ),
    trailing,
  ],
);

class VanillaDisclosureTrigger extends StatelessWidget {
  const VanillaDisclosureTrigger({
    super.key,
    required this.expanded,
    required this.child,
  });

  final bool expanded;
  final Widget child;

  @override
  Widget build(BuildContext context) => RowBox(
    style: FlexBoxStyler().crossAxisAlignment(.center),
    children: [
      Expanded(child: child),
      Box(
        style: BoxStyler()
            .transform(
              Matrix4.rotationZ(expanded ? math.pi : 0),
              alignment: .center,
            )
            .animate(VanillaTokens.motion),
        child: StyledIcon(
          icon: RemixIcons.chevronDown,
          style: IconStyler()
              .size(VanillaTokens.icon)
              .color(VanillaTokens.mutedForeground()),
        ),
      ),
    ],
  );
}
