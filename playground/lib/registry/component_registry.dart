import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

import '../preview_shell/preview_shell.dart';
import '../routes/all_components.dart';
import 'entries/avatar_entry.dart';
import 'entries/badge_entry.dart';
import 'entries/button_entry.dart';
import 'entries/callout_entry.dart';
import 'entries/card_entry.dart';
import 'entries/checkbox_entry.dart';
import 'entries/divider_entry.dart';
import 'entries/progress_entry.dart';
import 'entries/radio_entry.dart';
import 'entries/select_entry.dart';
import 'entries/slider_entry.dart';
import 'entries/spinner_entry.dart';
import 'entries/switch_entry.dart';
import 'entries/textfield_entry.dart';
import 'entries/tooltip_entry.dart';

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
  'checkbox': (_) => createRemixScope(
        child: PreviewShell(
          child: buildCheckboxExample(),
        ),
      ),
  'radio': (_) => createRemixScope(
        child: PreviewShell(
          child: buildRadioExample(),
        ),
      ),
  'select': (_) => createRemixScope(
        child: PreviewShell(
          child: buildSelectExample(),
        ),
      ),
  'switch': (_) => createRemixScope(
        child: PreviewShell(
          child: buildSwitchExample(),
        ),
      ),
  'slider': (_) => createRemixScope(
        child: PreviewShell(
          child: buildSliderExample(),
        ),
      ),
  // A consolidated page to preview all components together
  'all': (_) => createRemixScope(
        child: const PreviewShell(
          child: AllComponentsPage(),
        ),
      ),
  'avatar': (_) => createRemixScope(
        child: PreviewShell(
          child: buildAvatarExample(),
        ),
      ),
  'badge': (_) => createRemixScope(
        child: PreviewShell(
          child: buildBadgeExample(),
        ),
      ),
  'card': (_) => createRemixScope(
        child: PreviewShell(
          child: buildCardExample(),
        ),
      ),
  'callout': (_) => createRemixScope(
        child: PreviewShell(
          child: buildCalloutExample(),
        ),
      ),
  'divider': (_) => createRemixScope(
        child: PreviewShell(
          child: buildDividerExample(),
        ),
      ),
  'progress': (_) => createRemixScope(
        child: PreviewShell(
          child: buildProgressExample(),
        ),
      ),
  'spinner': (_) => createRemixScope(
        child: PreviewShell(
          child: buildSpinnerExample(),
        ),
      ),
  'tooltip': (_) => createRemixScope(
        child: PreviewShell(
          child: buildTooltipExample(),
        ),
      ),
};

List<String> get availableComponents => components.keys.toList()..sort();
