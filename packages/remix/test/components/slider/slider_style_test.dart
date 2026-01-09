import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_methods.dart';

void main() {
  group('RemixSliderStyle', () {
    group('Constructors', () {
      test('default constructor creates valid instance', () {
        final style = RemixSliderStyle();

        expect(style, isNotNull);
        expect(style, isA<RemixSliderStyle>());
      });

      test('create constructor with all parameters', () {
        final thumb = Prop.maybeMix(BoxStyler());
        final trackColor = Prop.value(Colors.blue);
        final trackWidth = Prop.value(8.0);
        final rangeColor = Prop.value(Colors.red);
        final rangeWidth = Prop.value(4.0);
        final variants = <VariantStyle<RemixSliderSpec>>[];

        final style = RemixSliderStyle.create(
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

        final style = RemixSliderStyle(
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
        initial: RemixSliderStyle(),
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
        initial: RemixSliderStyle(),
        modify: (style) => style.trackColor(const Color(0xFF0000FF)),
        expect: (style) {
          expect(
            style.$trackColor,
            equals(Prop.value(const Color(0xFF0000FF))),
          );
        },
      );

      styleMethodTest(
        'rangeColor',
        initial: RemixSliderStyle(),
        modify: (style) => style.rangeColor(const Color(0xFFFF0000)),
        expect: (style) {
          expect(
            style.$rangeColor,
            equals(Prop.value(const Color(0xFFFF0000))),
          );
        },
      );

      styleMethodTest(
        'thumb',
        initial: RemixSliderStyle(),
        modify: (style) => style.thumb(
          BoxStyler(decoration: BoxDecorationMix(color: Colors.green)),
        ),
        expect: (style) {
          expect(
            style.$thumb,
            equals(
              Prop.maybeMix(
                BoxStyler(decoration: BoxDecorationMix(color: Colors.green)),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'thumbSize',
        initial: RemixSliderStyle(),
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
        initial: RemixSliderStyle(),
        modify: (style) => style.alignment(Alignment.center),
        expect: (style) {
          expect(
            style.$thumb,
            equals(Prop.maybeMix(BoxStyler(alignment: Alignment.center))),
          );
        },
      );

      styleMethodTest(
        'thickness',
        initial: RemixSliderStyle(),
        modify: (style) => style.thickness(12.0),
        expect: (style) {
          expect(style.$trackWidth, equals(Prop.value(12.0)));
          expect(style.$rangeWidth, equals(Prop.value(12.0)));
        },
      );

      styleMethodTest(
        'trackThickness',
        initial: RemixSliderStyle(),
        modify: (style) => style.trackThickness(10.0),
        expect: (style) {
          expect(style.$trackWidth, equals(Prop.value(10.0)));
        },
      );

      styleMethodTest(
        'rangeThickness',
        initial: RemixSliderStyle(),
        modify: (style) => style.rangeThickness(8.0),
        expect: (style) {
          expect(style.$rangeWidth, equals(Prop.value(8.0)));
        },
      );

      styleMethodTest(
        'padding',
        initial: RemixSliderStyle(),
        modify: (style) => style.padding(EdgeInsetsGeometryMix.all(16.0)),
        expect: (style) {
          expect(
            style.$thumb,
            equals(
              Prop.maybeMix(
                BoxStyler(padding: EdgeInsetsGeometryMix.all(16.0)),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'color',
        initial: RemixSliderStyle(),
        modify: (style) => style.color(Colors.purple),
        expect: (style) {
          expect(
            style.$thumb,
            equals(
              Prop.maybeMix(
                BoxStyler(decoration: BoxDecorationMix(color: Colors.purple)),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'size',
        initial: RemixSliderStyle(),
        modify: (style) => style.size(24.0, 24.0),
        expect: (style) {
          expect(
            style.$thumb,
            equals(
              Prop.maybeMix(
                BoxStyler(
                  constraints: BoxConstraintsMix(
                    minWidth: 24.0,
                    maxWidth: 24.0,
                    minHeight: 24.0,
                    maxHeight: 24.0,
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'borderRadius',
        initial: RemixSliderStyle(),
        modify: (style) => style.borderRadius(BorderRadiusMix.circular(12.0)),
        expect: (style) {
          expect(
            style.$thumb,
            equals(
              Prop.maybeMix(
                BoxStyler(
                  decoration: BoxDecorationMix(
                    borderRadius: BorderRadiusMix.circular(12.0),
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'constraints',
        initial: RemixSliderStyle(),
        modify: (style) => style.constraints(
          BoxConstraintsMix(minWidth: 20.0, minHeight: 20.0),
        ),
        expect: (style) {
          expect(
            style.$thumb,
            equals(
              Prop.maybeMix(
                BoxStyler(
                  constraints: BoxConstraintsMix(
                    minWidth: 20.0,
                    minHeight: 20.0,
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'decoration',
        initial: RemixSliderStyle(),
        modify: (style) => style.decoration(
          BoxDecorationMix(
            color: Colors.blue,
            borderRadius: BorderRadiusMix.circular(8.0),
          ),
        ),
        expect: (style) {
          expect(
            style.$thumb,
            equals(
              Prop.maybeMix(
                BoxStyler(
                  decoration: BoxDecorationMix(
                    color: Colors.blue,
                    borderRadius: BorderRadiusMix.circular(8.0),
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'margin',
        initial: RemixSliderStyle(),
        modify: (style) => style.margin(EdgeInsetsGeometryMix.all(8.0)),
        expect: (style) {
          expect(
            style.$thumb,
            equals(
              Prop.maybeMix(BoxStyler(margin: EdgeInsetsGeometryMix.all(8.0))),
            ),
          );
        },
      );

      styleMethodTest(
        'foregroundDecoration',
        initial: RemixSliderStyle(),
        modify: (style) => style.foregroundDecoration(
          BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(color: Colors.red)),
          ),
        ),
        expect: (style) {
          expect(
            style.$thumb,
            equals(
              Prop.maybeMix(
                BoxStyler(
                  foregroundDecoration: BoxDecorationMix(
                    border: BoxBorderMix.all(BorderSideMix(color: Colors.red)),
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'transform',
        initial: RemixSliderStyle(),
        modify: (style) =>
            style.transform(Matrix4.identity(), alignment: Alignment.topLeft),
        expect: (style) {
          expect(
            style.$thumb,
            equals(
              Prop.maybeMix(
                BoxStyler(
                  transform: Matrix4.identity(),
                  transformAlignment: Alignment.topLeft,
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'variants',
        initial: RemixSliderStyle(),
        modify: (style) => style.variants(<VariantStyle<RemixSliderSpec>>[]),
        expect: (style) {
          expect(style.$variants, equals(<VariantStyle<RemixSliderSpec>>[]));
        },
      );

      styleMethodTest(
        'wrap',
        initial: RemixSliderStyle(),
        modify: (style) => style.wrap(WidgetModifierConfig.clipOval()),
        expect: (style) {
          expect(style.$modifier, equals(WidgetModifierConfig.clipOval()));
        },
      );

      styleMethodTest(
        'animate',
        initial: RemixSliderStyle(),
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
        final style = RemixSliderStyle();

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final spec = style.resolve(context);

                expect(spec, isA<StyleSpec<RemixSliderSpec>>());
                expect(spec.spec, isA<RemixSliderSpec>());
                expect(spec.spec.thumb, isA<StyleSpec<BoxSpec>>());
                expect(spec.spec.trackColor, isA<Color>());
                expect(spec.spec.trackWidth, isA<double>());
                expect(spec.spec.rangeColor, isA<Color>());
                expect(spec.spec.rangeWidth, isA<double>());

                return Container();
              },
            ),
          ),
        );
      });

      test('merge with null returns original instance', () {
        final originalStyle = RemixSliderStyle();

        final mergedStyle = originalStyle.merge(null);

        expect(mergedStyle, same(originalStyle));
      });
    });

    group('Call Method', () {
      testWidgets('call method creates RemixSlider with all parameters',
          (tester) async {
        final style = RemixSliderStyle().thumbColor(Colors.blue);
        final focusNode = FocusNode();

        final slider = style.call(
          value: 0.5,
          onChanged: (value) {},
          min: 0.0,
          max: 100.0,
          onChangeStart: (value) {},
          onChangeEnd: (value) {},
          enabled: false,
          enableHapticFeedback: false,
          focusNode: focusNode,
          autofocus: true,
          snapDivisions: 10,
        );

        expect(slider, isA<RemixSlider>());
        expect(slider.value, equals(0.5));
        expect(slider.min, equals(0.0));
        expect(slider.max, equals(100.0));
        expect(slider.enabled, equals(false));
        expect(slider.enableHapticFeedback, equals(false));
        expect(slider.focusNode, same(focusNode));
        expect(slider.autofocus, equals(true));
        expect(slider.snapDivisions, equals(10));
        expect(slider.style, same(style));

        focusNode.dispose();
      });

      testWidgets('call method creates RemixSlider with minimal parameters',
          (tester) async {
        final style = RemixSliderStyle();

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
        final style1 = RemixSliderStyle();
        final style2 = RemixSliderStyle();

        expect(style1, equals(style2));
        expect(style1.hashCode, equals(style2.hashCode));
      });

      test('styles with different properties are not equal', () {
        final style1 = RemixSliderStyle().trackColor(Colors.blue);
        final style2 = RemixSliderStyle().trackColor(Colors.red);

        expect(style1, isNot(equals(style2)));
      });
    });
  });
}
