import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';
import 'package:remix/remix.dart';

/// A Material-free app shell with the media overrides picker tests vary.
Widget pickerHost(
  Widget child, {
  double textScale = 1,
  TextDirection direction = TextDirection.ltr,
  EdgeInsets? safeArea,
  EdgeInsets? viewInsets,
  GlobalKey<NavigatorState>? navigatorKey,
}) => WidgetsApp(
  color: const Color(0xffffffff),
  navigatorKey: navigatorKey,
  pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
    settings: settings,
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
  ),
  builder: (context, page) => MediaQuery(
    data: MediaQuery.of(context).copyWith(
      textScaler: TextScaler.linear(textScale),
      padding: safeArea,
      viewPadding: safeArea,
      viewInsets: viewInsets,
    ),
    child: Directionality(textDirection: direction, child: page!),
  ),
  home: Center(child: child),
);

/// The calendar day that holds primary focus, if any.
DateTime? focusedDate() {
  DateTime? result;
  FocusManager.instance.primaryFocus?.context?.visitAncestorElements((element) {
    if (element.widget case NakedCalendarDay(:final date)) {
      result = date;
      return false;
    }
    return true;
  });
  return result;
}

/// Whether primary focus is inside a widget of [type].
bool focusInside(Type type) {
  var found = false;
  FocusManager.instance.primaryFocus?.context?.visitAncestorElements((element) {
    if (element.widget.runtimeType == type) found = true;
    return !found;
  });
  return found;
}

/// The picker's own popover controller (the outermost popover).
MenuController outerController(WidgetTester tester) =>
    tester.widget<RemixPopover>(find.byType(RemixPopover).first).controller!;

/// Sends one key press and settles.
Future<void> pressKey(WidgetTester tester, LogicalKeyboardKey key) async {
  await tester.sendKeyEvent(key);
  await tester.pumpAndSettle();
}

/// Runs [body] with semantics enabled, releasing the handle even when an
/// expectation fails, so the failure is reported instead of a leaked handle.
Future<void> withSemantics(
  WidgetTester tester,
  Future<void> Function() body,
) async {
  final semantics = tester.ensureSemantics();
  try {
    await body();
  } finally {
    semantics.dispose();
  }
}
