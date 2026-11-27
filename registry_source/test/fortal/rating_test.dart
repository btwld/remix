import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart' show NakedRadio;
import 'package:registry_source/fortal.dart';
import 'package:remix/remix.dart';
// ignore: invalid_use_of_internal_member
import 'package:remix/src/rendering/remix_box_effects.dart';

import '../helpers/test_helpers.dart';

Finder _inStar(int star, Finder matching) => find
    .descendant(
      of: find.byType(NakedRadio<int>).at(star - 1),
      matching: matching,
    )
    .first;

RatingStarSpec _star(WidgetTester tester, int star) => tester
    .widget<StyleSpecBuilder<RatingStarSpec>>(
      _inStar(star, find.byType(StyleSpecBuilder<RatingStarSpec>)),
    )
    .styleSpec
    .spec;

// ignore: invalid_use_of_internal_member
RemixBoxAdapter _cell(WidgetTester tester, int star) =>
    // ignore: invalid_use_of_internal_member
    tester.widget(_inStar(star, find.byType(RemixBoxAdapter)));

class _Host extends StatefulWidget {
  const _Host({this.initial, this.enabled = true, this.size = .size2});

  final int? initial;
  final bool enabled;
  final FortalRatingSize size;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  late int? value = widget.initial;

  @override
  Widget build(BuildContext context) => FortalRating(
    label: 'Rate this',
    size: widget.size,
    value: value,
    onChanged: widget.enabled ? (next) => setState(() => value = next) : null,
  );
}

void main() {
  for (final dark in [false, true]) {
    final mode = dark ? FortalThemeMode.dark : FortalThemeMode.light;
    final name = dark ? 'dark' : 'light';

    testWidgets('$name: an unrated row draws outlined stars', (tester) async {
      await tester.pumpRemixApp(const _Host(), mode: mode, accent: .orla);
      await tester.pumpAndSettle();
      final context = tester.element(find.byType(RemixRating));

      final star = _star(tester, 1);
      expect(star.outlineColor, FortalTokens.controlBorder.resolve(context));
      expect(star.emptyColor, isNull);
      expect(star.fillColor, FortalTokens.warning.resolve(context));
      expect(
        star.keptColor,
        FortalTokens.warning.resolve(context).withValues(alpha: .3),
      );
      expect(star.glyphScale, 1);
      expect(find.text('Not rated'), findsOneWidget);
    });

    testWidgets('$name: a rated row softens empty stars into a quiet solid', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        const _Host(initial: 3),
        mode: mode,
        accent: .orla,
      );
      await tester.pumpAndSettle();
      final context = tester.element(find.byType(RemixRating));
      final gray7 = FortalTokens.gray7.resolve(context);

      final filled = _star(tester, 3);
      expect(filled.glyphScale, 1);
      final empty = _star(tester, 4);
      expect(empty.emptyColor, gray7);
      expect(empty.outlineColor, gray7);
      expect(empty.glyphScale, .9);
    });
  }

  testWidgets('sizes set the cell, glyph and stroke', (tester) async {
    const expected = {
      FortalRatingSize.size1: (28.0, 18.0, 1.3125),
      FortalRatingSize.size2: (36.0, 24.0, 1.75),
      FortalRatingSize.size3: (44.0, 30.0, 2.1875),
    };
    for (final MapEntry(key: size, value: (cell, glyph, stroke))
        in expected.entries) {
      await tester.pumpRemixApp(_Host(size: size));
      await tester.pumpAndSettle();

      final cellSize = tester.getSize(_inStar(1, find.byType(RemixBoxAdapter)));
      // The star's spring settles within a hair of its target.
      expect(cellSize.width, moreOrLessEquals(cell, epsilon: .01));
      expect(cellSize.height, moreOrLessEquals(cell, epsilon: .01));
      final star = _star(tester, 1);
      expect(star.glyphSize, glyph);
      expect(star.strokeWidth, stroke);
      expect(
        _cell(tester, 1).styleSpec.spec.decoration,
        isA<BoxDecoration>().having(
          (decoration) => decoration.borderRadius,
          'borderRadius',
          BorderRadius.circular(8),
        ),
      );
    }
  });

  testWidgets('pressing a star lifts it to 86%', (tester) async {
    await tester.pumpRemixApp(const _Host());
    await tester.pumpAndSettle();

    final press = await tester.startGesture(
      tester.getCenter(find.byType(NakedRadio<int>).at(1)),
    );
    await tester.pumpAndSettle();
    expect(_star(tester, 2).glyphScale, .86);
    await press.up();
    await tester.pumpAndSettle();
    expect(_star(tester, 2).glyphScale, 1);
  });

  testWidgets(
    'keyboard focus rings the focused star',
    (tester) async {
      await tester.pumpRemixApp(const _Host(initial: 2));
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();

      final focused = FocusManager.instance.primaryFocus;
      final index = [
        for (var star = 1; star <= 5; star++)
          Focus.of(
            tester.element(_inStar(star, find.byType(RemixBoxAdapter))),
          ).hasPrimaryFocus,
      ].indexOf(true);
      expect(focused, isNotNull);
      expect(index, isNonNegative);
      final ring = _cell(tester, index + 1).containerEffects?.outline;
      expect(ring?.style, BorderStyle.solid);
      expect(ring?.width, moreOrLessEquals(2, epsilon: .01));
    },
    
  );

  testWidgets(
    'hover previews in the warning tone',
    (tester) async {
      await tester.pumpRemixApp(const _Host(initial: 1));
      await tester.pumpAndSettle();
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(mouse.removePointer);
      await mouse.addPointer(location: Offset.zero);
      await mouse.moveTo(tester.getCenter(find.byType(NakedRadio<int>).at(3)));
      await tester.pumpAndSettle();

      expect(find.text('Great'), findsOneWidget);
      expect(_star(tester, 4).glyphScale, 1);
      expect(_star(tester, 5).glyphScale, .9);
    },
    variant: TargetPlatformVariant.only(TargetPlatform.macOS),
  );

  testWidgets('a disabled rating fades its stars and value to half', (
    tester,
  ) async {
    await tester.pumpRemixApp(const _Host(initial: 3, enabled: false));
    await tester.pumpAndSettle();

    final opacities = tester
        .widgetList<Opacity>(
          find.descendant(
            of: find.byType(RemixRating),
            matching: find.byType(Opacity),
          ),
        )
        .map((opacity) => opacity.opacity)
        .toList();
    expect(opacities, [.5, .5]);
  });
}
