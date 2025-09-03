import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

/// Demo showcasing the new RemixLabel builder features
class LabelBuilderDemo extends StatelessWidget {
  const LabelBuilderDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RemixLabel Builder Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Regular Labels',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            
            // Regular usage - unchanged
            const RemixLabel('Simple Label'),
            const SizedBox(height: 8),
            
            // With icon at leading position
            const RemixLabel(
              'Settings',
              icon: Icons.settings,
            ),
            const SizedBox(height: 8),
            
            // With icon at trailing position
            const RemixLabel(
              'Next',
              icon: Icons.arrow_forward,
              iconPosition: IconPosition.trailing,
            ),
            
            const Divider(height: 32),
            const Text(
              'Part Builders',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            
            // Custom text builder
            RemixLabel(
              'Premium',
              textBuilder: (context, textSpec, text) {
                // Use the spec's style to create custom text
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(text, style: textSpec.style),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'PRO',
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 8),
            
            // Custom icon builder
            RemixLabel(
              'Notifications',
              icon: Icons.notifications,
              iconBuilder: (context, iconSpec, icon, position) {
                // icon is guaranteed to be non-null here since we provide icon: Icons.notifications
                return Badge(
                  label: const Text('5'),
                  child: Icon(icon!, size: iconSpec.size, color: iconSpec.color),
                );
              },
            ),
            const SizedBox(height: 8),
            
            // Animated icon with position-aware builder
            _AnimatedLabel(),
            
            const Divider(height: 32),
            const Text(
              'Full Builder',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            
            // Full custom builder
            RemixLabel(
              'Dashboard',
              builder: (context, spec, text) {
                // Build custom layout
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.dashboard, size: 32),
                      const SizedBox(height: 8),
                      spec.widget(text: text),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Animated label example
class _AnimatedLabel extends StatefulWidget {
  @override
  State<_AnimatedLabel> createState() => _AnimatedLabelState();
}

class _AnimatedLabelState extends State<_AnimatedLabel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RemixLabel(
      'Loading',
      icon: Icons.refresh,
      iconBuilder: (context, iconSpec, icon, position) {
        // icon is guaranteed to be non-null here since we provide icon: Icons.refresh
        // Position-aware animation (could animate differently based on position)
        return RotationTransition(
          turns: _controller,
          child: Icon(icon!, size: iconSpec.size, color: iconSpec.color),
        );
      },
    );
  }
}