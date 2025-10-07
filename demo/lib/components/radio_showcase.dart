import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Radio Showcase',
  type: RemixRadio,
)
Widget buildRadioShowcase(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Radio Button Groups',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Basic group layouts
            _buildSection(
              'Group Layouts',
              [
                _buildGroupLayoutsDemo(),
              ],
            ),

            // States section
            _buildSection(
              'States & Behavior',
              [
                _buildStatesDemo(),
              ],
            ),

            // Interactive demonstration
            _buildSection(
              'Interactive State Tracking',
              [
                _buildInteractiveDemo(),
              ],
            ),

            // Event handling
            _buildSection(
              'Event Handling & Callbacks',
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

Widget _buildGroupLayoutsDemo() {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Different layouts for radio button groups:',
        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
      ),
      SizedBox(height: 16),

      // Vertical layout
      _RadioGroupDemo(
        title: 'Vertical Layout',
        layout: _RadioLayout.vertical,
        options: ['Option A', 'Option B', 'Option C'],
        initialValue: 'Option A',
      ),

      SizedBox(height: 24),

      // Horizontal layout
      _RadioGroupDemo(
        title: 'Horizontal Layout',
        layout: _RadioLayout.horizontal,
        options: ['Small', 'Medium', 'Large'],
        initialValue: 'Medium',
      ),

      SizedBox(height: 24),

      // Grid layout
      _RadioGroupDemo(
        title: 'Grid Layout (2 columns)',
        layout: _RadioLayout.grid,
        options: ['Top Left', 'Top Right', 'Bottom Left', 'Bottom Right'],
        initialValue: 'Top Left',
      ),
    ],
  );
}

enum _RadioLayout { vertical, horizontal, grid }

class _RadioGroupDemo extends StatefulWidget {
  final String title;
  final _RadioLayout layout;
  final List<String> options;
  final String initialValue;

  const _RadioGroupDemo({
    required this.title,
    required this.layout,
    required this.options,
    required this.initialValue,
  });

  @override
  State<_RadioGroupDemo> createState() => _RadioGroupDemoState();
}

class _RadioGroupDemoState extends State<_RadioGroupDemo> {
  late String _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

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
          Text(
            widget.title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          RemixRadioGroup<String>(
            groupValue: _selectedValue,
            onChanged: (value) => setState(() => _selectedValue = value!),
            child: _buildLayoutWidget(),
          ),
          const SizedBox(height: 8),
          Text(
            'Selected: $_selectedValue',
            style: TextStyle(
              fontSize: 11,
              color: MixColors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLayoutWidget() {
    final radioWidgets = widget.options.map((option) => _buildRadioOption(option)).toList();

    switch (widget.layout) {
      case _RadioLayout.vertical:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: radioWidgets.map((radio) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: radio,
          )).toList(),
        );

      case _RadioLayout.horizontal:
        return Wrap(
          spacing: 16,
          children: radioWidgets,
        );

      case _RadioLayout.grid:
        return Wrap(
          spacing: 16,
          runSpacing: 8,
          children: radioWidgets.map((radio) => SizedBox(
            width: 120,
            child: radio,
          )).toList(),
        );
    }
  }

  Widget _buildRadioOption(String option) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        RemixRadio<String>(value: option),
        const SizedBox(width: 8),
        Text(option),
      ],
    );
  }
}

Widget _buildStatesDemo() {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Different states and behaviors:',
        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
      ),
      SizedBox(height: 16),

      // Normal group
      _StatesDemoGroup(
        title: 'Normal Group',
        enabled: true,
        toggleable: false,
      ),

      SizedBox(height: 20),

      // Disabled group
      _StatesDemoGroup(
        title: 'Disabled Group',
        enabled: false,
        toggleable: false,
      ),

      SizedBox(height: 20),

      // Toggleable group
      _StatesDemoGroup(
        title: 'Toggleable Group (can unselect)',
        enabled: true,
        toggleable: true,
      ),
    ],
  );
}

class _StatesDemoGroup extends StatefulWidget {
  final String title;
  final bool enabled;
  final bool toggleable;

  const _StatesDemoGroup({
    required this.title,
    required this.enabled,
    required this.toggleable,
  });

  @override
  State<_StatesDemoGroup> createState() => _StatesDemoGroupState();
}

class _StatesDemoGroupState extends State<_StatesDemoGroup> {
  String? _selectedValue = 'Option 1';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: MixColors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
        color: widget.enabled ? null : MixColors.grey[50],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: widget.enabled ? null : MixColors.grey[500],
            ),
          ),
          const SizedBox(height: 12),
          RemixRadioGroup<String>(
            groupValue: _selectedValue,
            onChanged: (String? value) {
              if (widget.enabled) {
                setState(() {
                  // If toggleable and clicking the same value, set to null
                  if (widget.toggleable && value == _selectedValue) {
                    _selectedValue = null;
                  } else {
                    _selectedValue = value;
                  }
                });
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: ['Option 1', 'Option 2', 'Option 3'].map((option) =>
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RemixRadio<String>(
                        value: option,
                        enabled: widget.enabled,
                        toggleable: widget.toggleable,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        option,
                        style: TextStyle(
                          color: widget.enabled ? null : MixColors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Selected: ${_selectedValue ?? 'None'}',
            style: TextStyle(
              fontSize: 11,
              color: MixColors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildInteractiveDemo() {
  return _InteractiveStateDemo();
}

class _InteractiveStateDemo extends StatefulWidget {
  @override
  State<_InteractiveStateDemo> createState() => _InteractiveStateDemoState();
}

class _InteractiveStateDemoState extends State<_InteractiveStateDemo> {
  String? _selectedTheme = 'light';
  final List<String> _stateLog = [];

  void _logStateChange(String newValue) {
    final timestamp = DateTime.now().toIso8601String().split('T')[1].split('.')[0];
    setState(() {
      _stateLog.insert(0, '$timestamp: Changed to $newValue');
      if (_stateLog.length > 4) {
        _stateLog.removeLast();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Interactive state tracking with visual feedback:',
          style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: MixColors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Theme Selector with State Tracking',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),

              RemixRadioGroup<String>(
                groupValue: _selectedTheme,
                onChanged: (value) {
                  setState(() => _selectedTheme = value);
                  if (value != null) {
                    _logStateChange(value);
                  }
                },
                child: const Column(
                  children: [
                    _InteractiveRadioOption(
                      value: 'light',
                      label: 'Light Theme',
                      description: 'Clean and bright interface',
                      icon: Icons.light_mode,
                    ),
                    SizedBox(height: 12),
                    _InteractiveRadioOption(
                      value: 'dark',
                      label: 'Dark Theme',
                      description: 'Easy on the eyes in low light',
                      icon: Icons.dark_mode,
                    ),
                    SizedBox(height: 12),
                    _InteractiveRadioOption(
                      value: 'system',
                      label: 'System Theme',
                      description: 'Follow system preference',
                      icon: Icons.settings_system_daydream,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // State display
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: MixColors.blue[50],
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: MixColors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, size: 16, color: MixColors.blue[700]),
                        const SizedBox(width: 8),
                        Text(
                          'Current Selection: ${_selectedTheme ?? 'None'}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: MixColors.blue[700],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    if (_stateLog.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Recent Changes:',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: MixColors.blue[700],
                        ),
                      ),
                      const SizedBox(height: 4),
                      ..._stateLog.map((log) => Text(
                        log,
                        style: TextStyle(
                          fontSize: 10,
                          color: MixColors.blue[600],
                          fontFamily: 'Courier',
                        ),
                      )),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InteractiveRadioOption extends StatelessWidget {
  final String value;
  final String label;
  final String description;
  final IconData icon;

  const _InteractiveRadioOption({
    required this.value,
    required this.label,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: MixColors.grey[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          RemixRadio<String>(value: value),
          const SizedBox(width: 12),
          Icon(icon, size: 20, color: MixColors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
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
        ],
      ),
    );
  }
}

Widget _buildEventHandlingDemo() {
  return _EventHandlingDemo();
}

class _EventHandlingDemo extends StatefulWidget {
  @override
  State<_EventHandlingDemo> createState() => _EventHandlingDemoState();
}

class _EventHandlingDemoState extends State<_EventHandlingDemo> {
  String? _selectedValue;
  final List<String> _eventLog = [];

  void _logEvent(String event) {
    setState(() {
      _eventLog.insert(0, event);
      if (_eventLog.length > 6) {
        _eventLog.removeLast();
      }
    });
    debugPrint(event);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Event callbacks and logging:',
          style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: MixColors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Priority Level Selection',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),

              RemixRadioGroup<String>(
                groupValue: _selectedValue,
                onChanged: (value) {
                  final oldValue = _selectedValue;
                  setState(() => _selectedValue = value);

                  final timestamp = DateTime.now().toIso8601String().split('T')[1].split('.')[0];
                  _logEvent('$timestamp: Changed from ${oldValue ?? 'None'} to ${value ?? 'None'}');
                },
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _EventRadioOption(
                      value: 'low',
                      label: 'Low Priority',
                      color: Colors.green,
                    ),
                    SizedBox(height: 8),
                    _EventRadioOption(
                      value: 'medium',
                      label: 'Medium Priority',
                      color: Colors.yellow,
                    ),
                    SizedBox(height: 8),
                    _EventRadioOption(
                      value: 'high',
                      label: 'High Priority',
                      color: Colors.orange,
                    ),
                    SizedBox(height: 8),
                    _EventRadioOption(
                      value: 'critical',
                      label: 'Critical Priority',
                      color: Colors.red,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Event console
              Container(
                width: double.infinity,
                height: 120,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: MixColors.grey[900],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Event Console:',
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
                                    'Select options to see events...',
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
          ),
        ),
      ],
    );
  }
}

class _EventRadioOption extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _EventRadioOption({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RemixRadio<String>(value: value),
        const SizedBox(width: 8),
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(width: 8),
        Text(label),
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

      // Theme selector
      _ThemeSelectionExample(),
      const SizedBox(height: 24),

      // Payment method
      _PaymentMethodExample(),
      const SizedBox(height: 24),

      // Survey/Poll
      _SurveyExample(),
    ],
  );
}

class _ThemeSelectionExample extends StatefulWidget {
  @override
  State<_ThemeSelectionExample> createState() => _ThemeSelectionExampleState();
}

class _ThemeSelectionExampleState extends State<_ThemeSelectionExample> {
  String _selectedTheme = 'system';

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
            'Theme Preferences',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose your preferred theme:',
            style: TextStyle(color: MixColors.grey[600]),
          ),
          const SizedBox(height: 16),

          RemixRadioGroup<String>(
            groupValue: _selectedTheme,
            onChanged: (value) => setState(() => _selectedTheme = value!),
            child: const Column(
              children: [
                _ThemeOption(
                  value: 'light',
                  title: 'Light',
                  description: 'Best for daylight use',
                  icon: Icons.wb_sunny,
                ),
                SizedBox(height: 12),
                _ThemeOption(
                  value: 'dark',
                  title: 'Dark',
                  description: 'Reduces eye strain in low light',
                  icon: Icons.nightlight_round,
                ),
                SizedBox(height: 12),
                _ThemeOption(
                  value: 'system',
                  title: 'System',
                  description: 'Automatically match your device',
                  icon: Icons.phone_android,
                ),
              ],
            ),
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
              'Your preference will be saved automatically. Current selection: ${_selectedTheme.toUpperCase()}',
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

class _ThemeOption extends StatelessWidget {
  final String value;
  final String title;
  final String description;
  final IconData icon;

  const _ThemeOption({
    required this.value,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RemixRadio<String>(value: value),
        const SizedBox(width: 12),
        Icon(icon, color: MixColors.grey[600]),
        const SizedBox(width: 12),
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
      ],
    );
  }
}

class _PaymentMethodExample extends StatefulWidget {
  @override
  State<_PaymentMethodExample> createState() => _PaymentMethodExampleState();
}

class _PaymentMethodExampleState extends State<_PaymentMethodExample> {
  String? _selectedMethod;

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
            'Payment Method',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Select your payment method:',
            style: TextStyle(color: MixColors.grey[600]),
          ),
          const SizedBox(height: 16),

          RemixRadioGroup<String>(
            groupValue: _selectedMethod,
            onChanged: (value) => setState(() => _selectedMethod = value),
            child: const Column(
              children: [
                _PaymentOption(
                  value: 'credit_card',
                  title: 'Credit Card',
                  subtitle: 'Visa, Mastercard, American Express',
                  icon: Icons.credit_card,
                ),
                SizedBox(height: 12),
                _PaymentOption(
                  value: 'paypal',
                  title: 'PayPal',
                  subtitle: 'Pay with your PayPal account',
                  icon: Icons.account_balance_wallet,
                ),
                SizedBox(height: 12),
                _PaymentOption(
                  value: 'apple_pay',
                  title: 'Apple Pay',
                  subtitle: 'Pay with Touch ID or Face ID',
                  icon: Icons.phone_iphone,
                ),
                SizedBox(height: 12),
                _PaymentOption(
                  value: 'bank_transfer',
                  title: 'Bank Transfer',
                  subtitle: 'Direct bank transfer',
                  icon: Icons.account_balance,
                ),
              ],
            ),
          ),

          if (_selectedMethod != null) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: MixColors.green[50],
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: MixColors.green[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: MixColors.green[600], size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Selected: ${_getPaymentMethodName(_selectedMethod!)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: MixColors.green[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getPaymentMethodName(String value) {
    switch (value) {
      case 'credit_card':
        return 'Credit Card';
      case 'paypal':
        return 'PayPal';
      case 'apple_pay':
        return 'Apple Pay';
      case 'bank_transfer':
        return 'Bank Transfer';
      default:
        return value;
    }
  }
}

class _PaymentOption extends StatelessWidget {
  final String value;
  final String title;
  final String subtitle;
  final IconData icon;

  const _PaymentOption({
    required this.value,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: MixColors.grey[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          RemixRadio<String>(value: value),
          const SizedBox(width: 12),
          Icon(icon, color: MixColors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  subtitle,
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
    );
  }
}

class _SurveyExample extends StatefulWidget {
  @override
  State<_SurveyExample> createState() => _SurveyExampleState();
}

class _SurveyExampleState extends State<_SurveyExample> {
  String? _satisfaction;

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
            'Customer Satisfaction Survey',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'How satisfied are you with our service?',
            style: TextStyle(color: MixColors.grey[600]),
          ),
          const SizedBox(height: 16),

          RemixRadioGroup<String>(
            groupValue: _satisfaction,
            onChanged: (value) => setState(() => _satisfaction = value),
            child: const Column(
              children: [
                _SatisfactionOption(
                  value: 'very_satisfied',
                  label: 'Very Satisfied',
                  emoji: '😄',
                  color: Colors.green,
                ),
                SizedBox(height: 8),
                _SatisfactionOption(
                  value: 'satisfied',
                  label: 'Satisfied',
                  emoji: '🙂',
                  color: Colors.blue,
                ),
                SizedBox(height: 8),
                _SatisfactionOption(
                  value: 'neutral',
                  label: 'Neutral',
                  emoji: '😐',
                  color: Colors.grey,
                ),
                SizedBox(height: 8),
                _SatisfactionOption(
                  value: 'dissatisfied',
                  label: 'Dissatisfied',
                  emoji: '🙁',
                  color: Colors.orange,
                ),
                SizedBox(height: 8),
                _SatisfactionOption(
                  value: 'very_dissatisfied',
                  label: 'Very Dissatisfied',
                  emoji: '😞',
                  color: Colors.red,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: RemixButton(
              label: 'Submit Survey',
              onPressed: _satisfaction != null
                  ? () => debugPrint('Survey submitted: $_satisfaction')
                  : null,
              style: FortalButtonStyle.solid(),
            ),
          ),

          if (_satisfaction == null) ...[
            const SizedBox(height: 8),
            Text(
              'Please select an option to submit',
              style: TextStyle(
                fontSize: 12,
                color: MixColors.red[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SatisfactionOption extends StatelessWidget {
  final String value;
  final String label;
  final String emoji;
  final Color color;

  const _SatisfactionOption({
    required this.value,
    required this.label,
    required this.emoji,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RemixRadio<String>(value: value),
        const SizedBox(width: 12),
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 12),
        Text(label),
        const Spacer(),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}