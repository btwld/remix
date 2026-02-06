import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_methods.dart';

void main() {
  group('RemixCardStyle', () {
    group('Constructors', () {
      test('default constructor creates valid instance', () {
        const style = RemixCardStyle.create();
        expect(style, isNotNull);
        expect(style, isA<RemixCardStyle>());
      });

      test('create constructor with all parameters', () {
        final container = Prop.maybeMix(BoxStyler());

        final style = RemixCardStyle.create(container: container);

        expect(style, isNotNull);
        expect(style, isA<RemixCardStyle>());
      });

      test('constructor with styler parameters', () {
        final style = RemixCardStyle(
          container: BoxStyler(padding: EdgeInsetsGeometryMix.all(16.0)),
        );

        expect(style, isNotNull);
        expect(style, isA<RemixCardStyle>());
      });
    });

    group('Style Methods', () {
      styleMethodTest(
        'padding sets container padding',
        initial: RemixCardStyle(),
        modify: (style) => style.padding(EdgeInsetsGeometryMix.all(20.0)),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(padding: EdgeInsetsGeometryMix.all(20.0)),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'color sets container background color',
        initial: RemixCardStyle(),
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
        'borderRadius sets container border radius',
        initial: RemixCardStyle(),
        modify: (style) =>
            style.borderRadius(BorderRadiusGeometryMix.circular(12.0)),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(
                  decoration: BoxDecorationMix(
                    borderRadius: BorderRadiusGeometryMix.circular(12.0),
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'margin sets container margin',
        initial: RemixCardStyle(),
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
        'alignment sets container alignment',
        initial: RemixCardStyle(),
        modify: (style) => style.alignment(Alignment.centerLeft),
        expect: (style) {
          expect(
            style.$container,
            equals(Prop.maybeMix(BoxStyler(alignment: Alignment.centerLeft))),
          );
        },
      );

      styleMethodTest(
        'decoration sets container decoration',
        initial: RemixCardStyle(),
        modify: (style) => style.decoration(
          BoxDecorationMix(
            color: Colors.purple,
            borderRadius: BorderRadiusGeometryMix.circular(8.0),
          ),
        ),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(
                  decoration: BoxDecorationMix(
                    color: Colors.purple,
                    borderRadius: BorderRadiusGeometryMix.circular(8.0),
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'variants sets variant styles',
        initial: RemixCardStyle(),
        modify: (style) => style.variants([]),
        expect: (style) {
          expect(style.$variants, equals([]));
        },
      );

      styleMethodTest(
        'wrap sets widget modifier config',
        initial: RemixCardStyle(),
        modify: (style) => style.wrap(WidgetModifierConfig()),
        expect: (style) {
          expect(style.$modifier, equals(WidgetModifierConfig()));
        },
      );

      styleMethodTest(
        'animate sets animation config',
        initial: RemixCardStyle(),
        modify: (style) =>
            style.animate(AnimationConfig.linear(Duration(milliseconds: 300))),
        expect: (style) {
          expect(
            style.$animation,
            equals(AnimationConfig.linear(Duration(milliseconds: 300))),
          );
        },
      );

      styleMethodTest(
        'constraints sets container constraints',
        initial: RemixCardStyle(),
        modify: (style) => style.constraints(
          BoxConstraintsMix(minWidth: 200.0, minHeight: 100.0),
        ),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(
                  constraints: BoxConstraintsMix(
                    minWidth: 200.0,
                    minHeight: 100.0,
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'foregroundDecoration sets foreground decoration',
        initial: RemixCardStyle(),
        modify: (style) => style.foregroundDecoration(
          BoxDecorationMix(color: Colors.yellow.withValues(alpha: 0.5)),
        ),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(
                  foregroundDecoration: BoxDecorationMix(
                    color: Colors.yellow.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'transform sets container transform',
        initial: RemixCardStyle(),
        modify: (style) => style.transform(Matrix4.rotationZ(0.1)),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(
                  transform: Matrix4.rotationZ(0.1),
                  transformAlignment: Alignment.center,
                ),
              ),
            ),
          );
        },
      );
    });

    group('Core Methods', () {
      testWidgets('resolve method returns StyleSpec', (tester) async {
        const style = RemixCardStyle.create();
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final spec = style.resolve(context);
                expect(spec, isA<StyleSpec<RemixCardSpec>>());
                expect(spec.spec, isA<RemixCardSpec>());
                return Container();
              },
            ),
          ),
        );
      });

      test('merge with null returns original instance', () {
        const originalStyle = RemixCardStyle.create();
        final mergedStyle = originalStyle.merge(null);
        expect(mergedStyle, equals(originalStyle));
      });

      test('merge with other style combines properties', () {
        const style1 = RemixCardStyle.create();
        final style2 = RemixCardStyle();

        final merged = style1.merge(style2);
        expect(merged, isNot(same(style1)));
        expect(merged, isNot(same(style2)));
        expect(merged, isA<RemixCardStyle>());
      });

      test('props list contains all properties', () {
        const style = RemixCardStyle.create();
        expect(style.props, hasLength(4));
        expect(style.props, contains(style.$container));
        expect(style.props, contains(style.$variants));
        expect(style.props, contains(style.$animation));
        expect(style.props, contains(style.$modifier));
      });
    });

    group('Equality', () {
      test('identical styles are equal', () {
        const style1 = RemixCardStyle.create();
        const style2 = RemixCardStyle.create();
        expect(style1, equals(style2));
        expect(style1.hashCode, equals(style2.hashCode));
      });

      test('styles with different properties are not equal', () {
        const style1 = RemixCardStyle.create();
        final style2 = RemixCardStyle();
        expect(style1, equals(style2));
      });

      test('styles with same properties are equal', () {
        final style1 = RemixCardStyle();
        final style2 = RemixCardStyle();
        expect(style1, equals(style2));
        expect(style1.hashCode, equals(style2.hashCode));
      });
    });
  });
}
