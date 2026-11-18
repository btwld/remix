import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../theme/theme.dart';
import 'icon_button.dart';
import 'textfield.dart';

/// The sizes a search field comes in: the text field's. Pixel values are at
/// 100% theme scaling.
enum FortalSearchFieldSize {
  /// 24px tall, with 12px text and a 12px clear glyph.
  size1,

  /// 32px tall, with 14px text and a 12px clear glyph. The default.
  size2,

  /// 40px tall, with 16px text and a 16px clear glyph.
  size3,
}

/// The looks a search field comes in: the text field's.
enum FortalSearchFieldVariant {
  /// The `gray2` fill inside a 1px neutral frame, with neutral text.
  surface,

  /// An accent tint inside a 1px accent ring, with accent-colored text.
  soft,
}

/// A text field for a search: a leading search glyph, and a clear button once
/// there is something to clear.
///
/// The field is a [FortalTextField] of the same [size] and [variant], so the
/// two share their height, frame, focus ring and disabled look. It has no
/// label or helper text: [semanticLabel] names it.
///
/// The clear button shows while the field is enabled, editable and not
/// empty. It sits over the field's end, centered in the last 40px so its
/// whole 40px target is inside the field, and the text area always stops
/// short of it. Pressing it clears the text, reports `onChanged('')` and
/// [onCleared], and returns focus to the field. It is its own semantics node
/// and takes no Tab stop: Escape clears from the keyboard. Escape passes on,
/// to close a dialog for example, when there is nothing to clear or while an
/// input method is composing.
///
/// The field creates its own controller and focus node when none are given.
/// When a caller's controller is withdrawn, the owned one starts from its
/// last value.
class FortalSearchField extends StatefulWidget {
  const FortalSearchField({
    super.key,
    this.variant = .surface,
    this.size = .size2,
    required this.semanticLabel,
    this.controller,
    this.focusNode,
    this.hintText,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.onChanged,
    this.onSubmitted,
    this.onCleared,
    this.clearSemanticLabel = 'Clear search',
    this.textInputAction = .search,
    this.style = const TextFieldStyler.create(),
  }) : assert(semanticLabel != ''),
       assert(clearSemanticLabel != '');

  /// The `gray2` fill inside a 1px neutral frame, with neutral text.
  const FortalSearchField.surface({
    super.key,
    this.size = .size2,
    required this.semanticLabel,
    this.controller,
    this.focusNode,
    this.hintText,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.onChanged,
    this.onSubmitted,
    this.onCleared,
    this.clearSemanticLabel = 'Clear search',
    this.textInputAction = .search,
    this.style = const TextFieldStyler.create(),
  }) : variant = FortalSearchFieldVariant.surface,
       assert(semanticLabel != ''),
       assert(clearSemanticLabel != '');

  /// An accent tint inside a 1px accent ring, with accent-colored text.
  const FortalSearchField.soft({
    super.key,
    this.size = .size2,
    required this.semanticLabel,
    this.controller,
    this.focusNode,
    this.hintText,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.onChanged,
    this.onSubmitted,
    this.onCleared,
    this.clearSemanticLabel = 'Clear search',
    this.textInputAction = .search,
    this.style = const TextFieldStyler.create(),
  }) : variant = FortalSearchFieldVariant.soft,
       assert(semanticLabel != ''),
       assert(clearSemanticLabel != '');

  final FortalSearchFieldVariant variant;
  final FortalSearchFieldSize size;

  /// The field's accessible name.
  final String semanticLabel;

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  /// Called after the clear button or Escape empties the field.
  final VoidCallback? onCleared;

  /// The clear button's accessible name.
  final String clearSemanticLabel;

  final TextInputAction textInputAction;

  /// Merged last into the field's style.
  final TextFieldStyler style;

  @override
  State<FortalSearchField> createState() => _FortalSearchFieldState();
}

class _FortalSearchFieldState extends State<FortalSearchField> {
  TextEditingController? _ownController;
  FocusNode? _ownFocusNode;

  TextEditingController get _controller =>
      widget.controller ?? (_ownController ??= TextEditingController());

  FocusNode get _focusNode =>
      widget.focusNode ?? (_ownFocusNode ??= FocusNode(debugLabel: 'search'));

  late bool _hasText = _controller.text.isNotEmpty;

  bool get _canClear => widget.enabled && !widget.readOnly && _hasText;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(FortalSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      final previous = oldWidget.controller ?? _ownController!;
      previous.removeListener(_onTextChanged);
      if (oldWidget.controller == null) {
        _disposeAfterFrame(_ownController);
        _ownController = null;
      } else if (widget.controller == null) {
        // Keep what the caller's controller held instead of emptying the
        // field.
        _ownController = TextEditingController.fromValue(previous.value);
      }
      _controller.addListener(_onTextChanged);
      _hasText = _controller.text.isNotEmpty;
    }
    if (oldWidget.focusNode == null && widget.focusNode != null) {
      _disposeAfterFrame(_ownFocusNode);
      _ownFocusNode = null;
    }
  }

  /// Disposes [notifier] once the field below has let go of it.
  void _disposeAfterFrame(ChangeNotifier? notifier) {
    if (notifier == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) => notifier.dispose());
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _ownController?.dispose();
    _ownFocusNode?.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) setState(() => _hasText = hasText);
  }

  void _clear() {
    _controller.clear();
    widget.onChanged?.call('');
    widget.onCleared?.call();
    _focusNode.requestFocus();
  }

  /// Escape clears, unless there is nothing to clear or an input method is
  /// still composing; then it passes on.
  KeyEventResult _onKeyEvent(FocusNode _, KeyEvent event) {
    if (event is! KeyDownEvent ||
        event.logicalKey != LogicalKeyboardKey.escape ||
        !_canClear) {
      return .ignored;
    }
    final composing = _controller.value.composing;
    if (composing.isValid && !composing.isCollapsed) return .ignored;
    _clear();

    return .handled;
  }

  @override
  Widget build(BuildContext context) {
    final (fieldSize, buttonSize, paddingX, glyph) = switch (widget.size) {
      .size1 => (
        FortalTextFieldSize.size1,
        FortalIconButtonSize.size1,
        FortalTokens.space2,
        FortalTokens.space3,
      ),
      .size2 => (
        FortalTextFieldSize.size2,
        FortalIconButtonSize.size1,
        FortalTokens.space2,
        FortalTokens.space3,
      ),
      .size3 => (
        FortalTextFieldSize.size3,
        FortalIconButtonSize.size2,
        FortalTokens.space3,
        FortalTokens.space4,
      ),
    };
    final target = FortalTokens.touchTargetMin.resolve(context);
    // The input stops where the clear glyph starts, minus the field's own
    // spacing, exactly as it would beside a trailing icon of that size.
    final reserved =
        target / 2 + glyph.resolve(context) / 2 - paddingX.resolve(context);

    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      onKeyEvent: _onKeyEvent,
      child: Stack(
        fit: .passthrough,
        children: [
          FortalTextField(
            variant: switch (widget.variant) {
              .surface => .surface,
              .soft => .soft,
            },
            size: fieldSize,
            controller: _controller,
            focusNode: _focusNode,
            hintText: widget.hintText,
            semanticLabel: widget.semanticLabel,
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            autofocus: widget.autofocus,
            textInputAction: widget.textInputAction,
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmitted,
            leading: const StyledIcon(icon: RemixIcons.search),
            // Always present at the clear button's width, so the text area
            // keeps one width and the field one structure as text comes and
            // goes.
            trailing: SizedBox(width: reserved),
            style: widget.style,
          ),
          if (_canClear)
            PositionedDirectional(
              top: 0,
              bottom: 0,
              end: 0,
              width: target,
              // Its own semantics node. Merged into the node around the
              // field, the button would make that node a button once there
              // is text, and on the web the browser then drops the input
              // focus the field's editor hangs from.
              child: Semantics(
                container: true,
                child: Center(
                  // Inside the field's tap region, so pressing it does not
                  // count as a tap outside the field.
                  child: TextFieldTapRegion(
                    child: ExcludeFocus(
                      child: FortalIconButton.ghost(
                        icon: RemixIcons.close,
                        semanticLabel: widget.clearSemanticLabel,
                        size: buttonSize,
                        onPressed: _clear,
                        style: _clearStyle(widget.variant),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// The clear button takes the field's icon color: gray on a surface field,
/// with a gray tint under the pointer, and the accent on a soft one.
IconButtonStyler _clearStyle(FortalSearchFieldVariant variant) =>
    switch (variant) {
      .surface =>
        IconButtonStyler()
            .icon(.color(FortalTokens.gray11()))
            .onHovered(.color(FortalTokens.grayA3()))
            .onPressed(.color(FortalTokens.grayA4())),
      .soft => IconButtonStyler().icon(.color(FortalTokens.accentContent())),
    };
