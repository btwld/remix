import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/agent.dart';

import '../helpers/pump.dart';
import '../helpers/transcript.dart';

// Ported from registry_source/test/agent/components/transcript_latest_test.dart
// and transcript_resume_test.dart. The way back to the latest is the harness's
// plain button, shown while the live edge offers it; its focus handling and
// the host opt-out stay with the conversation widget.

final _latest = find.byKey(latestKey);

Future<void> _wheel(WidgetTester tester, double dy) async {
  final mouse = TestPointer(1, PointerDeviceKind.mouse);
  mouse.hover(tester.getCenter(find.byType(ListView)));
  await tester.sendEventToBinding(mouse.scroll(Offset(0, dy)));
  await tester.pump();
}

Future<(GlobalKey<GrowingTranscriptState>, ScrollController)> _pump(
  WidgetTester tester, {
  bool disableAnimations = false,
  bool mirrorFollow = false,
}) async {
  final controller = ScrollController();
  addTearDown(controller.dispose);
  final key = GlobalKey<GrowingTranscriptState>();
  await pumpAgent(
    tester,
    SizedBox(
      width: 300,
      height: 160,
      child: GrowingTranscript(
        key: key,
        scrollController: controller,
        mirrorFollow: mirrorFollow,
      ),
    ),
    disableAnimations: disableAnimations,
  );
  await tester.pump();
  return (key, controller);
}

Matcher _atEndOf(ScrollController controller) =>
    closeTo(controller.position.maxScrollExtent, 0.5);

void main() {
  testWidgets('a reader away from the live edge is offered the latest', (
    tester,
  ) async {
    await _pump(tester);
    expect(_latest, findsNothing);

    await _wheel(tester, -200);
    expect(_latest, findsOneWidget);
  });

  testWidgets('the way back stays hidden within the follow threshold', (
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
    expect(controller.offset, _atEndOf(controller));
    expect(key.currentState!.changes, [false, true]);
    expect(_latest, findsNothing);

    key.currentState!.grow();
    await tester.pump();
    expect(controller.offset, _atEndOf(controller));
  });

  testWidgets('output that grows during the return is followed at its end', (
    tester,
  ) async {
    final (key, controller) = await _pump(tester);
    await _wheel(tester, -200);

    await tester.tap(_latest);
    await tester.pump(const Duration(milliseconds: 60));
    key.currentState!.grow();
    await tester.pumpAndSettle();
    expect(controller.offset, _atEndOf(controller));
  });

  testWidgets('reduced motion returns without animating', (tester) async {
    final (_, controller) = await _pump(tester, disableAnimations: true);
    await _wheel(tester, -200);

    await tester.tap(_latest);
    expect(controller.position.isScrollingNotifier.value, isFalse);
    expect(controller.offset, _atEndOf(controller));
  });

  testWidgets('a host that mirrors following is resumed by the way back', (
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
    expect(controller.offset, _atEndOf(controller));
  });

  testWidgets('explicitly re-enabling follow resumes later output growth', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    late StateSetter update;
    var following = true;
    var count = 30;
    await pumpAgent(
      tester,
      StatefulBuilder(
        builder: (context, setState) {
          update = setState;
          return SizedBox(
            width: 300,
            height: 200,
            child: TestTranscript(
              scrollController: controller,
              itemExtent: 40,
              label: 'Turn',
              followOutput: following,
              onFollowChanged: (value) => update(() => following = value),
              itemCount: count,
            ),
          );
        },
      ),
    );
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, 300));
    await tester.pumpAndSettle();
    expect(following, isFalse);

    // Match the application's visible Return to latest action.
    update(() => following = true);
    controller.jumpTo(controller.position.maxScrollExtent);
    await tester.pumpAndSettle();
    update(() => count += 10);
    await tester.pumpAndSettle();
    expect(controller.position.extentAfter, lessThanOrEqualTo(1));
  });

  testWidgets('re-enabling follow alone moves the reader to the end', (
    tester,
  ) async {
    final liveEdge = AgentLiveEdgeController();
    addTearDown(liveEdge.dispose);
    final (key, controller) = await _pumpWith(tester, liveEdge);
    await _wheel(tester, -200);
    liveEdge.enabled = false;
    expect(liveEdge.showLatest, isTrue);

    liveEdge.enabled = true;
    await tester.pump();
    expect(liveEdge.following, isTrue);
    expect(controller.offset, _atEndOf(controller));
    expect(key.currentState!.changes, [false, true]);
  });
}

Future<(GlobalKey<GrowingTranscriptState>, ScrollController)> _pumpWith(
  WidgetTester tester,
  AgentLiveEdgeController liveEdge,
) async {
  final controller = ScrollController();
  addTearDown(controller.dispose);
  final key = GlobalKey<GrowingTranscriptState>();
  await pumpAgent(
    tester,
    SizedBox(
      width: 300,
      height: 160,
      child: GrowingTranscript(
        key: key,
        scrollController: controller,
        liveEdge: liveEdge,
      ),
    ),
  );
  await tester.pump();
  return (key, controller);
}
