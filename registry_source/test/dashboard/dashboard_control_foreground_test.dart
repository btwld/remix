import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/default/recipes/dashboard/dashboard_overview.dart';
import 'package:registry_source/src/default/recipes/dashboard/dashboard_shell.dart';
import 'package:registry_source/src/default/theme/theme_data.dart';
import 'package:registry_source/src/default/theme/theme_scope.dart';
import 'package:registry_source/src/default/theme/tokens.dart';
import 'package:registry_source/src/fortal/recipes/dashboard/dashboard_overview.dart';
import 'package:registry_source/src/fortal/recipes/dashboard/dashboard_shell.dart';
import 'package:registry_source/src/fortal/theme/theme.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../helpers/contrast.dart';

const _collapse = ValueKey('dashboard-collapse');
const _viewAll = ValueKey('overview-view-orders');

/// A host foreground no recipe uses, so inheriting it cannot pass by accident.
const _hostile = Color(0xFFFF00FF);

/// The dashboard's ghost controls paint their recipe foreground.
///
/// Each test mounts the real shell and overview in a `WidgetsApp`, because a
/// `MaterialApp` installs an `IconTheme` that could mask a missing colour, and
/// puts a hostile `IconTheme` and text run between the theme and the controls.
/// It reads the colours handed to the painted spans, for the glyph and the
/// label alike.
void main() {
  for (final preset in _Preset.values) {
    for (final dark in [false, true]) {
      final mode = dark ? 'dark' : 'light';

      group('${preset.name}/$mode', () {
        testWidgets('enabled controls paint the ink and clear contrast', (
          tester,
        ) async {
          await _pumpDashboard(tester, preset: preset, dark: dark);

          for (final key in [_collapse, _viewAll]) {
            final colors = _paintedColors(tester, key);
            final ink = preset.ink(tester.element(_control(key)));
            final panel = preset.panel(tester.element(_control(key)));
            expect(colors, everyElement(ink), reason: '$key');
            // Glyphs need 3:1 and the label 4.5:1; every span here takes 4.5:1.
            expect(
              contrastRatio(Color.alphaBlend(ink, panel), panel),
              greaterThanOrEqualTo(4.5),
              reason: '$key',
            );
          }
          expect(_paintedColors(tester, _viewAll), hasLength(2));
        });

        testWidgets('hover and press keep the recipe foreground', (
          tester,
        ) async {
          await _pumpDashboard(tester, preset: preset, dark: dark);

          final hover = await tester.createGesture(
            kind: PointerDeviceKind.mouse,
          );
          await hover.addPointer(location: Offset.zero);
          addTearDown(hover.removePointer);

          for (final key in [_collapse, _viewAll]) {
            final control = _control(key);
            final context = tester.element(control);
            await hover.moveTo(tester.getCenter(control));
            await tester.pumpAndSettle();
            expect(
              _paintedColors(tester, key),
              everyElement(preset.highlightedInk(context)),
              reason: 'hovered $key',
            );

            final press = await tester.startGesture(tester.getCenter(control));
            await tester.pumpAndSettle();
            expect(
              _paintedColors(tester, key),
              everyElement(preset.highlightedInk(context)),
              reason: 'pressed $key',
            );
            await press.cancel();
            await hover.moveTo(Offset.zero);
            await tester.pumpAndSettle();
          }
        });

        testWidgets('keyboard focus keeps the ink', (tester) async {
          final strategy = FocusManager.instance.highlightStrategy;
          FocusManager.instance.highlightStrategy =
              FocusHighlightStrategy.alwaysTraditional;
          addTearDown(() => FocusManager.instance.highlightStrategy = strategy);
          await _pumpDashboard(tester, preset: preset, dark: dark);

          final control = _control(_collapse);
          var focused = false;
          for (var stop = 0; stop < 8 && !focused; stop++) {
            await tester.sendKeyEvent(LogicalKeyboardKey.tab);
            await tester.pumpAndSettle();
            final primary = FocusManager.instance.primaryFocus?.context;
            focused =
                primary != null &&
                find
                    .descendant(
                      of: control,
                      matching: find.byElementPredicate((e) => e == primary),
                    )
                    .evaluate()
                    .isNotEmpty;
          }
          expect(focused, isTrue, reason: 'Tab never reached $_collapse');
          expect(
            _paintedColors(tester, _collapse),
            everyElement(preset.ink(tester.element(control))),
          );
        });

        testWidgets('an inactive control stays visibly inactive', (
          tester,
        ) async {
          await _pumpDashboard(
            tester,
            preset: preset,
            dark: dark,
            viewOrdersEnabled: false,
          );

          preset.expectDisabled(tester, _viewAll);
        });
      });
    }

    for (final startDark in [false, true]) {
      final target = startDark ? 'light' : 'dark';

      testWidgets('${preset.name}: switching to $target settles on its ink', (
        tester,
      ) async {
        final host = await _pumpDashboard(
          tester,
          preset: preset,
          dark: startDark,
        );
        final before = preset.ink(tester.element(_control(_collapse)));

        host.value = !startDark;
        // The controls animate between the two inks, so a frame taken before
        // this settles shows the outgoing mode's ink on the incoming surface.
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        for (final key in [_collapse, _viewAll]) {
          final ink = preset.ink(tester.element(_control(key)));
          expect(ink, isNot(before));
          expect(
            _paintedColors(tester, key),
            everyElement(ink),
            reason: '$key',
          );
        }
      });
    }
  }
}

/// The dashboard recipes forward their key, so several elements carry it.
Finder _control(ValueKey<String> key) => find.byKey(key).first;

/// The colours of every glyph and text span painted inside [key].
List<Color?> _paintedColors(WidgetTester tester, ValueKey<String> key) {
  final spans = find.descendant(
    of: _control(key),
    matching: find.byType(RichText),
  );
  expect(spans, findsWidgets, reason: '$key paints nothing');

  return [
    for (final span in tester.widgetList<RichText>(spans))
      span.text.style?.color,
  ];
}

Future<ValueNotifier<bool>> _pumpDashboard(
  WidgetTester tester, {
  required _Preset preset,
  required bool dark,
  bool viewOrdersEnabled = true,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(1440, 1600);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final isDark = ValueNotifier(dark);
  addTearDown(isDark.dispose);

  await tester.pumpWidget(
    WidgetsApp(
      color: const Color(0xFFFFFFFF),
      debugShowCheckedModeBanner: false,
      pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) =>
            builder(context),
      ),
      home: ValueListenableBuilder<bool>(
        valueListenable: isDark,
        builder: (context, value, _) => preset.theme(
          dark: value,
          child: IconTheme.merge(
            data: const IconThemeData(color: _hostile),
            child: DefaultTextStyle.merge(
              style: const TextStyle(color: _hostile),
              child: preset.dashboard(
                onViewOrders: viewOrdersEnabled ? () {} : null,
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return isDark;
}

const _sections = <RemixSidebarSection<String>>[
  RemixSidebarSection(
    label: 'Workspace',
    destinations: [
      RemixSidebarDestination(
        value: 'overview',
        label: 'Overview',
        icon: RemixIcons.grid,
      ),
    ],
  ),
];

enum _Preset {
  fortal,
  vanilla;

  Widget theme({required bool dark, required Widget child}) => switch (this) {
    .fortal => FortalTheme(
      mode: dark ? FortalThemeMode.dark : FortalThemeMode.light,
      child: child,
    ),
    .vanilla => VanillaTheme(
      mode: dark ? VanillaThemeMode.dark : VanillaThemeMode.light,
      child: child,
    ),
  };

  Widget dashboard({required VoidCallback? onViewOrders}) => switch (this) {
    .fortal => FortalDashboardShell<String>(
      sections: _sections,
      selectedValue: 'overview',
      onSelected: (_) {},
      title: 'Overview',
      brand: const Text('Northstar'),
      body: FortalDashboardOverview(onViewOrders: onViewOrders),
    ),
    .vanilla => VanillaDashboardShell<String>(
      sections: _sections,
      selectedValue: 'overview',
      onSelected: (_) {},
      title: 'Overview',
      brand: const Text('Northstar'),
      body: VanillaDashboardOverview(onViewOrders: onViewOrders),
    ),
  };

  /// The resting foreground of a ghost control.
  Color ink(BuildContext context) => switch (this) {
    .fortal => MixScope.tokenOf(FortalTokens.accentA11, context),
    .vanilla => MixScope.tokenOf(VanillaTokens.foreground, context),
  };

  /// The foreground under the pointer or a press.
  Color highlightedInk(BuildContext context) => switch (this) {
    .fortal => MixScope.tokenOf(FortalTokens.accentA11, context),
    .vanilla => MixScope.tokenOf(VanillaTokens.accentForeground, context),
  };

  /// The surface behind a resting ghost control.
  Color panel(BuildContext context) => switch (this) {
    .fortal => MixScope.tokenOf(FortalTokens.colorPanelSolid, context),
    .vanilla => MixScope.tokenOf(VanillaTokens.card, context),
  };

  void expectDisabled(WidgetTester tester, ValueKey<String> key) {
    final context = tester.element(_control(key));
    switch (this) {
      case .fortal:
        final disabled = MixScope.tokenOf(FortalTokens.grayA8, context);
        expect(disabled, isNot(ink(context)));
        expect(_paintedColors(tester, key), everyElement(disabled));
      case .vanilla:
        expect(_paintedColors(tester, key), everyElement(ink(context)));
        final faded = find.descendant(
          of: _control(key),
          matching: find.byWidgetPredicate(
            (widget) => widget is Opacity && widget.opacity < 1,
          ),
        );
        expect(faded, findsWidgets);
    }
  }
}
