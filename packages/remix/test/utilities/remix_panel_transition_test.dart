import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
// ignore: implementation_imports
import 'package:remix/src/utilities/remix_panel_transition.dart';

Widget _fade(
  BuildContext context,
  RemixPanelTransitionInfo info,
  Widget panel,
) => FadeTransition(opacity: info.animation, child: panel);

Widget _other(
  BuildContext context,
  RemixPanelTransitionInfo info,
  Widget panel,
) => panel;

class _Harness extends StatefulWidget {
  const _Harness({super.key, required this.panel});

  final RemixPanelTransition? panel;

  @override
  State<_Harness> createState() => _HarnessState();
}

class _HarnessState extends State<_Harness>
    with SingleTickerProviderStateMixin {
  late final handle = RemixPanelTransitionHandle(vsync: this);
  bool shown = false;
  bool hidden = false;

  void open() {
    handle.openRequested(null, () => setState(() => shown = true), null);
  }

  void close() {
    handle.closeRequested(() => setState(() => hidden = true), null);
  }

  @override
  void dispose() {
    handle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!shown || hidden) return const SizedBox();
    return RemixPanelTransitionHost(
      handle: handle,
      transition: widget.panel,
      anchorRect: Rect.zero,
      child: const Text('panel', textDirection: TextDirection.ltr),
    );
  }
}

void main() {
  group('RemixPanelTransition equality', () {
    test('a top-level builder keeps equal transitions equal', () {
      expect(
        const RemixPanelTransition(builder: _fade),
        const RemixPanelTransition(builder: _fade),
      );
      expect(
        MenuStyler().panelTransition(
          const RemixPanelTransition(builder: _fade),
        ),
        MenuStyler().panelTransition(
          const RemixPanelTransition(builder: _fade),
        ),
      );
    });

    test('an inline closure is a new value on every call', () {
      RemixPanelTransition make() =>
          RemixPanelTransition(builder: (context, info, panel) => panel);

      expect(make(), isNot(make()));
      expect(
        const RemixPanelTransition(builder: _fade),
        isNot(const RemixPanelTransition(builder: _other)),
      );
    });
  });

  group('RemixPanelTransitionHandle', () {
    testWidgets('the mounted panel decides the builder and both durations', (
      tester,
    ) async {
      var built = 0;
      final panel = RemixPanelTransition(
        duration: const Duration(milliseconds: 400),
        reverseDuration: const Duration(milliseconds: 100),
        builder: (context, info, child) {
          built++;
          return FadeTransition(opacity: info.animation, child: child);
        },
      );
      final key = GlobalKey<_HarnessState>();
      await tester.pumpWidget(_Harness(key: key, panel: panel));

      key.currentState!.open();
      await tester.pump();
      expect(built, greaterThan(0));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      final fade = tester.widget<FadeTransition>(find.byType(FadeTransition));
      expect(fade.opacity.value, closeTo(.25, .01));

      await tester.pump(const Duration(milliseconds: 500));
      key.currentState!.close();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 101));
      await tester.pump();

      expect(key.currentState!.hidden, isTrue, reason: 'panel exit is 100 ms');
    });

    testWidgets('a panel with no transition hides immediately', (tester) async {
      final key = GlobalKey<_HarnessState>();
      await tester.pumpWidget(_Harness(key: key, panel: null));

      key.currentState!.open();
      await tester.pump();

      expect(find.byType(FadeTransition), findsNothing);
      key.currentState!.close();
      await tester.pump();
      expect(key.currentState!.hidden, isTrue);
    });

    testWidgets('removing the style does not interrupt an exit', (
      tester,
    ) async {
      const panel = RemixPanelTransition(builder: _fade);
      final key = GlobalKey<_HarnessState>();
      await tester.pumpWidget(_Harness(key: key, panel: panel));

      key.currentState!.open();
      await tester.pump();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      key.currentState!.close();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 40));
      final fade = tester.widget<FadeTransition>(find.byType(FadeTransition));
      expect(fade.opacity.value, closeTo(.8, .01));

      await tester.pumpWidget(_Harness(key: key, panel: null));
      expect(find.byType(FadeTransition), findsOneWidget);
      expect(fade.opacity.value, closeTo(.8, .01));
      final blockers = find.ancestor(
        of: find.text('panel'),
        matching: find.byWidgetPredicate(
          (widget) => widget is IgnorePointer && widget.ignoring,
        ),
      );
      expect(blockers, findsOneWidget);
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump();
      expect(key.currentState!.hidden, isTrue);
    });
  });
}
