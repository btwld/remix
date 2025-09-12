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
          padding: EdgeInsetsGeometryMix.symmetric(
            vertical: 8.0,
            horizontal: 12.0,
          ),
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
        label: TextStyler().color(RadixTokens.gray12()),
        icon: IconStyler(color: RadixTokens.gray12()),
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
          padding: EdgeInsetsGeometryMix.symmetric(
            vertical: 8.0,
            horizontal: 12.0,
          ),
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
        label: TextStyler().color(RadixTokens.gray12()),
        icon: IconStyler(color: RadixTokens.gray12()),
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
          padding: EdgeInsetsGeometryMix.symmetric(
            vertical: 8.0,
            horizontal: 12.0,
          ),
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
        label: TextStyler().color(RadixTokens.accent11()),
        icon: IconStyler(color: RadixTokens.accent11()),
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
          padding: EdgeInsetsGeometryMix.symmetric(
            vertical: 8.0,
            horizontal: 12.0,
          ),
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
        label: TextStyler().color(RadixTokens.gray12()),
        icon: IconStyler(color: RadixTokens.gray12()),
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
      ),
      item: RemixSelectMenuItemStyle(
        text: TextStyler().color(RadixTokens.gray12()),
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
      ),
      item: RemixSelectMenuItemStyle(
        text: TextStyler().color(RadixTokens.gray12()),
      ),
    );
  }
}
