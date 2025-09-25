import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

void main() {
  runApp(const FortalComponentsShowcaseApp());
}

class FortalComponentsShowcaseApp extends StatefulWidget {
  const FortalComponentsShowcaseApp({super.key});

  @override
  State<FortalComponentsShowcaseApp> createState() =>
      _FortalComponentsShowcaseAppState();
}

class _FortalComponentsShowcaseAppState
    extends State<FortalComponentsShowcaseApp> {
  FortalAccentColor _accent = FortalAccentColor.indigo;
  FortalGrayColor _gray = FortalGrayColor.slate;
  Brightness _brightness = Brightness.light;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: createFortalScope(
        accent: _accent,
        gray: _gray,
        brightness: _brightness,
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
      title: 'Fortal Components Showcase',
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

  final ValueChanged<FortalAccentColor> onAccentChanged;
  final ValueChanged<FortalGrayColor> onGrayChanged;
  final ValueChanged<Brightness> onBrightnessChanged;
  final FortalAccentColor currentAccent;
  final FortalGrayColor currentGray;
  final Brightness currentBrightness;

  @override
  State<_ShowcaseScreen> createState() => _ShowcaseScreenState();
}

class _ShowcaseScreenState extends State<_ShowcaseScreen> {
  bool _checkboxValue = false;
  String? _radioValue = 'option1';
  bool _switchValue = false;
  double _sliderValue = 0.5;
  double _progressValue = 0.7;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fortal Components Showcase'),
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
            _buildSection('Buttons', _ButtonsSection()),

            // Icon Buttons Section
            _buildSection('Icon Buttons', _IconButtonsSection()),

            // Form Controls Section
            _buildSection(
              'Form Controls',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Checkboxes
                  const Text(
                    'Checkboxes',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  _CheckboxSection(
                    value: _checkboxValue,
                    onChanged: (value) =>
                        setState(() => _checkboxValue = value ?? false),
                  ),
                  const SizedBox(height: 16),

                  // Radio buttons
                  const Text(
                    'Radio Buttons',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  _RadioSection(
                    value: _radioValue,
                    onChanged: (value) => setState(() => _radioValue = value),
                  ),
                  const SizedBox(height: 16),

                  // Switches
                  const Text(
                    'Switches',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  _SwitchSection(
                    value: _switchValue,
                    onChanged: (value) =>
                        setState(() => _switchValue = value ?? false),
                  ),
                  const SizedBox(height: 16),

                  // Text Fields
                  const Text(
                    'Text Fields',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
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
                  const Text(
                    'Badges',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  _BadgeSection(),
                  const SizedBox(height: 16),

                  // Progress
                  const Text(
                    'Progress',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  _ProgressSection(value: _progressValue),
                  const SizedBox(height: 16),

                  // Spinners
                  const Text(
                    'Spinners',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
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
                  const Text(
                    'Sliders',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  _SliderSection(
                    value: _sliderValue,
                    onChanged: (value) => setState(() => _sliderValue = value),
                  ),
                ],
              ),
            ),

            // Layout Section
            _buildSection('Layout', _CardSection()),
          ],
        ),
      ),
      backgroundColor: widget.currentBrightness == Brightness.dark
          ? Colors.grey.shade900
          : Colors.white,
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

  final FortalAccentColor accent;
  final FortalGrayColor gray;
  final ValueChanged<FortalAccentColor> onAccentChanged;
  final ValueChanged<FortalGrayColor> onGrayChanged;

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
                  child: DropdownButton<FortalAccentColor>(
                    items: FortalAccentColor.values
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
                  child: DropdownButton<FortalGrayColor>(
                    items: FortalGrayColor.values
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
          style: FortalButtonStyle.solid(),
          label: 'Solid',
          icon: Icons.check_circle,
          onPressed: () => print('Button pressed'),
        ),
        RemixButton(
          style: FortalButtonStyle.soft(),
          label: 'Soft',
          icon: Icons.favorite,
          onPressed: () => print('Button pressed'),
        ),
        RemixButton(
          style: FortalButtonStyle.surface(),
          label: 'Surface',
          icon: Icons.layers,
          onPressed: () => print('Button pressed'),
        ),
        RemixButton(
          style: FortalButtonStyle.outline(),
          label: 'Outline',
          icon: Icons.crop_free,
          onPressed: () => print('Button pressed'),
        ),
        RemixButton(
          style: FortalButtonStyle.ghost(),
          label: 'Ghost',
          icon: Icons.visibility_off,
          onPressed: () => print('Button pressed'),
        ),
        RemixButton(
          style: FortalButtonStyle.surface(),
          label: 'Surface',
          icon: Icons.style,
          onPressed: () => print('Button pressed'),
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
          style: FortalIconButtonStyles.solid(),
          icon: Icons.check_circle,
          onPressed: () => print('Button pressed'),
        ),
        RemixIconButton(
          style: FortalIconButtonStyles.soft(),
          icon: Icons.favorite,
          onPressed: () => print('Button pressed'),
        ),
        RemixIconButton(
          style: FortalIconButtonStyles.surface(),
          icon: Icons.layers,
          onPressed: () => print('Button pressed'),
        ),
        RemixIconButton(
          style: FortalIconButtonStyles.outline(),
          icon: Icons.crop_free,
          onPressed: () => print('Button pressed'),
        ),
        RemixIconButton(
          style: FortalIconButtonStyles.ghost(),
          icon: Icons.visibility_off,
          onPressed: () => print('Button pressed'),
        ),
        RemixIconButton(
          style: FortalIconButtonStyles.classic(),
          icon: Icons.style,
          onPressed: () => print('Button pressed'),
        ),
      ],
    );
  }
}

class _CheckboxSection extends StatelessWidget {
  const _CheckboxSection({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            RemixCheckbox(
              selected: value,
              onChanged: onChanged,
              style: FortalCheckboxStyles.classic(),
              semanticLabel: 'Classic Checkbox',
            ),
            const SizedBox(width: 8),
            const Text('Classic Checkbox'),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            RemixCheckbox(
              selected: value,
              onChanged: onChanged,
              style: FortalCheckboxStyles.surface(),
              semanticLabel: 'Surface Checkbox',
            ),
            const SizedBox(width: 8),
            const Text('Surface Checkbox'),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            RemixCheckbox(
              selected: value,
              onChanged: onChanged,
              style: FortalCheckboxStyles.soft(),
              semanticLabel: 'Soft Checkbox',
            ),
            const SizedBox(width: 8),
            const Text('Soft Checkbox'),
          ],
        ),
      ],
    );
  }
}

class _RadioSection extends StatelessWidget {
  const _RadioSection({required this.value, required this.onChanged});

  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return RemixRadioGroup<String>(
      groupValue: value,
      onChanged: onChanged,
      child: Column(
        children: [
          Row(
            children: [
              RemixRadio(
                semanticLabel: 'Classic Option 1',
                style: FortalRadioStyles.classic(),
                value: 'option1',
              ),
              const SizedBox(width: 8),
              const Text('Classic Option 1'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              RemixRadio(
                semanticLabel: 'Surface Option 2',
                style: FortalRadioStyles.surface(),
                value: 'option2',
              ),
              const SizedBox(width: 8),
              const Text('Surface Option 2'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              RemixRadio(
                semanticLabel: 'Soft Option 3',
                style: FortalRadioStyles.soft(),
                value: 'option3',
              ),
              const SizedBox(width: 8),
              const Text('Soft Option 3'),
            ],
          ),
        ],
      ),
    );
  }
}

class _SwitchSection extends StatelessWidget {
  const _SwitchSection({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            RemixSwitch(
              selected: value,
              onChanged: onChanged,
              style: FortalSwitchStyles.classic(),
            ),
            const SizedBox(width: 8),
            const Text('Classic Switch'),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            RemixSwitch(
              selected: value,
              onChanged: onChanged,
              style: FortalSwitchStyles.surface(),
            ),
            const SizedBox(width: 8),
            const Text('Surface Switch'),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            RemixSwitch(
              selected: value,
              onChanged: onChanged,
              style: FortalSwitchStyles.soft(),
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
          hintText: 'Classic TextField',
          style: FortalTextFieldStyles.classic(),
        ),
        const SizedBox(height: 12),
        RemixTextField(
          hintText: 'Surface TextField',
          style: FortalTextFieldStyles.surface(),
        ),
        const SizedBox(height: 12),
        RemixTextField(
          hintText: 'Soft TextField',
          style: FortalTextFieldStyles.soft(),
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
        RemixBadge(style: FortalBadgeStyles.solid(), label: 'Solid'),
        RemixBadge(style: FortalBadgeStyles.soft(), label: 'Soft'),
        RemixBadge(style: FortalBadgeStyles.surface(), label: 'Surface'),
        RemixBadge(style: FortalBadgeStyles.outline(), label: 'Outline'),
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
        RemixProgress(style: FortalProgressStyles.classic(), value: value),
        const SizedBox(height: 12),
        RemixProgress(style: FortalProgressStyles.surface(), value: value),
        const SizedBox(height: 12),
        RemixProgress(style: FortalProgressStyles.soft(), value: value),
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
        RemixSpinner(
          style:
              FortalSpinnerStyles.defaultStyle(size: FortalSpinnerSize.size1),
        ),
        RemixSpinner(
          style:
              FortalSpinnerStyles.defaultStyle(size: FortalSpinnerSize.size2),
        ),
        RemixSpinner(
          style:
              FortalSpinnerStyles.defaultStyle(size: FortalSpinnerSize.size3),
        ),
      ],
    );
  }
}

class _SliderSection extends StatelessWidget {
  const _SliderSection({required this.value, required this.onChanged});

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RemixSlider(
          onChanged: onChanged,
          value: value,
          style: FortalSliderStyles.classic(),
        ),
        const SizedBox(height: 16),
        RemixSlider(
          onChanged: onChanged,
          value: value,
          style: FortalSliderStyles.surface(),
        ),
        const SizedBox(height: 16),
        RemixSlider(
          onChanged: onChanged,
          value: value,
          style: FortalSliderStyles.soft(),
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
          style: FortalCardStyles.surface(),
          child: const Text('Surface Card\n\nThis is a surface card variant.'),
        ),
        const SizedBox(height: 16),
        RemixCard(
          style: FortalCardStyles.classic(),
          child: const Text('Classic Card\n\nThis is a classic card variant.'),
        ),
        const SizedBox(height: 16),
        RemixCard(
          style: FortalCardStyles.ghost(),
          child: const Text('Ghost Card\n\nThis is a ghost card variant.'),
        ),
      ],
    );
  }
}
