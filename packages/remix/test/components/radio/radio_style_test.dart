import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_methods.dart';

void main() {
  group('RemixRadioStyle', () {
    group('Constructors', () {
      test('default constructor creates valid instance', () {
        final style = RemixRadioStyle();

        expect(style, isNotNull);
        expect(style, isA<RemixRadioStyle>());
      });

      test('create constructor with all parameters', () {
        final container = Prop.maybeMix(BoxStyler());
        final indicator = Prop.maybeMix(BoxStyler());
        final variants = <VariantStyle<RemixRadioSpec>>[];

        final style = RemixRadioStyle.create(
          container: container,
          indicator: indicator,
          variants: variants,
        );

        expect(style, isNotNull);
        expect(style.$container, equals(container));
        expect(style.$indicator, equals(indicator));
        expect(style.$variants, equals(variants));
      });

      test('constructor with styler parameters', () {
        final containerStyler = BoxStyler();
        final indicatorStyler = BoxStyler();

        final style = RemixRadioStyle(
          container: containerStyler,
          indicator: indicatorStyler,
        );

        expect(style, isNotNull);
        expect(style.$container, isNotNull);
        expect(style.$indicator, isNotNull);
      });
    });

    group('Style Methods', () {
      styleMethodTest(
        'indicator',
        initial: RemixRadioStyle(),
        modify: (style) => style.indicator(
          BoxStyler(decoration: BoxDecorationMix(color: Colors.blue)),
        ),
        expect: (style) {
          expect(
            style.$indicator,
            equals(
              Prop.maybeMix(
                BoxStyler(decoration: BoxDecorationMix(color: Colors.blue)),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'alignment',
        initial: RemixRadioStyle(),
        modify: (style) => style.alignment(Alignment.center),
        expect: (style) {
          expect(
            style.$container,
            equals(Prop.maybeMix(BoxStyler(alignment: Alignment.center))),
          );
        },
      );

      styleMethodTest(
        'padding',
        initial: RemixRadioStyle(),
        modify: (style) => style.padding(EdgeInsetsGeometryMix.all(16.0)),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(padding: EdgeInsetsGeometryMix.all(16.0)),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'margin',
        initial: RemixRadioStyle(),
        modify: (style) => style.margin(EdgeInsetsGeometryMix.all(8.0)),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(BoxStyler(margin: EdgeInsetsGeometryMix.all(8.0))),
            ),
          );
        },
      );

      styleMethodTest(
        'color',
        initial: RemixRadioStyle(),
        modify: (style) => style.color(Colors.blue),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(decoration: BoxDecorationMix(color: Colors.blue)),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'size',
        initial: RemixRadioStyle(),
        modify: (style) => style.size(24.0, 24.0),
        expect: (style) {
          expect(
            style.$container,
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
        initial: RemixRadioStyle(),
        modify: (style) => style.borderRadius(BorderRadiusMix.circular(12.0)),
        expect: (style) {
          expect(
            style.$container,
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
        initial: RemixRadioStyle(),
        modify: (style) => style.constraints(
          BoxConstraintsMix(minWidth: 20.0, minHeight: 20.0),
        ),
        expect: (style) {
          expect(
            style.$container,
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
        initial: RemixRadioStyle(),
        modify: (style) => style.decoration(
          BoxDecorationMix(
            color: Colors.blue,
            borderRadius: BorderRadiusMix.circular(8.0),
          ),
        ),
        expect: (style) {
          expect(
            style.$container,
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
        'foregroundDecoration',
        initial: RemixRadioStyle(),
        modify: (style) => style.foregroundDecoration(
          BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(color: Colors.red)),
          ),
        ),
        expect: (style) {
          expect(
            style.$container,
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
        initial: RemixRadioStyle(),
        modify: (style) =>
            style.transform(Matrix4.identity(), alignment: Alignment.topLeft),
        expect: (style) {
          expect(
            style.$container,
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
        initial: RemixRadioStyle(),
        modify: (style) => style.variants(<VariantStyle<RemixRadioSpec>>[]),
        expect: (style) {
          expect(style.$variants, equals(<VariantStyle<RemixRadioSpec>>[]));
        },
      );

      styleMethodTest(
        'wrap',
        initial: RemixRadioStyle(),
        modify: (style) => style.wrap(WidgetModifierConfig.clipOval()),
        expect: (style) {
          expect(style.$modifier, equals(WidgetModifierConfig.clipOval()));
        },
      );
    });

    group('Call Method', () {
      test('call method creates RemixRadio with required parameters', () {
        final style = RemixRadioStyle();

        final radio = style.call<String>(value: 'option1');

        expect(radio, isA<RemixRadio<String>>());
        expect(radio.value, equals('option1'));
        expect(radio.enabled, isTrue);
        expect(radio.autofocus, isFalse);
        expect(radio.toggleable, isFalse);
        expect(radio.enableFeedback, isTrue);
      });

      test('call method creates RemixRadio with all parameters', () {
        final style = RemixRadioStyle();
        final focusNode = FocusNode();

        final radio = style.call<int>(
          value: 42,
          enabled: false,
          autofocus: true,
          toggleable: true,
          focusNode: focusNode,
          mouseCursor: SystemMouseCursors.click,
          enableFeedback: false,
        );

        expect(radio, isA<RemixRadio<int>>());
        expect(radio.value, equals(42));
        expect(radio.enabled, isFalse);
        expect(radio.autofocus, isTrue);
        expect(radio.toggleable, isTrue);
        expect(radio.focusNode, equals(focusNode));
        expect(radio.mouseCursor, equals(SystemMouseCursors.click));
        expect(radio.enableFeedback, isFalse);
      });
    });

    group('Core Methods', () {
      testWidgets('resolve method returns StyleSpec', (
        WidgetTester tester,
      ) async {
        final style = RemixRadioStyle();

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final spec = style.resolve(context);

                expect(spec, isA<StyleSpec<RemixRadioSpec>>());
                expect(spec.spec, isA<RemixRadioSpec>());
                expect(spec.spec.container, isA<StyleSpec<BoxSpec>>());
                expect(spec.spec.indicator, isA<StyleSpec<BoxSpec>>());

                return Container();
              },
            ),
          ),
        );
      });

      test('merge with null returns style equal to original', () {
        final originalStyle = RemixRadioStyle();

        final mergedStyle = originalStyle.merge(null);

        expect(mergedStyle, equals(originalStyle));
      });
    });

    group('Equality', () {
      test('identical styles are equal', () {
        final style1 = RemixRadioStyle();
        final style2 = RemixRadioStyle();

        expect(style1, equals(style2));
        expect(style1.hashCode, equals(style2.hashCode));
      });

      test('styles with different properties are not equal', () {
        final style1 = RemixRadioStyle().size(20.0, 20.0);
        final style2 = RemixRadioStyle().size(24.0, 24.0);

        expect(style1, isNot(equals(style2)));
      });
    });
  });
}
