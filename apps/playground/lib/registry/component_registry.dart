import 'package:flutter/widgets.dart';

import '../preview_shell/preview_shell.dart';
import '../ui/ui.dart';
import '../routes/all_components.dart';
import 'entries/avatar_entry.dart';
import 'entries/agent_entries.dart';
import 'entries/badge_entry.dart';
import 'entries/button_entry.dart';
import 'entries/callout_entry.dart';
import 'entries/card_entry.dart';
import 'entries/checkbox_entry.dart';
import 'entries/checkbox_group_entry.dart';
import 'entries/divider_entry.dart';
import 'entries/dashboard_entry.dart';
import 'entries/dashboard_shell_entry.dart';
import 'entries/progress_entry.dart';
import 'entries/radio_entry.dart';
import 'entries/select_entry.dart';
import 'entries/skeleton_entry.dart';
import 'entries/slider_entry.dart';
import 'entries/spinner_entry.dart';
import 'entries/switch_entry.dart';
import 'entries/textfield_entry.dart';
import 'entries/tooltip_entry.dart';

// Map component slugs to a builder that returns the component inside the
// installed theme scope, resolved for the preview's current brightness.

// Read brightness from MediaQuery, not Theme: the app host is WidgetsApp and
// installs no Material Theme. PreviewShell publishes its light/dark control
// through `MediaQuery(platformBrightness: ...)`, so an entry that resolves the
// scope inside the shell follows that control.
Widget _scope(BuildContext context, Widget child) => PlaygroundThemeScope(
  data: MediaQuery.platformBrightnessOf(context) == Brightness.dark
      ? const PlaygroundThemeData.dark()
      : const PlaygroundThemeData.light(),
  child: child,
);

final Map<String, WidgetBuilder> components = {
  'dashboard_shell': (context) => PreviewShell(
    initialSize: const Size(1200, 800),
    child: Builder(
      builder: (context) => _scope(context, const DashboardShellExample()),
    ),
  ),
  'agent-activity': (context) =>
      PreviewShell(child: Builder(builder: buildAgentActivity)),
  'agent-answer': (context) =>
      PreviewShell(child: Builder(builder: buildAgentAnswer)),
  'agent-composer': (context) =>
      PreviewShell(child: Builder(builder: buildAgentComposer)),
  'agent-execution': (context) =>
      PreviewShell(child: Builder(builder: buildAgentExecution)),
  'agent-message': (context) =>
      PreviewShell(child: Builder(builder: buildAgentMessage)),
  'agent-permission': (context) =>
      PreviewShell(child: Builder(builder: buildAgentPermission)),
  'agent-plan': (context) =>
      PreviewShell(child: Builder(builder: buildAgentPlan)),
  'agent-transcript': (context) =>
      PreviewShell(child: Builder(builder: buildAgentTranscript)),
  'chat': (context) => PreviewShell(
    initialSize: const Size(900, 720),
    child: Builder(builder: buildAgentChat),
  ),
  'dashboard': (context) => const PreviewShell(
    initialSize: Size(1280, 800),
    child: Builder(builder: buildDashboardExample),
  ),
  'button': (context) =>
      _scope(context, PreviewShell(child: buildButtonExample())),
  'textfield': (context) =>
      _scope(context, PreviewShell(child: buildTextFieldExample())),
  'checkbox': (context) =>
      _scope(context, PreviewShell(child: buildCheckboxExample())),
  'checkbox_group': (context) => PreviewShell(
    child: Builder(
      builder: (context) => _scope(context, buildCheckboxGroupExample()),
    ),
  ),
  'radio': (context) =>
      _scope(context, PreviewShell(child: buildRadioExample())),
  'select': (context) =>
      _scope(context, PreviewShell(child: buildSelectExample())),
  'switch': (context) =>
      _scope(context, PreviewShell(child: buildSwitchExample())),
  'slider': (context) =>
      _scope(context, PreviewShell(child: buildSliderExample())),
  'all': (context) =>
      _scope(context, const PreviewShell(child: AllComponentsPage())),
  'avatar': (context) =>
      _scope(context, PreviewShell(child: buildAvatarExample())),
  'badge': (context) =>
      _scope(context, PreviewShell(child: buildBadgeExample())),
  'card': (context) => _scope(context, PreviewShell(child: buildCardExample())),
  'callout': (context) =>
      _scope(context, PreviewShell(child: buildCalloutExample())),
  'divider': (context) =>
      _scope(context, PreviewShell(child: buildDividerExample())),
  'progress': (context) =>
      _scope(context, PreviewShell(child: buildProgressExample())),
  'skeleton': (context) => PreviewShell(
    child: Builder(
      builder: (context) => _scope(context, buildSkeletonExample()),
    ),
  ),
  'spinner': (context) =>
      _scope(context, PreviewShell(child: buildSpinnerExample())),
  'tooltip': (context) =>
      _scope(context, PreviewShell(child: buildTooltipExample())),
};

List<String> get availableComponents => components.keys.toList()..sort();
