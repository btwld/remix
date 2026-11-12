import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/default/components/sidebar_layout.dart';
import 'package:registry_source/src/default/theme/theme_scope.dart';
import 'package:registry_source/src/fortal/components/sidebar_layout.dart';
import 'package:registry_source/src/fortal/theme/theme.dart';
import 'package:registry_source/src/heroui/components/sidebar_layout.dart';
import 'package:registry_source/src/heroui/theme/theme.dart';
import 'package:remix/remix.dart';

const _sidebar = ValueKey('sidebar');

enum _Preset {
  vanilla,
  fortal,
  heroui;

  Widget theme(Widget child) => switch (this) {
    vanilla => VanillaTheme(child: child),
    fortal => FortalTheme(child: child),
    heroui => HeroUiTheme(child: child),
  };

  Widget layout(bool collapsed) {
    const sidebar = SizedBox(key: _sidebar);
    const body = SizedBox();
    return switch (this) {
      vanilla => VanillaSidebarLayout(
        collapsed: collapsed,
        collapsedWidth: 64,
        sidebar: sidebar,
        body: body,
      ),
      fortal => FortalSidebarLayout(
        collapsed: collapsed,
        collapsedWidth: 64,
        sidebar: sidebar,
        body: body,
      ),
      heroui => HeroUiSidebarLayout(
        collapsed: collapsed,
        collapsedWidth: 64,
        sidebar: sidebar,
        body: body,
      ),
    };
  }
}

Widget _host(
  _Preset preset,
  Widget child, {
  TextDirection direction = TextDirection.ltr,
}) => WidgetsApp(
  color: const Color(0xFFFFFFFF),
  builder: (context, _) =>
      preset.theme(Directionality(textDirection: direction, child: child)),
);

void main() {
  for (final preset in _Preset.values) {
    testWidgets('${preset.name}: rail follows platform reduce motion changes', (
      tester,
    ) async {
      final collapsed = ValueNotifier(false);
      addTearDown(collapsed.dispose);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
      await tester.pumpWidget(
        _host(
          preset,
          ValueListenableBuilder<bool>(
            valueListenable: collapsed,
            builder: (context, value, _) => preset.layout(value),
          ),
        ),
      );
      expect(tester.getSize(find.byKey(_sidebar)).width, 256);
      expect(
        MediaQuery.disableAnimationsOf(tester.element(find.byKey(_sidebar))),
        isFalse,
      );

      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(reduceMotion: true);
      await tester.pump();
      collapsed.value = true;
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1));
      expect(tester.getSize(find.byKey(_sidebar)).width, 64);

      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures();
      await tester.pump();
      collapsed.value = false;
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(
        tester.getSize(find.byKey(_sidebar)).width,
        allOf(greaterThan(64), lessThan(256)),
      );
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byKey(_sidebar)).width, 256);
    });
  }
}
