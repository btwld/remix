import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_methods.dart';

void main() {
  group('AppBarStyler', () {
    test('constructor retains every anatomy style', () {
      final container = BoxStyler();
      final toolbar = BoxStyler();
      final title = TextStyler();
      final actions = FlexBoxStyler();
      final bottom = BoxStyler();
      final style = AppBarStyler(
        container: container,
        toolbar: toolbar,
        title: title,
        actions: actions,
        bottom: bottom,
        toolbarHeight: 64,
        spacing: 12,
      );

      expect(style.$container, Prop.maybeMix(container));
      expect(style.$toolbar, Prop.maybeMix(toolbar));
      expect(style.$title, Prop.maybeMix(title));
      expect(style.$actions, Prop.maybeMix(actions));
      expect(style.$bottom, Prop.maybeMix(bottom));
      expect(style.$toolbarHeight, Prop.maybe(64.0));
      expect(style.$spacing, Prop.maybe(12.0));
    });

    styleMethodTest(
      'forwards the root Box surface',
      initial: AppBarStyler(),
      modify: (style) => style.color(const Color(0xFF000000)).padding(.all(4)),
      expect: (style) {
        expect(style.$container, isNotNull);
      },
    );

    test('styleFrom and call preserve the public type', () {
      expect(RemixAppBar.styleFrom(), isA<AppBarStyler>());

      final style = AppBarStyler().toolbarHeight(64);
      final widget = style.call(title: 'Orders', centerTitle: true);

      expect(widget, isA<RemixAppBar>());
      expect(widget.style, same(style));
      expect(widget.title, 'Orders');
      expect(widget.centerTitle, isTrue);
    });

    testWidgets('a raw spec bypasses the fluent style', (tester) async {
      await tester.pumpWidget(
        MixScope.empty(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 300,
                child: RemixAppBar(
                  title: 'Orders',
                  safeArea: false,
                  style: AppBarStyler().toolbarHeight(80),
                  styleSpec: const AppBarSpec(toolbarHeight: 48),
                ),
              ),
            ),
          ),
        ),
      );

      expect(tester.getSize(find.byType(RemixAppBar)).height, 48);
    });
  });
}
