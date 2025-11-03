import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

void main() {
  runApp(const FortalButtonExampleApp());
}

class FortalButtonExampleApp extends StatelessWidget {
  const FortalButtonExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: createFortalScope(
        accent: FortalAccentColor.indigo,
        gray: FortalGrayColor.slate,
        brightness: .light,
        child: const FortalButtonExampleScreen(),
      ),
      title: 'Fortal Button Example',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
    );
  }
}

class FortalButtonExampleScreen extends StatelessWidget {
  const FortalButtonExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fortal Button Variants & Sizes'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: .start,
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
        FortalButtonStyle.solid().call(
          label: 'Solid',
          onPressed: () => _showSnackBar(context, 'Solid button pressed'),
        ),

        // Soft variant
        FortalButtonStyle.soft().call(
          label: 'Soft',
          onPressed: () => _showSnackBar(context, 'Soft button pressed'),
        ),

        // Surface variant
        FortalButtonStyle.surface().call(
          label: 'Surface',
          onPressed: () => _showSnackBar(context, 'Surface button pressed'),
        ),

        // Outline variant
        FortalButtonStyle.outline().call(
          label: 'Outline',
          onPressed: () => _showSnackBar(context, 'Outline button pressed'),
        ),

        // Ghost variant
        FortalButtonStyle.ghost().call(
          label: 'Ghost',
          onPressed: () => _showSnackBar(context, 'Ghost button pressed'),
        ),

        // Surface variant
        FortalButtonStyle.surface().call(
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
      crossAxisAlignment: .start,
      children: [
        const Text('Size 1 (Small)'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            FortalButtonStyle.solid(size: FortalButtonSize.size1).call(
              label: 'Solid',
              leadingIcon: Icons.check,
              // ignore: avoid_print
              onPressed: () => print('Button pressed'),
            ),
            FortalButtonStyle.soft(size: FortalButtonSize.size1).call(
              label: 'Soft',
              leadingIcon: Icons.star,
              // ignore: avoid_print
              onPressed: () => print('Button pressed'),
            ),
            FortalButtonStyle.outline(size: FortalButtonSize.size1).call(
              label: 'Outline',
              leadingIcon: Icons.favorite,
              // ignore: avoid_print
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
            FortalButtonStyle.solid(size: FortalButtonSize.size2).call(
              label: 'Solid',
              leadingIcon: Icons.check,
              // ignore: avoid_print
              onPressed: () => print('Button pressed'),
            ),
            FortalButtonStyle.soft(size: FortalButtonSize.size2).call(
              label: 'Soft',
              leadingIcon: Icons.star,
              // ignore: avoid_print
              onPressed: () => print('Button pressed'),
            ),
            FortalButtonStyle.outline(size: FortalButtonSize.size2).call(
              label: 'Outline',
              leadingIcon: Icons.favorite,
              // ignore: avoid_print
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
            FortalButtonStyle.solid(size: FortalButtonSize.size3).call(
              label: 'Solid',
              leadingIcon: Icons.check,
              // ignore: avoid_print
              onPressed: () => print('Button pressed'),
            ),
            FortalButtonStyle.soft(size: FortalButtonSize.size3).call(
              label: 'Soft',
              leadingIcon: Icons.star,
              // ignore: avoid_print
              onPressed: () => print('Button pressed'),
            ),
            FortalButtonStyle.outline(size: FortalButtonSize.size3).call(
              label: 'Outline',
              leadingIcon: Icons.favorite,
              // ignore: avoid_print
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
            FortalButtonStyle.solid(size: FortalButtonSize.size4).call(
              label: 'Solid',
              leadingIcon: Icons.check,
              // ignore: avoid_print
              onPressed: () => print('Button pressed'),
            ),
            FortalButtonStyle.soft(size: FortalButtonSize.size4).call(
              label: 'Soft',
              leadingIcon: Icons.star,
              // ignore: avoid_print
              onPressed: () => print('Button pressed'),
            ),
            FortalButtonStyle.outline(size: FortalButtonSize.size4).call(
              label: 'Outline',
              leadingIcon: Icons.favorite,
              // ignore: avoid_print
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
        FortalButtonStyle.solid().call(label: 'Normal', onPressed: () {}),

        // Loading state
        FortalButtonStyle.solid().call(
          label: 'Loading',
          loading: true,
          // ignore: avoid_print
          onPressed: () => print('Button pressed'),
        ),

        // Disabled state
        FortalButtonStyle.solid().call(
          label: 'Disabled',
          enabled: false,
          onPressed: null,
        ),

        // With icon
        FortalButtonStyle.solid().call(
          label: 'With Icon',
          leadingIcon: Icons.download,
          // ignore: avoid_print
          onPressed: () => print('Button pressed'),
        ),
      ],
    );
  }
}
