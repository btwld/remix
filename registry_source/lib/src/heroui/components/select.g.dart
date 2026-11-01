// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'select.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// HeroUI recipe for [RemixSelect]: a field trigger over an overlay list.
///
/// [invalid] paints the error treatment; validation stays with the app.
class HeroUiSelect<T> extends StatelessWidget {
  const HeroUiSelect({
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

  const HeroUiSelect.primary({
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
  }) : variant = HeroUiSelectVariant.primary;

  const HeroUiSelect.secondary({
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
  }) : variant = HeroUiSelectVariant.secondary;

  final HeroUiSelectVariant variant;

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
  Widget build(BuildContext context) {
    return RemixSelect<T>(
      key: this.key,
      style: heroUiSelectStyle(
        variant: this.variant,
        invalid: this.invalid,
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
