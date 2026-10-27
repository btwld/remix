import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'mixins/naked_mixins.dart';
import 'utilities/naked_state_scope.dart';
import 'utilities/state.dart';

/// Formats one slider thumb's value for assistive technologies.
typedef NakedSliderSemanticFormatterCallback = String Function(double value);

/// Marks the rendered rail whose bounds map pointer positions to values.
///
/// Place one inside [NakedSlider.builder] when the painted rail is inset from
/// the full hit target. Without a marker, input uses the slider's full bounds.
/// This widget adds no padding, painting, or gesture handling.
class NakedSliderTrack extends StatelessWidget {
  /// Creates a geometry marker around the slider's rail.
  const NakedSliderTrack({super.key, required this.child});

  /// The rail, including its complete value span.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<_NakedSliderTrackScope>();
    assert(scope != null, 'NakedSliderTrack must be inside NakedSlider');

    return KeyedSubtree(key: scope!.trackKey, child: child);
  }
}

class _NakedSliderTrackScope extends InheritedWidget {
  const _NakedSliderTrackScope({required this.trackKey, required super.child});

  final GlobalKey trackKey;

  @override
  bool updateShouldNotify(_NakedSliderTrackScope oldWidget) =>
      trackKey != oldWidget.trackKey;
}

/// Immutable view passed to [NakedSlider.builder].
class NakedSliderState extends NakedState {
  /// Creates an immutable snapshot of slider state.
  NakedSliderState({
    required super.states,
    required List<double> values,
    required this.min,
    required this.max,
    required this.step,
    required this.minSpacing,
    required this.orientation,
    required this.inverted,
    required this.textDirection,
    required this.isDragging,
    this.activeThumbIndex,
    this.focusedThumbIndex,
  }) : values = List<double>.unmodifiable(values);

  /// The current controlled values, in ascending order.
  final List<double> values;

  /// The minimum value of the slider.
  final double min;

  /// The maximum value of the slider.
  final double max;

  /// The interval used for pointer, keyboard, and semantic changes.
  final double step;

  /// The minimum value-space distance between adjacent thumbs.
  final double minSpacing;

  /// The axis along which thumbs move.
  final Axis orientation;

  /// Whether the visual value direction is reversed.
  final bool inverted;

  /// The ambient text direction used for horizontal placement.
  final TextDirection textDirection;

  /// Whether a pointer interaction is active.
  final bool isDragging;

  /// The thumb currently controlled by a pointer, if any.
  final int? activeThumbIndex;

  /// The thumb with keyboard focus, if any.
  final int? focusedThumbIndex;

  /// Returns the nearest [NakedSliderState] provided by [NakedStateScope].
  static NakedSliderState of(BuildContext context) => NakedState.of(context);

  /// Returns the nearest [NakedSliderState] if one is available.
  static NakedSliderState? maybeOf(BuildContext context) =>
      NakedState.maybeOf(context);

  /// Returns the [WidgetStatesController] from the nearest scope.
  static WidgetStatesController controllerOf(BuildContext context) =>
      NakedState.controllerOf<NakedSliderState>(context);

  /// Returns the [WidgetStatesController] from the nearest scope, if any.
  static WidgetStatesController? maybeControllerOf(BuildContext context) =>
      NakedState.maybeControllerOf<NakedSliderState>(context);

  /// The logical percentage for the value at [index].
  double percentageAt(int index) => (values[index] - min) / (max - min);

  /// The logical percentage for every thumb.
  List<double> get percentages => List<double>.unmodifiable(
    List<double>.generate(values.length, percentageAt),
  );

  /// The physical alignment along [orientation] for a logical [percentage].
  ///
  /// [percentage] is a logical fraction where zero is [min] and one is [max].
  /// The result is zero at the left/top edge and one at the right/bottom edge,
  /// accounting for [orientation], [textDirection], and [inverted]. Use this for
  /// track decorations that are not tied to a thumb, such as the origin of a
  /// range fill, where [visualPercentageAt] (keyed by thumb index) does not fit.
  double visualPercentageOf(double percentage) {
    var result = percentage;
    if (orientation == Axis.horizontal && textDirection == TextDirection.rtl) {
      result = 1 - result;
    } else if (orientation == Axis.vertical) {
      result = 1 - result;
    }
    if (inverted) result = 1 - result;

    return result;
  }

  /// The physical alignment along [orientation] for the thumb at [index].
  ///
  /// The result is zero at the left/top edge and one at the right/bottom edge.
  double visualPercentageAt(int index) =>
      visualPercentageOf(percentageAt(index));

  @override
  List<Object?> get props => [
    ...super.props,
    min,
    max,
    step,
    minSpacing,
    orientation,
    inverted,
    textDirection,
    isDragging,
    activeThumbIndex,
    focusedThumbIndex,
    values,
  ];
}

/// A headless, controlled, arbitrary multi-thumb slider.
///
/// [values] must be nonempty, ascending, in range, and separated by at least
/// [minSpacing]. Pointer input selects the nearest thumb. Pointer, keyboard,
/// and semantic changes snap to [step] and never cross adjacent thumbs.
///
/// Each thumb owns an independent focus and slider semantics node. Supply
/// [focusNodes], [semanticLabels], or [semanticFormatterCallbacks] when a
/// product needs to customize them.
///
/// ```dart
/// NakedSlider(
///   values: values,
///   onChanged: (next) => setState(() => values = next),
///   builder: (context, state, child) => MySlider(
///     percentages: state.percentages,
///     activeThumbIndex: state.activeThumbIndex,
///   ),
/// )
/// ```
class NakedSlider extends StatefulWidget {
  /// Creates a headless slider controlled by [values].
  const NakedSlider({
    super.key,
    this.child,
    this.builder,
    required this.values,
    this.min = 0,
    this.max = 100,
    this.step = 1,
    this.minSpacing = 0,
    this.orientation = Axis.horizontal,
    this.inverted = false,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.onHoverChange,
    this.onDragChange,
    this.onFocusChange,
    this.enabled = true,
    this.mouseCursor = SystemMouseCursors.click,
    this.enableFeedback = true,
    this.focusNodes,
    this.autofocusThumbIndex,
    this.semanticLabels,
    this.semanticFormatterCallbacks,
    this.excludeSemantics = false,
  }) : assert(values.length > 0, 'values must not be empty'),
       assert(
         min > double.negativeInfinity &&
             min < double.infinity &&
             max > double.negativeInfinity &&
             max < double.infinity,
         'min and max must be finite',
       ),
       assert(min < max, 'min must be less than max'),
       assert(
         step > 0 && step < double.infinity,
         'step must be finite and positive',
       ),
       assert(
         minSpacing >= 0 && minSpacing < double.infinity,
         'minSpacing must be finite and non-negative',
       ),
       assert(
         focusNodes == null || focusNodes.length == values.length,
         'focusNodes must have one entry per value',
       ),
       assert(
         semanticLabels == null || semanticLabels.length == values.length,
         'semanticLabels must have one entry per value',
       ),
       assert(
         semanticFormatterCallbacks == null ||
             semanticFormatterCallbacks.length == values.length,
         'semanticFormatterCallbacks must have one entry per value',
       ),
       assert(
         autofocusThumbIndex == null ||
             (autofocusThumbIndex >= 0 && autofocusThumbIndex < values.length),
         'autofocusThumbIndex must identify a value',
       ),
       assert(
         child != null || builder != null,
         'Either child or builder must be provided',
       );

  /// The slider content (track, range, and visual thumbs).
  final Widget? child;

  /// Builds the visual slider using the current [NakedSliderState].
  final ValueWidgetBuilder<NakedSliderState>? builder;

  /// The current controlled values, in ascending order.
  final List<double> values;

  /// The minimum value of the range.
  final double min;

  /// The maximum value of the range.
  final double max;

  /// The interval used for pointer, keyboard, and semantic changes.
  final double step;

  /// The minimum value-space distance between adjacent thumbs.
  final double minSpacing;

  /// The axis along which thumbs move.
  final Axis orientation;

  /// Whether the visual value direction is reversed.
  final bool inverted;

  /// Called with the complete value list when one thumb changes.
  final ValueChanged<List<double>>? onChanged;

  /// Called with the value list at the start of a pointer interaction.
  final ValueChanged<List<double>>? onChangeStart;

  /// Called with the last requested value list at the end of an interaction.
  ///
  /// The callback present at the start owns the complete pointer interaction.
  /// Disabling or changing the thumb count or interaction configuration ends
  /// that interaction with its previous value list, after the current frame.
  final ValueChanged<List<double>>? onChangeEnd;

  /// Called when pointer hover changes.
  final ValueChanged<bool>? onHoverChange;

  /// Called when pointer-drag state changes.
  final ValueChanged<bool>? onDragChange;

  /// Called when aggregate thumb focus changes.
  final ValueChanged<bool>? onFocusChange;

  /// Whether user interaction is enabled.
  final bool enabled;

  /// The mouse cursor when enabled.
  final MouseCursor mouseCursor;

  /// Whether to provide platform feedback on value changes.
  final bool enableFeedback;

  /// Optional externally owned focus nodes, one per thumb.
  ///
  /// A null entry asks the slider to own that thumb's node.
  final List<FocusNode?>? focusNodes;

  /// The thumb that should request focus when first built.
  final int? autofocusThumbIndex;

  /// Optional semantic labels, one per thumb.
  final List<String?>? semanticLabels;

  /// Optional semantic formatters, one per thumb.
  final List<NakedSliderSemanticFormatterCallback?>? semanticFormatterCallbacks;

  /// Whether to hide all slider nodes from the semantic tree.
  final bool excludeSemantics;

  @override
  State<NakedSlider> createState() {
    assert(
      _debugValidSliderValues(values, min, max, minSpacing),
      'values must be finite, ascending, in range, and honor minSpacing',
    );

    return _NakedSliderState();
  }
}

bool _debugValidSliderValues(
  List<double> values,
  double min,
  double max,
  double minSpacing,
) {
  for (var index = 0; index < values.length; index++) {
    final value = values[index];
    if (!value.isFinite || value < min || value > max) return false;
    if (index > 0 && value - values[index - 1] < minSpacing) return false;
  }

  return true;
}

class _NakedSliderState extends State<NakedSlider>
    with WidgetStatesMixin<NakedSlider> {
  late List<FocusNode> _effectiveFocusNodes;
  late List<FocusNode> _ownedFocusNodes;
  late List<double> _workingValues;

  bool _isDragging = false;
  int? _activeThumbIndex;
  int? _focusedThumbIndex;
  final Set<int> _focusedThumbIndices = <int>{};
  int _focusLossGeneration = 0;
  List<double>? _lastRequestedValues;
  final _trackKey = GlobalKey();
  List<double>? _pointerStartValues;
  ValueChanged<List<double>>? _pointerEndCallback;
  ValueChanged<bool>? _pointerDragCallback;

  bool get _isEnabled => widget.enabled && widget.onChanged != null;

  TextDirection get _textDirection => Directionality.of(context);

  MouseCursor get _cursor =>
      _isEnabled ? widget.mouseCursor : SystemMouseCursors.basic;

  @override
  void initState() {
    super.initState();
    _workingValues = List<double>.of(widget.values);
    _createFocusNodes();
  }

  void _createFocusNodes() {
    final supplied = widget.focusNodes;
    _ownedFocusNodes = <FocusNode>[];
    _effectiveFocusNodes = List<FocusNode>.generate(widget.values.length, (
      index,
    ) {
      final external = supplied?[index];
      if (external != null) return external;

      final owned = FocusNode(debugLabel: 'NakedSlider thumb $index');
      _ownedFocusNodes.add(owned);

      return owned;
    });
  }

  bool _focusConfigurationChanged(NakedSlider oldWidget) {
    if (oldWidget.values.length != widget.values.length) return true;
    final oldNodes = oldWidget.focusNodes;
    final newNodes = widget.focusNodes;
    if (identical(oldNodes, newNodes)) return false;
    for (var index = 0; index < widget.values.length; index++) {
      if (!identical(oldNodes?[index], newNodes?[index])) return true;
    }

    return false;
  }

  void _replaceFocusNodes(NakedSlider oldWidget) {
    final oldOwned = _ownedFocusNodes;
    final oldEffective = _effectiveFocusNodes;
    final transferIndex = _focusedThumbIndex;
    final focusedNode = transferIndex == null
        ? null
        : oldEffective[transferIndex];
    _ownedFocusNodes = <FocusNode>[];
    _effectiveFocusNodes = List<FocusNode>.generate(widget.values.length, (
      index,
    ) {
      final external = widget.focusNodes?[index];
      if (external != null) return external;
      final node =
          index < oldEffective.length && oldOwned.contains(oldEffective[index])
          ? oldEffective[index]
          : FocusNode(debugLabel: 'NakedSlider thumb $index');
      _ownedFocusNodes.add(node);

      return node;
    });
    _focusedThumbIndices.clear();
    for (var index = 0; index < _effectiveFocusNodes.length; index++) {
      if (_effectiveFocusNodes[index].hasFocus) _focusedThumbIndices.add(index);
    }
    _focusedThumbIndex = _focusedThumbIndices.firstOrNull;
    final transferNode =
        focusedNode != null &&
            !_effectiveFocusNodes.contains(focusedNode) &&
            oldWidget.values.length == widget.values.length &&
            transferIndex != null
        ? _effectiveFocusNodes[transferIndex]
        : null;
    final retiredNodes = oldOwned
        .where((node) => !_ownedFocusNodes.contains(node))
        .toList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final node in retiredNodes) {
        node.dispose();
      }
      if (!mounted) return;
      if (transferNode != null &&
          _effectiveFocusNodes.contains(transferNode) &&
          _isEnabled) {
        transferNode.requestFocus();
      } else if (_focusedThumbIndices.isEmpty && isFocused) {
        updateFocusState(false, widget.onFocusChange);
      }
    });
  }

  @override
  void initializeWidgetStates() {
    updateDisabledState(!_isEnabled);
  }

  @override
  void didUpdateWidget(covariant NakedSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    assert(
      _debugValidSliderValues(
        widget.values,
        widget.min,
        widget.max,
        widget.minSpacing,
      ),
      'values must be finite, ascending, in range, and honor minSpacing',
    );
    final focusChanged = _focusConfigurationChanged(oldWidget);
    // Values have no stable identity across topology/configuration changes.
    // End the old transaction before adopting the new controlled contract.
    if (focusChanged ||
        !_isEnabled ||
        oldWidget.min != widget.min ||
        oldWidget.max != widget.max ||
        oldWidget.step != widget.step ||
        oldWidget.minSpacing != widget.minSpacing ||
        oldWidget.orientation != widget.orientation ||
        oldWidget.inverted != widget.inverted) {
      _finishPointerInteraction(deferCallbacks: true);
    }
    if (focusChanged) _replaceFocusNodes(oldWidget);

    _workingValues = List<double>.of(widget.values);
    syncWidgetStates();

    if (!_isEnabled) {
      updateState(WidgetState.hovered, false);
      updateState(WidgetState.pressed, false);
    }
  }

  @override
  void dispose() {
    for (final node in _ownedFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  double _snap(double value) {
    final steps = ((value - widget.min) / widget.step).round();

    return (widget.min + steps * widget.step).clamp(widget.min, widget.max);
  }

  double _constrainThumb(int index, double value, List<double> sourceValues) {
    final lower = index == 0
        ? widget.min
        : sourceValues[index - 1] + widget.minSpacing;
    final upper = index == sourceValues.length - 1
        ? widget.max
        : sourceValues[index + 1] - widget.minSpacing;
    final constrained = value.clamp(lower, upper);
    final snapped = _snap(constrained);

    return snapped.clamp(lower, upper);
  }

  List<double> _replaceThumb(
    List<double> sourceValues,
    int index,
    double value,
  ) {
    final result = List<double>.of(sourceValues);
    result[index] = _constrainThumb(index, value, sourceValues);

    return result;
  }

  void _emitValues(List<double> values) {
    if (listEquals(values, _workingValues)) return;
    _workingValues = List<double>.of(values);
    _lastRequestedValues = List<double>.unmodifiable(values);
    if (widget.enableFeedback) Feedback.forTap(context);
    widget.onChanged?.call(_lastRequestedValues!);
  }

  double? _valueForPosition(Offset localPosition, RenderBox sliderBox) {
    final trackBox = _trackKey.currentContext?.findRenderObject() as RenderBox?;
    final box = trackBox != null && trackBox.hasSize ? trackBox : sliderBox;
    final position = box.globalToLocal(sliderBox.localToGlobal(localPosition));
    final size = box.size;
    final extent = widget.orientation == Axis.horizontal
        ? size.width
        : size.height;
    if (extent <= 0) return null;

    var percentage = widget.orientation == Axis.horizontal
        ? position.dx / extent
        : 1 - position.dy / extent;
    if (widget.orientation == Axis.horizontal &&
        _textDirection == TextDirection.rtl) {
      percentage = 1 - percentage;
    }
    if (widget.inverted) percentage = 1 - percentage;

    return widget.min + percentage.clamp(0.0, 1.0) * (widget.max - widget.min);
  }

  int _nearestThumbIndex(double value) {
    var nearestIndex = 0;
    var nearestDistance = double.infinity;
    for (var index = 0; index < _workingValues.length; index++) {
      final distance = (_workingValues[index] - value).abs();
      if (distance < nearestDistance) {
        nearestIndex = index;
        nearestDistance = distance;
      } else if ((distance - nearestDistance).abs() < precisionErrorTolerance &&
          index == _focusedThumbIndex) {
        nearestIndex = index;
      }
    }

    return nearestIndex;
  }

  void _beginPointerInteraction(Offset localPosition) {
    if (!_isEnabled || _isDragging) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;

    _workingValues = List<double>.of(widget.values);
    final pointerValue = _valueForPosition(localPosition, box);
    if (pointerValue == null) return;
    final thumbIndex = _nearestThumbIndex(pointerValue);
    _isDragging = true;
    _activeThumbIndex = thumbIndex;
    _lastRequestedValues = null;
    _pointerStartValues = List<double>.unmodifiable(widget.values);
    _pointerEndCallback = widget.onChangeEnd;
    _pointerDragCallback = widget.onDragChange;
    updateState(WidgetState.pressed, true);
    _pointerDragCallback?.call(true);
    widget.onChangeStart?.call(_pointerStartValues!);
    _effectiveFocusNodes[thumbIndex].requestFocus();
    // Controlled values need not lie on the step grid. Grabbing their exact
    // painted center must not snap them before the pointer moves.
    if ((pointerValue - _workingValues[thumbIndex]).abs() >
        precisionErrorTolerance) {
      _emitValues(_replaceThumb(_workingValues, thumbIndex, pointerValue));
    }
  }

  void _updatePointerInteraction(Offset localPosition) {
    final thumbIndex = _activeThumbIndex;
    if (!_isEnabled || !_isDragging || thumbIndex == null) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final value = _valueForPosition(localPosition, box);
    if (value == null) return;
    _emitValues(_replaceThumb(_workingValues, thumbIndex, value));
  }

  void _finishPointerInteraction({bool deferCallbacks = false}) {
    if (!_isDragging) return;
    final result = _lastRequestedValues ?? _pointerStartValues!;
    final onDragChange = _pointerDragCallback;
    final onChangeEnd = _pointerEndCallback;
    _isDragging = false;
    _activeThumbIndex = null;
    _lastRequestedValues = null;
    _pointerStartValues = null;
    _pointerEndCallback = null;
    _pointerDragCallback = null;
    updateState(WidgetState.pressed, false);
    void notify() {
      onDragChange?.call(false);
      onChangeEnd?.call(result);
    }

    if (deferCallbacks) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) notify();
      });
    } else {
      notify();
    }
  }

  void _handleHorizontalDragStart(DragStartDetails details) {
    _updatePointerInteraction(details.localPosition);
  }

  void _handleHorizontalDragDown(DragDownDetails details) =>
      _beginPointerInteraction(details.localPosition);

  void _handleHorizontalDragUpdate(DragUpdateDetails details) =>
      _updatePointerInteraction(details.localPosition);

  void _handleHorizontalDragEnd(DragEndDetails details) =>
      _finishPointerInteraction();

  void _handleVerticalDragStart(DragStartDetails details) {
    _updatePointerInteraction(details.localPosition);
  }

  void _handleVerticalDragDown(DragDownDetails details) =>
      _beginPointerInteraction(details.localPosition);

  void _handleVerticalDragUpdate(DragUpdateDetails details) =>
      _updatePointerInteraction(details.localPosition);

  void _handleVerticalDragEnd(DragEndDetails details) =>
      _finishPointerInteraction();

  void _handleTapUp(TapUpDetails details) {
    _finishPointerInteraction();
  }

  void _handleThumbFocusChange(FocusNode node, bool focused) {
    final index = _effectiveFocusNodes.indexOf(node);
    if (index < 0) return;
    if (focused) {
      _focusLossGeneration++;
      _focusedThumbIndices.add(index);
      _focusedThumbIndex = index;
      if (!isFocused) {
        updateFocusState(true, widget.onFocusChange);
      } else if (mounted) {
        setState(() {});
      }

      return;
    }

    _focusedThumbIndices.remove(index);
    if (_focusedThumbIndex == index) {
      _focusedThumbIndex = _focusedThumbIndices.firstOrNull;
    }
    if (_focusedThumbIndices.isNotEmpty) {
      if (mounted) setState(() {});

      return;
    }

    final generation = ++_focusLossGeneration;
    if (mounted) setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted ||
          generation != _focusLossGeneration ||
          _focusedThumbIndices.isNotEmpty) {
        return;
      }
      if (isFocused) {
        updateFocusState(false, widget.onFocusChange);
      }
    });
  }

  double _keyboardDelta(LogicalKeyboardKey key) {
    final large = HardwareKeyboard.instance.isShiftPressed;
    var magnitude = widget.step * (large ? 10 : 1);
    var positive =
        key == LogicalKeyboardKey.arrowRight ||
        key == LogicalKeyboardKey.arrowUp ||
        key == LogicalKeyboardKey.pageUp;
    if (key == LogicalKeyboardKey.pageUp ||
        key == LogicalKeyboardKey.pageDown) {
      magnitude = math.max(magnitude, (widget.max - widget.min) / 10);
    }
    if (widget.orientation == Axis.horizontal &&
        _textDirection == TextDirection.rtl &&
        (key == LogicalKeyboardKey.arrowLeft ||
            key == LogicalKeyboardKey.arrowRight)) {
      positive = !positive;
    }
    if (widget.inverted) positive = !positive;

    return positive ? magnitude : -magnitude;
  }

  KeyEventResult _handleThumbKey(int index, KeyEvent event) {
    if (!_isEnabled || event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    final key = event.logicalKey;
    double? requestedValue;
    if (key == LogicalKeyboardKey.home) {
      requestedValue = widget.min;
    } else if (key == LogicalKeyboardKey.end) {
      requestedValue = widget.max;
    } else if (key == LogicalKeyboardKey.arrowLeft ||
        key == LogicalKeyboardKey.arrowRight ||
        key == LogicalKeyboardKey.arrowUp ||
        key == LogicalKeyboardKey.arrowDown ||
        key == LogicalKeyboardKey.pageUp ||
        key == LogicalKeyboardKey.pageDown) {
      requestedValue = widget.values[index] + _keyboardDelta(key);
    }
    if (requestedValue == null) return KeyEventResult.ignored;

    _workingValues = List<double>.of(widget.values);
    _emitValues(_replaceThumb(_workingValues, index, requestedValue));

    return KeyEventResult.handled;
  }

  String _percentString(double value) {
    final percentage = ((value - widget.min) / (widget.max - widget.min) * 100)
        .round();

    return '$percentage%';
  }

  String _semanticValue(int index, double value) {
    final formatter = widget.semanticFormatterCallbacks?[index];

    return formatter?.call(value) ?? _percentString(value);
  }

  Widget _buildThumbSemantics(NakedSliderState state, int index) {
    final focusNode = _effectiveFocusNodes[index];
    final value = widget.values[index];
    final increased = _constrainThumb(
      index,
      value + widget.step,
      widget.values,
    );
    final decreased = _constrainThumb(
      index,
      value - widget.step,
      widget.values,
    );
    final visualPercentage = state.visualPercentageAt(index);
    final alignment = widget.orientation == Axis.horizontal
        ? Alignment(visualPercentage * 2 - 1, 0)
        : Alignment(0, visualPercentage * 2 - 1);

    return Align(
      key: ObjectKey(focusNode),
      alignment: alignment,
      child: Focus(
        focusNode: focusNode,
        autofocus: widget.autofocusThumbIndex == index,
        canRequestFocus: _isEnabled,
        skipTraversal: !_isEnabled,
        includeSemantics: false,
        onFocusChange: (focused) => _handleThumbFocusChange(focusNode, focused),
        onKeyEvent: (_, event) => _handleThumbKey(index, event),
        child: Semantics(
          container: true,
          enabled: _isEnabled,
          slider: true,
          focused: _isEnabled ? _focusedThumbIndex == index : null,
          label: widget.semanticLabels?[index],
          value: _semanticValue(index, value),
          increasedValue: increased == value
              ? null
              : _semanticValue(index, increased),
          decreasedValue: decreased == value
              ? null
              : _semanticValue(index, decreased),
          onIncrease: _isEnabled && increased != value
              ? () {
                  _workingValues = List<double>.of(widget.values);
                  _emitValues(_replaceThumb(_workingValues, index, increased));
                }
              : null,
          onDecrease: _isEnabled && decreased != value
              ? () {
                  _workingValues = List<double>.of(widget.values);
                  _emitValues(_replaceThumb(_workingValues, index, decreased));
                }
              : null,
          onFocus: _isEnabled
              ? () => _effectiveFocusNodes[index].requestFocus()
              : null,
          child: const SizedBox.square(dimension: 48),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sliderState = NakedSliderState(
      states: widgetStates,
      values: widget.values,
      min: widget.min,
      max: widget.max,
      step: widget.step,
      minSpacing: widget.minSpacing,
      orientation: widget.orientation,
      inverted: widget.inverted,
      textDirection: _textDirection,
      isDragging: _isDragging,
      activeThumbIndex: _activeThumbIndex,
      focusedThumbIndex: _focusedThumbIndex,
    );

    Widget result = NakedStateScope<NakedSliderState>(
      value: sliderState,
      child: Builder(
        builder: (context) {
          final content =
              widget.builder?.call(context, sliderState, widget.child) ??
              widget.child!;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            excludeFromSemantics: true,
            onTapUp: _isEnabled ? _handleTapUp : null,
            onHorizontalDragDown:
                _isEnabled && widget.orientation == Axis.horizontal
                ? _handleHorizontalDragDown
                : null,
            onHorizontalDragStart:
                _isEnabled && widget.orientation == Axis.horizontal
                ? _handleHorizontalDragStart
                : null,
            onHorizontalDragUpdate:
                _isEnabled && widget.orientation == Axis.horizontal
                ? _handleHorizontalDragUpdate
                : null,
            onHorizontalDragEnd:
                _isEnabled && widget.orientation == Axis.horizontal
                ? _handleHorizontalDragEnd
                : null,
            onHorizontalDragCancel:
                _isEnabled && widget.orientation == Axis.horizontal
                ? _finishPointerInteraction
                : null,
            onVerticalDragStart:
                _isEnabled && widget.orientation == Axis.vertical
                ? _handleVerticalDragStart
                : null,
            onVerticalDragDown:
                _isEnabled && widget.orientation == Axis.vertical
                ? _handleVerticalDragDown
                : null,
            onVerticalDragUpdate:
                _isEnabled && widget.orientation == Axis.vertical
                ? _handleVerticalDragUpdate
                : null,
            onVerticalDragEnd: _isEnabled && widget.orientation == Axis.vertical
                ? _handleVerticalDragEnd
                : null,
            onVerticalDragCancel:
                _isEnabled && widget.orientation == Axis.vertical
                ? _finishPointerInteraction
                : null,
            child: Stack(
              clipBehavior: Clip.none,
              fit: StackFit.passthrough,
              children: [
                content,
                Positioned.fill(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: List<Widget>.generate(
                      widget.values.length,
                      (index) => _buildThumbSemantics(sliderState, index),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    result = _NakedSliderTrackScope(trackKey: _trackKey, child: result);
    if (widget.excludeSemantics) result = ExcludeSemantics(child: result);

    return MouseRegion(
      cursor: _cursor,
      onEnter: _isEnabled
          ? (_) => updateHoverState(true, widget.onHoverChange)
          : null,
      onExit: _isEnabled
          ? (_) => updateHoverState(false, widget.onHoverChange)
          : null,
      child: result,
    );
  }
}
