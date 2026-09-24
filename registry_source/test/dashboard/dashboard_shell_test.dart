import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/default/recipes/dashboard/dashboard_shell.dart';
import 'package:registry_source/src/default/theme/theme_data.dart';
import 'package:registry_source/src/default/theme/theme_scope.dart';
import 'package:registry_source/src/fortal/recipes/dashboard/dashboard_shell.dart';
import 'package:registry_source/src/fortal/theme/theme.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

enum _Preset { defaultPreset, fortal }

const _sections = <RemixSidebarSection<String>>[
  RemixSidebarSection(
    label: 'Workspace',
    destinations: [
      RemixSidebarDestination(
        value: 'overview',
        label: 'Overview',
        icon: RemixIcons.dashboard,
      ),
      RemixSidebarDestination(
        value: 'reports',
        label: 'Reports',
        icon: RemixIcons.fileText,
      ),
    ],
  ),
];

void main() {
  for (final preset in _Preset.values) {
    group(preset.name, () {
      testWidgets('selection emits once and compact selection closes drawer', (
        tester,
      ) async {
        final selected = <String>[];
        await _pump(
          tester,
          preset: preset,
          width: 390,
          onSelected: selected.add,
        );

        expect(find.byKey(const ValueKey('dashboard-sidebar')), findsNothing);
        await tester.tap(find.byKey(const ValueKey('dashboard-menu')).first);
        await tester.pumpAndSettle();
        expect(find.byKey(const ValueKey('dashboard-sidebar')), findsWidgets);

        await tester.tap(find.text('Reports'));
        await tester.pumpAndSettle();

        expect(selected, ['reports']);
        expect(find.byKey(const ValueKey('dashboard-sidebar')), findsNothing);
        expect(find.text('reports body'), findsOneWidget);
      });

      testWidgets('collapse is accessible and controlled by the host', (
        tester,
      ) async {
        final collapsed = ValueNotifier(false);
        addTearDown(collapsed.dispose);
        await _pump(tester, preset: preset, width: 1100, collapsed: collapsed);

        expect(
          tester
              .getSize(find.byKey(const ValueKey('dashboard-sidebar')).first)
              .width,
          256,
        );
        await tester.tap(
          find.byKey(const ValueKey('dashboard-collapse')).first,
        );
        await tester.pumpAndSettle();
        expect(collapsed.value, isTrue);
        expect(
          tester
              .getSize(find.byKey(const ValueKey('dashboard-sidebar')).first)
              .width,
          72,
        );
        expect(find.text('Workspace account'), findsNothing);
      });

      testWidgets('search is opt-in and reports host-owned input', (
        tester,
      ) async {
        await _pump(tester, preset: preset, width: 1100);
        expect(find.byKey(const ValueKey('dashboard-search')), findsNothing);

        final queries = <String>[];
        await _pump(
          tester,
          preset: preset,
          width: 1100,
          onSearchChanged: queries.add,
        );
        await tester.enterText(find.byType(EditableText), 'orders');
        expect(queries.last, 'orders');
      });

      testWidgets('custom header title replaces the visible fallback', (
        tester,
      ) async {
        await _pump(
          tester,
          preset: preset,
          width: 1100,
          headerTitle: const Row(
            children: [Text('Workspace'), Text(' / '), Text('Overview')],
          ),
        );

        expect(find.text('Workspace'), findsWidgets);
        expect(find.text(' / '), findsOneWidget);
        expect(
          find.descendant(
            of: find.byKey(const ValueKey('dashboard-title')),
            matching: find.text('Overview'),
          ),
          findsOneWidget,
        );
        expect(find.bySemanticsLabel('Overview'), findsWidgets);
        expect(tester.takeException(), isNull);
      });

      testWidgets('page state survives the responsive reparent', (
        tester,
      ) async {
        final width = ValueNotifier(1100.0);
        addTearDown(width.dispose);
        await _pump(
          tester,
          preset: preset,
          width: width.value,
          widthListenable: width,
          body: const _CounterPage(),
        );

        await tester.tap(find.text('Increment'));
        await tester.pump();
        expect(find.text('Count 1'), findsOneWidget);

        width.value = 390;
        await tester.pumpAndSettle();
        expect(find.text('Count 1'), findsOneWidget);

        width.value = 1100;
        await tester.pumpAndSettle();
        expect(find.text('Count 1'), findsOneWidget);
      });

      testWidgets('Escape restores focus to the compact menu trigger', (
        tester,
      ) async {
        await _pump(tester, preset: preset, width: 390);
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        final before = FocusManager.instance.primaryFocus;
        expect(before, isNotNull);

        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pumpAndSettle();
        expect(find.byKey(const ValueKey('dashboard-sidebar')), findsWidgets);

        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();
        expect(find.byKey(const ValueKey('dashboard-sidebar')), findsNothing);
        expect(FocusManager.instance.primaryFocus, same(before));
      });

      testWidgets('RTL, dark mode, and host slots build without overflow', (
        tester,
      ) async {
        await _pump(
          tester,
          preset: preset,
          width: 1100,
          brightness: Brightness.dark,
          textDirection: TextDirection.rtl,
          headerActions: const [Text('Host action')],
        );

        expect(find.text('Acme brand'), findsOneWidget);
        expect(find.text('Workspace account'), findsOneWidget);
        expect(find.text('Host action'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });
  }

  test('dashboard recipes remain independent of Material', () {
    final lib = Directory('lib').existsSync() ? 'lib' : 'registry_source/lib';
    for (final path in [
      '$lib/src/dashboard/dashboard_shell_base.dart',
      '$lib/src/default/recipes/dashboard/dashboard_shell.dart',
      '$lib/src/fortal/recipes/dashboard/dashboard_shell.dart',
    ]) {
      expect(
        File(path).readAsStringSync(),
        isNot(contains('package:flutter/material.dart')),
        reason: path,
      );
    }
  });
}

Future<void> _pump(
  WidgetTester tester, {
  required _Preset preset,
  required double width,
  ValueListenable<double>? widthListenable,
  ValueChanged<String>? onSelected,
  ValueChanged<String>? onSearchChanged,
  ValueNotifier<bool>? collapsed,
  Widget body = const Text('overview body'),
  Brightness brightness = Brightness.light,
  TextDirection textDirection = TextDirection.ltr,
  List<Widget> headerActions = const [],
  Widget? headerTitle,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(1200, 800);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  Widget shell(double currentWidth) => SizedBox(
    width: currentWidth,
    height: 700,
    child: _ShellHarness(
      preset: preset,
      onSelected: onSelected,
      onSearchChanged: onSearchChanged,
      collapsed: collapsed,
      body: body,
      headerActions: headerActions,
      headerTitle: headerTitle,
    ),
  );

  final content = widthListenable == null
      ? shell(width)
      : ValueListenableBuilder<double>(
          valueListenable: widthListenable,
          builder: (context, currentWidth, _) => shell(currentWidth),
        );
  final app = WidgetsApp(
    color: const Color(0xFFFFFFFF),
    pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    ),
    builder: (context, child) =>
        Directionality(textDirection: textDirection, child: child!),
    home: Align(alignment: Alignment.topLeft, child: content),
  );
  await tester.pumpWidget(switch (preset) {
    .defaultPreset => VanillaThemeScope(
      mode: brightness == Brightness.light
          ? VanillaThemeMode.light
          : VanillaThemeMode.dark,
      child: app,
    ),
    .fortal => FortalScope(
      mode: brightness == Brightness.light
          ? FortalThemeMode.light
          : FortalThemeMode.dark,
      child: app,
    ),
  });
  await tester.pump();
}

class _ShellHarness extends StatefulWidget {
  const _ShellHarness({
    required this.preset,
    required this.onSelected,
    required this.onSearchChanged,
    required this.collapsed,
    required this.body,
    required this.headerActions,
    required this.headerTitle,
  });

  final _Preset preset;
  final ValueChanged<String>? onSelected;
  final ValueChanged<String>? onSearchChanged;
  final ValueNotifier<bool>? collapsed;
  final Widget body;
  final List<Widget> headerActions;
  final Widget? headerTitle;

  @override
  State<_ShellHarness> createState() => _ShellHarnessState();
}

class _ShellHarnessState extends State<_ShellHarness> {
  String selected = 'overview';

  @override
  Widget build(BuildContext context) {
    Widget buildShell(bool? collapsed) {
      final body = selected == 'overview'
          ? widget.body
          : Text('$selected body');
      void select(String value) {
        setState(() => selected = value);
        widget.onSelected?.call(value);
      }

      return switch (widget.preset) {
        .defaultPreset => VanillaDashboardShell<String>(
          sections: _sections,
          selectedValue: selected,
          onSelected: select,
          body: body,
          title: 'Overview',
          headerTitle: widget.headerTitle,
          brand: const Text('Acme brand'),
          account: const Text('Workspace account'),
          headerActions: widget.headerActions,
          onSearchChanged: widget.onSearchChanged,
          collapsed: collapsed,
          onCollapsedChanged: (value) => widget.collapsed?.value = value,
        ),
        .fortal => FortalDashboardShell<String>(
          sections: _sections,
          selectedValue: selected,
          onSelected: select,
          body: body,
          title: 'Overview',
          headerTitle: widget.headerTitle,
          brand: const Text('Acme brand'),
          account: const Text('Workspace account'),
          headerActions: widget.headerActions,
          onSearchChanged: widget.onSearchChanged,
          collapsed: collapsed,
          onCollapsedChanged: (value) => widget.collapsed?.value = value,
        ),
      };
    }

    final notifier = widget.collapsed;
    if (notifier == null) return buildShell(null);
    return ValueListenableBuilder<bool>(
      valueListenable: notifier,
      builder: (context, collapsed, _) => buildShell(collapsed),
    );
  }
}

class _CounterPage extends StatefulWidget {
  const _CounterPage();

  @override
  State<_CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<_CounterPage> {
  int count = 0;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text('Count $count'),
      GestureDetector(
        onTap: () => setState(() => count += 1),
        child: Semantics(button: true, child: const Text('Increment')),
      ),
    ],
  );
}
