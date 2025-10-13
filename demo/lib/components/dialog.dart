import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final _key = GlobalKey();

@widgetbook.UseCase(
  name: 'Dialog Component',
  type: RemixDialog,
)
Widget buildDividerUseCase(BuildContext context) {
  return KeyedSubtree(
    key: _key,
    child: Scaffold(
      body: Center(
        child: SizedBox(
          height: 300,
          width: 300,
          child: Center(
            child: RemixButton(
              label: 'Open Dialog',
              onPressed: () {
                showAboutDialog(context: context);
                showRemixDialog(
                  context: context,
                  builder: (context) => RemixDialog(
                    title: 'Dialog',
                    description: 'Dialog description',
                    style: FortalDialogStyle.create(),
                    actions: [
                      RemixButton(label: 'Close', onPressed: () {}),
                    ],
                  ),
                );
              },
              style: FortalButtonStyle.create(),
            ),
          ),
        ),
      ),
    ),
  );
}
