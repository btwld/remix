import 'package:flutter_test/flutter_test.dart';
import 'package:remix_ui_icons/icons_index.dart';

void main() {
  test('lists every glyph once, with a unique codepoint', () {
    expect(remixIconEntries, hasLength(924));
    final codepoints = remixIconEntries.map((entry) => entry.icon.codePoint);
    expect(codepoints.toSet(), hasLength(924));
    for (final entry in remixIconEntries) {
      expect(entry.icon.fontFamily, 'RemixIcons');
      expect(entry.icon.fontPackage, 'remix_ui_icons');
    }
  });

  test('never reuses a 0.1.x codepoint', () {
    for (final entry in remixIconEntries) {
      expect(
        entry.icon.codePoint,
        greaterThanOrEqualTo(0xE200),
        reason: '${entry.family.name}.${entry.name}',
      );
      expect(entry.icon.codePoint, lessThanOrEqualTo(0xF8FF));
    }
  });

  test('counts glyphs per family, style, and master', () {
    int count(RemixIconFamily family, [RemixIconStyle? style, int? master]) =>
        remixIconEntries
            .where(
              (entry) =>
                  entry.family == family &&
                  (style == null || entry.style == style) &&
                  (master == null || entry.master == master),
            )
            .length;

    expect(count(RemixIconFamily.outline), 462);
    expect(count(RemixIconFamily.rounded), 462);
    for (final family in RemixIconFamily.values) {
      final concepts = count(family) ~/ 6;
      for (final style in RemixIconStyle.values) {
        for (final master in const [12, 16, 24]) {
          expect(count(family, style, master), concepts);
        }
      }
    }
  });

  test('flags the glyphs that need a visible label, per family and master', () {
    String key(RemixIconEntry entry) =>
        '${entry.family.name}.${entry.concept}@${entry.master}';
    final labelled = {
      for (final entry in remixIconEntries)
        if (entry.requiresLabel) key(entry),
    };
    expect(labelled, {
      for (final family in ['outline', 'rounded'])
        for (final master in [12, 16, 24]) ...[
          '$family.warning@$master',
          '$family.arrowUpRight@$master',
        ],
      for (final master in [12, 16, 24]) 'rounded.branch@$master',
      'outline.help@12',
      'outline.branch@12',
      'outline.focus@12',
      'rounded.link@12',
      'rounded.help@12',
      'rounded.focus@12',
      for (final family in ['outline', 'rounded']) '$family.group@12',
      for (final concept in ['wand', 'checkCircle', 'ban', 'closeCircle'])
        for (final master in [12, 16, 24]) 'outline.$concept@$master',
    });
    // A requirement covers both styles of a master, and always says why.
    for (final entry in remixIconEntries.where(
      (entry) => entry.requiresLabel,
    )) {
      expect(entry.usage, isNotEmpty, reason: key(entry));
      expect(
        remixIconEntries.where(
          (other) => key(other) == key(entry) && !other.requiresLabel,
        ),
        isEmpty,
      );
    }
  });

  test('carries contextual guidance that is not a hard requirement', () {
    final help = remixIconEntries.singleWhere(
      (entry) =>
          entry.family == RemixIconFamily.outline && entry.name == 'help',
    );
    expect(help.requiresLabel, isFalse);
    expect(help.usage.single, contains('contextual label'));
  });

  test('records the deprecated aliases on the glyph they render', () {
    final aliased = {
      for (final entry in remixIconEntries)
        for (final alias in entry.aliases) alias: entry,
    };
    expect(aliased, hasLength(31));
    expect(aliased['magnifyingGlass']!.name, 'search');
    expect(aliased['cross2']!.name, 'close');
    expect(aliased['cross2']!.family, RemixIconFamily.outline);
    expect(aliased['cross2']!.master, 24);
  });
}
