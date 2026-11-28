import 'package:flutter/foundation.dart' show internal, setEquals;
import 'package:flutter/widgets.dart';

/// Widget states a composite adds to the states a descendant Remix field
/// resolves its style under, such as `selected` while a combobox is open.
@internal
final class RemixAddedWidgetStates extends InheritedWidget {
  const RemixAddedWidgetStates({
    super.key,
    required this.states,
    required super.child,
  });

  final Set<WidgetState> states;

  static Set<WidgetState> of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<RemixAddedWidgetStates>()
          ?.states ??
      const {};

  @override
  bool updateShouldNotify(RemixAddedWidgetStates oldWidget) =>
      !setEquals(states, oldWidget.states);
}
