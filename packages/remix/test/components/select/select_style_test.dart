import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../lib/remix.dart';

import '../../helpers/test_methods.dart';

void main() {
  group('RemixSelectStyle', () {
    group('Constructors', () {
      test('default constructor creates valid instance', () {
        final style = RemixSelectStyle();

        expect(style, isNotNull);
        expect(style, isA<RemixSelectStyle>());
      });

      test('create constructor with all parameters', () {
        final menuContainer = Prop.maybeMix(FlexBoxStyler());
        final trigger = Prop.maybeMix(RemixSelectTriggerStyle());
        final variants = <VariantStyle<RemixSelectSpec>>[];

        final style = RemixSelectStyle.create(
          menuContainer: menuContainer,
          trigger: trigger,
          variants: variants,
        );

        expect(style, isNotNull);
        expect(style.$menuContainer, equals(menuContainer));
        expect(style.$trigger, equals(trigger));
        expect(style.$variants, equals(variants));
      });

      test('constructor with styler parameters', () {
        final menuContainerStyler = FlexBoxStyler();
        final triggerStyler = RemixSelectTriggerStyle();

        final style = RemixSelectStyle(
          menuContainer: menuContainerStyler,
          trigger: triggerStyler,
        );

        expect(style, isNotNull);
        expect(style.$menuContainer, isNotNull);
        expect(style.$trigger, isNotNull);
      });
    });

    group('Style Methods', () {
      styleMethodTest(
        'menuContainer',
        initial: RemixSelectStyle(),
        modify: (style) => style.menuContainer(
          FlexBoxStyler(padding: EdgeInsetsGeometryMix.all(8.0)),
        ),
        expect: (style) {
          expect(
            style.$menuContainer,
            equals(
              Prop.maybeMix(
                FlexBoxStyler(padding: EdgeInsetsGeometryMix.all(8.0)),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'trigger',
        initial: RemixSelectStyle(),
        modify: (style) => style.trigger(
          RemixSelectTriggerStyle().alignment(Alignment.center),
        ),
        expect: (style) {
          expect(
            style.$trigger,
            equals(
              Prop.maybeMix(
                RemixSelectTriggerStyle().alignment(Alignment.center),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'foregroundDecoration',
        initial: RemixSelectStyle(),
        modify: (style) => style.foregroundDecoration(
          BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(color: Colors.red)),
          ),
        ),
        expect: (style) {
          expect(
            style.$menuContainer,
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
        initial: RemixSelectStyle(),
        modify: (style) =>
            style.transform(Matrix4.identity(), alignment: Alignment.topLeft),
        expect: (style) {
          expect(
            style.$menuContainer,
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
        'variants',
        initial: RemixSelectStyle(),
        modify: (style) => style.variants(<VariantStyle<RemixSelectSpec>>[]),
        expect: (style) {
          expect(style.$variants, equals(<VariantStyle<RemixSelectSpec>>[]));
        },
      );

      styleMethodTest(
        'wrap',
        initial: RemixSelectStyle(),
        modify: (style) => style.wrap(WidgetModifierConfig.clipOval()),
        expect: (style) {
          expect(style.$modifier, equals(WidgetModifierConfig.clipOval()));
        },
      );

      styleMethodTest(
        'animate',
        initial: RemixSelectStyle(),
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

    group('Call Method', () {
      test('call method creates RemixSelect with required parameters', () {
        final style = RemixSelectStyle();
        final trigger = RemixSelectTrigger(placeholder: 'Select');
        final items = [
          RemixSelectItem(value: 'a', label: 'A'),
          RemixSelectItem(value: 'b', label: 'B'),
        ];

        final select = style.call<String>(trigger: trigger, items: items);

        expect(select, isA<RemixSelect<String>>());
        expect(select.trigger, equals(trigger));
        expect(select.items, equals(items));
        expect(select.enabled, isTrue);
        expect(select.closeOnSelect, isTrue);
      });

      test('call method creates RemixSelect with all parameters', () {
        final style = RemixSelectStyle();
        final trigger = RemixSelectTrigger(placeholder: 'Select');
        final items = [RemixSelectItem(value: 1, label: 'One')];
        final focusNode = FocusNode();

        final select = style.call<int>(
          trigger: trigger,
          items: items,
          selectedValue: 1,
          onChanged: (value) {},
          onOpen: () {},
          onClose: () {},
          enabled: false,
          closeOnSelect: false,
          semanticLabel: 'Test Select',
          focusNode: focusNode,
        );

        expect(select, isA<RemixSelect<int>>());
        expect(select.selectedValue, equals(1));
        expect(select.enabled, isFalse);
        expect(select.closeOnSelect, isFalse);
        expect(select.semanticLabel, equals('Test Select'));
        expect(select.focusNode, equals(focusNode));
      });
    });

    group('Core Methods', () {
      testWidgets('resolve method returns StyleSpec', (
        WidgetTester tester,
      ) async {
        final style = RemixSelectStyle();

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final spec = style.resolve(context);

                expect(spec, isA<StyleSpec<RemixSelectSpec>>());
                expect(spec.spec, isA<RemixSelectSpec>());
                expect(
                  spec.spec.trigger,
                  isA<StyleSpec<RemixSelectTriggerSpec>>(),
                );
                expect(spec.spec.menuContainer, isA<StyleSpec<FlexBoxSpec>>());

                return Container();
              },
            ),
          ),
        );
      });

      test('merge with null returns original instance', () {
        final originalStyle = RemixSelectStyle();

        final mergedStyle = originalStyle.merge(null);

        expect(mergedStyle, same(originalStyle));
      });
    });

    group('Equality', () {
      test('identical styles are equal', () {
        final style1 = RemixSelectStyle();
        final style2 = RemixSelectStyle();

        expect(style1, equals(style2));
        expect(style1.hashCode, equals(style2.hashCode));
      });

      test('styles with different properties are not equal', () {
        final style1 = RemixSelectStyle().menuContainer(
          FlexBoxStyler(padding: EdgeInsetsGeometryMix.all(8.0)),
        );
        final style2 = RemixSelectStyle().menuContainer(
          FlexBoxStyler(padding: EdgeInsetsGeometryMix.all(16.0)),
        );

        expect(style1, isNot(equals(style2)));
      });
    });
  });

  group('RemixSelectTriggerStyle', () {
    group('Constructors', () {
      test('default constructor creates valid instance', () {
        final style = RemixSelectTriggerStyle();

        expect(style, isNotNull);
        expect(style, isA<RemixSelectTriggerStyle>());
      });

      test('create constructor with all parameters', () {
        final container = Prop.maybeMix(FlexBoxStyler());
        final label = Prop.maybeMix(TextStyler());
        final icon = Prop.maybeMix(IconStyler());
        final variants = <VariantStyle<RemixSelectTriggerSpec>>[];

        final style = RemixSelectTriggerStyle.create(
          container: container,
          label: label,
          icon: icon,
          variants: variants,
        );

        expect(style, isNotNull);
        expect(style.$container, equals(container));
        expect(style.$label, equals(label));
        expect(style.$icon, equals(icon));
        expect(style.$variants, equals(variants));
      });
    });

    group('Style Methods', () {
      styleMethodTest(
        'label',
        initial: RemixSelectTriggerStyle(),
        modify: (style) =>
            style.label(TextStyler(style: TextStyleMix(color: Colors.blue))),
        expect: (style) {
          expect(
            style.$label,
            equals(
              Prop.maybeMix(
                TextStyler(style: TextStyleMix(color: Colors.blue)),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'icon',
        initial: RemixSelectTriggerStyle(),
        modify: (style) => style.icon(IconStyler(color: Colors.red)),
        expect: (style) {
          expect(
            style.$icon,
            equals(Prop.maybeMix(IconStyler(color: Colors.red))),
          );
        },
      );

      styleMethodTest(
        'alignment',
        initial: RemixSelectTriggerStyle(),
        modify: (style) => style.alignment(Alignment.center),
        expect: (style) {
          expect(
            style.$container,
            equals(Prop.maybeMix(FlexBoxStyler(alignment: Alignment.center))),
          );
        },
      );

      styleMethodTest(
        'padding',
        initial: RemixSelectTriggerStyle(),
        modify: (style) => style.padding(EdgeInsetsGeometryMix.all(16.0)),
        expect: (style) {
          expect(
            style.$container,
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
        initial: RemixSelectTriggerStyle(),
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
        'decoration',
        initial: RemixSelectTriggerStyle(),
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
                FlexBoxStyler(
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
        'constraints',
        initial: RemixSelectTriggerStyle(),
        modify: (style) => style.constraints(
          BoxConstraintsMix(minWidth: 100.0, minHeight: 50.0),
        ),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                FlexBoxStyler(
                  constraints: BoxConstraintsMix(
                    minWidth: 100.0,
                    minHeight: 50.0,
                  ),
                ),
              ),
            ),
          );
        },
      );
    });

    group('Core Methods', () {
      testWidgets('resolve method returns StyleSpec', (
        WidgetTester tester,
      ) async {
        final style = RemixSelectTriggerStyle();

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final spec = style.resolve(context);

                expect(spec, isA<StyleSpec<RemixSelectTriggerSpec>>());
                expect(spec.spec, isA<RemixSelectTriggerSpec>());
                expect(spec.spec.container, isA<StyleSpec<FlexBoxSpec>>());
                expect(spec.spec.label, isA<StyleSpec<TextSpec>>());
                expect(spec.spec.icon, isA<StyleSpec<IconSpec>>());

                return Container();
              },
            ),
          ),
        );
      });

      test('merge with null returns original instance', () {
        final originalStyle = RemixSelectTriggerStyle();

        final mergedStyle = originalStyle.merge(null);

        expect(mergedStyle, same(originalStyle));
      });
    });

    group('Equality', () {
      test('identical styles are equal', () {
        final style1 = RemixSelectTriggerStyle();
        final style2 = RemixSelectTriggerStyle();

        expect(style1, equals(style2));
        expect(style1.hashCode, equals(style2.hashCode));
      });

      test('styles with different properties are not equal', () {
        final style1 = RemixSelectTriggerStyle().label(
          TextStyler(style: TextStyleMix(color: Colors.blue)),
        );
        final style2 = RemixSelectTriggerStyle().label(
          TextStyler(style: TextStyleMix(color: Colors.red)),
        );

        expect(style1, isNot(equals(style2)));
      });
    });
  });

  group('RemixSelectMenuItemStyle', () {
    group('Constructors', () {
      test('default constructor creates valid instance', () {
        final style = RemixSelectMenuItemStyle();

        expect(style, isNotNull);
        expect(style, isA<RemixSelectMenuItemStyle>());
      });

      test('create constructor with all parameters', () {
        final container = Prop.maybeMix(FlexBoxStyler());
        final text = Prop.maybeMix(TextStyler());
        final icon = Prop.maybeMix(IconStyler());
        final variants = <VariantStyle<RemixSelectMenuItemSpec>>[];

        final style = RemixSelectMenuItemStyle.create(
          container: container,
          text: text,
          icon: icon,
          variants: variants,
        );

        expect(style, isNotNull);
        expect(style.$container, equals(container));
        expect(style.$text, equals(text));
        expect(style.$icon, equals(icon));
        expect(style.$variants, equals(variants));
      });
    });

    group('Style Methods', () {
      styleMethodTest(
        'text',
        initial: RemixSelectMenuItemStyle(),
        modify: (style) =>
            style.text(TextStyler(style: TextStyleMix(color: Colors.blue))),
        expect: (style) {
          expect(
            style.$text,
            equals(
              Prop.maybeMix(
                TextStyler(style: TextStyleMix(color: Colors.blue)),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'icon',
        initial: RemixSelectMenuItemStyle(),
        modify: (style) => style.icon(IconStyler(color: Colors.red)),
        expect: (style) {
          expect(
            style.$icon,
            equals(Prop.maybeMix(IconStyler(color: Colors.red))),
          );
        },
      );

      styleMethodTest(
        'alignment',
        initial: RemixSelectMenuItemStyle(),
        modify: (style) => style.alignment(Alignment.center),
        expect: (style) {
          expect(
            style.$container,
            equals(Prop.maybeMix(FlexBoxStyler(alignment: Alignment.center))),
          );
        },
      );

      styleMethodTest(
        'label delegates to text',
        initial: RemixSelectMenuItemStyle(),
        modify: (style) =>
            style.label(TextStyler(style: TextStyleMix(color: Colors.green))),
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
        'padding',
        initial: RemixSelectMenuItemStyle(),
        modify: (style) => style.padding(EdgeInsetsGeometryMix.all(16.0)),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                FlexBoxStyler(padding: EdgeInsetsGeometryMix.all(16.0)),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'decoration',
        initial: RemixSelectMenuItemStyle(),
        modify: (style) =>
            style.decoration(BoxDecorationMix(color: Colors.blue)),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                FlexBoxStyler(decoration: BoxDecorationMix(color: Colors.blue)),
              ),
            ),
          );
        },
      );
    });

    group('Core Methods', () {
      testWidgets('resolve method returns StyleSpec', (
        WidgetTester tester,
      ) async {
        final style = RemixSelectMenuItemStyle();

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final spec = style.resolve(context);

                expect(spec, isA<StyleSpec<RemixSelectMenuItemSpec>>());
                expect(spec.spec, isA<RemixSelectMenuItemSpec>());
                expect(spec.spec.container, isA<StyleSpec<FlexBoxSpec>>());
                expect(spec.spec.text, isA<StyleSpec<TextSpec>>());
                expect(spec.spec.icon, isA<StyleSpec<IconSpec>>());

                return Container();
              },
            ),
          ),
        );
      });

      test('merge with null returns original instance', () {
        final originalStyle = RemixSelectMenuItemStyle();

        final mergedStyle = originalStyle.merge(null);

        expect(mergedStyle, same(originalStyle));
      });
    });

    group('Equality', () {
      test('identical styles are equal', () {
        final style1 = RemixSelectMenuItemStyle();
        final style2 = RemixSelectMenuItemStyle();

        expect(style1, equals(style2));
        expect(style1.hashCode, equals(style2.hashCode));
      });

      test('styles with different properties are not equal', () {
        final style1 = RemixSelectMenuItemStyle().text(
          TextStyler(style: TextStyleMix(color: Colors.blue)),
        );
        final style2 = RemixSelectMenuItemStyle().text(
          TextStyler(style: TextStyleMix(color: Colors.red)),
        );

        expect(style1, isNot(equals(style2)));
      });
    });
  });
}
