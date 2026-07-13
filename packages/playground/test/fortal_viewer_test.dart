import 'package:flutter_test/flutter_test.dart';
import 'package:playground/sheets/fortal_catalog.dart';
import 'package:playground/sheets/fortal_viewer.dart';

void main() {
  test('router delegate binds selection to canonical URLs', () async {
    final delegate = SheetRouterDelegate(fortalCatalog);
    addTearDown(delegate.dispose);

    // The default selection is a bare `/` (no redundant query params).
    expect(delegate.currentConfiguration.path, '/');
    expect(delegate.currentConfiguration.queryParameters, isEmpty);

    // A deep link restores the exact selection and round-trips to the same URL.
    await delegate.setNewRoutePath(
      Uri.parse('/?sheet=button&theme=fortal-dark'),
    );
    expect(delegate.controller.selection?.sheetId, 'button');
    expect(delegate.controller.selection?.themeId, 'fortal-dark');
    expect(delegate.currentConfiguration.queryParameters, {
      'sheet': 'button',
      'theme': 'fortal-dark',
    });

    // An unknown sheet canonicalizes to the first declared one and drops the
    // invalid param from the URL.
    await delegate.setNewRoutePath(Uri.parse('/?sheet=bogus'));
    expect(
      delegate.controller.selection?.sheetId,
      fortalCatalog.sheets.first.id,
    );
    expect(delegate.currentConfiguration.queryParameters, isEmpty);
  });
}
