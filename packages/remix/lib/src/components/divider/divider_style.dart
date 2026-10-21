part of 'divider.dart';

/// Style configuration for a [RemixDivider] container.
extension RemixDividerStylerRemixHelpers on DividerStyler {
  /// Sets the horizontal rule's height.
  DividerStyler thickness(double value) {
    return merge(
      DividerStyler(
        container: BoxStyler(
          constraints: BoxConstraintsMix(minHeight: value, maxHeight: value),
        ),
      ),
    );
  }
}
