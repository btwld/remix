import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../lib/remix.dart';

import '../../helpers/test_methods.dart';

void main() {
  group('RemixAccordionStyle', () {
    group('Constructors', () {
      test('default constructor creates valid instance', () {
        final style = RemixAccordionStyle();

        expect(style, isNotNull);
        expect(style, isA<RemixAccordionStyle>());
      });

      test('create constructor with all parameters', () {
        final trigger = Prop.maybeMix(FlexBoxStyler());
        final leadingIcon = Prop.maybeMix(IconStyler());
        final title = Prop.maybeMix(TextStyler());
        final trailingIcon = Prop.maybeMix(IconStyler());
        final content = Prop.maybeMix(BoxStyler());
        final variants = <VariantStyle<RemixAccordionSpec>>[];

        final style = RemixAccordionStyle.create(
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
        final leadingIconStyler = IconStyler();
        final titleStyler = TextStyler();
        final trailingIconStyler = IconStyler();
        final contentStyler = BoxStyler();

        final style = RemixAccordionStyle(
          trigger: triggerStyler,
          leadingIcon: leadingIconStyler,
          title: titleStyler,
          trailingIcon: trailingIconStyler,
          content: contentStyler,
        );

        expect(style, isNotNull);
        expect(style.$trigger, isNotNull);
        expect(style.$leadingIcon, isNotNull);
        expect(style.$title, isNotNull);
        expect(style.$trailingIcon, isNotNull);
        expect(style.$content, isNotNull);
      });
    });

    group('Style Methods', () {
      styleMethodTest(
        'trigger',
        initial: RemixAccordionStyle(),
        modify: (style) => style.trigger(FlexBoxStyler()),
        expect: (style) {
          expect(style.$trigger, Prop.maybeMix(FlexBoxStyler()));
        },
      );

      styleMethodTest(
        'leadingIcon',
        initial: RemixAccordionStyle(),
        modify: (style) => style.leadingIcon(IconStyler()),
        expect: (style) {
          expect(style.$leadingIcon, equals(Prop.maybeMix(IconStyler())));
        },
      );

      styleMethodTest(
        'title',
        initial: RemixAccordionStyle(),
        modify: (style) => style.title(TextStyler()),
        expect: (style) {
          expect(style.$title, equals(Prop.maybeMix(TextStyler())));
        },
      );

      styleMethodTest(
        'trailingIcon',
        initial: RemixAccordionStyle(),
        modify: (style) => style.trailingIcon(IconStyler()),
        expect: (style) {
          expect(style.$trailingIcon, equals(Prop.maybeMix(IconStyler())));
        },
      );

      styleMethodTest(
        'content',
        initial: RemixAccordionStyle(),
        modify: (style) => style.content(BoxStyler()),
        expect: (style) {
          expect(style.$content, equals(Prop.maybeMix(BoxStyler())));
        },
      );

      styleMethodTest(
        'alignment',
        initial: RemixAccordionStyle(),
        modify: (style) => style.alignment(Alignment.center),
        expect: (style) {
          expect(style.$trigger, isNotNull);
        },
      );
    });

    group('Variant Methods', () {
      test('onExpanded creates variant style', () {
        final baseStyle = RemixAccordionStyle();
        final expandedStyle = RemixAccordionStyle(
          title: TextStyler(),
        );

        final result = baseStyle.onExpanded(expandedStyle);

        expect(result, isNotNull);
        expect(result.$variants, isNotEmpty);
        expect(result.$variants!.first.variant.name, equals('onExpanded'));
      });

      test('onCollapsed creates variant style', () {
        final baseStyle = RemixAccordionStyle();
        final collapsedStyle = RemixAccordionStyle(
          title: TextStyler(),
        );

        final result = baseStyle.onCollapsed(collapsedStyle);

        expect(result, isNotNull);
        expect(result.$variants, isNotEmpty);
        expect(result.$variants!.first.variant.name, equals('onCollapsed'));
      });

      test('onCanCollapse creates variant style', () {
        final baseStyle = RemixAccordionStyle();
        final canCollapseStyle = RemixAccordionStyle(
          title: TextStyler(),
        );

        final result = baseStyle.onCanCollapse(canCollapseStyle);

        expect(result, isNotNull);
        expect(result.$variants, isNotEmpty);
        expect(result.$variants!.first.variant.name, equals('onCanCollapse'));
      });

      test('onCanExpand creates variant style', () {
        final baseStyle = RemixAccordionStyle();
        final canExpandStyle = RemixAccordionStyle(
          title: TextStyler(),
        );

        final result = baseStyle.onCanExpand(canExpandStyle);

        expect(result, isNotNull);
        expect(result.$variants, isNotEmpty);
        expect(result.$variants!.first.variant.name, equals('onCanExpand'));
      });

      test('multiple variants can be combined', () {
        final baseStyle = RemixAccordionStyle();
        final expandedStyle = RemixAccordionStyle(title: TextStyler());
        final collapsedStyle = RemixAccordionStyle(leadingIcon: IconStyler());

        final result = baseStyle
            .onExpanded(expandedStyle)
            .onCollapsed(collapsedStyle);

        expect(result, isNotNull);
        expect(result.$variants, isNotEmpty);
        expect(result.$variants!.length, greaterThanOrEqualTo(2));
      });
    });

    group('Resolve Method', () {
      testWidgets('resolve returns StyleSpec with RemixAccordionSpec',
          (tester) async {
        final style = RemixAccordionStyle();

        await tester.pumpWidget(
          createRemixScope(
            child: MaterialApp(
              home: Builder(
                builder: (context) {
                  final resolved = style.resolve(context);
                  expect(resolved, isA<StyleSpec<RemixAccordionSpec>>());
                  expect(resolved.spec, isA<RemixAccordionSpec>());
                  return const SizedBox();
                },
              ),
            ),
          ),
        );
      });

      testWidgets('resolve with custom trigger style', (tester) async {
        final style = RemixAccordionStyle(
          trigger: FlexBoxStyler(),
        );

        await tester.pumpWidget(
          createRemixScope(
            child: MaterialApp(
              home: Builder(
                builder: (context) {
                  final resolved = style.resolve(context);
                  expect(resolved.spec, isA<RemixAccordionSpec>());
                  expect(resolved.spec.trigger, isA<StyleSpec<FlexBoxSpec>>());
                  return const SizedBox();
                },
              ),
            ),
          ),
        );
      });

      testWidgets('resolve with all style properties', (tester) async {
        final style = RemixAccordionStyle(
          trigger: FlexBoxStyler(),
          leadingIcon: IconStyler(),
          title: TextStyler(),
          trailingIcon: IconStyler(),
          content: BoxStyler(),
        );

        await tester.pumpWidget(
          createRemixScope(
            child: MaterialApp(
              home: Builder(
                builder: (context) {
                  final resolved = style.resolve(context);
                  final spec = resolved.spec;

                  expect(spec, isA<RemixAccordionSpec>());
                  expect(spec.trigger, isA<StyleSpec<FlexBoxSpec>>());
                  expect(spec.leadingIcon, isA<StyleSpec<IconSpec>>());
                  expect(spec.title, isA<StyleSpec<TextSpec>>());
                  expect(spec.trailingIcon, isA<StyleSpec<IconSpec>>());
                  expect(spec.content, isA<StyleSpec<BoxSpec>>());
                  return const SizedBox();
                },
              ),
            ),
          ),
        );
      });
    });

    group('Merge Method', () {
      test('merge combines two styles', () {
        final style1 = RemixAccordionStyle(
          trigger: FlexBoxStyler(),
        );
        final style2 = RemixAccordionStyle(
          title: TextStyler(),
        );

        final merged = style1.merge(style2);

        expect(merged, isNotNull);
        expect(merged.$trigger, isNotNull);
        expect(merged.$title, isNotNull);
      });

      test('merge preserves original styles', () {
        final style1 = RemixAccordionStyle(
          trigger: FlexBoxStyler(),
          leadingIcon: IconStyler(),
        );
        final style2 = RemixAccordionStyle(
          title: TextStyler(),
        );

        final merged = style1.merge(style2);

        expect(merged.$trigger, isNotNull);
        expect(merged.$leadingIcon, isNotNull);
        expect(merged.$title, isNotNull);
      });

      test('merge with empty style returns original', () {
        final style1 = RemixAccordionStyle(
          trigger: FlexBoxStyler(),
        );
        final style2 = RemixAccordionStyle();

        final merged = style1.merge(style2);

        expect(merged, isNotNull);
        expect(merged.$trigger, isNotNull);
      });
    });

    group('Equality', () {
      test('styles with same properties are equal', () {
        final style1 = RemixAccordionStyle();
        final style2 = RemixAccordionStyle();

        expect(style1, equals(style2));
      });

      test('styles with different properties are not equal', () {
        final style1 = RemixAccordionStyle();
        final style2 = RemixAccordionStyle(
          trigger: FlexBoxStyler(),
        );

        expect(style1, isNot(equals(style2)));
      });

      test('hashCode is consistent with equality', () {
        final style1 = RemixAccordionStyle();
        final style2 = RemixAccordionStyle();

        expect(style1.hashCode, equals(style2.hashCode));
      });
    });

    group('Props', () {
      test('props list contains all style properties', () {
        final style = RemixAccordionStyle(
          trigger: FlexBoxStyler(),
          leadingIcon: IconStyler(),
          title: TextStyler(),
          trailingIcon: IconStyler(),
          content: BoxStyler(),
        );

        expect(style.props, isNotEmpty);
        expect(style.props, contains(style.$trigger));
        expect(style.props, contains(style.$leadingIcon));
        expect(style.props, contains(style.$title));
        expect(style.props, contains(style.$trailingIcon));
        expect(style.props, contains(style.$content));
      });

      test('props list is empty for default style', () {
        final style = RemixAccordionStyle();

        // Props should only contain non-null values
        final nonNullProps = style.props.where((p) => p != null).toList();
        expect(nonNullProps, isEmpty);
      });
    });

    group('Edge Cases', () {
      test('style with null values creates valid instance', () {
        const style = RemixAccordionStyle.create(
          trigger: null,
          leadingIcon: null,
          title: null,
          trailingIcon: null,
          content: null,
        );

        expect(style, isNotNull);
        expect(style.$trigger, isNull);
        expect(style.$leadingIcon, isNull);
        expect(style.$title, isNull);
        expect(style.$trailingIcon, isNull);
        expect(style.$content, isNull);
      });

      test('chaining multiple style methods works correctly', () {
        final style = RemixAccordionStyle()
            .trigger(FlexBoxStyler())
            .leadingIcon(IconStyler())
            .title(TextStyler())
            .trailingIcon(IconStyler())
            .content(BoxStyler());

        expect(style, isNotNull);
        expect(style.$trigger, isNotNull);
        expect(style.$leadingIcon, isNotNull);
        expect(style.$title, isNotNull);
        expect(style.$trailingIcon, isNotNull);
        expect(style.$content, isNotNull);
      });

      test('style with animation config', () {
        final style = RemixAccordionStyle.create(
          animation: const AnimationConfig(
            duration: Duration(milliseconds: 200),
          ),
        );

        expect(style, isNotNull);
        expect(style.$animation, isNotNull);
      });

      test('style with modifier config', () {
        final style = RemixAccordionStyle.create(
          modifier: WidgetModifierConfig(),
        );

        expect(style, isNotNull);
        expect(style.$modifier, isNotNull);
      });
    });
  });
}
