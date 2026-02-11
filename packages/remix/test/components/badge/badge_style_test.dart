import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_methods.dart';

void main() {
  group('RemixBadgeStyle', () {
    group('Constructors', () {
      test('default constructor creates valid instance', () {
        const style = RemixBadgeStyle.create();
        expect(style, isNotNull);
        expect(style, isA<RemixBadgeStyle>());
      });

      test('create constructor with all parameters', () {
        final container = Prop.maybeMix(BoxStyler());
        final text = Prop.maybeMix(TextStyler());

        final style = RemixBadgeStyle.create(container: container, text: text);

        expect(style, isNotNull);
        expect(style, isA<RemixBadgeStyle>());
      });

      test('constructor with styler parameters', () {
        final style = RemixBadgeStyle(
          container: BoxStyler(padding: EdgeInsetsGeometryMix.all(8.0)),
          text: TextStyler(style: TextStyleMix(color: Colors.red)),
        );

        expect(style, isNotNull);
        expect(style, isA<RemixBadgeStyle>());
      });
    });

    group('Style Methods', () {
      styleMethodTest(
        'color sets background color',
        initial: RemixBadgeStyle(),
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
        'borderRadius sets border radius',
        initial: RemixBadgeStyle(),
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
        'padding sets container padding',
        initial: RemixBadgeStyle(),
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
        'textColor sets text color',
        initial: RemixBadgeStyle(),
        modify: (style) => style.textColor(Colors.green),
        expect: (style) {
          expect(
            style.$text,
            equals(
              Prop.maybeMix(
                TextStyler(style: TextStyleMix(color: Colors.green)),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'margin sets container margin',
        initial: RemixBadgeStyle(),
        modify: (style) => style.margin(EdgeInsetsGeometryMix.all(4.0)),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(BoxStyler(margin: EdgeInsetsGeometryMix.all(4.0))),
            ),
          );
        },
      );

      styleMethodTest(
        'decoration sets container decoration',
        initial: RemixBadgeStyle(),
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
        'alignment sets container alignment',
        initial: RemixBadgeStyle(),
        modify: (style) => style.alignment(Alignment.centerLeft),
        expect: (style) {
          expect(
            style.$container,
            equals(Prop.maybeMix(BoxStyler(alignment: Alignment.centerLeft))),
          );
        },
      );

      styleMethodTest(
        'label sets text styler',
        initial: RemixBadgeStyle(),
        modify: (style) =>
            style.label(TextStyler(style: TextStyleMix(fontSize: 14.0))),
        expect: (style) {
          expect(
            style.$text,
            equals(
              Prop.maybeMix(TextStyler(style: TextStyleMix(fontSize: 14.0))),
            ),
          );
        },
      );

      styleMethodTest(
        'constraints sets container constraints',
        initial: RemixBadgeStyle(),
        modify: (style) => style.constraints(
          BoxConstraintsMix(minWidth: 50.0, minHeight: 20.0),
        ),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(
                  constraints: BoxConstraintsMix(
                    minWidth: 50.0,
                    minHeight: 20.0,
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'animate sets animation config',
        initial: RemixBadgeStyle(),
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
        'variants sets variant styles',
        initial: RemixBadgeStyle(),
        modify: (style) => style.variants([]),
        expect: (style) {
          expect(style.$variants, equals([]));
        },
      );

      styleMethodTest(
        'wrap sets widget modifier config',
        initial: RemixBadgeStyle(),
        modify: (style) => style.wrap(WidgetModifierConfig()),
        expect: (style) {
          expect(style.$modifier, equals(WidgetModifierConfig()));
        },
      );

      styleMethodTest(
        'foregroundDecoration sets foreground decoration',
        initial: RemixBadgeStyle(),
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
        initial: RemixBadgeStyle(),
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
        const style = RemixBadgeStyle.create();
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final spec = style.resolve(context);
                expect(spec, isA<StyleSpec<RemixBadgeSpec>>());
                expect(spec.spec, isA<RemixBadgeSpec>());
                return Container();
              },
            ),
          ),
        );
      });

      test('merge with null returns style equal to original', () {
        const originalStyle = RemixBadgeStyle.create();
        final mergedStyle = originalStyle.merge(null);
        expect(mergedStyle, equals(originalStyle));
      });

      test('merge with other style combines properties', () {
        const style1 = RemixBadgeStyle.create();
        final style2 = RemixBadgeStyle();

        final merged = style1.merge(style2);
        expect(merged, isNot(same(style1)));
        expect(merged, isNot(same(style2)));
        expect(merged, isA<RemixBadgeStyle>());
      });

      test('props list contains all properties', () {
        const style = RemixBadgeStyle.create();
        expect(style.props, hasLength(5));
        expect(style.props, contains(style.$container));
        expect(style.props, contains(style.$text));
        expect(style.props, contains(style.$variants));
        expect(style.props, contains(style.$animation));
        expect(style.props, contains(style.$modifier));
      });
    });

    group('Equality', () {
      test('identical styles are equal', () {
        const style1 = RemixBadgeStyle.create();
        const style2 = RemixBadgeStyle.create();
        expect(style1, equals(style2));
        expect(style1.hashCode, equals(style2.hashCode));
      });

      test('styles with different properties are not equal', () {
        const style1 = RemixBadgeStyle.create();
        final style2 = RemixBadgeStyle();
        expect(style1, equals(style2));
      });

      test('styles with same properties are equal', () {
        final style1 = RemixBadgeStyle();
        final style2 = RemixBadgeStyle();
        expect(style1, equals(style2));
        expect(style1.hashCode, equals(style2.hashCode));
      });
    });
  });
}
