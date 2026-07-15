import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_methods.dart';

void main() {
  group('RemixSliderStyler', () {
    group('Constructors', () {
      test('default constructor creates valid instance', () {
        final style = RemixSliderStyler();

        expect(style, isNotNull);
        expect(style, isA<RemixSliderStyler>());
      });

      test('create constructor with all parameters', () {
        final thumb = Prop.maybeMix(BoxStyler());
        final trackColor = Prop.value(Colors.blue);
        final trackWidth = Prop.value(8.0);
        final rangeColor = Prop.value(Colors.red);
        final rangeWidth = Prop.value(4.0);
        final variants = <VariantStyle<RemixSliderSpec>>[];

        final style = RemixSliderStyler.create(
          thumb: thumb,
          trackColor: trackColor,
          trackWidth: trackWidth,
          rangeColor: rangeColor,
          rangeWidth: rangeWidth,
          variants: variants,
        );

        expect(style, isNotNull);
        expect(style.$thumb, equals(thumb));
        expect(style.$trackColor, equals(trackColor));
        expect(style.$trackWidth, equals(trackWidth));
        expect(style.$rangeColor, equals(rangeColor));
        expect(style.$rangeWidth, equals(rangeWidth));
        expect(style.$variants, equals(variants));
      });

      test('constructor with styler parameters', () {
        final thumbStyler = BoxStyler();

        final style = RemixSliderStyler(
          thumb: thumbStyler,
          trackColor: Colors.blue,
          trackWidth: 10.0,
          rangeColor: Colors.red,
          rangeWidth: 5.0,
        );

        expect(style, isNotNull);
        expect(style.$thumb, isNotNull);
        expect(style.$trackColor, isNotNull);
        expect(style.$trackWidth, isNotNull);
        expect(style.$rangeColor, isNotNull);
        expect(style.$rangeWidth, isNotNull);
      });
    });

    group('Style Methods', () {
      styleMethodTest(
        'thumbColor',
        initial: RemixSliderStyler(),
        modify: (style) => style.thumbColor(Colors.blue),
        expect: (style) {
          expect(
            style.$thumb,
            equals(
              Prop.maybeMix(
                BoxStyler(decoration: BoxDecorationMix(color: Colors.blue)),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'trackColor',
        initial: RemixSliderStyler(),
        modify: (style) => style.trackColor(const Color(0xFF0000FF)),
        expect: (style) {
          expect(
            style,
            equals(RemixSliderStyler.trackColor(const Color(0xFF0000FF))),
          );
        },
      );

      styleMethodTest(
        'rangeColor',
        initial: RemixSliderStyler(),
        modify: (style) => style.rangeColor(const Color(0xFFFF0000)),
        expect: (style) {
          expect(
            style,
            equals(RemixSliderStyler.rangeColor(const Color(0xFFFF0000))),
          );
        },
      );

      styleMethodTest(
        'thumb',
        initial: RemixSliderStyler(),
        modify: (style) => style.thumb(
          BoxStyler(decoration: BoxDecorationMix(color: Colors.green)),
        ),
        expect: (style) {
          expect(
            style,
            equals(
              RemixSliderStyler.thumb(
                BoxStyler(decoration: BoxDecorationMix(color: Colors.green)),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'thumbSize',
        initial: RemixSliderStyler(),
        modify: (style) => style.thumbSize(const Size(20.0, 20.0)),
        expect: (style) {
          expect(
            style.$thumb,
            equals(
              Prop.maybeMix(
                BoxStyler(
                  constraints: BoxConstraintsMix.size(const Size(20.0, 20.0)),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'alignment',
        initial: RemixSliderStyler(),
        modify: (style) => style.alignment(Alignment.center),
        expect: (style) {
          expect(style, equals(RemixSliderStyler.alignment(Alignment.center)));
        },
      );

      styleMethodTest(
        'thickness',
        initial: RemixSliderStyler(),
        modify: (style) => style.thickness(12.0),
        expect: (style) {
          expect(style.$trackWidth, equals(Prop.value(12.0)));
          expect(style.$rangeWidth, equals(Prop.value(12.0)));
        },
      );

      styleMethodTest(
        'trackThickness',
        initial: RemixSliderStyler(),
        modify: (style) => style.trackThickness(10.0),
        expect: (style) {
          expect(style.$trackWidth, equals(Prop.value(10.0)));
        },
      );

      styleMethodTest(
        'rangeThickness',
        initial: RemixSliderStyler(),
        modify: (style) => style.rangeThickness(8.0),
        expect: (style) {
          expect(style.$rangeWidth, equals(Prop.value(8.0)));
        },
      );

      styleMethodTest(
        'padding',
        initial: RemixSliderStyler(),
        modify: (style) => style.padding(EdgeInsetsGeometryMix.all(16.0)),
        expect: (style) {
          expect(
            style,
            equals(RemixSliderStyler.padding(EdgeInsetsGeometryMix.all(16.0))),
          );
        },
      );

      styleMethodTest(
        'color',
        initial: RemixSliderStyler(),
        modify: (style) => style.color(Colors.purple),
        expect: (style) {
          expect(style, equals(RemixSliderStyler.color(Colors.purple)));
        },
      );

      styleMethodTest(
        'size',
        initial: RemixSliderStyler(),
        modify: (style) => style.size(24.0, 24.0),
        expect: (style) {
          expect(style, equals(RemixSliderStyler.size(24.0, 24.0)));
        },
      );

      styleMethodTest(
        'borderRadius',
        initial: RemixSliderStyler(),
        modify: (style) => style.borderRadius(BorderRadiusMix.circular(12.0)),
        expect: (style) {
          expect(
            style,
            equals(
              RemixSliderStyler.borderRadius(BorderRadiusMix.circular(12.0)),
            ),
          );
        },
      );

      styleMethodTest(
        'constraints',
        initial: RemixSliderStyler(),
        modify: (style) => style.constraints(
          BoxConstraintsMix(minWidth: 20.0, minHeight: 20.0),
        ),
        expect: (style) {
          expect(
            style,
            equals(
              RemixSliderStyler.constraints(
                BoxConstraintsMix(minWidth: 20.0, minHeight: 20.0),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'decoration',
        initial: RemixSliderStyler(),
        modify: (style) => style.decoration(
          BoxDecorationMix(
            color: Colors.blue,
            borderRadius: BorderRadiusMix.circular(8.0),
          ),
        ),
        expect: (style) {
          expect(
            style,
            equals(
              RemixSliderStyler.decoration(
                BoxDecorationMix(
                  color: Colors.blue,
                  borderRadius: BorderRadiusMix.circular(8.0),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'margin',
        initial: RemixSliderStyler(),
        modify: (style) => style.margin(EdgeInsetsGeometryMix.all(8.0)),
        expect: (style) {
          expect(
            style,
            equals(RemixSliderStyler.margin(EdgeInsetsGeometryMix.all(8.0))),
          );
        },
      );

      styleMethodTest(
        'foregroundDecoration',
        initial: RemixSliderStyler(),
        modify: (style) => style.foregroundDecoration(
          BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(color: Colors.red)),
          ),
        ),
        expect: (style) {
          expect(
            style,
            equals(
              RemixSliderStyler.foregroundDecoration(
                BoxDecorationMix(
                  border: BoxBorderMix.all(BorderSideMix(color: Colors.red)),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'transform',
        initial: RemixSliderStyler(),
        modify: (style) =>
            style.transform(Matrix4.identity(), alignment: Alignment.topLeft),
        expect: (style) {
          expect(
            style,
            equals(
              RemixSliderStyler.transform(
                Matrix4.identity(),
                alignment: Alignment.topLeft,
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'variants',
        initial: RemixSliderStyler(),
        modify: (style) => style.variants(<VariantStyle<RemixSliderSpec>>[]),
        expect: (style) {
          expect(style.$variants, equals(<VariantStyle<RemixSliderSpec>>[]));
        },
      );

      styleMethodTest(
        'wrap',
        initial: RemixSliderStyler(),
        modify: (style) => style.wrap(.clipOval()),
        expect: (style) {
          expect(style.$modifier, equals(WidgetModifierConfig.clipOval()));
        },
      );

      styleMethodTest(
        'animate',
        initial: RemixSliderStyler(),
        modify: (style) =>
            style.animate(AnimationConfig.linear(const Duration(seconds: 1))),
        expect: (style) {
          expect(
            style.$animation,
            equals(AnimationConfig.linear(const Duration(seconds: 1))),
          );
        },
      );
    });

    group('Core Methods', () {
      testWidgets('resolve method returns StyleSpec', (
        WidgetTester tester,
      ) async {
        final style = RemixSliderStyler();

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final spec = style.resolve(context);

                expect(spec, isA<StyleSpec<RemixSliderSpec>>());
                expect(spec.spec, isA<RemixSliderSpec>());
                expect(spec.spec.thumb, isA<StyleSpec<BoxSpec>?>());
                expect(spec.spec.trackColor, isA<Color?>());
                expect(spec.spec.trackWidth, isA<double?>());
                expect(spec.spec.rangeColor, isA<Color?>());
                expect(spec.spec.rangeWidth, isA<double?>());

                return Container();
              },
            ),
          ),
        );
      });

      test('merge with null returns style equal to original', () {
        final originalStyle = RemixSliderStyler();

        final mergedStyle = originalStyle.merge(null);

        expect(mergedStyle, equals(originalStyle));
      });
    });

    group('Call Method', () {
      testWidgets('call method creates RemixSlider with all parameters', (
        tester,
      ) async {
        final style = RemixSliderStyler().thumbColor(Colors.blue);
        final focusNode = FocusNode();

        final slider = style.call(
          value: 0.5,
          onChanged: (value) {},
          min: 0.0,
          max: 100.0,
          onChangeStart: (value) {},
          onChangeEnd: (value) {},
          enabled: false,
          enableFeedback: false,
          focusNode: focusNode,
          autofocus: true,
          snapDivisions: 10,
        );

        expect(slider, isA<RemixSlider>());
        expect(slider.value, equals(0.5));
        expect(slider.min, equals(0.0));
        expect(slider.max, equals(100.0));
        expect(slider.enabled, equals(false));
        expect(slider.enableFeedback, equals(false));
        expect(slider.focusNode, same(focusNode));
        expect(slider.autofocus, equals(true));
        expect(slider.snapDivisions, equals(10));
        expect(slider.style, same(style));

        focusNode.dispose();
      });

      testWidgets('call method creates RemixSlider with minimal parameters', (
        tester,
      ) async {
        final style = RemixSliderStyler();

        final slider = style.call(value: 0.3, onChanged: (v) {});

        expect(slider, isA<RemixSlider>());
        expect(slider.value, equals(0.3));
        expect(slider.min, equals(0.0));
        expect(slider.max, equals(1.0));
        expect(slider.enabled, equals(true));
        expect(slider.style, same(style));
      });
    });

    group('Equality', () {
      test('identical styles are equal', () {
        final style1 = RemixSliderStyler();
        final style2 = RemixSliderStyler();

        expect(style1, equals(style2));
        expect(style1.hashCode, equals(style2.hashCode));
      });

      test('styles with different properties are not equal', () {
        final style1 = RemixSliderStyler().trackColor(Colors.blue);
        final style2 = RemixSliderStyler().trackColor(Colors.red);

        expect(style1, isNot(equals(style2)));
      });
    });
  });
}
