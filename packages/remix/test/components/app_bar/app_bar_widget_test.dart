import 'package:flutter/foundation.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

const _barWidth = 400.0;
const _surface = Color(0xFF102030);

/// A plain button-shaped node, so these tests depend on no other component.
Widget _target(String label, {double size = 40}) => Semantics(
  button: true,
  label: label,
  child: SizedBox.square(key: ValueKey(label), dimension: size),
);

Widget _host(
  Widget child, {
  TextDirection textDirection = TextDirection.ltr,
  EdgeInsets padding = EdgeInsets.zero,
}) {
  return MixScope.empty(
    child: MediaQuery(
      data: MediaQueryData(size: const Size(800, 600), padding: padding),
      child: Directionality(
        textDirection: textDirection,
        child: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(width: _barWidth, child: child),
        ),
      ),
    ),
  );
}

Rect _rect(WidgetTester tester, String key) =>
    tester.getRect(find.byKey(ValueKey(key)));

void main() {
  group('RemixAppBar layout', () {
    testWidgets('places leading, title, and actions with gaps between them', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          RemixAppBar(
            leading: _target('Back'),
            title: 'Orders',
            actions: [_target('Search'), _target('Settings')],
            style: AppBarStyler()
                .spacing(12)
                .actions(FlexBoxStyler().spacing(8)),
          ),
        ),
      );

      expect(tester.getSize(find.byType(RemixAppBar)), const Size(400, 56));
      expect(_rect(tester, 'Back').left, 0);
      expect(_rect(tester, 'Back').top, 8);
      expect(tester.getTopLeft(find.text('Orders')).dx, 52);
      expect(_rect(tester, 'Settings').right, _barWidth);
      expect(_rect(tester, 'Search').right, _rect(tester, 'Settings').left - 8);
    });

    testWidgets('starts the title at the toolbar edge without leading', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          RemixAppBar(
            title: 'Orders',
            style: AppBarStyler()
                .spacing(12)
                .toolbar(BoxStyler().padding(.horizontal(16))),
          ),
        ),
      );

      expect(tester.getTopLeft(find.text('Orders')).dx, 16);
    });

    testWidgets('mirrors in right-to-left text', (tester) async {
      await tester.pumpWidget(
        _host(
          textDirection: TextDirection.rtl,
          RemixAppBar(
            leading: _target('Back'),
            title: 'Orders',
            actions: [_target('Settings')],
            style: AppBarStyler().spacing(12),
          ),
        ),
      );

      expect(_rect(tester, 'Back').right, _barWidth);
      expect(tester.getTopRight(find.text('Orders')).dx, _barWidth - 52);
      expect(_rect(tester, 'Settings').left, 0);
    });

    testWidgets('centers the title in the whole bar on request', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          RemixAppBar(
            leading: _target('Back'),
            title: 'Orders',
            centerTitle: true,
          ),
        ),
      );

      expect(tester.getCenter(find.text('Orders')).dx, _barWidth / 2);
    });

    testWidgets('uses the style height and stacks bottom content below', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          RemixAppBar(
            title: 'Orders',
            bottom: const SizedBox(key: ValueKey('bottom'), height: 40),
            style: AppBarStyler().toolbarHeight(64),
          ),
        ),
      );

      expect(tester.getSize(find.byType(RemixAppBar)).height, 104);
      expect(_rect(tester, 'bottom').top, 64);
      expect(tester.getCenter(find.text('Orders')).dy, 32);
    });

    testWidgets('keeps a long title on one line with an ellipsis', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(RemixAppBar(title: 'A very long title ' * 10)),
      );

      final text = tester.widget<Text>(find.byType(Text));
      expect(text.maxLines, 1);
      expect(text.softWrap, isFalse);
      expect(text.overflow, TextOverflow.ellipsis);
      expect(tester.takeException(), isNull);
    });

    testWidgets('a custom title inherits the title text style', (tester) async {
      await tester.pumpWidget(
        _host(
          RemixAppBar(
            title: 'Overview',
            titleChild: const Text('Workspace / Overview'),
            style: AppBarStyler().title(TextStyler().fontSize(21)),
          ),
        ),
      );

      final style = DefaultTextStyle.of(
        tester.element(find.text('Workspace / Overview')),
      );
      expect(style.style.fontSize, 21);
      expect(style.maxLines, 1);
    });

    testWidgets(
      'clamps negative spacing and toolbarHeight from overshooting lerp to 0',
      (tester) async {
        final overshotSpec = const AppBarSpec(
          toolbarHeight: 0,
          spacing: 0,
        ).lerp(const AppBarSpec(toolbarHeight: 56, spacing: 12), -0.2);

        await tester.pumpWidget(
          _host(
            RemixAppBar(
              leading: _target('Back'),
              title: 'Orders',
              actions: [_target('Settings')],
              styleSpec: overshotSpec,
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(tester.getSize(find.byType(RemixAppBar)), const Size(400, 0));
      },
    );
  });

  group('RemixAppBar safe area', () {
    testWidgets('paints behind the top inset and lays out below it', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          padding: const EdgeInsets.only(top: 24),
          RemixAppBar(
            leading: _target('Back'),
            title: 'Orders',
            style: AppBarStyler().color(_surface),
          ),
        ),
      );

      final surface = find.descendant(
        of: find.byType(RemixAppBar),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is DecoratedBox &&
              (widget.decoration as BoxDecoration).color == _surface,
        ),
      );
      expect(tester.getRect(surface), const Rect.fromLTWH(0, 0, 400, 80));
      expect(_rect(tester, 'Back').top, 32);
      expect(
        MediaQuery.paddingOf(tester.element(find.text('Orders'))).top,
        0,
        reason: 'content below the bar must not reserve the inset again',
      );
    });

    testWidgets('ignores the inset when turned off', (tester) async {
      await tester.pumpWidget(
        _host(
          padding: const EdgeInsets.only(top: 24),
          const RemixAppBar(title: 'Orders', safeArea: false),
        ),
      );

      expect(tester.getSize(find.byType(RemixAppBar)).height, 56);
    });
  });

  group('RemixAppBar semantics', () {
    testWidgets('the title is a heading that names the route on Android', (
      tester,
    ) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(_host(const RemixAppBar(title: 'Orders')));

      expect(
        tester.getSemantics(find.bySemanticsLabel('Orders')),
        matchesSemantics(label: 'Orders', isHeader: true, namesRoute: true),
      );

      semantics.dispose();
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('the title does not name the route on iOS', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(_host(const RemixAppBar(title: 'Orders')));

      expect(
        tester.getSemantics(find.bySemanticsLabel('Orders')),
        matchesSemantics(label: 'Orders', isHeader: true),
      );

      semantics.dispose();
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('namesRoute overrides the platform convention', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        _host(const RemixAppBar(title: 'Orders', namesRoute: false)),
      );

      expect(
        tester.getSemantics(find.bySemanticsLabel('Orders')),
        matchesSemantics(label: 'Orders', isHeader: true),
      );

      semantics.dispose();
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('a title names a custom title widget and hides its parts', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        _host(
          const RemixAppBar(
            title: 'Overview',
            titleChild: Row(children: [Text('Workspace'), Text('Overview')]),
            headingLevel: 1,
          ),
        ),
      );

      final heading = tester.getSemantics(find.bySemanticsLabel('Overview'));
      expect(heading.label, 'Overview');
      expect(heading.getSemanticsData().headingLevel, 1);
      expect(find.bySemanticsLabel('Workspace'), findsNothing);

      semantics.dispose();
    });

    testWidgets('a custom title alone names the heading', (tester) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        _host(const RemixAppBar(titleChild: Text('Inbox'))),
      );

      expect(
        tester.getSemantics(find.bySemanticsLabel('Inbox')),
        isSemantics(label: 'Inbox', isHeader: true),
      );

      semantics.dispose();
    });

    testWidgets('a multi-text custom title merges into one heading node', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        _host(
          const RemixAppBar(
            titleChild: Row(
              children: [Text('Workspace'), Text(' / '), Text('Orders')],
            ),
          ),
        ),
      );

      expect(
        tester.getSemantics(find.bySemanticsLabel('Workspace\n / \nOrders')),
        isSemantics(label: 'Workspace\n / \nOrders', isHeader: true),
      );

      semantics.dispose();
    });

    testWidgets('custom title actions stay independently accessible', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      final activated = <String>[];

      await tester.pumpWidget(
        _host(
          RemixAppBar(
            titleChild: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final label in ['Workspace', 'Orders'])
                  Semantics(
                    button: true,
                    child: GestureDetector(
                      onTap: () => activated.add(label),
                      child: Text(label),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );

      final workspace = tester.getSemantics(find.bySemanticsLabel('Workspace'));
      final orders = tester.getSemantics(find.bySemanticsLabel('Orders'));
      expect(workspace.id, isNot(orders.id));
      expect(
        workspace.getSemanticsData().hasAction(SemanticsAction.tap),
        isTrue,
      );
      expect(orders.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);

      tester.semantics.performAction(
        find.semantics.byLabel('Workspace'),
        SemanticsAction.tap,
      );
      expect(activated, ['Workspace']);
      tester.semantics.performAction(
        find.semantics.byLabel('Orders'),
        SemanticsAction.tap,
      );
      expect(activated, ['Workspace', 'Orders']);

      semantics.dispose();
    });

    testWidgets('custom title preserves Remix link and button behavior', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      final ordersFocusNode = FocusNode();
      addTearDown(ordersFocusNode.dispose);
      final activated = <String>[];

      await tester.pumpWidget(
        _host(
          RemixAppBar(
            titleChild: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                RemixLink(
                  label: 'Home',
                  enableFeedback: false,
                  onPressed: () => activated.add('Home'),
                ),
                RemixLink(
                  label: 'Orders',
                  focusNode: ordersFocusNode,
                  enableFeedback: false,
                  onPressed: () => activated.add('Orders'),
                ),
                const RemixLink(label: 'Disabled'),
                RemixButton(
                  label: 'Refresh',
                  enableFeedback: false,
                  onPressed: () => activated.add('Refresh'),
                ),
              ],
            ),
          ),
        ),
      );

      final nodeIds = <int>{};
      for (final label in ['Home', 'Orders', 'Refresh']) {
        final node = tester.getSemantics(find.bySemanticsLabel(label));
        final data = node.getSemanticsData();
        nodeIds.add(node.id);
        expect(data.flagsCollection.isLink, label != 'Refresh');
        expect(data.flagsCollection.isButton, label == 'Refresh');
        expect(data.hasAction(SemanticsAction.tap), isTrue);
        tester.semantics.performAction(
          find.semantics.byLabel(label),
          SemanticsAction.tap,
        );
      }
      expect(nodeIds, hasLength(3));
      expect(activated, ['Home', 'Orders', 'Refresh']);

      final disabled = tester
          .getSemantics(find.bySemanticsLabel('Disabled'))
          .getSemanticsData();
      expect(disabled.flagsCollection.isLink, isFalse);
      expect(disabled.hasAction(SemanticsAction.tap), isFalse);

      ordersFocusNode.requestFocus();
      await tester.pump();
      expect(ordersFocusNode.hasFocus, isTrue);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      expect(activated, ['Home', 'Orders', 'Refresh', 'Orders']);
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      expect(activated, ['Home', 'Orders', 'Refresh', 'Orders']);

      semantics.dispose();
    });

    testWidgets('leading, title, and actions stay separate and in order', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        _host(
          RemixAppBar(
            leading: _target('Back'),
            title: 'Orders',
            centerTitle: true,
            actions: [_target('Settings')],
          ),
        ),
      );

      final labels = tester.semantics
          .simulatedAccessibilityTraversal()
          .map((node) => node.label)
          .where((label) => label.isNotEmpty)
          .toList();
      expect(labels, ['Back', 'Orders', 'Settings']);

      semantics.dispose();
    });

    testWidgets('meets labeled tap target and text contrast guidelines', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        _host(
          RemixAppBar(
            leading: Semantics(
              button: true,
              label: 'Back',
              onTap: () {},
              child: const SizedBox.square(dimension: 48),
            ),
            title: 'Orders',
            actions: [
              Semantics(
                button: true,
                label: 'Settings',
                onTap: () {},
                child: const SizedBox.square(dimension: 48),
              ),
            ],
            style: AppBarStyler()
                .color(const Color(0xFFFFFFFF))
                .title(TextStyler().color(const Color(0xFF111111))),
          ),
        ),
      );

      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));

      semantics.dispose();
    });
  });

  group('RemixAppBar configuration', () {
    testWidgets('rejects a blank title', (tester) async {
      await tester.pumpWidget(_host(const RemixAppBar(title: '  ')));

      expect(tester.takeException(), isAssertionError);
    });

    test('rejects a heading level outside 1 to 6', () {
      expect(
        () => RemixAppBar(title: 'Orders', headingLevel: 7),
        throwsAssertionError,
      );
    });
  });
}
