import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../components/accordion.dart';
import '../../components/app_bar.dart';
import '../../components/avatar.dart';
import '../../components/badge.dart';
import '../../components/button.dart';
import '../../components/callout.dart';
import '../../components/card.dart';
import '../../components/checkbox.dart';
import '../../components/data_list.dart';
import '../../components/dialog.dart';
import '../../components/disclosure.dart';
import '../../components/divider.dart';
import '../../components/icon_button.dart';
import '../../components/link.dart';
import '../../components/menu.dart';
import '../../components/popover.dart';
import '../../components/progress.dart';
import '../../components/radio.dart';
import '../../components/segmented_control.dart';
import '../../components/select.dart';
import '../../components/sidebar.dart';
import '../../components/skeleton.dart';
import '../../components/slider.dart';
import '../../components/spinner.dart';
import '../../components/switch.dart';
import '../../components/tabs.dart';
import '../../components/textfield.dart';
import '../../components/toggle.dart';
import '../../components/toggle_group.dart';
import '../../components/tooltip.dart';
import '../../theme/tokens.dart';

class DefaultGalleryPage extends StatelessWidget {
  const DefaultGalleryPage({
    super.key,
    required this.title,
    required this.intro,
    required this.sections,
  });

  final String title;
  final String intro;
  final List<Widget> sections;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(VanillaTokens.s8),
    child: ColumnBox(
      style: FlexBoxStyler()
          .crossAxisAlignment(.stretch)
          .spacing(VanillaTokens.s5),
      children: [
        ColumnBox(
          style: FlexBoxStyler()
              .crossAxisAlignment(.start)
              .spacing(VanillaTokens.s1_5),
          children: [
            _Heading(
              title,
              token: VanillaTokens.text3xl,
              weight: FontWeight.w700,
            ),
            _Text(intro, muted: true),
          ],
        ),
        ...sections,
      ],
    ),
  );
}

class _Section extends StatelessWidget {
  const _Section({
    required this.label,
    required this.description,
    required this.child,
  });

  final String label;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) => VanillaCard(
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
            _Heading(
              label,
              token: VanillaTokens.textLg,
              weight: FontWeight.w600,
            ),
            _Text(description, muted: true),
          ],
        ),
        child,
      ],
    ),
  );
}

class _Matrix<R, C> extends StatelessWidget {
  const _Matrix({
    required this.rows,
    required this.columns,
    required this.rowLabel,
    required this.columnLabel,
    required this.cell,
    this.cellWidth = 190,
  });

  final List<R> rows;
  final List<C> columns;
  final String Function(R) rowLabel;
  final String Function(C) columnLabel;
  final Widget Function(R, C) cell;
  final double cellWidth;

  @override
  Widget build(BuildContext context) {
    final divider = BorderSideMix(
      color: VanillaTokens.border(),
      width: VanillaTokens.strokeHairline,
    );
    final borderRadius = BorderRadiusMix.all(VanillaTokens.radiusMd());
    final GridBoxStyler gridStyle = .columns([
      const .fixed(112),
      for (final _ in columns) .fixed(cellWidth),
    ]);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Box(
        style: BoxStyler()
            .borderRadius(borderRadius)
            .clipBehavior(.antiAlias)
            .foregroundDecoration(
              BoxDecorationMix(
                border: BoxBorderMix.all(divider),
                borderRadius: borderRadius,
              ),
            ),
        child: GridBox(
          style: gridStyle,
          children: [
            _MatrixCell(
              divider: divider,
              alignment: Alignment.centerLeft,
              child: const _Text('', muted: true),
            ),
            for (final column in columns)
              _MatrixCell(
                divider: divider,
                hasLeadingDivider: true,
                child: _Text(columnLabel(column), muted: true),
              ),
            for (final row in rows) ...[
              _MatrixCell(
                divider: divider,
                hasTopDivider: true,
                alignment: Alignment.centerLeft,
                child: _Text(rowLabel(row), muted: true),
              ),
              for (final column in columns)
                _MatrixCell(
                  divider: divider,
                  hasLeadingDivider: true,
                  hasTopDivider: true,
                  child: cell(row, column),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MatrixCell extends StatelessWidget {
  const _MatrixCell({
    required this.child,
    required this.divider,
    this.hasLeadingDivider = false,
    this.hasTopDivider = false,
    this.alignment = Alignment.center,
  });

  final Widget child;
  final BorderSideMix divider;
  final bool hasLeadingDivider;
  final bool hasTopDivider;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    var style = BoxStyler()
        .minHeight(64)
        .padding(.all(VanillaTokens.s2_5))
        .alignment(alignment);
    if (hasLeadingDivider || hasTopDivider) {
      style = style.foregroundDecoration(
        BoxDecorationMix(
          border: BorderMix(
            left: hasLeadingDivider ? divider : null,
            top: hasTopDivider ? divider : null,
          ),
        ),
      );
    }

    return Box(style: style, child: child);
  }
}

class DefaultGalleryActionsPage extends StatefulWidget {
  const DefaultGalleryActionsPage({super.key});

  @override
  State<DefaultGalleryActionsPage> createState() =>
      _DefaultGalleryActionsPageState();
}

class _DefaultGalleryActionsPageState extends State<DefaultGalleryActionsPage> {
  bool _selected = true;

  @override
  Widget build(BuildContext context) => DefaultGalleryPage(
    title: 'Actions',
    intro: 'Interactive actions across every native variant and size.',
    sections: [
      _Section(
        label: 'Button',
        description:
            'Primary, secondary, outline, ghost, and destructive actions.',
        child: _Matrix(
          rows: VanillaButtonVariant.values,
          columns: VanillaButtonSize.values,
          rowLabel: _enumLabel,
          columnLabel: _enumLabel,
          cell: (variant, size) => VanillaButton(
            variant: variant,
            size: size,
            onPressed: () => _toast(context, 'Button pressed'),
            label: 'Button',
          ),
        ),
      ),
      _Section(
        label: 'Icon button',
        description:
            'Compact icon-only controls with complete focus semantics.',
        child: _Matrix(
          rows: VanillaIconButtonVariant.values,
          columns: VanillaIconButtonSize.values,
          rowLabel: _enumLabel,
          columnLabel: _enumLabel,
          cell: (variant, size) => VanillaIconButton(
            variant: variant,
            size: size,
            icon: RemixIcons.plus,
            semanticLabel: 'Add item',
            onPressed: () => _toast(context, 'Item added'),
          ),
        ),
      ),
      _Section(
        label: 'Toggle',
        description: 'Ghost and outline toggles remain fully interactive.',
        child: _Matrix(
          rows: VanillaToggleVariant.values,
          columns: VanillaToggleSize.values,
          rowLabel: _enumLabel,
          columnLabel: _enumLabel,
          cell: (variant, size) => VanillaToggle(
            variant: variant,
            size: size,
            selected: _selected,
            icon: RemixIcons.fontBold,
            label: 'Bold',
            onChanged: (value) => setState(() => _selected = value),
          ),
        ),
      ),
      _Section(
        label: 'States',
        description:
            'Disabled and loading behavior uses the same component API.',
        child: WrapBox(
          style: WrapBoxStyler()
              .spacing(VanillaTokens.s3)
              .runSpacing(VanillaTokens.s3),
          children: [
            const VanillaButton(label: 'Disabled', enabled: false),
            VanillaButton(label: 'Saving', loading: true, onPressed: () {}),
            const VanillaIconButton(
              icon: RemixIcons.heart,
              semanticLabel: 'Disabled favorite',
              enabled: false,
            ),
          ],
        ),
      ),
    ],
  );
}

class DefaultGalleryFormsPage extends StatefulWidget {
  const DefaultGalleryFormsPage({super.key});

  @override
  State<DefaultGalleryFormsPage> createState() =>
      _DefaultGalleryFormsPageState();
}

class _DefaultGalleryFormsPageState extends State<DefaultGalleryFormsPage> {
  bool _checked = true;
  bool _switched = true;
  int _radio = 1;
  String _alignment = 'left';
  String _density = 'comfortable';
  Set<String> _channels = {'email'};
  double _slider = 58;

  @override
  Widget build(BuildContext context) => DefaultGalleryPage(
    title: 'Forms & Inputs',
    intro: 'Production-ready fields and selection controls in every preset.',
    sections: [
      _Section(
        label: 'Text field',
        description: 'The native field with a leading icon and placeholder.',
        child: Box(
          style: BoxStyler().width(300),
          child: const VanillaTextField(
            hintText: 'Type something…',
            leading: Icon(RemixIcons.magnifyingGlass, size: VanillaTokens.icon),
          ),
        ),
      ),
      _Section(
        label: 'Text area',
        description: 'Multi-line input sharing the text field treatment.',
        child: Box(
          style: BoxStyler().width(360),
          child: const VanillaTextArea(hintText: 'Add a note…'),
        ),
      ),
      _Section(
        label: 'Segmented control',
        description: 'Exclusive selection using the native treatment.',
        child: Align(
          alignment: Alignment.centerLeft,
          child: VanillaSegmentedControl<String>(
            selectedValue: _density,
            semanticLabel: 'Row density',
            items: const [
              RemixSegmentedControlItem(value: 'compact', label: 'Compact'),
              RemixSegmentedControlItem(value: 'comfortable', label: 'Cozy'),
            ],
            onChanged: (value) => setState(() => _density = value),
          ),
        ),
      ),
      _Section(
        label: 'Select',
        description: 'A keyboard-accessible native select.',
        child: Align(
          alignment: Alignment.centerLeft,
          child: Box(
            style: BoxStyler().width(220),
            child: VanillaSelect<String>(
              trigger: const RemixSelectTrigger(placeholder: 'Fruit'),
              items: const [
                RemixSelectItem(value: 'apple', label: 'Apple'),
                RemixSelectItem(value: 'orange', label: 'Orange'),
                RemixSelectItem(value: 'pear', label: 'Pear'),
              ],
              selectedValue: 'apple',
              onChanged: (_) {},
            ),
          ),
        ),
      ),
      _Section(
        label: 'Toggle group',
        description: 'Every native group variant and size.',
        child: _Matrix(
          rows: VanillaToggleGroupVariant.values,
          columns: VanillaToggleGroupSize.values,
          rowLabel: _enumLabel,
          columnLabel: _enumLabel,
          cellWidth: 230,
          cell: (variant, size) => VanillaToggleGroup<String>(
            variant: variant,
            size: size,
            selectedValue: _alignment,
            semanticLabel: 'Text alignment',
            items: const [
              RemixToggleGroupItem(
                value: 'left',
                icon: RemixIcons.alignLeft,
                semanticLabel: 'Left',
              ),
              RemixToggleGroupItem(
                value: 'center',
                icon: RemixIcons.alignCenterHorizontally,
                semanticLabel: 'Center',
              ),
              RemixToggleGroupItem(
                value: 'right',
                icon: RemixIcons.alignRight,
                semanticLabel: 'Right',
              ),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _alignment = value);
            },
          ),
        ),
      ),
      _Section(
        label: 'Checkbox',
        description: 'The native tri-state checkbox recipe.',
        child: Align(
          alignment: Alignment.centerLeft,
          child: VanillaCheckbox(
            selected: _checked,
            label: 'Example checkbox',
            onChanged: (value) => setState(() => _checked = value ?? false),
          ),
        ),
      ),
      _Section(
        label: 'Checkbox group',
        description: 'Labelled options share the checkbox tap target.',
        child: RemixCheckboxGroup<String>(
          values: _channels,
          semanticLabel: 'Notification channels',
          onChanged: (values) => setState(() => _channels = values),
          child: WrapBox(
            style: WrapBoxStyler()
                .spacing(VanillaTokens.s4)
                .runSpacing(VanillaTokens.s1_5),
            children: [
              for (final (value, label) in const [
                ('email', 'Email'),
                ('sms', 'SMS'),
                ('push', 'Push'),
              ])
                VanillaCheckboxGroupItem<String>(value: value, label: label),
            ],
          ),
        ),
      ),
      _Section(
        label: 'Radio',
        description: 'Exclusive radio selection.',
        child: RemixRadioGroup<int>(
          groupValue: _radio,
          onChanged: (value) {
            if (value != null) setState(() => _radio = value);
          },
          child: WrapBox(
            style: WrapBoxStyler().spacing(VanillaTokens.s5),
            children: const [
              VanillaRadio<int>(value: 1, semanticLabel: 'First option'),
              VanillaRadio<int>(value: 2, semanticLabel: 'Second option'),
            ],
          ),
        ),
      ),
      _Section(
        label: 'Switch',
        description: 'The native binary setting control.',
        child: Align(
          alignment: Alignment.centerLeft,
          child: VanillaSwitch(
            selected: _switched,
            semanticLabel: 'Example switch',
            onChanged: (value) => setState(() => _switched = value),
          ),
        ),
      ),
      _Section(
        label: 'Slider',
        description: 'A discrete single-thumb slider.',
        child: Box(
          style: BoxStyler().width(300),
          child: VanillaSlider(
            value: _slider,
            min: 0,
            max: 100,
            snapDivisions: 100,
            onChanged: (value) => setState(() => _slider = value),
          ),
        ),
      ),
      _Section(
        label: 'States',
        description: 'Validation, disabled, and indeterminate states.',
        child: WrapBox(
          style: WrapBoxStyler()
              .spacing(VanillaTokens.s4)
              .runSpacing(VanillaTokens.s4)
              .crossAxisAlignment(.center),
          children: [
            Box(
              style: BoxStyler().width(240),
              child: const VanillaTextField(
                error: true,
                label: 'Workspace slug',
                hintText: 'remix',
                helperText: 'That slug is already in use.',
              ),
            ),
            const VanillaCheckbox(
              selected: null,
              tristate: true,
              semanticLabel: 'Indeterminate checkbox',
            ),
            const VanillaCheckbox(selected: true, label: 'Labelled'),
            const VanillaSwitch(
              selected: false,
              enabled: false,
              semanticLabel: 'Disabled switch',
            ),
          ],
        ),
      ),
    ],
  );
}

class DefaultGalleryDisplayPage extends StatefulWidget {
  const DefaultGalleryDisplayPage({super.key});

  @override
  State<DefaultGalleryDisplayPage> createState() =>
      _DefaultGalleryDisplayPageState();
}

class _DefaultGalleryDisplayPageState extends State<DefaultGalleryDisplayPage> {
  bool _spinnersRunning = false;
  bool _skeletonLoading = false;

  @override
  Widget build(BuildContext context) => DefaultGalleryPage(
    title: 'Data Display',
    intro: 'Rich surfaces and status components for product interfaces.',
    sections: [
      _Section(
        label: 'Avatar',
        description: 'The native avatar treatment with image and fallback.',
        child: WrapBox(
          style: WrapBoxStyler()
              .spacing(VanillaTokens.s4)
              .crossAxisAlignment(.center),
          children: const [
            VanillaAvatar(label: 'RF'),
            VanillaAvatar(icon: RemixIcons.person),
          ],
        ),
      ),
      _Section(
        label: 'Badge',
        description: 'Status labels in every native variant.',
        child: WrapBox(
          style: WrapBoxStyler()
              .spacing(VanillaTokens.s3)
              .runSpacing(VanillaTokens.s3),
          children: [
            for (final variant in VanillaBadgeVariant.values)
              VanillaBadge(variant: variant, label: _enumLabel(variant)),
          ],
        ),
      ),
      _Section(
        label: 'Card',
        description: 'The native surface and spacing treatment.',
        child: Box(
          style: BoxStyler().width(240),
          child: const VanillaCard(child: _Text('Card content')),
        ),
      ),
      _Section(
        label: 'Callout',
        description: 'Contextual information in every native variant.',
        child: WrapBox(
          style: WrapBoxStyler()
              .spacing(VanillaTokens.s3)
              .runSpacing(VanillaTokens.s3),
          children: [
            for (final variant in VanillaCalloutVariant.values)
              Box(
                style: BoxStyler().width(280),
                child: VanillaCallout(
                  variant: variant,
                  icon: variant == VanillaCalloutVariant.destructive
                      ? RemixIcons.exclamationTriangle
                      : RemixIcons.infoCircled,
                  text: 'A helpful ${_enumLabel(variant)} callout.',
                ),
              ),
          ],
        ),
      ),
      _Section(
        label: 'Data list',
        description: 'Label and value pairs in both orientations.',
        child: WrapBox(
          style: WrapBoxStyler()
              .spacing(VanillaTokens.s8)
              .runSpacing(VanillaTokens.s5),
          children: const [
            VanillaDataList(
              items: [
                RemixDataListItem(label: 'Status', value: 'Active'),
                RemixDataListItem(label: 'Plan', value: 'Enterprise'),
                RemixDataListItem(label: 'Seats', value: '48'),
              ],
            ),
            VanillaDataList(
              orientation: Axis.vertical,
              items: [
                RemixDataListItem(label: 'Status', value: 'Active'),
                RemixDataListItem(label: 'Plan', value: 'Enterprise'),
                RemixDataListItem(label: 'Seats', value: '48'),
              ],
            ),
          ],
        ),
      ),
      _Section(
        label: 'Skeleton',
        description: 'Placeholder shapes preserve loaded measurements.',
        child: ColumnBox(
          style: FlexBoxStyler()
              .crossAxisAlignment(.start)
              .spacing(VanillaTokens.s3),
          children: [
            VanillaButton.secondary(
              size: .small,
              label: _skeletonLoading ? 'Show content' : 'Show skeleton',
              onPressed: () =>
                  setState(() => _skeletonLoading = !_skeletonLoading),
            ),
            VanillaSkeleton(
              loading: _skeletonLoading,
              child: const VanillaAvatar(label: 'RF'),
            ),
            VanillaSkeleton(
              loading: _skeletonLoading,
              child: const _Text('Loaded content replaces the placeholder.'),
            ),
          ],
        ),
      ),
      _Section(
        label: 'Progress',
        description: 'Determinate progress using the native treatment.',
        child: Box(
          style: BoxStyler().width(320),
          child: const VanillaProgress(
            value: .68,
            semanticsLabel: '68 percent complete',
          ),
        ),
      ),
      _Section(
        label: 'Spinner',
        description:
            'Animation is stopped by default so automated tests settle.',
        child: RowBox(
          style: FlexBoxStyler()
              .crossAxisAlignment(.center)
              .spacing(VanillaTokens.s4),
          children: [
            VanillaButton.secondary(
              size: .small,
              label: _spinnersRunning ? 'Stop' : 'Start',
              onPressed: () =>
                  setState(() => _spinnersRunning = !_spinnersRunning),
            ),
            if (_spinnersRunning)
              const VanillaSpinner(semanticsLabel: 'Loading example')
            else
              const Icon(RemixIcons.check, size: VanillaTokens.icon),
          ],
        ),
      ),
      _Section(
        label: 'Divider',
        description: 'Horizontal and vertical native dividers.',
        child: ColumnBox(
          style: FlexBoxStyler().spacing(VanillaTokens.s3_5),
          children: [
            const VanillaDivider(),
            Box(
              style: BoxStyler().height(VanillaTokens.s12),
              child: const VanillaDivider(orientation: Axis.vertical),
            ),
          ],
        ),
      ),
    ],
  );
}

class DefaultGalleryOverlaysPage extends StatefulWidget {
  const DefaultGalleryOverlaysPage({super.key});

  @override
  State<DefaultGalleryOverlaysPage> createState() =>
      _DefaultGalleryOverlaysPageState();
}

class _DefaultGalleryOverlaysPageState
    extends State<DefaultGalleryOverlaysPage> {
  bool _showArchived = true;
  String _sort = 'newest';

  @override
  Widget build(BuildContext context) => DefaultGalleryPage(
    title: 'Overlays',
    intro: 'Real dialog, popover, tooltip, and menu triggers for every recipe.',
    sections: [
      _Section(
        label: 'Dialog',
        description: 'A modal, focus-trapped confirmation surface.',
        child: Align(
          alignment: Alignment.centerLeft,
          child: VanillaButton.secondary(
            label: 'Open',
            onPressed: () => showRemixDialog<void>(
              context: context,
              barrierLabel: 'Dismiss',
              builder: (dialogContext) => VanillaDialog(
                title: 'Invite teammates',
                description: 'Share this workspace with your collaborators.',
                actions: [
                  VanillaButton.secondary(
                    label: 'Cancel',
                    onPressed: () => Navigator.of(dialogContext).pop(),
                  ),
                  VanillaButton(
                    label: 'Send invite',
                    onPressed: () => Navigator.of(dialogContext).pop(),
                  ),
                ],
                child: Box(
                  style: BoxStyler().padding(.only(top: VanillaTokens.s3)),
                  child: const VanillaTextField(
                    hintText: 'teammate@example.com',
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      _Section(
        label: 'Popover',
        description: 'Anchored content using the native padding treatment.',
        child: Align(
          alignment: Alignment.centerLeft,
          child: VanillaPopover(
            semanticLabel: 'Open quick note popover',
            popoverChild: Box(
              style: BoxStyler().width(250),
              child: ColumnBox(
                style: FlexBoxStyler()
                    .mainAxisSize(.min)
                    .crossAxisAlignment(.start)
                    .spacing(VanillaTokens.s2),
                children: const [
                  _Text('Quick note', emphasized: true),
                  _Text('Popover content inherits the active theme.'),
                ],
              ),
            ),
            child: const _OverlayTrigger('Open popover'),
          ),
        ),
      ),
      const _Section(
        label: 'Tooltip',
        description: 'Hover or long-press to reveal contextual help.',
        child: Align(
          alignment: Alignment.centerLeft,
          child: VanillaTooltip(
            tooltipSemantics: 'Keyboard shortcut Command K',
            tooltipChild: Text('Search · ⌘K'),
            child: _OverlayTrigger('Hover for shortcut'),
          ),
        ),
      ),
      _Section(
        label: 'Menu',
        description:
            'Submenus, checkbox and radio items use real menu behavior.',
        child: Align(
          alignment: Alignment.centerLeft,
          child: VanillaMenu<String>(
            trigger: const RemixMenuTrigger(
              label: 'Open menu',
              icon: RemixIcons.dotsHorizontal,
            ),
            items: [
              const RemixMenuItem(value: 'duplicate', label: 'Duplicate'),
              const RemixMenuSubmenu(
                label: 'Share',
                items: [
                  RemixMenuItem(value: 'share-link', label: 'Copy link'),
                  RemixMenuItem(value: 'share-email', label: 'Email'),
                ],
              ),
              const RemixMenuDivider(),
              RemixMenuCheckboxItem(
                value: 'archived',
                label: 'Show archived',
                checked: _showArchived,
                onChanged: (checked) => setState(() => _showArchived = checked),
              ),
              const RemixMenuDivider(),
              RemixMenuRadioGroup(
                value: _sort,
                onChanged: (value) => setState(() => _sort = value),
                items: const [
                  RemixMenuRadioItem(value: 'newest', label: 'Newest'),
                  RemixMenuRadioItem(value: 'oldest', label: 'Oldest'),
                ],
              ),
            ],
            onSelected: (value) => _toast(context, '$value selected'),
          ),
        ),
      ),
    ],
  );
}

class DefaultGalleryNavigationPage extends StatefulWidget {
  const DefaultGalleryNavigationPage({super.key});

  @override
  State<DefaultGalleryNavigationPage> createState() =>
      _DefaultGalleryNavigationPageState();
}

class _DefaultGalleryNavigationPageState
    extends State<DefaultGalleryNavigationPage> {
  String _sidebar = 'overview';
  String _tab = 'overview';
  final _accordion = RemixAccordionController<String>(max: 1);

  @override
  void dispose() {
    _accordion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DefaultGalleryPage(
    title: 'Navigation',
    intro:
        'Page headers, sectioned navigation, tabs, disclosures, and accordions for organizing dense interfaces.',
    sections: [
      _Section(
        label: 'App bar',
        description:
            'A page header with a leading button, a title heading, and actions.',
        child: VanillaAppBar(
          // A sample inside a card: it neither touches the screen edge nor
          // names the page.
          safeArea: false,
          namesRoute: false,
          leading: VanillaIconButton.ghost(
            size: .large,
            icon: RemixIcons.hamburgerMenu,
            semanticLabel: 'Open navigation',
            onPressed: () => _toast(context, 'Navigation is the caller\'s'),
          ),
          title: 'Orders',
          actions: [
            VanillaIconButton.ghost(
              size: .large,
              icon: RemixIcons.magnifyingGlass,
              semanticLabel: 'Search orders',
              onPressed: () => _toast(context, 'Search orders'),
            ),
            VanillaIconButton.ghost(
              size: .large,
              icon: RemixIcons.bell,
              semanticLabel: 'Notifications',
              onPressed: () => _toast(context, 'No new notifications'),
            ),
          ],
        ),
      ),
      _Section(
        label: 'Sidebar',
        description:
            'A controlled native sidebar with fixed header and footer.',
        child: Align(
          alignment: Alignment.centerLeft,
          child: Box(
            style: BoxStyler().width(280).height(320),
            child: VanillaSidebar<String>(
              header: Box(
                style: BoxStyler().padding(.all(VanillaTokens.s3_5)),
                child: const _Heading(
                  'Acme',
                  token: VanillaTokens.textBase,
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
              footer: const _Text('Ada Chen', emphasized: true),
              semanticLabel: 'Gallery navigation example',
            ),
          ),
        ),
      ),
      _Section(
        label: 'Tabs',
        description: 'Live keyboard and pointer selection.',
        child: RemixTabs(
          selectedTabId: _tab,
          onChanged: (value) => setState(() => _tab = value),
          child: ColumnBox(
            style: FlexBoxStyler().crossAxisAlignment(.stretch),
            children: [
              VanillaTabBar(
                child: RowBox(
                  children: const [
                    VanillaTab(tabId: 'overview', label: 'Overview'),
                    VanillaTab(tabId: 'activity', label: 'Activity'),
                  ],
                ),
              ),
              VanillaTabView(
                tabId: 'overview',
                child: Box(
                  style: BoxStyler().padding(.all(VanillaTokens.s3)),
                  child: const _Text('Overview content'),
                ),
              ),
              VanillaTabView(
                tabId: 'activity',
                child: Box(
                  style: BoxStyler().padding(.all(VanillaTokens.s3)),
                  child: const _Text('Activity content'),
                ),
              ),
            ],
          ),
        ),
      ),
      const _Section(
        label: 'Disclosure',
        description: 'An independent expandable native panel.',
        child: VanillaDisclosure(
          defaultExpanded: true,
          semanticLabel: 'Shipping details',
          trigger: _Text('Shipping details', emphasized: true),
          content: _Text('Delivery takes 3–5 business days.'),
        ),
      ),
      _Section(
        label: 'Accordion',
        description: 'Coordinated panels keep one section open.',
        child: RemixAccordionGroup<String>(
          controller: _accordion,
          child: ColumnBox(
            style: FlexBoxStyler().crossAxisAlignment(.stretch),
            children: const [
              VanillaAccordion<String>(
                value: 'details',
                title: 'What is Vanilla?',
                child: _Text(
                  'A neutral starter theme, installed as source you own.',
                ),
              ),
              VanillaAccordion<String>(
                value: 'tokens',
                title: 'Does it support tokens?',
                child: _Text(
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

class DefaultGalleryTypographyPage extends StatelessWidget {
  const DefaultGalleryTypographyPage({super.key});

  @override
  Widget build(BuildContext context) => DefaultGalleryPage(
    title: 'Typography',
    intro: 'Text, headings, code, keys, and links on one shared scale.',
    sections: [
      _Section(
        label: 'Text scale',
        description: 'The native scale from caption to display.',
        child: ColumnBox(
          style: FlexBoxStyler()
              .crossAxisAlignment(.start)
              .spacing(VanillaTokens.s1_5),
          children: [
            for (final (label, token) in const [
              ('12px', VanillaTokens.textXs),
              ('14px', VanillaTokens.textSm),
              ('16px', VanillaTokens.textBase),
              ('18px', VanillaTokens.textLg),
              ('20px', VanillaTokens.textXl),
              ('24px', VanillaTokens.text2xl),
              ('30px', VanillaTokens.text3xl),
            ])
              _Text('The quick brown fox · $label', token: token),
          ],
        ),
      ),
      _Section(
        label: 'Weights',
        description: 'The complete native font-weight range.',
        child: WrapBox(
          style: WrapBoxStyler()
              .spacing(VanillaTokens.s6)
              .runSpacing(VanillaTokens.s3),
          children: [
            for (final (label, weight) in const [
              ('Regular', FontWeight.w400),
              ('Medium', FontWeight.w500),
              ('Semibold', FontWeight.w600),
              ('Bold', FontWeight.w700),
            ])
              _Text(label, token: VanillaTokens.textLg, weight: weight),
          ],
        ),
      ),
      _Section(
        label: 'Heading level and size',
        description:
            'Semantic heading levels remain independent of visual scale.',
        child: ColumnBox(
          style: FlexBoxStyler()
              .crossAxisAlignment(.start)
              .spacing(VanillaTokens.s2),
          children: [
            Semantics(
              header: true,
              child: const _Heading(
                'Level 1 heading at 30px',
                token: VanillaTokens.text3xl,
              ),
            ),
            Semantics(
              header: true,
              child: const _Heading(
                'Level 2 heading at 20px',
                token: VanillaTokens.textXl,
              ),
            ),
            Semantics(
              header: true,
              child: const _Heading(
                'Level 3 heading at 16px',
                token: VanillaTokens.textBase,
              ),
            ),
          ],
        ),
      ),
      _Section(
        label: 'Code',
        description: 'Inline code uses a distinct monospace surface.',
        child: WrapBox(
          style: WrapBoxStyler()
              .spacing(VanillaTokens.s3)
              .runSpacing(VanillaTokens.s2),
          children: const [
            _Code('const x = 1;'),
            _Code('remix add dashboard_demo'),
          ],
        ),
      ),
      _Section(
        label: 'Keyboard keys',
        description: 'Keyboard caps remain readable beside body copy.',
        child: WrapBox(
          style: WrapBoxStyler().spacing(VanillaTokens.s2),
          children: const [_Keycap('⌘'), _Keycap('K'), _Keycap('Enter')],
        ),
      ),
      _Section(
        label: 'Links',
        description: 'Interactive, disabled, and destination-bearing links.',
        child: WrapBox(
          style: WrapBoxStyler()
              .spacing(VanillaTokens.s5)
              .runSpacing(VanillaTokens.s3),
          children: [
            VanillaLink(
              label: 'Interactive',
              onPressed: () => _toast(context, 'Link activated'),
            ),
            const VanillaLink(label: 'Disabled'),
            VanillaLink(
              label: 'Documentation',
              linkUrl: Uri.parse('https://docs.page/btwld/remix'),
              onPressed: () => _toast(context, 'Navigation is the caller\'s'),
            ),
          ],
        ),
      ),
      _Section(
        label: 'Accent and high contrast',
        description: 'Foreground and muted roles preserve useful contrast.',
        child: WrapBox(
          style: WrapBoxStyler()
              .spacing(VanillaTokens.s5)
              .runSpacing(VanillaTokens.s3),
          children: const [
            _Text('Foreground'),
            _Text('Muted foreground', muted: true),
            _Heading('Strong heading', token: VanillaTokens.textBase),
          ],
        ),
      ),
      _Section(
        label: 'Wrapping and truncation',
        description: 'Long text demonstrates both wrapping strategies.',
        child: WrapBox(
          style: WrapBoxStyler()
              .spacing(VanillaTokens.s8)
              .runSpacing(VanillaTokens.s4),
          children: [
            Box(
              style: BoxStyler().width(260),
              child: const _Text(
                'Wrap keeps the complete sentence, across as many lines as it needs.',
              ),
            ),
            Box(
              style: BoxStyler().width(260),
              child: const _Text(
                'Truncate keeps exactly one line, across as many lines as it needs.',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _OverlayTrigger extends StatelessWidget {
  const _OverlayTrigger(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => VanillaBadge.outline(label: label);
}

class _Text extends StatelessWidget {
  const _Text(
    this.value, {
    this.token = VanillaTokens.textSm,
    this.weight = FontWeight.w400,
    this.muted = false,
    this.emphasized = false,
    this.maxLines,
    this.overflow,
  });

  final String value;
  final TextStyleToken token;
  final FontWeight weight;
  final bool muted;
  final bool emphasized;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    var style = TextStyler()
        .style(token.mix())
        .fontWeight(emphasized ? FontWeight.w600 : weight)
        .color(
          muted ? VanillaTokens.mutedForeground() : VanillaTokens.foreground(),
        );
    if (maxLines != null) style = style.maxLines(maxLines!);
    if (overflow != null) style = style.overflow(overflow!);
    return StyledText(value, style: style);
  }
}

class _Heading extends _Text {
  const _Heading(
    super.value, {
    super.token = VanillaTokens.textLg,
    super.weight = FontWeight.w600,
  });
}

class _Code extends StatelessWidget {
  const _Code(this.value);
  final String value;

  @override
  Widget build(BuildContext context) => Box(
    style: BoxStyler()
        .color(VanillaTokens.muted())
        .borderRadius(.all(VanillaTokens.radiusSm()))
        .padding(
          .symmetric(horizontal: VanillaTokens.s2, vertical: VanillaTokens.s1),
        ),
    child: StyledText(
      value,
      style: TextStyler()
          .style(VanillaTokens.textMono.mix())
          .color(VanillaTokens.foreground()),
    ),
  );
}

class _Keycap extends StatelessWidget {
  const _Keycap(this.value);
  final String value;

  @override
  Widget build(BuildContext context) => Box(
    style: BoxStyler()
        .color(VanillaTokens.background())
        .borderAll(
          color: VanillaTokens.border(),
          width: VanillaTokens.strokeHairline,
        )
        .borderRadius(.all(VanillaTokens.radiusSm()))
        .padding(
          .symmetric(horizontal: VanillaTokens.s2, vertical: VanillaTokens.s1),
        ),
    child: _Text(value, token: VanillaTokens.textXs, emphasized: true),
  );
}

String _enumLabel(Enum value) {
  final name = value.name;
  return '${name[0].toUpperCase()}${name.substring(1)}';
}

void _toast(BuildContext context, String title) => showRemixToast(
  context,
  RemixToastData(title: title, icon: RemixIcons.checkCircled),
);
