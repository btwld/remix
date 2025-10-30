import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_methods.dart';

void main() {
  group('RemixMenuTriggerStyle', () {
    group('Constructors', () {
      test('default constructor creates valid instance', () {
        final style = RemixMenuTriggerStyle();

        expect(style, isNotNull);
        expect(style, isA<RemixMenuTriggerStyle>());
      });

      test('create constructor with all parameters', () {
        final container = Prop.maybeMix(FlexBoxStyler());
        final label = Prop.maybeMix(TextStyler());
        final icon = Prop.maybeMix(IconStyler());
        final variants = <VariantStyle<RemixMenuTriggerSpec>>[];

        final style = RemixMenuTriggerStyle.create(
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

        final style = RemixMenuTriggerStyle(
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
        'label',
        initial: RemixMenuTriggerStyle(),
        modify: (style) =>
            style.label(TextStyler().color(Colors.red).fontSize(14)),
        expect: (style) {
          expect(
            style.$label,
            Prop.maybeMix(TextStyler().color(Colors.red).fontSize(14)),
          );
        },
      );

      styleMethodTest(
        'icon',
        initial: RemixMenuTriggerStyle(),
        modify: (style) => style.icon(IconStyler().color(Colors.red).size(16)),
        expect: (style) {
          expect(
            style.$icon,
            equals(Prop.maybeMix(IconStyler().color(Colors.red).size(16))),
          );
        },
      );

      styleMethodTest(
        'padding',
        initial: RemixMenuTriggerStyle(),
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
        'color',
        initial: RemixMenuTriggerStyle(),
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
        'alignment',
        initial: RemixMenuTriggerStyle(),
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
        'size',
        initial: RemixMenuTriggerStyle(),
        modify: (style) => style.size(100.0, 50.0),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                FlexBoxStyler(
                  constraints: BoxConstraintsMix(
                    minWidth: 100.0,
                    maxWidth: 100.0,
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
        initial: RemixMenuTriggerStyle(),
        modify: (style) => style.borderRadius(BorderRadiusMix.circular(8.0)),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                FlexBoxStyler(
                  decoration: BoxDecorationMix(
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
        initial: RemixMenuTriggerStyle(),
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
        'decoration',
        initial: RemixMenuTriggerStyle(),
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
        'margin',
        initial: RemixMenuTriggerStyle(),
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
        'foregroundDecoration',
        initial: RemixMenuTriggerStyle(),
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
        initial: RemixMenuTriggerStyle(),
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
        'flex',
        initial: RemixMenuTriggerStyle(),
        modify: (style) => style.flex(FlexStyler()),
        expect: (style) {
          expect(
            style.$container,
            equals(Prop.maybeMix(FlexBoxStyler().flex(FlexStyler()))),
          );
        },
      );

      styleMethodTest(
        'variants',
        initial: RemixMenuTriggerStyle(),
        modify: (style) =>
            style.variants(<VariantStyle<RemixMenuTriggerSpec>>[]),
        expect: (style) {
          expect(
            style.$variants,
            equals(<VariantStyle<RemixMenuTriggerSpec>>[]),
          );
        },
      );

      styleMethodTest(
        'wrap',
        initial: RemixMenuTriggerStyle(),
        modify: (style) => style.wrap(WidgetModifierConfig.clipOval()),
        expect: (style) {
          expect(style.$modifier, equals(WidgetModifierConfig.clipOval()));
        },
      );
    });

    group('Core Methods', () {
      testWidgets('resolve method returns StyleSpec', (
        WidgetTester tester,
      ) async {
        final style = RemixMenuTriggerStyle();

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final spec = style.resolve(context);

                expect(spec, isA<StyleSpec<RemixMenuTriggerSpec>>());
                expect(spec.spec, isA<RemixMenuTriggerSpec>());
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
        final originalStyle = RemixMenuTriggerStyle();

        final mergedStyle = originalStyle.merge(null);

        expect(mergedStyle, same(originalStyle));
      });
    });

    group('Equality', () {
      test('identical styles are equal', () {
        final style1 = RemixMenuTriggerStyle();
        final style2 = RemixMenuTriggerStyle();

        expect(style1, equals(style2));
        expect(style1.hashCode, equals(style2.hashCode));
      });

      test('styles with different properties are not equal', () {
        final style1 = RemixMenuTriggerStyle().padding(
          EdgeInsetsGeometryMix.all(16.0),
        );
        final style2 = RemixMenuTriggerStyle().padding(
          EdgeInsetsGeometryMix.all(8.0),
        );

        expect(style1, isNot(equals(style2)));
      });
    });
  });

  group('RemixMenuStyle', () {
    group('Constructors', () {
      test('default constructor creates valid instance', () {
        final style = RemixMenuStyle();

        expect(style, isNotNull);
        expect(style, isA<RemixMenuStyle>());
      });

      test('create constructor with all parameters', () {
        final trigger = Prop.maybeMix(RemixMenuTriggerStyle());
        final overlay = Prop.maybeMix(FlexBoxStyler());
        final item = Prop.maybeMix(RemixMenuItemStyle());
        final divider = Prop.maybeMix(RemixDividerStyle());
        final variants = <VariantStyle<RemixMenuSpec>>[];

        final style = RemixMenuStyle.create(
          trigger: trigger,
          overlay: overlay,
          item: item,
          divider: divider,
          variants: variants,
        );

        expect(style, isNotNull);
        expect(style.$trigger, equals(trigger));
        expect(style.$overlay, equals(overlay));
        expect(style.$item, equals(item));
        expect(style.$divider, equals(divider));
        expect(style.$variants, equals(variants));
      });

      test('constructor with styler parameters', () {
        final triggerStyle = RemixMenuTriggerStyle();
        final overlayStyler = FlexBoxStyler();
        final itemStyle = RemixMenuItemStyle();
        final dividerStyle = RemixDividerStyle();

        final style = RemixMenuStyle(
          trigger: triggerStyle,
          overlay: overlayStyler,
          item: itemStyle,
          divider: dividerStyle,
        );

        expect(style, isNotNull);
        expect(style.$trigger, isNotNull);
        expect(style.$overlay, isNotNull);
        expect(style.$item, isNotNull);
        expect(style.$divider, isNotNull);
      });
    });

    group('Style Methods', () {
      styleMethodTest(
        'trigger',
        initial: RemixMenuStyle(),
        modify: (style) => style.trigger(RemixMenuTriggerStyle()),
        expect: (style) {
          expect(
            style.$trigger,
            equals(Prop.maybeMix(RemixMenuTriggerStyle())),
          );
        },
      );

      styleMethodTest(
        'overlay',
        initial: RemixMenuStyle(),
        modify: (style) => style.overlay(FlexBoxStyler()),
        expect: (style) {
          expect(style.$overlay, equals(Prop.maybeMix(FlexBoxStyler())));
        },
      );

      styleMethodTest(
        'item',
        initial: RemixMenuStyle(),
        modify: (style) => style.item(RemixMenuItemStyle()),
        expect: (style) {
          expect(style.$item, equals(Prop.maybeMix(RemixMenuItemStyle())));
        },
      );

      styleMethodTest(
        'divider',
        initial: RemixMenuStyle(),
        modify: (style) => style.divider(RemixDividerStyle()),
        expect: (style) {
          expect(style.$divider, equals(Prop.maybeMix(RemixDividerStyle())));
        },
      );

      styleMethodTest(
        'variants',
        initial: RemixMenuStyle(),
        modify: (style) => style.variants(<VariantStyle<RemixMenuSpec>>[]),
        expect: (style) {
          expect(style.$variants, equals(<VariantStyle<RemixMenuSpec>>[]));
        },
      );

      styleMethodTest(
        'wrap',
        initial: RemixMenuStyle(),
        modify: (style) => style.wrap(WidgetModifierConfig.clipOval()),
        expect: (style) {
          expect(style.$modifier, equals(WidgetModifierConfig.clipOval()));
        },
      );
    });

    group('Call Method', () {
      test('call method creates RemixMenu with required parameters', () {
        final style = RemixMenuStyle();

        final menu = style.call<String>(
          trigger: const RemixMenuTrigger(label: 'Options'),
          items: [const RemixMenuItem<String>(value: 'copy', label: 'Copy')],
        );

        expect(menu, isA<RemixMenu<String>>());
        expect(menu.trigger.label, equals('Options'));
        expect(menu.items.length, equals(1));
      });

      test('call method creates RemixMenu with all parameters', () {
        final style = RemixMenuStyle();
        final controller = MenuController();
        final focusNode = FocusNode();
        int selectedCount = 0;
        int openCount = 0;
        int closeCount = 0;

        final menu = style.call<String>(
          trigger: const RemixMenuTrigger(
            label: 'Options',
            icon: Icons.more_vert,
          ),
          items: [
            const RemixMenuItem<String>(value: 'copy', label: 'Copy'),
            const RemixMenuDivider<String>(),
            const RemixMenuItem<String>(value: 'paste', label: 'Paste'),
          ],
          controller: controller,
          onSelected: (value) => selectedCount++,
          onOpen: () => openCount++,
          onClose: () => closeCount++,
          triggerFocusNode: focusNode,
        );

        expect(menu, isA<RemixMenu<String>>());
        expect(menu.trigger.label, equals('Options'));
        expect(menu.trigger.icon, equals(Icons.more_vert));
        expect(menu.items.length, equals(3));
        expect(menu.controller, equals(controller));
        expect(menu.onSelected, isNotNull);
        expect(menu.onOpen, isNotNull);
        expect(menu.onClose, isNotNull);
        expect(menu.triggerFocusNode, equals(focusNode));
      });
    });

    group('Core Methods', () {
      testWidgets('resolve method returns StyleSpec', (
        WidgetTester tester,
      ) async {
        final style = RemixMenuStyle();

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final spec = style.resolve(context);

                expect(spec, isA<StyleSpec<RemixMenuSpec>>());
                expect(spec.spec, isA<RemixMenuSpec>());
                expect(
                  spec.spec.trigger,
                  isA<StyleSpec<RemixMenuTriggerSpec>>(),
                );
                expect(spec.spec.overlay, isA<StyleSpec<FlexBoxSpec>>());
                expect(spec.spec.item, isA<StyleSpec<RemixMenuItemSpec>>());
                expect(spec.spec.divider, isA<StyleSpec<RemixDividerSpec>>());

                return Container();
              },
            ),
          ),
        );
      });

      test('merge with null returns original instance', () {
        final originalStyle = RemixMenuStyle();

        final mergedStyle = originalStyle.merge(null);

        expect(mergedStyle, same(originalStyle));
      });
    });

    group('Equality', () {
      test('identical styles are equal', () {
        final style1 = RemixMenuStyle();
        final style2 = RemixMenuStyle();

        expect(style1, equals(style2));
        expect(style1.hashCode, equals(style2.hashCode));
      });

      test('styles with different properties are not equal', () {
        final style1 = RemixMenuStyle().trigger(
          RemixMenuTriggerStyle().padding(EdgeInsetsGeometryMix.all(16.0)),
        );
        final style2 = RemixMenuStyle().trigger(
          RemixMenuTriggerStyle().padding(EdgeInsetsGeometryMix.all(8.0)),
        );

        expect(style1, isNot(equals(style2)));
      });
    });
  });

  group('RemixMenuItemStyle', () {
    group('Constructors', () {
      test('default constructor creates valid instance', () {
        final style = RemixMenuItemStyle();

        expect(style, isNotNull);
        expect(style, isA<RemixMenuItemStyle>());
      });

      test('create constructor with all parameters', () {
        final container = Prop.maybeMix(FlexBoxStyler());
        final label = Prop.maybeMix(TextStyler());
        final leadingIcon = Prop.maybeMix(IconStyler());
        final trailingIcon = Prop.maybeMix(IconStyler());
        final variants = <VariantStyle<RemixMenuItemSpec>>[];

        final style = RemixMenuItemStyle.create(
          container: container,
          label: label,
          leadingIcon: leadingIcon,
          trailingIcon: trailingIcon,
          variants: variants,
        );

        expect(style, isNotNull);
        expect(style.$container, equals(container));
        expect(style.$label, equals(label));
        expect(style.$leadingIcon, equals(leadingIcon));
        expect(style.$trailingIcon, equals(trailingIcon));
        expect(style.$variants, equals(variants));
      });

      test('constructor with styler parameters', () {
        final containerStyler = FlexBoxStyler();
        final labelStyler = TextStyler();
        final leadingIconStyler = IconStyler();
        final trailingIconStyler = IconStyler();

        final style = RemixMenuItemStyle(
          container: containerStyler,
          label: labelStyler,
          leadingIcon: leadingIconStyler,
          trailingIcon: trailingIconStyler,
        );

        expect(style, isNotNull);
        expect(style.$container, isNotNull);
        expect(style.$label, isNotNull);
        expect(style.$leadingIcon, isNotNull);
        expect(style.$trailingIcon, isNotNull);
      });
    });

    group('Style Methods', () {
      styleMethodTest(
        'label',
        initial: RemixMenuItemStyle(),
        modify: (style) => style.label(TextStyler()),
        expect: (style) {
          expect(style.$label, Prop.maybeMix(TextStyler()));
        },
      );

      styleMethodTest(
        'leadingIcon',
        initial: RemixMenuItemStyle(),
        modify: (style) => style.leadingIcon(IconStyler()),
        expect: (style) {
          expect(style.$leadingIcon, equals(Prop.maybeMix(IconStyler())));
        },
      );

      styleMethodTest(
        'trailingIcon',
        initial: RemixMenuItemStyle(),
        modify: (style) => style.trailingIcon(IconStyler()),
        expect: (style) {
          expect(style.$trailingIcon, equals(Prop.maybeMix(IconStyler())));
        },
      );

      styleMethodTest(
        'alignment',
        initial: RemixMenuItemStyle(),
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
        'padding',
        initial: RemixMenuItemStyle(),
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
        'color',
        initial: RemixMenuItemStyle(),
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
        'size',
        initial: RemixMenuItemStyle(),
        modify: (style) => style.size(200.0, 48.0),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                FlexBoxStyler(
                  constraints: BoxConstraintsMix(
                    minWidth: 200.0,
                    maxWidth: 200.0,
                    minHeight: 48.0,
                    maxHeight: 48.0,
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'borderRadius',
        initial: RemixMenuItemStyle(),
        modify: (style) => style.borderRadius(BorderRadiusMix.circular(4.0)),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                FlexBoxStyler(
                  decoration: BoxDecorationMix(
                    borderRadius: BorderRadiusMix.circular(4.0),
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'constraints',
        initial: RemixMenuItemStyle(),
        modify: (style) => style.constraints(
          BoxConstraintsMix(minWidth: 150.0, minHeight: 36.0),
        ),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                FlexBoxStyler(
                  constraints: BoxConstraintsMix(
                    minWidth: 150.0,
                    minHeight: 36.0,
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'decoration',
        initial: RemixMenuItemStyle(),
        modify: (style) => style.decoration(
          BoxDecorationMix(
            color: Colors.grey,
            borderRadius: BorderRadiusMix.circular(4.0),
          ),
        ),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                FlexBoxStyler(
                  decoration: BoxDecorationMix(
                    color: Colors.grey,
                    borderRadius: BorderRadiusMix.circular(4.0),
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'margin',
        initial: RemixMenuItemStyle(),
        modify: (style) => style.margin(EdgeInsetsGeometryMix.all(4.0)),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                FlexBoxStyler(margin: EdgeInsetsGeometryMix.all(4.0)),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'foregroundDecoration',
        initial: RemixMenuItemStyle(),
        modify: (style) => style.foregroundDecoration(
          BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(color: Colors.blue)),
          ),
        ),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                FlexBoxStyler(
                  foregroundDecoration: BoxDecorationMix(
                    border: BoxBorderMix.all(BorderSideMix(color: Colors.blue)),
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'transform',
        initial: RemixMenuItemStyle(),
        modify: (style) =>
            style.transform(Matrix4.identity(), alignment: Alignment.center),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                FlexBoxStyler(
                  transform: Matrix4.identity(),
                  transformAlignment: Alignment.center,
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'flex',
        initial: RemixMenuItemStyle(),
        modify: (style) => style.flex(FlexStyler()),
        expect: (style) {
          expect(
            style.$container,
            equals(Prop.maybeMix(FlexBoxStyler().flex(FlexStyler()))),
          );
        },
      );

      styleMethodTest(
        'variants',
        initial: RemixMenuItemStyle(),
        modify: (style) => style.variants(<VariantStyle<RemixMenuItemSpec>>[]),
        expect: (style) {
          expect(style.$variants, equals(<VariantStyle<RemixMenuItemSpec>>[]));
        },
      );

      styleMethodTest(
        'wrap',
        initial: RemixMenuItemStyle(),
        modify: (style) => style.wrap(WidgetModifierConfig.clipOval()),
        expect: (style) {
          expect(style.$modifier, equals(WidgetModifierConfig.clipOval()));
        },
      );
    });

    group('Core Methods', () {
      testWidgets('resolve method returns StyleSpec', (
        WidgetTester tester,
      ) async {
        final style = RemixMenuItemStyle();

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final spec = style.resolve(context);

                expect(spec, isA<StyleSpec<RemixMenuItemSpec>>());
                expect(spec.spec, isA<RemixMenuItemSpec>());
                expect(spec.spec.container, isA<StyleSpec<FlexBoxSpec>>());
                expect(spec.spec.label, isA<StyleSpec<TextSpec>>());
                expect(spec.spec.leadingIcon, isA<StyleSpec<IconSpec>>());
                expect(spec.spec.trailingIcon, isA<StyleSpec<IconSpec>>());

                return Container();
              },
            ),
          ),
        );
      });

      test('merge with null returns original instance', () {
        final originalStyle = RemixMenuItemStyle();

        final mergedStyle = originalStyle.merge(null);

        expect(mergedStyle, same(originalStyle));
      });
    });

    group('Equality', () {
      test('identical styles are equal', () {
        final style1 = RemixMenuItemStyle();
        final style2 = RemixMenuItemStyle();

        expect(style1, equals(style2));
        expect(style1.hashCode, equals(style2.hashCode));
      });

      test('styles with different properties are not equal', () {
        final style1 = RemixMenuItemStyle().padding(
          EdgeInsetsGeometryMix.all(16.0),
        );
        final style2 = RemixMenuItemStyle().padding(
          EdgeInsetsGeometryMix.all(8.0),
        );

        expect(style1, isNot(equals(style2)));
      });
    });
  });
}
