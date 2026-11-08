import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

const suggestions = ['Apple', 'Apricot', 'Avocado'];

Widget comboboxHost(
  Widget child, {
  TextDirection direction = TextDirection.ltr,
  double scale = 1,
  GlobalKey? repaintKey,
}) => WidgetsApp(
  color: const Color(0xFFFFFFFF),
  textStyle: const TextStyle(color: Color(0xFF111111), fontSize: 16),
  pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
    settings: settings,
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
  ),
  builder: (context, navigator) => Directionality(
    textDirection: direction,
    child: MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: TextScaler.linear(scale)),
      child: RepaintBoundary(key: repaintKey, child: navigator!),
    ),
  ),
  home: Align(
    alignment: Alignment.topCenter,
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          child,
          const Focus(child: SizedBox(height: 32)),
        ],
      ),
    ),
  ),
);

ComboboxStyler testComboboxStyle() => ComboboxStyler()
    .width(280)
    .field(
      TextFieldStyler()
          .constraints(.minHeight(48))
          .padding(.all(8))
          .color(const Color(0xFFFFFFFF))
          .onFocused(.color(const Color(0xFFE0E0FF))),
    )
    .panel(BoxStyler().color(const Color(0xFFFFFFFF)))
    .option(
      ComboboxOptionStyler()
          .padding(.horizontal(12))
          .color(const Color(0xFFFFFFFF))
          .onHovered(.color(const Color(0xFF00FF00)))
          .onFocused(.color(const Color(0xFF0000FF)))
          .label(TextStyler().fontSize(16)),
    );

Future<void> openCombobox(WidgetTester tester, [String text = 'a']) async {
  await tester.tap(find.byType(EditableText));
  await tester.enterText(find.byType(EditableText), text);
  await tester.pumpAndSettle();
}
