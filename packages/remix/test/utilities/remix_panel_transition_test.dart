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

/// Owns a handle that guesses one transition at the request, while the host
/// reports another from the panel's own scope.
class _Harness extends StatefulWidget {
  const _Harness({super.key, required this.guess, required this.panel});

  final RemixPanelTransition? guess;
  final RemixPanelTransition? panel;

  @override
  State<_Harness> createState() => _HarnessState();
}

class _HarnessState extends State<_Harness>
    with SingleTickerProviderStateMixin {
  late final handle = RemixPanelTransitionHandle(
    vsync: this,
    resolve: () => widget.guess,
    reduceMotion: () => false,
  );
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
    testWidgets('the panel scope decides the builder and the exit length', (
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
      const guess = RemixPanelTransition(
        duration: Duration(milliseconds: 50),
        reverseDuration: Duration(milliseconds: 900),
        builder: _other,
      );
      final key = GlobalKey<_HarnessState>();
      await tester.pumpWidget(_Harness(key: key, guess: guess, panel: panel));

      key.currentState!.open();
      await tester.pump();
      expect(built, greaterThan(0), reason: 'the panel builder, not the guess');
      expect(key.currentState!.handle.animation, isNotNull);

      await tester.pump(const Duration(milliseconds: 500));
      key.currentState!.close();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 101));
      await tester.pump();

      expect(key.currentState!.hidden, isTrue, reason: 'panel exit is 100 ms');
    });

    testWidgets('a panel with no transition stops what the request started', (
      tester,
    ) async {
      const guess = RemixPanelTransition(builder: _fade);
      final key = GlobalKey<_HarnessState>();
      await tester.pumpWidget(_Harness(key: key, guess: guess, panel: null));

      key.currentState!.open();
      await tester.pump();

      expect(key.currentState!.handle.animation, isNull);
      key.currentState!.close();
      await tester.pump();
      expect(key.currentState!.hidden, isTrue);
    });

    testWidgets('a panel transition starts one the request did not', (
      tester,
    ) async {
      const panel = RemixPanelTransition(builder: _fade);
      final key = GlobalKey<_HarnessState>();
      await tester.pumpWidget(_Harness(key: key, guess: null, panel: panel));

      key.currentState!.open();
      await tester.pump();

      expect(key.currentState!.handle.animation, isNotNull);
      await tester.pump(const Duration(milliseconds: 250));
    });
  });
}
