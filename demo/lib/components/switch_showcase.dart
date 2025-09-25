import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Switch Showcase',
  type: RemixSwitch,
)
Widget buildSwitchShowcase(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Switch Components',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Basic states demonstration
            _buildSection(
              'Basic States',
              [
                _buildBasicStatesDemo(),
              ],
            ),

            // Interactive states section
            _buildSection(
              'Interactive States',
              [
                _buildInteractiveStatesDemo(),
              ],
            ),

            // With Labels section
            _buildSection(
              'With Labels & Layouts',
              [
                _buildLabelLayoutsDemo(),
              ],
            ),

            // Event handling & tracking
            _buildSection(
              'Event Handling & State Tracking',
              [
                _buildEventHandlingDemo(),
              ],
            ),

            // Real-world examples
            _buildSection(
              'Real-World Examples',
              [
                _buildRealWorldExamples(),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildSection(String title, List<Widget> children) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 12),
      ...children,
      const SizedBox(height: 24),
    ],
  );
}

Widget _buildBasicStatesDemo() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Basic switch states and behaviors:',
        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
      ),
      const SizedBox(height: 16),
      Wrap(
        spacing: 24,
        runSpacing: 16,
        children: [
          _buildLabeledSwitch('Off', false, enabled: true),
          _buildLabeledSwitch('On', true, enabled: true),
          _buildLabeledSwitch('Disabled Off', false, enabled: false),
          _buildLabeledSwitch('Disabled On', true, enabled: false),
        ],
      ),
    ],
  );
}

Widget _buildInteractiveStatesDemo() {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Interactive switches with state tracking:',
        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
      ),
      SizedBox(height: 16),
      Wrap(
        spacing: 24,
        runSpacing: 20,
        children: [
          _StateTrackingSwitch(label: 'Click & Hover Me'),
          _StateTrackingSwitch(label: 'Focus with Tab', autoFocus: true),
        ],
      ),
    ],
  );
}

class _StateTrackingSwitch extends StatefulWidget {
  final String label;
  final bool autoFocus;

  const _StateTrackingSwitch({
    required this.label,
    this.autoFocus = false,
  });

  @override
  State<_StateTrackingSwitch> createState() => _StateTrackingSwitchState();
}

class _StateTrackingSwitchState extends State<_StateTrackingSwitch> {
  bool _selected = false;
  int _toggleCount = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RemixSwitch(
              selected: _selected,
              autofocus: widget.autoFocus,
              onChanged: (value) {
                setState(() {
                  _selected = value;
                  _toggleCount++;
                });
                debugPrint('${widget.label}: ${value ? 'ON' : 'OFF'} (toggles: $_toggleCount)');
              },
              semanticLabel: widget.label,
            ),
            const SizedBox(width: 12),
            Text(widget.label),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'State: ${_selected ? 'ON' : 'OFF'} | Toggles: $_toggleCount',
          style: TextStyle(
            fontSize: 10,
            color: MixColors.grey[600],
          ),
        ),
      ],
    );
  }
}

Widget _buildLabelLayoutsDemo() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Different label layouts and arrangements:',
        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
      ),
      const SizedBox(height: 16),

      // Left label
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Left Label'),
          const SizedBox(width: 12),
          _buildSimpleSwitch(true),
        ],
      ),
      const SizedBox(height: 12),

      // Right label
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSimpleSwitch(false),
          const SizedBox(width: 12),
          const Text('Right Label'),
        ],
      ),
      const SizedBox(height: 12),

      // Vertical layout
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Top Label'),
          const SizedBox(height: 8),
          _buildSimpleSwitch(true),
        ],
      ),
      const SizedBox(height: 16),

      // Card style layout
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: MixColors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Card Style Toggle',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'With detailed description underneath',
                    style: TextStyle(
                      fontSize: 12,
                      color: MixColors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            _buildSimpleSwitch(false),
          ],
        ),
      ),
    ],
  );
}

Widget _buildEventHandlingDemo() {
  return _EventHandlingDemo();
}

class _EventHandlingDemo extends StatefulWidget {
  @override
  State<_EventHandlingDemo> createState() => _EventHandlingDemoState();
}

class _EventHandlingDemoState extends State<_EventHandlingDemo> {
  final List<String> _eventLog = [];
  bool _logEnabled = true;

  void _logEvent(String event) {
    if (_logEnabled) {
      setState(() {
        _eventLog.insert(0, '${DateTime.now().toIso8601String().split('T')[1].split('.')[0]}: $event');
        if (_eventLog.length > 5) {
          _eventLog.removeLast();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Event callbacks and logging demonstration:',
          style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: 16),

        // Enable/disable logging
        Row(
          children: [
            RemixSwitch(
              selected: _logEnabled,
              onChanged: (value) {
                setState(() {
                  _logEnabled = value;
                  if (!_logEnabled) {
                    _eventLog.clear();
                  }
                });
              },
              semanticLabel: 'Enable Event Logging',
            ),
            const SizedBox(width: 12),
            const Text('Enable Event Logging'),
          ],
        ),

        const SizedBox(height: 16),

        // Demo switches
        Wrap(
          spacing: 24,
          runSpacing: 12,
          children: [
            _EventSwitch(label: 'Feature A', onEvent: _logEvent),
            _EventSwitch(label: 'Feature B', onEvent: _logEvent),
            _EventSwitch(label: 'Feature C', onEvent: _logEvent),
          ],
        ),

        const SizedBox(height: 16),

        // Event log display
        Container(
          width: double.infinity,
          height: 140,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: MixColors.grey[900],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Event Log:',
                style: TextStyle(
                  color: MixColors.grey[300],
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _eventLog.isNotEmpty
                        ? _eventLog.map((event) => Text(
                            event,
                            style: TextStyle(
                              color: MixColors.green[400],
                              fontFamily: 'Courier',
                              fontSize: 11,
                            ),
                          )).toList()
                        : [
                            Text(
                              _logEnabled ? 'No events yet...' : 'Event logging disabled',
                              style: TextStyle(
                                color: MixColors.grey[500],
                                fontStyle: FontStyle.italic,
                                fontSize: 11,
                              ),
                            ),
                          ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EventSwitch extends StatefulWidget {
  final String label;
  final Function(String) onEvent;

  const _EventSwitch({required this.label, required this.onEvent});

  @override
  State<_EventSwitch> createState() => _EventSwitchState();
}

class _EventSwitchState extends State<_EventSwitch> {
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RemixSwitch(
              selected: _selected,
              onChanged: (value) {
                setState(() => _selected = value);
                widget.onEvent('${widget.label}: ${value ? 'ON' : 'OFF'}');
              },
              semanticLabel: widget.label,
            ),
            const SizedBox(width: 8),
            Text(widget.label),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          _selected ? 'Enabled' : 'Disabled',
          style: TextStyle(
            fontSize: 10,
            color: _selected ? MixColors.green[600] : MixColors.grey[500],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

Widget _buildRealWorldExamples() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Real-world usage examples:',
        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
      ),
      const SizedBox(height: 16),

      // Settings panel
      _SettingsPanelExample(),
      const SizedBox(height: 24),

      // Feature flags dashboard
      _FeatureFlagsExample(),
      const SizedBox(height: 24),

      // Privacy settings
      _PrivacySettingsExample(),
    ],
  );
}

class _SettingsPanelExample extends StatefulWidget {
  @override
  State<_SettingsPanelExample> createState() => _SettingsPanelExampleState();
}

class _SettingsPanelExampleState extends State<_SettingsPanelExample> {
  bool _darkMode = false;
  bool _notifications = true;
  bool _soundEffects = true;
  bool _analytics = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: MixColors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'App Settings',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Customize your app experience:',
            style: TextStyle(color: MixColors.grey[600]),
          ),
          const SizedBox(height: 16),

          _SettingItem(
            icon: Icons.dark_mode,
            title: 'Dark Mode',
            description: 'Switch to dark theme',
            value: _darkMode,
            onChanged: (value) => setState(() => _darkMode = value),
          ),

          _SettingItem(
            icon: Icons.notifications,
            title: 'Push Notifications',
            description: 'Receive app notifications',
            value: _notifications,
            onChanged: (value) => setState(() => _notifications = value),
          ),

          _SettingItem(
            icon: Icons.volume_up,
            title: 'Sound Effects',
            description: 'Play sounds for interactions',
            value: _soundEffects,
            onChanged: (value) => setState(() => _soundEffects = value),
          ),

          _SettingItem(
            icon: Icons.analytics,
            title: 'Analytics',
            description: 'Help improve the app',
            value: _analytics,
            onChanged: (value) => setState(() => _analytics = value),
          ),
        ],
      ),
    );
  }
}

class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: MixColors.grey[600], size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: MixColors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          RemixSwitch(
            selected: value,
            onChanged: onChanged,
            semanticLabel: title,
          ),
        ],
      ),
    );
  }
}

class _FeatureFlagsExample extends StatefulWidget {
  @override
  State<_FeatureFlagsExample> createState() => _FeatureFlagsExampleState();
}

class _FeatureFlagsExampleState extends State<_FeatureFlagsExample> {
  final Map<String, bool> _features = {
    'experimental_ui': false,
    'beta_search': true,
    'new_dashboard': false,
    'advanced_filters': true,
    'dark_mode_v2': false,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: MixColors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.flag, color: MixColors.blue[600]),
              const SizedBox(width: 8),
              const Text(
                'Feature Flags Dashboard',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Enable or disable experimental features:',
            style: TextStyle(color: MixColors.grey[600]),
          ),
          const SizedBox(height: 16),

          ..._features.entries.map((entry) => _FeatureFlagItem(
            key: ValueKey(entry.key),
            flagKey: entry.key,
            value: entry.value,
            onChanged: (value) {
              setState(() => _features[entry.key] = value);
              debugPrint('Feature ${entry.key}: ${value ? 'ENABLED' : 'DISABLED'}');
            },
          )),

          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: MixColors.amber[50],
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: MixColors.amber[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber, size: 16, color: MixColors.amber[700]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Changes take effect after app restart',
                    style: TextStyle(
                      fontSize: 12,
                      color: MixColors.amber[800],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureFlagItem extends StatelessWidget {
  final String flagKey;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _FeatureFlagItem({
    super.key,
    required this.flagKey,
    required this.value,
    required this.onChanged,
  });

  String get _displayName {
    return flagKey
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String get _description {
    switch (flagKey) {
      case 'experimental_ui':
        return 'New experimental user interface';
      case 'beta_search':
        return 'Improved search functionality (beta)';
      case 'new_dashboard':
        return 'Redesigned dashboard layout';
      case 'advanced_filters':
        return 'Advanced filtering options';
      case 'dark_mode_v2':
        return 'Next generation dark mode';
      default:
        return 'Feature flag: $flagKey';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: value ? MixColors.green[500] : MixColors.grey[400],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _displayName,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  _description,
                  style: TextStyle(
                    fontSize: 12,
                    color: MixColors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          RemixSwitch(
            selected: value,
            onChanged: onChanged,
            semanticLabel: _displayName,
          ),
        ],
      ),
    );
  }
}

class _PrivacySettingsExample extends StatefulWidget {
  @override
  State<_PrivacySettingsExample> createState() => _PrivacySettingsExampleState();
}

class _PrivacySettingsExampleState extends State<_PrivacySettingsExample> {
  bool _shareUsageData = false;
  bool _personalizedAds = false;
  bool _locationServices = true;
  bool _crashReporting = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: MixColors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.privacy_tip, color: MixColors.blue[600]),
              const SizedBox(width: 8),
              const Text(
                'Privacy Settings',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Control how your data is used:',
            style: TextStyle(color: MixColors.grey[600]),
          ),
          const SizedBox(height: 16),

          _PrivacyItem(
            title: 'Share Usage Data',
            description: 'Help improve the app by sharing anonymous usage data',
            value: _shareUsageData,
            onChanged: (value) => setState(() => _shareUsageData = value),
            isRecommended: false,
          ),

          _PrivacyItem(
            title: 'Personalized Ads',
            description: 'Show ads based on your interests and activity',
            value: _personalizedAds,
            onChanged: (value) => setState(() => _personalizedAds = value),
            isRecommended: false,
          ),

          _PrivacyItem(
            title: 'Location Services',
            description: 'Allow location-based features and recommendations',
            value: _locationServices,
            onChanged: (value) => setState(() => _locationServices = value),
            isRecommended: true,
          ),

          _PrivacyItem(
            title: 'Crash Reporting',
            description: 'Automatically send crash reports to help fix bugs',
            value: _crashReporting,
            onChanged: (value) => setState(() => _crashReporting = value),
            isRecommended: true,
          ),

          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: MixColors.blue[50],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Your privacy choices are saved automatically and can be changed at any time.',
              style: TextStyle(
                fontSize: 12,
                color: MixColors.blue[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrivacyItem extends StatelessWidget {
  final String title;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isRecommended;

  const _PrivacyItem({
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
    required this.isRecommended,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    if (isRecommended) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: MixColors.green[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Recommended',
                          style: TextStyle(
                            fontSize: 10,
                            color: MixColors.green[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: MixColors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          RemixSwitch(
            selected: value,
            onChanged: onChanged,
            semanticLabel: title,
          ),
        ],
      ),
    );
  }
}

// Helper functions
Widget _buildLabeledSwitch(String label, bool selected, {bool enabled = true}) {
  return Column(
    children: [
      RemixSwitch(
        selected: selected,
        enabled: enabled,
        onChanged: (bool value) {
          if (enabled) {
            debugPrint('$label: $value');
          }
        },
        semanticLabel: label,
      ),
      const SizedBox(height: 8),
      Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: enabled ? null : MixColors.grey[500],
        ),
      ),
    ],
  );
}

Widget _buildSimpleSwitch(bool selected, {ValueChanged<bool>? onChanged}) {
  return RemixSwitch(
    selected: selected,
    onChanged: onChanged ?? (value) => debugPrint('Switch: $value'),
  );
}