part of 'divider.dart';

/// Style configuration for a [RemixDivider] container.
extension RemixDividerStylerRemixHelpers on RemixDividerStyler {
  /// Sets divider thickness (height for horizontal, width for vertical)
  RemixDividerStyler thickness(double value) {
    return merge(
      RemixDividerStyler(
        container: BoxStyler(
          constraints: BoxConstraintsMix(minHeight: value, maxHeight: value),
        ),
      ),
    );
  }

  /// Creates a [RemixDivider] widget with this style applied.
  RemixDivider call({Key? key}) {
    return RemixDivider(key: key, style: this);
  }
}
