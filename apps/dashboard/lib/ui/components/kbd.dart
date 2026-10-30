import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';
import 'typography.dart';

/// Ui Kbd variants.
enum UiKbdVariant { soft }

/// Ui-themed keyboard key.
///
BadgeStyler uiKbdStyle(
  BuildContext context, {
  UiTextSize? size,
  UiKbdVariant variant = .soft,
  BadgeStyler style = const BadgeStyler.create(),
}) {
  final base = uiResolveTextToken(context, size ?? UiTextSize.size3);
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
      .fontWeight(UiTokens.fontWeightRegular())
      .height(1.7)
      .letterSpacing(letterSpacing)
      .wordSpacing(-0.1 * fontSize)
      .textAlign(TextAlign.center)
      .softWrap(false)
      .maxLines(1)
      .color(UiTokens.gray12())
      .inherit(false);

  var recipe = BadgeStyler()
      .label(textStyle)
      .minWidth(1.75 * fontSize)
      .padding(.horizontal(0.5 * fontSize).bottom(0.05 * fontSize))
      .borderRadius(
        BorderRadiusGeometryMix.circular(
          0.35 * fontSize * uiRadiusFactor(context),
        ),
      )
      .color(switch (variant) {
        .soft => uiResolveColor(context, UiTokens.grayA3),
      });

  return recipe.merge(style);
}

/// Token-backed representation of one keyboard key or shortcut.
///
class UiKbd extends StatelessWidget {
  const UiKbd(
    this.text, {
    super.key,
    this.size,
    this.variant = UiKbdVariant.soft,
    this.semanticLabel,
    this.excludeSemantics = false,
    this.style = const BadgeStyler.create(),
  }) : assert(text != ''),
       assert(semanticLabel == null || semanticLabel != '');

  const UiKbd.soft(
    this.text, {
    super.key,
    this.size,
    this.semanticLabel,
    this.excludeSemantics = false,
    this.style = const BadgeStyler.create(),
  }) : variant = UiKbdVariant.soft,
       assert(text != ''),
       assert(semanticLabel == null || semanticLabel != '');

  final String text;
  final UiTextSize? size;
  final UiKbdVariant variant;
  final String? semanticLabel;
  final bool excludeSemantics;
  final BadgeStyler style;

  @override
  Widget build(BuildContext context) {
    final content = uiKbdStyle(
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
