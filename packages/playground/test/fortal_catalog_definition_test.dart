import 'package:flutter_test/flutter_test.dart';
import 'package:playground/specimens/fortal_catalog.dart';

void main() {
  test('Fortal catalog is complete, ordered, and valid', () {
    expect(fortalCatalog.validate, returnsNormally);
    expect(fortalCatalog.themes.map((theme) => theme.id), [
      'fortal-light',
      'fortal-dark',
    ]);
    expect(fortalCatalog.specimens.map((specimen) => specimen.id), [
      'accordion',
      'avatar',
      'badge',
      'button',
      'callout',
      'card',
      'checkbox',
      'dialog',
      'divider',
      'icon-button',
      'menu',
      'progress',
      'radio',
      'select',
      'slider',
      'spinner',
      'switch',
      'tabs',
      'text-field',
      'toggle',
      'tooltip',
    ]);
    for (final specimen in fortalCatalog.specimens) {
      expect(specimen.rows, isNotEmpty, reason: specimen.id);
      expect(specimen.scenarios, isNotEmpty, reason: specimen.id);
    }
  });

  test('variant and size products include every public enum value', () {
    for (final specimen in fortalCatalog.specimens.where(
      (item) => item.rowAxes.length == 2,
    )) {
      final variants = specimen.rows
          .map((row) => row.values['variant']!.id)
          .toSet();
      final sizes = specimen.rows.map((row) => row.values['size']!.id).toSet();
      expect(
        specimen.rows.length,
        variants.length * sizes.length,
        reason: specimen.id,
      );
      expect(specimen.rowAxes.map((axis) => axis.id), ['variant', 'size']);
    }
  });
}
