// Replaces the package-level test config for this directory so the semantics
// update spy can be the test isolate's binding.
import 'dart:async';

import 'semantics_update_spy.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  SemanticsUpdateSpyBinding();
  await testMain();
}
