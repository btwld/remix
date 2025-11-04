import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../lib/remix.dart';

import '../../helpers/test_methods.dart';

void main() {
  group('RemixButtonStyle', () {
    group('Constructors', () {
      test('default constructor creates valid instance', () {
        final style = RemixButtonStyle();

        expect(style, isNotNull);
        expect(style, isA<RemixButtonStyle>());
      });

      test('create constructor with all parameters', () {
        final container = Prop.maybeMix(FlexBoxStyler());
        final label = Prop.maybeMix(TextStyler());
        final icon = Prop.maybeMix(IconStyler());
        final spinner = Prop.maybeMix(RemixSpinnerStyle());
        final variants = <VariantStyle<RemixButtonSpec>>[];

        final style = RemixButtonStyle.create(
          container: container,
          label: label,
          icon: icon,
          spinner: spinner,
          variants: variants,
        );

        expect(style, isNotNull);
        expect(style.$container, equals(container));
        expect(style.$label, equals(label));
        expect(style.$icon, equals(icon));
        expect(style.$spinner, equals(spinner));
        expect(style.$variants, equals(variants));
      });

      test('constructor with styler parameters', () {
        final containerStyler = FlexBoxStyler();
        final labelStyler = TextStyler();
        final iconStyler = IconStyler();
        final spinnerStyle = RemixSpinnerStyle();

        final style = RemixButtonStyle(
          container: containerStyler,
          label: labelStyler,
          icon: iconStyler,
          spinner: spinnerStyle,
        );

        expect(style, isNotNull);
        expect(style.$container, isNotNull);
        expect(style.$label, isNotNull);
        expect(style.$icon, isNotNull);
        expect(style.$spinner, isNotNull);
      });
    });

    group('Style Methods', () {
      styleMethodTest(
        'label',
        initial: RemixButtonStyle(),
        modify: (style) => style.label(TextStyler()),
        expect: (style) {
          expect(style.$label, Prop.maybeMix(TextStyler()));
        },
      );

      styleMethodTest(
        'icon',
        initial: RemixButtonStyle(),
        modify: (style) => style.icon(IconStyler()),
        expect: (style) {
          expect(style.$icon, equals(Prop.maybeMix(IconStyler())));
        },
      );

      styleMethodTest(
        'spinner',
        initial: RemixButtonStyle(),
        modify: (style) => style.spinner(RemixSpinnerStyle()),
        expect: (style) {
          expect(style.$spinner, equals(Prop.maybeMix(RemixSpinnerStyle())));
        },
      );

      styleMethodTest(
        'padding',
        initial: RemixButtonStyle(),
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
        initial: RemixButtonStyle(),
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
        initial: RemixButtonStyle(),
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
        'alignment',
        initial: RemixButtonStyle(),
        modify: (style) => style.alignment(Alignment.centerLeft),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(FlexBoxStyler(alignment: Alignment.centerLeft)),
            ),
          );
        },
      );

      styleMethodTest(
        'spacing',
        initial: RemixButtonStyle(),
        modify: (style) => style.spacing(12.0),
        expect: (style) {
          expect(
            style.$container,
            equals(Prop.maybeMix(FlexBoxStyler(spacing: 12.0))),
          );
        },
      );

      styleMethodTest(
        'constraints',
        initial: RemixButtonStyle(),
        modify: (style) => style.constraints(
          BoxConstraintsMix(minWidth: 100.0, minHeight: 40.0),
        ),
        expect: (style) {
          expect(
            style.$container,
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
        'variants',
        initial: RemixButtonStyle(),
        modify: (style) => style.variants(<VariantStyle<RemixButtonSpec>>[]),
        expect: (style) {
          expect(style.$variants, equals(<VariantStyle<RemixButtonSpec>>[]));
        },
      );
      styleMethodTest(
        'flex',
        initial: RemixButtonStyle(),
        modify: (style) => style.flex(FlexStyler()),
        expect: (style) {
          expect(
            style.$container,
            equals(Prop.maybeMix(FlexBoxStyler().flex(FlexStyler()))),
          );
        },
      );

      styleMethodTest(
        'foregroundDecoration',
        initial: RemixButtonStyle(),
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
        initial: RemixButtonStyle(),
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
        'color',
        initial: RemixButtonStyle(),
        modify: (style) => style.color(Colors.blue),
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
        'wrap',
        initial: RemixButtonStyle(),
        modify: (style) => style.wrap(WidgetModifierConfig.clipOval()),
        expect: (style) {
          expect(style.$modifier, equals(WidgetModifierConfig.clipOval()));
        },
      );
    });

    group('Call Method', () {
      test('call method creates RemixButton with required parameters', () {
        final style = RemixButtonStyle();
        final onPressed = () {};

        final button = style.call(label: 'Test Button', onPressed: onPressed);

        expect(button, isA<RemixButton>());
        expect(button.label, equals('Test Button'));
        expect(button.onPressed, equals(onPressed));
      });

      test('call method creates RemixButton with all parameters', () {
        final style = RemixButtonStyle();
        final focusNode = FocusNode();

        final button = style.call(
          label: 'Test Button',
          icon: Icons.star,
          loading: true,
          enabled: false,
          enableFeedback: false,
          onPressed: () {},
          focusNode: focusNode,
        );

        expect(button, isA<RemixButton>());
        expect(button.label, equals('Test Button'));
        expect(button.icon, equals(Icons.star));
        expect(button.loading, isTrue);
        expect(button.enabled, isFalse);
        expect(button.enableFeedback, isFalse);
        expect(button.onPressed, isNotNull);
        expect(button.focusNode, equals(focusNode));
      });
    });

    group('Core Methods', () {
      testWidgets('resolve method returns StyleSpec', (
        WidgetTester tester,
      ) async {
        final style = RemixButtonStyle();

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final spec = style.resolve(context);

                expect(spec, isA<StyleSpec<RemixButtonSpec>>());
                expect(spec.spec, isA<RemixButtonSpec>());
                expect(spec.spec.container, isA<StyleSpec<FlexBoxSpec>>());
                expect(spec.spec.label, isA<StyleSpec<TextSpec>>());
                expect(spec.spec.icon, isA<StyleSpec<IconSpec>>());
                expect(spec.spec.spinner, isA<StyleSpec<RemixSpinnerSpec>>());

                return Container();
              },
            ),
          ),
        );
      });

      test('merge with null returns original instance', () {
        final originalStyle = RemixButtonStyle();

        final mergedStyle = originalStyle.merge(null);

        expect(mergedStyle, same(originalStyle));
      });
    });

    group('Equality', () {
      test('identical styles are equal', () {
        final style1 = RemixButtonStyle();
        final style2 = RemixButtonStyle();

        expect(style1, equals(style2));
        expect(style1.hashCode, equals(style2.hashCode));
      });

      test('styles with different properties are not equal', () {
        final style1 = RemixButtonStyle().padding(
          EdgeInsetsGeometryMix.all(16.0),
        );
        final style2 = RemixButtonStyle().padding(
          EdgeInsetsGeometryMix.all(8.0),
        );

        expect(style1, isNot(equals(style2)));
      });
    });
  });
}
