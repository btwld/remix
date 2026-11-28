import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'mixins/naked_mixins.dart';

/// Bindings for the editor and step controls in a [NakedNumberField].
class NakedNumberFieldBindings {
  const NakedNumberFieldBindings._({
    required this.controller,
    required this.focusNode,
    required this.enabled,
    required this.readOnly,
    required this.value,
    required this.keyboardType,
    required this.onSubmitted,
    required this.increment,
    required this.decrement,
    required Widget Function(Widget editor) spinButton,
  }) : _spinButton = spinButton;

  /// Pass to the editor. It holds the formatted value or the typed draft.
  /// Do not dispose it from the builder.
  final TextEditingController controller;

  /// Pass to the editor. Losing focus commits the draft.
  final FocusNode focusNode;

  /// Whether the editor should accept interaction.
  final bool enabled;

  /// Whether the editor should allow selection but not editing or stepping.
  final bool readOnly;

  /// The committed value the editor shows, or null when the field is empty.
  final double? value;

  /// A numeric keyboard that offers a sign only when [NakedNumberField.min]
  /// is negative and a decimal point only when the step has a fraction.
  final TextInputType keyboardType;

  /// Pass to the editor's submit callback. It commits the draft.
  final ValueChanged<String> onSubmitted;

  /// Steps up once. Null when disabled, read-only, or at the maximum.
  final VoidCallback? increment;

  /// Steps down once. Null when disabled, read-only, or at the minimum.
  final VoidCallback? decrement;

  final Widget Function(Widget editor) _spinButton;

  /// Wraps the editor so its semantics node carries the spin button's next
  /// and previous values and its increase and decrease actions.
  ///
  /// Wrap only the editor, never the step controls.
  Widget spinButton(Widget editor) => _spinButton(editor);
}

/// Headless spin button behavior for a caller-built numeric editor and step
/// controls.
///
/// The value is controlled: [onChanged] proposes a value and the field shows
/// [value] until the owner rebuilds it with the new one. A proposal the owner
/// declines leaves the editor showing [value].
///
/// The editor holds a draft while the user types. Submitting it or moving
/// focus away commits the draft: an empty draft commits null, a draft that
/// does not parse reverts to [value], and a parsed number is clamped to
/// [min] and [max]. Stepping starts from the parsed draft when there is one.
///
/// While the editor has focus and no text composition is active, Up and Down
/// step by [step], Page Up and Page Down step by [largeStep], and Home and End
/// set [min] and [max] when they are finite. Keys with Control, Alt, Meta or
/// Shift held are left to the editor, and so are Home and End on an unbounded
/// side.
///
/// The pinned Flutter SDK cannot yet report a spin button role (its role
/// checks reject `SemanticsRole.spinButton`), so the editor stays a text field
/// node that gains increase and decrease actions through
/// [NakedNumberFieldBindings.spinButton]. Step controls should not take a Tab
/// stop: wrap them in [ExcludeFocus] and [TextFieldTapRegion] so a press keeps
/// the editor's focus.
class NakedNumberField extends StatefulWidget {
  /// Creates a behavior-only number field.
  const NakedNumberField({
    super.key,
    required this.value,
    required this.builder,
    this.onChanged,
    this.min = double.negativeInfinity,
    this.max = double.infinity,
    this.step = 1,
    this.largeStep,
    this.format,
    this.parse,
    this.controller,
    this.focusNode,
    this.enabled = true,
    this.readOnly = false,
  }) : assert(min <= max, 'min must not exceed max'),
       assert(step > 0 && step < double.infinity, 'step must be positive'),
       assert(
         largeStep == null || (largeStep > 0 && largeStep < double.infinity),
         'largeStep must be positive',
       );

  /// The committed value, or null for an empty field.
  final double? value;

  /// Builds the editor and, optionally, step controls.
  final Widget Function(BuildContext context, NakedNumberFieldBindings field)
  builder;

  /// Receives a proposed value after a step, a key, a semantic action, or a
  /// commit that changes it. Null makes the field read-only.
  final ValueChanged<double?>? onChanged;

  /// The smallest value. Negative infinity leaves the field unbounded below.
  final double min;

  /// The largest value. Infinity leaves the field unbounded above.
  final double max;

  /// The amount Up, Down, the step controls and the semantic actions move.
  final double step;

  /// The amount Page Up and Page Down move. Defaults to ten steps.
  final double? largeStep;

  /// Turns a value into editor text. Defaults to the value with at least as
  /// many fraction digits as [step] has.
  final String Function(double value)? format;

  /// Turns trimmed, nonempty editor text into a value, or null when it does
  /// not parse. Defaults to [double.tryParse].
  final double? Function(String text)? parse;

  /// Optional caller-owned controller. The field writes the formatted value
  /// into it.
  final TextEditingController? controller;

  /// Optional caller-owned editor focus node.
  final FocusNode? focusNode;

  /// Whether the field accepts interaction.
  final bool enabled;

  /// Whether the field allows selection but not editing or stepping.
  final bool readOnly;

  @override
  State<NakedNumberField> createState() => _NakedNumberFieldState();
}

class _NakedNumberFieldState extends State<NakedNumberField>
    with FocusNodeMixin<NakedNumberField> {
  TextEditingController? _ownedController;
  TextEditingController get _controller =>
      widget.controller ?? _ownedController!;

  @override
  FocusNode? get widgetProvidedNode => widget.focusNode;

  @override
  ValueChanged<bool>? get onFocusChange => _handleFocusChange;

  bool get _canStep =>
      widget.enabled && !widget.readOnly && widget.onChanged != null;

  int get _fractionDigits => math.max(_decimals(widget.step), 0);

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) _ownedController = TextEditingController();
    _showValue();
  }

  @override
  void didUpdateWidget(NakedNumberField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      final previous = oldWidget.controller ?? _ownedController!;
      _ownedController?.dispose();
      _ownedController = widget.controller == null
          ? TextEditingController.fromValue(previous.value)
          : null;
    }
    if (widget.value != oldWidget.value ||
        widget.format != oldWidget.format ||
        widget.step != oldWidget.step) {
      _showValue();
    }
  }

  @override
  void dispose() {
    _ownedController?.dispose();
    super.dispose();
  }

  String _format(double value) =>
      widget.format?.call(value) ??
      value.toStringAsFixed(
        math.min(math.max(_fractionDigits, _decimals(value)), 15),
      );

  void _showValue() {
    final value = widget.value;
    final text = value == null ? '' : _format(value);
    if (_controller.text == text) return;
    _controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  double _clamp(double value) => value.clamp(widget.min, widget.max);

  // Removes the binary noise that repeated fractional steps leave behind.
  double _round(double value) {
    final digits = math.max(_fractionDigits, _decimals(widget.min));
    return double.parse(value.toStringAsFixed(math.min(digits, 15)));
  }

  ({bool parsed, double? value}) _readDraft() {
    final text = _controller.text.trim();
    if (text.isEmpty) return (parsed: true, value: null);
    final parsed = (widget.parse ?? double.tryParse)(text);
    if (parsed == null || parsed.isNaN) return (parsed: false, value: null);
    return (parsed: true, value: _clamp(parsed));
  }

  void _propose(double? next) {
    _showValue();
    if (next != widget.value) widget.onChanged?.call(next);
  }

  void _commit() {
    if (!_canStep) return;
    final draft = _readDraft();
    _propose(draft.parsed ? draft.value : widget.value);
  }

  double? _base() {
    final draft = _readDraft();
    return draft.parsed ? draft.value : widget.value;
  }

  double _stepFrom(double? base, double delta) {
    if (base == null) {
      return _clamp(widget.min.isFinite ? widget.min : 0);
    }
    return _clamp(_round(base + delta));
  }

  bool _canMove(double? base, double delta) {
    if (!_canStep) return false;
    if (base == null) return true;
    return delta > 0 ? base < widget.max : base > widget.min;
  }

  void _stepBy(double delta) {
    final base = _base();
    if (!_canMove(base, delta)) return;
    _propose(_stepFrom(base, delta));
  }

  void _handleFocusChange(bool focused) {
    if (!focused) _commit();
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is KeyUpEvent || !_canStep) return .ignored;
    final keyboard = HardwareKeyboard.instance;
    if (keyboard.isControlPressed ||
        keyboard.isAltPressed ||
        keyboard.isMetaPressed ||
        keyboard.isShiftPressed) {
      return .ignored;
    }
    final editing = _controller.value;
    if (editing.isComposingRangeValid && !editing.composing.isCollapsed) {
      return .ignored;
    }
    final largeStep = widget.largeStep ?? widget.step * 10;
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowUp) {
      _stepBy(widget.step);
    } else if (key == LogicalKeyboardKey.arrowDown) {
      _stepBy(-widget.step);
    } else if (key == LogicalKeyboardKey.pageUp) {
      _stepBy(largeStep);
    } else if (key == LogicalKeyboardKey.pageDown) {
      _stepBy(-largeStep);
    } else if (key == LogicalKeyboardKey.home && widget.min.isFinite) {
      _propose(widget.min);
    } else if (key == LogicalKeyboardKey.end && widget.max.isFinite) {
      _propose(widget.max);
    } else {
      return .ignored;
    }
    return .handled;
  }

  Widget _spinButton(Widget editor) => ListenableBuilder(
    listenable: _controller,
    builder: (context, editor) {
      final base = _base();
      final canIncrease = _canMove(base, widget.step);
      final canDecrease = _canMove(base, -widget.step);
      final text = _controller.text;
      // Flutter requires the next values to be absent while the value is.
      final announcesNext = text.isNotEmpty;
      return MergeSemantics(
        child: Semantics(
          value: text,
          increasedValue: canIncrease && announcesNext
              ? _format(_stepFrom(base, widget.step))
              : null,
          decreasedValue: canDecrease && announcesNext
              ? _format(_stepFrom(base, -widget.step))
              : null,
          onIncrease: canIncrease ? () => _stepBy(widget.step) : null,
          onDecrease: canDecrease ? () => _stepBy(-widget.step) : null,
          child: editor,
        ),
      );
    },
    child: editor,
  );

  TextInputType get _keyboardType => TextInputType.numberWithOptions(
    signed: widget.min < 0,
    decimal: _fractionDigits > 0,
  );

  @override
  Widget build(BuildContext context) {
    final value = widget.value;
    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      includeSemantics: false,
      onKeyEvent: _handleKey,
      child: widget.builder(
        context,
        NakedNumberFieldBindings._(
          controller: _controller,
          focusNode: effectiveFocusNode,
          enabled: widget.enabled,
          readOnly: widget.readOnly || widget.onChanged == null,
          value: value,
          keyboardType: _keyboardType,
          onSubmitted: (_) => _commit(),
          increment: _canMove(value, widget.step)
              ? () => _stepBy(widget.step)
              : null,
          decrement: _canMove(value, -widget.step)
              ? () => _stepBy(-widget.step)
              : null,
          spinButton: _spinButton,
        ),
      ),
    );
  }
}

int _decimals(double value) {
  if (!value.isFinite || value == value.roundToDouble()) return 0;
  final text = value.toString();
  final exponent = text.indexOf('e-');
  if (exponent != -1) return int.parse(text.substring(exponent + 2));
  final point = text.indexOf('.');
  return point == -1 ? 0 : text.length - point - 1;
}
