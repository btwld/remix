import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/agent.dart';

import '../helpers/pump.dart';

final _latest = find.byKey(const ValueKey('agent-transcript-latest'));

Future<void> _wheel(WidgetTester tester, double dy) async {
  final mouse = TestPointer(1, PointerDeviceKind.mouse);
  mouse.hover(tester.getCenter(find.byType(ListView)));
  await tester.sendEventToBinding(mouse.scroll(Offset(0, dy)));
  await tester.pump();
}

Future<(GlobalKey<_HarnessState>, ScrollController)> _pump(
  WidgetTester tester, {
  bool disableAnimations = false,
  bool showLatestButton = true,
  bool mirrorFollow = false,
}) async {
  final controller = ScrollController();
  addTearDown(controller.dispose);
  final key = GlobalKey<_HarnessState>();
  await pumpAgent(
    tester,
    SizedBox(
      width: 300,
      height: 160,
      child: _Harness(
        key: key,
        controller: controller,
        showLatestButton: showLatestButton,
        mirrorFollow: mirrorFollow,
      ),
    ),
    disableAnimations: disableAnimations,
  );
  await tester.pump();
  return (key, controller);
}

void main() {
  testWidgets('a reader away from the live edge is offered the latest', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await _pump(tester);
    expect(_latest, findsNothing);

    await _wheel(tester, -200);
    expect(_latest, findsOneWidget);
    expect(find.bySemanticsLabel('Scroll to latest'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('the button stays hidden within the follow threshold', (
    tester,
  ) async {
    final (key, _) = await _pump(tester);

    await _wheel(tester, -20);
    expect(key.currentState!.changes, [false]);
    expect(_latest, findsNothing);

    // Output that grows below the released reader carries them past it.
    key.currentState!.grow();
    await tester.pump();
    await tester.pump();
    expect(_latest, findsOneWidget);
  });

  testWidgets('it returns to the end and follows later output', (tester) async {
    final (key, controller) = await _pump(tester);
    await _wheel(tester, -200);

    await tester.tap(_latest);
    await tester.pumpAndSettle();
    expect(
      controller.offset,
      closeTo(controller.position.maxScrollExtent, 0.5),
    );
    expect(key.currentState!.changes, [false, true]);
    expect(_latest, findsNothing);

    key.currentState!.grow();
    await tester.pump();
    expect(
      controller.offset,
      closeTo(controller.position.maxScrollExtent, 0.5),
    );
  });

  testWidgets('reduced motion returns without animating', (tester) async {
    final (_, controller) = await _pump(tester, disableAnimations: true);
    await _wheel(tester, -200);

    await tester.tap(_latest);
    expect(controller.position.isScrollingNotifier.value, isFalse);
    expect(
      controller.offset,
      closeTo(controller.position.maxScrollExtent, 0.5),
    );
  });

  testWidgets('a host that mirrors following is resumed by the button', (
    tester,
  ) async {
    final (key, controller) = await _pump(tester, mirrorFollow: true);
    await _wheel(tester, -200);
    expect(key.currentState!.following, isFalse);

    await tester.tap(_latest);
    await tester.pumpAndSettle();
    expect(key.currentState!.following, isTrue);
    key.currentState!.grow();
    await tester.pump();
    expect(
      controller.offset,
      closeTo(controller.position.maxScrollExtent, 0.5),
    );
  });

  testWidgets('keyboard users reach it and keep focus in the transcript', (
    tester,
  ) async {
    await _pump(tester);
    final viewport = Focus.of(tester.element(find.byType(ListView)));
    viewport.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.home);
    await tester.pump();
    expect(_latest, findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    final focused = FocusManager.instance.primaryFocus!.context!;
    expect(
      find.descendant(of: _latest, matching: find.byWidget(focused.widget)),
      findsOneWidget,
      reason: 'Tab moves from the transcript to its scroll-to-latest button.',
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(_latest, findsNothing);
    expect(viewport.hasPrimaryFocus, isTrue);
  });

  testWidgets('hosts may leave the way back to their own chrome', (
    tester,
  ) async {
    await _pump(tester, showLatestButton: false);
    await _wheel(tester, -200);
    expect(_latest, findsNothing);
  });
}

class _Harness extends StatefulWidget {
  const _Harness({
    super.key,
    required this.controller,
    required this.showLatestButton,
    required this.mirrorFollow,
  });

  final ScrollController controller;
  final bool showLatestButton;
  final bool mirrorFollow;

  @override
  State<_Harness> createState() => _HarnessState();
}

class _HarnessState extends State<_Harness> {
  var count = 24;
  var following = true;
  final changes = <bool>[];

  void grow() => setState(() => count += 6);

  @override
  Widget build(BuildContext context) => AgentTranscript.builder(
    controller: widget.controller,
    showLatestButton: widget.showLatestButton,
    followOutput: widget.mirrorFollow ? following : true,
    onFollowChanged: (value) {
      changes.add(value);
      if (widget.mirrorFollow) setState(() => following = value);
    },
    itemCount: count,
    itemBuilder: (context, index) =>
        SizedBox(height: 24, child: Text('Line $index')),
  );
}
