import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
      'extracts unified Radix tokens (colors + spacing + typography + radius + shadows)',
      () async {
    final tokensFile = File('radix_tokens.generated.json');
    final colorsFile = File('radix_colors.generated.json');
    if (await tokensFile.exists()) {
      await tokensFile.delete();
    }
    if (await colorsFile.exists()) {
      await colorsFile.delete();
    }

    final res = await Process.run(
      'dart',
      [
        'run',
        'scripts/extract_radix_tokens.dart',
      ],
      runInShell: true,
    );

    expect(res.exitCode, 0,
        reason:
            'Script should exit 0. Stdout: ${res.stdout}\nStderr: ${res.stderr}');

    // Both files should exist
    expect(await tokensFile.exists(), isTrue);
    expect(await colorsFile.exists(), isTrue);

    // tokens: should NOT include colors
    final tokensData =
        json.decode(await tokensFile.readAsString()) as Map<String, dynamic>;
    expect(tokensData.containsKey('colors'), isFalse);

    // core categories (from base tokens)
    final spacing = Map<String, dynamic>.from(
        tokensData['spacing'] ?? const <String, dynamic>{});
    final typography = Map<String, dynamic>.from(
        tokensData['typography'] ?? const <String, dynamic>{});
    final radius = Map<String, dynamic>.from(
        tokensData['radius'] ?? const <String, dynamic>{});
    final shadows = Map<String, dynamic>.from(
        tokensData['shadows'] ?? const <String, dynamic>{});

    expect(spacing.isNotEmpty, isTrue);
    expect(typography.isNotEmpty, isTrue);
    expect(radius.isNotEmpty, isTrue);
    expect(shadows.isNotEmpty, isTrue);

    // theme section exists
    final theme = (tokensData['theme'] ?? const {}) as Map<String, dynamic>;
    expect(theme.isNotEmpty, isTrue, reason: 'theme should be present');

    // colors: in separate file
    final colorsData =
        json.decode(await colorsFile.readAsString()) as Map<String, dynamic>;
    final colors = Map<String, dynamic>.from(
        colorsData['colors'] ?? const <String, dynamic>{});
    final scales = Map<String, dynamic>.from(
        colors['scales'] ?? const <String, dynamic>{});
    expect(scales.containsKey('indigo'), isTrue);
    expect(scales.containsKey('blue'), isTrue);

    final neutrals = Map<String, dynamic>.from(
        colors['neutrals'] ?? const <String, dynamic>{});
    expect(neutrals.containsKey('blackA'), isTrue);

    await tokensFile.delete();
    await colorsFile.delete();
  }, timeout: const Timeout(Duration(minutes: 2)));
}
