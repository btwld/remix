import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_methods.dart';

void main() {
  group('RemixToggleStyle', () {
    group('Constructors', () {
      test('default constructor creates valid instance', () {
        final style = RemixToggleStyle();

        expect(style, isNotNull);
        expect(style, isA<RemixToggleStyle>());
      });

      test('create constructor with all parameters', () {
        final container = Prop.maybeMix(FlexBoxStyler());
        final label = Prop.maybeMix(TextStyler());
        final icon = Prop.maybeMix(IconStyler());
        final variants = <VariantStyle<RemixToggleSpec>>[];

        final style = RemixToggleStyle.create(
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

      test('constructor with styler parameters', () {
        final containerStyler = FlexBoxStyler();
        final labelStyler = TextStyler();
        final iconStyler = IconStyler();

        final style = RemixToggleStyle(
          container: containerStyler,
          label: labelStyler,
          icon: iconStyler,
        );

        expect(style, isNotNull);
        expect(style.$container, isNotNull);
        expect(style.$label, isNotNull);
        expect(style.$icon, isNotNull);
      });
    });

    group('Style Methods', () {
      styleMethodTest(
        'alignment',
        initial: RemixToggleStyle(),
        modify: (style) => style.alignment(Alignment.center),
        expect: (style) {
          expect(
            style.$container,
            equals(Prop.maybeMix(FlexBoxStyler(alignment: Alignment.center))),
          );
        },
      );

      styleMethodTest(
        'backgroundColor',
        initial: RemixToggleStyle(),
        modify: (style) => style.backgroundColor(Colors.blue),
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

      styleMethodTest(
        'padding',
        initial: RemixToggleStyle(),
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
        initial: RemixToggleStyle(),
        modify: (style) => style.margin(EdgeInsetsGeometryMix.all(8.0)),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(FlexBoxStyler(margin: EdgeInsetsGeometryMix.all(8.0))),
            ),
          );
        },
      );

      styleMethodTest(
        'constraints',
        initial: RemixToggleStyle(),
        modify: (style) => style.constraints(
          BoxConstraintsMix(minWidth: 20.0, minHeight: 20.0),
        ),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                FlexBoxStyler(
                  constraints: BoxConstraintsMix(
                    minWidth: 20.0,
                    minHeight: 20.0,
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'decoration',
        initial: RemixToggleStyle(),
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
        'foregroundDecoration',
        initial: RemixToggleStyle(),
        modify: (style) => style.foregroundDecoration(
          BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(color: Colors.red)),
          ),
        ),
        expect: (style) {
          expect(
            style.$container,
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
        initial: RemixToggleStyle(),
        modify: (style) =>
            style.transform(Matrix4.identity(), alignment: Alignment.topLeft),
        expect: (style) {
          expect(
            style.$container,
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
        'labelColor',
        initial: RemixToggleStyle(),
        modify: (style) => style.labelColor(Colors.white),
        expect: (style) {
          expect(
            style.$label,
            equals(
              Prop.maybeMix(
                TextStyler(style: TextStyleMix(color: Colors.white)),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'iconColor',
        initial: RemixToggleStyle(),
        modify: (style) => style.iconColor(Colors.blue),
        expect: (style) {
          expect(
            style.$icon,
            equals(Prop.maybeMix(IconStyler(color: Colors.blue))),
          );
        },
      );

      styleMethodTest(
        'iconSize',
        initial: RemixToggleStyle(),
        modify: (style) => style.iconSize(24.0),
        expect: (style) {
          expect(
            style.$icon,
            equals(Prop.maybeMix(IconStyler(size: 24.0))),
          );
        },
      );

      styleMethodTest(
        'variants',
        initial: RemixToggleStyle(),
        modify: (style) => style.variants(<VariantStyle<RemixToggleSpec>>[]),
        expect: (style) {
          expect(style.$variants, equals(<VariantStyle<RemixToggleSpec>>[]));
        },
      );

      styleMethodTest(
        'wrap',
        initial: RemixToggleStyle(),
        modify: (style) => style.wrap(WidgetModifierConfig.clipOval()),
        expect: (style) {
          expect(style.$modifier, equals(WidgetModifierConfig.clipOval()));
        },
      );

      styleMethodTest(
        'animate',
        initial: RemixToggleStyle(),
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

    group('Core Methods', () {
      testWidgets('resolve method returns StyleSpec', (
        WidgetTester tester,
      ) async {
        final style = RemixToggleStyle();

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final spec = style.resolve(context);

                expect(spec, isA<StyleSpec<RemixToggleSpec>>());
                expect(spec.spec, isA<RemixToggleSpec>());
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
        final originalStyle = RemixToggleStyle();

        final mergedStyle = originalStyle.merge(null);

        expect(mergedStyle, equals(originalStyle));
      });

      test('merge combines properties correctly', () {
        final style1 = RemixToggleStyle(
          container: FlexBoxStyler(alignment: Alignment.centerLeft),
        );
        final style2 = RemixToggleStyle(
          label: TextStyler(style: TextStyleMix(color: Colors.blue)),
        );

        final merged = style1.merge(style2);

        expect(
          merged.$container,
          equals(Prop.maybeMix(FlexBoxStyler(alignment: Alignment.centerLeft))),
        );
        expect(
          merged.$label,
          equals(
            Prop.maybeMix(TextStyler(style: TextStyleMix(color: Colors.blue))),
          ),
        );
      });
    });

    group('Call Method', () {
      testWidgets('call method creates RemixToggle with all parameters', (
        tester,
      ) async {
        final style = RemixToggleStyle().backgroundColor(Colors.blue);
        final focusNode = FocusNode();

        final toggleWidget = style.call(
          selected: true,
          onChanged: (value) {},
          label: 'Bold',
          icon: Icons.format_bold,
          enabled: false,
          enableFeedback: false,
          focusNode: focusNode,
          autofocus: true,
          semanticLabel: 'Test Toggle',
          mouseCursor: SystemMouseCursors.forbidden,
        );

        expect(toggleWidget, isA<RemixToggle>());
        expect(toggleWidget.selected, equals(true));
        expect(toggleWidget.label, equals('Bold'));
        expect(toggleWidget.icon, equals(Icons.format_bold));
        expect(toggleWidget.enabled, equals(false));
        expect(toggleWidget.enableFeedback, equals(false));
        expect(toggleWidget.focusNode, same(focusNode));
        expect(toggleWidget.autofocus, equals(true));
        expect(toggleWidget.semanticLabel, equals('Test Toggle'));
        expect(toggleWidget.mouseCursor, equals(SystemMouseCursors.forbidden));
        expect(toggleWidget.style, same(style));

        focusNode.dispose();
      });

      testWidgets('call method creates RemixToggle with minimal parameters', (
        tester,
      ) async {
        final style = RemixToggleStyle();

        final toggleWidget = style.call(
          selected: false,
          onChanged: (v) {},
          label: 'Test',
        );

        expect(toggleWidget, isA<RemixToggle>());
        expect(toggleWidget.selected, equals(false));
        expect(toggleWidget.enabled, equals(true));
        expect(toggleWidget.enableFeedback, equals(true));
        expect(toggleWidget.style, same(style));
      });
    });

    group('Equality', () {
      test('identical styles are equal', () {
        final style1 = RemixToggleStyle();
        final style2 = RemixToggleStyle();

        expect(style1, equals(style2));
        expect(style1.hashCode, equals(style2.hashCode));
      });

      test('styles with different properties are not equal', () {
        final style1 = RemixToggleStyle().backgroundColor(Colors.blue);
        final style2 = RemixToggleStyle().backgroundColor(Colors.red);

        expect(style1, isNot(equals(style2)));
      });

      test('props list contains all properties', () {
        final style = RemixToggleStyle();

        expect(style.props, hasLength(6));
        expect(style.props, contains(style.$container));
        expect(style.props, contains(style.$label));
        expect(style.props, contains(style.$icon));
        expect(style.props, contains(style.$variants));
        expect(style.props, contains(style.$animation));
        expect(style.props, contains(style.$modifier));
      });
    });
  });
}
