// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'code.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's Code recipe: a short run of inline code.
///
/// `textMono`, 14px on a 20px line, at semibold weight in `foreground`, on a
/// `muted` chip with 4px beside the text, 2px above and below, and corners of
/// at most 4px. In running text it sits in a `WidgetSpan`, which does not pass
/// its paragraph's style down, so the recipe sets every value itself:
///
/// ```dart
/// Text.rich(
///   TextSpan(
///     text: 'Install ',
///     children: [
///       WidgetSpan(
///         alignment: PlaceholderAlignment.middle,
///         child: VanillaCode('remix_ui_fonts'),
///       ),
///       TextSpan(text: ' first.'),
///     ],
///   ),
/// )
/// ```
///
/// Assistive technology reads the code as plain text: Flutter has no code
/// role.
class VanillaCode extends StatelessWidget {
  const VanillaCode(
    this.text, {
    super.key,
    this.style = const TextStyler.create(),
  });

  final TextStyler style;

  final String text;

  @override
  Widget build(BuildContext context) {
    return vanillaCodeStyle(style: this.style).call(this.text, key: this.key);
  }
}
