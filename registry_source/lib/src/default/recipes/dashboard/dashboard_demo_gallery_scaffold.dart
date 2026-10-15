import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../components/card.dart';
import '../../theme/tokens.dart';

class VanillaGalleryPage extends StatelessWidget {
  const VanillaGalleryPage({
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
            VanillaGalleryHeading(
              title,
              token: VanillaTokens.text3xl,
              weight: FontWeight.w700,
            ),
            VanillaGalleryText(intro, muted: true),
          ],
        ),
        ...sections,
      ],
    ),
  );
}

class VanillaGallerySection extends StatelessWidget {
  const VanillaGallerySection({
    super.key,
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
            VanillaGalleryHeading(
              label,
              token: VanillaTokens.textLg,
              weight: FontWeight.w600,
            ),
            VanillaGalleryText(description, muted: true),
          ],
        ),
        child,
      ],
    ),
  );
}

class VanillaGalleryMatrix<R, C> extends StatelessWidget {
  const VanillaGalleryMatrix({
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
              child: const VanillaGalleryText('', muted: true),
            ),
            for (final column in columns)
              _MatrixCell(
                divider: divider,
                hasLeadingDivider: true,
                child: VanillaGalleryText(
                  columnLabelBuilder(column),
                  muted: true,
                ),
              ),
            for (final row in rows) ...[
              _MatrixCell(
                divider: divider,
                hasTopDivider: true,
                alignment: Alignment.centerLeft,
                child: VanillaGalleryText(rowLabelBuilder(row), muted: true),
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

class VanillaGalleryEnumMatrix<R extends Enum, C extends Enum>
    extends VanillaGalleryMatrix<R, C> {
  const VanillaGalleryEnumMatrix({
    super.key,
    required super.rows,
    required super.columns,
    required super.cellBuilder,
    super.cellWidth,
  }) : super(
         rowLabelBuilder: vanillaGalleryEnumLabel,
         columnLabelBuilder: vanillaGalleryEnumLabel,
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

class VanillaGalleryText extends StatelessWidget {
  const VanillaGalleryText(
    this.value, {
    super.key,
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

class VanillaGalleryHeading extends VanillaGalleryText {
  const VanillaGalleryHeading(
    super.value, {
    super.key,
    super.token = VanillaTokens.textLg,
    super.weight = FontWeight.w600,
  });
}

String vanillaGalleryEnumLabel(Enum value) {
  final name = value.name;
  return '${name[0].toUpperCase()}${name.substring(1)}';
}

void showVanillaGalleryToast(BuildContext context, String title) =>
    showRemixToast(
      context,
      RemixToastData(title: title, icon: RemixIcons.checkCircled),
    );
