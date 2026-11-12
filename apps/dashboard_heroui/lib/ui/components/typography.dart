import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_fonts/remix_ui_fonts.dart';

import '../theme/theme.dart';

/// HeroUI's text styles: six headings, three body sizes, and inline `code`.
enum UiTypographyType {
  /// A heading, 36px on 40px.
  h1,

  /// A heading, 30px on 36px.
  h2,

  /// A heading, 24px on 32px.
  h3,

  /// A heading, 20px on 28px.
  h4,

  /// A heading, 18px on 28px.
  h5,

  /// A heading, 16px on 24px.
  h6,

  /// Body text, 16px on 28px. The default.
  body,

  /// Small body text, 14px on 24px.
  bodySm,

  /// Extra small body text, 12px on 20px.
  bodyXs,

  /// Inline code: 14px monospace on a `default` chip.
  code,
}

/// The text color.
enum UiTypographyColor {
  /// The `foreground` color.
  defaultColor,

  /// The `muted` color, for secondary copy.
  muted,
}

/// An explicit font weight, replacing the type's own.
enum UiTypographyWeight {
  /// Regular, 400.
  normal,

  /// Medium, 500.
  medium,

  /// Semibold, 600.
  semibold,

  /// Bold, 700.
  bold,
}

/// HeroUI's `Typography`, `Heading`, `Paragraph`, and `Code` in one widget.
///
/// Prose, which styles HTML descendants, has no counterpart: compose
/// headings, paragraphs, and code explicitly.
class UiTypography extends StatelessWidget {
  const UiTypography(
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
  final UiTypographyType type;
  final TextAlign align;
  final UiTypographyColor color;

  /// Overrides the type's weight: semibold for headings, normal otherwise.
  final UiTypographyWeight? weight;

  /// Keeps one line and ends it with an ellipsis.
  final bool truncate;

  final TextStyler style;

  @override
  Widget build(BuildContext context) {
    final metrics = _metrics(type);
    final heading = switch (type) {
      .h1 || .h2 || .h3 || .h4 || .h5 || .h6 => true,
      .body || .bodySm || .bodyXs || .code => false,
    };
    final result = TextStyler()
        .style(metrics.base.mix())
        .fontSize(metrics.fontSize)
        .height(metrics.lineHeight / metrics.fontSize)
        .fontWeight(switch (weight) {
          .normal => FontWeight.w400,
          .medium => FontWeight.w500,
          .semibold => FontWeight.w600,
          .bold => FontWeight.w700,
          null => heading ? FontWeight.w600 : FontWeight.w400,
        })
        .textAlign(align)
        .color((color == .muted ? UiTokens.muted : UiTokens.foreground)())
        .merge(
          heading
              ? TextStyler().letterSpacing(_tracking * metrics.fontSize)
              : null,
        )
        // CanvasKit does not resolve the CSS `monospace` family, so code
        // carries a real fixed-width face.
        .merge(
          type == .code ? TextStyler().fontFamily(RemixFonts.geistMono) : null,
        )
        .merge(
          truncate
              ? TextStyler()
                    .maxLines(1)
                    .softWrap(false)
                    .overflow(TextOverflow.ellipsis)
              : null,
        );

    final label = StyledText(text, style: result.merge(style));
    if (type != .code) return label;
    return Box(
      style: BoxStyler()
          .padding(
            .symmetric(horizontal: _codePaddingX, vertical: _codePaddingY),
          )
          .borderRadius(.all(UiTokens.radiusMd()))
          .color(UiTokens.defaultColor()),
      child: label,
    );
  }
}

typedef _Metrics = ({TextStyleToken base, double fontSize, double lineHeight});

/// Tailwind's text scale as the typography classes use it: `text-4xl` through
/// `text-base` for headings, `leading-7` / `-6` / `-5` for the body sizes.
_Metrics _metrics(UiTypographyType type) => switch (type) {
  .h1 => (base: UiTokens.textBase, fontSize: 36, lineHeight: 40),
  .h2 => (base: UiTokens.textBase, fontSize: 30, lineHeight: 36),
  .h3 => (base: UiTokens.textBase, fontSize: 24, lineHeight: 32),
  .h4 => (base: UiTokens.textBase, fontSize: 20, lineHeight: 28),
  .h5 => (base: UiTokens.textBase, fontSize: 18, lineHeight: 28),
  .h6 => (base: UiTokens.textBase, fontSize: 16, lineHeight: 24),
  .body => (base: UiTokens.textBase, fontSize: 16, lineHeight: 28),
  .bodySm => (base: UiTokens.textSm, fontSize: 14, lineHeight: 24),
  .bodyXs => (base: UiTokens.textXs, fontSize: 12, lineHeight: 20),
  .code => (base: UiTokens.textSm, fontSize: 14, lineHeight: 20),
};

/// `tracking-tight`, in em.
const _tracking = -0.025;

/// `code`: `px-1.5 py-0.5`.
const _codePaddingX = 6.0;
const _codePaddingY = 2.0;
