import 'dart:ui' show SemanticsRole;

import 'package:flutter/widgets.dart';

import 'utilities/intents.dart';

/// Focus nodes for the triggers in one [NakedMenubar], in tree order.
class MenubarTriggers {
  final List<FocusNode> _nodes = <FocusNode>[];
  FocusNode? _active;

  /// Adds [node] if it is not already registered.
  void register(FocusNode node) {
    if (_nodes.contains(node)) return;
    _nodes.add(node);
  }

  /// Remembers [node] as the trigger whose menu is open.
  void activate(FocusNode node) {
    register(node);
    _active = node;
  }

  /// Removes [node] when its menu leaves the bar.
  void unregister(FocusNode node) {
    _nodes.remove(node);
    if (identical(_active, node)) _active = null;
  }

  /// Moves focus from [from] to the neighboring trigger.
  void move(FocusNode from, {required bool forward}) {
    final origin = _nodes.contains(from) ? from : _active;
    final index = origin == null ? -1 : _nodes.indexOf(origin);
    if (index < 0 || _nodes.length < 2) return;
    final delta = forward ? 1 : -1;
    final next = _nodes[(index + delta + _nodes.length) % _nodes.length];
    next.requestFocus();
  }

  /// Moves focus to the first or last trigger.
  void focusEdge({required bool last}) {
    if (_nodes.isEmpty) return;
    (last ? _nodes.last : _nodes.first).requestFocus();
  }
}

/// Coordinates [NakedMenu] triggers that share a [RawMenuAnchorGroup].
///
/// Not part of the public component surface. [NakedMenu] reads it to switch
/// menus on hover and arrow keys.
class NakedMenubarScope extends InheritedWidget {
  /// Creates a scope describing the bar that encloses [child].
  const NakedMenubarScope({
    super.key,
    required super.child,
    required this.controller,
    required this.isOpen,
    required this.openOnHover,
    required this.triggers,
  });

  /// The group controller. `controller.isOpen` is live, unlike [isOpen],
  /// which is a snapshot from the bar's last build.
  final MenuController controller;

  /// Whether any menu in the bar was open when the bar last built.
  final bool isOpen;

  /// Whether hovering a trigger switches menus while one is already open.
  final bool openOnHover;

  /// Trigger focus nodes registered by menus inside this bar.
  final MenubarTriggers triggers;

  /// The enclosing scope, if [context] is inside a [NakedMenubar].
  static NakedMenubarScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NakedMenubarScope>();
  }

  @override
  bool updateShouldNotify(NakedMenubarScope oldWidget) {
    return isOpen != oldWidget.isOpen || openOnHover != oldWidget.openOnHover;
  }
}

/// Headless menu bar built on [RawMenuAnchorGroup].
///
/// Place [NakedMenu] triggers in [child]. Opening one menu closes the others,
/// and a tap outside closes every menu. This widget adds the bar semantics,
/// focus traversal, and arrow-key movement that [RawMenuAnchorGroup] does not.
///
/// Left or Right from inside a submenu panel closes that submenu first; the
/// next press traverses the bar.
class NakedMenubar extends StatefulWidget {
  /// Creates a menu bar around [child].
  const NakedMenubar({
    super.key,
    required this.child,
    this.controller,
    this.openOnHover = true,
    this.semanticLabel,
    this.excludeSemantics = false,
    this.onOpen,
    this.onClose,
  });

  /// Caller-owned layout of [NakedMenu] triggers.
  final Widget child;

  /// Optional group controller. An internal controller is created when null.
  final MenuController? controller;

  /// When true, hovering another trigger switches menus only while one is open.
  final bool openOnHover;

  /// Accessible name for the menu bar.
  final String? semanticLabel;

  /// Whether to hide this widget from the semantic tree.
  final bool excludeSemantics;

  /// Called when the bar transitions from all-closed to any-open.
  final VoidCallback? onOpen;

  /// Called when the bar transitions from any-open to all-closed.
  final VoidCallback? onClose;

  @override
  State<NakedMenubar> createState() => _NakedMenubarState();
}

class _NakedMenubarState extends State<NakedMenubar> {
  MenuController? _internalController;
  bool? _wasOpen;
  final MenubarTriggers _triggers = MenubarTriggers();

  MenuController get _controller => widget.controller ?? _internalController!;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = MenuController();
    }
  }

  @override
  void didUpdateWidget(NakedMenubar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == null && _internalController == null) {
      _internalController = MenuController();
    } else if (widget.controller != null) {
      _internalController = null;
    }
  }

  void _reportOpen(bool isOpen) {
    final previous = _wasOpen;
    _wasOpen = isOpen;
    if (previous == null || previous == isOpen) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _wasOpen != isOpen) return;
      if (isOpen) {
        widget.onOpen?.call();
      } else {
        widget.onClose?.call();
      }
    });
  }

  void _moveFocus({required bool forward}) {
    final current = FocusManager.instance.primaryFocus;
    if (current == null) return;
    _triggers.move(current, forward: forward);
  }

  void _focusEdge({required bool last}) {
    _triggers.focusEdge(last: last);
  }

  @override
  Widget build(BuildContext context) {
    final direction = Directionality.of(context);

    Widget bar = RawMenuAnchorGroup(
      controller: _controller,
      child: Builder(
        builder: (context) {
          final isOpen = MenuController.maybeIsOpenOf(context) ?? false;
          _reportOpen(isOpen);

          Widget body = FocusTraversalGroup(
            policy: ReadingOrderTraversalPolicy(),
            child: Shortcuts(
              shortcuts: NakedIntentActions.menubar.barShortcuts(direction),
              child: Actions(
                actions: NakedIntentActions.menubar.barActions(
                  onNext: () => _moveFocus(forward: true),
                  onPrevious: () => _moveFocus(forward: false),
                  onFirst: () => _focusEdge(last: false),
                  onLast: () => _focusEdge(last: true),
                ),
                child: NakedMenubarScope(
                  controller: _controller,
                  isOpen: isOpen,
                  openOnHover: widget.openOnHover,
                  triggers: _triggers,
                  child: widget.child,
                ),
              ),
            ),
          );

          body = Semantics(
            role: SemanticsRole.menuBar,
            container: true,
            explicitChildNodes: true,
            label: widget.semanticLabel,
            child: body,
          );

          if (widget.excludeSemantics) {
            body = ExcludeSemantics(child: body);
          }

          return body;
        },
      ),
    );

    return bar;
  }
}
