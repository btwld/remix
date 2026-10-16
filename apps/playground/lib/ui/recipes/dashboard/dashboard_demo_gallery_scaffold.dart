import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../components/card.dart';
import '../../theme/tokens.dart';

class PlaygroundGalleryPage extends StatelessWidget {
  const PlaygroundGalleryPage({
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
    padding: const EdgeInsets.all(PlaygroundTokens.s8),
    child: ColumnBox(
      style: FlexBoxStyler()
          .crossAxisAlignment(.stretch)
          .spacing(PlaygroundTokens.s5),
      children: [
        ColumnBox(
          style: FlexBoxStyler()
              .crossAxisAlignment(.start)
              .spacing(PlaygroundTokens.s1_5),
          children: [
            PlaygroundGalleryHeading(
              title,
              token: PlaygroundTokens.text3xl,
              weight: FontWeight.w700,
            ),
            PlaygroundGalleryText(intro, muted: true),
          ],
        ),
        ...sections,
      ],
    ),
  );
}

class PlaygroundGallerySection extends StatelessWidget {
  const PlaygroundGallerySection({
    super.key,
    required this.label,
    required this.description,
    required this.child,
  });

  final String label;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) => PlaygroundCard(
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
            PlaygroundGalleryHeading(
              label,
              token: PlaygroundTokens.textLg,
              weight: FontWeight.w600,
            ),
            PlaygroundGalleryText(description, muted: true),
          ],
        ),
        child,
      ],
    ),
  );
}

class PlaygroundGalleryMatrix<R, C> extends StatelessWidget {
  const PlaygroundGalleryMatrix({
    super.key,
    required this.rows,
    required this.columns,
    required this.rowLabelBuilder,
    required this.columnLabelBuilder,
    required this.cellBuilder,
    this.cellWidth = 190,
  });

  final List<R> rows;
  final List<C> columns;
  final String Function(R value) rowLabelBuilder;
  final String Function(C value) columnLabelBuilder;
  final Widget Function(BuildContext context, R row, C column) cellBuilder;
  final double cellWidth;

  @override
  Widget build(BuildContext context) {
    final divider = BorderSideMix(
      color: PlaygroundTokens.border(),
      width: PlaygroundTokens.strokeHairline,
    );
    final borderRadius = BorderRadiusMix.all(PlaygroundTokens.radiusMd());
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
              child: const PlaygroundGalleryText('', muted: true),
            ),
            for (final column in columns)
              _MatrixCell(
                divider: divider,
                hasLeadingDivider: true,
                child: PlaygroundGalleryText(
                  columnLabelBuilder(column),
                  muted: true,
                ),
              ),
            for (final row in rows) ...[
              _MatrixCell(
                divider: divider,
                hasTopDivider: true,
                alignment: Alignment.centerLeft,
                child: PlaygroundGalleryText(rowLabelBuilder(row), muted: true),
              ),
              for (final column in columns)
                _MatrixCell(
                  divider: divider,
                  hasLeadingDivider: true,
                  hasTopDivider: true,
                  child: cellBuilder(context, row, column),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class PlaygroundGalleryEnumMatrix<R extends Enum, C extends Enum>
    extends PlaygroundGalleryMatrix<R, C> {
  const PlaygroundGalleryEnumMatrix({
    super.key,
    required super.rows,
    required super.columns,
    required super.cellBuilder,
    super.cellWidth,
  }) : super(
         rowLabelBuilder: playgroundGalleryEnumLabel,
         columnLabelBuilder: playgroundGalleryEnumLabel,
       );
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
        .padding(.all(PlaygroundTokens.s2_5))
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

class PlaygroundGalleryText extends StatelessWidget {
  const PlaygroundGalleryText(
    this.value, {
    super.key,
    this.token = PlaygroundTokens.textSm,
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
          muted
              ? PlaygroundTokens.mutedForeground()
              : PlaygroundTokens.foreground(),
        );
    if (maxLines != null) style = style.maxLines(maxLines!);
    if (overflow != null) style = style.overflow(overflow!);
    return StyledText(value, style: style);
  }
}

class PlaygroundGalleryHeading extends PlaygroundGalleryText {
  const PlaygroundGalleryHeading(
    super.value, {
    super.key,
    super.token = PlaygroundTokens.textLg,
    super.weight = FontWeight.w600,
  });
}

String playgroundGalleryEnumLabel(Enum value) {
  final name = value.name;
  return '${name[0].toUpperCase()}${name.substring(1)}';
}

void showPlaygroundGalleryToast(BuildContext context, String title) =>
    showRemixToast(
      context,
      RemixToastData(title: title, icon: RemixIcons.checkCircled),
    );

/// Disclosure trigger row with an animated rotating chevron.
class PlaygroundDisclosureTrigger extends StatelessWidget {
  const PlaygroundDisclosureTrigger({
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
            .animate(PlaygroundTokens.motion),
        child: StyledIcon(
          icon: RemixIcons.chevronDown,
          style: IconStyler()
              .size(PlaygroundTokens.icon)
              .color(PlaygroundTokens.mutedForeground()),
        ),
      ),
    ],
  );
}
