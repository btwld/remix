import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'range_calendar_reference.dart';

/// Run with `flutter run -t lib/date_range_picker_reference.dart`.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) SemanticsBinding.instance.ensureSemantics();
  runApp(const RangeCalendarReferenceApp(usePicker: true));
}
