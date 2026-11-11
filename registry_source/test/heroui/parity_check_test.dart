import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/heroui_parity/check.dart';

const _mapped = 'component: Button\nstatus: implemented\n';
const _extension =
    'component: Sidebar\nstatus: implemented\n'
    'extension: no upstream family\n';

Map<String, dynamic> _manifest({List<Map<String, Object?>>? extensions}) => {
  'families': [
    {'upstream': 'button', 'status': 'mapped', 'item': 'button'},
    {'upstream': 'navbar', 'status': 'deferred', 'reason': 'none upstream'},
  ],
  'extensions': ?extensions,
};

void main() {
  group('HeroUI family map', () {
    test('a mapped item with a worksheet passes', () {
      expect(
        familyMapFailures(
          manifest: _manifest(),
          items: {'button'},
          worksheets: {'button': _mapped},
        ),
        isEmpty,
      );
    });

    test('an item with no family and no extension entry still fails', () {
      expect(
        familyMapFailures(
          manifest: _manifest(),
          items: {'button', 'sidebar'},
          worksheets: {'button': _mapped, 'sidebar': _extension},
        ),
        contains(
          'item sidebar maps no upstream family and is not a listed extension',
        ),
      );
    });

    test('a listed extension with a declaring worksheet passes', () {
      expect(
        familyMapFailures(
          manifest: _manifest(
            extensions: [
              {'item': 'sidebar', 'reason': 'no sidebar upstream'},
            ],
          ),
          items: {'button', 'sidebar'},
          worksheets: {'button': _mapped, 'sidebar': _extension},
        ),
        isEmpty,
      );
    });

    test('an extension still needs a worksheet that declares it', () {
      final manifest = _manifest(
        extensions: [
          {'item': 'sidebar', 'reason': 'no sidebar upstream'},
        ],
      );
      expect(
        familyMapFailures(
          manifest: manifest,
          items: {'button', 'sidebar'},
          worksheets: {'button': _mapped},
        ),
        ['item sidebar has no worksheet'],
      );
      expect(
        familyMapFailures(
          manifest: manifest,
          items: {'button', 'sidebar'},
          worksheets: {'button': _mapped, 'sidebar': _mapped},
        ),
        ['extension sidebar worksheet does not declare extension:'],
      );
    });

    test('a mapped item cannot claim to be an extension', () {
      expect(
        familyMapFailures(
          manifest: _manifest(),
          items: {'button'},
          worksheets: {'button': _extension},
        ),
        ['item button worksheet declares extension: but is mapped'],
      );
      expect(
        familyMapFailures(
          manifest: _manifest(
            extensions: [
              {'item': 'button', 'reason': 'duplicated'},
            ],
          ),
          items: {'button'},
          worksheets: {'button': _mapped},
        ),
        contains('extension button is also named by an upstream family'),
      );
    });

    test('extensions are enumerated, reasoned, unique, and shipped', () {
      final failures = familyMapFailures(
        manifest: _manifest(
          extensions: [
            {'item': 'sidebar', 'reason': ' '},
            {'item': 'sidebar', 'reason': 'again'},
            {'item': 'chart', 'reason': 'not shipped'},
          ],
        ),
        items: {'button', 'sidebar'},
        worksheets: {'button': _mapped, 'sidebar': _extension},
      );
      expect(
        failures,
        containsAll([
          'extension sidebar lacks a reason',
          'extension sidebar is listed twice',
          'extension names missing item chart',
        ]),
      );
    });

    test('catalog items exclude the theme foundation', () {
      expect(
        catalogItems(
          '# Generated\nschema: 2\nitems:\n  theme:\n    files: []\n\n'
          '  icons:\n    registryDependencies:\n      - theme\n'
          '  dashboard_shell:\n    files: []\n',
        ),
        {'icons', 'dashboard_shell'},
      );
    });

    test('the committed catalog names every component item', () {
      final shipped = catalogItems(
        File('../registry/heroui/registry.yaml').readAsStringSync(),
      );
      final components = {
        for (final file in Directory('lib/src/heroui/components').listSync())
          if (file.path.endsWith('.dart') && !file.path.endsWith('.g.dart'))
            file.uri.pathSegments.last.replaceAll('.dart', ''),
      };
      expect(shipped, containsAll(components));
    });
  });
}
