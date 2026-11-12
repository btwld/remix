import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/agent.dart';

import '../helpers/pump.dart';
import '../helpers/transcript.dart';

// Ported from registry_source/test/agent/components/live_edge_test.dart. The
// transcript, plan and activity widgets stand in as the harnesses in
// test/helpers/transcript.dart and _GrowingLedger below; the styling cases
// stay with the widgets.

Future<void> _wheel(WidgetTester tester, Finder over, double dy) async {
  final mouse = TestPointer(1, PointerDeviceKind.mouse);
  mouse.hover(tester.getCenter(over));
  await tester.sendEventToBinding(mouse.scroll(Offset(0, dy)));
  await tester.pump();
}

Future<(GlobalKey<GrowingTranscriptState>, ScrollController)> _pumpGrowing(
  WidgetTester tester, {
  AgentLiveEdgeController? liveEdge,
  int initialCount = 24,
}) async {
  final controller = ScrollController();
  addTearDown(controller.dispose);
  final key = GlobalKey<GrowingTranscriptState>();
  await pumpAgent(
    tester,
    SizedBox(
      width: 300,
      height: 120,
      child: GrowingTranscript(
        key: key,
        initialCount: initialCount,
        scrollController: controller,
        liveEdge: liveEdge,
      ),
    ),
  );
  await tester.pump();
  return (key, controller);
}

Future<void> _growAndSettle(
  GlobalKey<GrowingTranscriptState> key,
  WidgetTester tester,
) async {
  key.currentState!.grow();
  await tester.pump();
  await tester.pump();
}

Matcher _atEndOf(ScrollController controller) =>
    closeTo(controller.position.maxScrollExtent, 0.5);

void main() {
  test('followThreshold defaults to 48', () {
    // The transcript worksheet records "followThreshold default 48 logical
    // pixels"; the registry pinned the same constant in its widgets.
    expect(AgentLiveEdgeController().threshold, 48);
  });

  testWidgets('transcript follows growth, releases, and reattaches', (
    tester,
  ) async {
    final (key, controller) = await _pumpGrowing(tester);
    expect(controller.offset, _atEndOf(controller));

    await tester.drag(find.byType(ListView), const Offset(0, 160));
    await tester.pump();
    expect(key.currentState!.changes, contains(false));
    final readingOffset = controller.offset;

    await _growAndSettle(key, tester);
    expect(controller.offset, closeTo(readingOffset, 0.5));

    await tester.drag(find.byType(ListView), const Offset(0, -2000));
    await tester.pump();
    expect(key.currentState!.changes, contains(true));
    await _growAndSettle(key, tester);
    expect(controller.offset, _atEndOf(controller));
  });

  for (final dy in [-400.0, -20.0]) {
    testWidgets('a mouse wheel turned up ${-dy}px releases the live edge and '
        'holds the reader through later output', (tester) async {
      final (key, controller) = await _pumpGrowing(tester);
      final end = controller.position.maxScrollExtent;
      expect(controller.offset, closeTo(end, 0.5));

      await _wheel(tester, find.byType(ListView), dy);
      expect(key.currentState!.changes, [false]);
      final reading = controller.offset;
      expect(reading, closeTo(end + dy, 0.5));

      await _growAndSettle(key, tester);
      expect(controller.offset, closeTo(reading, 0.5));
      // The registry version also checked that maxScrollExtent grew. A lazy
      // list re-estimates its extent only when it lays out, and this plain
      // harness, unlike the styled transcript, does not relay out unseen rows.
    });
  }

  testWidgets('the wheel brings the reader back to the end and follows again', (
    tester,
  ) async {
    final (key, controller) = await _pumpGrowing(tester);
    await _wheel(tester, find.byType(ListView), -200);
    expect(key.currentState!.changes, [false]);

    await _wheel(tester, find.byType(ListView), 1000);
    expect(key.currentState!.changes, [false, true]);
    await _growAndSettle(key, tester);
    expect(controller.offset, _atEndOf(controller));
  });

  testWidgets('a short drag up releases even inside the follow threshold', (
    tester,
  ) async {
    final (key, controller) = await _pumpGrowing(tester);
    await tester.drag(
      find.byType(ListView),
      const Offset(0, 30),
      touchSlopY: 0,
    );
    await tester.pump();
    expect(key.currentState!.changes, [false]);
    final reading = controller.offset;

    await _growAndSettle(key, tester);
    expect(controller.offset, closeTo(reading, 0.5));
  });

  testWidgets('a jump to the start releases and a jump to the end follows', (
    tester,
  ) async {
    // The transcript's Home and End keys jump the position; any jump decides
    // following like a reader scroll.
    final (key, controller) = await _pumpGrowing(tester);
    controller.jumpTo(0);
    await tester.pump();
    expect(key.currentState!.changes, [false]);
    expect(controller.offset, 0);

    controller.jumpTo(controller.position.maxScrollExtent);
    await tester.pump();
    expect(key.currentState!.changes, [false, true]);
    await _growAndSettle(key, tester);
    expect(controller.offset, _atEndOf(controller));
  });

  testWidgets('a host scroll toward older output releases the live edge', (
    tester,
  ) async {
    final (key, controller) = await _pumpGrowing(tester);
    controller.jumpTo(40);
    await tester.pump();
    expect(key.currentState!.changes, [false]);

    await _growAndSettle(key, tester);
    expect(controller.offset, 40);
  });

  testWidgets('a mouse wheel releases a non-lazy ledger the same way', (
    tester,
  ) async {
    final key = GlobalKey<_GrowingLedgerState>();
    await pumpAgent(tester, _GrowingLedger(key: key));
    await tester.pump();
    final scrollView = find.byType(SingleChildScrollView);
    final controller = tester
        .widget<SingleChildScrollView>(scrollView)
        .controller!;

    await _wheel(tester, scrollView, -30);
    expect(key.currentState!.changes, [false]);
    final reading = controller.offset;

    key.currentState!.grow();
    await tester.pump();
    await tester.pump();
    expect(controller.offset, closeTo(reading, 0.5));
  });

  testWidgets('streamed output is in view in the frame that paints it', (
    tester,
  ) async {
    final (key, controller) = await _pumpGrowing(tester);
    final viewport = tester.getRect(find.byType(ListView));
    for (var update = 0; update < 5; update++) {
      key.currentState!.grow();
      await tester.pump();

      final newest = 'Line ${key.currentState!.count - 1}';
      expect(
        tester.getRect(find.text(newest)).bottom,
        lessThanOrEqualTo(viewport.bottom + 0.5),
        reason: 'The newest line must be painted inside the viewport.',
      );
      expect(controller.offset, _atEndOf(controller));
      expect(
        tester
            .renderObject<RenderViewport>(find.byType(Viewport))
            .debugNeedsLayout,
        isFalse,
        reason: 'Following must not lay the list out again in a second frame.',
      );
    }
  });

  testWidgets('a non-lazy ledger keeps its newest row in view the same way', (
    tester,
  ) async {
    final key = GlobalKey<_GrowingLedgerState>();
    await pumpAgent(tester, _GrowingLedger(key: key));
    await tester.pump();
    final scrollView = find.byType(SingleChildScrollView);

    key.currentState!.grow();
    await tester.pump();

    final newest = 'Row ${key.currentState!.count - 1}';
    expect(
      tester.getRect(find.text(newest)).bottom,
      lessThanOrEqualTo(tester.getRect(scrollView).bottom + 0.5),
    );
    final viewport = tester.renderObject<RenderBox>(
      find.descendant(
        of: scrollView,
        matching: find.byWidgetPredicate(
          (widget) => '${widget.runtimeType}' == '_SingleChildViewport',
        ),
      ),
    );
    expect(
      viewport.debugNeedsPaint,
      isFalse,
      reason: 'The frame that grew the ledger already painted its end.',
    );
  });

  testWidgets('a recreated scroll position still lands on the live edge', (
    tester,
  ) async {
    // A Scrollable rebuilds its ScrollPosition when its dependencies change,
    // for example a new ScrollBehavior at a responsive breakpoint, and that
    // position's first layout skips the physics that keep the end.
    final controller = ScrollController();
    addTearDown(controller.dispose);
    var behavior = 0;
    var count = 20;
    late StateSetter update;
    await pumpAgent(
      tester,
      StatefulBuilder(
        builder: (context, setState) {
          update = setState;
          return ScrollConfiguration(
            behavior: _TaggedBehavior(behavior),
            child: SizedBox(
              width: 300,
              height: 200,
              child: TestTranscript(
                scrollController: controller,
                itemCount: count,
              ),
            ),
          );
        },
      ),
    );
    await tester.pump();
    final first = controller.position;

    update(() {
      behavior = 1;
      count = 40;
    });
    await tester.pump();
    await tester.pump();
    expect(controller.position, isNot(same(first)));
    expect(controller.offset, _atEndOf(controller));
  });

  testWidgets('turning following off leaves the reader position stable', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    var count = 24;
    late StateSetter update;
    await pumpAgent(
      tester,
      StatefulBuilder(
        builder: (context, setState) {
          update = setState;
          return SizedBox(
            width: 300,
            height: 120,
            child: TestTranscript(
              scrollController: controller,
              followOutput: false,
              itemCount: count,
            ),
          );
        },
      ),
    );
    controller.jumpTo(60);
    final offset = controller.offset;

    update(() => count += 6);
    await tester.pump();
    await tester.pump();

    expect(controller.offset, closeTo(offset, 0.5));
  });

  testWidgets('removing an external controller installs an owned controller', (
    tester,
  ) async {
    final external = ScrollController();
    addTearDown(external.dispose);
    var useExternal = true;
    late StateSetter update;
    await pumpAgent(
      tester,
      StatefulBuilder(
        builder: (context, setState) {
          update = setState;
          return SizedBox(
            width: 300,
            height: 120,
            child: TestTranscript(
              scrollController: useExternal ? external : null,
              itemCount: 20,
            ),
          );
        },
      ),
    );
    final first = tester.widget<ListView>(find.byType(ListView)).controller;
    expect(first, same(external));

    update(() => useExternal = false);
    await tester.pump();
    final owned = tester.widget<ListView>(find.byType(ListView)).controller;

    expect(owned, isNot(same(external)));
    expect(owned!.hasClients, isTrue);
    expect(external.hasClients, isFalse);
  });

  testWidgets('a replaced live edge decides from then on', (tester) async {
    final first = AgentLiveEdgeController();
    final second = AgentLiveEdgeController(enabled: false);
    addTearDown(first.dispose);
    addTearDown(second.dispose);
    final controller = ScrollController();
    addTearDown(controller.dispose);
    var liveEdge = first;
    var count = 24;
    late StateSetter update;
    await pumpAgent(
      tester,
      StatefulBuilder(
        builder: (context, setState) {
          update = setState;
          return SizedBox(
            width: 300,
            height: 120,
            child: AgentLiveEdge(
              controller: liveEdge,
              scrollController: controller,
              builder: (context, scrollController, physics) => ListView.builder(
                controller: scrollController,
                physics: physics,
                itemCount: count,
                itemBuilder: (context, index) =>
                    SizedBox(height: 24, child: Text('Line $index')),
              ),
            ),
          );
        },
      ),
    );
    await tester.pump();
    final end = controller.offset;
    expect(end, _atEndOf(controller));

    update(() => liveEdge = second);
    await tester.pump();
    update(() => count += 6);
    await tester.pump();
    await tester.pump();
    expect(
      controller.offset,
      closeTo(end, 0.5),
      reason: 'The disabled replacement, not the first edge, decides.',
    );
  });

  testWidgets('a non-lazy ledger follows growth and releases on a drag', (
    tester,
  ) async {
    final key = GlobalKey<_GrowingLedgerState>();
    await pumpAgent(tester, _GrowingLedger(key: key));
    await tester.pump();
    final controller = tester
        .widget<SingleChildScrollView>(find.byType(SingleChildScrollView))
        .controller!;
    expect(controller.offset, _atEndOf(controller));

    key.currentState!.grow();
    await tester.pump();
    await tester.pump();
    expect(controller.offset, _atEndOf(controller));

    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, 70));
    await tester.pump();
    expect(key.currentState!.changes, contains(false));
    final readingOffset = controller.offset;
    key.currentState!.grow();
    await tester.pump();
    await tester.pump();
    expect(controller.offset, closeTo(readingOffset, 0.5));
  });

  group('holds', () {
    testWidgets('a hold keeps the content still and its end catches up', (
      tester,
    ) async {
      final liveEdge = AgentLiveEdgeController();
      addTearDown(liveEdge.dispose);
      final (key, controller) = await _pumpGrowing(tester, liveEdge: liveEdge);
      final end = controller.offset;

      liveEdge.hold();
      expect(liveEdge.holding, isTrue);
      expect(liveEdge.keepsEnd, isFalse);
      await _growAndSettle(key, tester);
      expect(controller.offset, closeTo(end, 0.5));
      expect(liveEdge.following, isTrue, reason: 'A hold is not a release.');

      liveEdge.unhold();
      await tester.pump();
      expect(controller.offset, _atEndOf(controller));
      await _growAndSettle(key, tester);
      expect(controller.offset, _atEndOf(controller));
    });

    testWidgets('holds nest; the last one to end catches up', (tester) async {
      final liveEdge = AgentLiveEdgeController();
      addTearDown(liveEdge.dispose);
      final (key, controller) = await _pumpGrowing(tester, liveEdge: liveEdge);
      final end = controller.offset;

      liveEdge
        ..hold()
        ..hold();
      await _growAndSettle(key, tester);
      liveEdge.unhold();
      await tester.pump();
      expect(controller.offset, closeTo(end, 0.5));

      liveEdge.unhold();
      await tester.pump();
      expect(controller.offset, _atEndOf(controller));
    });

    testWidgets('a pointer held on the transcript holds the live edge', (
      tester,
    ) async {
      // Text selection and a press on a control both start with a pointer
      // down; output must not slide under it.
      final (key, controller) = await _pumpGrowing(tester);
      final end = controller.offset;
      final pointer = await tester.startGesture(
        tester.getCenter(find.byType(ListView)),
        kind: PointerDeviceKind.mouse,
      );
      await _growAndSettle(key, tester);
      expect(controller.offset, closeTo(end, 0.5));

      await pointer.up();
      await tester.pump();
      expect(controller.offset, _atEndOf(controller));
      expect(key.currentState!.changes, isEmpty);
    });

    testWidgets('a held pointer that drags back releases instead', (
      tester,
    ) async {
      final (key, controller) = await _pumpGrowing(tester);
      final pointer = await tester.startGesture(
        tester.getCenter(find.byType(ListView)),
      );
      await pointer.moveBy(const Offset(0, 40));
      await pointer.moveBy(const Offset(0, 80));
      await pointer.up();
      await tester.pumpAndSettle();
      expect(key.currentState!.changes, [false]);
      final reading = controller.offset;

      await _growAndSettle(key, tester);
      expect(controller.offset, closeTo(reading, 0.5));
    });
  });

  group('content that shrinks', () {
    testWidgets('re-attaches a reader near the end', (tester) async {
      final (key, controller) = await _pumpGrowing(tester, initialCount: 30);
      controller.jumpTo(controller.position.maxScrollExtent - 60);
      await tester.pump();
      expect(key.currentState!.changes, [false]);

      // A collapsed block takes 48px from below the reader, who is now
      // within the follow threshold of the end.
      key.currentState!.shrink(2);
      await tester.pump();
      await tester.pump();
      expect(key.currentState!.changes, [false, true]);

      await _growAndSettle(key, tester);
      expect(controller.offset, _atEndOf(controller));
    });

    testWidgets('leaves a reader far from the end where they are', (
      tester,
    ) async {
      final (key, controller) = await _pumpGrowing(tester, initialCount: 30);
      controller.jumpTo(100);
      await tester.pump();

      key.currentState!.shrink(2);
      await tester.pump();
      await tester.pump();
      expect(key.currentState!.changes, [false]);
      expect(controller.offset, 100);
    });
  });

  testWidgets('release and resume are the reader actions, for a host', (
    tester,
  ) async {
    final liveEdge = AgentLiveEdgeController();
    addTearDown(liveEdge.dispose);
    final (key, controller) = await _pumpGrowing(tester, liveEdge: liveEdge);
    final end = controller.offset;

    liveEdge.release();
    expect(liveEdge.following, isFalse);
    await _growAndSettle(key, tester);
    expect(controller.offset, closeTo(end, 0.5));

    liveEdge.resume();
    await tester.pump();
    expect(liveEdge.following, isTrue);
    expect(controller.offset, _atEndOf(controller));
  });
}

/// A bounded, non-lazy ledger (the plan and activity shape) whose rows grow.
class _GrowingLedger extends StatefulWidget {
  const _GrowingLedger({super.key});

  @override
  State<_GrowingLedger> createState() => _GrowingLedgerState();
}

class _GrowingLedgerState extends State<_GrowingLedger> {
  final _liveEdge = AgentLiveEdgeController();
  var count = 6;
  final changes = <bool>[];
  late bool _following;

  @override
  void initState() {
    super.initState();
    _following = _liveEdge.following;
    _liveEdge.addListener(() {
      if (_liveEdge.following == _following) return;
      _following = _liveEdge.following;
      changes.add(_following);
    });
  }

  void grow() => setState(() => count += 3);

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 300,
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 90),
      child: AgentLiveEdge(
        controller: _liveEdge,
        builder: (context, scrollController, physics) => SingleChildScrollView(
          controller: scrollController,
          physics: physics,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var index = 0; index < count; index++)
                SizedBox(height: 30, child: Text('Row $index')),
            ],
          ),
        ),
      ),
    ),
  );

  @override
  void dispose() {
    _liveEdge.dispose();
    super.dispose();
  }
}

class _TaggedBehavior extends ScrollBehavior {
  const _TaggedBehavior(this.tag);

  final int tag;

  @override
  bool shouldNotify(_TaggedBehavior oldDelegate) => tag != oldDelegate.tag;
}
