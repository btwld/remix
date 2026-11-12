// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'select.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Ui Select recipe: the trigger, the floating panel and its items.
///
/// Content icons use size-matched 12/16/20 token defaults rather than the
/// ambient icon size. Override the trigger icon through [style] when needed.
///
/// The panel is at least as wide as its trigger. A [style] that gives the
/// content a `maxWidth` below the trigger's width must also set `minWidth`,
/// which replaces the minimum, because a minimum above a maximum is invalid.
///
/// [highContrast] moves the highlighted item of the surface and ghost variants
/// to accent step 12.
class UiSelect<T> extends StatelessWidget {
  const UiSelect({
    super.key,
    this.variant = .surface,
    this.size = .size2,
    this.highContrast = false,
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

  /// A near-white fill inside a 1px gray frame.
  const UiSelect.surface({
    super.key,
    this.size = .size2,
    this.highContrast = false,
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
  }) : variant = UiSelectVariant.surface;

  /// An accent tint under accent text.
  const UiSelect.soft({
    super.key,
    this.size = .size2,
    this.highContrast = false,
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
  }) : variant = UiSelectVariant.soft;

  /// No fill until hovered. It sits in a negative margin, so its text lines up
  /// with the text around it.
  const UiSelect.ghost({
    super.key,
    this.size = .size2,
    this.highContrast = false,
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
  }) : variant = UiSelectVariant.ghost;

  final UiSelectVariant variant;

  final UiSelectSize size;

  final bool highContrast;

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
  Widget build(BuildContext context) {
    return RemixSelect<T>(
      key: this.key,
      style: uiSelectStyle(
        variant: this.variant,
        size: this.size,
        highContrast: this.highContrast,
        style: this.style,
      ),
      trigger: this.trigger,
      items: this.items,
      selectedValue: this.selectedValue,
      positioning: this.positioning,
      onChanged: this.onChanged,
      onOpen: this.onOpen,
      onClose: this.onClose,
      enabled: this.enabled,
      mouseCursor: this.mouseCursor,
      semanticLabel: this.semanticLabel,
      closeOnSelect: this.closeOnSelect,
      focusNode: this.focusNode,
    );
  }
}
