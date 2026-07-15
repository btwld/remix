import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';
import '../../helpers/test_methods.dart';

void main() {
  group('RemixTabBarStyler', () {
    group('Constructors', () {
      test('create() constructs with null parameters', () {
        const style = RemixTabBarStyler.create();

        expect(style.$container, isNull);
        expect(style.$variants, isNull);
        expect(style.$animation, isNull);
        expect(style.$modifier, isNull);
      });

      test('create() constructs with provided parameters', () {
        final container = Prop.maybeMix(FlexBoxStyler());
        final variants = <VariantStyle<RemixTabBarSpec>>[];
        final animation = AnimationConfig.linear(
          const Duration(milliseconds: 200),
        );
        final modifier = WidgetModifierConfig();

        final style = RemixTabBarStyler.create(
          container: container,
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

        expect(style.$container, equals(container));
        expect(style.$variants, equals(variants));
        expect(style.$animation, equals(animation));
        expect(style.$modifier, equals(modifier));
      });

      test('default constructor converts types correctly', () {
        final style = RemixTabBarStyler(
          container: FlexBoxStyler(),
          animation: AnimationConfig.linear(const Duration(milliseconds: 200)),
          variants: [],
          modifier: WidgetModifierConfig(),
        );

        expect(style.$container, isNotNull);
        expect(style.$variants, isNotNull);
        expect(style.$animation, isNotNull);
        expect(style.$modifier, isNotNull);
      });
    });

    group('Style Methods', () {
      styleMethodTest(
        'container() adds container styling',
        initial: RemixTabBarStyler(),
        modify: (style) => style.container(FlexBoxStyler()),
        expect: (style) {
          expect(style.$container, isNotNull);
        },
      );

      styleMethodTest(
        'alignment() adds alignment',
        initial: RemixTabBarStyler(),
        modify: (style) => style.alignment(Alignment.center),
        expect: (style) {
          expect(style, equals(RemixTabBarStyler.alignment(Alignment.center)));
        },
      );

      styleMethodTest(
        'padding() adds padding',
        initial: RemixTabBarStyler(),
        modify: (style) => style.padding(EdgeInsetsGeometryMix.all(16)),
        expect: (style) {
          expect(
            style,
            equals(RemixTabBarStyler.padding(EdgeInsetsGeometryMix.all(16))),
          );
        },
      );

      styleMethodTest(
        'color() adds background color',
        initial: RemixTabBarStyler(),
        modify: (style) => style.color(Colors.blue),
        expect: (style) {
          expect(style, equals(RemixTabBarStyler.color(Colors.blue)));
        },
      );

      styleMethodTest(
        'size() sets width and height',
        initial: RemixTabBarStyler(),
        modify: (style) => style.size(100, 50),
        expect: (style) {
          expect(style, equals(RemixTabBarStyler.size(100, 50)));
        },
      );

      styleMethodTest(
        'borderRadius() adds border radius',
        initial: RemixTabBarStyler(),
        modify: (style) =>
            style.borderRadius(BorderRadiusGeometryMix.circular(8)),
        expect: (style) {
          expect(
            style,
            equals(
              RemixTabBarStyler.borderRadius(
                BorderRadiusGeometryMix.circular(8),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'constraints() adds box constraints',
        initial: RemixTabBarStyler(),
        modify: (style) =>
            style.constraints(BoxConstraintsMix(minWidth: 100, maxWidth: 200)),
        expect: (style) {
          expect(
            style,
            equals(
              RemixTabBarStyler.constraints(
                BoxConstraintsMix(minWidth: 100, maxWidth: 200),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'decoration() adds decoration',
        initial: RemixTabBarStyler(),
        modify: (style) =>
            style.decoration(BoxDecorationMix(color: Colors.red)),
        expect: (style) {
          expect(
            style,
            equals(
              RemixTabBarStyler.decoration(BoxDecorationMix(color: Colors.red)),
            ),
          );
        },
      );

      styleMethodTest(
        'margin() adds margin',
        initial: RemixTabBarStyler(),
        modify: (style) => style.margin(EdgeInsetsGeometryMix.all(8)),
        expect: (style) {
          expect(
            style,
            equals(RemixTabBarStyler.margin(EdgeInsetsGeometryMix.all(8))),
          );
        },
      );

      styleMethodTest(
        'foregroundDecoration() adds foreground decoration',
        initial: RemixTabBarStyler(),
        modify: (style) =>
            style.foregroundDecoration(BoxDecorationMix(color: Colors.green)),
        expect: (style) {
          expect(
            style,
            equals(
              RemixTabBarStyler.foregroundDecoration(
                BoxDecorationMix(color: Colors.green),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'transform() adds transform',
        initial: RemixTabBarStyler(),
        modify: (style) => style.transform(
          Matrix4.rotationZ(0.1),
          alignment: Alignment.topLeft,
        ),
        expect: (style) {
          expect(
            style,
            equals(
              RemixTabBarStyler.transform(
                Matrix4.rotationZ(0.1),
                alignment: Alignment.topLeft,
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'variants() adds variants',
        initial: RemixTabBarStyler(),
        modify: (style) => style.variants([]),
        expect: (style) {
          expect(style.$variants, isNotNull);
        },
      );

      styleMethodTest(
        'animate() adds animation config',
        initial: RemixTabBarStyler(),
        modify: (style) => style.animate(
          AnimationConfig.linear(const Duration(milliseconds: 300)),
        ),
        expect: (style) {
          expect(style.$animation, isNotNull);
        },
      );

      styleMethodTest(
        'wrap() adds widget modifier',
        initial: RemixTabBarStyler(),
        modify: (style) => style.wrap(WidgetModifierConfig()),
        expect: (style) {
          expect(style.$modifier, isNotNull);
        },
      );
    });

    group('Core Methods', () {
      testWidgets('resolve() creates StyleSpec', (tester) async {
        const style = RemixTabBarStyler.create();

        await tester.pumpMaterialApp(Container());
        final context = tester.element(find.byType(Container));

        final styleSpec = style.resolve(context);

        expect(styleSpec, isA<StyleSpec<RemixTabBarSpec>>());
        expect(styleSpec.spec, isA<RemixTabBarSpec>());
      });

      test('merge() combines two styles', () {
        final style1 = RemixTabBarStyler(container: FlexBoxStyler());
        final style2 = RemixTabBarStyler(
          animation: AnimationConfig.linear(const Duration(milliseconds: 200)),
        );

        final merged = style1.merge(style2);

        expect(merged.$container, isNotNull);
        expect(merged.$animation, isNotNull);
      });

      test('merge() with null returns original', () {
        final style = RemixTabBarStyler(container: FlexBoxStyler());
        final merged = style.merge(null);

        expect(merged, equals(style));
      });

      test('call() creates RemixTabBar with this style', () {
        final style = RemixTabBarStyler().padding(EdgeInsetsGeometryMix.all(8));

        final tabBar = style.call(child: const Text('Tabs'));

        expect(tabBar, isA<RemixTabBar>());
        expect(tabBar.style, same(style));
        expect(tabBar.child, isA<Text>());
      });
    });

    group('Equality', () {
      test('two identical styles are equal', () {
        const style1 = RemixTabBarStyler.create();
        const style2 = RemixTabBarStyler.create();

        expect(style1, equals(style2));
        expect(style1.hashCode, equals(style2.hashCode));
      });

      test('two styles with different properties are not equal', () {
        final style1 = RemixTabBarStyler(container: FlexBoxStyler());
        const style2 = RemixTabBarStyler.create();

        expect(style1, isNot(equals(style2)));
      });
    });
  });

  group('RemixTabViewStyler', () {
    group('Constructors', () {
      test('create() constructs with null parameters', () {
        const style = RemixTabViewStyler.create();

        expect(style.$container, isNull);
        expect(style.$variants, isNull);
        expect(style.$animation, isNull);
        expect(style.$modifier, isNull);
      });

      test('create() constructs with provided parameters', () {
        final container = Prop.maybeMix(BoxStyler());
        final variants = <VariantStyle<RemixTabViewSpec>>[];
        final animation = AnimationConfig.linear(
          const Duration(milliseconds: 200),
        );
        final modifier = WidgetModifierConfig();

        final style = RemixTabViewStyler.create(
          container: container,
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

        expect(style.$container, equals(container));
        expect(style.$variants, equals(variants));
        expect(style.$animation, equals(animation));
        expect(style.$modifier, equals(modifier));
      });

      test('default constructor converts types correctly', () {
        final style = RemixTabViewStyler(
          container: BoxStyler(),
          animation: AnimationConfig.linear(const Duration(milliseconds: 200)),
          variants: [],
          modifier: WidgetModifierConfig(),
        );

        expect(style.$container, isNotNull);
        expect(style.$variants, isNotNull);
        expect(style.$animation, isNotNull);
        expect(style.$modifier, isNotNull);
      });
    });

    group('Style Methods', () {
      styleMethodTest(
        'alignment() adds alignment',
        initial: RemixTabViewStyler(),
        modify: (style) => style.alignment(Alignment.center),
        expect: (style) {
          expect(style, equals(RemixTabViewStyler.alignment(Alignment.center)));
        },
      );

      styleMethodTest(
        'padding() adds padding',
        initial: RemixTabViewStyler(),
        modify: (style) => style.padding(EdgeInsetsGeometryMix.all(16)),
        expect: (style) {
          expect(
            style,
            equals(RemixTabViewStyler.padding(EdgeInsetsGeometryMix.all(16))),
          );
        },
      );

      styleMethodTest(
        'color() adds background color',
        initial: RemixTabViewStyler(),
        modify: (style) => style.color(Colors.blue),
        expect: (style) {
          expect(style, equals(RemixTabViewStyler.color(Colors.blue)));
        },
      );

      styleMethodTest(
        'borderRadius() adds border radius',
        initial: RemixTabViewStyler(),
        modify: (style) =>
            style.borderRadius(BorderRadiusGeometryMix.circular(8)),
        expect: (style) {
          expect(
            style,
            equals(
              RemixTabViewStyler.borderRadius(
                BorderRadiusGeometryMix.circular(8),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'constraints() adds box constraints',
        initial: RemixTabViewStyler(),
        modify: (style) =>
            style.constraints(BoxConstraintsMix(minWidth: 100, maxWidth: 200)),
        expect: (style) {
          expect(
            style,
            equals(
              RemixTabViewStyler.constraints(
                BoxConstraintsMix(minWidth: 100, maxWidth: 200),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'decoration() adds decoration',
        initial: RemixTabViewStyler(),
        modify: (style) =>
            style.decoration(BoxDecorationMix(color: Colors.red)),
        expect: (style) {
          expect(
            style,
            equals(
              RemixTabViewStyler.decoration(
                BoxDecorationMix(color: Colors.red),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'margin() adds margin',
        initial: RemixTabViewStyler(),
        modify: (style) => style.margin(EdgeInsetsGeometryMix.all(8)),
        expect: (style) {
          expect(
            style,
            equals(RemixTabViewStyler.margin(EdgeInsetsGeometryMix.all(8))),
          );
        },
      );

      styleMethodTest(
        'foregroundDecoration() adds foreground decoration',
        initial: RemixTabViewStyler(),
        modify: (style) =>
            style.foregroundDecoration(BoxDecorationMix(color: Colors.green)),
        expect: (style) {
          expect(
            style,
            equals(
              RemixTabViewStyler.foregroundDecoration(
                BoxDecorationMix(color: Colors.green),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'transform() adds transform',
        initial: RemixTabViewStyler(),
        modify: (style) => style.transform(
          Matrix4.rotationZ(0.1),
          alignment: Alignment.topLeft,
        ),
        expect: (style) {
          expect(
            style,
            equals(
              RemixTabViewStyler.transform(
                Matrix4.rotationZ(0.1),
                alignment: Alignment.topLeft,
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'variants() adds variants',
        initial: RemixTabViewStyler(),
        modify: (style) => style.variants([]),
        expect: (style) {
          expect(style.$variants, isNotNull);
        },
      );

      styleMethodTest(
        'animate() adds animation config',
        initial: RemixTabViewStyler(),
        modify: (style) => style.animate(
          AnimationConfig.linear(const Duration(milliseconds: 300)),
        ),
        expect: (style) {
          expect(style.$animation, isNotNull);
        },
      );

      styleMethodTest(
        'wrap() adds widget modifier',
        initial: RemixTabViewStyler(),
        modify: (style) => style.wrap(WidgetModifierConfig()),
        expect: (style) {
          expect(style.$modifier, isNotNull);
        },
      );
    });

    group('Core Methods', () {
      testWidgets('resolve() creates StyleSpec', (tester) async {
        const style = RemixTabViewStyler.create();

        await tester.pumpMaterialApp(Container());
        final context = tester.element(find.byType(Container));

        final styleSpec = style.resolve(context);

        expect(styleSpec, isA<StyleSpec<RemixTabViewSpec>>());
        expect(styleSpec.spec, isA<RemixTabViewSpec>());
      });

      test('merge() combines two styles', () {
        final style1 = RemixTabViewStyler(container: BoxStyler());
        final style2 = RemixTabViewStyler(
          animation: AnimationConfig.linear(const Duration(milliseconds: 200)),
        );

        final merged = style1.merge(style2);

        expect(merged.$container, isNotNull);
        expect(merged.$animation, isNotNull);
      });

      test('merge() with null returns original', () {
        final style = RemixTabViewStyler(container: BoxStyler());
        final merged = style.merge(null);

        expect(merged, equals(style));
      });

      test('call() creates RemixTabView with this style', () {
        final style = RemixTabViewStyler().padding(
          EdgeInsetsGeometryMix.all(8),
        );

        final tabView = style.call(
          tabId: 'overview',
          child: const Text('Overview'),
        );

        expect(tabView, isA<RemixTabView>());
        expect(tabView.style, same(style));
        expect(tabView.tabId, 'overview');
        expect(tabView.child, isA<Text>());
      });
    });

    group('Equality', () {
      test('two identical styles are equal', () {
        const style1 = RemixTabViewStyler.create();
        const style2 = RemixTabViewStyler.create();

        expect(style1, equals(style2));
        expect(style1.hashCode, equals(style2.hashCode));
      });

      test('two styles with different properties are not equal', () {
        final style1 = RemixTabViewStyler(container: BoxStyler());
        const style2 = RemixTabViewStyler.create();

        expect(style1, isNot(equals(style2)));
      });
    });
  });

  group('RemixTabStyler', () {
    group('Constructors', () {
      test('create() constructs with null parameters', () {
        const style = RemixTabStyler.create();

        expect(style.$container, isNull);
        expect(style.$label, isNull);
        expect(style.$icon, isNull);
        expect(style.$variants, isNull);
        expect(style.$animation, isNull);
        expect(style.$modifier, isNull);
      });

      test('create() constructs with provided parameters', () {
        final container = Prop.maybeMix(FlexBoxStyler());
        final label = Prop.maybeMix(TextStyler());
        final icon = Prop.maybeMix(IconStyler());
        final variants = <VariantStyle<RemixTabSpec>>[];
        final animation = AnimationConfig.linear(
          const Duration(milliseconds: 200),
        );
        final modifier = WidgetModifierConfig();

        final style = RemixTabStyler.create(
          container: container,
          label: label,
          icon: icon,
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

        expect(style.$container, equals(container));
        expect(style.$label, equals(label));
        expect(style.$icon, equals(icon));
        expect(style.$variants, equals(variants));
        expect(style.$animation, equals(animation));
        expect(style.$modifier, equals(modifier));
      });

      test('default constructor converts types correctly', () {
        final style = RemixTabStyler(
          container: FlexBoxStyler(),
          label: TextStyler(),
          icon: IconStyler(),
          animation: AnimationConfig.linear(const Duration(milliseconds: 200)),
          variants: [],
          modifier: WidgetModifierConfig(),
        );

        expect(style.$container, isNotNull);
        expect(style.$label, isNotNull);
        expect(style.$icon, isNotNull);
        expect(style.$variants, isNotNull);
        expect(style.$animation, isNotNull);
        expect(style.$modifier, isNotNull);
      });
    });

    group('Style Methods', () {
      styleMethodTest(
        'container() adds container styling',
        initial: RemixTabStyler(),
        modify: (style) => style.container(FlexBoxStyler()),
        expect: (style) {
          expect(style.$container, isNotNull);
        },
      );

      styleMethodTest(
        'label() adds label styling',
        initial: RemixTabStyler(),
        modify: (style) => style.label(TextStyler()),
        expect: (style) {
          expect(style.$label, isNotNull);
        },
      );

      styleMethodTest(
        'icon() adds icon styling',
        initial: RemixTabStyler(),
        modify: (style) => style.icon(IconStyler()),
        expect: (style) {
          expect(style.$icon, isNotNull);
        },
      );

      styleMethodTest(
        'alignment() adds alignment',
        initial: RemixTabStyler(),
        modify: (style) => style.alignment(Alignment.center),
        expect: (style) {
          expect(style, equals(RemixTabStyler.alignment(Alignment.center)));
        },
      );

      styleMethodTest(
        'padding() adds padding',
        initial: RemixTabStyler(),
        modify: (style) => style.padding(EdgeInsetsGeometryMix.all(16)),
        expect: (style) {
          expect(
            style,
            equals(RemixTabStyler.padding(EdgeInsetsGeometryMix.all(16))),
          );
        },
      );

      styleMethodTest(
        'color() adds background color',
        initial: RemixTabStyler(),
        modify: (style) => style.color(Colors.blue),
        expect: (style) {
          expect(style, equals(RemixTabStyler.color(Colors.blue)));
        },
      );

      styleMethodTest(
        'constraints() adds box constraints',
        initial: RemixTabStyler(),
        modify: (style) =>
            style.constraints(BoxConstraintsMix(minWidth: 100, maxWidth: 200)),
        expect: (style) {
          expect(
            style,
            equals(
              RemixTabStyler.constraints(
                BoxConstraintsMix(minWidth: 100, maxWidth: 200),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'decoration() adds decoration',
        initial: RemixTabStyler(),
        modify: (style) =>
            style.decoration(BoxDecorationMix(color: Colors.red)),
        expect: (style) {
          expect(
            style,
            equals(
              RemixTabStyler.decoration(BoxDecorationMix(color: Colors.red)),
            ),
          );
        },
      );

      styleMethodTest(
        'margin() adds margin',
        initial: RemixTabStyler(),
        modify: (style) => style.margin(EdgeInsetsGeometryMix.all(8)),
        expect: (style) {
          expect(
            style,
            equals(RemixTabStyler.margin(EdgeInsetsGeometryMix.all(8))),
          );
        },
      );

      styleMethodTest(
        'foregroundDecoration() adds foreground decoration',
        initial: RemixTabStyler(),
        modify: (style) =>
            style.foregroundDecoration(BoxDecorationMix(color: Colors.green)),
        expect: (style) {
          expect(
            style,
            equals(
              RemixTabStyler.foregroundDecoration(
                BoxDecorationMix(color: Colors.green),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'transform() adds transform',
        initial: RemixTabStyler(),
        modify: (style) => style.transform(
          Matrix4.rotationZ(0.1),
          alignment: Alignment.topLeft,
        ),
        expect: (style) {
          expect(
            style,
            equals(
              RemixTabStyler.transform(
                Matrix4.rotationZ(0.1),
                alignment: Alignment.topLeft,
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'variants() adds variants',
        initial: RemixTabStyler(),
        modify: (style) => style.variants([]),
        expect: (style) {
          expect(style.$variants, isNotNull);
        },
      );

      styleMethodTest(
        'animate() adds animation config',
        initial: RemixTabStyler(),
        modify: (style) => style.animate(
          AnimationConfig.linear(const Duration(milliseconds: 300)),
        ),
        expect: (style) {
          expect(style.$animation, isNotNull);
        },
      );

      styleMethodTest(
        'wrap() adds widget modifier',
        initial: RemixTabStyler(),
        modify: (style) => style.wrap(WidgetModifierConfig()),
        expect: (style) {
          expect(style.$modifier, isNotNull);
        },
      );
    });

    group('Core Methods', () {
      testWidgets('resolve() creates StyleSpec', (tester) async {
        const style = RemixTabStyler.create();

        await tester.pumpMaterialApp(Container());
        final context = tester.element(find.byType(Container));

        final styleSpec = style.resolve(context);

        expect(styleSpec, isA<StyleSpec<RemixTabSpec>>());
        expect(styleSpec.spec, isA<RemixTabSpec>());
      });

      test('merge() combines two styles', () {
        final style1 = RemixTabStyler(container: FlexBoxStyler());
        final style2 = RemixTabStyler(
          label: TextStyler(),
          animation: AnimationConfig.linear(const Duration(milliseconds: 200)),
        );

        final merged = style1.merge(style2);

        expect(merged.$container, isNotNull);
        expect(merged.$label, isNotNull);
        expect(merged.$animation, isNotNull);
      });

      test('merge() with null returns original', () {
        final style = RemixTabStyler(container: FlexBoxStyler());
        final merged = style.merge(null);

        expect(merged, equals(style));
      });

      test('call() creates RemixTab with this style', () {
        final style = RemixTabStyler().padding(EdgeInsetsGeometryMix.all(8));

        final tab = style.call(
          tabId: 'overview',
          label: 'Overview',
          icon: Icons.info,
          enabled: false,
        );

        expect(tab, isA<RemixTab>());
        expect(tab.style, same(style));
        expect(tab.tabId, 'overview');
        expect(tab.label, 'Overview');
        expect(tab.icon, Icons.info);
        expect(tab.enabled, isFalse);
      });
    });

    group('Equality', () {
      test('two identical styles are equal', () {
        const style1 = RemixTabStyler.create();
        const style2 = RemixTabStyler.create();

        expect(style1, equals(style2));
        expect(style1.hashCode, equals(style2.hashCode));
      });

      test('two styles with different properties are not equal', () {
        final style1 = RemixTabStyler(container: FlexBoxStyler());
        const style2 = RemixTabStyler.create();

        expect(style1, isNot(equals(style2)));
      });
    });
  });
}
