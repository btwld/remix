import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../components/code.dart';
import '../../components/kbd.dart';
import '../../components/link.dart';
import '../../components/slider.dart';
import '../../components/spinner.dart';
import '../../components/toggle_group.dart';
import 'dashboard_demo_artwork.dart';
import 'dashboard_demo_page_header.dart';
import 'dashboard_demo_text.dart';
import 'dashboard_demo_theme.dart';
import 'dashboard_demo_theme_panel.dart';
import 'dashboard_demo_typography.dart';
import 'dashboard_demo_ui.dart';
import 'dashboard_demo_widgets.dart';
import 'dashboard_overview.dart';

/// What the dashboard says about one Ui palette.
typedef UiPaletteNote = ({String place, String pairing, UiArtworkMotif motif});

/// The seven palettes, each named for a landscape of Ceará and paired with
/// its own neutral.
const uiPaletteNotes = <UiAccentColor, UiPaletteNote>{
  .orla: (place: 'The seafront', pairing: 'Gray on gray', motif: .waves),
  .mar: (place: 'The sea', pairing: 'Teal on sage', motif: .waves),
  .ceu: (place: 'The sky', pairing: 'Blue on slate', motif: .arches),
  .serra: (place: 'The hills', pairing: 'Gold on olive', motif: .peaks),
  .sol: (place: 'The sun', pairing: 'Amber on sand', motif: .sun),
  .duna: (place: 'The dunes', pairing: 'Brown on sand', motif: .dunes),
  .caju: (place: 'The cashew', pairing: 'Orange on sand', motif: .cobogo),
};

/// The Themes page: the seven Ui palettes as cards, the rest of the theme
/// as controls, and a specimen of components that follows both.
///
/// It edits the nearest [UiDashboardThemeScope], so every page restyles as
/// a palette is picked. Without a scope the cards are previews only.
class UiDashboardThemesPage extends StatelessWidget {
  const UiDashboardThemesPage({super.key});

  static final _palettes = GridBoxStyler.equalColumns(4)
      .gap(uiDashboardGap)
      .onConstraints(
        const .maxWidth(1079),
        .equalColumns(3).gap(uiDashboardGap),
      )
      .onConstraints(const .maxWidth(759), .equalColumns(2).gap(uiDashboardGap))
      .onConstraints(
        const .maxWidth(459),
        .equalColumns(1).gap(uiDashboardGap),
      );

  @override
  Widget build(BuildContext context) {
    final scope = UiDashboardThemeScope.maybeOf(context);
    final active = scope?.settings.accentColor ?? UiTheme.of(context).accent;

    return UiPage(
      key: const ValueKey('dashboard-themes'),
      title: 'Themes',
      description:
          'Seven palettes named for the landscapes of Ceará. Pick one and '
          'the whole dashboard follows.',
      children: [
        GridBox(
          key: const ValueKey('themes-palettes'),
          style: _palettes,
          children: [
            for (final accent in UiAccentColor.values)
              UiPaletteCard(
                key: ValueKey('palette-${accent.name}'),
                accent: accent,
                selected: accent == active,
                onPressed: scope == null
                    ? null
                    : () => scope.onChanged(
                        scope.settings.copyWith(accentColor: accent),
                      ),
              ),
            const _BrandPaletteCard(),
          ],
        ),
        GridBox(
          key: const ValueKey('themes-detail'),
          style: uiLeadGrid,
          children: [
            const UiSpecimenCard(),
            UiSurface(
              child: ColumnBox(
                style: FlexBoxStyler()
                    .crossAxisAlignment(.stretch)
                    .spacing(UiTokens.space4()),
                children: [
                  const UiCardHeader(
                    title: 'Appearance',
                    description: 'Applied live, everywhere.',
                  ),
                  if (scope == null)
                    const UiCallout.outline(
                      icon: RemixIcons.info,
                      text:
                          'Place a theme scope above this page to edit its '
                          'appearance.',
                    )
                  else
                    const SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: UiThemePanel(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// One palette: its landscape as a cover, its twelve steps as a ramp, and a
/// few controls drawn in it. The whole card is a button that applies it.
class UiPaletteCard extends StatelessWidget {
  const UiPaletteCard({
    super.key,
    required this.accent,
    required this.selected,
    this.onPressed,
  });

  /// The palette shown.
  final UiAccentColor accent;

  /// Whether the palette is the one in use.
  final bool selected;

  /// Called when the card is activated. The card is a preview when null.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final note = uiPaletteNotes[accent]!;
    final name = enumLabel(accent);
    final palette = uiAccentPalette(accent);
    final scale =
        (UiTheme.of(context).isDark ? palette.dark : palette.light).scale;
    final inset = UiTokens.space2.resolve(context);

    final content = ColumnBox(
      style: FlexBoxStyler().crossAxisAlignment(.stretch),
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            fit: StackFit.expand,
            children: [
              UiArtwork(motif: note.motif, accent: accent, seed: accent.index),
              if (selected)
                PositionedDirectional(
                  top: inset,
                  start: inset,
                  child: const UiBadge.solid(label: 'In use'),
                ),
            ],
          ),
        ),
        Box(
          style: BoxStyler().padding(.all(UiTokens.space3())),
          child: ColumnBox(
            style: FlexBoxStyler()
                .crossAxisAlignment(.stretch)
                .spacing(UiTokens.space3()),
            children: [
              ColumnBox(
                style: FlexBoxStyler().crossAxisAlignment(.start),
                children: [
                  UiText(name, size: .size3, weight: .medium),
                  StyledText(
                    '${note.place} · ${note.pairing}',
                    style: dashboardTextLine(.size1, tone: .muted),
                  ),
                ],
              ),
              // The twelve steps, lightest first, joined into one bar.
              Box(
                style: BoxStyler()
                    .height(16)
                    .borderRadius(.all(UiTokens.radius2()))
                    .clipBehavior(.antiAlias),
                child: RowBox(
                  style: FlexBoxStyler().crossAxisAlignment(.stretch),
                  children: [
                    for (var step = 1; step <= 12; step += 1)
                      Expanded(child: ColoredBox(color: scale.step(step))),
                  ],
                ),
              ),
              // Drawn, not operated: the card is the control.
              IgnorePointer(
                child: ExcludeFocus(
                  child: UiAccentScope(
                    accent: accent,
                    child: WrapBox(
                      style: WrapBoxStyler()
                          .crossAxisAlignment(.center)
                          .spacing(UiTokens.space2())
                          .runSpacing(UiTokens.space2()),
                      children: [
                        UiButton(
                          size: .size1,
                          label: 'Button',
                          onPressed: () {},
                        ),
                        const UiBadge(label: 'Badge'),
                        UiSwitch(
                          size: .size1,
                          selected: true,
                          semanticLabel: 'Sample switch',
                          onChanged: (_) {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
    final label =
        '$name palette, ${note.pairing.toLowerCase()}'
        '${selected ? ', in use' : ''}';

    return switch (onPressed) {
      final onPressed? => UiPressableSurface(
        onPressed: onPressed,
        semanticLabel: label,
        padded: false,
        child: content,
      ),
      null => Semantics(
        label: label,
        container: true,
        child: ExcludeSemantics(
          child: UiSurface(padded: false, child: content),
        ),
      ),
    };
  }
}

/// The eighth card: a palette is generated, not hand-picked, so a brand can
/// add its own.
class _BrandPaletteCard extends StatelessWidget {
  const _BrandPaletteCard();

  @override
  Widget build(BuildContext context) => UiSurface(
    key: const ValueKey('palette-brand'),
    emphasis: .quiet,
    child: ColumnBox(
      style: FlexBoxStyler()
          .crossAxisAlignment(.start)
          .mainAxisAlignment(.center)
          .spacing(UiTokens.space3()),
      children: [
        const UiAvatar.soft(icon: RemixIcons.plus, size: .size3),
        const UiText('Your brand', size: .size3, weight: .medium),
        StyledText(
          'An eighth palette comes from one seed color. Generate it, then '
          'pass it to the theme as accentPalette.',
          style: dashboardText(.size2, tone: .muted),
        ),
        const UiCode("generate.dart --seed '#8038CC'", size: .size1),
      ],
    ),
  );
}

/// A specimen of Ui components in the active theme: every variant of the
/// button and the badge, the selection and range controls, and inline type.
///
/// The variant rows come from the recipes' own enums, so a variant added to a
/// recipe appears here without an edit.
class UiSpecimenCard extends StatefulWidget {
  const UiSpecimenCard({super.key});

  @override
  State<UiSpecimenCard> createState() => _UiSpecimenCardState();
}

class _UiSpecimenCardState extends State<UiSpecimenCard> {
  bool _switch = true;
  bool _checkbox = true;
  String _radio = 'matte';
  String _align = 'left';
  double _slider = 0.6;
  bool _loading = false;

  Future<void> _load() async {
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) => UiSurface(
    key: const ValueKey('themes-specimen'),
    size: .size3,
    child: ColumnBox(
      style: FlexBoxStyler()
          .crossAxisAlignment(.stretch)
          .spacing(UiTokens.space4()),
      children: [
        const UiCardHeader(
          title: 'Components in this theme',
          description: 'Operate them, then change the palette or the radius.',
        ),
        _Row(
          label: 'Buttons',
          children: [
            for (final variant in UiButtonVariant.values)
              UiButton(
                variant: variant,
                label: capitalize(variant.name),
                onPressed: () {},
              ),
            UiButton.soft(
              key: const ValueKey('specimen-loading'),
              label: 'Save',
              loading: _loading,
              onPressed: _load,
            ),
          ],
        ),
        _Row(
          label: 'Badges',
          children: [
            for (final variant in UiBadgeVariant.values)
              UiBadge(
                variant: variant,
                size: .size2,
                label: capitalize(variant.name),
              ),
            const UiAccentScope.error(
              child: UiBadge(size: .size2, highContrast: true, label: 'Error'),
            ),
          ],
        ),
        _Row(
          label: 'Selection',
          children: [
            UiSwitch(
              selected: _switch,
              semanticLabel: 'Sample switch',
              onChanged: (value) => setState(() => _switch = value),
            ),
            UiCheckbox(
              selected: _checkbox,
              semanticLabel: 'Sample checkbox',
              minimumTapTargetSize: Size.zero,
              onChanged: (value) => setState(() => _checkbox = value ?? false),
            ),
            RemixRadioGroup<String>(
              groupValue: _radio,
              onChanged: (value) {
                if (value != null) setState(() => _radio = value);
              },
              child: RowBox(
                style: FlexBoxStyler()
                    .mainAxisSize(.min)
                    .spacing(UiTokens.space2()),
                children: const [
                  UiRadio(value: 'matte', semanticLabel: 'Matte paper'),
                  UiRadio(value: 'gloss', semanticLabel: 'Gloss paper'),
                ],
              ),
            ),
            UiToggleGroup<String>(
              semanticLabel: 'Sample alignment',
              selectedValue: _align,
              items: const [
                RemixToggleGroupItem(
                  value: 'left',
                  icon: RemixIcons.alignLeft,
                  semanticLabel: 'Align left',
                ),
                RemixToggleGroupItem(
                  value: 'center',
                  icon: RemixIcons.alignCenter,
                  semanticLabel: 'Align center',
                ),
                RemixToggleGroupItem(
                  value: 'right',
                  icon: RemixIcons.alignRight,
                  semanticLabel: 'Align right',
                ),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _align = value);
              },
            ),
          ],
        ),
        _Row(
          label: 'Range',
          children: [
            Box(
              style: BoxStyler().width(200),
              child: UiSlider(
                value: _slider,
                semanticLabel: 'Sample slider',
                onChanged: (value) => setState(() => _slider = value),
              ),
            ),
            Box(
              style: BoxStyler().width(160),
              child: UiProgress(
                value: _slider,
                semanticsLabel: 'Sample progress',
              ),
            ),
            const UiSpinner(semanticsLabel: 'Sample spinner'),
          ],
        ),
        _Row(
          label: 'Inline',
          children: [
            UiKbd(uiQuickFindShortcut),
            const UiCode('uiButtonStyle()'),
            UiLink(
              'A link',
              size: .size2,
              onPressed: () => showRemixToast(
                context,
                const RemixToastData(
                  title: 'Link followed',
                  icon: RemixIcons.checkCircle,
                ),
              ),
            ),
            const UiText('Body text', size: .size2),
            StyledText(
              'Muted text',
              style: dashboardText(.size2, tone: .muted),
            ),
          ],
        ),
        const UiCallout(
          icon: RemixIcons.info,
          text: 'Every control here reads its colors from the active palette.',
        ),
      ],
    ),
  );
}

/// One labelled row of specimens that wraps when it runs out of width.
class _Row extends StatelessWidget {
  const _Row({required this.label, required this.children});

  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => ColumnBox(
    style: FlexBoxStyler()
        .crossAxisAlignment(.start)
        .spacing(UiTokens.space2()),
    children: [
      StyledText(
        label,
        style: dashboardText(.size1, weight: .medium, tone: .muted),
      ),
      WrapBox(
        style: WrapBoxStyler()
            .crossAxisAlignment(.center)
            .spacing(UiTokens.space3())
            .runSpacing(UiTokens.space3()),
        children: children,
      ),
    ],
  );
}
