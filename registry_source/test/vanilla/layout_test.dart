import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/vanilla.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

/// Laid-out sizes the spec states. The spec targets read style inputs, which
/// can agree with the spec while the rendered widget does not.
void main() {
  Widget host(Widget home) => WidgetsApp(
    color: const Color(0xFFFFFFFF),
    pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, _, _) => builder(context),
    ),
    builder: (context, navigator) => VanillaThemeScope(child: navigator!),
    home: home,
  );

  Rect panelOf(WidgetTester tester, String text) => tester.getRect(
    find
        .ancestor(of: find.text(text), matching: find.byType(DecoratedBox))
        .first,
  );

  testWidgets('a dialog is centered and fills at most 512px', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    late BuildContext context;
    await tester.pumpWidget(
      host(
        Builder(
          builder: (inner) {
            context = inner;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    showRemixDialog<void>(
      context: context,
      barrierLabel: 'Dismiss',
      builder: (_) =>
          const VanillaDialog(title: 'Invite', description: 'Share it.'),
    );
    await tester.pumpAndSettle();

    final panel = panelOf(tester, 'Invite');
    expect(panel.width, 512);
    expect(panel.center.dx, 640);
    expect(panel.center.dy, 400);
    expect(panel.height, lessThan(800));
  });

  testWidgets('a dialog in a narrow viewport keeps 16px at each side', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(375, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    late BuildContext context;
    await tester.pumpWidget(
      host(
        Builder(
          builder: (inner) {
            context = inner;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    showRemixDialog<void>(
      context: context,
      barrierLabel: 'Dismiss',
      builder: (_) =>
          const VanillaDialog(title: 'Invite', description: 'Share it.'),
    );
    await tester.pumpAndSettle();

    final panel = panelOf(tester, 'Invite');
    expect(panel.left, 16);
    expect(panel.right, 375 - 16);
  });

  testWidgets('a sidebar destination row is 32px tall', (tester) async {
    await tester.pumpWidget(
      host(
        Center(
          child: SizedBox(
            width: 280,
            height: 320,
            child: VanillaSidebar<String>(
              sections: const [
                RemixSidebarSection(
                  label: 'Workspace',
                  destinations: [
                    RemixSidebarDestination(
                      value: 'overview',
                      label: 'Overview',
                      icon: RemixIcons.dashboard,
                    ),
                  ],
                ),
              ],
              selectedValue: 'overview',
              onSelected: (_) {},
            ),
          ),
        ),
      ),
    );

    expect(panelOf(tester, 'Overview').height, 32);
  });
}
