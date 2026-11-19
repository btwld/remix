// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'separator.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// Deui recipe for [RemixDivider]: a 1px line that spans its container.
class DeuiSeparator extends StatelessWidget {
  const DeuiSeparator({
    super.key,
    this.variant = .defaultSeparator,
    this.orientation = Axis.horizontal,
    this.style = const DividerStyler.create(),
  });

  /// The `separator` color.
  const DeuiSeparator.defaultSeparator({
    super.key,
    this.orientation = Axis.horizontal,
    this.style = const DividerStyler.create(),
  }) : variant = DeuiSeparatorVariant.defaultSeparator;

  /// The `separator-secondary` color.
  const DeuiSeparator.secondary({
    super.key,
    this.orientation = Axis.horizontal,
    this.style = const DividerStyler.create(),
  }) : variant = DeuiSeparatorVariant.secondary;

  /// The `separator-tertiary` color.
  const DeuiSeparator.tertiary({
    super.key,
    this.orientation = Axis.horizontal,
    this.style = const DividerStyler.create(),
  }) : variant = DeuiSeparatorVariant.tertiary;

  final DeuiSeparatorVariant variant;

  final Axis orientation;

  final DividerStyler style;

  @override
  Widget build(BuildContext context) {
    return RemixDivider(
      key: this.key,
      style: deuiSeparatorStyle(
        variant: this.variant,
        orientation: this.orientation,
        style: this.style,
      ),
    );
  }
}
