import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_methods.dart';

void main() {
  group('RemixAvatarStyle', () {
    group('Constructors', () {
      test('default constructor creates valid instance', () {
        const style = RemixAvatarStyle.create();
        expect(style, isNotNull);
        expect(style, isA<RemixAvatarStyle>());
      });

      test('constructor with styler parameters', () {
        final style = RemixAvatarStyle(
          container: BoxStyler(
            decoration: BoxDecorationMix(color: Colors.blue),
          ),
          text: TextStyler(style: TextStyleMix(color: Colors.white)),
          icon: IconStyler(color: Colors.red),
        );

        expect(style, isNotNull);
        expect(style, isA<RemixAvatarStyle>());
      });
    });

    group('Style Methods', () {
      styleMethodTest(
        'square method sets equal width and height',
        initial: RemixAvatarStyle(),
        modify: (style) => style.square(50.0),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(
                  constraints: BoxConstraintsMix(
                    minWidth: 50.0,
                    maxWidth: 50.0,
                    minHeight: 50.0,
                    maxHeight: 50.0,
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'sizeWH method sets width and height',
        initial: RemixAvatarStyle(),
        modify: (style) => style.sizeWH(100.0, 80.0),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(
                  constraints: BoxConstraintsMix(
                    minWidth: 100.0,
                    maxWidth: 100.0,
                    minHeight: 80.0,
                    maxHeight: 80.0,
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'color method sets background color',
        initial: RemixAvatarStyle(),
        modify: (style) => style.color(Colors.green),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(decoration: BoxDecorationMix(color: Colors.green)),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'borderRadius method sets border radius',
        initial: RemixAvatarStyle(),
        modify: (style) => style.borderRadius(
          BorderRadiusGeometryMix.all(Radius.circular(10)),
        ),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(
                  decoration: BoxDecorationMix(
                    borderRadius: BorderRadiusMix.circular(10),
                    shape: BoxShape.rectangle,
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'textColor method sets text color',
        initial: RemixAvatarStyle(),
        modify: (style) => style.textColor(Colors.purple),
        expect: (style) {
          expect(
            style.$text,
            equals(
              Prop.maybeMix(
                TextStyler(style: TextStyleMix(color: Colors.purple)),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'iconColor method sets icon color',
        initial: RemixAvatarStyle(),
        modify: (style) => style.iconColor(Colors.orange),
        expect: (style) {
          expect(
            style.$icon,
            equals(Prop.maybeMix(IconStyler(color: Colors.orange))),
          );
        },
      );

      styleMethodTest(
        'padding method sets padding',
        initial: RemixAvatarStyle(),
        modify: (style) => style.padding(EdgeInsetsGeometryMix.all(8.0)),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(BoxStyler(padding: EdgeInsetsGeometryMix.all(8.0))),
            ),
          );
        },
      );

      styleMethodTest(
        'margin method sets margin',
        initial: RemixAvatarStyle(),
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
        'alignment method sets container alignment',
        initial: RemixAvatarStyle(),
        modify: (style) => style.alignment(Alignment.topLeft),
        expect: (style) {
          expect(
            style.$container,
            equals(Prop.maybeMix(BoxStyler(alignment: Alignment.topLeft))),
          );
        },
      );

      styleMethodTest(
        'decoration method sets decoration',
        initial: RemixAvatarStyle(),
        modify: (style) =>
            style.decoration(BoxDecorationMix(color: Colors.yellow)),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(decoration: BoxDecorationMix(color: Colors.yellow)),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'constraints method sets constraints',
        initial: RemixAvatarStyle(),
        modify: (style) => style.constraints(
          BoxConstraintsMix(
            minWidth: 50,
            maxWidth: 100,
            minHeight: 50,
            maxHeight: 100,
          ),
        ),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(
                  constraints: BoxConstraintsMix(
                    minWidth: 50,
                    maxWidth: 100,
                    minHeight: 50,
                    maxHeight: 100,
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'animate method sets animation',
        initial: RemixAvatarStyle(),
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
        'label method sets text styler',
        initial: RemixAvatarStyle(),
        modify: (style) =>
            style.label(TextStyler(style: TextStyleMix(fontSize: 16))),
        expect: (style) {
          expect(
            style.$text,
            equals(
              Prop.maybeMix(TextStyler(style: TextStyleMix(fontSize: 16))),
            ),
          );
        },
      );

      styleMethodTest(
        'icon method sets icon styler',
        initial: RemixAvatarStyle(),
        modify: (style) => style.icon(IconStyler(size: 24)),
        expect: (style) {
          expect(style.$icon, equals(Prop.maybeMix(IconStyler(size: 24))));
        },
      );

      styleMethodTest(
        'size method sets width and height',
        initial: RemixAvatarStyle(),
        modify: (style) => style.size(60.0, 40.0),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(
                  constraints: BoxConstraintsMix(
                    minWidth: 60.0,
                    maxWidth: 60.0,
                    minHeight: 40.0,
                    maxHeight: 40.0,
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'variants method sets variants',
        initial: RemixAvatarStyle(),
        modify: (style) => style.variants([]),
        expect: (style) {
          expect(style.$variants, equals([]));
        },
      );

      styleMethodTest(
        'wrap method sets modifier',
        initial: RemixAvatarStyle(),
        modify: (style) => style.wrap(WidgetModifierConfig.align()),
        expect: (style) {
          expect(style.$modifier, equals(WidgetModifierConfig.align()));
        },
      );

      styleMethodTest(
        'foregroundDecoration method sets foreground decoration',
        initial: RemixAvatarStyle(),
        modify: (style) =>
            style.foregroundDecoration(BoxDecorationMix(color: Colors.cyan)),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(
                  foregroundDecoration: BoxDecorationMix(color: Colors.cyan),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'transform method sets transform',
        initial: RemixAvatarStyle(),
        modify: (style) => style.transform(Matrix4.identity()),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(
                  transform: Matrix4.identity(),
                  transformAlignment: Alignment.center,
                ),
              ),
            ),
          );
        },
      );
    });

    group('Style Integration', () {
      test('style can be used to create RemixAvatar widget', () {
        final style = RemixAvatarStyle().square(50.0);
        final avatar = RemixAvatar(style: style, label: 'Test User');

        expect(avatar, isA<RemixAvatar>());
        expect(avatar.label, equals('Test User'));
        expect(avatar.style, equals(style));
      });

      test('style methods can be chained', () {
        final style = RemixAvatarStyle()
            .square(100.0)
            .textColor(Colors.white)
            .iconColor(Colors.yellow);

        expect(style, isA<RemixAvatarStyle>());
      });
    });

    group('Core Methods', () {
      testWidgets('resolve method returns StyleSpec', (tester) async {
        final style = RemixAvatarStyle();
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final spec = style.resolve(context);
                expect(spec, isA<StyleSpec<RemixAvatarSpec>>());
                return Container();
              },
            ),
          ),
        );
      });

      test('merge with null returns original instance', () {
        final originalStyle = RemixAvatarStyle();
        final mergedStyle = originalStyle.merge(null);
        expect(mergedStyle, equals(originalStyle));
      });

      test('merge with other style returns new instance', () {
        final style1 = RemixAvatarStyle();
        final style2 = RemixAvatarStyle().square(50.0);
        final mergedStyle = style1.merge(style2);

        expect(mergedStyle, isNot(same(style1)));
        expect(mergedStyle, isNot(same(style2)));
        expect(mergedStyle, isA<RemixAvatarStyle>());
      });
    });

    group('Equality', () {
      test('identical styles are equal', () {
        const style1 = RemixAvatarStyle.create();
        const style2 = RemixAvatarStyle.create();
        expect(style1, equals(style2));
        expect(style1.hashCode, equals(style2.hashCode));
      });

      test('styles with different properties are not equal', () {
        final style1 = RemixAvatarStyle().square(50.0);
        final style2 = RemixAvatarStyle().square(100.0);
        expect(style1, isNot(equals(style2)));
      });

      test('styles with same properties are equal', () {
        final style1 = RemixAvatarStyle().square(50.0);
        final style2 = RemixAvatarStyle().square(50.0);
        expect(style1, equals(style2));
        expect(style1.hashCode, equals(style2.hashCode));
      });
    });
  });
}
