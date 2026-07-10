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

// Styles are pure functions of (kind, size, loading); the full input space is
// 7 x 5 x 2 immutable stylers, so they are built once and shared.
final Map<(CarbonButtonKind, CarbonSize, bool), RemixButtonStyler> _styleCache =
    {};

/// Builds a Carbon-themed [RemixButtonStyler] for a [kind] and [size].
///
/// Consumes Carbon component and role tokens; resolves inside a `CarbonScope`.
/// Carbon buttons use square corners (radius 0) and the `body-compact-01` label
/// style. Heights come from the Carbon control-size scale.
///
/// Pass [loading] when the button renders a loading spinner: Remix folds
/// loading into the disabled widget-state, and a loading Carbon button keeps
/// its kind's colors (with a `textOnColor` spinner) instead of the disabled
/// gray treatment.
RemixButtonStyler carbonButtonStyle({
  CarbonButtonKind kind = CarbonButtonKind.primary,
  CarbonSize size = CarbonSize.lg,
  bool loading = false,
}) {
  final clamped = size.clampTo(CarbonSize.sm, CarbonSize.x2l);

  return _styleCache.putIfAbsent((kind, clamped, loading), () {
    final base = _carbonButtonBaseStyle(clamped);

    return switch (kind) {
      CarbonButtonKind.primary => _fillStyle(
          base,
          fill: CarbonComponentTokens.buttonPrimary,
          hover: CarbonComponentTokens.buttonPrimaryHover,
          active: CarbonComponentTokens.buttonPrimaryActive,
          loading: loading,
        ),
      CarbonButtonKind.secondary => _fillStyle(
          base,
          fill: CarbonComponentTokens.buttonSecondary,
          hover: CarbonComponentTokens.buttonSecondaryHover,
          active: CarbonComponentTokens.buttonSecondaryActive,
          loading: loading,
        ),
      CarbonButtonKind.danger => _fillStyle(
          base,
          fill: CarbonComponentTokens.buttonDangerPrimary,
          hover: CarbonComponentTokens.buttonDangerHover,
          active: CarbonComponentTokens.buttonDangerActive,
          loading: loading,
        ),
      CarbonButtonKind.tertiary => _outlineStyle(
          base,
          line: CarbonComponentTokens.buttonTertiary,
          hover: CarbonComponentTokens.buttonTertiaryHover,
          active: CarbonComponentTokens.buttonTertiaryActive,
          loading: loading,
        ),
      CarbonButtonKind.dangerTertiary => _outlineStyle(
          base,
          line: CarbonComponentTokens.buttonDangerSecondary,
          hover: CarbonComponentTokens.buttonDangerHover,
          active: CarbonComponentTokens.buttonDangerActive,
          loading: loading,
        ),
      CarbonButtonKind.ghost => _ghostStyle(
          base,
          text: CarbonTokens.linkPrimary,
          hoverFill: CarbonTokens.backgroundHover,
          hoverText: CarbonTokens.linkPrimaryHover,
          activeFill: CarbonTokens.backgroundActive,
          activeText: CarbonTokens.linkPrimaryHover,
          loading: loading,
        ),
      CarbonButtonKind.dangerGhost => _ghostStyle(
          base,
          text: CarbonComponentTokens.buttonDangerSecondary,
          hoverFill: CarbonComponentTokens.buttonDangerHover,
          hoverText: CarbonTokens.textOnColor,
          activeFill: CarbonComponentTokens.buttonDangerActive,
          activeText: CarbonTokens.textOnColor,
          loading: loading,
        ),
    };
  });
}

// Carbon buttons share height, padding, label typography and focus ring.
RemixButtonStyler _carbonButtonBaseStyle(CarbonSize size) {
  return RemixButtonStyler()
      .height(size.height)
      .paddingX(CarbonTokens.spacing05())
      .spacing(CarbonTokens.spacing03())
      // Carbon justifies label/icon to opposite edges when the button is
      // given a width; shrink-wrapped buttons are unaffected.
      .mainAxisAlignment(MainAxisAlignment.spaceBetween)
      .borderRadiusAll(Radius.zero)
      // Label consumes the body-compact-01 token, so upstream type changes and
      // the scope's fontFamily override flow through without hand-synced values.
      .label(TextStyler().style(CarbonTokens.bodyCompact01.mix()))
      .icon(IconStyler().size(CarbonTokens.iconSize01()))
      .spinner(
        RemixSpinnerStyle()
            .size(CarbonTokens.iconSize01())
            .strokeWidth(2.0),
      )
      // Carbon's focus ring is an inset box-shadow. Painting it as a
      // foreground-decoration border keeps layout stable (no padding change)
      // and leaves each kind's own border intact.
      .onFocused(
        RemixButtonStyler().foregroundDecoration(
          BoxDecorationMix(
            border: BoxBorderMix.all(
              BorderSideMix(color: CarbonTokens.focus(), width: 2.0),
            ),
          ),
        ),
      );
}

// Solid-fill kinds (primary, secondary, danger): white-on-color label.
RemixButtonStyler _fillStyle(
  RemixButtonStyler base, {
  required ColorToken fill,
  required ColorToken hover,
  required ColorToken active,
  required bool loading,
}) {
  // Loading buttons are non-interactive (Remix maps loading to the disabled
  // state) but keep their kind's fill with a textOnColor spinner.
  final disabledStyle = loading
      ? RemixButtonStyler()
          .color(fill())
          .spinner(RemixSpinnerStyle().indicatorColor(CarbonTokens.textOnColor()))
      : _disabledFill();

  return base
      .color(fill())
      .foregroundColor(CarbonTokens.textOnColor())
      .spinner(RemixSpinnerStyle().indicatorColor(CarbonTokens.textOnColor()))
      .onHovered(RemixButtonStyler().color(hover()))
      .onPressed(RemixButtonStyler().color(active()))
      .onDisabled(disabledStyle);
}

// Outline kinds (tertiary, danger tertiary): colored border + text, fills on hover.
RemixButtonStyler _outlineStyle(
  RemixButtonStyler base, {
  required ColorToken line,
  required ColorToken hover,
  required ColorToken active,
  required bool loading,
}) {
  final disabledStyle = loading
      ? RemixButtonStyler()
          .color(const Color(0x00000000))
          .borderAll(color: line(), width: 1.0)
          .spinner(RemixSpinnerStyle().indicatorColor(line()))
      : RemixButtonStyler()
          .color(const Color(0x00000000))
          .borderAll(color: CarbonTokens.borderDisabled(), width: 1.0)
          .foregroundColor(CarbonTokens.textDisabled());

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
      .onDisabled(disabledStyle);
}

// Ghost kinds: transparent, colored text, per-kind hover/active fills.
RemixButtonStyler _ghostStyle(
  RemixButtonStyler base, {
  required ColorToken text,
  required ColorToken hoverFill,
  required ColorToken hoverText,
  required ColorToken activeFill,
  required ColorToken activeText,
  required bool loading,
}) {
  final disabledStyle = loading
      ? RemixButtonStyler()
          .spinner(RemixSpinnerStyle().indicatorColor(text()))
      : RemixButtonStyler().foregroundColor(CarbonTokens.textDisabled());

  return base
      .color(const Color(0x00000000))
      .foregroundColor(text())
      .spinner(RemixSpinnerStyle().indicatorColor(text()))
      .onHovered(
        RemixButtonStyler().color(hoverFill()).foregroundColor(hoverText()),
      )
      .onPressed(
        RemixButtonStyler().color(activeFill()).foregroundColor(activeText()),
      )
      .onDisabled(disabledStyle);
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
/// contextual size from an enclosing `CarbonLayoutScope`; without one it uses
/// Carbon's default button size (`lg`, 48px). Either way the size is clamped to
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

  /// Explicit size; when null, inherits from `CarbonLayoutScope` or defaults
  /// to Carbon's `lg`.
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
    final effectiveSize = size ??
        CarbonLayoutScope.maybeOf(context)?.size ??
        CarbonSize.lg;

    return carbonButtonStyle(
      kind: kind,
      size: effectiveSize,
      loading: loading,
    ).call(
      label: label,
      trailingIcon: icon,
      loading: loading,
      enabled: enabled,
      enableFeedback: enableFeedback,
      onPressed: onPressed,
      focusNode: focusNode,
      autofocus: autofocus,
      semanticLabel: semanticLabel,
    );
  }
}
