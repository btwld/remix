import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

void main() {
  group('AppBarSpec', () {
    test('creates every public anatomy slot', () {
      const spec = AppBarSpec();

      expect(spec.container, isA<StyleSpec<BoxSpec>>());
      expect(spec.toolbar, isA<StyleSpec<BoxSpec>>());
      expect(spec.title, isA<StyleSpec<TextSpec>>());
      expect(spec.actions, isA<StyleSpec<FlexBoxSpec>>());
      expect(spec.bottom, isA<StyleSpec<BoxSpec>>());
      expect(spec.toolbarHeight, isNull);
      expect(spec.spacing, isNull);
      expect(spec.props, hasLength(7));
    });

    test(
      'copyWith, lerp, equality, and diagnostics preserve value semantics',
      () {
        const original = AppBarSpec();
        final title = StyleSpec(
          spec: TextSpec(style: const TextStyle(fontSize: 18)),
        );
        final copy = original.copyWith(
          title: title,
          toolbarHeight: 64,
          spacing: 12,
        );

        expect(copy.title, title);
        expect(copy.container, original.container);
        expect(original.lerp(null, 0.5), original);
        expect(original.lerp(copy, 1).title.spec.style?.fontSize, 18);
        expect(
          const AppBarSpec(
            toolbarHeight: 48,
          ).lerp(const AppBarSpec(toolbarHeight: 64), 0.5).toolbarHeight,
          56,
        );
        expect(const AppBarSpec(), original);
        expect(const AppBarSpec().hashCode, original.hashCode);

        final builder = DiagnosticPropertiesBuilder();
        original.debugFillProperties(builder);
        expect(builder.properties.map((property) => property.name), [
          'container',
          'toolbar',
          'title',
          'actions',
          'bottom',
          'toolbarHeight',
          'spacing',
        ]);
      },
    );
  });
}
