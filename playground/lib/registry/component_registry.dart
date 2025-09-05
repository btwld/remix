import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

import '../preview_shell/preview_shell.dart';
import 'entries/button_entry.dart';
import 'entries/textfield_entry.dart';

// Map component slugs to a builder that returns the component inside createRemixScope.
final Map<String, WidgetBuilder> components = {
  'button': (_) => createRemixScope(
        child: PreviewShell(
          child: buildButtonExample(),
        ),
      ),
  'textfield': (_) => createRemixScope(
        child: PreviewShell(
          child: buildTextFieldExample(),
        ),
      ),
};

List<String> get availableComponents => components.keys.toList()..sort();

