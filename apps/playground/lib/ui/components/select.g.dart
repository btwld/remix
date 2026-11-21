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
  Widget build(BuildContext _) {
    return RemixSelect<T>(
      style: playgroundSelectStyle(style: style),
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
