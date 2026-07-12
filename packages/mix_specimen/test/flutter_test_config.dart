import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_specimen/golden.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  configureSpecimenGoldenComparator();
  await loadSpecimenFonts();

  return testMain();
}
