import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Checkbox Showcase',
  type: RemixCheckbox,
)
Widget buildCheckboxShowcase(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Checkbox Variants',
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

            // Tristate demonstration
            _buildSection(
              'Tristate (Indeterminate)',
              [
                _buildTristateDemo(),
              ],
            ),

            // States section
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

            // Event Handling Demo
            _buildSection(
              'Event Handling & State Tracking',
              [
                _buildEventHandlingDemo(),
              ],
            ),

            // Real-world Examples
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
        'Basic checkbox states with different selections:',
        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
      ),
      const SizedBox(height: 16),
      Wrap(
        spacing: 24,
        runSpacing: 16,
        children: [
          _buildLabeledCheckbox('Unchecked', false, enabled: true),
          _buildLabeledCheckbox('Checked', true, enabled: true),
          _buildLabeledCheckbox('Disabled Unchecked', false, enabled: false),
          _buildLabeledCheckbox('Disabled Checked', true, enabled: false),
        ],
      ),
    ],
  );
}

Widget _buildTristateDemo() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Tristate checkboxes can be true, false, or null (indeterminate):',
        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
      ),
      const SizedBox(height: 16),
      _TristateDemo(),
    ],
  );
}

class _TristateDemo extends StatefulWidget {
  @override
  State<_TristateDemo> createState() => _TristateState();
}

class _TristateState extends State<_TristateDemo> {
  bool? _parentValue;
  bool _child1 = false;
  bool _child2 = false;
  bool _child3 = false;

  void _updateParent() {
    final checkedCount = [_child1, _child2, _child3].where((v) => v).length;
    setState(() {
      if (checkedCount == 0) {
        _parentValue = false;
      } else if (checkedCount == 3) {
        _parentValue = true;
      } else {
        _parentValue = null; // Indeterminate
      }
    });
  }

  void _updateChildren(bool? value) {
    setState(() {
      _parentValue = value;
      if (value != null) {
        _child1 = _child2 = _child3 = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Parent checkbox
        Row(
          children: [
            RemixCheckbox(
              selected: _parentValue,
              tristate: true,
              onChanged: _updateChildren,
              semanticLabel: 'Select All',
            ),
            const SizedBox(width: 8),
            const Text('Select All', style: TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 8),

        // Child checkboxes
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Column(
            children: [
              Row(
                children: [
                  RemixCheckbox(
                    selected: _child1,
                    onChanged: (value) {
                      setState(() => _child1 = value ?? false);
                      _updateParent();
                    },
                    semanticLabel: 'Option 1',
                  ),
                  const SizedBox(width: 8),
                  const Text('Option 1'),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  RemixCheckbox(
                    selected: _child2,
                    onChanged: (value) {
                      setState(() => _child2 = value ?? false);
                      _updateParent();
                    },
                    semanticLabel: 'Option 2',
                  ),
                  const SizedBox(width: 8),
                  const Text('Option 2'),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  RemixCheckbox(
                    selected: _child3,
                    onChanged: (value) {
                      setState(() => _child3 = value ?? false);
                      _updateParent();
                    },
                    semanticLabel: 'Option 3',
                  ),
                  const SizedBox(width: 8),
                  const Text('Option 3'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: MixColors.blue[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: MixColors.blue[200]!),
          ),
          child: Text(
            'Parent state: ${_parentValue == null ? 'Indeterminate' : _parentValue! ? 'All selected' : 'None selected'}',
            style: TextStyle(
              fontSize: 12,
              color: MixColors.blue[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

Widget _buildInteractiveStatesDemo() {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Interactive states with visual feedback:',
        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
      ),
      SizedBox(height: 16),
      Wrap(
        spacing: 24,
        runSpacing: 16,
        children: [
          _StateTrackingCheckbox(label: 'Hover & Click Me'),
          _StateTrackingCheckbox(label: 'Focus with Tab', autoFocus: true),
        ],
      ),
    ],
  );
}

class _StateTrackingCheckbox extends StatefulWidget {
  final String label;
  final bool autoFocus;

  const _StateTrackingCheckbox({
    required this.label,
    this.autoFocus = false,
  });

  @override
  State<_StateTrackingCheckbox> createState() => _StateTrackingCheckboxState();
}

class _StateTrackingCheckboxState extends State<_StateTrackingCheckbox> {
  bool _selected = false;
  int _changeCount = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            RemixCheckbox(
              selected: _selected,
              autofocus: widget.autoFocus,
              onChanged: (value) {
                setState(() {
                  _selected = value ?? false;
                  _changeCount++;
                });
                debugPrint('${widget.label}: ${value == true ? 'checked' : 'unchecked'} (count: $_changeCount)');
              },
              semanticLabel: widget.label,
            ),
            const SizedBox(width: 8),
            Text(widget.label),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'State: ${_selected ? 'Checked' : 'Unchecked'} | Changes: $_changeCount',
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
          const SizedBox(width: 8),
          _buildSimpleCheckbox(true),
        ],
      ),
      const SizedBox(height: 12),

      // Right label
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSimpleCheckbox(false),
          const SizedBox(width: 8),
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
          const SizedBox(height: 4),
          _buildSimpleCheckbox(true),
        ],
      ),
      const SizedBox(height: 12),

      // In a list tile style
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: MixColors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            _buildSimpleCheckbox(false),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'List Item Style',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'With description text below the main label',
                    style: TextStyle(
                      fontSize: 12,
                      color: MixColors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
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

        Row(
          children: [
            _buildSimpleCheckbox(_logEnabled, onChanged: (value) {
              setState(() => _logEnabled = value ?? false);
              if (!_logEnabled) {
                _eventLog.clear();
              }
            }),
            const SizedBox(width: 8),
            const Text('Enable Event Logging'),
          ],
        ),
        const SizedBox(height: 16),

        // Demo checkboxes
        Wrap(
          spacing: 24,
          children: [
            _EventCheckbox(label: 'Checkbox A', onEvent: _logEvent),
            _EventCheckbox(label: 'Checkbox B', onEvent: _logEvent),
            _EventCheckbox(label: 'Checkbox C', onEvent: _logEvent),
          ],
        ),

        const SizedBox(height: 16),

        // Event log display
        Container(
          width: double.infinity,
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
              ..._eventLog.map((event) => Text(
                event,
                style: TextStyle(
                  color: MixColors.green[400],
                  fontFamily: 'Courier',
                  fontSize: 11,
                ),
              )),
              if (_eventLog.isEmpty)
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
      ],
    );
  }
}

class _EventCheckbox extends StatefulWidget {
  final String label;
  final Function(String) onEvent;

  const _EventCheckbox({required this.label, required this.onEvent});

  @override
  State<_EventCheckbox> createState() => _EventCheckboxState();
}

class _EventCheckboxState extends State<_EventCheckbox> {
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        RemixCheckbox(
          selected: _selected,
          onChanged: (value) {
            setState(() => _selected = value ?? false);
            widget.onEvent('${widget.label}: ${value == true ? 'Checked' : 'Unchecked'}');
          },
          semanticLabel: widget.label,
        ),
        const SizedBox(width: 8),
        Text(widget.label),
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

      // Terms and conditions
      _TermsExample(),
      const SizedBox(height: 24),

      // Feature selection
      _FeatureSelectionExample(),
      const SizedBox(height: 24),

      // Task checklist
      _TaskChecklistExample(),
    ],
  );
}

class _TermsExample extends StatefulWidget {
  @override
  State<_TermsExample> createState() => _TermsExampleState();
}

class _TermsExampleState extends State<_TermsExample> {
  bool _acceptedTerms = false;
  bool _acceptedPrivacy = false;
  bool _acceptedMarketing = false;

  bool get canProceed => _acceptedTerms && _acceptedPrivacy;

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
            'Account Registration',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),

          // Required agreements
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RemixCheckbox(
                selected: _acceptedTerms,
                onChanged: (value) => setState(() => _acceptedTerms = value ?? false),
                semanticLabel: 'Accept Terms of Service',
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text('I accept the Terms of Service *'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RemixCheckbox(
                selected: _acceptedPrivacy,
                onChanged: (value) => setState(() => _acceptedPrivacy = value ?? false),
                semanticLabel: 'Accept Privacy Policy',
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text('I accept the Privacy Policy *'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Optional agreement
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RemixCheckbox(
                selected: _acceptedMarketing,
                onChanged: (value) => setState(() => _acceptedMarketing = value ?? false),
                semanticLabel: 'Receive marketing emails',
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text('I would like to receive marketing emails (optional)'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Submit button
          SizedBox(
            width: double.infinity,
            child: RemixButton(
              label: 'Create Account',
              onPressed: canProceed ? () => debugPrint('Account created!') : null,
              style: FortalButtonStyle.solid(),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureSelectionExample extends StatefulWidget {
  @override
  State<_FeatureSelectionExample> createState() => _FeatureSelectionExampleState();
}

class _FeatureSelectionExampleState extends State<_FeatureSelectionExample> {
  final Map<String, bool> _features = {
    'Dark Mode': true,
    'Push Notifications': false,
    'Auto-save': true,
    'Analytics': false,
    'Cloud Sync': true,
    'Offline Mode': false,
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
          const Text(
            'Feature Selection',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose which features you want to enable:',
            style: TextStyle(color: MixColors.grey[600]),
          ),
          const SizedBox(height: 16),

          ..._features.entries.map((entry) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                RemixCheckbox(
                  selected: entry.value,
                  onChanged: (value) {
                    setState(() => _features[entry.key] = value ?? false);
                  },
                  semanticLabel: entry.key,
                ),
                const SizedBox(width: 8),
                Text(entry.key),
              ],
            ),
          )),

          const SizedBox(height: 8),
          Text(
            'Selected: ${_features.values.where((v) => v).length} of ${_features.length} features',
            style: TextStyle(
              fontSize: 12,
              color: MixColors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskChecklistExample extends StatefulWidget {
  @override
  State<_TaskChecklistExample> createState() => _TaskChecklistExampleState();
}

class _TaskChecklistExampleState extends State<_TaskChecklistExample> {
  final List<Map<String, dynamic>> _tasks = [
    {'title': 'Set up development environment', 'completed': true},
    {'title': 'Create project structure', 'completed': true},
    {'title': 'Implement user authentication', 'completed': false},
    {'title': 'Design database schema', 'completed': false},
    {'title': 'Write API endpoints', 'completed': false},
    {'title': 'Create unit tests', 'completed': false},
  ];

  @override
  Widget build(BuildContext context) {
    final completedCount = _tasks.where((task) => task['completed']).length;
    final progress = completedCount / _tasks.length;

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Project Checklist',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Text(
                '$completedCount/${_tasks.length} completed',
                style: TextStyle(
                  color: MixColors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Progress bar
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: MixColors.grey[200],
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  color: progress == 1.0 ? MixColors.green[500] : MixColors.blue[500],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          ..._tasks.asMap().entries.map((entry) {
            final index = entry.key;
            final task = entry.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  RemixCheckbox(
                    selected: task['completed'],
                    onChanged: (value) {
                      setState(() => _tasks[index]['completed'] = value ?? false);
                    },
                    semanticLabel: task['title'],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      task['title'],
                      style: TextStyle(
                        decoration: task['completed'] ? TextDecoration.lineThrough : null,
                        color: task['completed'] ? MixColors.grey[500] : null,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// Helper functions
Widget _buildLabeledCheckbox(String label, bool selected, {bool enabled = true}) {
  return Column(
    children: [
      RemixCheckbox(
        selected: selected,
        enabled: enabled,
        onChanged: enabled ? (value) => debugPrint('$label: $value') : null,
        semanticLabel: label,
      ),
      const SizedBox(height: 4),
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

Widget _buildSimpleCheckbox(bool selected, {ValueChanged<bool?>? onChanged}) {
  return RemixCheckbox(
    selected: selected,
    onChanged: onChanged ?? (value) => debugPrint('Checkbox: $value'),
  );
}