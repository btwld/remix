library;

export '../mixins/naked_mixins.dart';
export 'equality.dart' show NakedEquatable;
export 'naked_focusable_detector.dart';
export 'naked_state_scope.dart';
// OverlayPlacementScope is the package's internal bridge for adapters that
// position their own overlay; read placement through OverlayPlacement.of.
export 'positioning.dart' hide OverlayPlacementScope;
export 'state.dart';
