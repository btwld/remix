// ABOUTME: Example demonstrating the Radix button system with all variants and sizes
// ABOUTME: Shows how to set up createRadixScope and use RadixButtonStyle

import 'package:flutter/material.dart';

import '../lib/src/components/button/radix_button_styles.dart';
import '../lib/src/radix/radix.dart' as resolver;
import '../lib/src/radix/radix_theme.dart';

void main() {
  runApp(const RadixButtonExampleApp());
}

class RadixButtonExampleApp extends StatelessWidget {
  const RadixButtonExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: createRadixScope(
        accent: resolver.RadixAccentColor.indigo,
        gray: resolver.RadixGrayColor.slate,
        brightness: Brightness.light,
        child: const RadixButtonExampleScreen(),
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
        RadixButtonStyle.solid().call(
          label: 'Solid',
          onPressed: () => _showSnackBar(context, 'Solid button pressed'),
        ),

        // Soft variant
        RadixButtonStyle.soft().call(
          label: 'Soft',
          onPressed: () => _showSnackBar(context, 'Soft button pressed'),
        ),

        // Surface variant
        RadixButtonStyle.surface().call(
          label: 'Surface',
          onPressed: () => _showSnackBar(context, 'Surface button pressed'),
        ),

        // Outline variant
        RadixButtonStyle.outline().call(
          label: 'Outline',
          onPressed: () => _showSnackBar(context, 'Outline button pressed'),
        ),

        // Ghost variant
        RadixButtonStyle.ghost().call(
          label: 'Ghost',
          onPressed: () => _showSnackBar(context, 'Ghost button pressed'),
        ),

        // Surface variant
        RadixButtonStyle.surface().call(
          label: 'Surface',
          onPressed: () => _showSnackBar(context, 'Surface button pressed'),
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
            RadixButtonStyle.solid(size: RadixButtonSize.size1).call(
              label: 'Solid',
              icon: Icons.check,
              onPressed: () => print('Button pressed'),
            ),
            RadixButtonStyle.soft(size: RadixButtonSize.size1).call(
              label: 'Soft',
              icon: Icons.star,
              onPressed: () => print('Button pressed'),
            ),
            RadixButtonStyle.outline(size: RadixButtonSize.size1).call(
              label: 'Outline',
              icon: Icons.favorite,
              onPressed: () => print('Button pressed'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Size 2 (Medium - Default)'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            RadixButtonStyle.solid(size: RadixButtonSize.size2).call(
              label: 'Solid',
              icon: Icons.check,
              onPressed: () => print('Button pressed'),
            ),
            RadixButtonStyle.soft(size: RadixButtonSize.size2).call(
              label: 'Soft',
              icon: Icons.star,
              onPressed: () => print('Button pressed'),
            ),
            RadixButtonStyle.outline(size: RadixButtonSize.size2).call(
              label: 'Outline',
              icon: Icons.favorite,
              onPressed: () => print('Button pressed'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Size 3 (Large)'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            RadixButtonStyle.solid(size: RadixButtonSize.size3).call(
              label: 'Solid',
              icon: Icons.check,
              onPressed: () => print('Button pressed'),
            ),
            RadixButtonStyle.soft(size: RadixButtonSize.size3).call(
              label: 'Soft',
              icon: Icons.star,
              onPressed: () => print('Button pressed'),
            ),
            RadixButtonStyle.outline(size: RadixButtonSize.size3).call(
              label: 'Outline',
              icon: Icons.favorite,
              onPressed: () => print('Button pressed'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Size 4 (Extra Large)'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            RadixButtonStyle.solid(size: RadixButtonSize.size4).call(
              label: 'Solid',
              icon: Icons.check,
              onPressed: () => print('Button pressed'),
            ),
            RadixButtonStyle.soft(size: RadixButtonSize.size4).call(
              label: 'Soft',
              icon: Icons.star,
              onPressed: () => print('Button pressed'),
            ),
            RadixButtonStyle.outline(size: RadixButtonSize.size4).call(
              label: 'Outline',
              icon: Icons.favorite,
              onPressed: () => print('Button pressed'),
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
        RadixButtonStyle.solid().call(label: 'Normal', onPressed: () {}),

        // Loading state
        RadixButtonStyle.solid().call(
          label: 'Loading',
          loading: true,
          onPressed: () => print('Button pressed'),
        ),

        // Disabled state
        RadixButtonStyle.solid().call(
          label: 'Disabled',
          enabled: false,
          onPressed: null,
        ),

        // With icon
        RadixButtonStyle.solid().call(
          label: 'With Icon',
          icon: Icons.download,
          onPressed: () => print('Button pressed'),
        ),
      ],
    );
  }
}
