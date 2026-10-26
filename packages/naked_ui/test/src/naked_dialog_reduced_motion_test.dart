import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';

import '../helpers/reduced_motion.dart';

const _contentKey = Key('dialog-content');
const _fadeKey = Key('dialog-fade');

class _Host {
  _Host(this.reducedMotion);

  final ReducedMotionSwitch reducedMotion;
  late BuildContext context;

  Future<void> open({
    Duration transitionDuration = const Duration(milliseconds: 400),
  }) => showNakedDialog<void>(
    context: context,
    barrierColor: Colors.black54,
    transitionDuration: transitionDuration,
    transitionBuilder: _fade,
    builder: (_) => const NakedDialog(
      semanticLabel: 'Confirm',
      child: SizedBox(key: _contentKey, width: 200, height: 100),
    ),
  );

  void pop() => Navigator.of(context).pop();
}

Widget _fade(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) => FadeTransition(key: _fadeKey, opacity: animation, child: child);

Future<_Host> _pumpHost(WidgetTester tester) async {
  final host = _Host(ReducedMotionSwitch(tester));
  await tester.pumpWidget(
    MaterialApp(
      builder: (context, child) => host.reducedMotion.wrap(child!),
      home: Builder(
        builder: (context) {
          host.context = context;
          return const SizedBox.shrink();
        },
      ),
    ),
  );
  return host;
}

double _opacity(WidgetTester tester) =>
    tester.widget<FadeTransition>(find.byKey(_fadeKey)).opacity.value;

void main() {
  group('showNakedDialog reduced motion', () {
    testWidgets('fades over the transition duration by default', (
      tester,
    ) async {
      final host = await _pumpHost(tester);

      unawaited(host.open());
      await tester.pump();
      expect(_opacity(tester), 0);
      await tester.pump(const Duration(milliseconds: 200));
      expect(_opacity(tester), closeTo(0.5, 0.01));
      await tester.pumpAndSettle();
      expect(_opacity(tester), 1);

      host.pop();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(_opacity(tester), closeTo(0.5, 0.01));
      await tester.pumpAndSettle();
      expect(find.byKey(_contentKey), findsNothing);
    });

    for (final request in ReducedMotionRequest.values) {
      group('with ${request.label}', () {
        testWidgets('opens and closes at once', (tester) async {
          final host = await _pumpHost(tester);
          host.reducedMotion.set(request, on: true);
          await tester.pump();

          unawaited(host.open());
          await tester.pump();
          expect(find.byKey(_contentKey), findsOneWidget);
          expect(_opacity(tester), 1);

          host.pop();
          await tester.pump();
          expect(find.byKey(_contentKey), findsNothing);
        });

        testWidgets('ignores an explicit transition duration', (tester) async {
          final host = await _pumpHost(tester);
          host.reducedMotion.set(request, on: true);
          await tester.pump();

          unawaited(host.open(transitionDuration: const Duration(seconds: 2)));
          await tester.pump();
          expect(_opacity(tester), 1);

          host.pop();
          await tester.pump();
          expect(find.byKey(_contentKey), findsNothing);
        });

        testWidgets('closes at once when requested while open', (tester) async {
          final host = await _pumpHost(tester);
          unawaited(host.open());
          await tester.pumpAndSettle();

          host.reducedMotion.set(request, on: true);
          await tester.pump();
          host.pop();
          await tester.pump();

          expect(find.byKey(_contentKey), findsNothing);
        });

        testWidgets('closes with the transition once withdrawn while open', (
          tester,
        ) async {
          final host = await _pumpHost(tester);
          host.reducedMotion.set(request, on: true);
          await tester.pump();
          unawaited(host.open());
          await tester.pump();
          expect(_opacity(tester), 1);

          host.reducedMotion.set(request, on: false);
          await tester.pump();
          host.pop();
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 200));
          expect(find.byKey(_contentKey), findsOneWidget);
          expect(_opacity(tester), closeTo(0.5, 0.01));
          await tester.pumpAndSettle();
          expect(find.byKey(_contentKey), findsNothing);
        });
      });
    }

    testWidgets('keeps layout and semantics', (tester) async {
      final handle = tester.ensureSemantics();
      final host = await _pumpHost(tester);

      ({Rect rect, String label, bool scopesRoute, bool namesRoute})
      describe() {
        final data = tester
            .getSemantics(find.bySemanticsLabel('Confirm'))
            .getSemanticsData();
        return (
          rect: tester.getRect(find.byKey(_contentKey)),
          label: data.label,
          scopesRoute: data.flagsCollection.scopesRoute,
          namesRoute: data.flagsCollection.namesRoute,
        );
      }

      try {
        unawaited(host.open());
        await tester.pumpAndSettle();
        final animated = describe();
        host.pop();
        await tester.pumpAndSettle();

        host.reducedMotion.set(
          ReducedMotionRequest.platformReduceMotion,
          on: true,
        );
        await tester.pump();
        unawaited(host.open());
        await tester.pump();

        expect(describe(), animated);
        expect(animated.scopesRoute, isTrue);
        expect(animated.namesRoute, isTrue);
      } finally {
        handle.dispose();
      }
    });
  });

  group('showNakedAlertDialog reduced motion', () {
    for (final request in ReducedMotionRequest.values) {
      testWidgets('opens and closes at once with ${request.label}', (
        tester,
      ) async {
        final host = await _pumpHost(tester);
        host.reducedMotion.set(request, on: true);
        await tester.pump();

        unawaited(
          showNakedAlertDialog<void>(
            context: host.context,
            barrierColor: Colors.black54,
            semanticLabel: 'Delete file',
            transitionDuration: const Duration(seconds: 2),
            transitionBuilder: _fade,
            builder: (_) => const SizedBox(key: _contentKey, width: 200),
          ),
        );
        await tester.pump();
        expect(find.byKey(_contentKey), findsOneWidget);
        expect(_opacity(tester), 1);

        host.pop();
        await tester.pump();
        expect(find.byKey(_contentKey), findsNothing);
      });
    }
  });
}
