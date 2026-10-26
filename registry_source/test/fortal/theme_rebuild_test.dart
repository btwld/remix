import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';

/// Every token reader is a dependent of the nearest `MixScope`, which notifies
/// it whenever the scope's token map changes. A scope rebuilt from the same
/// settings must therefore build an equal map, or one parent rebuild restyles
/// everything below it.
void main() {
  for (final mode in [FortalThemeMode.light, FortalThemeMode.dark]) {
    testWidgets('rebuilding an equal ${mode.name} theme spares token readers', (
      tester,
    ) async {
      var reads = 0;
      // One instance, so only an inherited notification can rebuild it.
      final reader = Builder(
        builder: (context) {
          reads++;
          FortalTokens.gray12.resolve(context);
          return const SizedBox.shrink();
        },
      );

      Widget theme({FortalAccentColor accent = .red}) => FortalTheme(
        mode: mode,
        child: FortalTheme(accent: accent, child: reader),
      );

      await tester.pumpWidget(theme());
      expect(reads, 1);

      await tester.pumpWidget(theme());
      expect(reads, 1, reason: 'same settings');

      await tester.pumpWidget(theme(accent: .blue));
      expect(reads, 2, reason: 'a different accent');
    });
  }
}
