import 'package:flutter_test/flutter_test.dart';
import 'package:remix/src/radix/parser/radix_css_parser.dart';

void main() {
  test('parses light indigo tokens and resolves var() references', () {
    const css = r'''
:root, .light, .light-theme {
  --indigo-9: #3e63dd;
  --indigo-10: #3358d4;
  --indigo-a10: #002ec9cc;
  --indigo-surface: #f5f8ffcc;
  --indigo-indicator: var(--indigo-9);
  --indigo-track: var(--indigo-9);
}
:root {
  --indigo-contrast: white;
}
''';

    final res = parseRadixCss(css, 'indigo');

    expect(res.light, isNotNull);
    final light = res.light!;

    expect(light.solid['9'], '#3e63dd');
    expect(light.solid['10'], '#3358d4');
    expect(light.alpha['a10'], '#002ec9cc');
    expect(light.surface, '#f5f8ffcc');
    expect(light.indicator, '#3e63dd');
    expect(light.track, '#3e63dd');
    expect(light.contrast, '#ffffff');

    // Contrast is global (:root) so dark gets it as well, even if other fields are empty.
    expect(res.dark, isNotNull);
    expect(res.dark!.contrast, '#ffffff');
  });
}

