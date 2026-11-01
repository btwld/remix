import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_fonts/remix_ui_fonts.dart';

import '../theme/theme.dart';

/// HeroUI's text styles: six headings, three body sizes, and inline `code`.
enum HeroUiTypographyType { h1, h2, h3, h4, h5, h6, body, bodySm, bodyXs, code }

/// The text colour: `foreground`, or `muted` for secondary copy.
enum HeroUiTypographyColor { defaultColor, muted }

/// An explicit font weight, replacing the type's own.
enum HeroUiTypographyWeight { normal, medium, semibold, bold }

/// HeroUI's `Typography`, `Heading`, `Paragraph`, and `Code` in one widget.
///
/// Prose, which styles HTML descendants, has no counterpart: compose
/// headings, paragraphs, and code explicitly.
class HeroUiTypography extends StatelessWidget {
  const HeroUiTypography(
    this.text, {
    super.key,
    this.type = .body,
    this.align = TextAlign.start,
    this.color = .defaultColor,
    this.weight,
    this.truncate = false,
    this.style = const TextStyler.create(),
  });

  final String text;
  final HeroUiTypographyType type;
  final TextAlign align;
  final HeroUiTypographyColor color;

  /// Overrides the type's weight: semibold for headings, normal otherwise.
  final HeroUiTypographyWeight? weight;

  /// Keeps one line and ends it with an ellipsis.
  final bool truncate;

  final TextStyler style;

  @override
  Widget build(BuildContext context) {
    final metrics = _metrics(type);
    var result = TextStyler()
        .style(metrics.base.mix())
        .fontSize(metrics.fontSize)
        .height(metrics.lineHeight / metrics.fontSize)
        .fontWeight(switch (weight) {
          .normal => FontWeight.w400,
          .medium => FontWeight.w500,
          .semibold => FontWeight.w600,
          .bold => FontWeight.w700,
          null => metrics.heading ? FontWeight.w600 : FontWeight.w400,
        })
        .textAlign(align)
        .color(
          (color == .muted ? HeroUiTokens.muted : HeroUiTokens.foreground)(),
        );
    if (metrics.heading) {
      result = result.letterSpacing(_tracking * metrics.fontSize);
    }
    // CanvasKit does not resolve the CSS `monospace` family, so code carries a
    // real fixed-width face.
    if (type == .code) result = result.fontFamily(RemixFonts.geistMono);
    if (truncate) {
      result = result
          .maxLines(1)
          .softWrap(false)
          .overflow(TextOverflow.ellipsis);
    }

    final label = StyledText(text, style: result.merge(style));
    if (type != .code) return label;
    return Box(
      style: BoxStyler()
          .padding(
            .symmetric(horizontal: _codePaddingX, vertical: _codePaddingY),
          )
          .borderRadius(.all(HeroUiTokens.radiusMd()))
          .color(HeroUiTokens.defaultColor()),
      child: label,
    );
  }
}

typedef _Metrics = ({
  TextStyleToken base,
  double fontSize,
  double lineHeight,
  bool heading,
});

/// Tailwind's text scale as the typography classes use it: `text-4xl` through
/// `text-base` for headings, `leading-7` / `-6` / `-5` for the body sizes.
_Metrics _metrics(HeroUiTypographyType type) => switch (type) {
  .h1 => (
    base: HeroUiTokens.textBase,
    fontSize: 36,
    lineHeight: 40,
    heading: true,
  ),
  .h2 => (
    base: HeroUiTokens.textBase,
    fontSize: 30,
    lineHeight: 36,
    heading: true,
  ),
  .h3 => (
    base: HeroUiTokens.textBase,
    fontSize: 24,
    lineHeight: 32,
    heading: true,
  ),
  .h4 => (
    base: HeroUiTokens.textBase,
    fontSize: 20,
    lineHeight: 28,
    heading: true,
  ),
  .h5 => (
    base: HeroUiTokens.textBase,
    fontSize: 18,
    lineHeight: 28,
    heading: true,
  ),
  .h6 => (
    base: HeroUiTokens.textBase,
    fontSize: 16,
    lineHeight: 24,
    heading: true,
  ),
  .body => (
    base: HeroUiTokens.textBase,
    fontSize: 16,
    lineHeight: 28,
    heading: false,
  ),
  .bodySm => (
    base: HeroUiTokens.textSm,
    fontSize: 14,
    lineHeight: 24,
    heading: false,
  ),
  .bodyXs => (
    base: HeroUiTokens.textXs,
    fontSize: 12,
    lineHeight: 20,
    heading: false,
  ),
  .code => (
    base: HeroUiTokens.textSm,
    fontSize: 14,
    lineHeight: 20,
    heading: false,
  ),
};

/// `tracking-tight`, in em.
const _tracking = -0.025;

/// `code`: `px-1.5 py-0.5`.
const _codePaddingX = 6.0;
const _codePaddingY = 2.0;
