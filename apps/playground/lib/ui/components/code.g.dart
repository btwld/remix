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
/// its paragraph's style down, so the recipe sets every value itself. The span
/// scales the whole chip, so disable text scaling on the inline chip only:
///
/// ```dart
/// Text.rich(
///   TextSpan(
///     text: 'Install ',
///     children: [
///       WidgetSpan(
///         alignment: PlaceholderAlignment.middle,
///         child: PlaygroundCode(
///           'remix_ui_fonts',
///           style: TextStyler().textScaler(TextScaler.noScaling),
///         ),
///       ),
///       TextSpan(text: ' first.'),
///     ],
///   ),
/// )
/// ```
///
/// Assistive technology reads the code as plain text: Flutter has no code
/// role.
class PlaygroundCode extends StatelessWidget {
  const PlaygroundCode(
    this.text, {
    super.key,
    this.style = const TextStyler.create(),
  });

  final TextStyler style;

  final String text;

  @override
  Widget build(BuildContext context) {
    return playgroundCodeStyle(
      style: this.style,
    ).call(this.text, key: this.key);
  }
}
