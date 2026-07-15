import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_methods.dart';

void main() {
  group('RemixSelectStyler', () {
    group('Constructors', () {
      test('default constructor creates valid instance', () {
        final style = RemixSelectStyler();

        expect(style, isNotNull);
        expect(style, isA<RemixSelectStyler>());
      });

      test('create constructor with all parameters', () {
        final menuContainer = Prop.maybeMix(FlexBoxStyler());
        final trigger = Prop.maybeMix(RemixSelectTriggerStyler());
        final variants = <VariantStyle<RemixSelectSpec>>[];

        final style = RemixSelectStyler.create(
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
        final triggerStyler = RemixSelectTriggerStyler();

        final style = RemixSelectStyler(
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
        initial: RemixSelectStyler(),
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
        initial: RemixSelectStyler(),
        modify: (style) => style.trigger(
          RemixSelectTriggerStyler().alignment(Alignment.center),
        ),
        expect: (style) {
          expect(
            style.$trigger,
            equals(
              Prop.maybeMix(
                RemixSelectTriggerStyler().alignment(Alignment.center),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'foregroundDecoration',
        initial: RemixSelectStyler(),
        modify: (style) => style.foregroundDecoration(
          BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(color: Colors.red)),
          ),
        ),
        expect: (style) {
          expect(
            style,
            equals(
              RemixSelectStyler.foregroundDecoration(
                BoxDecorationMix(
                  border: BoxBorderMix.all(BorderSideMix(color: Colors.red)),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'transform',
        initial: RemixSelectStyler(),
        modify: (style) =>
            style.transform(Matrix4.identity(), alignment: Alignment.topLeft),
        expect: (style) {
          expect(
            style,
            equals(
              RemixSelectStyler.transform(
                Matrix4.identity(),
                alignment: Alignment.topLeft,
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'variants',
        initial: RemixSelectStyler(),
        modify: (style) => style.variants(<VariantStyle<RemixSelectSpec>>[]),
        expect: (style) {
          expect(style.$variants, equals(<VariantStyle<RemixSelectSpec>>[]));
        },
      );

      styleMethodTest(
        'wrap',
        initial: RemixSelectStyler(),
        modify: (style) => style.wrap(.clipOval()),
        expect: (style) {
          expect(style.$modifier, equals(WidgetModifierConfig.clipOval()));
        },
      );

      styleMethodTest(
        'animate',
        initial: RemixSelectStyler(),
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
        final style = RemixSelectStyler();
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
        final style = RemixSelectStyler();
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
        final style = RemixSelectStyler();

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

      test('merge with null returns style equal to original', () {
        final originalStyle = RemixSelectStyler();

        final mergedStyle = originalStyle.merge(null);

        expect(mergedStyle, equals(originalStyle));
      });
    });

    group('Equality', () {
      test('identical styles are equal', () {
        final style1 = RemixSelectStyler();
        final style2 = RemixSelectStyler();

        expect(style1, equals(style2));
        expect(style1.hashCode, equals(style2.hashCode));
      });

      test('styles with different properties are not equal', () {
        final style1 = RemixSelectStyler().menuContainer(
          FlexBoxStyler(padding: EdgeInsetsGeometryMix.all(8.0)),
        );
        final style2 = RemixSelectStyler().menuContainer(
          FlexBoxStyler(padding: EdgeInsetsGeometryMix.all(16.0)),
        );

        expect(style1, isNot(equals(style2)));
      });
    });
  });

  group('RemixSelectTriggerStyler', () {
    group('Constructors', () {
      test('default constructor creates valid instance', () {
        final style = RemixSelectTriggerStyler();

        expect(style, isNotNull);
        expect(style, isA<RemixSelectTriggerStyler>());
      });

      test('create constructor with all parameters', () {
        final container = Prop.maybeMix(FlexBoxStyler());
        final label = Prop.maybeMix(TextStyler());
        final icon = Prop.maybeMix(IconStyler());
        final variants = <VariantStyle<RemixSelectTriggerSpec>>[];

        final style = RemixSelectTriggerStyler.create(
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
        initial: RemixSelectTriggerStyler(),
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
        initial: RemixSelectTriggerStyler(),
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
        initial: RemixSelectTriggerStyler(),
        modify: (style) => style.alignment(Alignment.center),
        expect: (style) {
          expect(
            style,
            equals(RemixSelectTriggerStyler.alignment(Alignment.center)),
          );
        },
      );

      styleMethodTest(
        'padding',
        initial: RemixSelectTriggerStyler(),
        modify: (style) => style.padding(EdgeInsetsGeometryMix.all(16.0)),
        expect: (style) {
          expect(
            style,
            equals(
              RemixSelectTriggerStyler.padding(EdgeInsetsGeometryMix.all(16.0)),
            ),
          );
        },
      );

      styleMethodTest(
        'margin',
        initial: RemixSelectTriggerStyler(),
        modify: (style) => style.margin(EdgeInsetsGeometryMix.all(8.0)),
        expect: (style) {
          expect(
            style,
            equals(
              RemixSelectTriggerStyler.margin(EdgeInsetsGeometryMix.all(8.0)),
            ),
          );
        },
      );

      styleMethodTest(
        'decoration',
        initial: RemixSelectTriggerStyler(),
        modify: (style) => style.decoration(
          BoxDecorationMix(
            color: Colors.blue,
            borderRadius: BorderRadiusMix.circular(8.0),
          ),
        ),
        expect: (style) {
          expect(
            style,
            equals(
              RemixSelectTriggerStyler.decoration(
                BoxDecorationMix(
                  color: Colors.blue,
                  borderRadius: BorderRadiusMix.circular(8.0),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'constraints',
        initial: RemixSelectTriggerStyler(),
        modify: (style) => style.constraints(
          BoxConstraintsMix(minWidth: 100.0, minHeight: 50.0),
        ),
        expect: (style) {
          expect(
            style,
            equals(
              RemixSelectTriggerStyler.constraints(
                BoxConstraintsMix(minWidth: 100.0, minHeight: 50.0),
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
        final style = RemixSelectTriggerStyler();

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

      test('merge with null returns style equal to original', () {
        final originalStyle = RemixSelectTriggerStyler();

        final mergedStyle = originalStyle.merge(null);

        expect(mergedStyle, equals(originalStyle));
      });
    });

    group('Equality', () {
      test('identical styles are equal', () {
        final style1 = RemixSelectTriggerStyler();
        final style2 = RemixSelectTriggerStyler();

        expect(style1, equals(style2));
        expect(style1.hashCode, equals(style2.hashCode));
      });

      test('styles with different properties are not equal', () {
        final style1 = RemixSelectTriggerStyler().label(
          TextStyler(style: TextStyleMix(color: Colors.blue)),
        );
        final style2 = RemixSelectTriggerStyler().label(
          TextStyler(style: TextStyleMix(color: Colors.red)),
        );

        expect(style1, isNot(equals(style2)));
      });
    });
  });

  group('RemixSelectMenuItemStyler', () {
    group('Constructors', () {
      test('default constructor creates valid instance', () {
        final style = RemixSelectMenuItemStyler();

        expect(style, isNotNull);
        expect(style, isA<RemixSelectMenuItemStyler>());
      });

      test('create constructor with all parameters', () {
        final container = Prop.maybeMix(FlexBoxStyler());
        final text = Prop.maybeMix(TextStyler());
        final icon = Prop.maybeMix(IconStyler());
        final variants = <VariantStyle<RemixSelectMenuItemSpec>>[];

        final style = RemixSelectMenuItemStyler.create(
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
        initial: RemixSelectMenuItemStyler(),
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
        initial: RemixSelectMenuItemStyler(),
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
        initial: RemixSelectMenuItemStyler(),
        modify: (style) => style.alignment(Alignment.center),
        expect: (style) {
          expect(
            style,
            equals(RemixSelectMenuItemStyler.alignment(Alignment.center)),
          );
        },
      );

      styleMethodTest(
        'label delegates to text',
        initial: RemixSelectMenuItemStyler(),
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
        initial: RemixSelectMenuItemStyler(),
        modify: (style) => style.padding(EdgeInsetsGeometryMix.all(16.0)),
        expect: (style) {
          expect(
            style,
            equals(
              RemixSelectMenuItemStyler.padding(
                EdgeInsetsGeometryMix.all(16.0),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'decoration',
        initial: RemixSelectMenuItemStyler(),
        modify: (style) =>
            style.decoration(BoxDecorationMix(color: Colors.blue)),
        expect: (style) {
          expect(
            style,
            equals(
              RemixSelectMenuItemStyler.decoration(
                BoxDecorationMix(color: Colors.blue),
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
        final style = RemixSelectMenuItemStyler();

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

      test('merge with null returns style equal to original', () {
        final originalStyle = RemixSelectMenuItemStyler();

        final mergedStyle = originalStyle.merge(null);

        expect(mergedStyle, equals(originalStyle));
      });
    });

    group('Equality', () {
      test('identical styles are equal', () {
        final style1 = RemixSelectMenuItemStyler();
        final style2 = RemixSelectMenuItemStyler();

        expect(style1, equals(style2));
        expect(style1.hashCode, equals(style2.hashCode));
      });

      test('styles with different properties are not equal', () {
        final style1 = RemixSelectMenuItemStyler().text(
          TextStyler(style: TextStyleMix(color: Colors.blue)),
        );
        final style2 = RemixSelectMenuItemStyler().text(
          TextStyler(style: TextStyleMix(color: Colors.red)),
        );

        expect(style1, isNot(equals(style2)));
      });
    });
  });
}
