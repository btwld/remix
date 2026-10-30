import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';
import 'typography.dart';

/// Fortal Kbd variants.
enum FortalKbdVariant { soft }

/// Fortal-themed keyboard key.
///
BadgeStyler fortalKbdStyle(
  BuildContext context, {
  FortalTextSize? size,
  FortalKbdVariant variant = .soft,
  BadgeStyler style = const BadgeStyler.create(),
}) {
  final base = fortalResolveTextToken(context, size ?? FortalTextSize.size3);
  final fontSize = base.fontSize! * (size == null ? 0.75 : 0.8);
  final letterSpacing = (base.letterSpacing ?? 0) * (size == null ? 1 : 0.8);

  // Kbd pins its own weight and line box regardless of the surrounding style,
  // so it stays a key cap rather than following surrounding copy.
  final textStyle = TextStyler()
      .style(
        TextStyleMix(
          fontFamily: base.fontFamily,
          fontFamilyFallback: base.fontFamilyFallback,
        ),
      )
      .fontSize(fontSize)
      .fontWeight(FortalTokens.fontWeightRegular())
      .height(1.7)
      .letterSpacing(letterSpacing)
      .wordSpacing(-0.1 * fontSize)
      .textAlign(TextAlign.center)
      .softWrap(false)
      .maxLines(1)
      .color(FortalTokens.gray12())
      .inherit(false);

  final recipe = BadgeStyler()
      .label(textStyle)
      .minWidth(1.75 * fontSize)
      .padding(.horizontal(0.5 * fontSize).bottom(0.05 * fontSize))
      .borderRadius(
        BorderRadiusGeometryMix.circular(
          0.35 * fontSize * fortalRadiusFactor(context),
        ),
      )
      .color(switch (variant) {
        .soft => fortalResolveColor(context, FortalTokens.grayA3),
      });

  return recipe.merge(style);
}

/// Token-backed representation of one keyboard key or shortcut.
///
class FortalKbd extends StatelessWidget {
  const FortalKbd(
    this.text, {
    super.key,
    this.size,
    this.variant = FortalKbdVariant.soft,
    this.semanticLabel,
    this.excludeSemantics = false,
    this.style = const BadgeStyler.create(),
  }) : assert(text != ''),
       assert(semanticLabel == null || semanticLabel != '');

  const FortalKbd.soft(
    this.text, {
    super.key,
    this.size,
    this.semanticLabel,
    this.excludeSemantics = false,
    this.style = const BadgeStyler.create(),
  }) : variant = FortalKbdVariant.soft,
       assert(text != ''),
       assert(semanticLabel == null || semanticLabel != '');

  final String text;
  final FortalTextSize? size;
  final FortalKbdVariant variant;
  final String? semanticLabel;
  final bool excludeSemantics;
  final BadgeStyler style;

  @override
  Widget build(BuildContext context) {
    final content = fortalKbdStyle(
      context,
      size: size,
      variant: variant,
      style: style,
    )(label: text);

    if (excludeSemantics) return ExcludeSemantics(child: content);

    return Semantics(
      keyboardKey: true,
      label: semanticLabel ?? text,
      excludeSemantics: true,
      child: content,
    );
  }
}
