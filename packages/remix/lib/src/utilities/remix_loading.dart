import 'package:flutter/foundation.dart' show internal;
import 'package:flutter/widgets.dart';

/// Lays [control] out exactly as it would alone and, while [announcement] is
/// set, adds a live region that reads it.
///
/// The Stack is always present, so toggling loading neither remounts the
/// control nor changes the constraints it lays out under.
@internal
Widget remixLoadingAnnouncer({
  required Widget control,
  required String? announcement,
}) => Stack(
  fit: .passthrough,
  children: [
    control,
    if (announcement != null)
      PositionedDirectional(
        start: 0,
        top: 0,
        child: Semantics(
          liveRegion: true,
          label: announcement,
          child: const SizedBox.square(dimension: 1),
        ),
      ),
  ],
);
