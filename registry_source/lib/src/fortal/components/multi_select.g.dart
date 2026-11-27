// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multi_select.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Fortal Multi Select recipe: a rounded field showing the picks as pill
/// chips, over a floating list whose options draw a check when picked.
///
/// It reads top to bottom: the trigger at rest, hovered or open, and
/// disabled; its chips; the panel; the options; then the size.
///
/// Hovering or opening the trigger darkens its border and fills it muted,
/// and the chips lift to the surface color. The panel drops in from just
/// above the trigger. Options take a muted fill under the pointer or the
/// keyboard and fade when disabled; a picked option shows a check, not a
/// heavier label.
///
/// [highContrast] moves the resting border to the control border and the
/// placeholder and chevron to gray step 11. The theme's high contrast switch
/// moves the border too.
class FortalMultiSelect<T extends Object> extends StatelessWidget {
  const FortalMultiSelect({
    super.key,
    this.size = .size2,
    this.highContrast = false,
    this.style = const SelectStyler.create(),
    required this.trigger,
    required this.items,
    required this.selectedValues,
    this.onChanged,
    this.maxVisibleChips = 2,
    this.positioning = const OverlayPositionConfig(
      side: .bottom,
      alignment: .center,
    ),
    this.onOpen,
    this.onClose,
    this.enabled = true,
    this.mouseCursor = SystemMouseCursors.click,
    this.semanticLabel,
    this.focusNode,
  });

  final FortalMultiSelectSize size;

  final bool highContrast;

  final SelectStyler style;

  final RemixSelectTrigger trigger;

  final List<RemixSelectItem<T>> items;

  final Set<T> selectedValues;

  final ValueChanged<Set<T>>? onChanged;

  final int maxVisibleChips;

  final OverlayPositionConfig positioning;

  final VoidCallback? onOpen;

  final VoidCallback? onClose;

  final bool enabled;

  final MouseCursor mouseCursor;

  final String? semanticLabel;

  final FocusNode? focusNode;

  @override
  Widget build(BuildContext _) {
    return RemixMultiSelect<T>(
      style: fortalMultiSelectStyle(
        size: size,
        highContrast: highContrast,
        style: style,
      ),
      trigger: trigger,
      items: items,
      selectedValues: selectedValues,
      onChanged: onChanged,
      maxVisibleChips: maxVisibleChips,
      positioning: positioning,
      onOpen: onOpen,
      onClose: onClose,
      enabled: enabled,
      mouseCursor: mouseCursor,
      semanticLabel: semanticLabel,
      focusNode: focusNode,
    );
  }
}
