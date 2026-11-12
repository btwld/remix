// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'select.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's Select recipe.
///
/// One recipe covers the trigger, the floating panel and the option rows,
/// because `SelectSpec` carries all three. The trigger is styled as a field,
/// like the text field; the panel matches the menu's.
class PlaygroundSelect<T> extends StatelessWidget {
  const PlaygroundSelect({
    super.key,
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
      style: playgroundSelectStyle(style: this.style),
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
