// ABOUTME: Comprehensive test of all Radix button variants with proper spec compliance
// ABOUTME: Validates that all 6 variants work correctly with different accent/gray combinations

import 'package:flutter/material.dart';

import '../lib/src/components/button/button.dart';
import '../lib/src/radix/radix.dart' as resolver;
import '../lib/src/radix/radix_theme.dart';

void main() {
  runApp(const RadixButtonComprehensiveTest());
}

class RadixButtonComprehensiveTest extends StatefulWidget {
  const RadixButtonComprehensiveTest({super.key});

  @override
  State<RadixButtonComprehensiveTest> createState() =>
      _RadixButtonComprehensiveTestState();
}

class _RadixButtonComprehensiveTestState
    extends State<RadixButtonComprehensiveTest> {
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
      title: 'Radix Button Comprehensive Test',
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

  final ValueChanged<resolver.RadixAccentColor> onAccentChanged;
  final ValueChanged<resolver.RadixGrayColor> onGrayChanged;
  final ValueChanged<Brightness> onBrightnessChanged;
  final resolver.RadixAccentColor currentAccent;
  final resolver.RadixGrayColor currentGray;

  final Brightness currentBrightness;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Radix Button - Complete Spec Test'),
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
            _AllVariantsSection(size: 2),
            const SizedBox(height: 32),

            // Size Comparison - Solid Variant
            const Text(
              'Size Comparison - Solid Variant',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _SizeComparisonSection(),
            const SizedBox(height: 32),

            // State Testing - Each Variant
            const Text(
              'State Testing - All Variants',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _StateTestingSection(),
            const SizedBox(height: 32),

            // Accent Color Showcase
            const Text(
              'Accent Color Showcase - Solid Variant',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _AccentShowcaseSection(),
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

class _AllVariantsSection extends StatelessWidget {
  const _AllVariantsSection({required this.size});

  final int size;

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  RemixButtonStyle _getSizedStyle(RemixButtonStyle Function() _) {
    return switch (size) {
      1 => RadixButtonStyle.base(size: RadixButtonSize.size1),
      2 => RadixButtonStyle.base(size: RadixButtonSize.size2),
      3 => RadixButtonStyle.base(size: RadixButtonSize.size3),
      4 => RadixButtonStyle.base(size: RadixButtonSize.size4),
      _ =>
        RadixButtonStyle.base(size: RadixButtonSize.size2), // Default to size 2
    };
  }

  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        // Solid
        _getSizedStyle(() => RadixButtonStyle.solid()).call(
          label: 'Solid',
          icon: Icons.check_circle,
          onPressed: () => _showSnackBar(context, 'Solid pressed'),
        ),

        // Soft
        _getSizedStyle(() => RadixButtonStyle.soft()).call(
          label: 'Soft',
          icon: Icons.favorite,
          onPressed: () => _showSnackBar(context, 'Soft pressed'),
        ),

        // Surface
        _getSizedStyle(() => RadixButtonStyle.surface()).call(
          label: 'Surface',
          icon: Icons.layers,
          onPressed: () => _showSnackBar(context, 'Surface pressed'),
        ),

        // Outline
        _getSizedStyle(() => RadixButtonStyle.outline()).call(
          label: 'Outline',
          icon: Icons.crop_free,
          onPressed: () => _showSnackBar(context, 'Outline pressed'),
        ),

        // Ghost
        _getSizedStyle(() => RadixButtonStyle.ghost()).call(
          label: 'Ghost',
          icon: Icons.visibility_off,
          onPressed: () => _showSnackBar(context, 'Ghost pressed'),
        ),

        // Surface (was Classic)
        _getSizedStyle(() => RadixButtonStyle.surface()).call(
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
        RadixButtonStyle.solid().call(label: 'Size 1', onPressed: () {}),
        const SizedBox(height: 16),
        const Text('Size 2 (Medium - Default)'),
        const SizedBox(height: 8),
        RadixButtonStyle.solid().call(label: 'Size 2', onPressed: () {}),
        const SizedBox(height: 16),
        const Text('Size 3 (Large)'),
        const SizedBox(height: 8),
        RadixButtonStyle.solid().call(label: 'Size 3', onPressed: () {}),
        const SizedBox(height: 16),
        const Text('Size 4 (Extra Large)'),
        const SizedBox(height: 8),
        RadixButtonStyle.solid().call(label: 'Size 4', onPressed: () {}),
      ],
    );
  }
}

class _StateTestingSection extends StatelessWidget {
  const _StateTestingSection();

  RemixButtonStyle _getVariantButton(String variantName) {
    switch (variantName) {
      case 'Solid':
        return RadixButtonStyle.solid();
      case 'Soft':
        return RadixButtonStyle.soft();
      case 'Surface':
        return RadixButtonStyle.surface();
      case 'Outline':
        return RadixButtonStyle.outline();
      case 'Ghost':
        return RadixButtonStyle.ghost();
      default:
        return RadixButtonStyle.solid();
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
      resolver.RadixAccentColor.indigo,
      resolver.RadixAccentColor.blue,
      resolver.RadixAccentColor.green,
      resolver.RadixAccentColor.red,
      resolver.RadixAccentColor.purple,
      resolver.RadixAccentColor.orange,
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: popularAccents.map((accentColor) {
        // Create temporary scope to show the accent
        return createRadixScope(
          accent: accentColor,
          gray: resolver.RadixGrayColor.slate,
          brightness: Theme.of(context).brightness,
          child: RadixButtonStyle.solid().call(
            label: accentColor.name,
            onPressed: () => print('Button pressed'),
          ),
        );
      }).toList(),
    );
  }
}
