import 'package:flutter_test/flutter_test.dart';
import 'package:playground/sheets/fortal_catalog.dart';

void main() {
  test('Fortal catalog is complete, ordered, and valid', () {
    expect(fortalCatalog.validate, returnsNormally);
    expect(fortalCatalog.themes.map((theme) => theme.id), [
      'fortal-light',
      'fortal-dark',
    ]);
    expect(fortalCatalog.sheets.map((sheet) => sheet.id), [
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
    for (final sheet in fortalCatalog.sheets) {
      expect(sheet.rows, isNotEmpty, reason: sheet.id);
      expect(sheet.scenarios, isNotEmpty, reason: sheet.id);
    }
  });

  test('variant and size products include every public enum value', () {
    for (final sheet in fortalCatalog.sheets.where(
      (item) => item.rowAxes.length == 2,
    )) {
      final variants = sheet.rows
          .map((row) => row.values['variant']!.id)
          .toSet();
      final sizes = sheet.rows.map((row) => row.values['size']!.id).toSet();
      expect(
        sheet.rows.length,
        variants.length * sizes.length,
        reason: sheet.id,
      );
      expect(sheet.rowAxes.map((axis) => axis.id), ['variant', 'size']);
    }
  });
}
