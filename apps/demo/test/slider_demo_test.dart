import 'package:demo/components/slider.dart';
import 'package:demo/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

void main() {
  for (final dark in [false, true]) {
    testWidgets('${dark ? "dark" : "light"}: demo thumb states stay legible', (
      tester,
    ) async {
      Color? idleFace;
      BoxBorder? idleBorder;
      for (final states in <Set<WidgetState>>[
        {},
        {WidgetState.hovered},
        {WidgetState.pressed},
        {WidgetState.disabled},
      ]) {
        await tester.pumpWidget(
          MaterialApp(
            home: FortalTheme(
              mode: dark ? .dark : .light,
              child: WidgetStateProvider(
                states: states,
                child: Builder(
                  builder: (context) {
                    final spec = fortalSliderStyle().build(context).spec;
                    final face =
                        (spec.thumb.spec.decoration as BoxDecoration).color;
                    final border =
                        (spec.thumb.spec.decoration as BoxDecoration).border;
                    if (states.isEmpty) {
                      idleFace = face;
                      idleBorder = border;
                    }
                    // Thumbs keep one face and ring in every state; hover
                    // draws nothing and disabled fades the whole slider.
                    expect(border, idleBorder);
                    expect(face, idleFace);
                    expect(face, FortalTokens.controlThumb.resolve(context));
                    expect(
                      spec.thumbEffects?.outline.style ?? BorderStyle.none,
                      BorderStyle.none,
                    );
                    expect(spec.thumbFocusEffects!.outlineOffset, 0);
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ),
        );
      }
    });
  }

  testWidgets('demo sliders share a 40px row and aligned label blocks', (
    tester,
  ) async {
    final changes = <double>[];
    await tester.pumpWidget(
      MaterialApp(
        home: FortalTheme(
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 280,
                  child: Builder(builder: buildRangeSliderUseCase),
                ),
                SizedBox(
                  width: 280,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Single price'),
                      const Text(r'$80'),
                      FortalSlider(value: 80, max: 400, onChanged: changes.add),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    final range = tester.getRect(find.byType(RemixRangeSlider));
    final single = tester.getRect(find.byType(RemixSlider));
    expect(single.height, 40);
    expect(range.height, single.height);
    expect(
      tester.getTopLeft(find.text('Nightly price')).dy,
      tester.getTopLeft(find.text('Single price')).dy,
    );
    // The added height belongs to the gesture target, including its top edge.
    await tester.tapAt(single.topRight + const Offset(-1, 1));
    await tester.pump();
    expect(changes, [400]);
    expect(tester.takeException(), isNull);
  });
}
