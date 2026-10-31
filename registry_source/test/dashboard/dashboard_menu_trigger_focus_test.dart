import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:registry_source/src/fortal/recipes/dashboard/dashboard_demo.dart';
import 'package:registry_source/src/fortal/recipes/dashboard/dashboard_demo_theme.dart';
import 'package:registry_source/src/fortal/recipes/dashboard/dashboard_demo_widgets.dart';
import 'package:remix/remix.dart';

import '../helpers/pixels.dart';
import '../helpers/test_helpers.dart';

/// Every menu trigger in the dashboard demo is a keyboard focus stop, so each
/// shows a visible `focus-8` ring when it takes focus from the keyboard.
void main() {
  late FocusHighlightStrategy previousStrategy;

  setUp(() {
    previousStrategy = FocusManager.instance.highlightStrategy;
    FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.alwaysTraditional;
  });

  tearDown(() => FocusManager.instance.highlightStrategy = previousStrategy);

  /// Pumps [child] on an opaque page, takes keyboard focus with [focus], and
  /// expects a `focus-8` ring on each edge of [trigger] with nothing 3px in.
  Future<void> expectRingOnFocus(
    WidgetTester tester, {
    required Widget child,
    required Finder trigger,
    required Future<void> Function() focus,
  }) async {
    final boundary = GlobalKey();
    await tester.pumpRemixApp(
      RepaintBoundary(
        key: boundary,
        child: ColoredBox(
          color: const Color(0xFFFFFFFF),
          child: Padding(padding: const EdgeInsets.all(16), child: child),
        ),
      ),
    );
    final surface = find.descendant(
      of: trigger,
      matching: find.byKey(const ValueKey('remix-icon-button-surface')),
    );
    final painted = surface.evaluate().isEmpty ? trigger : surface;
    final rect = tester.getRect(painted);
    final idle = await capturePixels(tester, boundary);

    await focus();
    await tester.pumpAndSettle();
    final focused = await capturePixels(tester, boundary);
    final focus8 = MixScope.tokenOf(
      FortalTokens.focus8,
      tester.element(trigger),
    );

    final origin = tester.getTopLeft(find.byKey(boundary));
    Color pixel(Pixels pixels, Offset logical) {
      final device = (logical - origin) * pixelScale.toDouble();
      return pixels.at(device.dx.round(), device.dy.round());
    }

    for (final at in <Offset Function(double inside)>[
      (inside) => Offset(rect.center.dx, rect.top + inside),
      (inside) => Offset(rect.center.dx, rect.bottom - inside),
      (inside) => Offset(rect.left + inside, rect.center.dy),
      (inside) => Offset(rect.right - inside, rect.center.dy),
    ]) {
      expectNearColor(pixel(focused, at(-3)), focus8);
      expectNearColor(pixel(focused, at(3)), pixel(idle, at(3)));
    }
    expect(tester.getRect(painted), rect);
  }

  Future<void> tab(WidgetTester tester) =>
      tester.sendKeyEvent(LogicalKeyboardKey.tab);

  testWidgets('the data-table kebab rings on keyboard focus', (tester) async {
    await expectRingOnFocus(
      tester,
      child: FortalActionMenu(
        trigger: fortalDataTableActionsTrigger('Actions for Ada'),
        actions: const [FortalAction(value: 'view', label: 'View profile')],
        onSelected: (_) {},
      ),
      trigger: find.byType(RemixIconButton),
      focus: () => tab(tester),
    );
  });

  group('the sidebar account row', () {
    /// Hosts the row in a sidebar footer, as the dashboard shell does, on an
    /// opaque page, and returns what the tests probe.
    Future<
      ({
        GlobalKey boundary,
        Rect row,
        Rect avatar,
        Element avatarElement,
        Pixels idle,
      })
    >
    pumpRow(
      WidgetTester tester, {
      required FortalThemeMode mode,
      Map<SpaceToken, double>? ringTokens,
    }) async {
      final boundary = GlobalKey();
      await tester.pumpRemixApp(
        FortalTheme(
          mode: mode,
          child: MixScope.inherit(
            spaces: ringTokens,
            child: RepaintBoundary(
              key: boundary,
              child: ColoredBox(
                color: mode == .dark
                    ? const Color(0xFF000000)
                    : const Color(0xFFFFFFFF),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: 256,
                    height: 320,
                    child: FortalSidebar<String>(
                      selectedValue: null,
                      sections: const [],
                      footer: const FortalDashboardSidebarAccount(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      return (
        boundary: boundary,
        row: tester.getRect(
          find.descendant(
            of: find.byKey(const ValueKey('sidebar-account-trigger')),
            matching: find.byType(RowBox),
          ),
        ),
        avatar: tester.getRect(find.byType(FortalAvatar)),
        avatarElement: tester.element(find.byType(FortalAvatar)),
        idle: await capturePixels(tester, boundary),
      );
    }

    Color pixelAt(
      GlobalKey boundary,
      WidgetTester tester,
      Pixels pixels,
      Offset p,
    ) {
      final device =
          (p - tester.getTopLeft(find.byKey(boundary))) * pixelScale.toDouble();
      return pixels.at(device.dx.round(), device.dy.round());
    }

    for (final mode in [FortalThemeMode.light, FortalThemeMode.dark]) {
      testWidgets(
        'rings around its content without covering it in ${mode.name}',
        (tester) async {
          final row = await pumpRow(tester, mode: mode);

          await tab(tester);
          await tester.pumpAndSettle();
          final focused = await capturePixels(tester, row.boundary);
          final focus8 = MixScope.tokenOf(
            FortalTokens.focus8,
            tester.element(find.byType(FortalAvatar)),
          );
          Color idle(Offset p) => pixelAt(row.boundary, tester, row.idle, p);
          Color after(Offset p) => pixelAt(row.boundary, tester, focused, p);

          // The ring sits 2px off the row and is 2px wide: 3px out is ring,
          // 1px out is the gap, and 1px in is the row's own content.
          for (final edge in <Offset Function(double out)>[
            (out) => Offset(row.row.center.dx, row.row.top - out),
            (out) => Offset(row.row.center.dx, row.row.bottom + out),
            (out) => Offset(row.row.left - out, row.row.center.dy),
            (out) => Offset(row.row.right + out, row.row.center.dy),
          ]) {
            expectNearColor(after(edge(3)), focus8);
            expectNearColor(after(edge(1)), idle(edge(1)));
          }
          // The avatar's own pixels, including its left edge, are untouched.
          for (final inside in [
            row.avatar.centerLeft.translate(1, 0),
            row.avatar.center,
            row.avatar.centerRight.translate(-1, 0),
          ]) {
            expectNearColor(after(inside), idle(inside));
          }
          expect(tester.getRect(find.byType(FortalAvatar)), row.avatar);
        },
      );
    }

    testWidgets('keeps the state of its content when it takes focus', (
      tester,
    ) async {
      final row = await pumpRow(tester, mode: .light);

      await tab(tester);
      await tester.pumpAndSettle();

      expect(
        tester.element(find.byType(FortalAvatar)),
        same(row.avatarElement),
      );
      expect(tester.getRect(find.byType(FortalAvatar)), row.avatar);
    });

    testWidgets('draws nothing at a ring width of zero', (tester) async {
      final row = await pumpRow(
        tester,
        mode: .light,
        ringTokens: {FortalTokens.focusRingWidth: 0},
      );

      await tab(tester);
      await tester.pumpAndSettle();
      final focused = await capturePixels(tester, row.boundary);

      for (final edge in <Offset>[
        Offset(row.row.center.dx, row.row.top - 2.5),
        Offset(row.row.center.dx, row.row.bottom + 2.5),
        Offset(row.row.left - 2.5, row.row.center.dy),
        Offset(row.row.right + 2.5, row.row.center.dy),
        Offset(row.row.center.dx, row.row.top - 0.5),
        Offset(row.row.center.dx, row.row.bottom + 0.5),
      ]) {
        expectNearColor(
          pixelAt(row.boundary, tester, focused, edge),
          pixelAt(row.boundary, tester, row.idle, edge),
        );
      }
    });
  });

  testWidgets('the top-bar account avatar rings on keyboard focus', (
    tester,
  ) async {
    final trigger = find.descendant(
      of: find.byKey(const ValueKey('topbar-account-trigger')),
      matching: find.byType(RemixIconButton),
    );
    await expectRingOnFocus(
      tester,
      child: FortalDashboardThemeScope(
        settings: const FortalThemeSettings(),
        onChanged: (_) {},
        child: const FortalDashboardTopBar(),
      ),
      trigger: trigger,
      focus: () async =>
          tester.widget<RemixIconButton>(trigger).focusNode!..requestFocus(),
    );
  });

  testWidgets('the top-bar account avatar is one named, expandable button', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpRemixApp(
      FortalDashboardThemeScope(
        settings: const FortalThemeSettings(),
        onChanged: (_) {},
        child: const FortalDashboardTopBar(),
      ),
    );

    expect(find.semantics.byLabel('Account menu'), findsOne);
    expect(
      tester.getSemantics(find.byType(FortalAvatar)),
      isSemantics(
        label: 'Account menu',
        isButton: true,
        hasTapAction: true,
        hasExpandedState: true,
        isExpanded: false,
      ),
    );
    semantics.dispose();
  });
}
