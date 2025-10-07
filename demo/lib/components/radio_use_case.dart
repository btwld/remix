import 'package:demo/helpers/string.dart';
import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

enum Theme {
  dark,
  light,
  system;
}

@widgetbook.UseCase(
  name: 'Radio Component',
  type: RemixRadio,
)
Widget buildRadioUseCase(BuildContext context) {
  return Scaffold(
    body: Center(
      child: ListenableBuilder(
        listenable: _state,
        builder: (context, child) {
          return RemixRadioGroup<Theme>(
            groupValue: _state.value,
            onChanged: (value) {
              _state.update(value!);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: Theme.values
                  .map(
                    (theme) => Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RemixRadio<Theme>(
                            value: theme,
                            enabled: context.knobs.boolean(
                              label: 'Enabled',
                              initialValue: true,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(theme.name.capitalize()),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          );
        },
      ),
    ),
  );
}

class _ThemeState extends ValueNotifier<Theme> {
  _ThemeState(super.value);

  void update(Theme value) {
    this.value = value;
    notifyListeners();
  }
}

_ThemeState _state = _ThemeState(Theme.dark);
