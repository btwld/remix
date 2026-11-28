import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:registry_source/fortal.dart';

void main() {
  testWidgets('Fortal recipe resolves in a Fortal scope', (tester) async {
    await tester.pumpWidget(
      FortalTheme(
        child: WidgetsApp(
          color: const Color(0xFFFFFFFF),
          pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
            settings: settings,
            pageBuilder: (context, _, _) => builder(context),
          ),
          home: FortalToggleGroup<String>(
            items: const [
              RemixToggleGroupItem(value: 'list', label: 'List'),
              RemixToggleGroupItem(value: 'grid', label: 'Grid'),
            ],
            selectedValue: 'list',
            onChanged: (_) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(RemixToggleGroup<String>), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  test('Fortal recipe defaults to soft size2', () {
    expect(
      fortalToggleGroupStyle(),
      fortalToggleGroupStyle(variant: .soft, size: .size2),
    );
  });
  testWidgets('all Fortal variant and size combinations resolve', (
    tester,
  ) async {
    for (final variant in FortalToggleGroupVariant.values) {
      for (final size in FortalToggleGroupSize.values) {
        final resolved = await _resolveFortalToggleGroupStyle(
          tester,
          fortalToggleGroupStyle(variant: variant, size: size),
          states: {WidgetState.selected},
        );
        final groupBox = resolved.spec.container.spec.box?.spec;
        final item = resolved.spec.item.spec;
        final itemBox = item.container.spec.box?.spec;

        expect(
          groupBox?.decoration,
          isA<BoxDecoration>(),
          reason: '$variant $size group decoration',
        );
        expect(
          itemBox?.padding,
          isNotNull,
          reason: '$variant $size item padding',
        );
        expect(
          item.container.spec.flex?.spec.spacing,
          isNotNull,
          reason: '$variant $size item spacing',
        );
        expect(
          item.label.spec.style?.fontSize,
          isNotNull,
          reason: '$variant $size label size',
        );
        expect(
          item.icon.spec.size,
          isNotNull,
          reason: '$variant $size icon size',
        );
        expect(
          itemBox?.decoration,
          isA<BoxDecoration>(),
          reason: '$variant $size selected decoration',
        );
        expect(
          item.label.spec.style?.color,
          isNotNull,
          reason: '$variant $size selected foreground',
        );
      }
    }
  });
  testWidgets('Fortal sizes resolve the item box, padding and type', (
    tester,
  ) async {
    const expected = {
      FortalToggleGroupSize.size1: (
        edge: 28.0,
        inline: 8.0,
        text: 12.0,
        icon: 14.0,
      ),
      FortalToggleGroupSize.size2: (
        edge: 36.0,
        inline: 10.0,
        text: 13.0,
        icon: 16.0,
      ),
      FortalToggleGroupSize.size3: (
        edge: 44.0,
        inline: 12.0,
        text: 13.0,
        icon: 16.0,
      ),
    };

    for (final MapEntry(key: size, value: metrics) in expected.entries) {
      final resolved = await _resolveFortalToggleGroupStyle(
        tester,
        fortalToggleGroupStyle(size: size),
      );
      final group = resolved.spec.container.spec.box!.spec;
      final item = resolved.spec.item.spec;
      final box = item.container.spec.box!.spec;

      expect(group.padding, const EdgeInsets.all(3), reason: '$size');
      expect(resolved.spec.container.spec.flex!.spec.spacing, 2);
      expect(
        (group.decoration! as BoxDecoration).borderRadius,
        const BorderRadius.all(Radius.circular(14)),
      );
      expect(box.constraints!.minHeight, metrics.edge, reason: '$size');
      expect(box.constraints!.minWidth, metrics.edge, reason: '$size');
      expect(
        box.padding,
        EdgeInsets.symmetric(horizontal: metrics.inline),
        reason: '$size',
      );
      // The group corner less its 3px padding.
      expect(
        (box.decoration! as BoxDecoration).borderRadius,
        const BorderRadius.all(Radius.circular(11)),
      );
      expect(item.container.spec.flex!.spec.spacing, 6);
      expect(item.label.spec.style!.fontSize, metrics.text, reason: '$size');
      expect(item.icon.spec.size, metrics.icon, reason: '$size');
    }
  });

  testWidgets('one fill glides to the on item at the measured pace', (
    tester,
  ) async {
    final soft = await _resolveFortalToggleGroupStyle(
      tester,
      fortalToggleGroupStyle(),
      accent: FortalAccentColor.orla,
    );
    final surface = await _resolveFortalToggleGroupStyle(
      tester,
      fortalToggleGroupStyle(variant: .surface),
      accent: FortalAccentColor.orla,
    );
    final softFill = soft.spec.indicator!.spec.decoration! as BoxDecoration;
    final surfaceFill =
        surface.spec.indicator!.spec.decoration! as BoxDecoration;

    // The neutral indicator mixed 11% into the surface, rounded 1px past the
    // group corner.
    expect(softFill.color, isSameColorAs(const Color(0xFFE3E3E3)));
    expect(softFill.borderRadius, const BorderRadius.all(Radius.circular(15)));
    expect(surfaceFill.color, const Color(0xFFF8F8F8));
    expect((surfaceFill.border! as Border).top.color, const Color(0xFFE9E9E9));
    expect(
      soft.spec.indicatorMotion,
      AnimationConfig.curve(
        duration: const Duration(milliseconds: 200),
        curve: FortalMotion.easeStandard,
      ),
    );

    final on = await _resolveFortalToggleGroupStyle(
      tester,
      fortalToggleGroupStyle(),
      accent: FortalAccentColor.orla,
      states: {WidgetState.selected, WidgetState.hovered},
    );
    final onBox = on.spec.item.spec.container.spec.box!.spec;
    // The on item paints nothing over the gliding fill, even under the
    // pointer, and its text is ink.
    expect((onBox.decoration! as BoxDecoration).color, const Color(0x00000000));
    expect(on.spec.item.spec.label.spec.style!.color, const Color(0xFF0B0B0B));
  });
}

Future<StyleSpec<ToggleGroupSpec>> _resolveFortalToggleGroupStyle(
  WidgetTester tester,
  ToggleGroupStyler style, {
  Set<WidgetState> states = const {},
  FortalAccentColor? accent,
}) async {
  late StyleSpec<ToggleGroupSpec> resolved;

  await tester.pumpWidget(
    FortalTheme(
      accent: accent,
      child: WidgetsApp(
        color: const Color(0xFFFFFFFF),
        pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (context, _, _) => builder(context),
        ),
        home: WidgetStateProvider(
          states: states,
          child: Builder(
            builder: (context) {
              resolved = style.build(context);

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    ),
  );

  return resolved;
}
