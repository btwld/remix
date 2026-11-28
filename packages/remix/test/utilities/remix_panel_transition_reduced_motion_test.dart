import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
// ignore: implementation_imports
import 'package:remix/src/utilities/remix_panel_transition.dart';

Widget _fade(
  BuildContext context,
  RemixPanelTransitionInfo info,
  Widget panel,
) => FadeTransition(opacity: info.animation, child: panel);

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

Future<GlobalKey<_HarnessState>> _pump(
  WidgetTester tester,
  RemixPanelTransition panel, {
  bool reduceMotion = true,
}) async {
  final key = GlobalKey<_HarnessState>();
  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(disableAnimations: reduceMotion),
      child: _Harness(key: key, panel: panel),
    ),
  );
  key.currentState!.open();
  await tester.pump();
  await tester.pump();

  return key;
}

double _opacity(WidgetTester tester) =>
    tester.widget<FadeTransition>(find.byType(FadeTransition)).opacity.value;

void main() {
  group('RemixPanelTransition.reducedMotionDuration', () {
    testWidgets('without it, reduced motion opens and closes at once', (
      tester,
    ) async {
      final key = await _pump(
        tester,
        const RemixPanelTransition(
          builder: _fade,
          duration: Duration(milliseconds: 400),
        ),
      );
      expect(_opacity(tester), 1);

      key.currentState!.close();
      await tester.pump();
      expect(key.currentState!.hidden, isTrue);
    });

    testWidgets('with it, reduced motion keeps a short open and close', (
      tester,
    ) async {
      final key = await _pump(
        tester,
        const RemixPanelTransition(
          builder: _fade,
          duration: Duration(milliseconds: 400),
          reverseDuration: Duration(milliseconds: 300),
          reducedMotionDuration: Duration(milliseconds: 100),
        ),
      );
      await tester.pump(const Duration(milliseconds: 50));
      expect(_opacity(tester), closeTo(.5, .01));
      await tester.pump(const Duration(milliseconds: 50));
      expect(_opacity(tester), 1);

      key.currentState!.close();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      expect(key.currentState!.hidden, isFalse);
      expect(_opacity(tester), closeTo(.5, .01));
      await tester.pump(const Duration(milliseconds: 51));
      await tester.pump();
      expect(key.currentState!.hidden, isTrue);
    });

    testWidgets('full motion ignores it', (tester) async {
      await _pump(
        tester,
        const RemixPanelTransition(
          builder: _fade,
          duration: Duration(milliseconds: 400),
          reducedMotionDuration: Duration(milliseconds: 100),
        ),
        reduceMotion: false,
      );
      await tester.pump(const Duration(milliseconds: 100));

      expect(_opacity(tester), closeTo(.25, .01));
    });

    test('takes part in equality', () {
      expect(
        const RemixPanelTransition(
          builder: _fade,
          reducedMotionDuration: Duration(milliseconds: 100),
        ),
        isNot(const RemixPanelTransition(builder: _fade)),
      );
    });
  });
}
