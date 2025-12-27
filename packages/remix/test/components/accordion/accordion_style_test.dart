import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_methods.dart';

void main() {
  group('RemixAccordionStyle', () {
    group('Constructors', () {
      test('default constructor creates valid instance', () {
        final style = RemixAccordionStyle<String>();

        expect(style, isNotNull);
        expect(style, isA<RemixAccordionStyle<String>>());
      });

      test('create constructor with all parameters', () {
        final trigger = Prop.maybeMix(FlexBoxStyler());
        final leadingIcon = Prop.maybeMix(IconStyler());
        final title = Prop.maybeMix(TextStyler());
        final trailingIcon = Prop.maybeMix(IconStyler());
        final content = Prop.maybeMix(BoxStyler());
        final variants = <VariantStyle<RemixAccordionSpec>>[];

        final style = RemixAccordionStyle<String>.create(
          trigger: trigger,
          leadingIcon: leadingIcon,
          title: title,
          trailingIcon: trailingIcon,
          content: content,
          variants: variants,
        );

        expect(style, isNotNull);
        expect(style.$trigger, equals(trigger));
        expect(style.$leadingIcon, equals(leadingIcon));
        expect(style.$title, equals(title));
        expect(style.$trailingIcon, equals(trailingIcon));
        expect(style.$content, equals(content));
        expect(style.$variants, equals(variants));
      });

      test('constructor with styler parameters', () {
        final triggerStyler = FlexBoxStyler();
        final titleStyler = TextStyler();
        final contentStyler = BoxStyler();

        final style = RemixAccordionStyle<String>(
          trigger: triggerStyler,
          title: titleStyler,
          content: contentStyler,
        );

        expect(style, isNotNull);
        expect(style.$trigger, isNotNull);
        expect(style.$title, isNotNull);
        expect(style.$content, isNotNull);
      });
    });

    group('Style Methods', () {
      styleMethodTest(
        'trigger',
        initial: RemixAccordionStyle<String>(),
        modify: (style) => style.trigger(FlexBoxStyler()),
        expect: (style) {
          expect(style.$trigger, equals(Prop.maybeMix(FlexBoxStyler())));
        },
      );

      styleMethodTest(
        'leadingIcon',
        initial: RemixAccordionStyle<String>(),
        modify: (style) => style.leadingIcon(IconStyler()),
        expect: (style) {
          expect(style.$leadingIcon, equals(Prop.maybeMix(IconStyler())));
        },
      );

      styleMethodTest(
        'title',
        initial: RemixAccordionStyle<String>(),
        modify: (style) => style.title(TextStyler()),
        expect: (style) {
          expect(style.$title, equals(Prop.maybeMix(TextStyler())));
        },
      );

      styleMethodTest(
        'trailingIcon',
        initial: RemixAccordionStyle<String>(),
        modify: (style) => style.trailingIcon(IconStyler()),
        expect: (style) {
          expect(style.$trailingIcon, equals(Prop.maybeMix(IconStyler())));
        },
      );

      styleMethodTest(
        'content',
        initial: RemixAccordionStyle<String>(),
        modify: (style) => style.content(BoxStyler()),
        expect: (style) {
          expect(style.$content, equals(Prop.maybeMix(BoxStyler())));
        },
      );

      styleMethodTest(
        'alignment',
        initial: RemixAccordionStyle<String>(),
        modify: (style) => style.alignment(Alignment.centerLeft),
        expect: (style) {
          expect(
            style.$trigger,
            equals(
              Prop.maybeMix(FlexBoxStyler(alignment: Alignment.centerLeft)),
            ),
          );
        },
      );

      styleMethodTest(
        'padding',
        initial: RemixAccordionStyle<String>(),
        modify: (style) => style.padding(EdgeInsetsGeometryMix.all(16.0)),
        expect: (style) {
          expect(
            style.$trigger,
            equals(
              Prop.maybeMix(
                FlexBoxStyler(padding: EdgeInsetsGeometryMix.all(16.0)),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'margin',
        initial: RemixAccordionStyle<String>(),
        modify: (style) => style.margin(EdgeInsetsGeometryMix.all(8.0)),
        expect: (style) {
          expect(
            style.$trigger,
            equals(
              Prop.maybeMix(
                FlexBoxStyler(margin: EdgeInsetsGeometryMix.all(8.0)),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'color',
        initial: RemixAccordionStyle<String>(),
        modify: (style) => style.color(Colors.blue),
        expect: (style) {
          expect(
            style.$trigger,
            equals(
              Prop.maybeMix(
                FlexBoxStyler(decoration: BoxDecorationMix(color: Colors.blue)),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'decoration',
        initial: RemixAccordionStyle<String>(),
        modify: (style) => style.decoration(
          BoxDecorationMix(
            color: Colors.red,
            borderRadius: BorderRadiusMix.circular(8.0),
          ),
        ),
        expect: (style) {
          expect(
            style.$trigger,
            equals(
              Prop.maybeMix(
                FlexBoxStyler(
                  decoration: BoxDecorationMix(
                    color: Colors.red,
                    borderRadius: BorderRadiusMix.circular(8.0),
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'constraints',
        initial: RemixAccordionStyle<String>(),
        modify: (style) => style.constraints(
          BoxConstraintsMix(minWidth: 100.0, minHeight: 40.0),
        ),
        expect: (style) {
          expect(
            style.$trigger,
            equals(
              Prop.maybeMix(
                FlexBoxStyler(
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
        'size',
        initial: RemixAccordionStyle<String>(),
        modify: (style) => style.size(200.0, 50.0),
        expect: (style) {
          expect(
            style.$trigger,
            equals(
              Prop.maybeMix(
                FlexBoxStyler(
                  constraints: BoxConstraintsMix(
                    minWidth: 200.0,
                    maxWidth: 200.0,
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
        'borderRadius',
        initial: RemixAccordionStyle<String>(),
        modify: (style) => style.borderRadius(BorderRadiusMix.circular(12.0)),
        expect: (style) {
          expect(
            style.$trigger,
            equals(
              Prop.maybeMix(
                FlexBoxStyler(
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
        'foregroundDecoration',
        initial: RemixAccordionStyle<String>(),
        modify: (style) => style.foregroundDecoration(
          BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(color: Colors.red)),
          ),
        ),
        expect: (style) {
          expect(
            style.$trigger,
            equals(
              Prop.maybeMix(
                FlexBoxStyler(
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
        initial: RemixAccordionStyle<String>(),
        modify: (style) =>
            style.transform(Matrix4.identity(), alignment: Alignment.topLeft),
        expect: (style) {
          expect(
            style.$trigger,
            equals(
              Prop.maybeMix(
                FlexBoxStyler(
                  transform: Matrix4.identity(),
                  transformAlignment: Alignment.topLeft,
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'flex',
        initial: RemixAccordionStyle<String>(),
        modify: (style) => style.flex(FlexStyler()),
        expect: (style) {
          expect(
            style.$trigger,
            equals(Prop.maybeMix(FlexBoxStyler().flex(FlexStyler()))),
          );
        },
      );

      styleMethodTest(
        'wrap',
        initial: RemixAccordionStyle<String>(),
        modify: (style) => style.wrap(WidgetModifierConfig.clipOval()),
        expect: (style) {
          expect(style.$modifier, equals(WidgetModifierConfig.clipOval()));
        },
      );

      styleMethodTest(
        'variants',
        initial: RemixAccordionStyle<String>(),
        modify: (style) =>
            style.variants(<VariantStyle<RemixAccordionSpec>>[]),
        expect: (style) {
          expect(style.$variants, equals(<VariantStyle<RemixAccordionSpec>>[]));
        },
      );
    });

    group('Core Methods', () {
      testWidgets('resolve method returns StyleSpec', (
        WidgetTester tester,
      ) async {
        final style = RemixAccordionStyle<String>();

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final spec = style.resolve(context);

                expect(spec, isA<StyleSpec<RemixAccordionSpec>>());
                expect(spec.spec, isA<RemixAccordionSpec>());
                expect(spec.spec.trigger, isA<StyleSpec<FlexBoxSpec>>());
                expect(spec.spec.leadingIcon, isA<StyleSpec<IconSpec>>());
                expect(spec.spec.title, isA<StyleSpec<TextSpec>>());
                expect(spec.spec.trailingIcon, isA<StyleSpec<IconSpec>>());
                expect(spec.spec.content, isA<StyleSpec<BoxSpec>>());

                return Container();
              },
            ),
          ),
        );
      });

      test('merge with null returns original instance', () {
        final originalStyle = RemixAccordionStyle<String>();

        final mergedStyle = originalStyle.merge(null);

        expect(mergedStyle, same(originalStyle));
      });

      test('merge combines two styles', () {
        final style1 = RemixAccordionStyle<String>().padding(
          EdgeInsetsGeometryMix.all(8.0),
        );
        final style2 = RemixAccordionStyle<String>().color(Colors.blue);

        final merged = style1.merge(style2);

        expect(merged, isNot(same(style1)));
        expect(merged, isNot(same(style2)));
        expect(merged.$trigger, isNotNull);
      });
    });

    group('Equality', () {
      test('identical styles are equal', () {
        final style1 = RemixAccordionStyle<String>();
        final style2 = RemixAccordionStyle<String>();

        expect(style1, equals(style2));
        expect(style1.hashCode, equals(style2.hashCode));
      });

      test('styles with different properties are not equal', () {
        final style1 = RemixAccordionStyle<String>().padding(
          EdgeInsetsGeometryMix.all(16.0),
        );
        final style2 = RemixAccordionStyle<String>().padding(
          EdgeInsetsGeometryMix.all(8.0),
        );

        expect(style1, isNot(equals(style2)));
      });
    });

    group('Props', () {
      test('props list contains all properties', () {
        final style = RemixAccordionStyle<String>();

        expect(style.props, hasLength(8));
        expect(style.props, contains(style.$trigger));
        expect(style.props, contains(style.$leadingIcon));
        expect(style.props, contains(style.$title));
        expect(style.props, contains(style.$trailingIcon));
        expect(style.props, contains(style.$content));
        expect(style.props, contains(style.$variants));
        expect(style.props, contains(style.$animation));
        expect(style.props, contains(style.$modifier));
      });
    });
  });
}
