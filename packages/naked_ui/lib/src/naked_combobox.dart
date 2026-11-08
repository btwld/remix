import 'dart:async';
import 'dart:ui' show SemanticsRole;

import 'package:flutter/widgets.dart';

import 'base/overlay_base.dart';
import 'utilities/focus_in_view.dart';
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
  List<Object?> get props => [...super.props, isOpen, value, text];

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
  List<Object?> get props => [...super.props, value, isHighlighted];

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
/// Enter selects the highlighted option. Submission while disabled or while
/// confirming active text composition does not select an option.
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
    required this.claimReveal,
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

  final List<T> options;
  final ValueChanged<T> onSelected;

  /// Returns whether the option at the given index still has to be revealed,
  /// and records that it is being revealed.
  final bool Function(int index) claimReveal;
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
    final index = scope.options.indexOf(value);
    final isHighlighted =
        index >= 0 && AutocompleteHighlightedOption.of(context) == index;
    final isSelected = scope.value == value;
    final effectiveEnabled = enabled && scope.enabled;

    if (isHighlighted && scope.claimReveal(index)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) revealInView(context);
      });
    }

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
/// announcements come from [RawAutocomplete]. This widget adds public state
/// snapshots, selected-value tracking, semantic wrappers, and mount/unmount
/// notifications because [RawAutocomplete] exposes no visibility callbacks.
///
/// Limitations inherited from [RawAutocomplete]:
/// - There is no controlled `open` flag.
/// - Highlight cannot be set programmatically or by hover.
/// - The options view is pinned to the field width and opens [optionsViewOpenDirection]
///   (`down`, `up`, or `mostSpace`). [OverlayPositionConfig] does not apply.
/// - On Flutter 3.41, a selection-only caret change after picking an option
///   can reopen the options list. Replacing selected text with the exact prior
///   query may not reopen it until the text changes again.
/// - An option's `enabled` flag disables its pointer/semantic activation, but
///   does not remove it from RawAutocomplete's keyboard navigation or submit.
///   Filter unavailable options in [optionsBuilder].
///
/// The highlighted option scrolls just far enough into view when the highlight
/// moves and when the options view opens, without moving focus.
///
/// Limitations of that reveal:
/// - Opening reveals the highlighted option too, so a scroll offset the caller
///   gave the options list is replaced when the highlight is outside it.
/// - In a lazily built list such as [ListView.builder], a highlighted option
///   that is not built, such as the last option after Ctrl or Cmd with
///   ArrowDown, is not revealed.
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

  /// Supplies eligible entities for the current field value.
  ///
  /// Equal values are one entity: the first occurrence is retained. Distinct
  /// unequal values may share a display string and remain separate options.
  final AutocompleteOptionsBuilder<T> optionsBuilder;

  /// Builds the text field. This maps to [RawAutocomplete.fieldViewBuilder].
  /// Forward [controller], [focusNode], and the submit callback so selection
  /// and filtering stay in sync.
  final NakedComboboxFieldBuilder<T> fieldBuilder;

  /// Builds the options panel. This maps to
  /// [RawAutocomplete.optionsViewBuilder].
  ///
  /// Place [NakedComboboxOption] widgets inside. The second argument is the
  /// latest result from [optionsBuilder].
  final Widget Function(BuildContext context, Iterable<T> options)
  overlayBuilder;

  /// Called when the user selects an option, after RawAutocomplete writes its
  /// display string. Synchronous text changes here are preserved and reflected
  /// in the next state snapshot.
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
  ///
  /// Does not disable the caller's editor or change its focus or text. Pending
  /// results are discarded when this changes; editing requests new results.
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

// RawAutocomplete retains its selected option even when an onSelected callback
// clears the editor. Keep each delivered option immutable, while enumerating
// Raw's cached iterable with the current *observable selection* identity. A new
// acceptance after that selection is cleared is distinct to Raw; ordinary
// reentry and a still-selected entity retain equality. The public API sees T.
class _RawComboboxOption<T extends Object> {
  const _RawComboboxOption(this.value, this.selectionEpoch);
  final T value;
  final int selectionEpoch;

  @override
  bool operator ==(Object other) =>
      other is _RawComboboxOption<T> &&
      value == other.value &&
      selectionEpoch == other.selectionEpoch;

  @override
  int get hashCode => Object.hash(value, selectionEpoch);
}

class _NakedComboboxState<T extends Object> extends State<NakedCombobox<T>> {
  static final _disabledNavigation = <Type, Action<Intent>>{
    for (final type in [
      AutocompletePreviousOptionIntent,
      AutocompleteNextOptionIntent,
      AutocompleteFirstOptionIntent,
      AutocompleteLastOptionIntent,
      AutocompleteNextPageOptionIntent,
      AutocompletePreviousPageOptionIntent,
      DismissIntent,
    ])
      type: _DisabledComboboxAction(),
  };
  bool _isOpen = false;
  T? _value;
  TextEditingController? _listenedController;
  FocusNode? _listenedFocusNode;
  bool _focused = false;
  int? _revealedIndex;
  String _text = '';
  bool _composing = false;
  bool _handlingSelection = false;
  int _selectionEpoch = 0;
  int _optionsGeneration = 0;
  int _optionsRequest = 0;
  String? _optionsText;
  bool _waitingForOptions = false;
  bool _suppressCachedOptions = false;

  @override
  void didUpdateWidget(covariant NakedCombobox<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enabled != widget.enabled ||
        oldWidget.controller != widget.controller ||
        oldWidget.focusNode != widget.focusNode) {
      _optionsGeneration++;
      if (_waitingForOptions ||
          (oldWidget.controller != widget.controller &&
              widget.controller?.text != _text)) {
        // Raw retains resolved options when its editor pair changes. Suppress
        // that cache when it belongs to different text, as well as when an
        // in-flight query was abandoned. A fresh edit must supply results.
        _suppressCachedOptions = true;
        _optionsText = widget.controller?.text ?? _text;
        _waitingForOptions = false;
      }
    }
    // Detach before RawAutocomplete can dispose its internally owned pair.
    if (!identical(oldWidget.controller, widget.controller)) {
      _listenedController?.removeListener(_syncValueToText);
      _listenedController = null;
    }
    if (!identical(oldWidget.focusNode, widget.focusNode)) {
      _listenedFocusNode?.removeListener(_syncFocus);
      _listenedFocusNode = null;
    }
    _reconcileValue();
  }

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
      _text = controller.text;
      if (_suppressCachedOptions) _optionsText = _text;
      _composing = _hasComposition(controller.value);
      _reconcileValue();
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

  void _reconcileValue() {
    final value = _value;
    final controller = _listenedController;
    if (value != null &&
        controller != null &&
        controller.text != widget.displayStringForOption(value)) {
      _value = null;
      _selectionEpoch++;
    }
  }

  static bool _hasComposition(TextEditingValue value) =>
      value.isComposingRangeValid && !value.composing.isCollapsed;

  void _syncValueToText() {
    final controller = _listenedController;
    if (controller == null || !mounted) return;
    final composing = _hasComposition(controller.value);
    if (_composing && !composing) {
      // EditableText clears composing before invoking onSubmitted. Keep the
      // guard through that synchronous submit, then allow a later acceptance.
      scheduleMicrotask(() {
        if (mounted && identical(controller, _listenedController)) {
          _composing = _hasComposition(controller.value);
        }
      });
    } else {
      _composing = composing;
    }
    if (controller.text == _text) return;
    setState(() {
      _text = controller.text;
      if (!widget.enabled) {
        // Observe disabled edits here regardless of Raw's listener ordering.
        // The next enabled query must be compared with this discarded text.
        _suppressCachedOptions = true;
        _optionsText = _text;
      }
      _reconcileValue();
    });
  }

  void _submit(VoidCallback onFieldSubmitted) {
    if (_composing) return;
    _invokeSelection(onFieldSubmitted);
  }

  void _invokeSelection(VoidCallback select) {
    // RawAutocomplete writes selected text before onSelected. A callback-only
    // guard is too late, including when Raw still holds cached options.
    if (!mounted ||
        !widget.enabled ||
        _suppressCachedOptions ||
        _handlingSelection) {
      return;
    }
    _handlingSelection = true;
    try {
      select();
    } finally {
      _handlingSelection = false;
    }
  }

  void _handleSelected(_RawComboboxOption<T> option) {
    final value = option.value;
    // Cached options can be accepted while a newer query is still pending.
    // Its completion must not reopen suggestions after this acceptance.
    _optionsGeneration++;
    // Selection can replace Raw's last query without calling optionsBuilder.
    // Restart pending-query tracking on either supported SDK's submit path.
    _optionsText = null;
    try {
      widget.onSelected?.call(value);
    } finally {
      if (mounted) {
        setState(() {
          _value = value;
          _reconcileValue();
        });
      }
    }
  }

  void _handleMount() {
    if (!mounted || !widget.enabled || _suppressCachedOptions || _isOpen)
      return;
    setState(() => _isOpen = true);
    widget.onOpen?.call();
  }

  bool _claimReveal(int index) {
    if (_revealedIndex == index) return false;
    _revealedIndex = index;
    return true;
  }

  void _handleUnmount() {
    _revealedIndex = null;
    if (!mounted || !_isOpen) return;
    setState(() => _isOpen = false);
    widget.onClose?.call();
  }

  Future<Iterable<_RawComboboxOption<T>>> _optionsBuilder(
    TextEditingValue value,
  ) {
    if (!widget.enabled) {
      // An empty result would announce a search that did not run. The text
      // listener handles disabled edits and invalidates Raw's retained cache.
      return Completer<Iterable<_RawComboboxOption<T>>>().future;
    }

    final generation = _optionsGeneration;
    // Raw adopts results only for text changes. A faster caret-only invocation
    // must not release the result/cache owned by the pending text invocation.
    final textChanged = value.text != _optionsText;
    _optionsText = value.text;
    if (textChanged) {
      _optionsRequest++;
      _waitingForOptions = true;
    }
    final request = _optionsRequest;
    final result = widget.optionsBuilder(value);
    // Raw awaits synchronous iterables too. Every result must cross the same
    // cancellation boundary before Raw can adopt it or announce its emptiness.
    return Future<Iterable<T>>.value(result).then((options) {
      if (textChanged && request == _optionsRequest) {
        _waitingForOptions = false;
      }
      if (!mounted || !widget.enabled || generation != _optionsGeneration) {
        return Completer<Iterable<_RawComboboxOption<T>>>().future;
      }
      if (textChanged && request == _optionsRequest && _suppressCachedOptions) {
        setState(() => _suppressCachedOptions = false);
      }
      // Equality defines an entity, not its display string. Canonicalize once
      // so Raw and public rows use the same first-occurrence ordering. Map
      // lazily: Raw's retained iterable must use the live selection identity,
      // without changing the equality of an already delivered option.
      return Set<T>.of(
        options,
      ).map((value) => _RawComboboxOption(value, _selectionEpoch));
    });
  }

  Widget _buildFieldView(
    BuildContext context,
    TextEditingController controller,
    FocusNode focusNode,
    VoidCallback onFieldSubmitted,
  ) {
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
      builder: (context, state, _) => Actions(
        // Raw still caches options while disabled. Shadow its navigation so
        // hidden suggestions cannot consume the editor's ordinary shortcuts.
        actions: widget.enabled && !_suppressCachedOptions
            ? const {}
            : _disabledNavigation,
        child: widget.fieldBuilder(
          context,
          state,
          controller,
          focusNode,
          () => _submit(onFieldSubmitted),
        ),
      ),
    );

    if (widget.semanticLabel == null) return field;
    return Semantics(
      container: true,
      label: widget.semanticLabel,
      child: field,
    );
  }

  Widget _buildOptionsView(
    BuildContext context,
    AutocompleteOnSelected<_RawComboboxOption<T>> onSelected,
    Iterable<_RawComboboxOption<T>> options,
  ) {
    // Raw has no public enabled/cache control. Suppress the actual options
    // subtree while retaining its editor, highlight and overlay ownership.
    if (!widget.enabled || _suppressCachedOptions) {
      return const SizedBox.shrink();
    }
    final values = options
        .map((option) => option.value)
        .toList(growable: false);
    final generation = _optionsGeneration;
    return _OverlayLifecycle(
      onMount: _handleMount,
      onUnmount: _handleUnmount,
      child: _NakedComboboxScope<T>(
        options: values,
        onSelected: (value) {
          if (generation == _optionsGeneration) {
            _invokeSelection(
              () => onSelected(_RawComboboxOption(value, _selectionEpoch)),
            );
          }
        },
        claimReveal: _claimReveal,
        enabled: widget.enabled,
        value: _value,
        // The portal's overlay semantics need their own exclusion boundary.
        child: ExcludeSemantics(
          excluding: widget.excludeSemantics,
          child: Semantics(
            role: SemanticsRole.list,
            container: true,
            explicitChildNodes: true,
            child: ExcludeFocus(child: widget.overlayBuilder(context, values)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      excluding: widget.excludeSemantics,
      child: RawAutocomplete<_RawComboboxOption<T>>(
        optionsBuilder: _optionsBuilder,
        displayStringForOption: (option) =>
            widget.displayStringForOption(option.value),
        optionsViewOpenDirection: widget.optionsViewOpenDirection,
        textEditingController: widget.controller,
        focusNode: widget.focusNode,
        initialValue: widget.initialValue,
        onSelected: _handleSelected,
        fieldViewBuilder: _buildFieldView,
        optionsViewBuilder: _buildOptionsView,
      ),
    );
  }
}

/// Makes RawAutocomplete's shortcuts fall through to native editor actions.
class _DisabledComboboxAction extends Action<Intent> {
  @override
  bool isEnabled(Intent intent) => false;

  @override
  Object? invoke(Intent intent) => null;
}
