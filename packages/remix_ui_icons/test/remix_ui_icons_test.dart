import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix_ui_icons/icons_index.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

void main() {
  test('every glyph is in the RemixIcons font of this package', () {
    const icons = [
      OutlineIcons.search,
      RoundedIcons.homeFilled16,
      RemixIcons.close,
    ];
    for (final icon in icons) {
      expect(icon.fontFamily, 'RemixIcons');
      expect(icon.fontPackage, 'remix_ui_icons');
      expect(icon.matchTextDirection, isFalse);
    }
  });

  test('the bare name is the outline 24 px master, suffixes pick the rest', () {
    final entries = {
      for (final entry in remixIconEntries)
        if (entry.family == RemixIconFamily.outline &&
            entry.concept == 'search')
          entry.name: entry,
    };
    expect(entries.keys, [
      'search',
      'searchFilled',
      'search16',
      'searchFilled16',
      'search12',
      'searchFilled12',
    ]);
    expect(entries['search']!.icon, OutlineIcons.search);
    expect(entries['search']!.style, RemixIconStyle.outline);
    expect(entries['search']!.master, 24);
    expect(entries['searchFilled16']!.icon, OutlineIcons.searchFilled16);
    expect(entries['searchFilled16']!.style, RemixIconStyle.filled);
    expect(entries['searchFilled16']!.master, 16);
    expect(entries['search12']!.master, 12);
  });

  test('families draw the same concept as distinct glyphs', () {
    expect(OutlineIcons.search, isNot(RoundedIcons.search));
    expect(OutlineIcons.search, isNot(OutlineIcons.search16));
    expect(OutlineIcons.search, isNot(OutlineIcons.searchFilled));
  });

  test('RemixIcons is the Outline family under the same names', () {
    expect(RemixIcons.search, OutlineIcons.search);
    expect(RemixIcons.searchFilled12, OutlineIcons.searchFilled12);
    expect(RemixIcons.arrowUpRight16, OutlineIcons.arrowUpRight16);
    expect(RemixIcons.warningFilled, OutlineIcons.warningFilled);
  });

  test('deprecated 0.1.x aliases render their replacement', () {
    // ignore: deprecated_member_use_from_same_package
    expect(RemixIcons.magnifyingGlass, RemixIcons.search);
    // ignore: deprecated_member_use_from_same_package
    expect(RemixIcons.cross2, RemixIcons.close);
    // ignore: deprecated_member_use_from_same_package
    expect(RemixIcons.reload, RemixIcons.refresh);
    // ignore: deprecated_member_use_from_same_package
    expect(RemixIcons.exclamationTriangle, RemixIcons.warning);
  });

  test('the main library does not export the opt-in libraries', () {
    final library = File('lib/remix_ui_icons.dart').readAsStringSync();
    final exports = RegExp(
      r"^export '([^']+)';",
      multiLine: true,
    ).allMatches(library).map((match) => match[1]).toList();
    expect(exports, [
      'src/generated/outline_icons.dart',
      'src/generated/remix_icons.dart',
      'src/generated/rounded_icons.dart',
    ]);
    for (final path in exports) {
      final source = File('lib/$path').readAsStringSync();
      expect(source, isNot(contains('icons_index')));
      expect(source, isNot(contains('icon_sets')));
    }
  });

  testWidgets('renders glyphs from every family', (tester) async {
    const icons = [
      OutlineIcons.search,
      OutlineIcons.chevronDownFilled16,
      RoundedIcons.home,
      RemixIcons.check,
    ];

    await tester.pumpWidget(
      WidgetsApp(
        color: const Color(0xFFFFFFFF),
        builder: (context, child) =>
            Row(children: [for (final icon in icons) Icon(icon)]),
      ),
    );

    for (final icon in icons) {
      expect(find.byIcon(icon), findsOneWidget);
    }
  });
}
