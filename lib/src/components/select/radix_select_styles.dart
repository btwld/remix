// Provides Radix-compliant select styles mapped to token spec.

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../radix/radix.dart';
import 'select.dart';

/// Radix select styles for trigger and menu content.
class RadixSelectStyles {
  const RadixSelectStyles._();

  // Trigger variants

  static RemixSelectStyle triggerClassic() {
    return RemixSelectStyle()
        .trigger(
          RemixSelectTriggerStyle()
              // Use standard trigger padding X = space-3 (12px), Y = space-2 (8px)
              .padding(
                EdgeInsetsGeometryMix.symmetric(vertical: 8.0, horizontal: 12.0),
              )
              // Per JSON: select-trigger-height = space-7 (28px)
              .constraints(
                BoxConstraintsMix(minHeight: 28.0, maxHeight: 28.0),
              )
              .direction(Axis.horizontal)
              .mainAxisAlignment(MainAxisAlignment.spaceBetween)
              .crossAxisAlignment(CrossAxisAlignment.center)
              .color(RadixTokens.colorSurface())
              .borderAll(
                color: RadixTokens.gray7(),
                width: RadixTokens.borderWidth1(),
              )
              .borderRadiusAll(RadixTokens.radius3())
              .label(TextStyler().color(RadixTokens.gray12()))
              .icon(IconStyler(color: RadixTokens.gray12(), size: 16.0)),
        )
        .onHovered(
          RemixSelectStyle().trigger(
                RemixSelectTriggerStyle().borderAll(
                  color: RadixTokens.gray8(),
                  width: RadixTokens.borderWidth1(),
                ),
              ),
        )
        .onFocused(
          RemixSelectStyle().trigger(
                RemixSelectTriggerStyle().borderAll(
                  color: RadixTokens.focusA8(),
                  width: RadixTokens.focusRingWidth(),
                ),
              ),
        );
  }

  static RemixSelectStyle triggerSurface() {
    return RemixSelectStyle()
        .trigger(
          RemixSelectTriggerStyle()
              .padding(
                EdgeInsetsGeometryMix.symmetric(vertical: 8.0, horizontal: 12.0),
              )
              .constraints(
                BoxConstraintsMix(minHeight: 28.0, maxHeight: 28.0),
              )
              .direction(Axis.horizontal)
              .mainAxisAlignment(MainAxisAlignment.spaceBetween)
              .crossAxisAlignment(CrossAxisAlignment.center)
              .color(RadixTokens.colorSurface())
              .borderAll(
                color: RadixTokens.gray6(),
                width: RadixTokens.borderWidth1(),
              )
              .borderRadiusAll(RadixTokens.radius3())
              .label(TextStyler().color(RadixTokens.gray12()))
              .icon(IconStyler(color: RadixTokens.gray12(), size: 16.0)),
        )
        .onFocused(
          RemixSelectStyle().trigger(
                RemixSelectTriggerStyle().borderAll(
                  color: RadixTokens.focusA8(),
                  width: RadixTokens.focusRingWidth(),
                ),
              ),
        );
  }

  static RemixSelectStyle triggerSoft() {
    return RemixSelectStyle()
        .trigger(
          RemixSelectTriggerStyle()
              .padding(
                EdgeInsetsGeometryMix.symmetric(vertical: 8.0, horizontal: 12.0),
              )
              .constraints(
                BoxConstraintsMix(minHeight: 28.0, maxHeight: 28.0),
              )
              .direction(Axis.horizontal)
              .mainAxisAlignment(MainAxisAlignment.spaceBetween)
              .crossAxisAlignment(CrossAxisAlignment.center)
              .color(RadixTokens.accent3())
              .borderAll(
                color: RadixTokens.accent6(),
                width: RadixTokens.borderWidth1(),
              )
              .borderRadiusAll(RadixTokens.radius3())
              .label(TextStyler().color(RadixTokens.accent11()))
              .icon(IconStyler(color: RadixTokens.accent11(), size: 16.0)),
        )
        .onFocused(
          RemixSelectStyle().trigger(
                RemixSelectTriggerStyle().borderAll(
                  color: RadixTokens.focusA8(),
                  width: RadixTokens.focusRingWidth(),
                ),
              ),
        );
  }

  static RemixSelectStyle triggerGhost() {
    return RemixSelectStyle()
        .trigger(
          RemixSelectTriggerStyle()
              .padding(
                EdgeInsetsGeometryMix.symmetric(vertical: 6.0, horizontal: 12.0),
              )
              .constraints(
                BoxConstraintsMix(minHeight: 28.0, maxHeight: 28.0),
              )
              .direction(Axis.horizontal)
              .mainAxisAlignment(MainAxisAlignment.spaceBetween)
              .crossAxisAlignment(CrossAxisAlignment.center)
              .color(Colors.transparent)
              .borderRadiusAll(RadixTokens.radius3())
              .label(TextStyler().color(RadixTokens.gray12()))
              .icon(IconStyler(color: RadixTokens.gray12(), size: 16.0)),
        )
        .onFocused(
          RemixSelectStyle().trigger(
                RemixSelectTriggerStyle().borderAll(
                  color: RadixTokens.focusA8(),
                  width: RadixTokens.focusRingWidth(),
                ),
              ),
        );
  }

  // Content (menu) variants

  static RemixSelectStyle contentSolid() {
    return RemixSelectStyle()
        .menuContainer(
          BoxStyler()
              .color(RadixTokens.colorPanelSolid())
              .borderAll(
                color: RadixTokens.gray6(),
                width: RadixTokens.borderWidth1(),
              )
              .borderRadiusAll(RadixTokens.radius3())
              .padding(EdgeInsetsGeometryMix.all(8.0)),
        )
        .item(
          RemixSelectMenuItemStyle()
              .padding(
                EdgeInsetsGeometryMix.symmetric(horizontal: 8.0),
              )
              .constraints(
                BoxConstraintsMix(minHeight: 24.0, maxHeight: 24.0),
              )
              .text(TextStyler().color(RadixTokens.gray12()))
              .icon(IconStyler(size: 20.0)),
        );
  }

  static RemixSelectStyle contentSoft() {
    return RemixSelectStyle()
        .menuContainer(
          BoxStyler()
              .color(RadixTokens.colorPanelTranslucent())
              .borderAll(
                color: RadixTokens.gray6(),
                width: RadixTokens.borderWidth1(),
              )
              .borderRadiusAll(RadixTokens.radius3())
              .padding(EdgeInsetsGeometryMix.all(8.0)),
        )
        .item(
          RemixSelectMenuItemStyle()
              .padding(
                EdgeInsetsGeometryMix.symmetric(horizontal: 8.0),
              )
              .constraints(
                BoxConstraintsMix(minHeight: 24.0, maxHeight: 24.0),
              )
              .text(TextStyler().color(RadixTokens.gray12()))
              .icon(IconStyler(size: 20.0)),
        );
  }
}
