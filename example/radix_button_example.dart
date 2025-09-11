// ABOUTME: Example demonstrating the Radix button system with all variants and sizes
// ABOUTME: Shows how to set up RadixTheme and use RadixButtonStyles

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../lib/src/components/button/radix_button_styles.dart';
import '../lib/src/theme/radix_theme_data.dart';
import '../lib/src/theme/radix_token_definitions.dart';
import '../lib/src/utilities/radix_token_resolver.dart' as resolver;

void main() {
  runApp(const RadixButtonExampleApp());
}

class RadixButtonExampleApp extends StatelessWidget {
  const RadixButtonExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a RadixThemeData with indigo accent and slate gray
    final radixThemeData = RadixThemeData(
      accent: resolver.RadixAccentColor.indigo,
      gray: resolver.RadixGrayColor.slate,
      brightness: Brightness.light,
      trackVariant: resolver.TrackVariant.neutral,
    );

    // Create token definitions for the theme
    final tokenDefinitions =
        RadixTokenDefinitions.createDefinitions(radixThemeData);

    return MaterialApp(
      home: MixScope(
        tokens: tokenDefinitions.toSet(),
        child: RadixTheme(
          themeData: radixThemeData,
          child: const RadixButtonExampleScreen(),
        ),
      ),
      title: 'Radix Button Example',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
    );
  }
}

class RadixButtonExampleScreen extends StatelessWidget {
  const RadixButtonExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Radix Button Variants & Sizes'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Button Variants',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _VariantSection(),
            SizedBox(height: 32),
            Text(
              'Button Sizes',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _SizeSection(),
            SizedBox(height: 32),
            Text(
              'Button States',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _StateSection(),
          ],
        ),
      ),
    );
  }
}

class _VariantSection extends StatelessWidget {
  const _VariantSection();

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        // Solid variant
        RadixButtonStyles.solid().call(
          label: 'Solid',
          onPressed: () => _showSnackBar(context, 'Solid button pressed'),
        ),

        // Soft variant
        RadixButtonStyles.soft().call(
          label: 'Soft',
          onPressed: () => _showSnackBar(context, 'Soft button pressed'),
        ),

        // Surface variant
        RadixButtonStyles.surface().call(
          label: 'Surface',
          onPressed: () => _showSnackBar(context, 'Surface button pressed'),
        ),

        // Outline variant
        RadixButtonStyles.outline().call(
          label: 'Outline',
          onPressed: () => _showSnackBar(context, 'Outline button pressed'),
        ),

        // Ghost variant
        RadixButtonStyles.ghost().call(
          label: 'Ghost',
          onPressed: () => _showSnackBar(context, 'Ghost button pressed'),
        ),

        // Classic variant
        RadixButtonStyles.classic().call(
          label: 'Classic',
          onPressed: () => _showSnackBar(context, 'Classic button pressed'),
        ),
      ],
    );
  }
}

class _SizeSection extends StatelessWidget {
  const _SizeSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Size 1 (Small)'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            RadixButtonStyles.solid(size: 1).call(
              label: 'Solid',
              icon: Icons.check,
              onPressed: () {},
            ),
            RadixButtonStyles.soft(size: 1).call(
              label: 'Soft',
              icon: Icons.star,
              onPressed: () {},
            ),
            RadixButtonStyles.outline(size: 1).call(
              label: 'Outline',
              icon: Icons.favorite,
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Size 2 (Medium - Default)'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            RadixButtonStyles.solid(size: 2).call(
              label: 'Solid',
              icon: Icons.check,
              onPressed: () {},
            ),
            RadixButtonStyles.soft(size: 2).call(
              label: 'Soft',
              icon: Icons.star,
              onPressed: () {},
            ),
            RadixButtonStyles.outline(size: 2).call(
              label: 'Outline',
              icon: Icons.favorite,
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Size 3 (Large)'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            RadixButtonStyles.solid(size: 3).call(
              label: 'Solid',
              icon: Icons.check,
              onPressed: () {},
            ),
            RadixButtonStyles.soft(size: 3).call(
              label: 'Soft',
              icon: Icons.star,
              onPressed: () {},
            ),
            RadixButtonStyles.outline(size: 3).call(
              label: 'Outline',
              icon: Icons.favorite,
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Size 4 (Extra Large)'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            RadixButtonStyles.solid(size: 4).call(
              label: 'Solid',
              icon: Icons.check,
              onPressed: () {},
            ),
            RadixButtonStyles.soft(size: 4).call(
              label: 'Soft',
              icon: Icons.star,
              onPressed: () {},
            ),
            RadixButtonStyles.outline(size: 4).call(
              label: 'Outline',
              icon: Icons.favorite,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class _StateSection extends StatelessWidget {
  const _StateSection();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        // Normal state
        RadixButtonStyles.solid().call(label: 'Normal', onPressed: () {}),

        // Loading state
        RadixButtonStyles.solid().call(
          label: 'Loading',
          loading: true,
          onPressed: () {},
        ),

        // Disabled state
        RadixButtonStyles.solid().call(
          label: 'Disabled',
          enabled: false,
          onPressed: null,
        ),

        // With icon
        RadixButtonStyles.solid().call(
          label: 'With Icon',
          icon: Icons.download,
          onPressed: () {},
        ),
      ],
    );
  }
}
