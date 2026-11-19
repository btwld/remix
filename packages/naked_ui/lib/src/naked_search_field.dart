import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'mixins/naked_mixins.dart';

/// Bindings for the editor and optional clear button in a [NakedSearchField].
class NakedSearchFieldBindings {
  const NakedSearchFieldBindings._({
    required this.controller,
    required this.focusNode,
    required this.enabled,
    required this.readOnly,
    required this.onChanged,
    required this.clear,
  });

  /// Pass to the editor. Do not dispose it from the builder.
  final TextEditingController controller;

  /// Pass to the editor so clearing can return focus to it.
  final FocusNode focusNode;

  /// Whether the editor should accept interaction.
  final bool enabled;

  /// Whether the editor should allow selection but not editing.
  final bool readOnly;

  /// Forward to the editor's user-edit callback, not a controller listener.
  final ValueChanged<String>? onChanged;

  /// Clears once and returns focus to the editor. Null when empty or not editable.
  final VoidCallback? clear;
}

/// Headless search behavior for a caller-built editor and clear affordance.
///
/// Forward the supplied bindings to a text field, e.g. `NakedTextField` with
/// `textInputAction: TextInputAction.search`. The editor owns its accessible
/// name and submit action. This component adds no styling, search results, or
/// extra tab stop.
///
/// Escape clears an editable, nonempty field. Repeats and key-up from that
/// press do not dismiss a surrounding dialog. During active text composition,
/// Escape stays with the input method even if the field becomes read-only.
/// A fresh Escape with nothing to clear bubbles.
class NakedSearchField extends StatefulWidget {
  /// Creates a behavior-only search field.
  const NakedSearchField({
    super.key,
    required this.builder,
    this.controller,
    this.focusNode,
    this.enabled = true,
    this.readOnly = false,
    this.onChanged,
    this.onCleared,
  });

  /// Builds the editor and, optionally, a separately labelled clear button.
  final Widget Function(BuildContext context, NakedSearchFieldBindings field)
  builder;

  /// Optional caller-owned controller. Removing it preserves the editing value.
  final TextEditingController? controller;

  /// Optional caller-owned editor focus node.
  final FocusNode? focusNode;

  /// Whether the field accepts interaction.
  final bool enabled;

  /// Whether the field allows selection but not editing or clearing.
  final bool readOnly;

  /// Receives user edits from the editor and an empty string after a clear.
  /// Programmatic changes to [controller] do not fire this callback.
  final ValueChanged<String>? onChanged;

  /// Called after [onChanged] when the button or Escape clears the query.
  final VoidCallback? onCleared;

  @override
  State<NakedSearchField> createState() => _NakedSearchFieldState();
}

class _NakedSearchFieldState extends State<NakedSearchField>
    with FocusNodeMixin<NakedSearchField> {
  TextEditingController? _ownedController;
  TextEditingController get _controller =>
      widget.controller ?? _ownedController!;
  late bool _hasText;
  KeyEventResult _escapeResult = KeyEventResult.ignored;

  @override
  FocusNode? get widgetProvidedNode => widget.focusNode;

  bool get _canClear => widget.enabled && !widget.readOnly && _hasText;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) _ownedController = TextEditingController();
    _attachController();
  }

  void _attachController() {
    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(_syncHasText);
  }

  void _syncHasText() {
    final hasText = _controller.text.isNotEmpty;
    if (_hasText != hasText) setState(() => _hasText = hasText);
  }

  @override
  void didUpdateWidget(NakedSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == oldWidget.controller) return;
    final previous = oldWidget.controller ?? _ownedController!;
    previous.removeListener(_syncHasText);
    _ownedController?.dispose();
    _ownedController = widget.controller == null
        ? TextEditingController.fromValue(previous.value)
        : null;
    _attachController();
  }

  @override
  void dispose() {
    _controller.removeListener(_syncHasText);
    _ownedController?.dispose();
    super.dispose();
  }

  void _clear() {
    if (!mounted || !_canClear) return;
    _controller.clear();
    widget.onChanged?.call('');
    widget.onCleared?.call();
    requestEffectiveFocus();
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event.logicalKey != LogicalKeyboardKey.escape) return .ignored;
    if (event is KeyDownEvent) {
      final value = _controller.value;
      _escapeResult = .ignored;
      if (value.isComposingRangeValid && !value.composing.isCollapsed) {
        _escapeResult = .skipRemainingHandlers;
      } else if (_canClear) {
        _escapeResult = .handled;
        _clear();
      }
    }
    final result = _escapeResult;
    if (event is KeyUpEvent) _escapeResult = .ignored;
    return result;
  }

  @override
  Widget build(BuildContext context) => Focus(
    canRequestFocus: false,
    includeSemantics: false,
    onKeyEvent: _handleKey,
    child: widget.builder(
      context,
      NakedSearchFieldBindings._(
        controller: _controller,
        focusNode: effectiveFocusNode,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        onChanged: widget.onChanged,
        clear: _canClear ? _clear : null,
      ),
    ),
  );
}
