import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:registry_source/fortal.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('Fortal button motion', () {
    testWidgets('FortalButton enters hover over 40ms and rests over 120ms', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        FortalButton.solid(label: 'Continue', onPressed: () {}),
      );

      await _expectHoverMotion(
        tester,
        target: find.byType(FortalButton),
        fill: () => _fill(
          _spec<ButtonSpec>(tester).container.spec.box?.spec.decoration,
        ),
      );
    });

    testWidgets(
      'FortalIconButton enters hover over 40ms and rests over 120ms',
      (tester) async {
        await tester.pumpRemixApp(
          FortalIconButton.solid(
            icon: Icons.add,
            semanticLabel: 'Add',
            onPressed: () {},
          ),
        );

        await _expectHoverMotion(
          tester,
          target: find.byType(FortalIconButton),
          fill: () =>
              _fill(_spec<IconButtonSpec>(tester).container.spec.decoration),
        );
      },
    );
  });
}

/// Hovers [target] and checks the solid fill between `accent9` and
/// `accent10` partway through each transition.
Future<void> _expectHoverMotion(
  WidgetTester tester, {
  required Finder target,
  required Color? Function() fill,
}) async {
  await tester.pumpAndSettle();
  final context = tester.element(target);
  final idle = MixScope.tokenOf(FortalTokens.accent9, context);
  final hovered = MixScope.tokenOf(FortalTokens.accent10, context);
  expect(fill(), idle);

  final pointer = await tester.createGesture(kind: PointerDeviceKind.mouse);
  addTearDown(pointer.removePointer);
  await pointer.addPointer(location: Offset.zero);
  await tester.pump();
  await pointer.moveTo(tester.getCenter(target));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 20));

  expect(fill(), isNot(anyOf(idle, hovered)));

  await tester.pump(const Duration(milliseconds: 30));
  expect(fill(), hovered);

  await pointer.moveTo(Offset.zero);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 60));

  expect(fill(), isNot(anyOf(idle, hovered)));

  await tester.pumpAndSettle();
  expect(fill(), idle);
}

S _spec<S extends Spec<S>>(WidgetTester tester) => tester
    .widget<StyleSpecProvider<S>>(
      find.byWidgetPredicate((widget) => widget is StyleSpecProvider<S>).first,
    )
    .spec
    .spec;

Color? _fill(Decoration? decoration) => (decoration as BoxDecoration?)?.color;
