import 'dart:math' as math;
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:remix/remix.dart';
import 'ui/ui.dart';
import 'helpers/catalog.dart';
import 'components/button.dart' as button;
import 'components/icon_button.dart' as icon_button;
import 'components/toggle.dart' as toggle;
import 'components/toggle_group.dart' as toggle_group;
import 'components/tabs.dart' as tabs;
import 'components/link.dart' as link;
import 'components/checkbox.dart' as checkbox;
import 'components/radio.dart' as radio;
import 'components/switch.dart' as switch_story;
import 'components/slider.dart' as slider;
import 'components/select.dart' as select;
import 'components/segmented_control.dart' as segmented_control;
import 'components/textfield.dart' as textfield;
import 'components/textarea.dart' as textarea;
import 'components/card.dart' as card;
import 'components/accordion.dart' as accordion;
import 'components/disclosure.dart' as disclosure;
import 'components/data_table.dart' as data_table;
import 'components/data_list.dart' as data_list;
import 'components/divider.dart' as divider;
import 'components/text.dart' as text;
import 'components/heading.dart' as heading;
import 'components/code.dart' as code;
import 'components/kbd.dart' as kbd;
import 'components/avatar.dart' as avatar;
import 'components/badge.dart' as badge;
import 'components/callout.dart' as callout;
import 'components/progress.dart' as progress;
import 'components/spinner.dart' as spinner;
import 'components/dialog.dart' as dialog;

/// Fortal's review playground. All authored sizes and variants, in both modes.
/// `group` and `accent` also make deterministic, focused visual captures easy.
class FortalPolishBoard extends StatefulWidget {
  const FortalPolishBoard({
    super.key,
    this.initialAccent = .calcadao,
    this.initialGroup = 'All',
  });
  final FortalAccentColor initialAccent;
  final String initialGroup;
  @override
  State<FortalPolishBoard> createState() => _FortalPolishBoardState();
}

class _FortalPolishBoardState extends State<FortalPolishBoard> {
  late FortalAccentColor accent = widget.initialAccent;
  late String group = widget.initialGroup;
  String state = 'Live';
  bool grid = true;

  @override
  Widget build(BuildContext context) => WidgetsApp(
    debugShowCheckedModeBanner: false,
    title: 'Fortal · polish board',
    color: const Color(0xfffaf9f6),
    pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    ),
    builder: (context, child) => FortalTheme(mode: .light, child: child!),
    home: Column(
      children: [
        const FortalAppBar(title: 'Fortal · polish board'),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 24,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              FortalSelect<FortalAccentColor>(
                semanticLabel: 'Palette',
                trigger: const RemixSelectTrigger(placeholder: 'Palette'),
                selectedValue: accent,
                items: [
                  for (final value in FortalAccentColor.values)
                    RemixSelectItem(value: value, label: paletteLabel(value)),
                ],
                onChanged: (value) => setState(() => accent = value!),
              ),
              FortalSelect<String>(
                semanticLabel: 'Component group',
                trigger: const RemixSelectTrigger(placeholder: 'Group'),
                selectedValue: group,
                items: [
                  for (final value in ['All', ...polishGroups])
                    RemixSelectItem(value: value, label: value),
                ],
                onChanged: (value) => setState(() => group = value!),
              ),
              FortalSelect<String>(
                semanticLabel: 'Interaction state',
                trigger: const RemixSelectTrigger(placeholder: 'State'),
                selectedValue: state,
                items: [
                  for (final value in [
                    'Live',
                    'Hovered',
                    'Pressed',
                    'Focused',
                    'Disabled',
                  ])
                    RemixSelectItem(value: value, label: value),
                ],
                onChanged: (value) => setState(() => state = value!),
              ),
              FortalToggle(
                label: '4 px grid',
                selected: grid,
                onChanged: (value) => setState(() => grid = value),
              ),
              const FortalText(
                'Check padding · icon / gap · text centering · ≥40 px targets',
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 1600,
                child: FortalPolishContents(
                  accent: accent,
                  group: group,
                  grid: grid,
                  states: switch (state) {
                    'Hovered' => {WidgetState.hovered},
                    'Pressed' => {WidgetState.pressed},
                    'Focused' => {WidgetState.focused},
                    'Disabled' => {WidgetState.disabled},
                    _ => const {},
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

String paletteLabel(FortalAccentColor value) => switch (value) {
  .calcadao => 'Calçadão',
  .ceu => 'Céu',
  _ => '${value.name[0].toUpperCase()}${value.name.substring(1)}',
};
const polishGroups = <String>[
  'Actions',
  'Inputs',
  'Containers',
  'Typography',
  'Feedback',
  'Layers',
  'Layout',
];

typedef _Family = ({String id, String group, WidgetBuilder build});
final _families = <_Family>[
  (id: 'button', group: 'Actions', build: button.buildButtonCatalogUseCase),
  (
    id: 'icon_button',
    group: 'Actions',
    build: icon_button.buildIconButtonCatalogUseCase,
  ),
  (id: 'toggle', group: 'Actions', build: toggle.buildToggleCatalogUseCase),
  (
    id: 'toggle_group',
    group: 'Actions',
    build: toggle_group.buildToggleGroupCatalogUseCase,
  ),
  (id: 'tabs', group: 'Actions', build: tabs.buildTabsCatalogUseCase),
  (id: 'link', group: 'Actions', build: link.buildLinkCatalogUseCase),
  (
    id: 'checkbox',
    group: 'Inputs',
    build: checkbox.buildCheckboxCatalogUseCase,
  ),
  (id: 'radio', group: 'Inputs', build: radio.buildRadioCatalogUseCase),
  (
    id: 'switch',
    group: 'Inputs',
    build: switch_story.buildSwitchCatalogUseCase,
  ),
  (id: 'slider', group: 'Inputs', build: slider.buildSliderCatalogUseCase),
  (id: 'select', group: 'Inputs', build: select.buildSelectCatalogUseCase),
  (
    id: 'segmented_control',
    group: 'Inputs',
    build: segmented_control.buildSegmentedControlCatalogUseCase,
  ),
  (
    id: 'textfield',
    group: 'Inputs',
    build: textfield.buildTextFieldCatalogUseCase,
  ),
  (
    id: 'textarea',
    group: 'Inputs',
    build: textarea.buildTextAreaCatalogUseCase,
  ),
  (id: 'card', group: 'Containers', build: card.buildCardCatalogUseCase),
  (
    id: 'accordion',
    group: 'Containers',
    build: accordion.buildAccordionCatalogUseCase,
  ),
  (
    id: 'disclosure',
    group: 'Containers',
    build: disclosure.buildDisclosureCatalogUseCase,
  ),
  (
    id: 'data_table',
    group: 'Containers',
    build: data_table.buildDataTableCatalogUseCase,
  ),
  (
    id: 'data_list',
    group: 'Containers',
    build: data_list.buildDataListCatalogUseCase,
  ),
  (
    id: 'divider',
    group: 'Containers',
    build: divider.buildDividerCatalogUseCase,
  ),
  (id: 'text', group: 'Typography', build: text.buildTextCatalogUseCase),
  (
    id: 'heading',
    group: 'Typography',
    build: heading.buildHeadingCatalogUseCase,
  ),
  (id: 'code', group: 'Typography', build: code.buildCodeCatalogUseCase),
  (id: 'kbd', group: 'Typography', build: kbd.buildKbdCatalogUseCase),
  (id: 'avatar', group: 'Typography', build: avatar.buildAvatarCatalogUseCase),
  (id: 'badge', group: 'Typography', build: badge.buildBadgeCatalogUseCase),
  (id: 'callout', group: 'Feedback', build: callout.buildCalloutCatalogUseCase),
  (
    id: 'progress',
    group: 'Feedback',
    build: progress.buildProgressCatalogUseCase,
  ),
  (id: 'spinner', group: 'Feedback', build: spinner.buildSpinnerCatalogUseCase),
  (id: 'dialog', group: 'Layers', build: dialog.buildDialogCatalogUseCase),

  (id: 'menu', group: 'Layers', build: _menuMatrix),
  (id: 'popover', group: 'Layers', build: _popoverMatrix),
  (id: 'tooltip', group: 'Layers', build: _tooltipMatrix),
  (id: 'toast', group: 'Feedback', build: _toastMatrix),
  (id: 'skeleton', group: 'Feedback', build: _skeletonMatrix),
  (id: 'app_bar', group: 'Layout', build: _appBarMatrix),
  (id: 'sidebar', group: 'Layout', build: _sidebarMatrix),
  (id: 'sidebar_layout', group: 'Layout', build: _sidebarLayoutMatrix),
  (id: 'chart', group: 'Layout', build: _chartMatrix),
];

List<String> get polishFamilyIds => [for (final family in _families) family.id];

/// The exact review surface captured by the owned golden tests.
class FortalPolishContents extends StatelessWidget {
  const FortalPolishContents({
    super.key,
    this.accent = .calcadao,
    this.group = 'All',
    this.grid = true,
    this.fontFamily,
    this.states = const {},
  });
  final FortalAccentColor accent;
  final String group;
  final bool grid;
  final String? fontFamily;
  final Set<WidgetState> states;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      for (final family in _families.where(
        (family) => group == 'All' || family.group == group,
      ))
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final dark in [false, true])
              Expanded(
                child: FortalTheme(
                  accent: accent,
                  mode: dark ? .dark : .light,
                  child: PolishTypography(
                    fontFamily: fontFamily,
                    child: Builder(
                      builder: (context) => ColoredBox(
                        color: FortalTokens.colorBackground.resolve(context),
                        child: CustomPaint(
                          painter: grid
                              ? _Grid(FortalTokens.gray8.resolve(context))
                              : null,
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                FortalText(
                                  '${family.id.replaceAll('_', ' ')} · ${dark ? 'dark' : 'light'}',
                                  weight: .bold,
                                ),
                                const SizedBox(height: 16),
                                WidgetStateStyleOverride(
                                  states: states,
                                  child: Builder(
                                    builder: (context) => _MatrixCells(
                                      matrix:
                                          family.build(context)
                                              as CatalogMatrix,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
    ],
  );
}

class _MatrixCells extends StatelessWidget {
  const _MatrixCells({required this.matrix});
  final CatalogMatrix matrix;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final width = math.min(matrix.cellWidth, constraints.maxWidth);
      return Wrap(
        spacing: 8,
        runSpacing: 16,
        children: [
          for (var row = 0; row < matrix.rows.length; row++)
            for (var column = 0; column < matrix.columns.length; column++)
              SizedBox(
                width: width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FortalText(
                      [
                        matrix.rows[row],
                        matrix.columns[column],
                      ].where((label) => label.isNotEmpty).join(' / '),
                      size: .size1,
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: matrix.cell(row, column),
                    ),
                  ],
                ),
              ),
        ],
      );
    },
  );
}

class _Grid extends CustomPainter {
  const _Grid(this.color);
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: .07)
      ..strokeWidth = .5;
    for (var x = 0.0; x < size.width; x += 4) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y < size.height; y += 4) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_Grid oldDelegate) => color != oldDelegate.color;
}

Widget _menuMatrix(BuildContext context) => CatalogMatrix(
  columns: labelsOf(FortalMenuSize.values),
  rows: labelsOf(FortalMenuVariant.values),
  cellWidth: 280,
  cell: (row, column) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    spacing: 12,
    children: [
      FortalMenu<String>(
        size: FortalMenuSize.values[column],
        variant: FortalMenuVariant.values[row],
        trigger: const RemixMenuTrigger(label: 'Open menu'),
        items: const [
          RemixMenuItem(value: 'edit', label: 'Edit'),
          RemixMenuItem(value: 'archive', label: 'Archive'),
        ],
      ),
      Builder(
        builder: (context) {
          final spec = fortalMenuStyle(
            size: FortalMenuSize.values[column],
            variant: FortalMenuVariant.values[row],
          ).build(context).spec;
          return FlexBox(
            styleSpec: spec.overlay,
            children: [
              for (final label in ['Edit', 'Archive'])
                FlexBox(
                  styleSpec: spec.item.spec.container,
                  children: [
                    StyledText(label, styleSpec: spec.item.spec.label),
                  ],
                ),
            ],
          );
        },
      ),
    ],
  ),
);
Widget _popoverMatrix(BuildContext context) => CatalogMatrix(
  columns: labelsOf(FortalPopoverSize.values),
  rows: noRowAxis,
  cellWidth: 320,
  cell: (row, column) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    spacing: 12,
    children: [
      FortalPopover(
        size: FortalPopoverSize.values[column],
        popoverChild: const FortalText('Popover content'),
        child: FortalButton.outline(label: 'Open popover', onPressed: () {}),
      ),
      Builder(
        builder: (context) => Box(
          styleSpec: fortalPopoverStyle(
            size: FortalPopoverSize.values[column],
          ).build(context).spec.container,
          child: const FortalText('Floating panel'),
        ),
      ),
    ],
  ),
);
Widget _tooltipMatrix(BuildContext context) => CatalogMatrix(
  columns: const ['default'],
  rows: noRowAxis,
  cellWidth: 320,
  cell: (row, column) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    spacing: 12,
    children: [
      FortalTooltip(
        tooltipChild: const Text('Helpful context'),
        child: FortalButton.outline(
          label: 'Hover for tooltip',
          onPressed: () {},
        ),
      ),
      Builder(
        builder: (context) {
          final spec = fortalTooltipStyle().build(context).spec;
          return Box(
            styleSpec: spec.container,
            child: StyledText('Helpful context', styleSpec: spec.label),
          );
        },
      ),
    ],
  ),
);
Widget _toastMatrix(BuildContext context) => CatalogMatrix(
  columns: labelsOf(FortalToastSize.values),
  rows: labelsOf(FortalToastVariant.values),
  cellWidth: 352,
  cell: (row, column) => FortalToast(
    size: FortalToastSize.values[column],
    variant: FortalToastVariant.values[row],
    title: 'Draft saved',
    description: 'Ready when you are.',
    onDismiss: () {},
    dismissLabel: 'Dismiss',
  ),
);
Widget _skeletonMatrix(BuildContext context) => CatalogMatrix(
  columns: const ['loading', 'loaded'],
  rows: noRowAxis,
  cell: (row, column) => FortalSkeleton(
    loading: column == 0,
    child: const FortalText('Your workspace is ready'),
  ),
);
Widget _appBarMatrix(BuildContext context) => CatalogMatrix(
  columns: const ['default'],
  rows: noRowAxis,
  cellWidth: 700,
  cell: (row, column) => const FortalAppBar(title: 'Workspace'),
);
const _sections = <RemixSidebarSection<String>>[
  RemixSidebarSection(
    label: 'Workspace',
    destinations: [
      RemixSidebarDestination(
        value: 'home',
        label: 'Overview',
        icon: Icons.home_outlined,
      ),
      RemixSidebarDestination(
        value: 'team',
        label: 'Team',
        icon: Icons.people_outline,
      ),
      RemixSidebarDestination(
        value: 'disabled',
        label: 'Unavailable',
        icon: Icons.lock_outline,
        enabled: false,
      ),
    ],
  ),
];
Widget _sidebarMatrix(BuildContext context) => CatalogMatrix(
  columns: const ['expanded', 'collapsed'],
  rows: noRowAxis,
  cellWidth: 280,
  cell: (row, column) => SizedBox(
    width: column == 0 ? 256 : 72,
    height: 260,
    child: FortalSidebar<String>(
      collapsed: column == 1,
      semanticLabel:
          '${FortalTheme.of(context).brightness.name} sidebar ${column == 0 ? 'expanded' : 'collapsed'}',
      sections: _sections,
      selectedValue: 'home',
      onSelected: (_) {},
    ),
  ),
);
Widget _sidebarLayoutMatrix(BuildContext context) => CatalogMatrix(
  columns: const ['wide', 'compact'],
  rows: noRowAxis,
  cellWidth: 700,
  cell: (row, column) => SizedBox(
    width: 680,
    height: 280,
    child: FortalSidebarLayout(
      compactBreakpoint: column == 0 ? 600 : 720,
      sidebar: FortalSidebar<String>(
        semanticLabel:
            '${FortalTheme.of(context).brightness.name} layout ${column == 0 ? 'wide' : 'compact'}',
        sections: _sections,
        selectedValue: 'home',
        onSelected: (_) {},
      ),
      header: const FortalAppBar(title: 'Overview'),
      body: const Center(child: FortalText('Workspace content')),
    ),
  ),
);
Widget _chartMatrix(BuildContext context) => CatalogMatrix(
  columns: const ['line', 'bar', 'pie'],
  rows: noRowAxis,
  cellWidth: 352,
  cell: (row, column) => SizedBox(
    width: 320,
    height: 200,
    child: switch (column) {
      0 => FortalLineChart(
        showMarkers: true,
        series: [
          LineSeries(
            id: 'revenue',
            label: 'Revenue',
            points: [
              ChartPoint(id: 'one', x: 0, y: 12),
              ChartPoint(id: 'two', x: 1, y: 24),
              ChartPoint(id: 'three', x: 2, y: 18),
            ],
          ),
        ],
      ),
      1 => FortalBarChart(
        groups: [
          BarGroup(
            id: 'q1',
            label: 'Q1',
            bars: [BarValue(id: 'a', label: 'Actual', toY: 24)],
          ),
          BarGroup(
            id: 'q2',
            label: 'Q2',
            bars: [BarValue(id: 'a', label: 'Actual', toY: 36)],
          ),
        ],
      ),
      _ => FortalPieChart(
        slices: [
          PieSlice(id: 'one', label: 'Direct', value: 60),
          PieSlice(id: 'two', label: 'Search', value: 40),
        ],
      ),
    },
  ),
);

/// Optional, deterministic typeface for the review captures only.
/// Production Fortal retains the application's font selection.
class PolishTypography extends StatelessWidget {
  const PolishTypography({super.key, this.fontFamily, required this.child});
  final String? fontFamily;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    if (fontFamily == null) return child;
    return MixScope.inherit(
      textStyles: {
        for (final token in [
          FortalTokens.text1,
          FortalTokens.text2,
          FortalTokens.text3,
          FortalTokens.text4,
          FortalTokens.text5,
          FortalTokens.text6,
          FortalTokens.text7,
          FortalTokens.text8,
          FortalTokens.text9,
          FortalTokens.avatarFallback1One,
          FortalTokens.avatarFallback1Two,
          FortalTokens.avatarFallback2One,
          FortalTokens.avatarFallback2Two,
          FortalTokens.avatarFallback3One,
          FortalTokens.avatarFallback3Two,
          FortalTokens.avatarFallback4One,
          FortalTokens.avatarFallback4Two,
          FortalTokens.avatarFallback5,
          FortalTokens.avatarFallback6,
          FortalTokens.avatarFallback7,
          FortalTokens.avatarFallback8,
          FortalTokens.avatarFallback9,
        ])
          token: token.resolve(context).copyWith(fontFamily: fontFamily),
      },
      child: child,
    );
  }
}
