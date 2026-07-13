import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_sheets/golden.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  configureSheetGoldenComparator();
  await loadSheetFonts();

  return testMain();
}
