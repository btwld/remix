import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/vanilla.dart';
import 'package:remix/remix.dart';
// `RemixBoxAdapter` is `@internal` to `remix`, but the panel's width is the one
// thing to measure and no public widget is the panel. Suppressed at the use.
import 'package:remix/src/rendering/remix_box_effects.dart';
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
    builder: (context, navigator) => VanillaTheme(child: navigator!),
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

  testWidgets(
    'a select panel is at least 128px and at least its trigger wide',
    (tester) async {
      Future<double> panelWidth(double triggerWidth) async {
        await tester.pumpWidget(
          host(
            Center(
              child: SizedBox(
                width: triggerWidth,
                child: VanillaSelect<String>(
                  trigger: const RemixSelectTrigger(placeholder: 'Plan'),
                  items: const [RemixSelectItem(value: 'free', label: 'Free')],
                  onChanged: (_) {},
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.byType(VanillaSelect<String>));
        await tester.pumpAndSettle();
        final width = tester
            .getSize(
              find
                  .ancestor(
                    of: find.text('Free'),
                    // ignore: invalid_use_of_internal_member
                    matching: find.byType(RemixBoxAdapter),
                  )
                  .last,
            )
            .width;
        await tester.tapAt(const Offset(2, 2));
        await tester.pumpAndSettle();

        return width;
      }

      expect(await panelWidth(100), 128);
      expect(await panelWidth(240), 240);
      expect(await panelWidth(400), 400);
    },
  );

  testWidgets('a segmented control stays 36px tall inside a taller row', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        Center(
          child: SizedBox(
            height: 56,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                VanillaSegmentedControl<String>(
                  items: const [
                    RemixSegmentedControlItem(value: 'today', label: 'Today'),
                    RemixSegmentedControlItem(value: 'tasks', label: 'Tasks'),
                  ],
                  selectedValue: 'today',
                  onChanged: (_) {},
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(
      tester.getSize(find.byType(VanillaSegmentedControl<String>)).height,
      36,
    );
  });
}
