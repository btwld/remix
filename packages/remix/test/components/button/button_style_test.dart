import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';
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

        final style = RemixButtonStyle()
            .container(containerStyler)
            .label(labelStyler)
            .icon(iconStyler)
            .spinner(spinnerStyle);

        expect(style, isNotNull);
        expect(style.$container, isNotNull);
        expect(style.$label, isNotNull);
        expect(style.$icon, isNotNull);
        expect(style.$spinner, isNotNull);
      });

      test('shadow factory applies shadow style', () {
        final shadow = BoxShadowMix().color(Colors.black).blurRadius(4.0);
        final style = RemixButtonStyle().shadow(shadow);

        expect(
          style.$container,
          equals(
            Prop.maybeMix(
              FlexBoxStyler(decoration: BoxDecorationMix(boxShadow: [shadow])),
            ),
          ),
        );
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
        'rotate',
        initial: RemixButtonStyle(),
        modify: (style) => style.rotate(0.5, alignment: Alignment.topLeft),
        expect: (style) {
          expect(
            style.$modifier,
            equals(
              WidgetModifierConfig.rotate(
                radians: 0.5,
                alignment: Alignment.topLeft,
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'scale',
        initial: RemixButtonStyle(),
        modify: (style) => style.scale(1.2, alignment: Alignment.topLeft),
        expect: (style) {
          expect(style.$container, isNotNull);
        },
      );

      styleMethodTest(
        'translate',
        initial: RemixButtonStyle(),
        modify: (style) => style.translate(1.0, 2.0, 3.0),
        expect: (style) {
          expect(style.$container, isNotNull);
        },
      );

      styleMethodTest(
        'skew',
        initial: RemixButtonStyle(),
        modify: (style) => style.skew(0.1, 0.2),
        expect: (style) {
          expect(style.$container, isNotNull);
        },
      );

      styleMethodTest(
        'transformReset',
        initial: RemixButtonStyle(),
        modify: (style) => style.transformReset(),
        expect: (style) {
          expect(style.$container, isNotNull);
        },
      );

      testWidgets('transform shortcut helpers resolve expected matrices', (
        tester,
      ) async {
        final scaleBox = await _resolveContainerBoxSpec(
          tester,
          RemixButtonStyle().scale(1.2, alignment: Alignment.topLeft),
        );
        expect(
          scaleBox.transform?.storage,
          orderedEquals(Matrix4.diagonal3Values(1.2, 1.2, 1.0).storage),
        );
        expect(scaleBox.transformAlignment, equals(Alignment.topLeft));

        final translateBox = await _resolveContainerBoxSpec(
          tester,
          RemixButtonStyle().translate(1.0, 2.0, 3.0),
        );
        expect(
          translateBox.transform?.storage,
          orderedEquals(Matrix4.translationValues(1.0, 2.0, 3.0).storage),
        );

        final skewMatrix = Matrix4.identity()
          ..setEntry(0, 1, 0.1)
          ..setEntry(1, 0, 0.2);
        final skewBox = await _resolveContainerBoxSpec(
          tester,
          RemixButtonStyle().skew(0.1, 0.2),
        );
        expect(skewBox.transform?.storage, orderedEquals(skewMatrix.storage));

        final resetBox = await _resolveContainerBoxSpec(
          tester,
          RemixButtonStyle().transformReset(),
        );
        expect(
          resetBox.transform?.storage,
          orderedEquals(Matrix4.identity().storage),
        );
      });

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

      styleMethodTest(
        'inherited spacing helpers',
        initial: RemixButtonStyle(),
        modify: (style) => style.paddingStart(4.0).marginEnd(8.0),
        expect: (style) {
          expect(style.$container, isNotNull);
        },
      );

      styleMethodTest(
        'inherited border helpers',
        initial: RemixButtonStyle(),
        modify: (style) => style.borderTop(color: Colors.red, width: 2.0),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                FlexBoxStyler().borderTop(color: Colors.red, width: 2.0),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'inherited shape and constraint helpers',
        initial: RemixButtonStyle(),
        modify: (style) => style.shapeStadium().minHeight(32.0),
        expect: (style) {
          expect(style.$container, isNotNull);
        },
      );
    });

    group('Call Method', () {
      test('call method creates RemixButton with minimal parameters', () {
        final style = RemixButtonStyle();

        final button = style.call(label: 'Test Button');

        expect(button, isA<RemixButton>());
        expect(button.label, equals('Test Button'));
        expect(button.onPressed, isNull);
      });

      test('call method creates RemixButton with all parameters', () {
        final style = RemixButtonStyle();
        final focusNode = FocusNode();

        final button = style.call(
          label: 'Test Button',
          leadingIcon: Icons.star,
          loading: true,
          enabled: false,
          enableFeedback: false,
          onPressed: () {},
          focusNode: focusNode,
        );

        expect(button, isA<RemixButton>());
        expect(button.label, equals('Test Button'));
        expect(button.leadingIcon, equals(Icons.star));
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

      test('merge with null returns style equal to original', () {
        final originalStyle = RemixButtonStyle();

        final mergedStyle = originalStyle.merge(null);

        expect(mergedStyle, equals(originalStyle));
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

  group('FortalButton recipe', () {
    test('defaults to solid variant and size2', () {
      expect(
        fortalButtonStyle(),
        equals(fortalButtonStyle(variant: .solid, size: .size2)),
      );
    });

    for (final variant in FortalButtonVariant.values) {
      testWidgets('resolves $variant variant', (tester) async {
        final resolved = await _resolveFortalButtonStyle(
          tester,
          fortalButtonStyle(variant: variant),
        );

        expect(resolved, isA<StyleSpec<RemixButtonSpec>>());
        expect(resolved.spec, isA<RemixButtonSpec>());
      });
    }

    testWidgets('each size resolves distinct layout metrics', (tester) async {
      final resolvedBySize = <FortalButtonSize, StyleSpec<RemixButtonSpec>>{};

      for (final size in FortalButtonSize.values) {
        resolvedBySize[size] = await _resolveFortalButtonStyle(
          tester,
          fortalButtonStyle(size: size),
        );
      }

      final paddings = resolvedBySize.values
          .map((spec) => spec.spec.container.spec.box?.spec.padding)
          .toSet();
      final spacings = resolvedBySize.values
          .map((spec) => spec.spec.container.spec.flex?.spec.spacing)
          .toSet();

      expect(paddings, hasLength(FortalButtonSize.values.length));
      expect(spacings, hasLength(FortalButtonSize.values.length));
    });
  });
}

Future<StyleSpec<RemixButtonSpec>> _resolveFortalButtonStyle(
  WidgetTester tester,
  RemixButtonStyle style,
) async {
  late final StyleSpec<RemixButtonSpec> resolved;

  await tester.pumpRemixApp(
    Builder(
      builder: (context) {
        resolved = style.resolve(context);

        return const SizedBox.shrink();
      },
    ),
  );

  return resolved;
}

Future<BoxSpec> _resolveContainerBoxSpec(
  WidgetTester tester,
  RemixButtonStyle style,
) async {
  final resolved = await _resolveFortalButtonStyle(tester, style);

  return resolved.spec.container.spec.box!.spec;
}
