// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'select.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// HeroUI recipe for [RemixSelect]: a field trigger over an overlay list.
///
/// [invalid] paints the error treatment; validation stays with the app.
class UiSelect<T> extends StatelessWidget {
  const UiSelect({
    super.key,
    this.variant = .primary,
    this.invalid = false,
    this.style = const SelectStyler.create(),
    required this.trigger,
    required this.items,
    this.selectedValue,
    this.positioning = const OverlayPositionConfig(
      side: .bottom,
      alignment: .center,
    ),
    this.onChanged,
    this.onOpen,
    this.onClose,
    this.enabled = true,
    this.mouseCursor = SystemMouseCursors.click,
    this.semanticLabel,
    this.closeOnSelect = true,
    this.focusNode,
  });

  /// The field surface fill, with its shadow.
  const UiSelect.primary({
    super.key,
    this.invalid = false,
    this.style = const SelectStyler.create(),
    required this.trigger,
    required this.items,
    this.selectedValue,
    this.positioning = const OverlayPositionConfig(
      side: .bottom,
      alignment: .center,
    ),
    this.onChanged,
    this.onOpen,
    this.onClose,
    this.enabled = true,
    this.mouseCursor = SystemMouseCursors.click,
    this.semanticLabel,
    this.closeOnSelect = true,
    this.focusNode,
  }) : variant = UiSelectVariant.primary;

  /// The `default` fill.
  const UiSelect.secondary({
    super.key,
    this.invalid = false,
    this.style = const SelectStyler.create(),
    required this.trigger,
    required this.items,
    this.selectedValue,
    this.positioning = const OverlayPositionConfig(
      side: .bottom,
      alignment: .center,
    ),
    this.onChanged,
    this.onOpen,
    this.onClose,
    this.enabled = true,
    this.mouseCursor = SystemMouseCursors.click,
    this.semanticLabel,
    this.closeOnSelect = true,
    this.focusNode,
  }) : variant = UiSelectVariant.secondary;

  final UiSelectVariant variant;

  final bool invalid;

  final SelectStyler style;

  final RemixSelectTrigger trigger;

  final List<RemixSelectItem<T>> items;

  final T? selectedValue;

  final OverlayPositionConfig positioning;

  final ValueChanged<T?>? onChanged;

  final VoidCallback? onOpen;

  final VoidCallback? onClose;

  final bool enabled;

  final MouseCursor mouseCursor;

  final String? semanticLabel;

  final bool closeOnSelect;

  final FocusNode? focusNode;

  @override
  Widget build(BuildContext _) {
    return RemixSelect<T>(
      style: uiSelectStyle(variant: variant, invalid: invalid, style: style),
      trigger: trigger,
      items: items,
      selectedValue: selectedValue,
      positioning: positioning,
      onChanged: onChanged,
      onOpen: onOpen,
      onClose: onClose,
      enabled: enabled,
      mouseCursor: mouseCursor,
      semanticLabel: semanticLabel,
      closeOnSelect: closeOnSelect,
      focusNode: focusNode,
    );
  }
}
