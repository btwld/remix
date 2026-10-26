import 'package:flutter/foundation.dart' show internal;
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

/// Supplies the size of the widget that opened an overlay to the styles
/// resolved inside it.
@internal
final class RemixAnchorScope extends InheritedWidget {
  const RemixAnchorScope({super.key, required this.size, required super.child});

  /// The size of the trigger that opened the overlay.
  final Size size;

  /// The size of the nearest anchor, or null outside a [RemixAnchorScope].
  static Size? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RemixAnchorScope>()?.size;
  }

  @override
  bool updateShouldNotify(RemixAnchorScope oldWidget) => size != oldWidget.size;
}

/// The width of the widget that opened the surrounding `RemixSelect` or
/// `RemixMenu` overlay, and 0 anywhere else.
///
/// Pass it where a width is expected to size an overlay from its trigger, the
/// counterpart of CSS `min-width: var(--trigger-width)`:
///
/// ```dart
/// SelectContentStyler().minWidth(remixAnchorWidth())
/// ```
///
/// The token resolves where the style is built, so it works for styles that
/// `RemixSelect` and `RemixMenu` resolve inside their overlay. It reads 0 in
/// any style resolved outside one, such as a `RemixPopover`'s.
const remixAnchorWidth = ContextToken<double>(_anchorWidthOf);

double _anchorWidthOf(BuildContext context) {
  return RemixAnchorScope.maybeOf(context)?.width ?? 0;
}
