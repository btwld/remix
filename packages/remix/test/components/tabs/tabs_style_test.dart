import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../lib/remix.dart';

import '../../helpers/test_helpers.dart';
import '../../helpers/test_methods.dart';

void main() {
  group('RemixTabBarStyle', () {
    group('Constructors', () {
      test('create() constructs with null parameters', () {
        const style = RemixTabBarStyle.create();

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

        final style = RemixTabBarStyle.create(
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
        final style = RemixTabBarStyle(
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
        initial: RemixTabBarStyle(),
        modify: (style) => style.container(FlexBoxStyler()),
        expect: (style) {
          expect(style.$container, isNotNull);
        },
      );

      styleMethodTest(
        'alignment() adds alignment',
        initial: RemixTabBarStyle(),
        modify: (style) => style.alignment(Alignment.center),
        expect: (style) {
          expect(style.$container, isNotNull);
        },
      );

      styleMethodTest(
        'padding() adds padding',
        initial: RemixTabBarStyle(),
        modify: (style) => style.padding(EdgeInsetsGeometryMix.all(16)),
        expect: (style) {
          expect(style.$container, isNotNull);
        },
      );

      styleMethodTest(
        'color() adds background color',
        initial: RemixTabBarStyle(),
        modify: (style) => style.color(Colors.blue),
        expect: (style) {
          expect(style.$container, isNotNull);
        },
      );

      styleMethodTest(
        'size() sets width and height',
        initial: RemixTabBarStyle(),
        modify: (style) => style.size(100, 50),
        expect: (style) {
          expect(style.$container, isNotNull);
        },
      );

      styleMethodTest(
        'borderRadius() adds border radius',
        initial: RemixTabBarStyle(),
        modify: (style) =>
            style.borderRadius(BorderRadiusGeometryMix.circular(8)),
        expect: (style) {
          expect(style.$container, isNotNull);
        },
      );

      styleMethodTest(
        'constraints() adds box constraints',
        initial: RemixTabBarStyle(),
        modify: (style) =>
            style.constraints(BoxConstraintsMix(minWidth: 100, maxWidth: 200)),
        expect: (style) {
          expect(style.$container, isNotNull);
        },
      );

      styleMethodTest(
        'decoration() adds decoration',
        initial: RemixTabBarStyle(),
        modify: (style) =>
            style.decoration(BoxDecorationMix(color: Colors.red)),
        expect: (style) {
          expect(style.$container, isNotNull);
        },
      );

      styleMethodTest(
        'margin() adds margin',
        initial: RemixTabBarStyle(),
        modify: (style) => style.margin(EdgeInsetsGeometryMix.all(8)),
        expect: (style) {
          expect(style.$container, isNotNull);
        },
      );

      styleMethodTest(
        'foregroundDecoration() adds foreground decoration',
        initial: RemixTabBarStyle(),
        modify: (style) =>
            style.foregroundDecoration(BoxDecorationMix(color: Colors.green)),
        expect: (style) {
          expect(style.$container, isNotNull);
        },
      );

      styleMethodTest(
        'transform() adds transform',
        initial: RemixTabBarStyle(),
        modify: (style) => style.transform(
          Matrix4.rotationZ(0.1),
          alignment: Alignment.topLeft,
        ),
        expect: (style) {
          expect(style.$container, isNotNull);
        },
      );

      styleMethodTest(
        'variants() adds variants',
        initial: RemixTabBarStyle(),
        modify: (style) => style.variants([]),
        expect: (style) {
          expect(style.$variants, isNotNull);
        },
      );

      styleMethodTest(
        'animate() adds animation config',
        initial: RemixTabBarStyle(),
        modify: (style) => style.animate(
          AnimationConfig.linear(const Duration(milliseconds: 300)),
        ),
        expect: (style) {
          expect(style.$animation, isNotNull);
        },
      );

      styleMethodTest(
        'wrap() adds widget modifier',
        initial: RemixTabBarStyle(),
        modify: (style) => style.wrap(WidgetModifierConfig()),
        expect: (style) {
          expect(style.$modifier, isNotNull);
        },
      );
    });

    group('Core Methods', () {
      testWidgets('resolve() creates StyleSpec', (tester) async {
        const style = RemixTabBarStyle.create();

        await tester.pumpMaterialApp(Container());
        final context = tester.element(find.byType(Container));

        final styleSpec = style.resolve(context);

        expect(styleSpec, isA<StyleSpec<RemixTabBarSpec>>());
        expect(styleSpec.spec, isA<RemixTabBarSpec>());
      });

      test('merge() combines two styles', () {
        final style1 = RemixTabBarStyle(container: FlexBoxStyler());
        final style2 = RemixTabBarStyle(
          animation: AnimationConfig.linear(const Duration(milliseconds: 200)),
        );

        final merged = style1.merge(style2);

        expect(merged.$container, isNotNull);
        expect(merged.$animation, isNotNull);
      });

      test('merge() with null returns original', () {
        final style = RemixTabBarStyle(container: FlexBoxStyler());
        final merged = style.merge(null);

        expect(merged, equals(style));
      });
    });

    group('Equality', () {
      test('two identical styles are equal', () {
        const style1 = RemixTabBarStyle.create();
        const style2 = RemixTabBarStyle.create();

        expect(style1, equals(style2));
        expect(style1.hashCode, equals(style2.hashCode));
      });

      test('two styles with different properties are not equal', () {
        final style1 = RemixTabBarStyle(container: FlexBoxStyler());
        const style2 = RemixTabBarStyle.create();

        expect(style1, isNot(equals(style2)));
      });
    });
  });

  group('RemixTabViewStyle', () {
    group('Constructors', () {
      test('create() constructs with null parameters', () {
        const style = RemixTabViewStyle.create();

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

        final style = RemixTabViewStyle.create(
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
        final style = RemixTabViewStyle(
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
        initial: RemixTabViewStyle(),
        modify: (style) => style.alignment(Alignment.center),
        expect: (style) {
          expect(style.$container, isNotNull);
        },
      );

      styleMethodTest(
        'padding() adds padding',
        initial: RemixTabViewStyle(),
        modify: (style) => style.padding(EdgeInsetsGeometryMix.all(16)),
        expect: (style) {
          expect(style.$container, isNotNull);
        },
      );

      styleMethodTest(
        'color() adds background color',
        initial: RemixTabViewStyle(),
        modify: (style) => style.color(Colors.blue),
        expect: (style) {
          expect(style.$container, isNotNull);
        },
      );

      styleMethodTest(
        'borderRadius() adds border radius',
        initial: RemixTabViewStyle(),
        modify: (style) =>
            style.borderRadius(BorderRadiusGeometryMix.circular(8)),
        expect: (style) {
          expect(style.$container, isNotNull);
        },
      );

      styleMethodTest(
        'constraints() adds box constraints',
        initial: RemixTabViewStyle(),
        modify: (style) =>
            style.constraints(BoxConstraintsMix(minWidth: 100, maxWidth: 200)),
        expect: (style) {
          expect(style.$container, isNotNull);
        },
      );

      styleMethodTest(
        'decoration() adds decoration',
        initial: RemixTabViewStyle(),
        modify: (style) =>
            style.decoration(BoxDecorationMix(color: Colors.red)),
        expect: (style) {
          expect(style.$container, isNotNull);
        },
      );

      styleMethodTest(
        'margin() adds margin',
        initial: RemixTabViewStyle(),
        modify: (style) => style.margin(EdgeInsetsGeometryMix.all(8)),
        expect: (style) {
          expect(style.$container, isNotNull);
        },
      );

      styleMethodTest(
        'foregroundDecoration() adds foreground decoration',
        initial: RemixTabViewStyle(),
        modify: (style) =>
            style.foregroundDecoration(BoxDecorationMix(color: Colors.green)),
        expect: (style) {
          expect(style.$container, isNotNull);
        },
      );

      styleMethodTest(
        'transform() adds transform',
        initial: RemixTabViewStyle(),
        modify: (style) => style.transform(
          Matrix4.rotationZ(0.1),
          alignment: Alignment.topLeft,
        ),
        expect: (style) {
          expect(style.$container, isNotNull);
        },
      );

      styleMethodTest(
        'variants() adds variants',
        initial: RemixTabViewStyle(),
        modify: (style) => style.variants([]),
        expect: (style) {
          expect(style.$variants, isNotNull);
        },
      );

      styleMethodTest(
        'animate() adds animation config',
        initial: RemixTabViewStyle(),
        modify: (style) => style.animate(
          AnimationConfig.linear(const Duration(milliseconds: 300)),
        ),
        expect: (style) {
          expect(style.$animation, isNotNull);
        },
      );

      styleMethodTest(
        'wrap() adds widget modifier',
        initial: RemixTabViewStyle(),
        modify: (style) => style.wrap(WidgetModifierConfig()),
        expect: (style) {
          expect(style.$modifier, isNotNull);
        },
      );
    });

    group('Core Methods', () {
      testWidgets('resolve() creates StyleSpec', (tester) async {
        const style = RemixTabViewStyle.create();

        await tester.pumpMaterialApp(Container());
        final context = tester.element(find.byType(Container));

        final styleSpec = style.resolve(context);

        expect(styleSpec, isA<StyleSpec<RemixTabViewSpec>>());
        expect(styleSpec.spec, isA<RemixTabViewSpec>());
      });

      test('merge() combines two styles', () {
        final style1 = RemixTabViewStyle(container: BoxStyler());
        final style2 = RemixTabViewStyle(
          animation: AnimationConfig.linear(const Duration(milliseconds: 200)),
        );

        final merged = style1.merge(style2);

        expect(merged.$container, isNotNull);
        expect(merged.$animation, isNotNull);
      });

      test('merge() with null returns original', () {
        final style = RemixTabViewStyle(container: BoxStyler());
        final merged = style.merge(null);

        expect(merged, equals(style));
      });
    });

    group('Equality', () {
      test('two identical styles are equal', () {
        const style1 = RemixTabViewStyle.create();
        const style2 = RemixTabViewStyle.create();

        expect(style1, equals(style2));
        expect(style1.hashCode, equals(style2.hashCode));
      });

      test('two styles with different properties are not equal', () {
        final style1 = RemixTabViewStyle(container: BoxStyler());
        const style2 = RemixTabViewStyle.create();

        expect(style1, isNot(equals(style2)));
      });
    });
  });

  group('RemixTabStyle', () {
    group('Constructors', () {
      test('create() constructs with null parameters', () {
        const style = RemixTabStyle.create();

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

        final style = RemixTabStyle.create(
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
        final style = RemixTabStyle(
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
        initial: RemixTabStyle(),
        modify: (style) => style.container(FlexBoxStyler()),
        expect: (style) {
          expect(style.$container, isNotNull);
        },
      );

      styleMethodTest(
        'label() adds label styling',
        initial: RemixTabStyle(),
        modify: (style) => style.label(TextStyler()),
        expect: (style) {
          expect(style.$label, isNotNull);
        },
      );

      styleMethodTest(
        'icon() adds icon styling',
        initial: RemixTabStyle(),
        modify: (style) => style.icon(IconStyler()),
        expect: (style) {
          expect(style.$icon, isNotNull);
        },
      );

      styleMethodTest(
        'alignment() adds alignment',
        initial: RemixTabStyle(),
        modify: (style) => style.alignment(Alignment.center),
        expect: (style) {
          expect(style.$container, isNotNull);
        },
      );

      styleMethodTest(
        'padding() adds padding',
        initial: RemixTabStyle(),
        modify: (style) => style.padding(EdgeInsetsGeometryMix.all(16)),
        expect: (style) {
          expect(style.$container, isNotNull);
        },
      );

      styleMethodTest(
        'color() adds background color',
        initial: RemixTabStyle(),
        modify: (style) => style.color(Colors.blue),
        expect: (style) {
          expect(style.$container, isNotNull);
        },
      );

      styleMethodTest(
        'constraints() adds box constraints',
        initial: RemixTabStyle(),
        modify: (style) =>
            style.constraints(BoxConstraintsMix(minWidth: 100, maxWidth: 200)),
        expect: (style) {
          expect(style.$container, isNotNull);
        },
      );

      styleMethodTest(
        'decoration() adds decoration',
        initial: RemixTabStyle(),
        modify: (style) =>
            style.decoration(BoxDecorationMix(color: Colors.red)),
        expect: (style) {
          expect(style.$container, isNotNull);
        },
      );

      styleMethodTest(
        'margin() adds margin',
        initial: RemixTabStyle(),
        modify: (style) => style.margin(EdgeInsetsGeometryMix.all(8)),
        expect: (style) {
          expect(style.$container, isNotNull);
        },
      );

      styleMethodTest(
        'foregroundDecoration() adds foreground decoration',
        initial: RemixTabStyle(),
        modify: (style) =>
            style.foregroundDecoration(BoxDecorationMix(color: Colors.green)),
        expect: (style) {
          expect(style.$container, isNotNull);
        },
      );

      styleMethodTest(
        'transform() adds transform',
        initial: RemixTabStyle(),
        modify: (style) => style.transform(
          Matrix4.rotationZ(0.1),
          alignment: Alignment.topLeft,
        ),
        expect: (style) {
          expect(style.$container, isNotNull);
        },
      );

      styleMethodTest(
        'variants() adds variants',
        initial: RemixTabStyle(),
        modify: (style) => style.variants([]),
        expect: (style) {
          expect(style.$variants, isNotNull);
        },
      );

      styleMethodTest(
        'animate() adds animation config',
        initial: RemixTabStyle(),
        modify: (style) => style.animate(
          AnimationConfig.linear(const Duration(milliseconds: 300)),
        ),
        expect: (style) {
          expect(style.$animation, isNotNull);
        },
      );

      styleMethodTest(
        'wrap() adds widget modifier',
        initial: RemixTabStyle(),
        modify: (style) => style.wrap(WidgetModifierConfig()),
        expect: (style) {
          expect(style.$modifier, isNotNull);
        },
      );
    });

    group('Core Methods', () {
      testWidgets('resolve() creates StyleSpec', (tester) async {
        const style = RemixTabStyle.create();

        await tester.pumpMaterialApp(Container());
        final context = tester.element(find.byType(Container));

        final styleSpec = style.resolve(context);

        expect(styleSpec, isA<StyleSpec<RemixTabSpec>>());
        expect(styleSpec.spec, isA<RemixTabSpec>());
      });

      test('merge() combines two styles', () {
        final style1 = RemixTabStyle(container: FlexBoxStyler());
        final style2 = RemixTabStyle(
          label: TextStyler(),
          animation: AnimationConfig.linear(const Duration(milliseconds: 200)),
        );

        final merged = style1.merge(style2);

        expect(merged.$container, isNotNull);
        expect(merged.$label, isNotNull);
        expect(merged.$animation, isNotNull);
      });

      test('merge() with null returns original', () {
        final style = RemixTabStyle(container: FlexBoxStyler());
        final merged = style.merge(null);

        expect(merged, equals(style));
      });
    });

    group('Equality', () {
      test('two identical styles are equal', () {
        const style1 = RemixTabStyle.create();
        const style2 = RemixTabStyle.create();

        expect(style1, equals(style2));
        expect(style1.hashCode, equals(style2.hashCode));
      });

      test('two styles with different properties are not equal', () {
        final style1 = RemixTabStyle(container: FlexBoxStyler());
        const style2 = RemixTabStyle.create();

        expect(style1, isNot(equals(style2)));
      });
    });
  });
}
