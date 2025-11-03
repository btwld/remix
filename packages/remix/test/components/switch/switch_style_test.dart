import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../lib/remix.dart';

import '../../helpers/test_methods.dart';

void main() {
  group('RemixSwitchStyle', () {
    group('Constructors', () {
      test('default constructor creates valid instance', () {
        final style = RemixSwitchStyle();

        expect(style, isNotNull);
        expect(style, isA<RemixSwitchStyle>());
      });

      test('create constructor with all parameters', () {
        final container = Prop.maybeMix(BoxStyler());
        final thumb = Prop.maybeMix(BoxStyler());
        final variants = <VariantStyle<RemixSwitchSpec>>[];

        final style = RemixSwitchStyle.create(
          container: container,
          thumb: thumb,
          variants: variants,
        );

        expect(style, isNotNull);
        expect(style.$container, equals(container));
        expect(style.$thumb, equals(thumb));
        expect(style.$variants, equals(variants));
      });

      test('constructor with styler parameters', () {
        final containerStyler = BoxStyler();
        final thumbStyler = BoxStyler();

        final style = RemixSwitchStyle(
          container: containerStyler,
          thumb: thumbStyler,
        );

        expect(style, isNotNull);
        expect(style.$container, isNotNull);
        expect(style.$thumb, isNotNull);
      });
    });

    group('Style Methods', () {
      styleMethodTest(
        'thumbColor',
        initial: RemixSwitchStyle(),
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
        'thumb',
        initial: RemixSwitchStyle(),
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
        'alignment',
        initial: RemixSwitchStyle(),
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
        initial: RemixSwitchStyle(),
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
        initial: RemixSwitchStyle(),
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
        initial: RemixSwitchStyle(),
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
        initial: RemixSwitchStyle(),
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
        initial: RemixSwitchStyle(),
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
        initial: RemixSwitchStyle(),
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
        initial: RemixSwitchStyle(),
        modify: (style) => style.variants(<VariantStyle<RemixSwitchSpec>>[]),
        expect: (style) {
          expect(style.$variants, equals(<VariantStyle<RemixSwitchSpec>>[]));
        },
      );

      styleMethodTest(
        'wrap',
        initial: RemixSwitchStyle(),
        modify: (style) => style.wrap(WidgetModifierConfig.clipOval()),
        expect: (style) {
          expect(style.$modifier, equals(WidgetModifierConfig.clipOval()));
        },
      );

      styleMethodTest(
        'animate',
        initial: RemixSwitchStyle(),
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
        final style = RemixSwitchStyle();

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final spec = style.resolve(context);

                expect(spec, isA<StyleSpec<RemixSwitchSpec>>());
                expect(spec.spec, isA<RemixSwitchSpec>());
                expect(spec.spec.container, isA<StyleSpec<BoxSpec>>());
                expect(spec.spec.thumb, isA<StyleSpec<BoxSpec>>());

                return Container();
              },
            ),
          ),
        );
      });

      test('merge with null returns original instance', () {
        final originalStyle = RemixSwitchStyle();

        final mergedStyle = originalStyle.merge(null);

        expect(mergedStyle, same(originalStyle));
      });

      test('merge combines properties correctly', () {
        final style1 = RemixSwitchStyle(
          container: BoxStyler(alignment: Alignment.centerLeft),
        );
        final style2 = RemixSwitchStyle(
          thumb: BoxStyler(decoration: BoxDecorationMix(color: Colors.blue)),
        );

        final merged = style1.merge(style2);

        expect(
          merged.$container,
          equals(Prop.maybeMix(BoxStyler(alignment: Alignment.centerLeft))),
        );
        expect(
          merged.$thumb,
          equals(
            Prop.maybeMix(
              BoxStyler(decoration: BoxDecorationMix(color: Colors.blue)),
            ),
          ),
        );
      });
    });

    group('Equality', () {
      test('identical styles are equal', () {
        final style1 = RemixSwitchStyle();
        final style2 = RemixSwitchStyle();

        expect(style1, equals(style2));
        expect(style1.hashCode, equals(style2.hashCode));
      });

      test('styles with different properties are not equal', () {
        final style1 = RemixSwitchStyle().thumbColor(Colors.blue);
        final style2 = RemixSwitchStyle().thumbColor(Colors.red);

        expect(style1, isNot(equals(style2)));
      });

      test('props list contains all properties', () {
        final style = RemixSwitchStyle();

        expect(style.props, hasLength(5));
        expect(style.props, contains(style.$container));
        expect(style.props, contains(style.$thumb));
        expect(style.props, contains(style.$variants));
        expect(style.props, contains(style.$animation));
        expect(style.props, contains(style.$modifier));
      });
    });
  });
}
