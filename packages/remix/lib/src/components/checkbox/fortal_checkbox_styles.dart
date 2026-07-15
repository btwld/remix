part of 'checkbox.dart';

/// Fortal checkbox size presets.
enum FortalCheckboxSize {
  /// Compact checkbox.
  size1,

  /// Default checkbox.
  size2,

  /// Large checkbox.
  size3,
}

/// Fortal checkbox color variants.
enum FortalCheckboxVariant {
  /// Surface treatment with neutral border.
  surface,

  /// Soft accent treatment.
  soft,
}

/// Fortal-themed preset for [RemixCheckbox].
RemixCheckboxStyler fortalCheckboxStyler({
  FortalCheckboxVariant variant = .surface,
  FortalCheckboxSize size = .size2,
}) {
  return switch (variant) {
    .surface => _fortalCheckboxSurfaceStyler(size),
    .soft => _fortalCheckboxSoftStyler(size),
  };
}

RemixCheckboxStyler _fortalCheckboxBaseStyler(FortalCheckboxSize size) {
  return RemixCheckboxStyler()
      .onFocused(
        RemixCheckboxStyler().borderAll(
          color: FortalTokens.focusA8(),
          width: FortalTokens.focusRingWidth(),
        ),
      )
      .merge(_fortalCheckboxSizeStyler(size));
}

RemixCheckboxStyler _fortalCheckboxSurfaceStyler([
  FortalCheckboxSize size = .size2,
]) {
  return _fortalCheckboxBaseStyler(size)
      .borderAll(
        color: FortalTokens.gray6(),
        width: FortalTokens.borderWidth1(),
      )
      .borderRadiusAll(FortalTokens.radius2())
      .indicatorColor(FortalTokens.accent9())
      .onSelected(
        RemixCheckboxStyler()
            .fillColor(FortalTokens.accent9())
            .borderAll(
              color: FortalTokens.accent9(),
              width: FortalTokens.borderWidth1(),
            )
            .indicatorColor(FortalTokens.accentContrast()),
      )
      .onDisabled(
        RemixCheckboxStyler()
            .fillColor(FortalTokens.grayA3())
            .borderAll(
              color: FortalTokens.gray7(),
              width: FortalTokens.borderWidth1(),
            )
            .indicatorColor(FortalTokens.gray8()),
      );
}

RemixCheckboxStyler _fortalCheckboxSoftStyler([
  FortalCheckboxSize size = .size2,
]) {
  return _fortalCheckboxBaseStyler(size)
      .fillColor(FortalTokens.accentA4())
      .borderRadiusAll(FortalTokens.radius2())
      .onSelected(
        RemixCheckboxStyler().indicatorColor(FortalTokens.accentA11()),
      )
      .onDisabled(
        RemixCheckboxStyler()
            .fillColor(FortalTokens.grayA3())
            .indicatorColor(FortalTokens.gray8()),
      );
}

RemixCheckboxStyler _fortalCheckboxSizeStyler(FortalCheckboxSize size) {
  return switch (size) {
    .size1 => RemixCheckboxStyler(
      container: BoxStyler()
          .width(FortalTokens.space4())
          .height(FortalTokens.space4()),
      indicator: IconStyler().size(FortalTokens.space3()),
    ),
    .size2 => RemixCheckboxStyler(
      container: BoxStyler()
          .width(FortalTokens.space5())
          .height(FortalTokens.space5()),
      indicator: IconStyler().size(FortalTokens.space4()),
    ),
    .size3 => RemixCheckboxStyler(
      container: BoxStyler()
          .width(FortalTokens.space6())
          .height(FortalTokens.space6()),
      indicator: IconStyler().size(FortalTokens.space5()),
    ),
  };
}

/// Fortal-themed preset for [RemixCheckbox].
class FortalCheckbox extends StatelessWidget {
  const FortalCheckbox({
    super.key,
    this.variant = .surface,
    this.size = .size2,
    required this.selected,
    this.onChanged,
    this.enabled = true,
    this.tristate = false,
    this.checkedIcon = Icons.check_rounded,
    this.uncheckedIcon,
    this.indeterminateIcon = Icons.horizontal_rule,
    this.focusNode,
    this.autofocus = false,
    this.enableFeedback = true,
    this.semanticLabel,
    this.mouseCursor = SystemMouseCursors.click,
  });

  /// Surface treatment with neutral border.
  const FortalCheckbox.surface({
    super.key,
    this.size = .size2,
    required this.selected,
    this.onChanged,
    this.enabled = true,
    this.tristate = false,
    this.checkedIcon = Icons.check_rounded,
    this.uncheckedIcon,
    this.indeterminateIcon = Icons.horizontal_rule,
    this.focusNode,
    this.autofocus = false,
    this.enableFeedback = true,
    this.semanticLabel,
    this.mouseCursor = SystemMouseCursors.click,
  }) : variant = FortalCheckboxVariant.surface;

  /// Soft accent treatment.
  const FortalCheckbox.soft({
    super.key,
    this.size = .size2,
    required this.selected,
    this.onChanged,
    this.enabled = true,
    this.tristate = false,
    this.checkedIcon = Icons.check_rounded,
    this.uncheckedIcon,
    this.indeterminateIcon = Icons.horizontal_rule,
    this.focusNode,
    this.autofocus = false,
    this.enableFeedback = true,
    this.semanticLabel,
    this.mouseCursor = SystemMouseCursors.click,
  }) : variant = FortalCheckboxVariant.soft;

  final FortalCheckboxVariant variant;

  final FortalCheckboxSize size;

  final bool? selected;

  final ValueChanged<bool?>? onChanged;

  final bool enabled;

  final bool tristate;

  final IconData checkedIcon;

  final IconData? uncheckedIcon;

  final IconData indeterminateIcon;

  final FocusNode? focusNode;

  final bool autofocus;

  final bool enableFeedback;

  final String? semanticLabel;

  final MouseCursor mouseCursor;

  @override
  Widget build(BuildContext context) {
    return fortalCheckboxStyler(variant: this.variant, size: this.size).call(
      key: this.key,
      selected: this.selected,
      onChanged: this.onChanged,
      enabled: this.enabled,
      tristate: this.tristate,
      checkedIcon: this.checkedIcon,
      uncheckedIcon: this.uncheckedIcon,
      indeterminateIcon: this.indeterminateIcon,
      focusNode: this.focusNode,
      autofocus: this.autofocus,
      enableFeedback: this.enableFeedback,
      semanticLabel: this.semanticLabel,
      mouseCursor: this.mouseCursor,
    );
  }
}
