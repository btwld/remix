import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

void main() {
  runApp(const RemixExampleApp());
}

class RemixExampleApp extends StatelessWidget {
  const RemixExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FortalScope(
        accent: .blue,
        gray: .slate,
        brightness: .light,
        child: const RemixExampleScreen(),
      ),
    );
  }
}

class RemixExampleScreen extends StatefulWidget {
  const RemixExampleScreen({super.key});

  @override
  State<RemixExampleScreen> createState() => _RemixExampleScreenState();
}

class _RemixExampleScreenState extends State<RemixExampleScreen> {
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: RemixCard(
                style: fortalCardStyler(variant: .classic, size: .size3),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RemixBadge(
                      label: 'Remix 1.0',
                      style: fortalBadgeStyler(variant: .soft),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Build themed Flutter interfaces with Remix widgets and Fortal recipes.',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        RemixToggle(
                          selected: notificationsEnabled,
                          onChanged: (value) {
                            setState(() => notificationsEnabled = value);
                          },
                          icon: Icons.notifications_active_outlined,
                          label: 'Notifications',
                          style: fortalToggleStyler(variant: .outline),
                        ),
                        RemixButton(
                          label: 'Continue',
                          trailingIcon: Icons.arrow_forward_rounded,
                          style: fortalButtonStyler(),
                          onPressed: () {
                            debugPrint('Continue pressed');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
