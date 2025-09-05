import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

Widget buildButtonExample() {
  return Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _Section(
        title: 'Remix',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RemixButton(
              label: 'Primary Button',
              onPressed: () {},
            ),
            const SizedBox(height: 12),
            const RemixButton(
              label: 'Disabled',
              enabled: false,
              onPressed: null,
            ),
            const SizedBox(height: 12),
            const RemixButton(
              label: 'Loading',
              loading: true,
              onPressed: null,
            ),
            const SizedBox(height: 12),
            RemixButton.icon(
              Icons.star,
              onPressed: () {},
              semanticLabel: 'Favorite',
            ),
          ],
        ),
      ),
      const SizedBox(width: 24),
      _Section(
        title: 'Material',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: const Text('Primary Button'),
            ),
            const SizedBox(height: 12),
            const ElevatedButton(
              onPressed: null,
              child: Text('Disabled'),
            ),
            const SizedBox(height: 12),
            // Simulated loading state for Material (no built-in loading flag)
            const ElevatedButton(
              onPressed: null,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text('Loading'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            IconButton(
              onPressed: () {},
              tooltip: 'Favorite',
              icon: const Icon(Icons.star),
            ),
          ],
        ),
      ),
    ],
  );
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}
