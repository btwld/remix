import 'package:flutter_test/flutter_test.dart';
import 'package:playground/specimens/fortal_catalog.dart';
import 'package:playground/specimens/fortal_viewer.dart';

void main() {
  test('router delegate binds selection to canonical URLs', () async {
    final delegate = SpecimenRouterDelegate(fortalCatalog);
    addTearDown(delegate.dispose);

    // The default selection is a bare `/` (no redundant query params).
    expect(delegate.currentConfiguration.path, '/');
    expect(delegate.currentConfiguration.queryParameters, isEmpty);

    // A deep link restores the exact selection and round-trips to the same URL.
    await delegate.setNewRoutePath(
      Uri.parse('/?specimen=button&theme=fortal-dark'),
    );
    expect(delegate.controller.selection?.specimenId, 'button');
    expect(delegate.controller.selection?.themeId, 'fortal-dark');
    expect(delegate.currentConfiguration.queryParameters, {
      'specimen': 'button',
      'theme': 'fortal-dark',
    });

    // An unknown specimen canonicalizes to the first declared one and drops the
    // invalid param from the URL.
    await delegate.setNewRoutePath(Uri.parse('/?specimen=bogus'));
    expect(
      delegate.controller.selection?.specimenId,
      fortalCatalog.specimens.first.id,
    );
    expect(delegate.currentConfiguration.queryParameters, isEmpty);
  });
}
