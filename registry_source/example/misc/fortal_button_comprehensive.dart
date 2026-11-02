import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:registry_source/fortal.dart';

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
  FortalAccentColor _accent = FortalAccentColor.ceu;
  Brightness _brightness = .light;

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      color: const Color(0xFFF8FAFC),
      pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) =>
            builder(context),
      ),
      builder: (context, child) => FortalTheme(
        accent: _accent,
        mode: _brightness == Brightness.dark ? .dark : .light,
        child: Overlay.wrap(
          child: RemixToastScope(style: fortalToastStyle(), child: child!),
        ),
      ),
      home: _ComprehensiveTestScreen(
        onAccentChanged: (accent) => setState(() => _accent = accent),
        onBrightnessChanged: (brightness) =>
            setState(() => _brightness = brightness),
        currentAccent: _accent,
        currentBrightness: _brightness,
      ),
      title: 'Fortal Button Comprehensive Test',
    );
  }
}

class _ComprehensiveTestScreen extends StatelessWidget {
  const _ComprehensiveTestScreen({
    required this.onAccentChanged,
    required this.onBrightnessChanged,
    required this.currentAccent,
    required this.currentBrightness,
  });

  final ValueChanged<FortalAccentColor> onAccentChanged;
  final ValueChanged<Brightness> onBrightnessChanged;
  final FortalAccentColor currentAccent;

  final Brightness currentBrightness;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              const Expanded(
                child: FortalHeading('Fortal Button - Complete Spec Test'),
              ),
              FortalButton(
                label: currentBrightness == .light
                    ? 'Dark theme'
                    : 'Light theme',
                onPressed: () => onBrightnessChanged(
                  currentBrightness == .light ? .dark : .light,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                _ThemeControls(
                  accent: currentAccent,
                  onAccentChanged: onAccentChanged,
                ),
                const SizedBox(height: 24),
                const Text(
                  'All Variants - Size 2 (Default)',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const _AllVariantsSection(size: 2),
                const SizedBox(height: 32),
                const Text(
                  'Size Comparison - Solid Variant',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const _SizeComparisonSection(),
                const SizedBox(height: 32),
                const Text(
                  'State Testing - All Variants',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const _StateTestingSection(),
                const SizedBox(height: 32),
                const Text(
                  'Theme Showcase - Solid Variant',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const _AccentShowcaseSection(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ThemeControls extends StatelessWidget {
  const _ThemeControls({required this.accent, required this.onAccentChanged});

  final FortalAccentColor accent;
  final ValueChanged<FortalAccentColor> onAccentChanged;

  @override
  Widget build(BuildContext context) => FortalCard(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: FortalSelect<FortalAccentColor>(
        items: [
          for (final theme in FortalAccentColor.values)
            RemixSelectItem(value: theme, label: theme.name),
        ],
        selectedValue: accent,
        trigger: const RemixSelectTrigger(placeholder: 'Choose theme'),
        onChanged: (value) {
          if (value != null) onAccentChanged(value);
        },
      ),
    ),
  );
}

class _AllVariantsSection extends StatelessWidget {
  const _AllVariantsSection({required this.size});

  final int size;

  void _showToast(BuildContext context, String message) {
    showRemixToast(context, RemixToastData(title: message));
  }

  ButtonStyler _getSizedStyle(FortalButtonVariant variant) {
    return switch (size) {
      1 => fortalButtonStyle(variant: variant, size: .size1),
      2 => fortalButtonStyle(variant: variant, size: .size2),
      3 => fortalButtonStyle(variant: variant, size: .size3),
      4 => fortalButtonStyle(variant: variant, size: .size4),
      _ => fortalButtonStyle(variant: variant, size: .size2),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _getSizedStyle(.solid).call(
          label: 'Solid',
          leadingIcon: Icons.check_circle,
          onPressed: () => _showToast(context, 'Solid pressed'),
        ),
        _getSizedStyle(.soft).call(
          label: 'Soft',
          leadingIcon: Icons.favorite,
          onPressed: () => _showToast(context, 'Soft pressed'),
        ),
        _getSizedStyle(.surface).call(
          label: 'Surface',
          leadingIcon: Icons.layers,
          onPressed: () => _showToast(context, 'Surface pressed'),
        ),
        _getSizedStyle(.outline).call(
          label: 'Outline',
          leadingIcon: Icons.crop_free,
          onPressed: () => _showToast(context, 'Outline pressed'),
        ),
        _getSizedStyle(.ghost).call(
          label: 'Ghost',
          leadingIcon: Icons.visibility_off,
          onPressed: () => _showToast(context, 'Ghost pressed'),
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
      crossAxisAlignment: .start,
      children: [
        const Text('Size 1 (Small)'),
        const SizedBox(height: 8),
        fortalButtonStyle(
          variant: .solid,
        ).call(label: 'Size 1', onPressed: () {}),
        const SizedBox(height: 16),
        const Text('Size 2 (Medium - Default)'),
        const SizedBox(height: 8),
        fortalButtonStyle(
          variant: .solid,
        ).call(label: 'Size 2', onPressed: () {}),
        const SizedBox(height: 16),
        const Text('Size 3 (Large)'),
        const SizedBox(height: 8),
        fortalButtonStyle(
          variant: .solid,
        ).call(label: 'Size 3', onPressed: () {}),
        const SizedBox(height: 16),
        const Text('Size 4 (Extra Large)'),
        const SizedBox(height: 8),
        fortalButtonStyle(
          variant: .solid,
        ).call(label: 'Size 4', onPressed: () {}),
      ],
    );
  }
}

class _StateTestingSection extends StatelessWidget {
  const _StateTestingSection();

  ButtonStyler _getVariantButton(String variantName) {
    switch (variantName) {
      case 'Solid':
        return fortalButtonStyle(variant: .solid);
      case 'Soft':
        return fortalButtonStyle(variant: .soft);
      case 'Surface':
        return fortalButtonStyle(variant: .surface);
      case 'Outline':
        return fortalButtonStyle(variant: .outline);
      case 'Ghost':
        return fortalButtonStyle(variant: .ghost);
      default:
        return fortalButtonStyle(variant: .solid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
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
              _getVariantButton(variantName).call(
                label: 'Normal',
                onPressed: () => debugPrint('Button pressed'),
              ),
              _getVariantButton(variantName).call(
                label: 'Loading',
                loading: true,
                onPressed: () => debugPrint('Button pressed'),
              ),
              _getVariantButton(
                variantName,
              ).call(label: 'Disabled', enabled: false, onPressed: null),
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
    const popularAccents = FortalAccentColor.values;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: popularAccents.map((accentColor) {
        // Create temporary scope to show the accent
        return FortalTheme(
          accent: accentColor,

          child: fortalButtonStyle(variant: .solid).call(
            label: accentColor.name,
            onPressed: () => debugPrint('Button pressed'),
          ),
        );
      }).toList(),
    );
  }
}
