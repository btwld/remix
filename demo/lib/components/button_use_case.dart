import 'package:demo/addons/icon_data_knob.dart';
import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final _key = GlobalKey();

@widgetbook.UseCase(
  name: 'Button Component',
  type: RemixButton,
)
Widget buildButtonUseCase(BuildContext context) {
  return KeyedSubtree(
    key: _key,
    child: Scaffold(
      body: Center(
        child: Builder(builder: (context) {
          // Style selection with simplified options
          final styleVariant = context.knobs.string(
            label: 'Style',
            initialValue: 'primary',
          );
          
          final sizeVariant = context.knobs.string(
            label: 'Size',
            initialValue: 'medium',
          );

          // Map style variants
          RemixButtonStyle? buttonStyle;
          switch (styleVariant) {
            // Solid variants
            case 'primary':
              buttonStyle = ButtonVariants.primary;
              break;
            case 'secondary':
              buttonStyle = ButtonVariants.secondary;
              break;
            case 'success':
              buttonStyle = ButtonVariants.success;
              break;
            case 'danger':
              buttonStyle = ButtonVariants.danger;
              break;
            case 'warning':
              buttonStyle = ButtonVariants.warning;
              break;
            // Outline variants
            case 'primaryOutline':
              buttonStyle = ButtonVariants.primaryOutline;
              break;
            case 'secondaryOutline':
              buttonStyle = ButtonVariants.secondaryOutline;
              break;
            case 'successOutline':
              buttonStyle = ButtonVariants.successOutline;
              break;
            case 'dangerOutline':
              buttonStyle = ButtonVariants.dangerOutline;
              break;
            // Ghost variants
            case 'primaryGhost':
              buttonStyle = ButtonVariants.primaryGhost;
              break;
            case 'secondaryGhost':
              buttonStyle = ButtonVariants.secondaryGhost;
              break;
            case 'successGhost':
              buttonStyle = ButtonVariants.successGhost;
              break;
            case 'dangerGhost':
              buttonStyle = ButtonVariants.dangerGhost;
              break;
            // Soft variants
            case 'primarySoft':
              buttonStyle = ButtonVariants.primarySoft;
              break;
            case 'secondarySoft':
              buttonStyle = ButtonVariants.secondarySoft;
              break;
            case 'successSoft':
              buttonStyle = ButtonVariants.successSoft;
              break;
            case 'dangerSoft':
              buttonStyle = ButtonVariants.dangerSoft;
              break;
            default:
              buttonStyle = ButtonVariants.primary;
          }
          
          // Apply size
          switch (sizeVariant) {
            case 'small':
              buttonStyle = buttonStyle.merge(ButtonVariants.small);
              break;
            case 'large':
              buttonStyle = buttonStyle.merge(ButtonVariants.large);
              break;
          }

          return RemixButton(
            onPressed: () {
              debugPrint('✅ RemixButton pressed');
            },
            onLongPress: context.knobs.boolean(
              label: 'Enable Long Press',
              initialValue: true,
            ) ? () {
              debugPrint('⏳ RemixButton long pressed');
            } : null,
            onDoubleTap: context.knobs.boolean(
              label: 'Enable Double Tap',
              initialValue: true,
            ) ? () {
              debugPrint('⚡ RemixButton double tapped');
            } : null,
            onHoverChange: (hovered) {
              debugPrint('🖱️  Hover state changed: $hovered');
            },
            onPressChanged: (pressed) {
              debugPrint('🔴 Pressed state changed: $pressed');
            },
            onFocusChange: (focused) {
              debugPrint('⌨️  Focus state changed: $focused');
            },
            onStatesChange: (states) {
              debugPrint('📊 Widget states: ${states.map((s) => s.name).join(', ')}');
            },
            enabled: context.knobs.boolean(
              label: 'Enabled',
              initialValue: true,
            ),
            loading: context.knobs.boolean(
              label: 'Loading',
              initialValue: false,
            ),
            label: context.knobs.string(
              label: 'label',
              initialValue: 'Interactive Button',
            ),
            leading: context.knobs.iconData(
              label: 'Icon',
              initialValue: Icons.touch_app,
            ),
            style: buttonStyle,
          );
        }),
      ),
    ),
  );
}
