import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'naked_checkbox.dart';

/// Coordinates a controlled set of [NakedCheckboxGroupItem] values.
///
/// The caller lays out and styles the items. Each enabled item is an ordinary
/// Tab stop in traditional navigation; the group does not handle arrow keys.
class NakedCheckboxGroup<T extends Object> extends StatefulWidget {
  /// Creates a group controlled by [values].
  const NakedCheckboxGroup({
    super.key,
    required this.values,
    required this.child,
    this.onChanged,
    this.enabled = true,
    this.isRequired = false,
    this.semanticLabel,
    this.excludeSemantics = false,
  }) : assert(
         semanticLabel != '',
         'Group semantic labels must not be blank when provided',
       ),
       assert(
         !isRequired || excludeSemantics || semanticLabel != null,
         'A required group must have a semanticLabel unless excluded',
       );

  /// The owner's current selection. The group snapshots it on each build and
  /// never mutates it.
  final Set<T> values;

  /// Proposes a new unmodifiable set on each enabled activation, retaining
  /// values without mounted items. Selection changes only if the owner rebuilds
  /// with new [values]. When null, all items are disabled.
  final ValueChanged<Set<T>>? onChanged;

  /// Whether options can be activated. Also requires [onChanged] and an
  /// enabled [NakedCheckboxGroupItem].
  final bool enabled;

  /// Marks the group, not its items, as required in semantics. This does not
  /// enforce a minimum selection.
  final bool isRequired;

  /// The group's accessible name. Must be nonblank when supplied and is
  /// required if [isRequired] is true and [excludeSemantics] is false.
  final String? semanticLabel;

  /// Whether to hide the group and its descendants from accessibility services.
  final bool excludeSemantics;

  /// The caller-provided layout containing the group's items.
  final Widget child;

  @override
  State<NakedCheckboxGroup<T>> createState() => _NakedCheckboxGroupState<T>();
}

class _NakedCheckboxGroupState<T extends Object>
    extends State<NakedCheckboxGroup<T>> {
  final _CheckboxGroupRegistry<T>? _registry = kDebugMode
      ? _CheckboxGroupRegistry<T>()
      : null;

  @override
  void dispose() {
    _registry?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(
      widget.semanticLabel == null || widget.semanticLabel!.trim().isNotEmpty,
      'Group semantic labels must not be blank when provided',
    );

    final excluded = widget.excludeSemantics;
    return Semantics(
      container: !excluded,
      explicitChildNodes: !excluded,
      excludeSemantics: excluded,
      label: excluded ? null : widget.semanticLabel,
      isRequired: !excluded && widget.isRequired ? true : null,
      child: _CheckboxGroupScope<T>(
        values: Set<T>.unmodifiable(widget.values),
        onChanged: widget.enabled ? widget.onChanged : null,
        registry: _registry,
        child: widget.child,
      ),
    );
  }
}

/// One binary option in a [NakedCheckboxGroup] with the same type argument.
///
/// Uses [NakedCheckbox] for focus, activation and semantics. Supply a visual
/// [child] or [builder], not another interactive checkbox.
class NakedCheckboxGroupItem<T extends Object> extends StatefulWidget {
  /// Creates an option checked when [value] belongs to the group's selection.
  const NakedCheckboxGroupItem({
    super.key,
    required this.value,
    this.child,
    this.builder,
    this.enabled = true,
    this.focusNode,
    this.autofocus = false,
    this.mouseCursor,
    this.enableFeedback = true,
    this.semanticLabel,
  }) : assert(
         semanticLabel != '',
         'Item semantic labels must not be blank when provided',
       );

  /// The value to add or remove. It must be unique among mounted items of this
  /// group and stable in equality and hash code while mounted.
  final T value;

  /// Optional visual content, also passed to [builder] when provided.
  final Widget? child;

  /// Builds the visuals from checked and interaction state. Descendants can
  /// also read the nearest [NakedCheckboxState] from context.
  final ValueWidgetBuilder<NakedCheckboxState>? builder;

  /// Whether this option is enabled, subject to the group's enabled state.
  final bool enabled;

  /// An optional caller-owned focus node. The checkbox manages an internal
  /// node when none is supplied.
  final FocusNode? focusNode;

  /// Whether to request focus on mount. At most one item may opt in per group.
  final bool autofocus;

  /// The cursor when this option is enabled and hovered.
  final MouseCursor? mouseCursor;

  /// Whether to provide haptic feedback on activation.
  final bool enableFeedback;

  /// An optional accessible name that replaces descendant text semantics.
  final String? semanticLabel;

  @override
  State<NakedCheckboxGroupItem<T>> createState() =>
      _NakedCheckboxGroupItemState<T>();
}

class _NakedCheckboxGroupItemState<T extends Object>
    extends State<NakedCheckboxGroupItem<T>> {
  _CheckboxGroupRegistry<T>? _registry;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncDebugRegistration();
  }

  @override
  void didUpdateWidget(covariant NakedCheckboxGroupItem<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value ||
        oldWidget.autofocus != widget.autofocus) {
      _syncDebugRegistration();
    }
  }

  @override
  void dispose() {
    _registry?.unregister(this);
    super.dispose();
  }

  void _syncDebugRegistration() {
    assert(() {
      final registry = context
          .getInheritedWidgetOfExactType<_CheckboxGroupScope<T>>()
          ?.registry;
      if (!identical(registry, _registry)) {
        _registry?.unregister(this);
        _registry = registry;
      }
      registry?.register(
        this,
        value: widget.value,
        autofocus: widget.autofocus,
      );
      return true;
    }());
  }

  @override
  Widget build(BuildContext context) {
    assert(
      widget.semanticLabel == null || widget.semanticLabel!.trim().isNotEmpty,
      'Item semantic labels must not be blank when provided',
    );
    final scope = context
        .dependOnInheritedWidgetOfExactType<_CheckboxGroupScope<T>>();
    if (scope == null) {
      throw FlutterError(
        'NakedCheckboxGroupItem<$T> must be used within a '
        'NakedCheckboxGroup<$T> with the same type argument.',
      );
    }

    return NakedCheckbox(
      value: scope.values.contains(widget.value),
      onChanged: scope.onChanged == null
          ? null
          : (checked) => scope.toggle(widget.value, checked: checked == true),
      enabled: widget.enabled,
      child: widget.child,
      builder: widget.builder,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      enableFeedback: widget.enableFeedback,
      mouseCursor: widget.mouseCursor,
      semanticLabel: widget.semanticLabel,
    );
  }
}

class _CheckboxGroupScope<T extends Object> extends InheritedWidget {
  const _CheckboxGroupScope({
    required this.values,
    required this.onChanged,
    required this.registry,
    required super.child,
  });

  final Set<T> values;
  final ValueChanged<Set<T>>? onChanged;
  final _CheckboxGroupRegistry<T>? registry;

  void toggle(T value, {required bool checked}) {
    final next = Set<T>.of(values);
    if (checked) {
      next.add(value);
    } else {
      next.remove(value);
    }
    onChanged?.call(Set<T>.unmodifiable(next));
  }

  @override
  bool updateShouldNotify(_CheckboxGroupScope<T> oldWidget) =>
      onChanged != oldWidget.onChanged || !setEquals(values, oldWidget.values);
}

/// Validates mounted items after the frame, when updates that transiently
/// duplicate an item value or autofocus request have settled.
class _CheckboxGroupRegistry<T extends Object> {
  final Map<State, ({T value, bool autofocus})> _entries = {};
  bool _validationScheduled = false;

  void register(State owner, {required T value, required bool autofocus}) {
    _entries[owner] = (value: value, autofocus: autofocus);
    if (_validationScheduled) return;
    _validationScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _validationScheduled = false;
      _validate();
    });
  }

  void unregister(State owner) => _entries.remove(owner);

  void dispose() => _entries.clear();

  void _validate() {
    final seen = <T>{};
    var autofocusCount = 0;
    for (final entry in _entries.values) {
      if (!seen.add(entry.value)) {
        throw FlutterError(
          'NakedCheckboxGroup<$T> item values must be unique. '
          'Duplicate value: ${entry.value}.',
        );
      }
      if (entry.autofocus) autofocusCount += 1;
    }
    if (autofocusCount > 1) {
      throw FlutterError(
        'Only one item may autofocus in a NakedCheckboxGroup<$T>.',
      );
    }
  }
}
