part of 'spinner.dart';

/// Style builder for [RemixSpinner].
///
/// Use this class to customize spinner size, stroke widths, colors, duration,
/// and Mix variants.
extension RemixSpinnerStylerRemixHelpers on RemixSpinnerStyler {
  RemixSpinner call({Key? key}) {
    return RemixSpinner(key: key, style: this);
  }
}
