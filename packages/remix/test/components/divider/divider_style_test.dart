import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../lib/remix.dart';

import '../../helpers/test_methods.dart';

void main() {
  group('RemixDividerStyle', () {
    group('Constructors', () {
      test('default constructor creates valid instance', () {
        final style = RemixDividerStyle();

        expect(style, isNotNull);
        expect(style, isA<RemixDividerStyle>());
      });

      test('create constructor with all parameters', () {
        final container = Prop.maybeMix(BoxStyler());
        final variants = <VariantStyle<RemixDividerSpec>>[];

        final style = RemixDividerStyle.create(
          container: container,
          variants: variants,
        );

        expect(style, isNotNull);
        expect(style.$container, equals(container));
        expect(style.$variants, equals(variants));
      });

      test('constructor with styler parameters', () {
        final containerStyler = BoxStyler();

        final style = RemixDividerStyle(container: containerStyler);

        expect(style, isNotNull);
        expect(style.$container, isNotNull);
      });
    });

    group('Style Methods', () {
      styleMethodTest(
        'color',
        initial: RemixDividerStyle(),
        modify: (style) => style.color(Colors.red),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(decoration: BoxDecorationMix(color: Colors.red)),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'thickness',
        initial: RemixDividerStyle(),
        modify: (style) => style.thickness(2.0),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(
                  constraints: BoxConstraintsMix(
                    minHeight: 2.0,
                    maxHeight: 2.0,
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'padding',
        initial: RemixDividerStyle(),
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
        initial: RemixDividerStyle(),
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
        'alignment',
        initial: RemixDividerStyle(),
        modify: (style) => style.alignment(Alignment.center),
        expect: (style) {
          expect(
            style.$container,
            equals(Prop.maybeMix(BoxStyler(alignment: Alignment.center))),
          );
        },
      );

      styleMethodTest(
        'decoration',
        initial: RemixDividerStyle(),
        modify: (style) => style.decoration(
          BoxDecorationMix(
            color: Colors.blue,
            borderRadius: BorderRadiusMix.circular(4.0),
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
                    borderRadius: BorderRadiusMix.circular(4.0),
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'constraints',
        initial: RemixDividerStyle(),
        modify: (style) => style.constraints(
          BoxConstraintsMix(minWidth: 100.0, minHeight: 1.0),
        ),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(
                  constraints: BoxConstraintsMix(
                    minWidth: 100.0,
                    minHeight: 1.0,
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'foregroundDecoration',
        initial: RemixDividerStyle(),
        modify: (style) => style.foregroundDecoration(
          BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(color: Colors.black)),
          ),
        ),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(
                  foregroundDecoration: BoxDecorationMix(
                    border: BoxBorderMix.all(
                      BorderSideMix(color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'transform',
        initial: RemixDividerStyle(),
        modify: (style) =>
            style.transform(Matrix4.identity(), alignment: Alignment.topCenter),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(
                  transform: Matrix4.identity(),
                  transformAlignment: Alignment.topCenter,
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'wrap',
        initial: RemixDividerStyle(),
        modify: (style) => style.wrap(WidgetModifierConfig.clipOval()),
        expect: (style) {
          expect(style.$modifier, equals(WidgetModifierConfig.clipOval()));
        },
      );

      styleMethodTest(
        'variants',
        initial: RemixDividerStyle(),
        modify: (style) => style.variants(<VariantStyle<RemixDividerSpec>>[]),
        expect: (style) {
          expect(style.$variants, equals(<VariantStyle<RemixDividerSpec>>[]));
        },
      );

      styleMethodTest(
        'animate',
        initial: RemixDividerStyle(),
        modify: (style) => style.animate(
          AnimationConfig(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          ),
        ),
        expect: (style) {
          expect(style.$animation, isNotNull);
          expect(
            style.$animation?.duration,
            equals(Duration(milliseconds: 300)),
          );
          expect(style.$animation?.curve, equals(Curves.easeInOut));
        },
      );
    });

    group('Core Methods', () {
      testWidgets('resolve method returns StyleSpec', (
        WidgetTester tester,
      ) async {
        final style = RemixDividerStyle();

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final spec = style.resolve(context);

                expect(spec, isA<StyleSpec<RemixDividerSpec>>());
                expect(spec.spec, isA<RemixDividerSpec>());
                expect(spec.spec.container, isA<StyleSpec<BoxSpec>>());

                return Container();
              },
            ),
          ),
        );
      });

      test('merge with null returns original instance', () {
        final originalStyle = RemixDividerStyle();

        final mergedStyle = originalStyle.merge(null);

        expect(mergedStyle, same(originalStyle));
      });

      test('merge combines two styles', () {
        final style1 = RemixDividerStyle().color(Colors.red);
        final style2 = RemixDividerStyle().thickness(2.0);

        final merged = style1.merge(style2);

        expect(merged, isNot(same(style1)));
        expect(merged, isNot(same(style2)));
        expect(merged.$container, isNotNull);
      });
    });

    group('Equality', () {
      test('identical styles are equal', () {
        final style1 = RemixDividerStyle();
        final style2 = RemixDividerStyle();

        expect(style1, equals(style2));
        expect(style1.hashCode, equals(style2.hashCode));
      });

      test('styles with different properties are not equal', () {
        final style1 = RemixDividerStyle().color(Colors.red);
        final style2 = RemixDividerStyle().color(Colors.blue);

        expect(style1, isNot(equals(style2)));
      });
    });

    group('Props', () {
      test('props list contains all properties', () {
        final style = RemixDividerStyle();

        expect(style.props, hasLength(4));
        expect(style.props, contains(style.$container));
        expect(style.props, contains(style.$variants));
        expect(style.props, contains(style.$animation));
        expect(style.props, contains(style.$modifier));
      });
    });

    group('Chaining', () {
      test('multiple style methods can be chained', () {
        final style = RemixDividerStyle()
            .color(Colors.grey)
            .thickness(1.0)
            .margin(EdgeInsetsGeometryMix.symmetric(vertical: 8.0));

        expect(style, isA<RemixDividerStyle>());
        expect(style.$container, isNotNull);
      });
    });
  });
}
