import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Button Showcase',
  type: RemixButton,
)
Widget buildButtonShowcase(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Button Variants',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Base style demonstration
            _buildSection(
              'Base Style',
              [
                _buildButtonRow('Default Button', RemixButtonStyles.baseStyle),
              ],
            ),

            // Sizes section
            _buildSection(
              'Sizes',
              [
                _buildSizeRow(),
              ],
            ),

            // States section
            _buildSection(
              'States',
              [
                _buildStatesRow(),
              ],
            ),

            // Interactive State Demo
            _buildSection(
              'Interactive State Demonstration',
              [
                _buildInteractiveStateDemo(),
              ],
            ),

            // State Callbacks Demo
            _buildSection(
              'State Callbacks & Events',
              [
                _buildStateCallbacksDemo(),
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

Widget _buildButtonRow(String variantName, RemixButtonStyle style) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          variantName,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            RemixButton(
              label: 'Default',
              icon: Icons.star,
              onPressed: () => debugPrint('$variantName default pressed'),
              style: style,
            ),
            RemixButton(
              label: 'Icon Only',
              icon: Icons.star,
              onPressed: () => debugPrint('$variantName icon pressed'),
              style: style,
            ),
            RemixButton(
              label: 'Text Only',
              onPressed: () => debugPrint('$variantName text pressed'),
              style: style,
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildSizeRow() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Using custom sizes with padding and fontSize',
        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
      ),
      const SizedBox(height: 8),
      Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          RemixButton(
            label: 'Small',
            icon: Icons.circle,
            onPressed: () => debugPrint('Small button pressed'),
            style: RemixButtonStyles.baseStyle.padding(EdgeInsetsGeometryMix.all(8.0)),
          ),
          RemixButton(
            label: 'Medium',
            icon: Icons.circle,
            onPressed: () => debugPrint('Medium button pressed'),
            style: RemixButtonStyles.baseStyle.padding(EdgeInsetsGeometryMix.all(12.0)),
          ),
          RemixButton(
            label: 'Large',
            icon: Icons.circle,
            onPressed: () => debugPrint('Large button pressed'),
            style: RemixButtonStyles.baseStyle.padding(EdgeInsetsGeometryMix.all(16.0)),
          ),
        ],
      ),
    ],
  );
}

Widget _buildStatesRow() {
  return Wrap(
    spacing: 12,
    runSpacing: 12,
    children: [
      RemixButton(
        label: 'Enabled',
        icon: Icons.check,
        onPressed: () => debugPrint('Enabled button pressed'),
        style: RemixButtonStyles.baseStyle,
      ),
      RemixButton(
        label: 'Disabled',
        icon: Icons.block,
        enabled: false,
        onPressed: () => debugPrint('This should not print'),
        style: RemixButtonStyles.baseStyle,
      ),
      RemixButton(
        label: 'Loading',
        icon: Icons.refresh,
        loading: true,
        onPressed: () => debugPrint('Loading button pressed'),
        style: RemixButtonStyles.baseStyle,
      ),
    ],
  );
}

class _StateTracker extends StatefulWidget {
  final Widget child;
  final String label;

  const _StateTracker({required this.child, required this.label});

  @override
  State<_StateTracker> createState() => _StateTrackerState();
}

class _StateTrackerState extends State<_StateTracker> {
  final bool _isHovered = false;
  final bool _isPressed = false;
  final bool _isFocused = false;
  final int _pressCount = 0;
  final int _longPressCount = 0;
  final int _doubleTapCount = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.child,
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: MixColors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: MixColors.grey[300]),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current States:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: MixColors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: [
                        _buildStateChip('Hovered', _isHovered, MixColors.blue),
                        _buildStateChip('Pressed', _isPressed, MixColors.red),
                        _buildStateChip('Focused', _isFocused, MixColors.green),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Event Counters:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: MixColors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Press: $_pressCount | Long Press: $_longPressCount | Double Tap: $_doubleTapCount',
                      style:
                          TextStyle(fontSize: 10, color: MixColors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStateChip(String label, bool isActive, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? color.withValues(alpha: 0.2) : MixColors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? color : MixColors.grey[400],
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          color: isActive ? color : MixColors.grey[600],
        ),
      ),
    );
  }
}

Widget _buildInteractiveStateDemo() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Hover, click, and use keyboard navigation to see state changes in real-time:',
        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
      ),
      const SizedBox(height: 16),
      _StateTracker(
        label: 'Primary Button with State Tracking',
        child: RemixButton(
          label: 'Interactive Demo',
          icon: Icons.touch_app,
          style: RemixButtonStyles.baseStyle,
          onPressed: () => debugPrint('Primary button pressed'),
          onLongPress: () => debugPrint('Primary button long pressed'),
          onDoubleTap: () => debugPrint('Primary button double tapped'),
        ),
      ),
      const SizedBox(height: 16),
      _StateTracker(
        label: 'Outline Button with State Tracking',
        child: RemixButton(
          label: 'Hover & Click Me',
          icon: Icons.mouse,
          style: RemixButtonStyles.baseStyle,
          onPressed: () => debugPrint('Outline button pressed'),
          onLongPress: () => debugPrint('Outline button long pressed'),
          onDoubleTap: () => debugPrint('Outline button double tapped'),
        ),
      ),
      const SizedBox(height: 16),
      _StateTracker(
        label: 'Ghost Button with State Tracking',
        child: RemixButton(
          label: 'Focus & Press Me',
          icon: Icons.keyboard,
          style: RemixButtonStyles.baseStyle,
          onPressed: () => debugPrint('Ghost button pressed'),
          onLongPress: () => debugPrint('Ghost button long pressed'),
          onDoubleTap: () => debugPrint('Ghost button double tapped'),
        ),
      ),
    ],
  );
}

Widget _buildStateCallbacksDemo() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Comprehensive event handling demonstration:',
        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
      ),
      const SizedBox(height: 16),
      Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          RemixButton(
            label: 'Press Events',
            icon: Icons.tap_and_play,
            style: RemixButtonStyles.baseStyle,
            onPressed: () => debugPrint('✅ Single Press'),
            onLongPress: () => debugPrint('⏳ Long Press (Hold for 500ms)'),
            onDoubleTap: () => debugPrint('⚡ Double Tap'),
          ),
          RemixButton(
            label: 'Hover Events',
            icon: Icons.mouse,
            style: RemixButtonStyles.baseStyle,
            onPressed: () => debugPrint('Button clicked'),
          ),
          RemixButton(
            label: 'Focus Events',
            icon: Icons.keyboard,
            style: RemixButtonStyles.baseStyle,
            onPressed: () => debugPrint('Focused button clicked'),
          ),
          RemixButton(
            label: 'All State Changes',
            icon: Icons.analytics,
            style: RemixButtonStyles.baseStyle,
            onPressed: () => debugPrint('State tracking button clicked'),
          ),
        ],
      ),
      const SizedBox(height: 16),
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: MixColors.amber[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: MixColors.amber[200]),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info, size: 16, color: MixColors.amber[700]),
                const SizedBox(width: 8),
                Text(
                  'Event Testing Tips:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: MixColors.amber[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '• Use Tab key for keyboard navigation and focus events\n'
              '• Hold buttons for 500ms+ to trigger long press\n'
              '• Double-tap quickly for double-tap events\n'
              '• Hover with mouse to see hover state changes\n'
              '• Check debug console for detailed event logs',
              style: TextStyle(
                fontSize: 12,
                color: MixColors.amber[800],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
