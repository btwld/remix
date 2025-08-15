import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

mixin Disableable on StatefulWidget {
  /// {@macro remix.component.enabled}
  bool get enabled;
}

mixin Selectable on StatefulWidget {
  /// {@macro remix.component.selected}
  bool get selected;
}

mixin Errorable on StatefulWidget {
  /// {@macro remix.component.error}
  bool get error;
}

mixin Focusable on StatefulWidget {
  /// {@macro remix.component.focusNode}
  FocusNode? get focusNode;
}

mixin WidgetStateMixin<T extends StatefulWidget> on State<T> {
  late final WidgetStatesController controller;

  @override
  void initState() {
    super.initState();
    controller = WidgetStatesController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

mixin DisableableMixin<T extends Disableable> on WidgetStateMixin<T> {
  @override
  void initState() {
    super.initState();
    controller.disabled = !widget.enabled;
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldDisableable = oldWidget as Disableable;
    if (oldDisableable.enabled != widget.enabled) {
      controller.disabled = !widget.enabled;
    }
  }
}

mixin SelectableMixin<T extends Selectable> on WidgetStateMixin<T> {
  @override
  void initState() {
    super.initState();
    controller.selected = widget.selected;
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldSelectable = oldWidget as Selectable;
    if (oldSelectable.selected != widget.selected) {
      controller.selected = widget.selected;
    }
  }
}

mixin ErrorableMixin<T extends Errorable> on WidgetStateMixin<T> {
  @override
  void initState() {
    super.initState();
    controller.error = widget.error;
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldErrorable = oldWidget as Errorable;
    if (oldErrorable.error != widget.error) {
      controller.error = widget.error;
    }
  }
}

mixin FocusableMixin<T extends Focusable> on WidgetStateMixin<T> {
  FocusNode? _internalFocusNode;

  /// Returns the focus node to use - either the provided one or the internal one
  FocusNode get effectiveFocusNode {
    if (widget.focusNode != null) {
      return widget.focusNode!;
    }

    return _internalFocusNode ??= FocusNode();
  }

  @override
  void initState() {
    super.initState();
    // If no external focus node is provided, create an internal one
    if (widget.focusNode == null) {
      _internalFocusNode = FocusNode();
    }
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldFocusable = oldWidget as Focusable;

    // Handle transitions between external and internal focus nodes
    if (oldFocusable.focusNode != widget.focusNode) {
      if (oldFocusable.focusNode == null && widget.focusNode != null) {
        // Switching from internal to external - dispose internal
        _internalFocusNode?.dispose();
        _internalFocusNode = null;
      } else if (oldFocusable.focusNode != null && widget.focusNode == null) {
        // Switching from external to internal - create internal
        _internalFocusNode = FocusNode();
      }
    }
  }

  @override
  void dispose() {
    // Only dispose the internal focus node if we created it
    _internalFocusNode?.dispose();
    super.dispose();
  }
}
