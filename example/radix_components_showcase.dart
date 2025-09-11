// ABOUTME: Comprehensive showcase of all Radix component variants and styles
// ABOUTME: Demonstrates the complete Radix design system implementation

import 'package:flutter/material.dart';

import '../lib/src/components/badge/badge.dart';
import '../lib/src/components/badge/radix_badge_styles.dart';
import '../lib/src/components/button/button.dart';
import '../lib/src/components/button/radix_button_styles.dart';
import '../lib/src/components/card/card.dart';
import '../lib/src/components/card/radix_card_styles.dart';
import '../lib/src/components/checkbox/checkbox.dart';
import '../lib/src/components/checkbox/radix_checkbox_styles.dart';
import '../lib/src/components/icon_button/icon_button.dart';
import '../lib/src/components/icon_button/radix_icon_button_styles.dart';
import '../lib/src/components/progress/progress.dart';
import '../lib/src/components/progress/radix_progress_styles.dart';
import '../lib/src/components/radio/radio.dart';
import '../lib/src/components/radio/radix_radio_styles.dart';
import '../lib/src/components/slider/radix_slider_styles.dart';
import '../lib/src/components/slider/slider.dart';
import '../lib/src/components/spinner/radix_spinner_styles.dart';
import '../lib/src/components/spinner/spinner.dart';
import '../lib/src/components/switch/radix_switch_styles.dart';
import '../lib/src/components/switch/switch.dart';
import '../lib/src/components/textfield/radix_textfield_styles.dart';
import '../lib/src/components/textfield/textfield.dart';
import '../lib/src/theme/radix_theme_data.dart';
import '../lib/src/utilities/radix_token_resolver.dart' as resolver;

void main() {
  runApp(const RadixComponentsShowcaseApp());
}

class RadixComponentsShowcaseApp extends StatefulWidget {
  const RadixComponentsShowcaseApp({super.key});

  @override
  State<RadixComponentsShowcaseApp> createState() =>
      _RadixComponentsShowcaseAppState();
}

class _RadixComponentsShowcaseAppState
    extends State<RadixComponentsShowcaseApp> {
  resolver.RadixAccentColor _accent = resolver.RadixAccentColor.indigo;
  resolver.RadixGrayColor _gray = resolver.RadixGrayColor.slate;
  Brightness _brightness = Brightness.light;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: createRadixScope(
        accent: _accent,
        gray: _gray,
        brightness: _brightness,
        trackVariant: resolver.TrackVariant.neutral,
        child: _ShowcaseScreen(
          onAccentChanged: (accent) => setState(() => _accent = accent),
          onGrayChanged: (gray) => setState(() => _gray = gray),
          onBrightnessChanged: (brightness) =>
              setState(() => _brightness = brightness),
          currentAccent: _accent,
          currentGray: _gray,
          currentBrightness: _brightness,
        ),
      ),
      title: 'Radix Components Showcase',
      theme: _brightness == Brightness.light
          ? ThemeData.light(useMaterial3: true)
          : ThemeData.dark(useMaterial3: true),
    );
  }
}

class _ShowcaseScreen extends StatefulWidget {
  const _ShowcaseScreen({
    required this.onAccentChanged,
    required this.onGrayChanged,
    required this.onBrightnessChanged,
    required this.currentAccent,
    required this.currentGray,
    required this.currentBrightness,
  });

  final ValueChanged<resolver.RadixAccentColor> onAccentChanged;
  final ValueChanged<resolver.RadixGrayColor> onGrayChanged;
  final ValueChanged<Brightness> onBrightnessChanged;
  final resolver.RadixAccentColor currentAccent;
  final resolver.RadixGrayColor currentGray;
  final Brightness currentBrightness;

  @override
  State<_ShowcaseScreen> createState() => _ShowcaseScreenState();
}

class _ShowcaseScreenState extends State<_ShowcaseScreen> {
  bool _checkboxValue = false;
  String _radioValue = 'option1';
  bool _switchValue = false;
  double _sliderValue = 0.5;
  double _progressValue = 0.7;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Radix Components Showcase'),
        actions: [
          // Theme controls
          PopupMenuButton<Brightness>(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: Brightness.light,
                child: Text('Light'),
              ),
              const PopupMenuItem(
                value: Brightness.dark,
                child: Text('Dark'),
              ),
            ],
            onSelected: widget.onBrightnessChanged,
            icon: Icon(widget.currentBrightness == Brightness.light
                ? Icons.light_mode
                : Icons.dark_mode),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theme Controls
            _ThemeControls(
              accent: widget.currentAccent,
              gray: widget.currentGray,
              onAccentChanged: widget.onAccentChanged,
              onGrayChanged: widget.onGrayChanged,
            ),
            const SizedBox(height: 32),

            // Buttons Section
            _buildSection(
              'Buttons',
              _ButtonsSection(),
            ),

            // Icon Buttons Section
            _buildSection(
              'Icon Buttons',
              _IconButtonsSection(),
            ),

            // Form Controls Section
            _buildSection(
              'Form Controls',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Checkboxes
                  const Text('Checkboxes',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  _CheckboxSection(
                    value: _checkboxValue,
                    onChanged: (value) => setState(() => _checkboxValue = value),
                  ),
                  const SizedBox(height: 16),

                  // Radio buttons
                  const Text('Radio Buttons',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  _RadioSection(
                    value: _radioValue,
                    onChanged: (value) => setState(() => _radioValue = value),
                  ),
                  const SizedBox(height: 16),

                  // Switches
                  const Text('Switches',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  _SwitchSection(
                    value: _switchValue,
                    onChanged: (value) => setState(() => _switchValue = value),
                  ),
                  const SizedBox(height: 16),

                  // Text Fields
                  const Text('Text Fields',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  _TextFieldSection(),
                ],
              ),
            ),

            // Indicators Section
            _buildSection(
              'Indicators',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badges
                  const Text('Badges',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  _BadgeSection(),
                  const SizedBox(height: 16),

                  // Progress
                  const Text('Progress',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  _ProgressSection(value: _progressValue),
                  const SizedBox(height: 16),

                  // Spinners
                  const Text('Spinners',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  _SpinnerSection(),
                ],
              ),
            ),

            // Controls Section
            _buildSection(
              'Controls',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sliders
                  const Text('Sliders',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  _SliderSection(
                    value: _sliderValue,
                    onChanged: (value) => setState(() => _sliderValue = value),
                  ),
                ],
              ),
            ),

            // Layout Section
            _buildSection(
              'Layout',
              _CardSection(),
            ),
          ],
        ),
      ),
      backgroundColor: widget.currentBrightness == Brightness.dark
          ? Colors.grey.shade900
          : Colors.white,
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        content,
        const SizedBox(height: 32),
      ],
    );
  }
}

class _ThemeControls extends StatelessWidget {
  const _ThemeControls({
    required this.accent,
    required this.gray,
    required this.onAccentChanged,
    required this.onGrayChanged,
  });

  final resolver.RadixAccentColor accent;
  final resolver.RadixGrayColor gray;
  final ValueChanged<resolver.RadixAccentColor> onAccentChanged;
  final ValueChanged<resolver.RadixGrayColor> onGrayChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Theme Configuration',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButton<resolver.RadixAccentColor>(
                    items: resolver.RadixAccentColor.values
                        .map(
                          (color) => DropdownMenuItem(
                            value: color,
                            child: Text('Accent: ${color.name}'),
                          ),
                        )
                        .toList(),
                    value: accent,
                    onChanged: (value) =>
                        value != null ? onAccentChanged(value) : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButton<resolver.RadixGrayColor>(
                    items: resolver.RadixGrayColor.values
                        .map(
                          (color) => DropdownMenuItem(
                            value: color,
                            child: Text('Gray: ${color.name}'),
                          ),
                        )
                        .toList(),
                    value: gray,
                    onChanged: (value) =>
                        value != null ? onGrayChanged(value) : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ButtonsSection extends StatelessWidget {
  const _ButtonsSection();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        RemixButton(
          style: RadixButtonStyles.solid(),
          label: 'Solid',
          icon: Icons.check_circle,
          onPressed: () {},
        ),
        RemixButton(
          style: RadixButtonStyles.soft(),
          label: 'Soft',
          icon: Icons.favorite,
          onPressed: () {},
        ),
        RemixButton(
          style: RadixButtonStyles.surface(),
          label: 'Surface',
          icon: Icons.layers,
          onPressed: () {},
        ),
        RemixButton(
          style: RadixButtonStyles.outline(),
          label: 'Outline',
          icon: Icons.crop_free,
          onPressed: () {},
        ),
        RemixButton(
          style: RadixButtonStyles.ghost(),
          label: 'Ghost',
          icon: Icons.visibility_off,
          onPressed: () {},
        ),
        RemixButton(
          style: RadixButtonStyles.classic(),
          label: 'Classic',
          icon: Icons.style,
          onPressed: () {},
        ),
      ],
    );
  }
}

class _IconButtonsSection extends StatelessWidget {
  const _IconButtonsSection();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        RemixIconButton(
          style: RadixIconButtonStyles.solid(),
          icon: Icons.check_circle,
          onPressed: () {},
        ),
        RemixIconButton(
          style: RadixIconButtonStyles.soft(),
          icon: Icons.favorite,
          onPressed: () {},
        ),
        RemixIconButton(
          style: RadixIconButtonStyles.surface(),
          icon: Icons.layers,
          onPressed: () {},
        ),
        RemixIconButton(
          style: RadixIconButtonStyles.outline(),
          icon: Icons.crop_free,
          onPressed: () {},
        ),
        RemixIconButton(
          style: RadixIconButtonStyles.ghost(),
          icon: Icons.visibility_off,
          onPressed: () {},
        ),
        RemixIconButton(
          style: RadixIconButtonStyles.classic(),
          icon: Icons.style,
          onPressed: () {},
        ),
      ],
    );
  }
}

class _CheckboxSection extends StatelessWidget {
  const _CheckboxSection({
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RemixCheckbox(
          style: RadixCheckboxStyles.classic(),
          checked: value,
          onChanged: onChanged,
          label: 'Classic Checkbox',
        ),
        const SizedBox(height: 8),
        RemixCheckbox(
          style: RadixCheckboxStyles.surface(),
          checked: value,
          onChanged: onChanged,
          label: 'Surface Checkbox',
        ),
        const SizedBox(height: 8),
        RemixCheckbox(
          style: RadixCheckboxStyles.soft(),
          checked: value,
          onChanged: onChanged,
          label: 'Soft Checkbox',
        ),
      ],
    );
  }
}

class _RadioSection extends StatelessWidget {
  const _RadioSection({
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RemixRadio(
          style: RadixRadioStyles.classic(),
          value: 'option1',
          groupValue: value,
          onChanged: onChanged,
          label: 'Classic Option 1',
        ),
        const SizedBox(height: 8),
        RemixRadio(
          style: RadixRadioStyles.surface(),
          value: 'option2',
          groupValue: value,
          onChanged: onChanged,
          label: 'Surface Option 2',
        ),
        const SizedBox(height: 8),
        RemixRadio(
          style: RadixRadioStyles.soft(),
          value: 'option3',
          groupValue: value,
          onChanged: onChanged,
          label: 'Soft Option 3',
        ),
      ],
    );
  }
}

class _SwitchSection extends StatelessWidget {
  const _SwitchSection({
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            RemixSwitch(
              style: RadixSwitchStyles.classic(),
              value: value,
              onChanged: onChanged,
            ),
            const SizedBox(width: 8),
            const Text('Classic Switch'),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            RemixSwitch(
              style: RadixSwitchStyles.surface(),
              value: value,
              onChanged: onChanged,
            ),
            const SizedBox(width: 8),
            const Text('Surface Switch'),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            RemixSwitch(
              style: RadixSwitchStyles.soft(),
              value: value,
              onChanged: onChanged,
            ),
            const SizedBox(width: 8),
            const Text('Soft Switch'),
          ],
        ),
      ],
    );
  }
}

class _TextFieldSection extends StatelessWidget {
  const _TextFieldSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RemixTextField(
          style: RadixTextFieldStyles.classic(),
          placeholder: 'Classic TextField',
        ),
        const SizedBox(height: 12),
        RemixTextField(
          style: RadixTextFieldStyles.surface(),
          placeholder: 'Surface TextField',
        ),
        const SizedBox(height: 12),
        RemixTextField(
          style: RadixTextFieldStyles.soft(),
          placeholder: 'Soft TextField',
        ),
      ],
    );
  }
}

class _BadgeSection extends StatelessWidget {
  const _BadgeSection();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        RemixBadge(style: RadixBadgeStyles.solid(), text: 'Solid'),
        RemixBadge(style: RadixBadgeStyles.soft(), text: 'Soft'),
        RemixBadge(style: RadixBadgeStyles.surface(), text: 'Surface'),
        RemixBadge(style: RadixBadgeStyles.outline(), text: 'Outline'),
      ],
    );
  }
}

class _ProgressSection extends StatelessWidget {
  const _ProgressSection({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RemixProgress(style: RadixProgressStyles.classic(), value: value),
        const SizedBox(height: 12),
        RemixProgress(style: RadixProgressStyles.surface(), value: value),
        const SizedBox(height: 12),
        RemixProgress(style: RadixProgressStyles.soft(), value: value),
      ],
    );
  }
}

class _SpinnerSection extends StatelessWidget {
  const _SpinnerSection();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        RemixSpinner(style: RadixSpinnerStyles.defaultStyle(size: 1)),
        RemixSpinner(style: RadixSpinnerStyles.defaultStyle(size: 2)),
        RemixSpinner(style: RadixSpinnerStyles.defaultStyle(size: 3)),
      ],
    );
  }
}

class _SliderSection extends StatelessWidget {
  const _SliderSection({
    required this.value,
    required this.onChanged,
  });

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RemixSlider(
          style: RadixSliderStyles.classic(),
          value: value,
          onChanged: onChanged,
        ),
        const SizedBox(height: 16),
        RemixSlider(
          style: RadixSliderStyles.surface(),
          value: value,
          onChanged: onChanged,
        ),
        const SizedBox(height: 16),
        RemixSlider(
          style: RadixSliderStyles.soft(),
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _CardSection extends StatelessWidget {
  const _CardSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RemixCard(
          style: RadixCardStyles.surface(),
          child: const Text('Surface Card\n\nThis is a surface card variant.'),
        ),
        const SizedBox(height: 16),
        RemixCard(
          style: RadixCardStyles.classic(),
          child: const Text('Classic Card\n\nThis is a classic card variant.'),
        ),
        const SizedBox(height: 16),
        RemixCard(
          style: RadixCardStyles.ghost(),
          child: const Text('Ghost Card\n\nThis is a ghost card variant.'),
        ),
      ],
    );
  }
}