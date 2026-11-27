import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// One appearance of a Fortal palette: twelve steps and their semantic roles.
///
/// Labels and marks are separate jobs. [indicator] and [track] are mark fills
/// (selected checkbox and radio, switch track, slider and progress range) and
/// carry [markContrast] or a derived ink. [solid] and [solidHover] are the
/// labelled fills of buttons, badges, avatars and highlighted menu items, and
/// [contrast] is the label colour on them.
///
/// A palette with [roles] pins the colours the theme would otherwise derive
/// from its scale. Fortal's built-in accents carry their foundation values
/// this way; a palette without them, and every palette under the theme's
/// high contrast switch, has those roles fitted to the contrast floors.
@immutable
class FortalColor {
  /// Creates a palette appearance.
  ///
  /// Without [solid] and [solidHover], labelled fills are scale steps 9 and
  /// 10, so palettes written before the split keep pairing [contrast] with
  /// those steps. A [solid] without [solidHover] also serves as its own hover,
  /// keeping the label pairing intact; supply both for a visible hover step.
  const FortalColor(
    this.scale,
    this.surface,
    this.indicator,
    this.track,
    this.contrast, {
    Color? solid,
    Color? solidHover,
    this.markContrast,
    Color? markHover,
    this.roles,
  }) : _solid = solid,
       _solidHover = solidHover,
       _markHover = markHover;

  final FortalColorScale scale;
  final Color surface;
  final Color indicator;
  final Color track;

  /// Label colour on [solid] and [solidHover].
  final Color contrast;

  /// Ink of checks and radio dots on [indicator] and [markHover]. A palette
  /// with [roles] uses it as given; otherwise it is used where it keeps 3:1.
  final Color? markContrast;

  /// Roles pinned by the palette instead of derived from its scale.
  final FortalColorRoles? roles;

  final Color? _solid;
  final Color? _solidHover;
  final Color? _markHover;

  /// Hovered or pressed mark/track fill; source step 10 unless supplied.
  Color get markHover => _markHover ?? scale.step(10);

  /// Labelled solid fill; scale step 9 unless supplied.
  Color get solid => _solid ?? scale.step(9);

  /// Hovered labelled solid fill; [solid] when only that was supplied,
  /// otherwise scale step 10.
  Color get solidHover => _solidHover ?? _solid ?? scale.step(10);
}

/// Colours a [FortalColor] pins instead of leaving the theme to derive them.
@immutable
class FortalColorRoles {
  const FortalColorRoles({
    required this.content,
    required this.contentAlpha,
    required this.focus,
    required this.thumbRing,
    required this.range,
    required this.thumb,
    required this.swatchContrast,
  });

  /// Accent text on soft fills and neutral surfaces.
  final Color content;

  /// Translucent form of [content].
  final Color contentAlpha;

  /// The focus outline.
  final Color focus;

  /// Outline of switch and slider thumbs; transparent for a shadowed thumb.
  final Color thumbRing;

  /// The slider's filled range.
  final Color range;

  /// The thumb of a selected switch.
  final Color thumb;

  /// Ink on a swatch filled with scale step 9.
  final Color swatchContrast;
}

/// A palette's paired light and dark appearances, including custom brands.
@immutable
class FortalColorTheme {
  const FortalColorTheme(this.light, this.dark);

  final FortalColor light;
  final FortalColor dark;
}

/// Roles of one appearance that follow neither the accent nor a custom
/// palette: surfaces, the off state of controls, and the status tones.
@immutable
class FortalFunctionalColors {
  const FortalFunctionalColors({
    required this.background,
    required this.surface,
    required this.panelSolid,
    required this.panelTranslucent,
    required this.overlay,
    required this.controlTrack,
    required this.controlTrackHover,
    required this.controlThumb,
    required this.success,
    required this.warning,
    required this.info,
    required this.toneTeal,
    required this.toneSky,
    required this.toneOrchid,
    required this.toneViolet,
    required this.toneRose,
    required this.toneAmber,
    required this.toneGreen,
  });

  final Color background;
  final Color surface;
  final Color panelSolid;
  final Color panelTranslucent;
  final Color overlay;
  final Color controlTrack;
  final Color controlTrackHover;
  final Color controlThumb;
  final Color success;
  final Color warning;
  final Color info;
  final Color toneTeal;
  final Color toneSky;
  final Color toneOrchid;
  final Color toneViolet;
  final Color toneRose;
  final Color toneAmber;
  final Color toneGreen;
}

/// Fixed-role, one-based color steps. Invalid steps are programming errors.
@immutable
class FortalColorScale {
  const FortalColorScale(this.solid, this.alpha);

  final ColorSwatch<int> solid;
  final ColorSwatch<int> alpha;

  Color step(int step) => _at(solid, step);
  Color alphaStep(int step) => _at(alpha, step);

  Color _at(ColorSwatch<int> swatch, int step) {
    if (step < 1 || step > 12) {
      throw RangeError.range(step, 1, 12, 'step');
    }
    return swatch[step]!;
  }
}
