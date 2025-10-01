import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

void main() {
  runApp(const FortalButtonComprehensiveTest());
}

class FortalButtonComprehensiveTest extends StatefulWidget {
  const FortalButtonComprehensiveTest({super.key});

  @override
  State<FortalButtonComprehensiveTest> createState() =>
      _FortalButtonComprehensiveTestState();
}

class _FortalButtonComprehensiveTestState
    extends State<FortalButtonComprehensiveTest> {
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
        child: _ComprehensiveTestScreen(
          onAccentChanged: (accent) => setState(() => _accent = accent),
          onGrayChanged: (gray) => setState(() => _gray = gray),
          onBrightnessChanged: (brightness) =>
              setState(() => _brightness = brightness),
          currentAccent: _accent,
          currentGray: _gray,
          currentBrightness: _brightness,
        ),
      ),
      title: 'Fortal Button Comprehensive Test',
      theme: _brightness == Brightness.light
          ? ThemeData.light(useMaterial3: true)
          : ThemeData.dark(useMaterial3: true),
    );
  }
}

class _ComprehensiveTestScreen extends StatelessWidget {
  const _ComprehensiveTestScreen({
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fortal Button - Complete Spec Test'),
        actions: [
          // Theme controls
          PopupMenuButton<Brightness>(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: Brightness.light,
                child: Text('Light'),
              ),
              const PopupMenuItem(value: Brightness.dark, child: Text('Dark')),
            ],
            onSelected: onBrightnessChanged,
            icon: Icon(currentBrightness == Brightness.light
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
              accent: currentAccent,
              gray: currentGray,
              onAccentChanged: onAccentChanged,
              onGrayChanged: onGrayChanged,
            ),
            const SizedBox(height: 24),

            // All Variants - Default Size (2)
            const Text(
              'All Variants - Size 2 (Default)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const _AllVariantsSection(size: 2),
            const SizedBox(height: 32),

            // Size Comparison - Solid Variant
            const Text(
              'Size Comparison - Solid Variant',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const _SizeComparisonSection(),
            const SizedBox(height: 32),

            // State Testing - Each Variant
            const Text(
              'State Testing - All Variants',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const _StateTestingSection(),
            const SizedBox(height: 32),

            // Accent Color Showcase
            const Text(
              'Accent Color Showcase - Solid Variant',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const _AccentShowcaseSection(),
          ],
        ),
      ),
      backgroundColor: currentBrightness == Brightness.dark
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

class _AllVariantsSection extends StatelessWidget {
  const _AllVariantsSection({required this.size});

  final int size;

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  RemixButtonStyle _getSizedStyle(RemixButtonStyle Function() _) {
    return switch (size) {
      1 => FortalButtonStyle.base(size: FortalButtonSize.size1),
      2 => FortalButtonStyle.base(size: FortalButtonSize.size2),
      3 => FortalButtonStyle.base(size: FortalButtonSize.size3),
      4 => FortalButtonStyle.base(size: FortalButtonSize.size4),
      _ => FortalButtonStyle.base(
          size: FortalButtonSize.size2), // Default to size 2
    };
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        // Solid
        _getSizedStyle(() => FortalButtonStyle.solid()).call(
          label: 'Solid',
          icon: Icons.check_circle,
          onPressed: () => _showSnackBar(context, 'Solid pressed'),
        ),

        // Soft
        _getSizedStyle(() => FortalButtonStyle.soft()).call(
          label: 'Soft',
          icon: Icons.favorite,
          onPressed: () => _showSnackBar(context, 'Soft pressed'),
        ),

        // Surface
        _getSizedStyle(() => FortalButtonStyle.surface()).call(
          label: 'Surface',
          icon: Icons.layers,
          onPressed: () => _showSnackBar(context, 'Surface pressed'),
        ),

        // Outline
        _getSizedStyle(() => FortalButtonStyle.outline()).call(
          label: 'Outline',
          icon: Icons.crop_free,
          onPressed: () => _showSnackBar(context, 'Outline pressed'),
        ),

        // Ghost
        _getSizedStyle(() => FortalButtonStyle.ghost()).call(
          label: 'Ghost',
          icon: Icons.visibility_off,
          onPressed: () => _showSnackBar(context, 'Ghost pressed'),
        ),

        // Surface (was Classic)
        _getSizedStyle(() => FortalButtonStyle.surface()).call(
          label: 'Surface',
          icon: Icons.style,
          onPressed: () => _showSnackBar(context, 'Surface pressed'),
        ),
      ],
    );
  }
}

class _SizeComparisonSection extends StatelessWidget {
  const _SizeComparisonSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Size 1 (Small)'),
        const SizedBox(height: 8),
        FortalButtonStyle.solid().call(label: 'Size 1', onPressed: () {}),
        const SizedBox(height: 16),
        const Text('Size 2 (Medium - Default)'),
        const SizedBox(height: 8),
        FortalButtonStyle.solid().call(label: 'Size 2', onPressed: () {}),
        const SizedBox(height: 16),
        const Text('Size 3 (Large)'),
        const SizedBox(height: 8),
        FortalButtonStyle.solid().call(label: 'Size 3', onPressed: () {}),
        const SizedBox(height: 16),
        const Text('Size 4 (Extra Large)'),
        const SizedBox(height: 8),
        FortalButtonStyle.solid().call(label: 'Size 4', onPressed: () {}),
      ],
    );
  }
}

class _StateTestingSection extends StatelessWidget {
  const _StateTestingSection();

  RemixButtonStyle _getVariantButton(String variantName) {
    switch (variantName) {
      case 'Solid':
        return FortalButtonStyle.solid();
      case 'Soft':
        return FortalButtonStyle.soft();
      case 'Surface':
        return FortalButtonStyle.surface();
      case 'Outline':
        return FortalButtonStyle.outline();
      case 'Ghost':
        return FortalButtonStyle.ghost();
      default:
        return FortalButtonStyle.solid();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Normal, Loading, Disabled states for each variant
        for (final variantName in [
          'Solid',
          'Soft',
          'Surface',
          'Outline',
          'Ghost',
        ]) ...[
          Text(
            '$variantName States',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              // Normal
              _getVariantButton(variantName).call(
                label: 'Normal',
                onPressed: () => print('Button pressed'),
              ),

              // Loading
              _getVariantButton(variantName).call(
                label: 'Loading',
                loading: true,
                onPressed: () => print('Button pressed'),
              ),

              // Disabled
              _getVariantButton(variantName).call(
                label: 'Disabled',
                enabled: false,
                onPressed: null,
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}

class _AccentShowcaseSection extends StatelessWidget {
  const _AccentShowcaseSection();

  @override
  Widget build(BuildContext context) {
    final popularAccents = [
      FortalAccentColor.indigo,
      FortalAccentColor.blue,
      FortalAccentColor.green,
      FortalAccentColor.red,
      FortalAccentColor.purple,
      FortalAccentColor.orange,
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: popularAccents.map((accentColor) {
        // Create temporary scope to show the accent
        return createFortalScope(
          accent: accentColor,
          gray: FortalGrayColor.slate,
          brightness: Theme.of(context).brightness,
          child: FortalButtonStyle.solid().call(
            label: accentColor.name,
            onPressed: () => print('Button pressed'),
          ),
        );
      }).toList(),
    );
  }
}
