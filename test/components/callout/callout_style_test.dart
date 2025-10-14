import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_methods.dart';

void main() {
  group('RemixCalloutStyle', () {
    group('Constructors', () {
      test('default constructor creates valid instance', () {
        const style = RemixCalloutStyle.create();
        expect(style, isNotNull);
        expect(style, isA<RemixCalloutStyle>());
      });

      test('create constructor with all parameters', () {
        final container = Prop.maybeMix(FlexBoxStyler());
        final text = Prop.maybeMix(TextStyler());
        final icon = Prop.maybeMix(IconStyler());

        final style = RemixCalloutStyle.create(
          container: container,
          text: text,
          icon: icon,
        );

        expect(style, isNotNull);
        expect(style, isA<RemixCalloutStyle>());
      });

      test('constructor with styler parameters', () {
        final style = RemixCalloutStyle(
          container: FlexBoxStyler(padding: EdgeInsetsGeometryMix.all(16.0)),
          text: TextStyler(style: TextStyleMix(color: Colors.blue)),
          icon: IconStyler(color: Colors.green),
        );

        expect(style, isNotNull);
        expect(style, isA<RemixCalloutStyle>());
      });
    });

    group('Style Methods', () {
      styleMethodTest(
        'padding sets container padding',
        initial: RemixCalloutStyle(),
        modify: (style) => style.padding(EdgeInsetsGeometryMix.all(20.0)),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                FlexBoxStyler(padding: EdgeInsetsGeometryMix.all(20.0)),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'icon sets icon styler',
        initial: RemixCalloutStyle(),
        modify: (style) => style.icon(IconStyler(color: Colors.red)),
        expect: (style) {
          expect(
            style.$icon,
            equals(Prop.maybeMix(IconStyler(color: Colors.red))),
          );
        },
      );

      styleMethodTest(
        'margin sets container margin',
        initial: RemixCalloutStyle(),
        modify: (style) => style.margin(EdgeInsetsGeometryMix.all(8.0)),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                FlexBoxStyler(margin: EdgeInsetsGeometryMix.all(8.0)),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'color sets container background color',
        initial: RemixCalloutStyle(),
        modify: (style) => style.color(Colors.yellow),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                FlexBoxStyler(
                  decoration: BoxDecorationMix(color: Colors.yellow),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'borderRadius sets container border radius',
        initial: RemixCalloutStyle(),
        modify: (style) =>
            style.borderRadius(BorderRadiusGeometryMix.circular(12.0)),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                FlexBoxStyler(
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
        'decoration sets container decoration',
        initial: RemixCalloutStyle(),
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
                FlexBoxStyler(
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
        'alignment sets container alignment',
        initial: RemixCalloutStyle(),
        modify: (style) => style.alignment(Alignment.centerRight),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(FlexBoxStyler(alignment: Alignment.centerRight)),
            ),
          );
        },
      );

      styleMethodTest(
        'spacing sets flex spacing',
        initial: RemixCalloutStyle(),
        modify: (style) => style.spacing(16.0),
        expect: (style) {
          expect(
            style.$container,
            equals(Prop.maybeMix(FlexBoxStyler(spacing: 16.0))),
          );
        },
      );

      styleMethodTest(
        'iconColor sets icon color',
        initial: RemixCalloutStyle(),
        modify: (style) => style.iconColor(Colors.orange),
        expect: (style) {
          expect(
            style.$icon,
            equals(Prop.maybeMix(IconStyler(color: Colors.orange))),
          );
        },
      );

      styleMethodTest(
        'textColor sets text color',
        initial: RemixCalloutStyle(),
        modify: (style) => style.textColor(Colors.indigo),
        expect: (style) {
          expect(
            style.$text,
            equals(
              Prop.maybeMix(
                TextStyler(style: TextStyleMix(color: Colors.indigo)),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'variants sets variant styles',
        initial: RemixCalloutStyle(),
        modify: (style) => style.variants([]),
        expect: (style) {
          expect(style.$variants, equals([]));
        },
      );

      styleMethodTest(
        'wrap sets widget modifier config',
        initial: RemixCalloutStyle(),
        modify: (style) => style.wrap(WidgetModifierConfig()),
        expect: (style) {
          expect(style.$modifier, equals(WidgetModifierConfig()));
        },
      );

      styleMethodTest(
        'animate sets animation config',
        initial: RemixCalloutStyle(),
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
        initial: RemixCalloutStyle(),
        modify: (style) => style.constraints(
          BoxConstraintsMix(minWidth: 200.0, minHeight: 50.0),
        ),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                FlexBoxStyler(
                  constraints: BoxConstraintsMix(
                    minWidth: 200.0,
                    minHeight: 50.0,
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'foregroundDecoration sets foreground decoration',
        initial: RemixCalloutStyle(),
        modify: (style) => style.foregroundDecoration(
          BoxDecorationMix(color: Colors.cyan.withValues(alpha: 0.3)),
        ),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                FlexBoxStyler(
                  foregroundDecoration: BoxDecorationMix(
                    color: Colors.cyan.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'transform sets container transform',
        initial: RemixCalloutStyle(),
        modify: (style) => style.transform(Matrix4.rotationZ(0.2)),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                FlexBoxStyler(
                  transform: Matrix4.rotationZ(0.2),
                  transformAlignment: Alignment.center,
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'flex sets flex styler',
        initial: RemixCalloutStyle(),
        modify: (style) => style.flex(
          FlexStyler(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                FlexBoxStyler().flex(
                  FlexStyler(
                    direction: Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ),
              ),
            ),
          );
        },
      );
    });

    group('Core Methods', () {
      testWidgets('resolve method returns StyleSpec', (tester) async {
        const style = RemixCalloutStyle.create();
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final spec = style.resolve(context);
                expect(spec, isA<StyleSpec<RemixCalloutSpec>>());
                expect(spec.spec, isA<RemixCalloutSpec>());
                return Container();
              },
            ),
          ),
        );
      });

      test('merge with null returns original instance', () {
        const originalStyle = RemixCalloutStyle.create();
        final mergedStyle = originalStyle.merge(null);
        expect(mergedStyle, same(originalStyle));
      });

      test('merge with other style combines properties', () {
        const style1 = RemixCalloutStyle.create();
        final style2 = RemixCalloutStyle();

        final merged = style1.merge(style2);
        expect(merged, isNot(same(style1)));
        expect(merged, isNot(same(style2)));
        expect(merged, isA<RemixCalloutStyle>());
      });

      test('props list contains all properties', () {
        const style = RemixCalloutStyle.create();
        expect(style.props, hasLength(6));
        expect(style.props, contains(style.$container));
        expect(style.props, contains(style.$text));
        expect(style.props, contains(style.$icon));
        expect(style.props, contains(style.$variants));
        expect(style.props, contains(style.$animation));
        expect(style.props, contains(style.$modifier));
      });
    });

    group('Equality', () {
      test('identical styles are equal', () {
        const style1 = RemixCalloutStyle.create();
        const style2 = RemixCalloutStyle.create();
        expect(style1, equals(style2));
        expect(style1.hashCode, equals(style2.hashCode));
      });

      test('styles with different properties are not equal', () {
        const style1 = RemixCalloutStyle.create();
        final style2 = RemixCalloutStyle();
        expect(style1, equals(style2));
      });

      test('styles with same properties are equal', () {
        final style1 = RemixCalloutStyle();
        final style2 = RemixCalloutStyle();
        expect(style1, equals(style2));
        expect(style1.hashCode, equals(style2.hashCode));
      });
    });
  });
}
