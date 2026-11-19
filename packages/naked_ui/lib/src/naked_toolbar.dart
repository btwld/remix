import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'utilities/focus_in_view.dart';

/// A single Tab stop for a horizontal row of existing controls.
///
/// Left and Right move focus in reading order, wrapping at the ends. Tab and
/// Shift+Tab leave the toolbar. On entry, focus returns to the last focused
/// control if it is still traversable, or goes to the first traversable one.
/// The controls keep ownership of activation, selection and semantics actions.
/// They also decide whether they remain traversable when disabled.
class NakedToolbar extends StatefulWidget {
  /// Creates a headless toolbar around [child].
  const NakedToolbar({super.key, required this.child, this.semanticLabel});

  /// Caller-owned horizontal layout of controls, without nested focus groups
  /// or scopes. Put text fields and other arrow-operated controls outside it.
  final Widget child;

  /// Accessible name for the group, distinct from the labels of its controls.
  final String? semanticLabel;

  @override
  State<NakedToolbar> createState() => _NakedToolbarState();
}

class _NakedToolbarState extends State<NakedToolbar> {
  final _boundary = FocusNode(debugLabel: 'NakedToolbar');
  late final _policy = _ToolbarTraversalPolicy(() => _lastFocused);
  FocusNode? _lastFocused;
  bool _hadFocusedControl = false;

  @override
  void initState() {
    super.initState();
    FocusManager.instance.addListener(_handleFocusChange);
  }

  bool _containsControl(FocusNode node) =>
      node.ancestors.contains(_boundary) &&
      node.nearestScope == _boundary.nearestScope &&
      FocusTraversalGroup.maybeOfNode(node) == _policy;

  Iterable<FocusNode> get _controls =>
      _boundary.traversalDescendants.where(_containsControl);

  void _handleFocusChange() {
    final focused = FocusManager.instance.primaryFocus;
    final previous = _lastFocused;
    final hadFocusedControl = _hadFocusedControl;
    _hadFocusedControl = false;
    if (focused != null &&
        _containsControl(focused) &&
        !focused.skipTraversal) {
      _lastFocused = focused;
      _hadFocusedControl = true;
    } else if (previous != null && !_containsControl(previous)) {
      _lastFocused = null;
      if (hadFocusedControl && focused == _boundary.enclosingScope) {
        final first = ReadingOrderTraversalPolicy.sort(_controls).firstOrNull;
        if (first != null) requestFocusInView(first);
      }
    }
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final keyboard = HardwareKeyboard.instance;
    if (keyboard.isAltPressed ||
        keyboard.isControlPressed ||
        keyboard.isMetaPressed ||
        keyboard.isShiftPressed) {
      return KeyEventResult.ignored;
    }
    final right = event.logicalKey == LogicalKeyboardKey.arrowRight;
    if (!right && event.logicalKey != LogicalKeyboardKey.arrowLeft) {
      return KeyEventResult.ignored;
    }
    final focused = FocusManager.instance.primaryFocus;
    if (focused == null || !_containsControl(focused)) {
      return KeyEventResult.ignored;
    }
    final controls = ReadingOrderTraversalPolicy.sort(_controls).toList();
    final index = controls.indexOf(focused);
    if (index == -1) return KeyEventResult.ignored;
    final forward = right == (Directionality.of(context) == TextDirection.ltr);
    final next = controls[(index + (forward ? 1 : -1)) % controls.length];
    if (next != focused) requestFocusInView(next);
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: widget.semanticLabel,
      child: FocusTraversalGroup(
        policy: _policy,
        child: Focus(
          focusNode: _boundary,
          canRequestFocus: false,
          skipTraversal: true,
          includeSemantics: false,
          onKeyEvent: _handleKey,
          child: widget.child,
        ),
      ),
    );
  }

  @override
  void dispose() {
    FocusManager.instance.removeListener(_handleFocusChange);
    _boundary.dispose();
    super.dispose();
  }
}

class _ToolbarTraversalPolicy extends ReadingOrderTraversalPolicy {
  _ToolbarTraversalPolicy(this._lastFocused);

  final FocusNode? Function() _lastFocused;

  @override
  Iterable<FocusNode> sortDescendants(
    Iterable<FocusNode> descendants,
    FocusNode currentNode,
  ) {
    if (descendants.contains(currentNode)) return [currentNode];
    final controls = descendants.where(
      (node) => node.canRequestFocus && !node.skipTraversal,
    );
    final last = _lastFocused();
    if (last != null && controls.contains(last)) return [last];
    return ReadingOrderTraversalPolicy.sort(controls).take(1);
  }
}
