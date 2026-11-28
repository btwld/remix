// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'select.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Fortal Select recipe: the trigger, the floating panel and its items.
///
/// The trigger answers hover, press and the open panel with the muted fill
/// and the strong frame, and turns its chevron half a turn while open. A new
/// value rises into place (an earlier one drops) while the old one leaves.
/// The panel grows in from the trigger edge and leaves faster than it came.
/// Items take the muted fill under the pointer or the keyboard.
///
/// The panel is at least as wide as its trigger. A [style] that gives the
/// content a `maxWidth` below the trigger's width must also set `minWidth`,
/// which replaces the minimum, because a minimum above a maximum is invalid.
///
/// [highContrast] gives the surface trigger the strong frame at rest and
/// moves the highlighted item of the surface and ghost variants to accent
/// step 12 under step 1 text. It, or the theme's high contrast switch, lifts
/// the placeholder and chevron from gray 10 to gray 11 so they read at 4.5:1.
class FortalSelect<T> extends StatelessWidget {
  const FortalSelect({
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

  /// The surface fill inside a quiet 1px frame that strengthens, over the
  /// muted fill, while hovered, pressed or open.
  const FortalSelect.surface({
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
  }) : variant = FortalSelectVariant.surface;

  /// The muted fill inside the strong frame.
  const FortalSelect.soft({
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
  }) : variant = FortalSelectVariant.soft;

  /// No fill until hovered or open. It sits in a negative margin, so its text
  /// lines up with the text around it.
  const FortalSelect.ghost({
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
  }) : variant = FortalSelectVariant.ghost;

  final FortalSelectVariant variant;

  final FortalSelectSize size;

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
  Widget build(BuildContext _) {
    return RemixSelect<T>(
      style: fortalSelectStyle(
        variant: variant,
        size: size,
        highContrast: highContrast,
        style: style,
      ),
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
