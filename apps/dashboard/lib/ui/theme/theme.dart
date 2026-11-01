// Internal entrypoint for the theme layer, imported by every component under
// `src/components/`. The public entrypoint exports this barrel.

export 'computed.dart';
export 'control_styles.dart';
export 'surface_frame.dart';
export 'theme_data.dart' hide buildUiScopeTokens;
export 'theme_scope.dart';
export 'tokens.dart';

// Accent palette constants stay out of this internal barrel to avoid bare-name
// collisions. Consumers can import theme/fortal_colors.dart and palette.dart.
// The prefixed error palette is exported so applications can scope
// destructive content without a deep import.
export 'fortal_colors.dart' show uiError;
