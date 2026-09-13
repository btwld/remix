import 'package:flutter/widgets.dart';

import '../registry/component_registry.dart';
import '../ui/ui.dart';

/// Matches the heading role Fortal's `FortalHeading` filled before the host
/// migration. The playground preset installs no typography recipe, so the two
/// headings on this index page carry an explicit style.
const _headingStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w600,
  color: Color(0xFF1C2024),
);

class PlaygroundHome extends StatelessWidget {
  const PlaygroundHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text('Remix Playground', style: _headingStyle),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: availableComponents.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final key = availableComponents[index];
              return PlaygroundButton(
                label: key,
                onPressed: () => Navigator.of(context).push(
                  PageRouteBuilder<void>(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  PlaygroundButton(
                                    variant: .outline,
                                    label: 'Back',
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  const SizedBox(width: 16),
                                  Text(key, style: _headingStyle),
                                ],
                              ),
                            ),
                            Expanded(child: Builder(builder: components[key]!)),
                          ],
                        ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
