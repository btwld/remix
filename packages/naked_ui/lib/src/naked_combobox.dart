import 'dart:async';
import 'dart:ui' show SemanticsRole;

import 'package:flutter/widgets.dart';

import 'base/overlay_base.dart';
import 'utilities/naked_state_scope.dart';
import 'utilities/state.dart';

/// Immutable view passed to [NakedCombobox.fieldBuilder].
class NakedComboboxState<T extends Object> extends NakedState {
  /// Whether the options view is currently mounted.
  final bool isOpen;

  /// Last selected option.
  ///
  /// Becomes null once the field text no longer matches
  /// [NakedCombobox.displayStringForOption] for this value.
  final T? value;

  /// Current field text.
  final String text;

  /// Creates an immutable snapshot of combobox state.
  NakedComboboxState({
    required super.states,
    required this.isOpen,
    required this.value,
    required this.text,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NakedComboboxState<T> &&
        statesEqual(other) &&
        other.isOpen == isOpen &&
        other.value == value &&
        other.text == text;
  }

  @override
  int get hashCode => Object.hash(statesHashCode, isOpen, value, text);

  /// Returns the nearest [NakedComboboxState] of the requested type.
  static NakedComboboxState<S> of<S extends Object>(BuildContext context) =>
      NakedState.of(context);

  /// Returns the nearest [NakedComboboxState] if available.
  static NakedComboboxState<S>? maybeOf<S extends Object>(
    BuildContext context,
  ) => NakedState.maybeOf(context);

  /// Returns the [WidgetStatesController] from the nearest scope.
  static WidgetStatesController controllerOf<S extends Object>(
    BuildContext context,
  ) => NakedState.controllerOf<NakedComboboxState<S>>(context);

  /// Returns the [WidgetStatesController] from the nearest scope, if any.
  static WidgetStatesController? maybeControllerOf<S extends Object>(
    BuildContext context,
  ) => NakedState.maybeControllerOf<NakedComboboxState<S>>(context);
}

/// Immutable view passed to [NakedComboboxOption] builders.
class NakedComboboxOptionState<T extends Object> extends NakedState {
  /// The option's value.
  final T value;

  /// Whether keyboard navigation currently highlights this option.
  final bool isHighlighted;

  /// Creates an immutable snapshot for the option associated with [value].
  NakedComboboxOptionState({
    required super.states,
    required this.value,
    required this.isHighlighted,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NakedComboboxOptionState<T> &&
        statesEqual(other) &&
        other.value == value &&
        other.isHighlighted == isHighlighted;
  }

  @override
  int get hashCode => Object.hash(statesHashCode, value, isHighlighted);

  /// Returns the nearest [NakedComboboxOptionState] of the requested type.
  static NakedComboboxOptionState<S> of<S extends Object>(
    BuildContext context,
  ) => NakedState.of(context);

  /// Returns the nearest [NakedComboboxOptionState] if available.
  static NakedComboboxOptionState<S>? maybeOf<S extends Object>(
    BuildContext context,
  ) => NakedState.maybeOf(context);

  /// Returns the [WidgetStatesController] from the nearest scope.
  static WidgetStatesController controllerOf<S extends Object>(
    BuildContext context,
  ) => NakedState.controllerOf<NakedComboboxOptionState<S>>(context);

  /// Returns the [WidgetStatesController] from the nearest scope, if any.
  static WidgetStatesController? maybeControllerOf<S extends Object>(
    BuildContext context,
  ) => NakedState.maybeControllerOf<NakedComboboxOptionState<S>>(context);
}

/// Builds the text field for a [NakedCombobox].
///
/// [onFieldSubmitted] must be forwarded to the field's submit handler so
/// Enter selects the highlighted option.
typedef NakedComboboxFieldBuilder<T extends Object> =
    Widget Function(
      BuildContext context,
      NakedComboboxState<T> state,
      TextEditingController controller,
      FocusNode focusNode,
      VoidCallback onFieldSubmitted,
    );

/// Internal scope provided by [NakedCombobox] to its options view.
class _NakedComboboxScope<T extends Object> extends OverlayScope<T> {
  const _NakedComboboxScope({
    super.key,
    required super.child,
    required this.options,
    required this.onSelected,
    required this.enabled,
    this.value,
  });

  /// Returns the scope that most tightly encloses [context].
  static _NakedComboboxScope<T> of<T extends Object>(BuildContext context) {
    return OverlayScope.of(
      context,
      scopeConsumer: NakedComboboxOption,
      scopeOwner: NakedCombobox,
    );
  }

  final Iterable<T> options;
  final ValueChanged<T> onSelected;
  final bool enabled;
  final T? value;

  @override
  bool updateShouldNotify(covariant _NakedComboboxScope<T> oldWidget) {
    return !identical(options, oldWidget.options) ||
        onSelected != oldWidget.onSelected ||
        enabled != oldWidget.enabled ||
        value != oldWidget.value;
  }
}

/// A selectable option inside [NakedCombobox.overlayBuilder].
class NakedComboboxOption<T extends Object>
    extends OverlayItem<T, NakedComboboxOptionState<T>> {
  /// Creates a selectable option associated with [value].
  const NakedComboboxOption({
    super.key,
    required super.value,
    super.enabled = true,
    super.semanticLabel,
    super.child,
    super.builder,
  });

  @override
  Widget build(BuildContext context) {
    final scope = _NakedComboboxScope.of<T>(context);
    final options = scope.options.toList(growable: false);
    final index = options.indexOf(value);
    final isHighlighted =
        index >= 0 && AutocompleteHighlightedOption.of(context) == index;
    final isSelected = scope.value == value;
    final effectiveEnabled = enabled && scope.enabled;

    return buildButton(
      onPressed: effectiveEnabled ? () => scope.onSelected(value) : null,
      effectiveEnabled: effectiveEnabled,
      isSelected: isSelected,
      mapStates: (states) {
        final effective = <WidgetState>{...states};
        if (isHighlighted) effective.add(WidgetState.focused);

        return NakedComboboxOptionState<T>(
          states: effective,
          value: value,
          isHighlighted: isHighlighted,
        );
      },
    );
  }
}

/// Reports options-view mount and unmount without reading private
/// [RawAutocomplete] visibility.
class _OverlayLifecycle extends StatefulWidget {
  const _OverlayLifecycle({
    required this.onMount,
    required this.onUnmount,
    required this.child,
  });

  final VoidCallback onMount;
  final VoidCallback onUnmount;
  final Widget child;

  @override
  State<_OverlayLifecycle> createState() => _OverlayLifecycleState();
}

class _OverlayLifecycleState extends State<_OverlayLifecycle> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onMount();
    });
  }

  @override
  void dispose() {
    final onUnmount = widget.onUnmount;
    WidgetsBinding.instance.addPostFrameCallback((_) => onUnmount());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// Headless combobox built on [RawAutocomplete].
///
/// The caller owns the field and the options panel. Keyboard highlight, Enter
/// to select, Escape to dismiss, async option staleness, and result
/// announcements come from [RawAutocomplete].
///
/// Limitations inherited from [RawAutocomplete]:
/// - There is no controlled `open` flag.
/// - Highlight cannot be set programmatically or by hover.
/// - The options view is pinned to the field width and opens [optionsViewOpenDirection]
///   (`down`, `up`, or `mostSpace`). [OverlayPositionConfig] does not apply.
///
/// [SemanticsRole.comboBox] is not used: on Flutter 3.41 debug semantics throw
/// `Missing checks for role` for that role.
class NakedCombobox<T extends Object> extends StatefulWidget {
  /// Creates a combobox whose options come from [optionsBuilder].
  const NakedCombobox({
    super.key,
    required this.optionsBuilder,
    required this.fieldBuilder,
    required this.overlayBuilder,
    this.onSelected,
    this.displayStringForOption = RawAutocomplete.defaultStringForOption,
    this.optionsViewOpenDirection = OptionsViewOpenDirection.down,
    this.controller,
    this.focusNode,
    this.initialValue,
    this.enabled = true,
    this.onOpen,
    this.onClose,
    this.semanticLabel,
    this.excludeSemantics = false,
  }) : assert(
         (controller == null) == (focusNode == null),
         'TextEditingController and FocusNode must both be supplied or both be null.',
       ),
       assert(
         !(controller != null && initialValue != null),
         'controller and initialValue cannot be simultaneously defined.',
       );

  /// Type alias for [NakedComboboxOption].
  static final Option = NakedComboboxOption.new;

  /// Supplies the options for the current field value.
  final AutocompleteOptionsBuilder<T> optionsBuilder;

  /// Builds the text field. Forward [controller], [focusNode], and the submit
  /// callback so selection and filtering stay in sync.
  final NakedComboboxFieldBuilder<T> fieldBuilder;

  /// Builds the options panel.
  ///
  /// Place [NakedComboboxOption] widgets inside. The second argument is the
  /// latest result from [optionsBuilder].
  final Widget Function(BuildContext context, Iterable<T> options)
  overlayBuilder;

  /// Called when the user selects an option.
  final ValueChanged<T>? onSelected;

  /// String written into the field when [T] is selected.
  final AutocompleteOptionToString<T> displayStringForOption;

  /// Whether the options view opens above or below the field.
  final OptionsViewOpenDirection optionsViewOpenDirection;

  /// Optional field controller. Must be paired with [focusNode].
  final TextEditingController? controller;

  /// Optional field focus node. Must be paired with [controller].
  final FocusNode? focusNode;

  /// Initial text when [controller] is null.
  final TextEditingValue? initialValue;

  /// Whether the combobox can open and select.
  final bool enabled;

  /// Called when the options view is mounted.
  final VoidCallback? onOpen;

  /// Called when the options view is unmounted.
  final VoidCallback? onClose;

  /// Accessible name for the field container.
  final String? semanticLabel;

  /// Whether to hide this widget from the semantic tree.
  final bool excludeSemantics;

  @override
  State<NakedCombobox<T>> createState() => _NakedComboboxState<T>();
}

class _NakedComboboxState<T extends Object> extends State<NakedCombobox<T>> {
  bool _isOpen = false;
  T? _value;
  TextEditingController? _listenedController;
  FocusNode? _listenedFocusNode;
  bool _focused = false;

  @override
  void dispose() {
    _listenedController?.removeListener(_syncValueToText);
    _listenedFocusNode?.removeListener(_syncFocus);
    super.dispose();
  }

  void _attachField(TextEditingController controller, FocusNode focusNode) {
    if (!identical(_listenedController, controller)) {
      _listenedController?.removeListener(_syncValueToText);
      _listenedController = controller;
      controller.addListener(_syncValueToText);
    }
    if (!identical(_listenedFocusNode, focusNode)) {
      _listenedFocusNode?.removeListener(_syncFocus);
      _listenedFocusNode = focusNode;
      _focused = focusNode.hasFocus;
      focusNode.addListener(_syncFocus);
    }
  }

  void _syncFocus() {
    final focused = _listenedFocusNode?.hasFocus ?? false;
    if (focused == _focused || !mounted) return;
    setState(() => _focused = focused);
  }

  void _syncValueToText() {
    final value = _value;
    final controller = _listenedController;
    if (value == null || controller == null || !mounted) return;
    if (controller.text == widget.displayStringForOption(value)) return;
    setState(() => _value = null);
  }

  void _handleSelected(T value) {
    widget.onSelected?.call(value);
    if (!mounted) return;
    setState(() => _value = value);
  }

  void _handleMount() {
    if (!mounted || _isOpen) return;
    setState(() => _isOpen = true);
    widget.onOpen?.call();
  }

  void _handleUnmount() {
    if (!mounted || !_isOpen) return;
    setState(() => _isOpen = false);
    widget.onClose?.call();
  }

  FutureOr<Iterable<T>> _optionsBuilder(TextEditingValue value) {
    if (!widget.enabled) return const Iterable.empty();

    return widget.optionsBuilder(value);
  }

  @override
  Widget build(BuildContext context) {
    Widget combobox = RawAutocomplete<T>(
      optionsBuilder: _optionsBuilder,
      displayStringForOption: widget.displayStringForOption,
      optionsViewOpenDirection: widget.optionsViewOpenDirection,
      textEditingController: widget.controller,
      focusNode: widget.focusNode,
      initialValue: widget.initialValue,
      onSelected: _handleSelected,
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        _attachField(controller, focusNode);
        final state = NakedComboboxState<T>(
          states: {
            if (!widget.enabled) WidgetState.disabled,
            if (_focused) WidgetState.focused,
          },
          isOpen: _isOpen,
          value: _value,
          text: controller.text,
        );

        final field = NakedStateScopeBuilder<NakedComboboxState<T>>(
          value: state,
          builder: (context, state, _) => widget.fieldBuilder(
            context,
            state,
            controller,
            focusNode,
            onFieldSubmitted,
          ),
        );

        if (widget.semanticLabel == null) return field;

        return Semantics(
          container: true,
          label: widget.semanticLabel,
          child: field,
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return _OverlayLifecycle(
          onMount: _handleMount,
          onUnmount: _handleUnmount,
          child: _NakedComboboxScope<T>(
            options: options,
            onSelected: onSelected,
            enabled: widget.enabled,
            value: _value,
            child: Semantics(
              role: SemanticsRole.list,
              container: true,
              explicitChildNodes: true,
              child: widget.overlayBuilder(context, options),
            ),
          ),
        );
      },
    );

    if (widget.excludeSemantics) {
      combobox = ExcludeSemantics(child: combobox);
    }

    return combobox;
  }
}
