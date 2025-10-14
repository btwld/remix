import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_methods.dart';

void main() {
  group('RemixIconButtonStyle', () {
    group('Constructors', () {
      test('default constructor creates valid instance', () {
        const style = RemixIconButtonStyle.create();
        expect(style, isNotNull);
        expect(style, isA<RemixIconButtonStyle>());
      });

      test('create constructor with all parameters', () {
        final container = Prop.maybeMix(BoxStyler());
        final icon = Prop.maybeMix(IconStyler());
        final spinner = Prop.maybeMix(RemixSpinnerStyle());

        final style = RemixIconButtonStyle.create(
          container: container,
          icon: icon,
          spinner: spinner,
        );

        expect(style, isNotNull);
        expect(style, isA<RemixIconButtonStyle>());
      });

      test('constructor with styler parameters', () {
        final style = RemixIconButtonStyle(
          container: BoxStyler(padding: EdgeInsetsGeometryMix.all(12.0)),
          icon: IconStyler(color: Colors.blue),
          spinner: RemixSpinnerStyle(),
        );

        expect(style, isNotNull);
        expect(style, isA<RemixIconButtonStyle>());
      });
    });

    group('Style Methods', () {
      styleMethodTest(
        'icon sets icon styler',
        initial: RemixIconButtonStyle(),
        modify: (style) => style.icon(IconStyler(color: Colors.red)),
        expect: (style) {
          expect(
            style.$icon,
            equals(Prop.maybeMix(IconStyler(color: Colors.red))),
          );
        },
      );

      styleMethodTest(
        'spinner sets spinner style',
        initial: RemixIconButtonStyle(),
        modify: (style) => style.spinner(RemixSpinnerStyle()),
        expect: (style) {
          expect(style.$spinner, equals(Prop.maybeMix(RemixSpinnerStyle())));
        },
      );

      styleMethodTest(
        'color sets container background color',
        initial: RemixIconButtonStyle(),
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
        'padding sets container padding',
        initial: RemixIconButtonStyle(),
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
        'borderRadius sets container border radius',
        initial: RemixIconButtonStyle(),
        modify: (style) =>
            style.borderRadius(BorderRadiusGeometryMix.circular(8.0)),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(
                  decoration: BoxDecorationMix(
                    borderRadius: BorderRadiusGeometryMix.circular(8.0),
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'iconButtonSize sets container size constraints',
        initial: RemixIconButtonStyle(),
        modify: (style) => style.iconButtonSize(48.0),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(
                  constraints: BoxConstraintsMix(
                    minWidth: 48.0,
                    maxWidth: 48.0,
                    minHeight: 48.0,
                    maxHeight: 48.0,
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'border sets container border',
        initial: RemixIconButtonStyle(),
        modify: (style) =>
            style.border(BoxBorderMix.all(BorderSideMix(color: Colors.grey))),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(
                  decoration: BoxDecorationMix(
                    border: BoxBorderMix.all(BorderSideMix(color: Colors.grey)),
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'margin sets container margin',
        initial: RemixIconButtonStyle(),
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
        'alignment sets container alignment',
        initial: RemixIconButtonStyle(),
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
        initial: RemixIconButtonStyle(),
        modify: (style) => style.decoration(
          BoxDecorationMix(
            color: Colors.lightBlue,
            borderRadius: BorderRadiusGeometryMix.circular(6.0),
          ),
        ),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(
                  decoration: BoxDecorationMix(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadiusGeometryMix.circular(6.0),
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'constraints sets container constraints',
        initial: RemixIconButtonStyle(),
        modify: (style) => style.constraints(
          BoxConstraintsMix(minWidth: 40.0, minHeight: 40.0),
        ),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(
                  constraints: BoxConstraintsMix(
                    minWidth: 40.0,
                    minHeight: 40.0,
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'iconColor sets icon color',
        initial: RemixIconButtonStyle(),
        modify: (style) => style.iconColor(Colors.green),
        expect: (style) {
          expect(
            style.$icon,
            equals(Prop.maybeMix(IconStyler(color: Colors.green))),
          );
        },
      );

      styleMethodTest(
        'iconSize sets icon size',
        initial: RemixIconButtonStyle(),
        modify: (style) => style.iconSize(24.0),
        expect: (style) {
          expect(style.$icon, equals(Prop.maybeMix(IconStyler(size: 24.0))));
        },
      );

      styleMethodTest(
        'width sets container width',
        initial: RemixIconButtonStyle(),
        modify: (style) => style.width(50.0),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(
                  constraints: BoxConstraintsMix(
                    minWidth: 50.0,
                    maxWidth: 50.0,
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'height sets container height',
        initial: RemixIconButtonStyle(),
        modify: (style) => style.height(50.0),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(
                  constraints: BoxConstraintsMix(
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
        'animate sets animation config',
        initial: RemixIconButtonStyle(),
        modify: (style) =>
            style.animate(AnimationConfig.linear(Duration(milliseconds: 200))),
        expect: (style) {
          expect(
            style.$animation,
            equals(AnimationConfig.linear(Duration(milliseconds: 200))),
          );
        },
      );

      styleMethodTest(
        'variants sets variant styles',
        initial: RemixIconButtonStyle(),
        modify: (style) => style.variants([]),
        expect: (style) {
          expect(style.$variants, equals([]));
        },
      );

      styleMethodTest(
        'wrap sets widget modifier config',
        initial: RemixIconButtonStyle(),
        modify: (style) => style.wrap(WidgetModifierConfig()),
        expect: (style) {
          expect(style.$modifier, equals(WidgetModifierConfig()));
        },
      );

      styleMethodTest(
        'foregroundDecoration sets foreground decoration',
        initial: RemixIconButtonStyle(),
        modify: (style) => style.foregroundDecoration(
          BoxDecorationMix(color: Colors.yellow.withValues(alpha: 0.3)),
        ),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(
                  foregroundDecoration: BoxDecorationMix(
                    color: Colors.yellow.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'transform sets container transform',
        initial: RemixIconButtonStyle(),
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

    group('Call Method', () {
      test('call method creates RemixIconButton with required parameters', () {
        const style = RemixIconButtonStyle.create();
        final button = style.call(icon: Icons.add, onPressed: () {});

        expect(button, isA<RemixIconButton>());
        expect(button.icon, equals(Icons.add));
        expect(button.onPressed, isNotNull);
      });

      test('call method with all parameters', () {
        const style = RemixIconButtonStyle.create();
        final button = style.call(
          icon: Icons.delete,
          onPressed: () {},
          loading: true,
          enableFeedback: false,
          focusNode: FocusNode(),
        );

        expect(button, isA<RemixIconButton>());
        expect(button.icon, equals(Icons.delete));
        expect(button.onPressed, isNotNull);
        expect(button.loading, isTrue);
        expect(button.enableFeedback, isFalse);
        expect(button.focusNode, isNotNull);
      });
    });

    group('Core Methods', () {
      testWidgets('resolve method returns StyleSpec', (tester) async {
        const style = RemixIconButtonStyle.create();
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final spec = style.resolve(context);
                expect(spec, isA<StyleSpec<RemixIconButtonSpec>>());
                expect(spec.spec, isA<RemixIconButtonSpec>());
                return Container();
              },
            ),
          ),
        );
      });

      test('merge with null returns original instance', () {
        const originalStyle = RemixIconButtonStyle.create();
        final mergedStyle = originalStyle.merge(null);
        expect(mergedStyle, same(originalStyle));
      });

      test('merge with other style combines properties', () {
        const style1 = RemixIconButtonStyle.create();
        final style2 = RemixIconButtonStyle();

        final merged = style1.merge(style2);
        expect(merged, isNot(same(style1)));
        expect(merged, isNot(same(style2)));
        expect(merged, isA<RemixIconButtonStyle>());
      });

      test('props list contains all properties', () {
        const style = RemixIconButtonStyle.create();
        expect(style.props, hasLength(6));
        expect(style.props, contains(style.$container));
        expect(style.props, contains(style.$icon));
        expect(style.props, contains(style.$spinner));
        expect(style.props, contains(style.$variants));
        expect(style.props, contains(style.$animation));
        expect(style.props, contains(style.$modifier));
      });
    });

    group('Equality', () {
      test('identical styles are equal', () {
        const style1 = RemixIconButtonStyle.create();
        const style2 = RemixIconButtonStyle.create();
        expect(style1, equals(style2));
        expect(style1.hashCode, equals(style2.hashCode));
      });

      test('styles with different properties are not equal', () {
        const style1 = RemixIconButtonStyle.create();
        final style2 = RemixIconButtonStyle();
        expect(style1, equals(style2));
      });

      test('styles with same properties are equal', () {
        final style1 = RemixIconButtonStyle();
        final style2 = RemixIconButtonStyle();
        expect(style1, equals(style2));
        expect(style1.hashCode, equals(style2.hashCode));
      });
    });
  });
}
