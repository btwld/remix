import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'utilities/focus_in_view.dart';

/// Presentation and identity for an option in a [NakedListbox].
class NakedListboxOption<T extends Object> {
  /// Creates an option with a child, a state-driven builder, or both.
  const NakedListboxOption({
    required this.value,
    required this.semanticLabel,
    this.enabled = true,
    this.child,
    this.builder,
  }) : assert(semanticLabel != ''),
       assert(child != null || builder != null);

  /// Unique in the listbox, with stable equality and hash code across updates.
  final T value;

  /// Localized accessible name, replacing the row's presentation semantics.
  final String semanticLabel;

  /// Whether this option can receive focus and be activated.
  final bool enabled;

  /// The row presentation, or a static child passed to [builder].
  final Widget? child;

  /// Builds a row from its current state. Do not nest interactive controls.
  final ValueWidgetBuilder<NakedListboxOptionState<T>>? builder;
}

/// The controlled selection and keyboard focus state of an option.
class NakedListboxOptionState<T extends Object> {
  /// Creates an immutable snapshot of an option's current state.
  const NakedListboxOptionState({
    required this.value,
    required this.isSelected,
    required this.isFocused,
    required this.isDisabled,
  });

  /// The value identifying the option.
  final T value;

  /// Whether the caller's current value includes this option.
  final bool isSelected;

  /// Whether the option holds keyboard focus.
  final bool isFocused;

  /// Whether the option is unavailable for interaction.
  final bool isDisabled;
}

/// An always-visible, vertical collection with roving focus and controlled
/// selection. The caller supplies the row visuals and any enclosing scrollable.
///
/// Arrows, Home, and End move focus without selecting. Space, Enter, tapping,
/// and assistive activation request focus and then propose a selection change.
/// Tab and Shift+Tab enter or leave the list through ordinary Flutter traversal.
class NakedListbox<T extends Object> extends StatefulWidget {
  /// Selects one value, or none when [selectedValue] is null.
  ///
  /// [onChanged] proposes a new value and is not called for the current value.
  const NakedListbox({
    super.key,
    required this.options,
    required this.semanticLabel,
    required T? selectedValue,
    ValueChanged<T>? onChanged,
    this.enabled = true,
    this.excludeSemantics = false,
  }) : _selectedValue = selectedValue,
       _onSingleChanged = onChanged,
       _selectedValues = null,
       _onMultipleChanged = null,
       assert(semanticLabel != '');

  /// Toggles each value independently.
  ///
  /// [onChanged] receives an unmodifiable proposed set, retaining values that
  /// are not rendered. Neither the set nor the list of options may be mutated
  /// after being passed to this widget.
  const NakedListbox.multiple({
    super.key,
    required this.options,
    required this.semanticLabel,
    required Set<T> selectedValues,
    ValueChanged<Set<T>>? onChanged,
    this.enabled = true,
    this.excludeSemantics = false,
  }) : _selectedValues = selectedValues,
       _onMultipleChanged = onChanged,
       _selectedValue = null,
       _onSingleChanged = null,
       assert(semanticLabel != '');

  /// The options in visual and keyboard order. Rebuild with a new list to edit it.
  final List<NakedListboxOption<T>> options;

  /// The localized accessible name of the list.
  final String semanticLabel;

  /// Whether the list can accept input. A missing callback also disables input.
  final bool enabled;

  /// Whether to hide the entire list from accessibility services.
  final bool excludeSemantics;

  final T? _selectedValue;
  final Set<T>? _selectedValues;
  final ValueChanged<T>? _onSingleChanged;
  final ValueChanged<Set<T>>? _onMultipleChanged;

  @override
  State<NakedListbox<T>> createState() => _NakedListboxState<T>();
}

class _NakedListboxState<T extends Object> extends State<NakedListbox<T>> {
  Map<T, FocusNode> _nodes = {};
  FocusNode? _focused;
  FocusNode? _tabStop;

  bool _isEnabled(NakedListboxOption<T> option) =>
      widget.enabled &&
      option.enabled &&
      (widget._onSingleChanged != null || widget._onMultipleChanged != null);

  bool _isSelected(T value) =>
      widget._selectedValues?.contains(value) ?? widget._selectedValue == value;

  FocusNode? get _entryNode {
    FocusNode? first;
    for (final option in widget.options) {
      if (!_isEnabled(option)) continue;
      final node = _nodes[option.value]!;
      if (_isSelected(option.value)) return node;
      first ??= node;
    }
    return first;
  }

  @override
  void initState() {
    super.initState();
    _syncOptions();
    FocusManager.instance.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(covariant NakedListbox<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncOptions();
    final focused = _focused;
    if (focused != null &&
        !listEquals(
          [for (final option in oldWidget.options) option.value],
          [for (final option in widget.options) option.value],
        )) {
      _revealAfterLayout(focused);
    }
  }

  @override
  void dispose() {
    FocusManager.instance.removeListener(_handleFocusChange);
    for (final node in _nodes.values) {
      node.dispose();
    }
    super.dispose();
  }

  void _syncOptions() {
    assert(
      widget.options.map((option) => option.value).toSet().length ==
          widget.options.length,
      'NakedListbox option values must be unique.',
    );
    final previous = _nodes;
    _nodes = {
      for (final option in widget.options)
        option.value:
            (previous.remove(option.value) ?? _ListboxFocusNode(context))
              ..canRequestFocus = _isEnabled(option),
    };
    final focused = _focused;
    if (focused != null &&
        (previous.containsValue(focused) || !focused.canRequestFocus)) {
      _focused = null;
      focused.unfocus(disposition: UnfocusDisposition.previouslyFocusedChild);
      _entryNode?.requestFocus();
    }
    _updateTabStop();
    if (previous.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        for (final node in previous.values) {
          node.dispose();
        }
      });
    }
  }

  void _handleFocusChange() {
    final primary = FocusManager.instance.primaryFocus;
    final focused = _nodes.containsValue(primary) ? primary : null;
    if (_focused == focused) return;
    setState(() {
      _focused = focused;
      _updateTabStop();
    });
    if (focused != null) _revealAfterLayout(focused);
  }

  void _revealAfterLayout(FocusNode node) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !node.hasPrimaryFocus) return;
      final rowContext = node.context;
      if (rowContext != null && rowContext.mounted) revealInView(rowContext);
    });
  }

  void _updateTabStop() {
    final next = _focused ?? _entryNode;
    if (_tabStop == next) return;
    _tabStop?.skipTraversal = true;
    next?.skipTraversal = false;
    _tabStop = next;
  }

  void _activate(NakedListboxOption<T> option) {
    if (!_isEnabled(option)) return;
    requestFocusInView(_nodes[option.value]!);
    final selected = widget._selectedValues;
    if (selected != null) {
      final next = Set<T>.of(selected);
      if (!next.remove(option.value)) next.add(option.value);
      widget._onMultipleChanged?.call(Set<T>.unmodifiable(next));
    } else if (!_isSelected(option.value)) {
      widget._onSingleChanged?.call(option.value);
    }
  }

  KeyEventResult _handleKey(NakedListboxOption<T> option, KeyEvent event) {
    final keyboard = HardwareKeyboard.instance;
    if (!_isEnabled(option) ||
        keyboard.isShiftPressed ||
        keyboard.isControlPressed ||
        keyboard.isAltPressed ||
        keyboard.isMetaPressed) {
      return KeyEventResult.ignored;
    }
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.space ||
        key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter) {
      if (event is KeyDownEvent) _activate(option);
      return KeyEventResult.handled;
    }
    final int start;
    final int step;
    if (key == LogicalKeyboardKey.home) {
      start = 0;
      step = 1;
    } else if (key == LogicalKeyboardKey.end) {
      start = widget.options.length - 1;
      step = -1;
    } else if (key == LogicalKeyboardKey.arrowDown ||
        key == LogicalKeyboardKey.arrowUp) {
      step = key == LogicalKeyboardKey.arrowDown ? 1 : -1;
      start = widget.options.indexOf(option) + step;
    } else {
      return KeyEventResult.ignored;
    }
    if (event is! KeyUpEvent) {
      for (
        var index = start;
        index >= 0 && index < widget.options.length;
        index += step
      ) {
        final target = widget.options[index];
        if (_isEnabled(target)) {
          requestFocusInView(_nodes[target.value]!);
          break;
        }
      }
    }
    return KeyEventResult.handled;
  }

  Widget _buildOption(NakedListboxOption<T> option) {
    final node = _nodes[option.value]!;
    final enabled = _isEnabled(option);
    final selected = _isSelected(option.value);
    final focusable = enabled && node == _tabStop;
    final focused = enabled && node == _focused;
    final activate = enabled ? () => _activate(option) : null;
    return Focus(
      key: ValueKey(option.value),
      focusNode: node,
      includeSemantics: false,
      descendantsAreFocusable: false,
      onKeyEvent: (_, event) => _handleKey(option, event),
      child: Semantics(
        role: SemanticsRole.listItem,
        container: true,
        explicitChildNodes: true,
        child: Semantics(
          container: true,
          label: option.semanticLabel,
          checked: selected,
          inMutuallyExclusiveGroup: widget._selectedValues == null,
          enabled: enabled,
          focusable: focusable,
          focused: focusable ? focused : null,
          onFocus: focusable && defaultTargetPlatform != TargetPlatform.iOS
              ? node.requestFocus
              : null,
          onTap: activate,
          excludeSemantics: true,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            excludeFromSemantics: true,
            onTap: activate,
            child: option.builder == null
                ? option.child!
                : Builder(
                    builder: (context) => option.builder!(
                      context,
                      NakedListboxOptionState(
                        value: option.value,
                        isSelected: selected,
                        isFocused: focused,
                        isDisabled: !enabled,
                      ),
                      option.child,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      excluding: widget.excludeSemantics,
      child: Semantics(
        container: true,
        explicitChildNodes: true,
        role: SemanticsRole.list,
        label: widget.semanticLabel,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [for (final option in widget.options) _buildOption(option)],
        ),
      ),
    );
  }
}

class _ListboxFocusNode extends FocusNode {
  _ListboxFocusNode(this.listContext) : super(skipTraversal: true);

  final BuildContext listContext;

  @override
  Rect get rect {
    final list = listContext.findRenderObject()!;
    var viewport = RenderAbstractViewport.maybeOf(list);
    if (viewport == null) return super.rect;

    var bounds = _globalBounds(list);
    while (viewport != null) {
      final clip = _globalBounds(viewport);
      if (!bounds.overlaps(clip)) break;
      bounds = bounds.intersect(clip);
      viewport = RenderAbstractViewport.maybeOf(viewport.parent);
    }
    return bounds;
  }

  Rect _globalBounds(RenderObject object) => MatrixUtils.transformRect(
    object.getTransformTo(null),
    object.semanticBounds,
  );
}
