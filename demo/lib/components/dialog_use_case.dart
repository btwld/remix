import 'package:flutter/material.dart' as m;

import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final _key = GlobalKey();

@widgetbook.UseCase(
  name: 'Dialog Component',
  type: Dialog,
)
Widget buildButtonUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Edit profile',
  );
  final description = context.knobs.string(
    label: 'Description',
    initialValue:
        'Make changes to your profile here. Click save when you\'re done.',
  );
  final actions = context.knobs.boolean(
    label: 'Actions',
    initialValue: true,
  );

  return KeyedSubtree(
    key: _key,
    child: m.Scaffold(
      body: Builder(builder: (context) {
        return Center(
          child: m.TextButton(
            child: const Text('Show dialog'),
            onPressed: () {
              showDialog(
                useRootNavigator: false,
                context: context,
                builder: (BuildContext context) => Center(
                  child: SizedBox(
                    width: 350,
                    child: Dialog(
                      title: title,
                      description: description,
                      actions: actions
                          ? [
                              m.TextButton(
                                onPressed: () {},
                                child: const Text('Save'),
                              ),
                            ]
                          : null,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    ),
  );
}
