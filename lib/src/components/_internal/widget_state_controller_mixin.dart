import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

mixin HasEnabled on StatefulWidget {
  /// {@macro remix.component.enabled}
  bool get enabled;
}

mixin HasSelected on StatefulWidget {
  /// {@macro remix.component.selected}
  bool get selected;
  ValueChanged<bool>? get onChanged;
}

mixin HasError on StatefulWidget {
  /// {@macro remix.component.error}
  bool get error;
}

mixin HasFocused on StatefulWidget {
  /// {@macro remix.component.focusNode}
  FocusNode? get focusNode;

  bool get autofocus;
  ValueChanged<bool>? get onFocusChange;
}

mixin HasWidgetStateController<T extends StatefulWidget> on State<T> {
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

mixin HasEnabledState<T extends HasEnabled> on HasWidgetStateController<T> {
  @override
  void initState() {
    super.initState();
    controller.disabled = !widget.enabled;
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.enabled != widget.enabled) {
      controller.disabled = !widget.enabled;
    }
  }
}

mixin HasSelectedState<T extends HasSelected> on HasWidgetStateController<T> {
  @override
  void initState() {
    super.initState();
    controller.selected = widget.selected;
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selected != widget.selected) {
      controller.selected = widget.selected;
    }
  }
}

mixin HasErrorState<T extends HasError> on HasWidgetStateController<T> {
  @override
  void initState() {
    super.initState();
    controller.error = widget.error;
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.error != widget.error) {
      controller.error = widget.error;
    }
  }
}

mixin HasFocusedState<T extends HasFocused> on HasWidgetStateController<T> {
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

    effectiveFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    controller.focused = effectiveFocusNode.hasFocus;
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle transitions between external and internal focus nodes
    if (oldWidget.focusNode != widget.focusNode) {
      if (oldWidget.focusNode == null && widget.focusNode != null) {
        // Switching from internal to external - dispose internal
        _internalFocusNode?.dispose();
        _internalFocusNode = null;
      } else if (oldWidget.focusNode != null && widget.focusNode == null) {
        // Switching from external to internal - create internal
        _internalFocusNode = FocusNode();
      }
    }
  }

  @override
  void dispose() {
    effectiveFocusNode.removeListener(_onFocusChange);
    _internalFocusNode?.dispose();
    super.dispose();
  }
}
