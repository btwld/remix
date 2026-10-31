// Internal entrypoint for the theme layer, imported by every component under
// `src/components/`. The public entrypoint exports this barrel.

export 'computed.dart';
export 'control_styles.dart';
export 'surface_frame.dart';
export 'theme_data.dart' hide buildFortalScopeTokens;
export 'theme_scope.dart';
export 'tokens.dart';

// Palette constants stay out of this internal barrel to avoid bare-name
// collisions. Consumers can import theme/fortal_colors.dart and palette.dart.
