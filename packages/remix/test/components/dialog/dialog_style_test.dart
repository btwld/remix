import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_methods.dart';

void main() {
  group('RemixDialogStyle', () {
    group('Constructors', () {
      test('default constructor creates valid instance', () {
        const style = RemixDialogStyle.create();
        expect(style, isNotNull);
        expect(style, isA<RemixDialogStyle>());
      });

      test('create constructor with all parameters', () {
        final container = Prop.maybeMix(BoxStyler());
        final title = Prop.maybeMix(TextStyler());
        final description = Prop.maybeMix(TextStyler());
        final actions = Prop.maybeMix(FlexBoxStyler());
        final overlay = Prop.maybeMix(BoxStyler());

        final style = RemixDialogStyle.create(
          container: container,
          title: title,
          description: description,
          actions: actions,
          overlay: overlay,
        );

        expect(style, isNotNull);
        expect(style, isA<RemixDialogStyle>());
      });

      test('constructor with styler parameters', () {
        final style = RemixDialogStyle(
          container: BoxStyler(padding: EdgeInsetsGeometryMix.all(24.0)),
          title: TextStyler(style: TextStyleMix(color: Colors.blue)),
          description: TextStyler(style: TextStyleMix(color: Colors.grey)),
          actions: FlexBoxStyler(spacing: 8.0),
          overlay: BoxStyler(
            decoration: BoxDecorationMix(color: Colors.black54),
          ),
        );

        expect(style, isNotNull);
        expect(style, isA<RemixDialogStyle>());
      });
    });

    group('Style Methods', () {
      styleMethodTest(
        'title sets title text styler',
        initial: RemixDialogStyle(),
        modify: (style) =>
            style.title(TextStyler(style: TextStyleMix(color: Colors.red))),
        expect: (style) {
          expect(
            style.$title,
            equals(
              Prop.maybeMix(TextStyler(style: TextStyleMix(color: Colors.red))),
            ),
          );
        },
      );

      styleMethodTest(
        'description sets description text styler',
        initial: RemixDialogStyle(),
        modify: (style) => style.description(
          TextStyler(style: TextStyleMix(color: Colors.green)),
        ),
        expect: (style) {
          expect(
            style.$description,
            equals(
              Prop.maybeMix(
                TextStyler(style: TextStyleMix(color: Colors.green)),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'actions sets actions flex box styler',
        initial: RemixDialogStyle(),
        modify: (style) => style.actions(FlexBoxStyler(spacing: 12.0)),
        expect: (style) {
          expect(
            style.$actions,
            equals(Prop.maybeMix(FlexBoxStyler(spacing: 12.0))),
          );
        },
      );

      styleMethodTest(
        'overlay sets overlay box styler',
        initial: RemixDialogStyle(),
        modify: (style) => style.overlay(
          BoxStyler(decoration: BoxDecorationMix(color: Colors.black87)),
        ),
        expect: (style) {
          expect(
            style.$overlay,
            equals(
              Prop.maybeMix(
                BoxStyler(decoration: BoxDecorationMix(color: Colors.black87)),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'alignment sets container alignment',
        initial: RemixDialogStyle(),
        modify: (style) => style.alignment(Alignment.centerRight),
        expect: (style) {
          expect(
            style.$container,
            equals(Prop.maybeMix(BoxStyler(alignment: Alignment.centerRight))),
          );
        },
      );

      styleMethodTest(
        'padding sets container padding',
        initial: RemixDialogStyle(),
        modify: (style) => style.padding(EdgeInsetsGeometryMix.all(24.0)),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(padding: EdgeInsetsGeometryMix.all(24.0)),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'color sets container background color',
        initial: RemixDialogStyle(),
        modify: (style) => style.color(Colors.white),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(decoration: BoxDecorationMix(color: Colors.white)),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'size sets container size constraints',
        initial: RemixDialogStyle(),
        modify: (style) => style.size(400.0, 300.0),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(
                  constraints: BoxConstraintsMix(
                    minWidth: 400.0,
                    maxWidth: 400.0,
                    minHeight: 300.0,
                    maxHeight: 300.0,
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'borderRadius sets container border radius',
        initial: RemixDialogStyle(),
        modify: (style) =>
            style.borderRadius(BorderRadiusGeometryMix.circular(16.0)),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(
                  decoration: BoxDecorationMix(
                    borderRadius: BorderRadiusGeometryMix.circular(16.0),
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'constraints sets container constraints',
        initial: RemixDialogStyle(),
        modify: (style) => style.constraints(
          BoxConstraintsMix(minWidth: 300.0, minHeight: 200.0),
        ),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(
                  constraints: BoxConstraintsMix(
                    minWidth: 300.0,
                    minHeight: 200.0,
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'decoration sets container decoration',
        initial: RemixDialogStyle(),
        modify: (style) => style.decoration(
          BoxDecorationMix(
            color: Colors.blue,
            borderRadius: BorderRadiusGeometryMix.circular(12.0),
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
        initial: RemixDialogStyle(),
        modify: (style) => style.margin(EdgeInsetsGeometryMix.all(16.0)),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(BoxStyler(margin: EdgeInsetsGeometryMix.all(16.0))),
            ),
          );
        },
      );

      styleMethodTest(
        'foregroundDecoration sets foreground decoration',
        initial: RemixDialogStyle(),
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
        initial: RemixDialogStyle(),
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

      styleMethodTest(
        'variants sets variant styles',
        initial: RemixDialogStyle(),
        modify: (style) => style.variants([]),
        expect: (style) {
          expect(style.$variants, equals([]));
        },
      );

      styleMethodTest(
        'wrap sets widget modifier config',
        initial: RemixDialogStyle(),
        modify: (style) => style.wrap(WidgetModifierConfig()),
        expect: (style) {
          expect(style.$modifier, equals(WidgetModifierConfig()));
        },
      );

      styleMethodTest(
        'animate sets animation config',
        initial: RemixDialogStyle(),
        modify: (style) =>
            style.animate(AnimationConfig.linear(Duration(milliseconds: 300))),
        expect: (style) {
          expect(
            style.$animation,
            equals(AnimationConfig.linear(Duration(milliseconds: 300))),
          );
        },
      );
    });

    group('Core Methods', () {
      testWidgets('resolve method returns StyleSpec', (tester) async {
        const style = RemixDialogStyle.create();
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final spec = style.resolve(context);
                expect(spec, isA<StyleSpec<RemixDialogSpec>>());
                expect(spec.spec, isA<RemixDialogSpec>());
                return Container();
              },
            ),
          ),
        );
      });

      test('merge with null returns style equal to original', () {
        const originalStyle = RemixDialogStyle.create();
        final mergedStyle = originalStyle.merge(null);
        expect(mergedStyle, equals(originalStyle));
      });

      test('merge with other style combines properties', () {
        const style1 = RemixDialogStyle.create();
        final style2 = RemixDialogStyle();

        final merged = style1.merge(style2);
        expect(merged, isNot(same(style1)));
        expect(merged, isNot(same(style2)));
        expect(merged, isA<RemixDialogStyle>());
      });

      test('props list contains all properties', () {
        const style = RemixDialogStyle.create();
        expect(style.props, hasLength(8));
        expect(style.props, contains(style.$container));
        expect(style.props, contains(style.$title));
        expect(style.props, contains(style.$description));
        expect(style.props, contains(style.$actions));
        expect(style.props, contains(style.$overlay));
        expect(style.props, contains(style.$variants));
        expect(style.props, contains(style.$animation));
        expect(style.props, contains(style.$modifier));
      });
    });

    group('Equality', () {
      test('identical styles are equal', () {
        const style1 = RemixDialogStyle.create();
        const style2 = RemixDialogStyle.create();
        expect(style1, equals(style2));
        expect(style1.hashCode, equals(style2.hashCode));
      });

      test('styles with different properties are not equal', () {
        const style1 = RemixDialogStyle.create();
        final style2 = RemixDialogStyle();
        expect(style1, equals(style2));
      });

      test('styles with same properties are equal', () {
        final style1 = RemixDialogStyle();
        final style2 = RemixDialogStyle();
        expect(style1, equals(style2));
        expect(style1.hashCode, equals(style2.hashCode));
      });
    });
  });
}
