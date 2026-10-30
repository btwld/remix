import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_fonts/remix_ui_fonts.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import 'ui/ui.dart';

/// Runs the HeroUI review gallery, composed entirely from installed source.
void main() => runApp(const AcmeApp());

const _light = AcmeThemeData.light(fontFamily: RemixFonts.geist);
const _dark = AcmeThemeData.dark(fontFamily: RemixFonts.geist);

/// The consumer shell: theme and toast host above the navigator, so dialogs,
/// popovers, and toasts all resolve the installed tokens.
class AcmeApp extends StatefulWidget {
  /// Creates the gallery application.
  const AcmeApp({super.key});

  @override
  State<AcmeApp> createState() => _AcmeAppState();
}

class _AcmeAppState extends State<AcmeApp> {
  final _mode = ValueNotifier(AcmeThemeMode.light);

  @override
  void dispose() {
    _mode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      title: 'HeroUI on Remix',
      color: const Color(0xFFFFFFFF),
      debugShowCheckedModeBanner: false,
      pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) =>
            builder(context),
      ),
      builder: (context, child) => ValueListenableBuilder<AcmeThemeMode>(
        valueListenable: _mode,
        child: child,
        builder: (context, mode, child) => AcmeTheme(
          theme: _light,
          darkTheme: _dark,
          mode: mode,
          child: Overlay.wrap(
            child: RemixToastScope(style: acmeToastStyle(), child: child!),
          ),
        ),
      ),
      home: Gallery(mode: _mode),
    );
  }
}

void _noop() {}

String _colorLabel(AcmeColor color) => switch (color) {
  AcmeColor.defaultColor => 'Default',
  _ => color.name[0].toUpperCase() + color.name.substring(1),
};

typedef _Person = ({String id, String name, String role});

const _people = <_Person>[
  (id: '1', name: 'Ada Lovelace', role: 'Engineer'),
  (id: '2', name: 'Grace Hopper', role: 'Admiral'),
  (id: '3', name: 'Alan Turing', role: 'Researcher'),
  (id: '4', name: 'Margaret Hamilton', role: 'Director'),
];

const _faq = <(String, String, String)>[
  (
    'copy',
    'Is the source mine?',
    'Yes. The recipes are installed into your app and you edit them there.',
  ),
  (
    'remix',
    'Who owns behavior?',
    'Remix and Naked UI. The preset only decides how things look.',
  ),
];

/// A compact review gallery of every installed HeroUI component.
class Gallery extends StatefulWidget {
  /// Creates the gallery; [mode] drives the header toggle.
  const Gallery({super.key, required this.mode});

  /// The app's theme mode, switched by the header toggle.
  final ValueNotifier<AcmeThemeMode> mode;

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  final _search = TextEditingController();
  final _popover = MenuController();
  final _defaultAccordion = RemixAccordionController<String>();
  final _surfaceAccordion = RemixAccordionController<String>();

  var _presses = 0;
  var _accepted = true;
  var _subscribed = false;
  var _toppings = <String>{'cheese'};
  String? _plan = 'pro';
  var _notify = true;
  var _autosave = false;
  var _bold = true;
  var _italic = false;
  String? _align = 'left';
  var _volume = 0.4;
  var _tab = 'overview';
  String? _fruit;
  var _lastAction = 'none';
  var _selectedRows = <Object>{};
  var _sort = const RemixDataTableSort(
    columnId: 'name',
    direction: RemixDataTableSortDirection.ascending,
  );

  @override
  void dispose() {
    _search.dispose();
    _defaultAccordion.dispose();
    _surfaceAccordion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 900;
        final padding = wide ? 24.0 : 16.0;
        return SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 24,
                children: [
                  _header(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 16,
                    children: [
                      for (final column in _columns(wide ? 2 : 1))
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            spacing: 16,
                            children: column,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _header() {
    return Row(
      spacing: 16,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AcmeTypography('HeroUI on Remix', type: .h3),
              AcmeTypography(
                'Installed source, light and dark',
                type: .bodySm,
                color: .muted,
              ),
            ],
          ),
        ),
        const AcmeTypography('Dark mode', type: .bodySm, color: .muted),
        ValueListenableBuilder<AcmeThemeMode>(
          valueListenable: widget.mode,
          builder: (context, mode, _) => AcmeSwitch(
            selected: mode == AcmeThemeMode.dark,
            semanticLabel: 'Dark mode',
            onChanged: (dark) => widget.mode.value = dark
                ? AcmeThemeMode.dark
                : AcmeThemeMode.light,
          ),
        ),
      ],
    );
  }

  /// Spreads the sections over [count] columns, always filling the shortest.
  List<List<Widget>> _columns(int count) {
    final columns = [for (var i = 0; i < count; i++) <Widget>[]];
    final heights = List.filled(count, 0.0);
    for (final (weight, section) in _sections()) {
      final shortest = heights.indexOf(heights.reduce((a, b) => a < b ? a : b));
      columns[shortest].add(section);
      heights[shortest] += weight;
    }
    return columns;
  }

  /// Each section with a rough height, used only to balance the columns.
  List<(double, Widget)> _sections() => [
    (300, _buttons()),
    (480, _textInputs()),
    (260, _chipsAndBadges()),
    (260, _avatars()),
    (190, _inline()),
    (440, _surfaceAndCard()),
    (400, _typography()),
    (220, _feedback()),
    (520, _selection()),
    (260, _toggles()),
    (180, _tabs()),
    (340, _overlays()),
    (360, _accordions()),
    (300, _toastsAndAlerts()),
    (330, _table()),
  ];

  Widget _card(String title, List<Widget> children) {
    return AcmeCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [AcmeCardTitle(title), ...children],
      ),
    );
  }

  Widget _row(List<Widget> children) => Wrap(
    spacing: 8,
    runSpacing: 8,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: children,
  );

  Widget _caption(String text) =>
      AcmeTypography(text, type: .bodyXs, color: .muted);

  Widget _buttons() {
    return _card('Buttons', [
      _row([
        AcmeButton.primary(
          label: 'Count $_presses',
          onPressed: () => setState(() => _presses++),
        ),
        const AcmeButton.secondary(label: 'Secondary', onPressed: _noop),
        const AcmeButton.tertiary(label: 'Tertiary', onPressed: _noop),
        const AcmeButton.outline(label: 'Outline', onPressed: _noop),
        const AcmeButton.ghost(label: 'Ghost', onPressed: _noop),
        const AcmeButton.danger(label: 'Danger', onPressed: _noop),
        const AcmeButton.dangerSoft(label: 'Danger soft', onPressed: _noop),
      ]),
      _caption('States, icons, and close button'),
      _row([
        const AcmeButton(label: 'Loading', loading: true, onPressed: _noop),
        const AcmeButton(label: 'Disabled', enabled: false),
        const AcmeButton(
          label: 'Add',
          leadingIcon: RemixIcons.plus,
          onPressed: _noop,
        ),
        const AcmeIconButton.secondary(
          icon: RemixIcons.heart,
          semanticLabel: 'Like',
          onPressed: _noop,
        ),
        const AcmeCloseButton(onPressed: _noop),
      ]),
      _caption('Button group'),
      _row([
        for (final variant in [
          AcmeButtonVariant.primary,
          AcmeButtonVariant.outline,
        ])
          AcmeButtonGroup(
            variant: variant,
            buttons: [
              for (final label in ['Day', 'Week', 'Month'])
                (context, style) =>
                    RemixButton(label: label, style: style, onPressed: _noop),
            ],
          ),
      ]),
    ]);
  }

  Widget _chipsAndBadges() {
    return _card('Chip and badge', [
      _row([
        const AcmeChip.primary(label: 'Primary'),
        const AcmeChip.secondary(label: 'Secondary'),
        const AcmeChip.soft(label: 'Soft'),
        const AcmeChip.tertiary(label: 'Tertiary'),
      ]),
      _row([
        for (final color in AcmeColor.values)
          AcmeChip.soft(label: _colorLabel(color), color: color),
      ]),
      _caption('Badge on an avatar'),
      _row([
        for (final (variant, color) in const [
          (AcmeBadgeVariant.primary, AcmeColor.danger),
          (AcmeBadgeVariant.secondary, AcmeColor.defaultColor),
          (AcmeBadgeVariant.soft, AcmeColor.success),
        ])
          Padding(
            padding: const EdgeInsets.only(right: 8, top: 8),
            child: AcmeBadge(
              variant: variant,
              color: color,
              size: .sm,
              label: '3',
              child: const AcmeAvatar(label: 'AB'),
            ),
          ),
        const Padding(
          padding: EdgeInsets.only(right: 8, top: 8),
          child: AcmeBadge(
            color: AcmeColor.success,
            size: .sm,
            child: AcmeAvatar(label: 'CD'),
          ),
        ),
      ]),
    ]);
  }

  Widget _avatars() {
    return _card('Avatar', [
      _row([
        const AcmeAvatar.defaultAvatar(label: 'AB'),
        for (final (index, color) in AcmeColor.values.indexed)
          AcmeAvatar.soft(label: 'ABCDE'[index], color: color),
      ]),
      _caption('Groups'),
      const AcmeAvatarGroup(
        children: [
          AcmeAvatar.soft(label: 'AB', color: AcmeColor.accent),
          AcmeAvatar.soft(label: 'CD', color: AcmeColor.success),
          AcmeAvatar.soft(label: 'EF', color: AcmeColor.warning),
          AcmeAvatar.soft(label: '+3'),
        ],
      ),
      const AcmeAvatarGroup(
        overlap: .ring,
        children: [
          AcmeAvatar.soft(label: 'AB', color: AcmeColor.accent),
          AcmeAvatar.soft(label: 'CD', color: AcmeColor.danger),
          AcmeAvatar.soft(label: '+3'),
        ],
      ),
    ]);
  }

  Widget _inline() {
    return _card('Kbd, link, breadcrumbs, separator', [
      _row([
        const AcmeKbd(keys: ['Ctrl', 'K']),
        const AcmeKbd(keys: ['Shift', 'Enter'], variant: .light),
        const AcmeLink(label: 'Read the docs', onPressed: _noop),
      ]),
      const AcmeBreadcrumbs(
        items: [
          AcmeBreadcrumb('Home', onPressed: _noop),
          AcmeBreadcrumb('Components', onPressed: _noop),
          AcmeBreadcrumb('Gallery'),
        ],
      ),
      const AcmeSeparator(),
      const AcmeSeparator.secondary(),
      const AcmeSeparator.tertiary(),
      const SizedBox(
        height: 20,
        child: Row(
          spacing: 12,
          children: [
            AcmeTypography('Docs', type: .bodySm),
            AcmeSeparator(orientation: Axis.vertical),
            AcmeTypography('Source', type: .bodySm),
            AcmeSeparator(orientation: Axis.vertical),
            AcmeTypography('Releases', type: .bodySm),
          ],
        ),
      ),
    ]);
  }

  Widget _surfaceAndCard() {
    const padded = BoxStyler.create();
    return _card('Surface and card', [
      _row([
        for (final variant in AcmeSurfaceVariant.values)
          AcmeSurface(
            variant: variant,
            style: padded
                .padding(.all(12))
                .borderRadius(.circular(16))
                .border(.all(.color(const Color(0x1F808080)))),
            child: AcmeTypography(
              variant == AcmeSurfaceVariant.defaultSurface
                  ? 'default'
                  : variant.name,
              type: .bodySm,
            ),
          ),
      ]),
      AcmeCard.secondary(child: _cardBody('Secondary card')),
      AcmeCard.tertiary(child: _cardBody('Tertiary card')),
      AcmeCard.transparent(child: _cardBody('Transparent card')),
    ]);
  }

  Widget _cardBody(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        AcmeCardTitle(title),
        const AcmeCardDescription('A card groups related content.'),
      ],
    );
  }

  Widget _typography() {
    return _card('Typography', [
      for (final type in AcmeTypographyType.values)
        AcmeTypography(
          type == AcmeTypographyType.code ? 'flutter run' : type.name,
          type: type,
          color: type == AcmeTypographyType.bodyXs
              ? AcmeTypographyColor.muted
              : AcmeTypographyColor.defaultColor,
        ),
    ]);
  }

  Widget _feedback() {
    return _card('Spinner, skeleton, progress', [
      _row([
        for (final color in AcmeSpinnerColor.values)
          AcmeSpinner(color: color, semanticsLabel: 'Loading ${color.name}'),
      ]),
      Row(
        spacing: 12,
        children: [
          AcmeSkeleton(
            style: SkeletonStyler().container(
              BoxStyler().borderRadius(.circular(20)),
            ),
            child: const SizedBox.square(dimension: 40),
          ),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                AcmeSkeleton(child: SizedBox(width: 160, height: 12)),
                AcmeSkeleton(child: SizedBox(width: 100, height: 12)),
              ],
            ),
          ),
        ],
      ),
      const AcmeProgress(value: 0.35, semanticsLabel: 'Upload'),
      const AcmeProgress(value: 0.6, color: .success, semanticsLabel: 'Sync'),
      const AcmeProgress(
        value: 0.8,
        color: .warning,
        semanticsLabel: 'Storage',
      ),
      const AcmeProgress(value: 0.5, color: .danger, semanticsLabel: 'Errors'),
    ]);
  }

  Widget _textInputs() {
    return _card('Text inputs', [
      const AcmeTextField(
        label: 'Email',
        hintText: 'you@example.com',
        helperText: 'We will never share it.',
      ),
      const AcmeTextField(
        variant: .secondary,
        label: 'Display name',
        hintText: 'Ada Lovelace',
      ),
      const AcmeTextField(
        label: 'Password',
        hintText: 'At least 8 characters',
        helperText: 'Password is too short.',
        error: true,
        obscureText: true,
      ),
      const AcmeTextField(
        label: 'Disabled',
        hintText: 'Unavailable',
        enabled: false,
      ),
      const AcmeTextArea(label: 'Notes', hintText: 'Write something'),
      AcmeSearchField(
        controller: _search,
        hintText: 'Search components',
        semanticLabel: 'Search components',
        leading: const AcmeSearchIcon(),
        trailing: ListenableBuilder(
          listenable: _search,
          builder: (context, _) => _search.text.isEmpty
              ? const SizedBox.shrink()
              : AcmeSearchClearButton(onPressed: _search.clear),
        ),
      ),
      const AcmeInputGroup(
        label: 'Website',
        hintText: 'example',
        leading: Text('https://'),
        trailing: Text('.com'),
      ),
    ]);
  }

  Widget _selection() {
    return _card('Checkbox, radio, switch', [
      _row([
        AcmeCheckbox(
          selected: _accepted,
          label: 'Accept terms',
          onChanged: (value) => setState(() => _accepted = value ?? false),
        ),
        AcmeCheckbox(
          variant: .secondary,
          selected: _subscribed,
          label: 'Subscribe',
          onChanged: (value) => setState(() => _subscribed = value ?? false),
        ),
      ]),
      AcmeCheckboxGroup<String>(
        label: 'Toppings',
        helperText: 'Pick as many as you like.',
        values: _toppings,
        onChanged: (values) => setState(() => _toppings = values),
        options: const [
          AcmeCheckboxOption(value: 'cheese', label: 'Cheese'),
          AcmeCheckboxOption(value: 'olives', label: 'Olives'),
          AcmeCheckboxOption(value: 'basil', label: 'Basil', enabled: false),
        ],
      ),
      AcmeRadioGroup<String>(
        label: 'Plan',
        groupValue: _plan,
        onChanged: (value) => setState(() => _plan = value),
        options: const [
          AcmeRadioOption(
            value: 'free',
            label: 'Free',
            description: 'For side projects.',
          ),
          AcmeRadioOption(
            value: 'pro',
            label: 'Pro',
            description: 'For growing teams.',
          ),
        ],
      ),
      AcmeSwitchGroup(
        label: 'Notifications',
        items: [
          AcmeSwitchOption(
            selected: _notify,
            label: 'Email me',
            description: 'Product news and receipts.',
            onChanged: (value) => setState(() => _notify = value),
          ),
          AcmeSwitchOption(
            selected: _autosave,
            label: 'Autosave drafts',
            onChanged: (value) => setState(() => _autosave = value),
          ),
        ],
      ),
    ]);
  }

  Widget _toggles() {
    return _card('Toggle button and slider', [
      _row([
        AcmeToggleButton(
          selected: _bold,
          label: 'Bold',
          icon: RemixIcons.fontBold,
          onChanged: (value) => setState(() => _bold = value),
        ),
        AcmeToggleButton(
          variant: .ghost,
          selected: _italic,
          label: 'Italic',
          icon: RemixIcons.fontItalic,
          onChanged: (value) => setState(() => _italic = value),
        ),
      ]),
      for (final variant in AcmeToggleButtonVariant.values)
        AcmeToggleButtonGroup<String>(
          variant: variant,
          selectedValue: _align,
          semanticLabel: 'Alignment ${variant.name}',
          onChanged: (value) => setState(() => _align = value),
          items: const [
            RemixToggleGroupItem(value: 'left', label: 'Left'),
            RemixToggleGroupItem(value: 'center', label: 'Center'),
            RemixToggleGroupItem(value: 'right', label: 'Right'),
          ],
        ),
      _caption('Volume ${(_volume * 100).round()}%'),
      AcmeSlider(
        value: _volume,
        semanticLabel: 'Volume',
        onChanged: (value) => setState(() => _volume = value),
      ),
    ]);
  }

  Widget _tabs() {
    return _card('Tabs', [
      for (final variant in AcmeTabsVariant.values)
        RemixTabs(
          selectedTabId: _tab,
          onChanged: (id) => setState(() => _tab = id),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AcmeTabBar(
                variant: variant,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final (id, label) in const [
                      ('overview', 'Overview'),
                      ('usage', 'Usage'),
                      ('api', 'API'),
                    ])
                      AcmeTab(variant: variant, tabId: id, label: label),
                  ],
                ),
              ),
              if (variant == AcmeTabsVariant.primary)
                for (final id in const ['overview', 'usage', 'api'])
                  AcmeTabView(
                    tabId: id,
                    child: AcmeTypography(
                      'Panel: $id',
                      type: .bodySm,
                      color: .muted,
                    ),
                  ),
            ],
          ),
        ),
    ]);
  }

  Widget _overlays() {
    return _card('Select, dropdown, popover, tooltip, modal', [
      for (final variant in AcmeSelectVariant.values)
        AcmeSelect<String>(
          variant: variant,
          semanticLabel: 'Fruit ${variant.name}',
          trigger: const RemixSelectTrigger(placeholder: 'Choose a fruit'),
          selectedValue: _fruit,
          onChanged: (value) => setState(() => _fruit = value),
          items: const [
            RemixSelectItem(value: 'apple', label: 'Apple'),
            RemixSelectItem(value: 'banana', label: 'Banana'),
            RemixSelectItem(value: 'cherry', label: 'Cherry'),
          ],
        ),
      _row([
        AcmeDropdown<String>(
          semanticLabel: 'Actions',
          trigger: const RemixMenuTrigger(label: 'Actions'),
          onSelected: (value) => setState(() => _lastAction = value),
          items: [
            const RemixMenuItem(
              value: 'edit',
              label: 'Edit',
              leadingIcon: RemixIcons.pencil1,
            ),
            const RemixMenuItem(
              value: 'copy',
              label: 'Duplicate',
              leadingIcon: RemixIcons.copy,
            ),
            const RemixMenuDivider(),
            RemixMenuItem(
              value: 'delete',
              label: 'Delete',
              leadingIcon: RemixIcons.trash,
              style: acmeDropdownItemStyle(variant: .danger),
            ),
          ],
        ),
        AcmeTypography(
          'Last action: $_lastAction',
          type: .bodySm,
          color: .muted,
        ),
      ]),
      _row([
        AcmePopover(
          controller: _popover,
          openOnTap: false,
          popoverChild: SizedBox(
            width: 220,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                const AcmeTypography(
                  'Share project',
                  type: .bodySm,
                  weight: .medium,
                ),
                const AcmeTypography(
                  'Anyone with the link can view.',
                  type: .bodySm,
                  color: .muted,
                ),
                AcmeButton.primary(
                  label: 'Copy link',
                  onPressed: _popover.close,
                ),
              ],
            ),
          ),
          child: AcmeButton.secondary(
            label: 'Open popover',
            onPressed: _popover.open,
          ),
        ),
        const AcmeTooltip(
          tooltipChild: Text('Tooltips follow hover and focus'),
          child: AcmeButton.tertiary(label: 'Hover me', onPressed: _noop),
        ),
        AcmeButton.outline(label: 'Open modal', onPressed: _openModal),
      ]),
    ]);
  }

  void _openModal() {
    showRemixDialog<void>(
      context: context,
      barrierLabel: 'Dismiss',
      barrierColor: AcmeTokens.backdrop.resolve(context),
      builder: (dialogContext) => AcmeModal(
        title: 'Delete project?',
        description: 'This permanently removes the project and its data.',
        actions: [
          AcmeButton.tertiary(
            label: 'Cancel',
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
          AcmeButton.danger(
            label: 'Delete',
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
        ],
      ),
    );
  }

  Widget _accordions() {
    Widget group(
      AcmeAccordionVariant variant,
      RemixAccordionController<String> controller,
    ) {
      return AcmeAccordionGroup<String>(
        variant: variant,
        controller: controller,
        initialExpandedValues: const ['copy'],
        child: Column(
          children: [
            for (final (value, title, body) in _faq)
              AcmeAccordion<String>(
                variant: variant,
                value: value,
                title: title,
                trailingIcon: RemixIcons.chevronDown,
                child: Text(body),
              ),
          ],
        ),
      );
    }

    return _card('Accordion and disclosure', [
      group(AcmeAccordionVariant.defaultAccordion, _defaultAccordion),
      group(AcmeAccordionVariant.surface, _surfaceAccordion),
      const AcmeDisclosure(
        trigger: AcmeTypography('Show details', type: .bodySm, weight: .medium),
        content: AcmeTypography(
          'Disclosures expand a single panel in place.',
          type: .bodySm,
          color: .muted,
        ),
      ),
    ]);
  }

  Widget _toastsAndAlerts() {
    return _card('Toast and alert', [
      AcmeButton.secondary(
        label: 'Show toast',
        onPressed: () => showRemixToast(
          context,
          RemixToastData(
            title: 'Draft saved',
            description: 'Your changes are stored locally.',
            icon: RemixIcons.checkCircled,
            style: acmeToastStyle(variant: .success),
          ),
        ),
      ),
      const AcmeToast(title: 'Default toast', description: 'Plain overlay.'),
      const AcmeToast(
        variant: .accent,
        title: 'Accent toast',
        icon: RemixIcons.infoCircled,
      ),
      const AcmeToast(
        variant: .success,
        title: 'Success toast',
        icon: RemixIcons.checkCircled,
      ),
      const AcmeToast(
        variant: .warning,
        title: 'Warning toast',
        icon: RemixIcons.exclamationTriangle,
      ),
      const AcmeToast(
        variant: .danger,
        title: 'Danger toast',
        icon: RemixIcons.crossCircled,
      ),
      const AcmeAlert(text: 'Default alert', icon: RemixIcons.infoCircled),
      const AcmeAlert(
        status: .accent,
        text: 'Accent alert',
        icon: RemixIcons.infoCircled,
      ),
      const AcmeAlert(
        status: .success,
        text: 'Success alert',
        icon: RemixIcons.checkCircled,
      ),
      const AcmeAlert(
        status: .warning,
        text: 'Warning alert',
        icon: RemixIcons.exclamationTriangle,
      ),
      const AcmeAlert(
        status: .danger,
        text: 'Danger alert',
        icon: RemixIcons.crossCircled,
      ),
    ]);
  }

  List<_Person> get _sortedPeople {
    String field(_Person person) => switch (_sort.columnId) {
      'role' => person.role,
      _ => person.name,
    };
    final people = [..._people]..sort((a, b) => field(a).compareTo(field(b)));
    return _sort.direction == RemixDataTableSortDirection.ascending
        ? people
        : people.reversed.toList();
  }

  Widget _table() {
    return _card('Table', [
      for (final variant in AcmeTableVariant.values)
        AcmeTable<_Person>(
          variant: variant,
          semanticLabel: 'People ${variant.name}',
          rows: _sortedPeople,
          rowId: (person) => person.id,
          selectedRowIds: _selectedRows,
          onSelectionChanged: (ids) => setState(() => _selectedRows = ids),
          sort: _sort,
          onSortChanged: (sort) => setState(() => _sort = sort),
          columns: [
            RemixDataTableColumn<_Person>(
              id: 'name',
              label: 'Name',
              sortable: true,
              cellBuilder: (context, person) => Text(person.name),
            ),
            RemixDataTableColumn<_Person>(
              id: 'role',
              label: 'Role',
              sortable: true,
              cellBuilder: (context, person) => Text(person.role),
            ),
          ],
        ),
    ]);
  }
}
