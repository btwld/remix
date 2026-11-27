import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'mixins/naked_mixins.dart';

/// Which committed text a [NakedTagInput] treats as already present.
enum NakedTagInputDuplicates {
  /// Every committed piece becomes a tag.
  allow,

  /// A piece equal to an existing tag is rejected.
  reject,

  /// A piece equal to an existing tag, ignoring case, is rejected.
  rejectIgnoringCase,
}

String _defaultPicked(String tag) =>
    '$tag selected. Press Backspace to remove it.';
String _defaultAdded(String tag) => 'Added $tag';
String _defaultRemoved(String tag) => 'Removed $tag';
String _defaultDuplicate(String tag) => '$tag is already added';

/// Text a [NakedTagInput] gives assistive technology.
///
/// The defaults are English. Pass translated strings to localize them.
class NakedTagInputMessages {
  /// Creates the announcement and action strings.
  const NakedTagInputMessages({
    this.removeAction = 'Remove',
    this.picked = _defaultPicked,
    this.added = _defaultAdded,
    this.removed = _defaultRemoved,
    this.duplicate = _defaultDuplicate,
  });

  /// The label of each tag's remove action.
  final String removeAction;

  /// Announced when the keyboard or a tap picks a tag.
  final String Function(String tag) picked;

  /// Announced when committed text becomes a tag.
  final String Function(String tag) added;

  /// Announced when a tag is removed.
  final String Function(String tag) removed;

  /// Announced when committed text matches the existing [tag].
  final String Function(String tag) duplicate;
}

/// One tag of a [NakedTagInput], as its builder sees it.
@immutable
class NakedTagInputItem {
  const NakedTagInputItem._({
    required this.index,
    required this.value,
    required this.isPicked,
    required this.removeActionLabel,
    required this.remove,
    required this.pick,
  });

  /// Position in [NakedTagInput.value].
  final int index;

  /// The tag text.
  final String value;

  /// Whether the keyboard or a tap has picked this tag. Backspace or Delete
  /// removes a picked tag.
  final bool isPicked;

  /// The label [NakedTagInputTag] gives the remove action.
  final String removeActionLabel;

  /// Removes this tag and keeps focus in the editor. Null when tags cannot
  /// change.
  final VoidCallback? remove;

  /// Toggles the pick on this tag and focuses the editor. Null when tags
  /// cannot change.
  final VoidCallback? pick;
}

/// Bindings for the editor and tags in a [NakedTagInput].
class NakedTagInputBindings {
  const NakedTagInputBindings._({
    required this.controller,
    required this.focusNode,
    required this.enabled,
    required this.readOnly,
    required this.tags,
    required this.isFull,
    required this.onChanged,
    required this.onEditingComplete,
  });

  /// Pass to the editor. Holds the uncommitted draft.
  final TextEditingController controller;

  /// Pass to the editor. Picking a tag keeps focus here.
  final FocusNode focusNode;

  /// Whether the editor should accept interaction.
  final bool enabled;

  /// Whether the editor should allow selection but not editing. True when
  /// [NakedTagInput.onChanged] is null.
  final bool readOnly;

  /// The current tags, in [NakedTagInput.value] order.
  final List<NakedTagInputItem> tags;

  /// Whether [NakedTagInput.maxTags] tags are present, so a commit is refused.
  final bool isFull;

  /// Forward to the editor's user-edit callback. Commits text before a
  /// separator.
  final ValueChanged<String> onChanged;

  /// Forward to the editor's editing-complete callback. Commits the draft on
  /// Enter and keeps focus in the editor.
  final VoidCallback onEditingComplete;

  /// The picked tag, if any.
  NakedTagInputItem? get picked {
    for (final tag in tags) {
      if (tag.isPicked) return tag;
    }
    return null;
  }
}

/// Headless tag entry: a text editor that commits tags, plus the tags it holds.
///
/// The caller owns [value] and lays out the tags and editor. Forward the
/// builder's [NakedTagInputBindings] to a text field (for example
/// `NakedTextField`), and wrap each tag's visual in a [NakedTagInputTag]. The
/// editor is the only Tab stop and owns the field's accessible name.
///
/// Enter, a [separators] character, and focus loss commit the trimmed draft.
/// Pasted text splits at every separator. A duplicate under [duplicates] is
/// refused, announced, and reported to [onDuplicate]; the draft stays. At
/// [maxTags] a commit is refused and the draft stays.
///
/// Keyboard, with the caret at the start of the editor and no selection:
/// Backspace picks the last tag; Left Arrow picks the last tag. With a tag
/// picked: Backspace or Delete removes it, Left and Right Arrow move the pick
/// (Right past the last tag returns to the editor), Escape clears it. Arrows
/// follow the reading direction. Typing clears the pick. Keys the input
/// method is composing stay with it.
class NakedTagInput extends StatefulWidget {
  /// Creates a behavior-only tag input.
  const NakedTagInput({
    super.key,
    required this.value,
    required this.builder,
    this.onChanged,
    this.onDuplicate,
    this.controller,
    this.focusNode,
    this.separators = const [','],
    this.duplicates = NakedTagInputDuplicates.rejectIgnoringCase,
    this.maxTags,
    this.enabled = true,
    this.readOnly = false,
    this.messages = const NakedTagInputMessages(),
  }) : assert(maxTags == null || maxTags > 0, 'maxTags must be positive.');

  /// The tags, owned by the caller.
  final List<String> value;

  /// Builds the editor and tags from the bindings.
  final Widget Function(BuildContext context, NakedTagInputBindings bindings)
  builder;

  /// Receives the proposed list once per user action. When null, tags cannot
  /// be added or removed. A committed draft is cleared whether or not the
  /// owner accepts the proposal.
  final ValueChanged<List<String>>? onChanged;

  /// Called with the index of the existing tag a commit duplicated.
  final ValueChanged<int>? onDuplicate;

  /// Optional caller-owned controller for the draft.
  final TextEditingController? controller;

  /// Optional caller-owned editor focus node.
  final FocusNode? focusNode;

  /// Strings that commit the text before them as a tag. Empty disables
  /// separator commits.
  final List<String> separators;

  /// Which commits count as duplicates.
  final NakedTagInputDuplicates duplicates;

  /// The most tags a user can add. Null means no limit.
  final int? maxTags;

  /// Whether the field accepts interaction.
  final bool enabled;

  /// Whether the field allows selection but not editing or removal.
  final bool readOnly;

  /// Text given to assistive technology.
  final NakedTagInputMessages messages;

  @override
  State<NakedTagInput> createState() => _NakedTagInputState();
}

enum _AddResult { added, empty, duplicate, full }

class _NakedTagInputState extends State<NakedTagInput>
    with FocusNodeMixin<NakedTagInput> {
  TextEditingController? _ownedController;
  int? _picked;

  TextEditingController get _controller =>
      widget.controller ?? _ownedController!;

  @override
  FocusNode? get widgetProvidedNode => widget.focusNode;

  @override
  ValueChanged<bool>? get onFocusChange => _handleFocusChange;

  bool get _editable =>
      widget.enabled && !widget.readOnly && widget.onChanged != null;

  bool get _isFull =>
      widget.maxTags != null && widget.value.length >= widget.maxTags!;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) _ownedController = TextEditingController();
  }

  @override
  void didUpdateWidget(NakedTagInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      final previous = oldWidget.controller ?? _ownedController!;
      _ownedController?.dispose();
      _ownedController = widget.controller == null
          ? TextEditingController.fromValue(previous.value)
          : null;
    }
    final picked = _picked;
    if (picked != null && (!_editable || picked >= widget.value.length)) {
      _picked = null;
    }
  }

  @override
  void dispose() {
    _ownedController?.dispose();
    super.dispose();
  }

  void _announce(String message) {
    SemanticsService.sendAnnouncement(
      View.of(context),
      message,
      Directionality.maybeOf(context) ?? TextDirection.ltr,
    );
  }

  int? _indexOf(List<String> tags, String tag) {
    switch (widget.duplicates) {
      case .allow:
        return null;
      case .reject:
        final index = tags.indexOf(tag);
        return index < 0 ? null : index;
      case .rejectIgnoringCase:
        final lower = tag.toLowerCase();
        final index = tags.indexWhere((t) => t.toLowerCase() == lower);
        return index < 0 ? null : index;
    }
  }

  _AddResult _addTo(List<String> tags, String raw) {
    final tag = raw.trim();
    if (tag.isEmpty) return .empty;
    final existing = _indexOf(tags, tag);
    if (existing != null) {
      widget.onDuplicate?.call(existing);
      _announce(widget.messages.duplicate(tags[existing]));
      return .duplicate;
    }
    if (widget.maxTags != null && tags.length >= widget.maxTags!) return .full;
    tags.add(tag);
    _announce(widget.messages.added(tag));
    return .added;
  }

  void _propose(List<String> next) {
    setState(() => _picked = null);
    widget.onChanged!(List.unmodifiable(next));
  }

  void _setDraft(String text) {
    _controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  String? _separatorAt(String text, int index) {
    for (final separator in widget.separators) {
      if (separator.isNotEmpty && text.startsWith(separator, index)) {
        return separator;
      }
    }
    return null;
  }

  void _handleEditorChanged(String text) {
    if (_picked != null) setState(() => _picked = null);
    if (!_editable) return;
    final next = [...widget.value];
    var start = 0;
    String? draft;
    for (var i = 0; i < text.length;) {
      final separator = _separatorAt(text, i);
      if (separator == null) {
        i++;
        continue;
      }
      final end = i + separator.length;
      final piece = text.substring(start, i);
      final result = _addTo(next, piece);
      // A refused piece stays editable. Only a separator just typed after it
      // is dropped; pasted text after it keeps its separators.
      if (result == .full || (result == .duplicate && end == text.length)) {
        draft = end == text.length ? piece : text.substring(start);
        break;
      }
      i = end;
      start = end;
    }
    if (draft == null && start == 0) return;
    if (next.length != widget.value.length) _propose(next);
    _setDraft(draft ?? text.substring(start));
  }

  void _commitDraft() {
    if (!_editable) return;
    final next = [...widget.value];
    if (_addTo(next, _controller.text) != .added) return;
    _controller.clear();
    _propose(next);
  }

  void _handleEditingComplete() {
    _commitDraft();
    requestEffectiveFocus();
  }

  void _handleFocusChange(bool focused) {
    if (focused || !mounted) return;
    _commitDraft();
    if (_picked != null && mounted) setState(() => _picked = null);
  }

  void _pick(int? index) {
    if (_picked == index) return;
    setState(() => _picked = index);
    if (index != null) _announce(widget.messages.picked(widget.value[index]));
  }

  void _remove(int index) {
    if (!_editable || index >= widget.value.length) return;
    final removed = widget.value[index];
    _propose([...widget.value]..removeAt(index));
    _announce(widget.messages.removed(removed));
    requestEffectiveFocus();
  }

  void _togglePick(int index) {
    if (!_editable) return;
    _pick(_picked == index ? null : index);
    requestEffectiveFocus();
  }

  bool get _caretAtStart {
    final selection = _controller.selection;
    return !selection.isValid ||
        (selection.isCollapsed && selection.baseOffset == 0);
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is KeyUpEvent || !_editable || widget.value.isEmpty) {
      return .ignored;
    }
    final value = _controller.value;
    if (value.isComposingRangeValid && !value.composing.isCollapsed) {
      return .ignored;
    }
    final keyboard = HardwareKeyboard.instance;
    if (keyboard.isShiftPressed ||
        keyboard.isControlPressed ||
        keyboard.isAltPressed ||
        keyboard.isMetaPressed) {
      return .ignored;
    }
    final key = event.logicalKey;
    final picked = _picked;
    final isRepeat = event is KeyRepeatEvent;
    final rtl = Directionality.maybeOf(context) == TextDirection.rtl;
    final backward = rtl
        ? LogicalKeyboardKey.arrowRight
        : LogicalKeyboardKey.arrowLeft;
    final forward = rtl
        ? LogicalKeyboardKey.arrowLeft
        : LogicalKeyboardKey.arrowRight;

    if (key == LogicalKeyboardKey.backspace ||
        key == LogicalKeyboardKey.delete) {
      if (isRepeat) return picked == null ? .ignored : .handled;
      if (picked != null) {
        _remove(picked);
        return .handled;
      }
      if (key == LogicalKeyboardKey.backspace && _caretAtStart) {
        _pick(widget.value.length - 1);
        return .handled;
      }
      return .ignored;
    }
    if (key == backward && (picked != null || _caretAtStart)) {
      final from = picked ?? widget.value.length;
      if (from > 0) _pick(from - 1);
      return .handled;
    }
    if (key == forward && picked != null) {
      _pick(picked + 1 < widget.value.length ? picked + 1 : null);
      return .handled;
    }
    if (key == LogicalKeyboardKey.escape && !isRepeat && picked != null) {
      _pick(null);
      return .handled;
    }
    return .ignored;
  }

  @override
  Widget build(BuildContext context) {
    final editable = _editable;
    final tags = [
      for (final (index, value) in widget.value.indexed)
        NakedTagInputItem._(
          index: index,
          value: value,
          isPicked: index == _picked,
          removeActionLabel: widget.messages.removeAction,
          remove: editable ? () => _remove(index) : null,
          pick: editable ? () => _togglePick(index) : null,
        ),
    ];
    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      includeSemantics: false,
      onKeyEvent: _handleKey,
      child: widget.builder(
        context,
        NakedTagInputBindings._(
          controller: _controller,
          focusNode: effectiveFocusNode,
          enabled: widget.enabled,
          readOnly: widget.readOnly || widget.onChanged == null,
          tags: List.unmodifiable(tags),
          isFull: _isFull,
          onChanged: _handleEditorChanged,
          onEditingComplete: _handleEditingComplete,
        ),
      ),
    );
  }
}

/// The interactive region and semantics node of one tag in a [NakedTagInput].
///
/// Gives the tag one semantics node, labelled with [semanticLabel] or the tag
/// text, that reports the pick as selected and offers a remove action. The
/// [child]'s own semantics are excluded, so a visual remove button inside it
/// should not be a separate Tab stop or semantics node. A tap on the tag
/// toggles its pick and keeps focus in the editor.
class NakedTagInputTag extends StatelessWidget {
  /// Wraps a tag's visual.
  const NakedTagInputTag({
    super.key,
    required this.item,
    required this.child,
    this.semanticLabel,
    this.mouseCursor = SystemMouseCursors.click,
  });

  /// The tag from [NakedTagInputBindings.tags].
  final NakedTagInputItem item;

  /// The tag's visual, including any remove button.
  final Widget child;

  /// Accessible name. Defaults to [NakedTagInputItem.value].
  final String? semanticLabel;

  /// Cursor over the tag while it can be picked.
  final MouseCursor mouseCursor;

  @override
  Widget build(BuildContext context) {
    final remove = item.remove;
    final pick = item.pick;
    return Semantics(
      container: true,
      label: semanticLabel ?? item.value,
      selected: item.isPicked ? true : null,
      customSemanticsActions: remove == null
          ? null
          : {CustomSemanticsAction(label: item.removeActionLabel): remove},
      child: ExcludeSemantics(
        child: MouseRegion(
          cursor: pick == null ? MouseCursor.defer : mouseCursor,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: pick,
            child: child,
          ),
        ),
      ),
    );
  }
}
