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
import '../../theme/tokens.dart';

enum _Appearance { light, dark, system }

class PlaygroundDashboardSettingsPage extends StatefulWidget {
  const PlaygroundDashboardSettingsPage({
    super.key,
    this.darkMode,
    this.onDarkModeChanged,
  });

  final bool? darkMode;
  final ValueChanged<bool?>? onDarkModeChanged;

  @override
  State<PlaygroundDashboardSettingsPage> createState() =>
      _PlaygroundDashboardSettingsPageState();
}

class _PlaygroundDashboardSettingsPageState
    extends State<PlaygroundDashboardSettingsPage> {
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
    padding: const EdgeInsets.all(PlaygroundTokens.s8),
    child: Box(
      style: BoxStyler().alignment(.topStart),
      child: ColumnBox(
        style: FlexBoxStyler()
            .maxWidth(880)
            .crossAxisAlignment(.stretch)
            .spacing(PlaygroundTokens.s4),
        children: [
          ColumnBox(
            style: FlexBoxStyler()
                .crossAxisAlignment(.start)
                .spacing(PlaygroundTokens.s1),
            children: const [
              _Text(
                'Settings',
                token: PlaygroundTokens.text3xl,
                emphasized: true,
              ),
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
              style: FlexBoxStyler()
                  .crossAxisAlignment(.stretch)
                  .spacing(PlaygroundTokens.s3),
              children: [
                GridBox(
                  style: GridBoxStyler.equalColumns(2)
                      .gap(PlaygroundTokens.s3)
                      .onConstraints(
                        const .maxWidth(559),
                        .equalColumns(1).gap(PlaygroundTokens.s3),
                      ),
                  children: const [
                    PlaygroundTextField(
                      label: 'Full name',
                      hintText: 'Ada Chen',
                    ),
                    PlaygroundTextField(
                      label: 'Email address',
                      hintText: 'ada@northstar.co',
                    ),
                  ],
                ),
                PlaygroundSelect<String>(
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
                  child: PlaygroundButton(
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
              style: FlexBoxStyler()
                  .crossAxisAlignment(.stretch)
                  .spacing(PlaygroundTokens.s4),
              children: [
                _preference(
                  'Product updates',
                  'News about features and improvements.',
                  PlaygroundSwitch(
                    selected: _productUpdates,
                    semanticLabel: 'Receive product updates',
                    onChanged: (value) =>
                        setState(() => _productUpdates = value),
                  ),
                ),
                _preference(
                  'Weekly digest',
                  'A summary of workspace activity each Monday.',
                  PlaygroundCheckbox(
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
              style: FlexBoxStyler()
                  .crossAxisAlignment(.stretch)
                  .spacing(PlaygroundTokens.s4),
              children: [
                const PlaygroundCallout(
                  icon: RemixIcons.magicWand,
                  text:
                      'Changes are deterministic and remain local to the demo.',
                ),
                ColumnBox(
                  style: FlexBoxStyler()
                      .crossAxisAlignment(.start)
                      .spacing(PlaygroundTokens.s2),
                  children: [
                    const _Text('Color mode', emphasized: true),
                    PlaygroundSegmentedControl<_Appearance>(
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
                      .spacing(PlaygroundTokens.s2),
                  children: [
                    _Text(
                      'Control radius · ${_radius.round()}px',
                      emphasized: true,
                    ),
                    PlaygroundSlider(
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
          PlaygroundDisclosure(
            key: const ValueKey('settings-danger-zone'),
            semanticHint: 'Shows destructive workspace actions',
            trigger: const _Text('Danger zone', emphasized: true),
            content: ColumnBox(
              style: FlexBoxStyler()
                  .crossAxisAlignment(.stretch)
                  .spacing(PlaygroundTokens.s3),
              children: [
                const _Text('Destructive workspace actions cannot be undone.'),
                Box(
                  style: BoxStyler().alignment(.centerStart),
                  child: PlaygroundButton.destructive(
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
      builder: (dialogContext) => PlaygroundDialog(
        title: 'Delete workspace?',
        description:
            'This demo keeps your data safe, but a real action would be permanent.',
        actions: [
          PlaygroundButton.secondary(
            label: 'Cancel',
            onPressed: () => Navigator.of(dialogContext).pop(false),
          ),
          PlaygroundButton.destructive(
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

Widget _section(String title, String description, Widget child) =>
    PlaygroundCard(
      child: ColumnBox(
        style: FlexBoxStyler()
            .crossAxisAlignment(.stretch)
            .spacing(PlaygroundTokens.s4),
        children: [
          ColumnBox(
            style: FlexBoxStyler()
                .crossAxisAlignment(.start)
                .spacing(PlaygroundTokens.s1),
            children: [
              _Text(title, token: PlaygroundTokens.textLg, emphasized: true),
              _Text(description, muted: true),
            ],
          ),
          child,
        ],
      ),
    );

Widget _preference(String title, String description, Widget trailing) => RowBox(
  style: FlexBoxStyler()
      .crossAxisAlignment(.center)
      .spacing(PlaygroundTokens.s4),
  children: [
    Expanded(
      child: ColumnBox(
        style: FlexBoxStyler()
            .crossAxisAlignment(.start)
            .spacing(PlaygroundTokens.s0_5),
        children: [
          _Text(title, emphasized: true),
          _Text(description, muted: true),
        ],
      ),
    ),
    trailing,
  ],
);

class _Text extends StatelessWidget {
  const _Text(
    this.value, {
    this.token = PlaygroundTokens.textSm,
    this.emphasized = false,
    this.muted = false,
  });
  final String value;
  final TextStyleToken token;
  final bool emphasized;
  final bool muted;

  @override
  Widget build(BuildContext context) => StyledText(
    value,
    style: TextStyler()
        .style(token.mix())
        .fontWeight(emphasized ? FontWeight.w600 : FontWeight.w400)
        .color(
          muted
              ? PlaygroundTokens.mutedForeground()
              : PlaygroundTokens.foreground(),
        ),
  );
}

void _toast(BuildContext context, String title) => showRemixToast(
  context,
  RemixToastData(title: title, icon: RemixIcons.checkCircled),
);
