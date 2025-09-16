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
    return RemixSelectStyle(
      trigger: RemixSelectTriggerStyle(
        container: FlexBoxStyler(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(
              BorderSideMix(color: RadixTokens.gray7(), width: 1.0),
            ),
            borderRadius: BorderRadiusMix.all(RadixTokens.radius3()),
            color: RadixTokens.colorSurface(),
          ),
          // Use standard trigger padding X = space-3 (12px), Y = space-2 (8px)
          padding:
              EdgeInsetsGeometryMix.symmetric(vertical: 8.0, horizontal: 12.0),
          // Per JSON: select-trigger-height = space-7 (28px)
          constraints: BoxConstraintsMix(minHeight: 28.0, maxHeight: 28.0),
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
        label: TextStyler().color(RadixTokens.gray12()),
        icon: IconStyler(color: RadixTokens.gray12(), size: 16.0),
      ),
    )
        .onHovered(
          RemixSelectStyle(
            trigger: RemixSelectTriggerStyle(
              container: FlexBoxStyler(
                decoration: BoxDecorationMix(
                  border: BoxBorderMix.all(
                    BorderSideMix(color: RadixTokens.gray8(), width: 1.0),
                  ),
                ),
              ),
            ),
          ),
        )
        .onFocused(
          RemixSelectStyle(
            trigger: RemixSelectTriggerStyle(
              container: FlexBoxStyler(
                decoration: BoxDecorationMix(
                  border: BoxBorderMix.all(
                    BorderSideMix(
                      color: RadixTokens.focusA8(),
                      width: RadixTokens.focusRingWidth(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
  }

  static RemixSelectStyle triggerSurface() {
    return RemixSelectStyle(
      trigger: RemixSelectTriggerStyle(
        container: FlexBoxStyler(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(
              BorderSideMix(color: RadixTokens.gray6(), width: 1.0),
            ),
            borderRadius: BorderRadiusMix.all(RadixTokens.radius3()),
            color: RadixTokens.colorSurface(),
          ),
          padding:
              EdgeInsetsGeometryMix.symmetric(vertical: 8.0, horizontal: 12.0),
          constraints: BoxConstraintsMix(minHeight: 28.0, maxHeight: 28.0),
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
        label: TextStyler().color(RadixTokens.gray12()),
        icon: IconStyler(color: RadixTokens.gray12(), size: 16.0),
      ),
    ).onFocused(
      RemixSelectStyle(
        trigger: RemixSelectTriggerStyle(
          container: FlexBoxStyler(
            decoration: BoxDecorationMix(
              border: BoxBorderMix.all(
                BorderSideMix(
                  color: RadixTokens.focusA8(),
                  width: RadixTokens.focusRingWidth(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static RemixSelectStyle triggerSoft() {
    return RemixSelectStyle(
      trigger: RemixSelectTriggerStyle(
        container: FlexBoxStyler(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(
              BorderSideMix(color: RadixTokens.accent6(), width: 1.0),
            ),
            borderRadius: BorderRadiusMix.all(RadixTokens.radius3()),
            color: RadixTokens.accent3(),
          ),
          padding:
              EdgeInsetsGeometryMix.symmetric(vertical: 8.0, horizontal: 12.0),
          constraints: BoxConstraintsMix(minHeight: 28.0, maxHeight: 28.0),
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
        label: TextStyler().color(RadixTokens.accent11()),
        icon: IconStyler(color: RadixTokens.accent11(), size: 16.0),
      ),
    ).onFocused(
      RemixSelectStyle(
        trigger: RemixSelectTriggerStyle(
          container: FlexBoxStyler(
            decoration: BoxDecorationMix(
              border: BoxBorderMix.all(
                BorderSideMix(
                  color: RadixTokens.focusA8(),
                  width: RadixTokens.focusRingWidth(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static RemixSelectStyle triggerGhost() {
    return RemixSelectStyle(
      trigger: RemixSelectTriggerStyle(
        container: FlexBoxStyler(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.all(RadixTokens.radius3()),
            color: Colors.transparent,
          ),
          // Per JSON ghost paddings: X = space-3 (12px), Y = space-1 * 1.5 (~6px)
          padding:
              EdgeInsetsGeometryMix.symmetric(vertical: 6.0, horizontal: 12.0),
          constraints: BoxConstraintsMix(minHeight: 28.0, maxHeight: 28.0),
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
        label: TextStyler().color(RadixTokens.gray12()),
        icon: IconStyler(color: RadixTokens.gray12(), size: 16.0),
      ),
    ).onFocused(
      RemixSelectStyle(
        trigger: RemixSelectTriggerStyle(
          container: FlexBoxStyler(
            decoration: BoxDecorationMix(
              border: BoxBorderMix.all(
                BorderSideMix(
                  color: RadixTokens.focusA8(),
                  width: RadixTokens.focusRingWidth(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Content (menu) variants

  static RemixSelectStyle contentSolid() {
    return RemixSelectStyle(
      menuContainer: BoxStyler(
        decoration: BoxDecorationMix(
          border: BoxBorderMix.all(
            BorderSideMix(color: RadixTokens.gray6(), width: 1.0),
          ),
          borderRadius: BorderRadiusMix.all(RadixTokens.radius3()),
          color: RadixTokens.colorPanelSolid(),
        ),
      ).padding(
        EdgeInsetsGeometryMix.all(8.0),
      ), // select-content-padding = space-2
      item: RemixSelectMenuItemStyle(
        container: FlexBoxStyler(
          constraints: BoxConstraintsMix(minHeight: 24.0, maxHeight: 24.0),
          padding: EdgeInsetsGeometryMix.symmetric(horizontal: 8.0),
        ),
        text: TextStyler().color(RadixTokens.gray12()),
        icon: IconStyler(size: 20.0), // select-item-indicator-width = space-5
      ),
    );
  }

  static RemixSelectStyle contentSoft() {
    return RemixSelectStyle(
      menuContainer: BoxStyler(
        decoration: BoxDecorationMix(
          border: BoxBorderMix.all(
            BorderSideMix(color: RadixTokens.gray6(), width: 1.0),
          ),
          borderRadius: BorderRadiusMix.all(RadixTokens.radius3()),
          color: RadixTokens.colorPanelTranslucent(),
        ),
      ).padding(
        EdgeInsetsGeometryMix.all(8.0),
      ), // select-content-padding = space-2
      item: RemixSelectMenuItemStyle(
        container: FlexBoxStyler(
          constraints: BoxConstraintsMix(minHeight: 24.0, maxHeight: 24.0),
          padding: EdgeInsetsGeometryMix.symmetric(horizontal: 8.0),
        ),
        text: TextStyler().color(RadixTokens.gray12()),
        icon: IconStyler(size: 20.0),
      ),
    );
  }
}
