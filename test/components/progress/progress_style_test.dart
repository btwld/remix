import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_methods.dart';

void main() {
  group('RemixProgressStyle', () {
    group('Constructors', () {
      test('default constructor creates valid instance', () {
        final style = RemixProgressStyle();

        expect(style, isNotNull);
        expect(style, isA<RemixProgressStyle>());
      });

      test('create constructor with all parameters', () {
        final container = Prop.maybeMix(BoxStyler());
        final track = Prop.maybeMix(BoxStyler());
        final indicator = Prop.maybeMix(BoxStyler());
        final trackContainer = Prop.maybeMix(BoxStyler());
        final variants = <VariantStyle<RemixProgressSpec>>[];

        final style = RemixProgressStyle.create(
          container: container,
          track: track,
          indicator: indicator,
          trackContainer: trackContainer,
          variants: variants,
        );

        expect(style, isNotNull);
        expect(style.$container, equals(container));
        expect(style.$track, equals(track));
        expect(style.$indicator, equals(indicator));
        expect(style.$trackContainer, equals(trackContainer));
        expect(style.$variants, equals(variants));
      });

      test('constructor with styler parameters', () {
        final containerStyler = BoxStyler();
        final trackStyler = BoxStyler();
        final indicatorStyler = BoxStyler();
        final trackContainerStyler = BoxStyler();

        final style = RemixProgressStyle(
          container: containerStyler,
          track: trackStyler,
          indicator: indicatorStyler,
          trackContainer: trackContainerStyler,
        );

        expect(style, isNotNull);
        expect(style.$container, isNotNull);
        expect(style.$track, isNotNull);
        expect(style.$indicator, isNotNull);
        expect(style.$trackContainer, isNotNull);
      });
    });

    group('Style Methods', () {
      styleMethodTest(
        'height',
        initial: RemixProgressStyle(),
        modify: (style) => style.height(20.0),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(
                  constraints: BoxConstraintsMix(
                    minHeight: 20.0,
                    maxHeight: 20.0,
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'width',
        initial: RemixProgressStyle(),
        modify: (style) => style.width(200.0),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(
                  constraints: BoxConstraintsMix(
                    minWidth: 200.0,
                    maxWidth: 200.0,
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'trackColor',
        initial: RemixProgressStyle(),
        modify: (style) => style.trackColor(Colors.grey),
        expect: (style) {
          expect(
            style.$track,
            equals(
              Prop.maybeMix(
                BoxStyler(decoration: BoxDecorationMix(color: Colors.grey)),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'indicatorColor',
        initial: RemixProgressStyle(),
        modify: (style) => style.indicatorColor(Colors.blue),
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
        'track',
        initial: RemixProgressStyle(),
        modify: (style) => style.track(
          BoxStyler(decoration: BoxDecorationMix(color: Colors.red)),
        ),
        expect: (style) {
          expect(
            style.$track,
            equals(
              Prop.maybeMix(
                BoxStyler(decoration: BoxDecorationMix(color: Colors.red)),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'indicator',
        initial: RemixProgressStyle(),
        modify: (style) => style.indicator(
          BoxStyler(decoration: BoxDecorationMix(color: Colors.green)),
        ),
        expect: (style) {
          expect(
            style.$indicator,
            equals(
              Prop.maybeMix(
                BoxStyler(decoration: BoxDecorationMix(color: Colors.green)),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'trackContainer',
        initial: RemixProgressStyle(),
        modify: (style) => style.trackContainer(
          BoxStyler(padding: EdgeInsetsGeometryMix.all(4.0)),
        ),
        expect: (style) {
          expect(
            style.$trackContainer,
            equals(
              Prop.maybeMix(BoxStyler(padding: EdgeInsetsGeometryMix.all(4.0))),
            ),
          );
        },
      );

      styleMethodTest(
        'alignment',
        initial: RemixProgressStyle(),
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
        initial: RemixProgressStyle(),
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
        initial: RemixProgressStyle(),
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
        'constraints',
        initial: RemixProgressStyle(),
        modify: (style) => style.constraints(
          BoxConstraintsMix(minWidth: 100.0, minHeight: 40.0),
        ),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(
                  constraints: BoxConstraintsMix(
                    minWidth: 100.0,
                    minHeight: 40.0,
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'decoration',
        initial: RemixProgressStyle(),
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
        initial: RemixProgressStyle(),
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
        initial: RemixProgressStyle(),
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
        initial: RemixProgressStyle(),
        modify: (style) => style.variants(<VariantStyle<RemixProgressSpec>>[]),
        expect: (style) {
          expect(style.$variants, equals(<VariantStyle<RemixProgressSpec>>[]));
        },
      );

      styleMethodTest(
        'wrap',
        initial: RemixProgressStyle(),
        modify: (style) => style.wrap(WidgetModifierConfig.clipOval()),
        expect: (style) {
          expect(style.$modifier, equals(WidgetModifierConfig.clipOval()));
        },
      );
    });

    group('Core Methods', () {
      testWidgets('resolve method returns StyleSpec', (
        WidgetTester tester,
      ) async {
        final style = RemixProgressStyle();

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final spec = style.resolve(context);

                expect(spec, isA<StyleSpec<RemixProgressSpec>>());
                expect(spec.spec, isA<RemixProgressSpec>());
                expect(spec.spec.container, isA<StyleSpec<BoxSpec>>());
                expect(spec.spec.track, isA<StyleSpec<BoxSpec>>());
                expect(spec.spec.indicator, isA<StyleSpec<BoxSpec>>());
                expect(spec.spec.trackContainer, isA<StyleSpec<BoxSpec>>());

                return Container();
              },
            ),
          ),
        );
      });

      test('merge with null returns original instance', () {
        final originalStyle = RemixProgressStyle();

        final mergedStyle = originalStyle.merge(null);

        expect(mergedStyle, same(originalStyle));
      });
    });

    group('Equality', () {
      test('identical styles are equal', () {
        final style1 = RemixProgressStyle();
        final style2 = RemixProgressStyle();

        expect(style1, equals(style2));
        expect(style1.hashCode, equals(style2.hashCode));
      });

      test('styles with different properties are not equal', () {
        final style1 = RemixProgressStyle().height(10.0);
        final style2 = RemixProgressStyle().height(20.0);

        expect(style1, isNot(equals(style2)));
      });
    });
  });
}
