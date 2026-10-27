import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/heroui/components/slider.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

class _Host extends StatefulWidget {
  const _Host({
    this.enabled = true,
    this.style = const SliderStyler.create(),
    this.onChanged,
  });

  final bool enabled;
  final SliderStyler style;
  final ValueChanged<double>? onChanged;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  /// The `slider-mid` fixture sits at 50%.
  double value = .5;

  @override
  Widget build(BuildContext context) => SizedBox(
    // The upstream fixture's column.
    width: heroUiCase('slider-mid-root').size.width,
    child: HeroUiSlider(
      value: value,
      enabled: widget.enabled,
      style: widget.style,
      onChanged: (next) {
        setState(() => value = next);
        widget.onChanged?.call(next);
      },
    ),
  );
}

SliderSpec _spec(WidgetTester tester) => tester
    .widget<StyleSpecProvider<SliderSpec>>(
      find.byType(StyleSpecProvider<SliderSpec>),
    )
    .spec
    .spec;

BoxDecoration _thumb(SliderSpec spec) =>
    spec.thumb.spec.decoration! as BoxDecoration;

void main() {
  for (final mode in ['light', 'dark']) {
    testWidgets('the track, fill, and thumb follow slider.css in $mode', (
      tester,
    ) async {
      await tester.pumpHeroUi(const _Host(), mode: mode);
      await tester.pumpAndSettle();
      final spec = _spec(tester);
      final track = heroUiCase('slider-mid-track', mode: mode);
      final fill = heroUiCase('slider-mid-fill', mode: mode);
      final thumbCase = heroUiCase('slider-mid-thumb', mode: mode);
      final pill = heroUiCase('slider-mid-thumb-pill', mode: mode);

      // .slider__track: h-5, rounded-xl, bg-default; .slider__fill: bg-accent.
      expect(spec.trackWidth, track.size.height);
      expect(spec.rangeWidth, fill.size.height);
      expectCssColor(spec.trackColor, track.styles['backgroundColor']!);
      expectCssColor(spec.rangeColor, fill.styles['backgroundColor']!);
      for (final rail in [spec.track, spec.range]) {
        expect(
          (rail.spec.decoration as BoxDecoration).borderRadius,
          BorderRadius.circular(track.px('borderRadius')),
        );
      }

      // .slider__thumb: accent, 28x20, radius 12. Its ::after pill is
      // bg-accent-foreground, 24x16; the recipe draws it as the thumb's fill
      // inside a ring-width accent border.
      expect(spec.thumb.spec.constraints, BoxConstraints.tight(thumbCase.size));
      final thumb = _thumb(spec);
      expectCssColor(thumb.color!, pill.styles['backgroundColor']!);
      final rim = thumb.border! as Border;
      expect(rim.top.width, (thumbCase.size.height - pill.size.height) / 2);
      expect(rim.left.width, (thumbCase.size.width - pill.size.width) / 2);
      expectCssColor(rim.top.color, thumbCase.styles['backgroundColor']!);
      expect(
        thumb.borderRadius,
        BorderRadius.circular(thumbCase.px('borderRadius')),
      );
    });

    testWidgets('the thumb carries the field shadow, which dark lacks in '
        '$mode', (tester) async {
      await tester.pumpHeroUi(const _Host(), mode: mode);
      await tester.pumpAndSettle();
      // The pill's `shadow-field`, equal to --surface-shadow in this theme.
      expect(
        behindShadows(_spec(tester).thumbEffects),
        cssRemixShadows(
          heroUiCase('slider-mid-thumb-pill', mode: mode).styles['boxShadow'] ??
              '',
        ),
      );
    });

    testWidgets('the thumb shrinks to 90% while dragged in $mode', (
      tester,
    ) async {
      await tester.pumpHeroUi(const _Host(), mode: mode);
      await tester.pumpAndSettle();
      expect(_spec(tester).thumb.spec.transform, isNull);

      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(RemixSlider)),
      );
      await tester.pump(const Duration(milliseconds: 50));
      await gesture.moveBy(const Offset(40, 0));
      await tester.pump(const Duration(milliseconds: 400));
      // data-dragging scales the ::after pill to 0.9; the recipe scales the
      // whole thumb, which has no separate pill.
      final drag = heroUiCase(
        'slider-mid-drag-thumb-pill',
        mode: mode,
        state: true,
      );
      expect(
        _spec(tester).thumb.spec.transform!.entry(0, 0),
        closeTo(double.parse(drag.styles['scale']!), .001),
      );
      await gesture.up();
    });

    testWidgets('keyboard focus rings the thumb with the focus ring in $mode', (
      tester,
    ) async {
      await tester.pumpHeroUi(const _Host(), mode: mode);
      await tester.pumpAndSettle();
      await tester.focusWithTab();

      expect(FocusManager.instance.primaryFocus!.hasPrimaryFocus, isTrue);
      expect(
        FocusManager.instance.highlightMode,
        FocusHighlightMode.traditional,
      );
      // slider-mid-focus-thumb: a 2px background gap, then a 2px focus ring.
      expectFocusRing(
        _spec(tester).thumbFocusEffects,
        heroUiCase('slider-mid-focus-thumb', mode: mode, state: true),
      );
    });

    testWidgets('disabled dims the slider in $mode', (tester) async {
      await tester.pumpHeroUi(const _Host(enabled: false), mode: mode);
      await tester.pumpAndSettle();
      final opacity = tester.widget<Opacity>(
        find
            .descendant(
              of: find.byType(RemixSlider),
              matching: find.byType(Opacity),
            )
            .first,
      );
      expect(
        opacity.opacity,
        double.parse(
          heroUiCase('slider-disabled-root', mode: mode).styles['opacity']!,
        ),
      );
    });
  }

  testWidgets('RemixSlider reserves thumb height plus track thickness', (
    tester,
  ) async {
    await tester.pumpHeroUi(const _Host());
    await tester.pumpAndSettle();
    final thumb = heroUiCase('slider-bare-thumb').size.height;
    final track = heroUiCase('slider-bare-track').size.height;
    // This documents Remix's layout, not HeroUI's: a bare slider is 24 high
    // upstream (a 20 track and the label row's 4 gap), 44 with a label.
    expect(tester.getSize(find.byType(RemixSlider)).height, thumb + track);
    expect(
      tester.getSize(find.byType(RemixSlider)).width,
      heroUiCase('slider-bare-root').size.width,
    );
  });

  testWidgets('dragging the thumb reports values through Remix', (
    tester,
  ) async {
    final values = <double>[];
    await tester.pumpHeroUi(_Host(onChanged: values.add));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(RemixSlider), const Offset(100, 0));
    await tester.pumpAndSettle();
    expect(values, isNotEmpty);
    expect(values.last, greaterThan(.5));
  });

  testWidgets('a caller style wins over the recipe', (tester) async {
    await tester.pumpHeroUi(_Host(style: SliderStyler().thickness(8)));
    await tester.pumpAndSettle();
    expect(_spec(tester).trackWidth, 8);
  });
}
