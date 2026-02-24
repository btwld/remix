import 'package:flutter/material.dart';

@visibleForTesting
Brightness resolveRemixBrightness(
  BuildContext context, {
  Brightness? brightnessOverride,
}) {
  final theme = Theme.of(context);
  final maybeMediaQuery = MediaQuery.maybeOf(context);

  return resolveRemixBrightnessValues(
    brightnessOverride: brightnessOverride,
    mediaQuery: maybeMediaQuery,
    themeBrightness: theme.brightness,
  );
}

@visibleForTesting
Brightness resolveRemixBrightnessValues({
  Brightness? brightnessOverride,
  MediaQueryData? mediaQuery,
  Brightness? themeBrightness,
}) {
  if (brightnessOverride != null) {
    return brightnessOverride;
  }

  if (mediaQuery != null) {
    return mediaQuery.platformBrightness;
  }

  if (themeBrightness != null) {
    return themeBrightness;
  }

  return Brightness.light;
}
