// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_field.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// HeroUI recipe for [RemixTextField] as a search field.
///
/// Pass [HeroUiSearchIcon] as `leading` and [HeroUiSearchClearButton] as
/// `trailing`. The group is a fixed `h-9` row with the icon `ms-3`, the input
/// `px-2` beside each accessory, and the clear button `me-2`.
class HeroUiSearchField extends StatelessWidget {
  const HeroUiSearchField({
    super.key,
    this.variant = .primary,
    this.style = const TextFieldStyler.create(),
    this.controller,
    this.focusNode,
    this.label,
    this.hintText,
    this.helperText,
    this.error = false,
    this.keyboardType,
    this.textInputAction,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onTap,
    this.onTapOutside,
    this.autofillHints,
    this.leading,
    this.trailing,
    this.semanticLabel,
    this.semanticHint,
    this.excludeSemantics = false,
  });

  const HeroUiSearchField.primary({
    super.key,
    this.style = const TextFieldStyler.create(),
    this.controller,
    this.focusNode,
    this.label,
    this.hintText,
    this.helperText,
    this.error = false,
    this.keyboardType,
    this.textInputAction,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onTap,
    this.onTapOutside,
    this.autofillHints,
    this.leading,
    this.trailing,
    this.semanticLabel,
    this.semanticHint,
    this.excludeSemantics = false,
  }) : variant = HeroUiTextFieldVariant.primary;

  const HeroUiSearchField.secondary({
    super.key,
    this.style = const TextFieldStyler.create(),
    this.controller,
    this.focusNode,
    this.label,
    this.hintText,
    this.helperText,
    this.error = false,
    this.keyboardType,
    this.textInputAction,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onTap,
    this.onTapOutside,
    this.autofillHints,
    this.leading,
    this.trailing,
    this.semanticLabel,
    this.semanticHint,
    this.excludeSemantics = false,
  }) : variant = HeroUiTextFieldVariant.secondary;

  final HeroUiTextFieldVariant variant;

  final TextFieldStyler style;

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final String? label;

  final String? hintText;

  final String? helperText;

  final bool error;

  final TextInputType? keyboardType;

  final TextInputAction? textInputAction;

  final bool enabled;

  final bool readOnly;

  final bool autofocus;

  final ValueChanged<String>? onChanged;

  final VoidCallback? onEditingComplete;

  final ValueChanged<String>? onSubmitted;

  final GestureTapCallback? onTap;

  final TapRegionCallback? onTapOutside;

  final Iterable<String>? autofillHints;

  final Widget? leading;

  final Widget? trailing;

  final String? semanticLabel;

  final String? semanticHint;

  final bool excludeSemantics;

  @override
  Widget build(BuildContext context) {
    return RemixTextField(
      key: this.key,
      style: heroUiSearchFieldStyle(variant: this.variant, style: this.style),
      controller: this.controller,
      focusNode: this.focusNode,
      label: this.label,
      hintText: this.hintText,
      helperText: this.helperText,
      error: this.error,
      keyboardType: this.keyboardType,
      textInputAction: this.textInputAction,
      enabled: this.enabled,
      readOnly: this.readOnly,
      autofocus: this.autofocus,
      onChanged: this.onChanged,
      onEditingComplete: this.onEditingComplete,
      onSubmitted: this.onSubmitted,
      onTap: this.onTap,
      onTapOutside: this.onTapOutside,
      autofillHints: this.autofillHints,
      leading: this.leading,
      trailing: this.trailing,
      semanticLabel: this.semanticLabel,
      semanticHint: this.semanticHint,
      excludeSemantics: this.excludeSemantics,
    );
  }
}

/// HeroUI recipe for the clear button of a [HeroUiSearchField]: the close
/// button at `size-5` with a `size-3` icon.
///
/// The app decides when it shows and what its `onPressed` clears; HeroUI
/// hides it while the field is empty.
class HeroUiSearchClearButton extends StatelessWidget {
  const HeroUiSearchClearButton({
    super.key,
    this.icon = RemixIcons.cross2,
    this.semanticLabel = 'Clear search',
    this.style = const IconButtonStyler.create(),
    this.iconBuilder,
    this.loadingBuilder,
    this.loading = false,
    this.enabled = true,
    this.enableFeedback = true,
    this.onPressed,
    this.onLongPress,
    this.focusNode,
    this.autofocus = false,
    this.semanticHint,
    this.excludeSemantics = false,
    this.mouseCursor = SystemMouseCursors.click,
  });

  final IconData? icon;

  final String semanticLabel;

  final IconButtonStyler style;

  final RemixIconButtonIconBuilder? iconBuilder;

  final RemixIconButtonLoadingBuilder? loadingBuilder;

  final bool loading;

  final bool enabled;

  final bool enableFeedback;

  final VoidCallback? onPressed;

  final VoidCallback? onLongPress;

  final FocusNode? focusNode;

  final bool autofocus;

  final String? semanticHint;

  final bool excludeSemantics;

  final MouseCursor mouseCursor;

  @override
  Widget build(BuildContext context) {
    return RemixIconButton(
      key: this.key,
      style: heroUiSearchClearButtonStyle(
        icon: this.icon,
        semanticLabel: this.semanticLabel,
        style: this.style,
      ),
      icon: this.icon,
      semanticLabel: this.semanticLabel,
      iconBuilder: this.iconBuilder,
      loadingBuilder: this.loadingBuilder,
      loading: this.loading,
      enabled: this.enabled,
      enableFeedback: this.enableFeedback,
      onPressed: this.onPressed,
      onLongPress: this.onLongPress,
      focusNode: this.focusNode,
      autofocus: this.autofocus,
      semanticHint: this.semanticHint,
      excludeSemantics: this.excludeSemantics,
      mouseCursor: this.mouseCursor,
    );
  }
}
