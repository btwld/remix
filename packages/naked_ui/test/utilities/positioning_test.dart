import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/src/utilities/positioning.dart';

void main() {
  group('OverlayPositionConfig', () {
    test('uses Radix-shaped defaults', () {
      const config = OverlayPositionConfig();

      expect(config.side, OverlaySide.bottom);
      expect(config.alignment, OverlayAlignment.start);
      expect(config.sideOffset, 0);
      expect(config.alignmentOffset, 0);
      expect(config.collisionPadding, EdgeInsets.zero);
      expect(config.avoidCollisions, isTrue);
    });

    test('supports all placement controls and value equality', () {
      const first = OverlayPositionConfig(
        side: OverlaySide.left,
        alignment: OverlayAlignment.end,
        sideOffset: 8,
        alignmentOffset: -4,
        collisionPadding: EdgeInsets.all(12),
        avoidCollisions: false,
      );
      const second = OverlayPositionConfig(
        side: OverlaySide.left,
        alignment: OverlayAlignment.end,
        sideOffset: 8,
        alignmentOffset: -4,
        collisionPadding: EdgeInsets.all(12),
        avoidCollisions: false,
      );

      expect(first, second);
      expect(first.hashCode, second.hashCode);
    });
  });

  group('resolveOverlayPlacement', () {
    const anchor = Rect.fromLTWH(100, 100, 50, 30);
    const overlaySize = Size(80, 40);
    const boundsSize = Size(400, 300);

    test('places bottom-start in LTR', () {
      final placement = resolveOverlayPlacement(
        targetRect: anchor,
        overlaySize: overlaySize,
        boundsSize: boundsSize,
        positioning: const OverlayPositionConfig(),
        textDirection: TextDirection.ltr,
      );

      expect(placement.side, OverlaySide.bottom);
      expect(placement.alignment, OverlayAlignment.start);
      expect(placement.offset, const Offset(100, 130));
      expect(placement.wasFlipped, isFalse);
      expect(placement.wasShifted, isFalse);
    });

    test('resolves logical start and alignment offset in RTL', () {
      final placement = resolveOverlayPlacement(
        targetRect: anchor,
        overlaySize: overlaySize,
        boundsSize: boundsSize,
        positioning: const OverlayPositionConfig(alignmentOffset: 6),
        textDirection: TextDirection.rtl,
      );

      expect(placement.offset, const Offset(64, 130));
    });

    test('applies side and alignment offsets independently', () {
      final placement = resolveOverlayPlacement(
        targetRect: anchor,
        overlaySize: overlaySize,
        boundsSize: boundsSize,
        positioning: const OverlayPositionConfig(
          side: OverlaySide.right,
          alignment: OverlayAlignment.center,
          sideOffset: 8,
          alignmentOffset: 5,
        ),
        textDirection: TextDirection.ltr,
      );

      expect(placement.offset, const Offset(158, 100));
    });

    test('allows signed side offsets for intentional overlap', () {
      final placement = resolveOverlayPlacement(
        targetRect: anchor,
        overlaySize: overlaySize,
        boundsSize: boundsSize,
        positioning: const OverlayPositionConfig(sideOffset: -10),
        textDirection: TextDirection.ltr,
      );

      expect(placement.offset, const Offset(100, 120));
    });

    test('flips to the opposite side when it has more room', () {
      final placement = resolveOverlayPlacement(
        targetRect: const Rect.fromLTWH(100, 270, 50, 20),
        overlaySize: const Size(80, 60),
        boundsSize: boundsSize,
        positioning: const OverlayPositionConfig(
          sideOffset: 4,
          collisionPadding: EdgeInsets.all(8),
        ),
        textDirection: TextDirection.ltr,
      );

      expect(placement.side, OverlaySide.top);
      expect(placement.offset, const Offset(100, 206));
      expect(placement.wasFlipped, isTrue);
      expect(placement.wasShifted, isFalse);
    });

    test('shifts the cross axis inside collision padding', () {
      final placement = resolveOverlayPlacement(
        targetRect: const Rect.fromLTWH(380, 100, 20, 20),
        overlaySize: const Size(100, 40),
        boundsSize: boundsSize,
        positioning: const OverlayPositionConfig(
          collisionPadding: EdgeInsets.all(12),
        ),
        textDirection: TextDirection.ltr,
      );

      expect(placement.side, OverlaySide.bottom);
      expect(placement.offset, const Offset(288, 120));
      expect(placement.wasShifted, isTrue);
    });

    test(
      'leaves overflowing placement untouched when collisions are disabled',
      () {
        final placement = resolveOverlayPlacement(
          targetRect: const Rect.fromLTWH(390, 280, 10, 10),
          overlaySize: const Size(100, 40),
          boundsSize: boundsSize,
          positioning: const OverlayPositionConfig(avoidCollisions: false),
          textDirection: TextDirection.ltr,
        );

        expect(placement.side, OverlaySide.bottom);
        expect(placement.offset, const Offset(390, 290));
        expect(placement.wasFlipped, isFalse);
        expect(placement.wasShifted, isFalse);
      },
    );

    test('pins an oversized overlay to the padded origin', () {
      final placement = resolveOverlayPlacement(
        targetRect: anchor,
        overlaySize: const Size(500, 400),
        boundsSize: boundsSize,
        positioning: const OverlayPositionConfig(
          collisionPadding: EdgeInsets.all(8),
        ),
        textDirection: TextDirection.ltr,
      );

      expect(placement.offset, const Offset(8, 8));
      expect(placement.wasShifted, isTrue);
    });
  });

  group('OverlayPositioner', () {
    const childKey = Key('overlay-child');

    Widget buildHarness({
      Rect targetRect = const Rect.fromLTWH(100, 100, 50, 30),
      OverlayPositionConfig positioning = const OverlayPositionConfig(),
      bool constrainToAvailableHeight = false,
      TextDirection textDirection = TextDirection.ltr,
      ValueChanged<OverlayPlacement>? onPlacementChanged,
      Widget? child,
    }) {
      return MaterialApp(
        home: Directionality(
          textDirection: textDirection,
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 400,
              height: 300,
              child: OverlayPositioner(
                targetRect: targetRect,
                positioning: positioning,
                constrainToAvailableHeight: constrainToAvailableHeight,
                onPlacementChanged: onPlacementChanged,
                child:
                    child ??
                    Builder(
                      builder: (context) => SizedBox(
                        key: childKey,
                        width: 80,
                        height: 40,
                        child: Text(OverlayPlacement.of(context).side.name),
                      ),
                    ),
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('positions the child and exposes the resolved placement', (
      tester,
    ) async {
      OverlayPlacement? reported;
      await tester.pumpWidget(
        buildHarness(onPlacementChanged: (value) => reported = value),
      );
      await tester.pump();

      expect(tester.getTopLeft(find.byKey(childKey)), const Offset(100, 130));
      expect(find.text('bottom'), findsOneWidget);
      expect(reported?.side, OverlaySide.bottom);
    });

    testWidgets('reports a flipped placement for arrow positioning', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildHarness(
          targetRect: const Rect.fromLTWH(100, 270, 50, 20),
          positioning: const OverlayPositionConfig(
            sideOffset: 4,
            collisionPadding: EdgeInsets.all(8),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('top'), findsOneWidget);
      expect(tester.getTopLeft(find.byKey(childKey)), const Offset(100, 226));
    });

    testWidgets('reports an initial placement even when its offset is zero', (
      tester,
    ) async {
      OverlayPlacement? reported;
      await tester.pumpWidget(
        buildHarness(
          targetRect: const Rect.fromLTWH(0, -40, 80, 40),
          onPlacementChanged: (value) => reported = value,
        ),
      );
      await tester.pump();

      expect(tester.getTopLeft(find.byKey(childKey)), Offset.zero);
      expect(reported?.offset, Offset.zero);
    });

    testWidgets('relayouts when the anchor changes', (tester) async {
      await tester.pumpWidget(buildHarness());
      final initial = tester.getTopLeft(find.byKey(childKey));

      await tester.pumpWidget(
        buildHarness(targetRect: const Rect.fromLTWH(200, 120, 50, 30)),
      );

      expect(tester.getTopLeft(find.byKey(childKey)), isNot(initial));
    });

    testWidgets('loosens child constraints', (tester) async {
      BoxConstraints? childConstraints;
      await tester.pumpWidget(
        buildHarness(
          child: LayoutBuilder(
            builder: (context, constraints) {
              childConstraints = constraints;
              return const SizedBox(width: 80, height: 40);
            },
          ),
        ),
      );

      expect(childConstraints?.minWidth, 0);
      expect(childConstraints?.minHeight, 0);
      expect(childConstraints?.maxWidth, 400);
      expect(childConstraints?.maxHeight, 300);
    });

    group('constrainToAvailableHeight', () {
      // Taller than the 300 high overlay, like a long list that scrolls.
      Widget scrollingPanel({double itemHeight = 40, int items = 20}) =>
          SingleChildScrollView(
            key: childKey,
            child: Column(
              children: [
                for (var i = 0; i < items; i++)
                  SizedBox(width: 80, height: itemHeight),
              ],
            ),
          );

      Future<void> pumpPanel(
        WidgetTester tester, {
        required Rect targetRect,
        OverlayPositionConfig positioning = const OverlayPositionConfig(),
        TextDirection textDirection = TextDirection.ltr,
        Widget? panel,
        ValueChanged<OverlayPlacement>? onPlacementChanged,
      }) async {
        await tester.pumpWidget(
          buildHarness(
            targetRect: targetRect,
            positioning: positioning,
            constrainToAvailableHeight: true,
            textDirection: textDirection,
            onPlacementChanged: onPlacementChanged,
            child: panel ?? scrollingPanel(),
          ),
        );
        await tester.pump();
      }

      Rect panelRect(WidgetTester tester) =>
          tester.getRect(find.byKey(childKey));

      testWidgets('a full-height anchor keeps a constrained panel usable', (
        tester,
      ) async {
        await pumpPanel(
          tester,
          targetRect: const Rect.fromLTWH(100, 0, 50, 300),
          positioning: const OverlayPositionConfig(sideOffset: 6),
        );
        final rect = panelRect(tester);
        expect(rect.height, 300);
        expect(rect.top, 0);
        expect(rect.bottom, 300);
        expect(tester.takeException(), isNull);
      });

      testWidgets('follows the option as it is turned on and off', (
        tester,
      ) async {
        double panelHeight() => tester.getSize(find.byKey(childKey)).height;
        Future<void> pump({required bool constrain}) async {
          await tester.pumpWidget(
            buildHarness(
              targetRect: const Rect.fromLTWH(100, 100, 50, 30),
              positioning: const OverlayPositionConfig(sideOffset: 6),
              constrainToAvailableHeight: constrain,
              child: scrollingPanel(),
            ),
          );
          await tester.pump();
        }

        await pump(constrain: false);
        expect(panelHeight(), 300);
        await pump(constrain: true);
        expect(panelHeight(), 164);
        await pump(constrain: false);
        expect(panelHeight(), 300);
      });

      testWidgets('fits a tall panel between the anchor and the edge', (
        tester,
      ) async {
        const target = Rect.fromLTWH(100, 100, 50, 30);
        await pumpPanel(
          tester,
          targetRect: target,
          positioning: const OverlayPositionConfig(sideOffset: 6),
        );

        expect(panelRect(tester), const Rect.fromLTWH(100, 136, 80, 164));
        expect(panelRect(tester).overlaps(target), isFalse);
      });

      testWidgets('flips above and fits when there is more room above', (
        tester,
      ) async {
        OverlayPlacement? placement;
        const target = Rect.fromLTWH(100, 200, 50, 30);
        await pumpPanel(
          tester,
          targetRect: target,
          positioning: const OverlayPositionConfig(sideOffset: 6),
          onPlacementChanged: (value) => placement = value,
        );

        expect(panelRect(tester), const Rect.fromLTWH(100, 0, 80, 194));
        expect(placement?.side, OverlaySide.top);
        expect(placement?.wasFlipped, isTrue);
      });

      testWidgets('stays on a preferred top side with more room', (
        tester,
      ) async {
        OverlayPlacement? placement;
        await pumpPanel(
          tester,
          targetRect: const Rect.fromLTWH(100, 200, 50, 30),
          positioning: const OverlayPositionConfig(
            side: OverlaySide.top,
            sideOffset: 6,
          ),
          onPlacementChanged: (value) => placement = value,
        );

        expect(panelRect(tester), const Rect.fromLTWH(100, 0, 80, 194));
        expect(placement?.wasFlipped, isFalse);
      });

      testWidgets('keeps the collision padding clear', (tester) async {
        await pumpPanel(
          tester,
          targetRect: const Rect.fromLTWH(100, 100, 50, 30),
          positioning: const OverlayPositionConfig(
            sideOffset: 4,
            collisionPadding: EdgeInsets.fromLTRB(0, 10, 0, 12),
          ),
        );

        expect(panelRect(tester), const Rect.fromLTWH(100, 134, 80, 154));
      });

      testWidgets('leaves a panel that fits unchanged', (tester) async {
        await pumpPanel(
          tester,
          targetRect: const Rect.fromLTWH(100, 100, 50, 30),
          panel: SizedBox(key: childKey, width: 80, height: 40),
        );

        expect(panelRect(tester), const Rect.fromLTWH(100, 130, 80, 40));
      });

      testWidgets('does not shrink a panel that fits on the other side', (
        tester,
      ) async {
        await pumpPanel(
          tester,
          targetRect: const Rect.fromLTWH(100, 200, 50, 30),
          panel: SizedBox(key: childKey, width: 80, height: 120),
        );

        expect(panelRect(tester), const Rect.fromLTWH(100, 80, 80, 120));
      });

      testWidgets(
        'measures the preferred side when collisions are not avoided',
        (tester) async {
          OverlayPlacement? placement;
          await pumpPanel(
            tester,
            targetRect: const Rect.fromLTWH(100, 240, 50, 30),
            positioning: const OverlayPositionConfig(avoidCollisions: false),
            onPlacementChanged: (value) => placement = value,
          );

          expect(panelRect(tester), const Rect.fromLTWH(100, 270, 80, 30));
          expect(placement?.side, OverlaySide.bottom);
        },
      );

      testWidgets('never lays the child out with a negative height', (
        tester,
      ) async {
        BoxConstraints? constraints;
        await pumpPanel(
          tester,
          targetRect: const Rect.fromLTWH(100, 290, 50, 20),
          positioning: const OverlayPositionConfig(
            sideOffset: 5,
            avoidCollisions: false,
          ),
          panel: LayoutBuilder(
            builder: (context, value) {
              constraints = value;
              return const SizedBox(width: 80, height: 40);
            },
          ),
        );

        expect(constraints?.maxHeight, 0);
      });

      testWidgets('does not cap a placement beside the anchor', (tester) async {
        BoxConstraints? constraints;
        await pumpPanel(
          tester,
          targetRect: const Rect.fromLTWH(100, 100, 50, 30),
          positioning: const OverlayPositionConfig(side: OverlaySide.right),
          panel: LayoutBuilder(
            builder: (context, value) {
              constraints = value;
              return const SizedBox(width: 80, height: 40);
            },
          ),
        );

        expect(constraints?.maxHeight, 300);
      });

      testWidgets('fits the same height in right-to-left layouts', (
        tester,
      ) async {
        await pumpPanel(
          tester,
          targetRect: const Rect.fromLTWH(100, 100, 50, 30),
          positioning: const OverlayPositionConfig(sideOffset: 6),
          textDirection: TextDirection.rtl,
        );

        expect(panelRect(tester), const Rect.fromLTWH(70, 136, 80, 164));
      });
    });
  });

  test('clampOverlayPosition pins oversized content to the origin', () {
    expect(
      clampOverlayPosition(
        const Offset(40, 30),
        overlaySize: const Size(500, 400),
        boundsSize: const Size(400, 300),
      ),
      Offset.zero,
    );
  });
}
