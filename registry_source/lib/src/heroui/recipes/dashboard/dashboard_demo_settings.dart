import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../components/alert.dart';
import '../../components/button.dart';
import '../../components/card.dart';
import '../../components/checkbox.dart';
import '../../components/disclosure.dart';
import '../../components/modal.dart';
import '../../components/select.dart';
import '../../components/slider.dart';
import '../../components/switch.dart';
import '../../components/textfield.dart';
import '../../theme/theme.dart';
import 'dashboard_demo_text.dart';

enum _Appearance { light, dark, system }

class HeroUiDashboardSettingsPage extends StatefulWidget {
  const HeroUiDashboardSettingsPage({
    super.key,
    this.darkMode,
    this.onDarkModeChanged,
    this.onRadiusChanged,
  });

  final bool? darkMode;
  final ValueChanged<bool?>? onDarkModeChanged;

  /// Called with the base corner radius (`--radius`), in logical pixels, as
  /// the slider moves.
  final ValueChanged<double>? onRadiusChanged;

  @override
  State<HeroUiDashboardSettingsPage> createState() =>
      _HeroUiDashboardSettingsPageState();
}

class _HeroUiDashboardSettingsPageState
    extends State<HeroUiDashboardSettingsPage> {
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
  /// [HeroUiThemeData.radius].
  double _resolvedRadius(BuildContext context) =>
      _radius ??
      HeroUiTheme.maybeOf(context)?.radius ??
      const HeroUiThemeData.light().radius;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(32),
    child: Box(
      style: BoxStyler().alignment(.topStart),
      child: ColumnBox(
        style: FlexBoxStyler()
            .maxWidth(880)
            .crossAxisAlignment(.stretch)
            .spacing(16),
        children: [
          ColumnBox(
            style: FlexBoxStyler().crossAxisAlignment(.start).spacing(4),
            children: const [
              HeroUiDashboardText('Settings', type: .h3),
              HeroUiDashboardText(
                'Manage your profile, preferences, and workspace.',
                muted: true,
              ),
            ],
          ),
          _section(
            'Profile',
            'This information appears across your workspace.',
            ColumnBox(
              style: FlexBoxStyler().crossAxisAlignment(.stretch).spacing(12),
              children: [
                GridBox(
                  style: GridBoxStyler.equalColumns(2)
                      .gap(12)
                      .onConstraints(
                        const .maxWidth(559),
                        .equalColumns(1).gap(12),
                      ),
                  // Inside a card, HeroUI's fields take their `secondary`
                  // variant: the primary field fill is the card's own
                  // `surface`.
                  children: const [
                    HeroUiTextField.secondary(
                      label: 'Full name',
                      hintText: 'Ada Chen',
                    ),
                    HeroUiTextField.secondary(
                      label: 'Email address',
                      hintText: 'ada@northstar.co',
                    ),
                  ],
                ),
                HeroUiSelect<String>.secondary(
                  semanticLabel: 'Language',
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
                  child: HeroUiButton(
                    label: 'Save changes',
                    onPressed: () =>
                        heroUiDashboardToast(context, 'Profile settings saved'),
                  ),
                ),
              ],
            ),
          ),
          _section(
            'Preferences',
            'Choose which workspace activity reaches your inbox.',
            ColumnBox(
              style: FlexBoxStyler().crossAxisAlignment(.stretch).spacing(16),
              children: [
                _preference(
                  'Product updates',
                  'News about features and improvements.',
                  HeroUiSwitch(
                    selected: _productUpdates,
                    semanticLabel: 'Receive product updates',
                    onChanged: (value) =>
                        setState(() => _productUpdates = value),
                  ),
                ),
                _preference(
                  'Weekly digest',
                  'A summary of workspace activity each Monday.',
                  HeroUiCheckbox.secondary(
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
              style: FlexBoxStyler().crossAxisAlignment(.stretch).spacing(16),
              children: [
                const HeroUiAlert(
                  icon: RemixIcons.wand,
                  text:
                      'Changes are deterministic and remain local to the demo.',
                ),
                ColumnBox(
                  style: FlexBoxStyler().crossAxisAlignment(.start).spacing(8),
                  children: [
                    const HeroUiDashboardText('Color mode', emphasized: true),
                    HeroUiDashboardSegments<_Appearance>(
                      semanticLabel: 'Color mode',
                      selectedValue: _resolvedAppearance,
                      items: const [
                        (value: .light, label: 'Light'),
                        (value: .dark, label: 'Dark'),
                        (value: .system, label: 'System'),
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
                      .spacing(8),
                  children: [
                    HeroUiDashboardText(
                      'Control radius · ${_resolvedRadius(context).round()}px',
                      emphasized: true,
                    ),
                    HeroUiSlider(
                      semanticLabel: 'Control radius',
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
          HeroUiCard(
            child: HeroUiDisclosure(
              key: const ValueKey('settings-danger-zone'),
              expanded: _dangerZoneExpanded,
              onExpandedChanged: (value) =>
                  setState(() => _dangerZoneExpanded = value),
              semanticHint: 'Shows destructive workspace actions',
              trigger: HeroUiDisclosureTrigger(
                expanded: _dangerZoneExpanded,
                child: const HeroUiDashboardText(
                  'Danger zone',
                  emphasized: true,
                ),
              ),
              content: ColumnBox(
                style: FlexBoxStyler().crossAxisAlignment(.stretch).spacing(12),
                children: [
                  const HeroUiDashboardText(
                    'Destructive workspace actions cannot be undone.',
                    muted: true,
                  ),
                  Box(
                    style: BoxStyler().alignment(.centerStart),
                    child: HeroUiButton.danger(
                      label: 'Delete workspace',
                      onPressed: _confirmDelete,
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

  Future<void> _confirmDelete() async {
    final confirmed = await showRemixDialog<bool>(
      context: context,
      barrierLabel: 'Dismiss',
      barrierColor: HeroUiTokens.backdrop.resolve(context),
      builder: (dialogContext) => HeroUiModal(
        title: 'Delete workspace?',
        description:
            'This demo keeps your data safe, but a real action would be permanent.',
        actions: [
          HeroUiButton.tertiary(
            label: 'Cancel',
            onPressed: () => Navigator.of(dialogContext).pop(false),
          ),
          HeroUiButton.danger(
            label: 'Delete',
            onPressed: () => Navigator.of(dialogContext).pop(true),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    heroUiDashboardToast(context, 'Demo workspace was not deleted');
  }
}

Widget _section(String title, String description, Widget child) => HeroUiCard(
  child: ColumnBox(
    style: FlexBoxStyler().crossAxisAlignment(.stretch).spacing(16),
    children: [
      ColumnBox(
        style: FlexBoxStyler().crossAxisAlignment(.start),
        children: [HeroUiCardTitle(title), HeroUiCardDescription(description)],
      ),
      child,
    ],
  ),
);

Widget _preference(String title, String description, Widget trailing) => RowBox(
  style: FlexBoxStyler().crossAxisAlignment(.center).spacing(16),
  children: [
    Expanded(
      child: ColumnBox(
        style: FlexBoxStyler().crossAxisAlignment(.start).spacing(2),
        children: [
          HeroUiDashboardText(title, emphasized: true),
          HeroUiDashboardText(description, muted: true),
        ],
      ),
    ),
    trailing,
  ],
);

/// The disclosure's trigger row: its label and a chevron that turns over as
/// the panel opens.
class HeroUiDisclosureTrigger extends StatelessWidget {
  const HeroUiDisclosureTrigger({
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
            .animate(HeroUiTokens.smoothMotion),
        child: StyledIcon(
          icon: RemixIcons.chevronDown,
          style: IconStyler().size(16).color(HeroUiTokens.muted()),
        ),
      ),
    ],
  );
}
