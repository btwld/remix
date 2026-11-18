import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../theme/tokens.dart';
import 'icon_button.dart';
import 'textfield.dart';

/// The application's SearchField: a text field for a query, with a search
/// icon at the start and a clear button at the end.
///
/// A composition of [PlaygroundTextField] and [PlaygroundIconButton] in the shape
/// of shadcn/ui's Input Group with a search addon and an `InputGroupButton`.
/// The field keeps the TextField recipe's 36px height, border, focus ring,
/// error, and disabled treatment. The icon sits 12px in and 8px before the
/// text in the field's muted accessory color. The clear button, a 24px ghost
/// square 4px from the end, shows only while the field is enabled, editable,
/// and not empty.
///
/// Clearing, by the button or by Escape, empties the text, reports `''` to
/// [onChanged], calls [onCleared], and keeps focus in the field. Escape clears
/// only when there is text and no input-method composition in progress;
/// otherwise it passes up, so an enclosing dialog still closes.
///
/// ```dart
/// PlaygroundSearchField(
///   semanticLabel: 'Search customers',
///   hintText: 'Search customers…',
///   onChanged: (query) => setState(() => this.query = query),
/// )
/// ```
class PlaygroundSearchField extends StatefulWidget {
  const PlaygroundSearchField({
    super.key,
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
    this.textInputAction = TextInputAction.search,
    this.style = const TextFieldStyler.create(),
  });

  /// Names the field for assistive technology; a search field rarely has a
  /// visible label.
  final String semanticLabel;

  /// The query text. The field creates and disposes its own when null.
  final TextEditingController? controller;

  /// The field's focus. The field creates and disposes its own when null.
  final FocusNode? focusNode;

  /// The placeholder shown while the field is empty.
  final String? hintText;

  /// Whether the field accepts input. A disabled field fades and shows no
  /// clear button.
  final bool enabled;

  /// Whether the text can be selected but not changed. A read-only field
  /// shows no clear button and ignores Escape.
  final bool readOnly;

  /// Whether the field takes focus when first built.
  final bool autofocus;

  /// Called with the text after each edit, and with `''` after a clear.
  final ValueChanged<String>? onChanged;

  /// Called with the text when the keyboard's search action is submitted.
  final ValueChanged<String>? onSubmitted;

  /// Called after the clear button or Escape empties the field.
  final VoidCallback? onCleared;

  /// Names the clear button for assistive technology.
  final String clearSemanticLabel;

  /// The keyboard's action button.
  final TextInputAction textInputAction;

  /// Merged last into the field's style.
  final TextFieldStyler style;

  @override
  State<PlaygroundSearchField> createState() => _PlaygroundSearchFieldState();
}

class _PlaygroundSearchFieldState extends State<PlaygroundSearchField> {
  TextEditingController? _ownController;
  FocusNode? _ownFocusNode;
  late bool _hasText;
  late final _clearAction = _ClearSearchAction(this);

  TextEditingController get _controller =>
      widget.controller ?? (_ownController ??= TextEditingController());

  FocusNode get _focusNode =>
      widget.focusNode ??
      (_ownFocusNode ??= FocusNode(debugLabel: 'PlaygroundSearchField'));

  /// Whether there is anything the user may clear.
  bool get _canClear => widget.enabled && !widget.readOnly && _hasText;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_syncHasText);
    _hasText = _controller.text.isNotEmpty;
  }

  @override
  void didUpdateWidget(PlaygroundSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == oldWidget.controller) return;
    final previous = oldWidget.controller ?? _ownController!;
    previous.removeListener(_syncHasText);
    // Taking the text over from the caller keeps what the user typed.
    if (widget.controller == null) {
      _ownController?.dispose();
      _ownController = TextEditingController.fromValue(previous.value);
    }
    _controller.addListener(_syncHasText);
    _hasText = _controller.text.isNotEmpty;
  }

  @override
  void dispose() {
    (widget.controller ?? _ownController)?.removeListener(_syncHasText);
    _ownController?.dispose();
    _ownFocusNode?.dispose();
    super.dispose();
  }

  void _syncHasText() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) setState(() => _hasText = hasText);
  }

  void _clear() {
    _controller.clear();
    widget.onChanged?.call('');
    widget.onCleared?.call();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) => Shortcuts(
    shortcuts: const {
      SingleActivator(LogicalKeyboardKey.escape): _ClearSearchIntent(),
    },
    child: Actions(
      actions: {_ClearSearchIntent: _clearAction},
      child: PlaygroundTextField(
        controller: _controller,
        focusNode: _focusNode,
        hintText: widget.hintText,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        autofocus: widget.autofocus,
        textInputAction: widget.textInputAction,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        semanticLabel: widget.semanticLabel,
        style: _fieldStyle(Directionality.of(context)).merge(widget.style),
        // In the recipe's accessory icon theme: `mutedForeground`, 16px.
        leading: const ExcludeSemantics(
          child: StyledIcon(icon: RemixIcons.search),
        ),
        // Always present, so the 8px gap before it plus the 4px end inset
        // make the 12px text inset the field has without the button.
        trailing: _canClear
            // Its own semantics node: a button's semantics are not a
            // container, so it would otherwise merge into whatever node
            // encloses the field.
            ? Semantics(
                container: true,
                child: PlaygroundIconButton.ghost(
                  size: .small,
                  icon: RemixIcons.close,
                  semanticLabel: widget.clearSemanticLabel,
                  onPressed: _clear,
                  style: _clearButtonStyle(),
                ),
              )
            : const SizedBox.shrink(),
      ),
    ),
  );
}

/// The Input Group's insets over the TextField recipe: 12px before the search
/// icon, as the addon's `pl-3`, and 4px after the trailing slot, where the
/// addon's `pr-3` and the button's `-mr-[0.45rem]` leave the clear button.
///
/// Resolved to left and right for [direction]: the recipe's padding is not
/// directional, and Mix cannot merge directional insets into it.
TextFieldStyler _fieldStyle(TextDirection direction) {
  final (left, right) = switch (direction) {
    .ltr => (PlaygroundTokens.s3, PlaygroundTokens.s1),
    .rtl => (PlaygroundTokens.s1, PlaygroundTokens.s3),
  };

  return TextFieldStyler().padding(.only(left: left, right: right));
}

/// `InputGroupButton` at `size="icon-xs"` over the small ghost icon button: a
/// 24px square with the small radius, its glyph in the addon's
/// `mutedForeground` until the pointer brings the ghost hover.
IconButtonStyler _clearButtonStyle() => IconButtonStyler()
    .size(PlaygroundTokens.s6, PlaygroundTokens.s6)
    .borderRadius(.all(PlaygroundTokens.radiusSm()))
    .icon(.color(PlaygroundTokens.mutedForeground()));

/// Escape inside the field.
class _ClearSearchIntent extends Intent {
  const _ClearSearchIntent();
}

/// Clears on Escape while there is text and no composition in progress.
///
/// Disabled otherwise, so the key goes on to the enclosing shortcuts: an open
/// dialog still closes on Escape from an empty search field.
class _ClearSearchAction extends Action<_ClearSearchIntent> {
  _ClearSearchAction(this.field);

  final _PlaygroundSearchFieldState field;

  @override
  bool isEnabled(_ClearSearchIntent intent) =>
      field._canClear && !field._controller.value.isComposingRangeValid;

  @override
  Object? invoke(_ClearSearchIntent intent) {
    field._clear();
    return null;
  }
}
