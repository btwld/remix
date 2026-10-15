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
import '../../components/text.dart';
import '../../components/typography.dart';

enum _Appearance { light, dark, system }

class FortalDashboardSettingsPage extends StatefulWidget {
  const FortalDashboardSettingsPage({
    super.key,
    this.darkMode,
    this.onDarkModeChanged,
  });

  final bool? darkMode;
  final ValueChanged<bool?>? onDarkModeChanged;

  @override
  State<FortalDashboardSettingsPage> createState() =>
      _FortalDashboardSettingsPageState();
}

class _FortalDashboardSettingsPageState
    extends State<FortalDashboardSettingsPage> {
  bool _productUpdates = true;
  bool _weeklyDigest = false;
  String _language = 'en';
  _Appearance _appearance = .system;
  double _radius = 8;

  _Appearance get _resolvedAppearance => widget.onDarkModeChanged == null
      ? _appearance
      : switch (widget.darkMode) {
          false => .light,
          true => .dark,
          null => .system,
        };

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(32),
    child: ColumnBox(
      style: FlexBoxStyler().crossAxisAlignment(.stretch).spacing(16),
      children: [
        ColumnBox(
          style: FlexBoxStyler().crossAxisAlignment(.start).spacing(4),
          children: const [
            _Text('Settings', size: 28, emphasized: true),
            _Text(
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
              const FortalTextField(label: 'Full name', hintText: 'Ada Chen'),
              const FortalTextField(
                label: 'Email address',
                hintText: 'ada@northstar.co',
              ),
              FortalSelect<String>(
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
              Align(
                alignment: Alignment.centerLeft,
                child: FortalButton(
                  label: 'Save changes',
                  onPressed: () => _toast(context, 'Profile settings saved'),
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
                FortalSwitch(
                  selected: _productUpdates,
                  semanticLabel: 'Receive product updates',
                  onChanged: (value) => setState(() => _productUpdates = value),
                ),
              ),
              _preference(
                'Weekly digest',
                'A summary of workspace activity each Monday.',
                FortalCheckbox(
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
          'Tune the default preset theme with meaningful native values.',
          ColumnBox(
            style: FlexBoxStyler().crossAxisAlignment(.stretch).spacing(16),
            children: [
              const FortalCallout(
                icon: RemixIcons.magicWand,
                text: 'Changes are deterministic and remain local to the demo.',
              ),
              ColumnBox(
                style: FlexBoxStyler().crossAxisAlignment(.start).spacing(8),
                children: [
                  const _Text('Color mode', emphasized: true),
                  FortalSegmentedControl<_Appearance>(
                    semanticLabel: 'Color mode',
                    selectedValue: _resolvedAppearance,
                    items: const [
                      RemixSegmentedControlItem(value: .light, label: 'Light'),
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
                style: FlexBoxStyler().crossAxisAlignment(.stretch).spacing(8),
                children: [
                  _Text(
                    'Control radius · ${_radius.round()}px',
                    emphasized: true,
                  ),
                  FortalSlider(
                    value: _radius,
                    min: 0,
                    max: 16,
                    snapDivisions: 16,
                    onChanged: (value) => setState(() => _radius = value),
                  ),
                ],
              ),
            ],
          ),
        ),
        FortalDisclosure(
          key: const ValueKey('settings-danger-zone'),
          semanticHint: 'Shows destructive workspace actions',
          trigger: const _Text('Danger zone', emphasized: true),
          content: ColumnBox(
            style: FlexBoxStyler().crossAxisAlignment(.stretch).spacing(12),
            children: [
              const _Text('Destructive workspace actions cannot be undone.'),
              Align(
                alignment: Alignment.centerLeft,
                child: FortalButton.outline(
                  label: 'Delete workspace',
                  onPressed: _confirmDelete,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Future<void> _confirmDelete() async {
    final confirmed = await showRemixDialog<bool>(
      context: context,
      barrierLabel: 'Dismiss',
      builder: (dialogContext) => FortalDialog(
        title: 'Delete workspace?',
        description:
            'This demo keeps your data safe, but a real action would be permanent.',
        actions: [
          FortalButton.soft(
            label: 'Cancel',
            onPressed: () => Navigator.of(dialogContext).pop(false),
          ),
          FortalButton.solid(
            label: 'Delete',
            onPressed: () => Navigator.of(dialogContext).pop(true),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    _toast(context, 'Demo workspace was not deleted');
  }
}

Widget _section(String title, String description, Widget child) => FortalCard(
  child: ColumnBox(
    style: FlexBoxStyler().crossAxisAlignment(.stretch).spacing(16),
    children: [
      ColumnBox(
        style: FlexBoxStyler().crossAxisAlignment(.start).spacing(4),
        children: [
          _Text(title, size: 17, emphasized: true),
          _Text(description, size: 13, muted: true),
        ],
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
          _Text(title, emphasized: true),
          _Text(description, size: 13, muted: true),
        ],
      ),
    ),
    trailing,
  ],
);

class _Text extends StatelessWidget {
  const _Text(
    this.value, {
    this.size = 14,
    this.emphasized = false,
    this.muted = false,
  });
  final String value;
  final double size;
  final bool emphasized;
  final bool muted;

  @override
  Widget build(BuildContext context) => FortalText(
    value,
    size: size >= 24
        ? FortalTextSize.size7
        : size >= 18
        ? FortalTextSize.size4
        : FortalTextSize.size2,
    weight: emphasized ? .bold : .regular,
    highContrast: !muted,
  );
}

void _toast(BuildContext context, String title) => showRemixToast(
  context,
  RemixToastData(title: title, icon: RemixIcons.checkCircled),
);
