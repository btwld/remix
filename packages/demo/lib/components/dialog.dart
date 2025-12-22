import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final _key = GlobalKey();

@widgetbook.UseCase(
  name: 'Dialog Component',
  type: RemixDialog,
)
Widget buildDialogUseCase(BuildContext context) {
  return KeyedSubtree(
    key: _key,
    child: Scaffold(
      body: Center(
        child: Center(
          child: RemixButton(
            label: 'Open Dialog',
            onPressed: () {
              showRemixDialog(
                context: context,
                builder: (context) => Center(
                  child: RemixDialog(
                    title: 'Revoke access',
                    description:
                        'Are you sure? This application will no longer be accessible and any existing sessions will be expired.',
                    style: FortalDialogStyles.create(),
                    actions: [
                      RemixButton(
                        label: 'Cancel',
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: FortalButtonStyles.create(
                          variant: FortalButtonVariant.ghost,
                        ),
                      ),
                      RemixButton(
                        label: 'Revoke access',
                        onPressed: () {},
                        style: FortalButtonStyles.create(),
                      ),
                    ],
                  ),
                ),
              );
            },
            style: FortalButtonStyles.create(),
          ),
        ),
      ),
    ),
  );
}
