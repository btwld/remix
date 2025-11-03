import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../lib/remix.dart';

import '../../helpers/test_helpers.dart';
import '../../helpers/test_methods.dart';

void main() {
  group('RemixTextFieldStyle', () {
    group('Constructors', () {
      test('create() constructs with null parameters', () {
        const style = RemixTextFieldStyle.create();

        expect(style.$text, isNull);
        expect(style.$hintText, isNull);
        expect(style.$textAlign, isNull);
        expect(style.$cursorWidth, isNull);
        expect(style.$cursorHeight, isNull);
        expect(style.$cursorRadius, isNull);
        expect(style.$cursorColor, isNull);
        expect(style.$cursorOffset, isNull);
        expect(style.$cursorOpacityAnimates, isNull);
        expect(style.$selectionHeightStyle, isNull);
        expect(style.$selectionWidthStyle, isNull);
        expect(style.$scrollPadding, isNull);
        expect(style.$keyboardAppearance, isNull);
        expect(style.$spacing, isNull);
        expect(style.$container, isNull);
        expect(style.$helperText, isNull);
        expect(style.$label, isNull);
        expect(style.$variants, isNull);
        expect(style.$animation, isNull);
        expect(style.$modifier, isNull);
      });

      test('create() constructs with provided parameters', () {
        final text = Prop.maybeMix(TextStyler());
        final hintText = Prop.maybeMix(TextStyler());
        final textAlign = Prop.maybe(TextAlign.center);
        final cursorWidth = Prop.maybe(3.0);
        final cursorHeight = Prop.maybe(20.0);
        final cursorRadius = Prop.maybe(const Radius.circular(2));
        final cursorColor = Prop.maybe(Colors.blue);
        final cursorOffset = Prop.maybe(const Offset(1, 0));
        final cursorOpacityAnimates = Prop.maybe(true);
        final selectionHeightStyle = Prop.maybe(BoxHeightStyle.max);
        final selectionWidthStyle = Prop.maybe(BoxWidthStyle.max);
        final scrollPadding = Prop.maybe(const EdgeInsets.all(10));
        final keyboardAppearance = Prop.maybe(Brightness.dark);
        final spacing = Prop.maybe(8.0);
        final container = Prop.maybeMix(FlexBoxStyler());
        final helperText = Prop.maybeMix(TextStyler());
        final label = Prop.maybeMix(TextStyler());
        final variants = <VariantStyle<RemixTextFieldSpec>>[];
        final animation = AnimationConfig.linear(
          const Duration(milliseconds: 200),
        );
        final modifier = WidgetModifierConfig();

        final style = RemixTextFieldStyle.create(
          text: text,
          hintText: hintText,
          textAlign: textAlign,
          cursorWidth: cursorWidth,
          cursorHeight: cursorHeight,
          cursorRadius: cursorRadius,
          cursorColor: cursorColor,
          cursorOffset: cursorOffset,
          cursorOpacityAnimates: cursorOpacityAnimates,
          selectionHeightStyle: selectionHeightStyle,
          selectionWidthStyle: selectionWidthStyle,
          scrollPadding: scrollPadding,
          keyboardAppearance: keyboardAppearance,
          spacing: spacing,
          container: container,
          helperText: helperText,
          label: label,
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

        expect(style.$text, equals(text));
        expect(style.$hintText, equals(hintText));
        expect(style.$textAlign, equals(textAlign));
        expect(style.$cursorWidth, equals(cursorWidth));
        expect(style.$cursorHeight, equals(cursorHeight));
        expect(style.$cursorRadius, equals(cursorRadius));
        expect(style.$cursorColor, equals(cursorColor));
        expect(style.$cursorOffset, equals(cursorOffset));
        expect(style.$cursorOpacityAnimates, equals(cursorOpacityAnimates));
        expect(style.$selectionHeightStyle, equals(selectionHeightStyle));
        expect(style.$selectionWidthStyle, equals(selectionWidthStyle));
        expect(style.$scrollPadding, equals(scrollPadding));
        expect(style.$keyboardAppearance, equals(keyboardAppearance));
        expect(style.$spacing, equals(spacing));
        expect(style.$container, equals(container));
        expect(style.$helperText, equals(helperText));
        expect(style.$label, equals(label));
        expect(style.$variants, equals(variants));
        expect(style.$animation, equals(animation));
        expect(style.$modifier, equals(modifier));
      });

      test('default constructor converts types correctly', () {
        final style = RemixTextFieldStyle(
          text: TextStyler(),
          hintText: TextStyler(),
          textAlign: TextAlign.center,
          cursorWidth: 3.0,
          cursorHeight: 20.0,
          cursorRadius: const Radius.circular(2),
          cursorColor: Colors.blue,
          cursorOffset: const Offset(1, 0),
          cursorOpacityAnimates: true,
          selectionHeightStyle: BoxHeightStyle.max,
          selectionWidthStyle: BoxWidthStyle.max,
          scrollPadding: const EdgeInsets.all(10),
          keyboardAppearance: Brightness.dark,
          spacing: 8.0,
          container: FlexBoxStyler(),
          helperText: TextStyler(),
          label: TextStyler(),
          animation: AnimationConfig.linear(const Duration(milliseconds: 200)),
          variants: [],
          modifier: WidgetModifierConfig(),
        );

        expect(style.$text, isNotNull);
        expect(style.$hintText, isNotNull);
        expect(style.$textAlign, isNotNull);
        expect(style.$cursorWidth, isNotNull);
        expect(style.$cursorHeight, isNotNull);
        expect(style.$cursorRadius, isNotNull);
        expect(style.$cursorColor, isNotNull);
        expect(style.$cursorOffset, isNotNull);
        expect(style.$cursorOpacityAnimates, isNotNull);
        expect(style.$selectionHeightStyle, isNotNull);
        expect(style.$selectionWidthStyle, isNotNull);
        expect(style.$scrollPadding, isNotNull);
        expect(style.$keyboardAppearance, isNotNull);
        expect(style.$spacing, isNotNull);
        expect(style.$container, isNotNull);
        expect(style.$helperText, isNotNull);
        expect(style.$label, isNotNull);
        expect(style.$variants, isNotNull);
        expect(style.$animation, isNotNull);
        expect(style.$modifier, isNotNull);
      });
    });

    group('Style Methods', () {
      styleMethodTest(
        'color() sets text color',
        initial: RemixTextFieldStyle(),
        modify: (style) => style.color(Colors.blue),
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
        'backgroundColor() sets background color',
        initial: RemixTextFieldStyle(),
        modify: (style) => style.backgroundColor(Colors.grey),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                FlexBoxStyler(decoration: BoxDecorationMix(color: Colors.grey)),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'container() sets container styling',
        initial: RemixTextFieldStyle(),
        modify: (style) => style.container(FlexBoxStyler()),
        expect: (style) {
          expect(style.$container, equals(Prop.maybeMix(FlexBoxStyler())));
        },
      );

      styleMethodTest(
        'borderRadius() sets border radius',
        initial: RemixTextFieldStyle(),
        modify: (style) =>
            style.borderRadius(BorderRadiusGeometryMix.circular(8)),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                FlexBoxStyler(
                  decoration: BoxDecorationMix(
                    borderRadius: BorderRadiusGeometryMix.circular(8),
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'padding() sets padding',
        initial: RemixTextFieldStyle(),
        modify: (style) => style.padding(EdgeInsetsGeometryMix.all(16)),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                FlexBoxStyler(padding: EdgeInsetsGeometryMix.all(16)),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'border() sets border',
        initial: RemixTextFieldStyle(),
        modify: (style) => style.border(
          BoxBorderMix.all(BorderSideMix(color: Colors.black, width: 1)),
        ),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                FlexBoxStyler(
                  decoration: BoxDecorationMix(
                    border: BoxBorderMix.all(
                      BorderSideMix(color: Colors.black, width: 1),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'width() sets width',
        initial: RemixTextFieldStyle(),
        modify: (style) => style.width(200),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                FlexBoxStyler(
                  constraints: BoxConstraintsMix(minWidth: 200, maxWidth: 200),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'height() sets height',
        initial: RemixTextFieldStyle(),
        modify: (style) => style.height(50),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                FlexBoxStyler(
                  constraints: BoxConstraintsMix(minHeight: 50, maxHeight: 50),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'cursorColor() sets cursor color',
        initial: RemixTextFieldStyle(),
        modify: (style) => style.cursorColor(Color.fromARGB(255, 255, 0, 0)),
        expect: (style) {
          expect(
            style.$cursorColor,
            equals(Prop.maybe(Color.fromARGB(255, 255, 0, 0))),
          );
        },
      );

      styleMethodTest(
        'hintColor() sets hint text color',
        initial: RemixTextFieldStyle(),
        modify: (style) => style.hintColor(Colors.grey),
        expect: (style) {
          expect(
            style.$hintText,
            equals(
              Prop.maybeMix(
                TextStyler(style: TextStyleMix(color: Colors.grey)),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'hintText() sets hint text styling',
        initial: RemixTextFieldStyle(),
        modify: (style) => style.hintText(TextStyler()),
        expect: (style) {
          expect(style.$hintText, equals(Prop.maybeMix(TextStyler())));
        },
      );

      styleMethodTest(
        'margin() sets margin',
        initial: RemixTextFieldStyle(),
        modify: (style) => style.margin(EdgeInsetsGeometryMix.all(8)),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                FlexBoxStyler(margin: EdgeInsetsGeometryMix.all(8)),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'spacing() sets spacing',
        initial: RemixTextFieldStyle(),
        modify: (style) => style.spacing(12),
        expect: (style) {
          expect(
            style.$container,
            equals(Prop.maybeMix(FlexBoxStyler(spacing: 12))),
          );
        },
      );

      styleMethodTest(
        'decoration() sets decoration',
        initial: RemixTextFieldStyle(),
        modify: (style) =>
            style.decoration(BoxDecorationMix(color: Colors.red)),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                FlexBoxStyler(decoration: BoxDecorationMix(color: Colors.red)),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'alignment() sets alignment',
        initial: RemixTextFieldStyle(),
        modify: (style) => style.alignment(Alignment.center),
        expect: (style) {
          expect(
            style.$container,
            equals(Prop.maybeMix(FlexBoxStyler(alignment: Alignment.center))),
          );
        },
      );

      styleMethodTest(
        'constraints() sets constraints',
        initial: RemixTextFieldStyle(),
        modify: (style) =>
            style.constraints(BoxConstraintsMix(minWidth: 100, maxWidth: 200)),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                FlexBoxStyler(
                  constraints: BoxConstraintsMix(minWidth: 100, maxWidth: 200),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'textAlign() sets text alignment',
        initial: RemixTextFieldStyle(),
        modify: (style) => style.textAlign(TextAlign.center),
        expect: (style) {
          expect(style.$textAlign, equals(Prop.maybe(TextAlign.center)));
        },
      );

      styleMethodTest(
        'helperText() sets helper text styling',
        initial: RemixTextFieldStyle(),
        modify: (style) => style.helperText(TextStyler().color(Colors.blue)),
        expect: (style) {
          expect(
            style.$helperText,
            equals(
              Prop.maybeMix(
                TextStyler(style: TextStyleMix(color: Colors.blue)),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'label() sets label styling',
        initial: RemixTextFieldStyle(),
        modify: (style) => style.label(TextStyler().color(Colors.blue)),
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
        'animate() adds animation config',
        initial: RemixTextFieldStyle(),
        modify: (style) => style.animate(
          AnimationConfig.linear(const Duration(milliseconds: 300)),
        ),
        expect: (style) {
          expect(
            style.$animation,
            equals(AnimationConfig.linear(const Duration(milliseconds: 300))),
          );
        },
      );

      styleMethodTest(
        'variants() adds variants',
        initial: RemixTextFieldStyle(),
        modify: (style) => style.variants([]),
        expect: (style) {
          expect(style.$variants, equals([]));
        },
      );

      styleMethodTest(
        'wrap() adds widget modifier',
        initial: RemixTextFieldStyle(),
        modify: (style) => style.wrap(WidgetModifierConfig.clipOval()),
        expect: (style) {
          expect(style.$modifier, equals(WidgetModifierConfig.clipOval()));
        },
      );

      styleMethodTest(
        'foregroundDecoration() adds foreground decoration',
        initial: RemixTextFieldStyle(),
        modify: (style) => style.foregroundDecoration(
          BoxDecorationMix(shape: BoxShape.circle),
        ),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                FlexBoxStyler(
                  foregroundDecoration: BoxDecorationMix(
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'transform() adds transform',
        initial: RemixTextFieldStyle(),
        modify: (style) => style.transform(
          Matrix4.rotationZ(0.1),
          alignment: Alignment.topLeft,
        ),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                FlexBoxStyler(
                  transform: Matrix4.rotationZ(0.1),
                  transformAlignment: Alignment.topLeft,
                ),
              ),
            ),
          );
        },
      );
    });

    group('Core Methods', () {
      testWidgets('resolve() creates StyleSpec', (tester) async {
        const style = RemixTextFieldStyle.create();

        await tester.pumpMaterialApp(Container());
        final context = tester.element(find.byType(Container));

        final styleSpec = style.resolve(context);

        expect(styleSpec, isA<StyleSpec<RemixTextFieldSpec>>());
        expect(styleSpec.spec, isA<RemixTextFieldSpec>());
      });

      test('merge() combines two styles', () {
        final style1 = RemixTextFieldStyle(text: TextStyler());
        final style2 = RemixTextFieldStyle(
          hintText: TextStyler(),
          animation: AnimationConfig.linear(const Duration(milliseconds: 200)),
        );

        final merged = style1.merge(style2);

        expect(merged.$text, isNotNull);
        expect(merged.$hintText, isNotNull);
        expect(merged.$animation, isNotNull);
      });

      test('merge() with null returns original', () {
        final style = RemixTextFieldStyle(text: TextStyler());
        final merged = style.merge(null);

        expect(merged, equals(style));
      });
    });

    group('Equality', () {
      test('two identical styles are equal', () {
        const style1 = RemixTextFieldStyle.create();
        const style2 = RemixTextFieldStyle.create();

        expect(style1, equals(style2));
        expect(style1.hashCode, equals(style2.hashCode));
      });

      test('two styles with different properties are not equal', () {
        final style1 = RemixTextFieldStyle(text: TextStyler());
        const style2 = RemixTextFieldStyle.create();

        expect(style1, isNot(equals(style2)));
      });
    });
  });
}
