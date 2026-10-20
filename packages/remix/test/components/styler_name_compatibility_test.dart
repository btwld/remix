// ignore_for_file: deprecated_member_use

import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

/// Proves that every `Remix*Styler` name kept for source compatibility still
/// resolves through `package:remix/remix.dart`, constructs, and is the same
/// type as its canonical unprefixed counterpart.
///
/// Component-specific behavior lives in the per-component compatibility tests;
/// this file is the exhaustive name-level contract for the migration.
void main() {
  group('deprecated Remix*Styler aliases', () {
    expectStylerAlias<AccordionStyler>(
      'RemixAccordionStyler',
      RemixAccordionStyler.new,
      RemixAccordionStyler.create,
      (legacy, other) => legacy.merge(other),
    );
    expectStylerAlias<AvatarStyler>(
      'RemixAvatarStyler',
      RemixAvatarStyler.new,
      RemixAvatarStyler.create,
      (legacy, other) => legacy.merge(other),
    );
    expectStylerAlias<BadgeStyler>(
      'RemixBadgeStyler',
      RemixBadgeStyler.new,
      RemixBadgeStyler.create,
      (legacy, other) => legacy.merge(other),
    );
    expectStylerAlias<ButtonStyler>(
      'RemixButtonStyler',
      RemixButtonStyler.new,
      RemixButtonStyler.create,
      (legacy, other) => legacy.merge(other),
    );
    expectStylerAlias<CalloutStyler>(
      'RemixCalloutStyler',
      RemixCalloutStyler.new,
      RemixCalloutStyler.create,
      (legacy, other) => legacy.merge(other),
    );
    expectStylerAlias<CardStyler>(
      'RemixCardStyler',
      RemixCardStyler.new,
      RemixCardStyler.create,
      (legacy, other) => legacy.merge(other),
    );
    expectStylerAlias<CheckboxStyler>(
      'RemixCheckboxStyler',
      RemixCheckboxStyler.new,
      RemixCheckboxStyler.create,
      (legacy, other) => legacy.merge(other),
    );
    expectStylerAlias<DialogStyler>(
      'RemixDialogStyler',
      RemixDialogStyler.new,
      RemixDialogStyler.create,
      (legacy, other) => legacy.merge(other),
    );
    expectStylerAlias<DividerStyler>(
      'RemixDividerStyler',
      RemixDividerStyler.new,
      RemixDividerStyler.create,
      (legacy, other) => legacy.merge(other),
    );
    expectStylerAlias<IconButtonStyler>(
      'RemixIconButtonStyler',
      RemixIconButtonStyler.new,
      RemixIconButtonStyler.create,
      (legacy, other) => legacy.merge(other),
    );
    expectStylerAlias<MenuStyler>(
      'RemixMenuStyler',
      RemixMenuStyler.new,
      RemixMenuStyler.create,
      (legacy, other) => legacy.merge(other),
    );
    expectStylerAlias<MenuTriggerStyler>(
      'RemixMenuTriggerStyler',
      RemixMenuTriggerStyler.new,
      RemixMenuTriggerStyler.create,
      (legacy, other) => legacy.merge(other),
    );
    expectStylerAlias<MenuItemStyler>(
      'RemixMenuItemStyler',
      RemixMenuItemStyler.new,
      RemixMenuItemStyler.create,
      (legacy, other) => legacy.merge(other),
    );
    expectStylerAlias<PopoverStyler>(
      'RemixPopoverStyler',
      RemixPopoverStyler.new,
      RemixPopoverStyler.create,
      (legacy, other) => legacy.merge(other),
    );
    expectStylerAlias<ProgressStyler>(
      'RemixProgressStyler',
      RemixProgressStyler.new,
      RemixProgressStyler.create,
      (legacy, other) => legacy.merge(other),
    );
    expectStylerAlias<RadioStyler>(
      'RemixRadioStyler',
      RemixRadioStyler.new,
      RemixRadioStyler.create,
      (legacy, other) => legacy.merge(other),
    );
    expectStylerAlias<SelectStyler>(
      'RemixSelectStyler',
      RemixSelectStyler.new,
      RemixSelectStyler.create,
      (legacy, other) => legacy.merge(other),
    );
    expectStylerAlias<SelectTriggerStyler>(
      'RemixSelectTriggerStyler',
      RemixSelectTriggerStyler.new,
      RemixSelectTriggerStyler.create,
      (legacy, other) => legacy.merge(other),
    );
    expectStylerAlias<SelectContentStyler>(
      'RemixSelectContentStyler',
      RemixSelectContentStyler.new,
      RemixSelectContentStyler.create,
      (legacy, other) => legacy.merge(other),
    );
    expectStylerAlias<SelectMenuItemStyler>(
      'RemixSelectMenuItemStyler',
      RemixSelectMenuItemStyler.new,
      RemixSelectMenuItemStyler.create,
      (legacy, other) => legacy.merge(other),
    );
    expectStylerAlias<SliderStyler>(
      'RemixSliderStyler',
      RemixSliderStyler.new,
      RemixSliderStyler.create,
      (legacy, other) => legacy.merge(other),
    );
    expectStylerAlias<SpinnerStyler>(
      'RemixSpinnerStyler',
      RemixSpinnerStyler.new,
      RemixSpinnerStyler.create,
      (legacy, other) => legacy.merge(other),
    );
    expectStylerAlias<SwitchStyler>(
      'RemixSwitchStyler',
      RemixSwitchStyler.new,
      RemixSwitchStyler.create,
      (legacy, other) => legacy.merge(other),
    );
    expectStylerAlias<TabBarStyler>(
      'RemixTabBarStyler',
      RemixTabBarStyler.new,
      RemixTabBarStyler.create,
      (legacy, other) => legacy.merge(other),
    );
    expectStylerAlias<TabStyler>(
      'RemixTabStyler',
      RemixTabStyler.new,
      RemixTabStyler.create,
      (legacy, other) => legacy.merge(other),
    );
    expectStylerAlias<TabViewStyler>(
      'RemixTabViewStyler',
      RemixTabViewStyler.new,
      RemixTabViewStyler.create,
      (legacy, other) => legacy.merge(other),
    );
    expectStylerAlias<TextFieldStyler>(
      'RemixTextFieldStyler',
      RemixTextFieldStyler.new,
      RemixTextFieldStyler.create,
      (legacy, other) => legacy.merge(other),
    );
    expectStylerAlias<ToggleStyler>(
      'RemixToggleStyler',
      RemixToggleStyler.new,
      RemixToggleStyler.create,
      (legacy, other) => legacy.merge(other),
    );
    expectStylerAlias<ToggleGroupStyler>(
      'RemixToggleGroupStyler',
      RemixToggleGroupStyler.new,
      RemixToggleGroupStyler.create,
      (legacy, other) => legacy.merge(other),
    );
    expectStylerAlias<ToggleGroupItemStyler>(
      'RemixToggleGroupItemStyler',
      RemixToggleGroupItemStyler.new,
      RemixToggleGroupItemStyler.create,
      (legacy, other) => legacy.merge(other),
    );
    expectStylerAlias<TooltipStyler>(
      'RemixTooltipStyler',
      RemixTooltipStyler.new,
      RemixTooltipStyler.create,
      (legacy, other) => legacy.merge(other),
    );
  });

  group('legacy Remix*Spec typedefs', () {
    test('RemixAccordionSpec aliases AccordionSpec', () {
      expect(RemixAccordionSpec, AccordionSpec);
    });

    test('RemixAvatarSpec aliases AvatarSpec', () {
      expect(RemixAvatarSpec, AvatarSpec);
    });

    test('RemixBadgeSpec aliases BadgeSpec', () {
      expect(RemixBadgeSpec, BadgeSpec);
    });

    test('RemixButtonSpec aliases ButtonSpec', () {
      expect(RemixButtonSpec, ButtonSpec);
    });

    test('RemixCalloutSpec aliases CalloutSpec', () {
      expect(RemixCalloutSpec, CalloutSpec);
    });

    test('RemixCardSpec aliases CardSpec', () {
      expect(RemixCardSpec, CardSpec);
    });

    test('RemixCheckboxSpec aliases CheckboxSpec', () {
      expect(RemixCheckboxSpec, CheckboxSpec);
    });

    test('RemixDialogSpec aliases DialogSpec', () {
      expect(RemixDialogSpec, DialogSpec);
    });

    test('RemixDividerSpec aliases DividerSpec', () {
      expect(RemixDividerSpec, DividerSpec);
    });

    test('RemixIconButtonSpec aliases IconButtonSpec', () {
      expect(RemixIconButtonSpec, IconButtonSpec);
    });

    test('RemixMenuSpec aliases MenuSpec', () {
      expect(RemixMenuSpec, MenuSpec);
    });

    test('RemixMenuTriggerSpec aliases MenuTriggerSpec', () {
      expect(RemixMenuTriggerSpec, MenuTriggerSpec);
    });

    test('RemixMenuItemSpec aliases MenuItemSpec', () {
      expect(RemixMenuItemSpec, MenuItemSpec);
    });

    test('RemixPopoverSpec aliases PopoverSpec', () {
      expect(RemixPopoverSpec, PopoverSpec);
    });

    test('RemixProgressSpec aliases ProgressSpec', () {
      expect(RemixProgressSpec, ProgressSpec);
    });

    test('RemixRadioSpec aliases RadioSpec', () {
      expect(RemixRadioSpec, RadioSpec);
    });

    test('RemixSelectSpec aliases SelectSpec', () {
      expect(RemixSelectSpec, SelectSpec);
    });

    test('RemixSelectTriggerSpec aliases SelectTriggerSpec', () {
      expect(RemixSelectTriggerSpec, SelectTriggerSpec);
    });

    test('RemixSelectContentSpec aliases SelectContentSpec', () {
      expect(RemixSelectContentSpec, SelectContentSpec);
    });

    test('RemixSelectMenuItemSpec aliases SelectMenuItemSpec', () {
      expect(RemixSelectMenuItemSpec, SelectMenuItemSpec);
    });

    test('RemixSliderSpec aliases SliderSpec', () {
      expect(RemixSliderSpec, SliderSpec);
    });

    test('RemixSpinnerSpec aliases SpinnerSpec', () {
      expect(RemixSpinnerSpec, SpinnerSpec);
    });

    test('RemixSwitchSpec aliases SwitchSpec', () {
      expect(RemixSwitchSpec, SwitchSpec);
    });

    test('RemixTabBarSpec aliases TabBarSpec', () {
      expect(RemixTabBarSpec, TabBarSpec);
    });

    test('RemixTabSpec aliases TabSpec', () {
      expect(RemixTabSpec, TabSpec);
    });

    test('RemixTabViewSpec aliases TabViewSpec', () {
      expect(RemixTabViewSpec, TabViewSpec);
    });

    test('RemixTextFieldSpec aliases TextFieldSpec', () {
      expect(RemixTextFieldSpec, TextFieldSpec);
    });

    test('RemixToggleSpec aliases ToggleSpec', () {
      expect(RemixToggleSpec, ToggleSpec);
    });

    test('RemixToggleGroupSpec aliases ToggleGroupSpec', () {
      expect(RemixToggleGroupSpec, ToggleGroupSpec);
    });

    test('RemixToggleGroupItemSpec aliases ToggleGroupItemSpec', () {
      expect(RemixToggleGroupItemSpec, ToggleGroupItemSpec);
    });

    test('RemixTooltipSpec aliases TooltipSpec', () {
      expect(RemixTooltipSpec, TooltipSpec);
    });
  });
}

/// One alias case: construct, `create()`, assign, `runtimeType`, and `merge`.
///
/// [construct] and [create] are tear-offs of the deprecated export, so dropping
/// that export fails this library at compile time.
void expectStylerAlias<T>(
  String legacyName,
  T Function() construct,
  T Function() create,
  T Function(T legacy, T other) merge,
) {
  test('$legacyName aliases ${construct().runtimeType}', () {
    final legacy = construct();
    final T canonical = legacy;

    expect(canonical, same(legacy));
    expect(legacy.runtimeType, T);
    expect(merge(legacy, create()), isA<T>());
  });
}
