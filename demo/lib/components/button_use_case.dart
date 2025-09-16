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
          // Use default Radix solid variant layered over base metrics
          RemixButtonStyle buttonStyle = RadixButtonStyles.solid();

          return RemixButton(
            onPressed: () {
              debugPrint('✅ RemixButton pressed');
            },
            onLongPress: context.knobs.boolean(
              label: 'Enable Long Press',
              initialValue: true,
            )
                ? () {
                    debugPrint('⏳ RemixButton long pressed');
                  }
                : null,
            onDoubleTap: context.knobs.boolean(
              label: 'Enable Double Tap',
              initialValue: true,
            )
                ? () {
                    debugPrint('⚡ RemixButton double tapped');
                  }
                : null,
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
