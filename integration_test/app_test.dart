import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'test_utils.dart';
import 'components/button_test.dart' as button_test;
import 'components/textfield_test.dart' as textfield_test;
import 'components/checkbox_test.dart' as checkbox_test;
import 'components/switch_test.dart' as switch_test;
import 'components/radio_test.dart' as radio_test;
import 'components/select_test.dart' as select_test;
import 'components/slider_test.dart' as slider_test;
import 'components/accordion_test.dart' as accordion_test;
import 'components/avatar_test.dart' as avatar_test;
import 'components/badge_test.dart' as badge_test;
import 'components/chip_test.dart' as chip_test;
import 'components/spinner_test.dart' as spinner_test;
import 'components/progress_test.dart' as progress_test;
import 'components/callout_test.dart' as callout_test;

void main() {
  // Initialize integration test binding
  IntegrationTestHelper.setupBinding();

  group('Remix Component Integration Tests', () {
    // Core interactive components
    button_test.main();
    textfield_test.main();
    checkbox_test.main();
    switch_test.main();
    radio_test.main();
    
    // Selection and input components
    select_test.main();
    slider_test.main();
    accordion_test.main();
    
    // Visual and feedback components
    avatar_test.main();
    badge_test.main();
    chip_test.main();
    spinner_test.main();
    progress_test.main();
    callout_test.main();
  });
}