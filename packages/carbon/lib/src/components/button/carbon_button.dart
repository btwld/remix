import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../../foundation/carbon_layout_scope.dart';
import '../../tokens/generated/carbon_tokens.g.dart';
import '../../tokens/generated/carbon_component_tokens.g.dart';

/// Carbon button kinds.
///
/// Mirrors Carbon's button variants rather than Fortal/Remix naming. See the
/// worksheet at `specs/components/button.yaml`.
enum CarbonButtonKind {
  primary,
  secondary,
  tertiary,
  ghost,
  danger,
  dangerTertiary,
  dangerGhost,
}

/// Builds a Carbon-themed [RemixButtonStyler] for a [kind] and [size].
///
/// Consumes Carbon component and role tokens; resolves inside a `CarbonScope`.
/// Carbon buttons use square corners (radius 0) and the `body-compact-01` label
/// style. Heights come from the Carbon control-size scale.
RemixButtonStyler carbonButtonStyle({
  CarbonButtonKind kind = CarbonButtonKind.primary,
  CarbonSize size = CarbonSize.lg,
}) {
  final clamped = size.clampTo(CarbonSize.sm, CarbonSize.x2l);
  final base = _carbonButtonBaseStyle(clamped);

  return switch (kind) {
    CarbonButtonKind.primary => _fillStyle(
        base,
        fill: CarbonComponentTokens.buttonPrimary,
        hover: CarbonComponentTokens.buttonPrimaryHover,
        active: CarbonComponentTokens.buttonPrimaryActive,
      ),
    CarbonButtonKind.secondary => _fillStyle(
        base,
        fill: CarbonComponentTokens.buttonSecondary,
        hover: CarbonComponentTokens.buttonSecondaryHover,
        active: CarbonComponentTokens.buttonSecondaryActive,
      ),
    CarbonButtonKind.danger => _fillStyle(
        base,
        fill: CarbonComponentTokens.buttonDangerPrimary,
        hover: CarbonComponentTokens.buttonDangerHover,
        active: CarbonComponentTokens.buttonDangerActive,
      ),
    CarbonButtonKind.tertiary => _outlineStyle(
        base,
        line: CarbonComponentTokens.buttonTertiary,
        hover: CarbonComponentTokens.buttonTertiaryHover,
        active: CarbonComponentTokens.buttonTertiaryActive,
      ),
    CarbonButtonKind.dangerTertiary => _outlineStyle(
        base,
        line: CarbonComponentTokens.buttonDangerSecondary,
        hover: CarbonComponentTokens.buttonDangerHover,
        active: CarbonComponentTokens.buttonDangerActive,
      ),
    CarbonButtonKind.ghost => _ghostStyle(
        base,
        text: CarbonTokens.linkPrimary,
        textHover: CarbonTokens.linkPrimaryHover,
      ),
    CarbonButtonKind.dangerGhost => _ghostStyle(
        base,
        text: CarbonComponentTokens.buttonDangerSecondary,
        textHover: CarbonComponentTokens.buttonDangerSecondary,
        hoverFill: CarbonComponentTokens.buttonDangerHover,
        hoverText: CarbonTokens.textOnColor,
      ),
  };
}

// Carbon buttons share height, padding, label typography and focus ring.
RemixButtonStyler _carbonButtonBaseStyle(CarbonSize size) {
  return RemixButtonStyler()
      .height(size.height)
      .paddingX(CarbonTokens.spacing05())
      .spacing(CarbonTokens.spacing03())
      .mainAxisAlignment(MainAxisAlignment.spaceBetween)
      .borderRadiusAll(Radius.zero)
      .label(_labelStyler())
      .icon(IconStyler().size(CarbonTokens.iconSize01()))
      .spinner(
        RemixSpinnerStyle()
            .size(CarbonTokens.iconSize01())
            .strokeWidth(2.0),
      )
      // Carbon focus is a 2px `focus`-colored ring (approximated with a border).
      .onFocused(
        RemixButtonStyler().borderAll(color: CarbonTokens.focus(), width: 2.0),
      );
}

// Solid-fill kinds (primary, secondary, danger): white-on-color label.
RemixButtonStyler _fillStyle(
  RemixButtonStyler base, {
  required ColorToken fill,
  required ColorToken hover,
  required ColorToken active,
}) {
  return base
      .color(fill())
      .foregroundColor(CarbonTokens.textOnColor())
      .spinner(RemixSpinnerStyle().indicatorColor(CarbonTokens.textOnColor()))
      .onHovered(RemixButtonStyler().color(hover()))
      .onPressed(RemixButtonStyler().color(active()))
      .onDisabled(_disabledFill());
}

// Outline kinds (tertiary, danger tertiary): colored border + text, fills on hover.
RemixButtonStyler _outlineStyle(
  RemixButtonStyler base, {
  required ColorToken line,
  required ColorToken hover,
  required ColorToken active,
}) {
  return base
      .color(const Color(0x00000000))
      .borderAll(color: line(), width: 1.0)
      .foregroundColor(line())
      .spinner(RemixSpinnerStyle().indicatorColor(line()))
      .onHovered(
        RemixButtonStyler()
            .color(hover())
            .foregroundColor(CarbonTokens.textOnColor()),
      )
      .onPressed(
        RemixButtonStyler()
            .color(active())
            .foregroundColor(CarbonTokens.textOnColor()),
      )
      .onDisabled(
        RemixButtonStyler()
            .color(const Color(0x00000000))
            .borderAll(color: CarbonTokens.borderDisabled(), width: 1.0)
            .foregroundColor(CarbonTokens.textDisabled()),
      );
}

// Ghost kinds: transparent, colored text, subtle hover fill.
RemixButtonStyler _ghostStyle(
  RemixButtonStyler base, {
  required ColorToken text,
  required ColorToken textHover,
  ColorToken? hoverFill,
  ColorToken? hoverText,
}) {
  return base
      .color(const Color(0x00000000))
      .foregroundColor(text())
      .spinner(RemixSpinnerStyle().indicatorColor(text()))
      .onHovered(
        RemixButtonStyler()
            .color((hoverFill ?? CarbonTokens.backgroundHover)())
            .foregroundColor((hoverText ?? textHover)()),
      )
      .onPressed(RemixButtonStyler().color(CarbonTokens.backgroundActive()))
      .onDisabled(
        RemixButtonStyler().foregroundColor(CarbonTokens.textDisabled()),
      );
}

RemixButtonStyler _disabledFill() {
  return RemixButtonStyler()
      .color(CarbonComponentTokens.buttonDisabled())
      .foregroundColor(CarbonTokens.textOnColorDisabled())
      .spinner(
        RemixSpinnerStyle()
            .indicatorColor(CarbonTokens.textOnColorDisabled())
            .strokeWidth(1.0),
      );
}

// Carbon buttons use the body-compact-01 label style (14px / 400 / 0.16 tracking).
TextStyler _labelStyler() {
  return TextStyler()
      .fontSize(14.0)
      .height(18.0 / 14.0)
      .letterSpacing(0.16)
      .fontWeight(FontWeight.w400);
}

/// A Carbon button.
///
/// ```dart
/// CarbonButton(
///   label: 'Save',
///   kind: CarbonButtonKind.primary,
///   onPressed: () {},
/// )
/// ```
///
/// Resolve inside a `CarbonScope`. When [size] is null, the button inherits the
/// contextual size from a `CarbonLayoutScope` (defaulting to `lg`), clamped to
/// the range Carbon buttons support (`sm`–`2xl`).
class CarbonButton extends StatelessWidget {
  const CarbonButton({
    super.key,
    required this.label,
    this.kind = CarbonButtonKind.primary,
    this.size,
    this.icon,
    this.loading = false,
    this.enabled = true,
    this.enableFeedback = true,
    required this.onPressed,
    this.focusNode,
    this.autofocus = false,
    this.semanticLabel,
  });

  /// Button text.
  final String label;

  /// Carbon button kind.
  final CarbonButtonKind kind;

  /// Explicit size; inherits the contextual `CarbonLayoutScope` size when null.
  final CarbonSize? size;

  /// Optional trailing icon (Carbon places button icons after the label).
  final IconData? icon;

  /// Whether to show a loading spinner in place of interaction.
  final bool loading;

  /// Whether the button is enabled.
  final bool enabled;

  final bool enableFeedback;

  /// Pressed callback. A null callback also renders the button as disabled.
  final VoidCallback? onPressed;

  final FocusNode? focusNode;

  final bool autofocus;

  /// Overrides the accessible label (defaults to [label]).
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final effectiveSize = size ?? CarbonLayoutScope.of(context).size;

    return carbonButtonStyle(kind: kind, size: effectiveSize).call(
      label: label,
      trailingIcon: icon,
      loading: loading,
      enabled: enabled && onPressed != null,
      enableFeedback: enableFeedback,
      onPressed: onPressed,
      focusNode: focusNode,
      autofocus: autofocus,
      semanticLabel: semanticLabel,
    );
  }
}
