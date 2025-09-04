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
              buttonStyle = RemixButtonStyles.primary;
              break;
            case 'secondary':
              buttonStyle = RemixButtonStyles.secondary;
              break;
            case 'success':
              buttonStyle = RemixButtonStyles.success;
              break;
            case 'danger':
              buttonStyle = RemixButtonStyles.danger;
              break;
            case 'warning':
              buttonStyle = RemixButtonStyles.warning;
              break;
            // Outline variants
            case 'primaryOutline':
              buttonStyle = RemixButtonStyles.primaryOutline;
              break;
            case 'secondaryOutline':
              buttonStyle = RemixButtonStyles.secondaryOutline;
              break;
            case 'successOutline':
              buttonStyle = RemixButtonStyles.successOutline;
              break;
            case 'dangerOutline':
              buttonStyle = RemixButtonStyles.dangerOutline;
              break;
            // Ghost variants
            case 'primaryGhost':
              buttonStyle = RemixButtonStyles.primaryGhost;
              break;
            case 'secondaryGhost':
              buttonStyle = RemixButtonStyles.secondaryGhost;
              break;
            case 'successGhost':
              buttonStyle = RemixButtonStyles.successGhost;
              break;
            case 'dangerGhost':
              buttonStyle = RemixButtonStyles.dangerGhost;
              break;
            // Soft variants
            case 'primarySoft':
              buttonStyle = RemixButtonStyles.primarySoft;
              break;
            case 'secondarySoft':
              buttonStyle = RemixButtonStyles.secondarySoft;
              break;
            case 'successSoft':
              buttonStyle = RemixButtonStyles.successSoft;
              break;
            case 'dangerSoft':
              buttonStyle = RemixButtonStyles.dangerSoft;
              break;
            default:
              buttonStyle = RemixButtonStyles.primary;
          }
          
          // Apply size
          switch (sizeVariant) {
            case 'small':
              buttonStyle = buttonStyle.merge(RemixButtonStyles.small);
              break;
            case 'large':
              buttonStyle = buttonStyle.merge(RemixButtonStyles.large);
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
            icon: context.knobs.iconData(
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
