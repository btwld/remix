// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'separator.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// HeroUI recipe for [RemixDivider]: a 1px line that spans its container.
class UiSeparator extends StatelessWidget {
  const UiSeparator({
    super.key,
    this.variant = .defaultSeparator,
    this.orientation = Axis.horizontal,
    this.style = const DividerStyler.create(),
  });

  /// The `separator` color.
  const UiSeparator.defaultSeparator({
    super.key,
    this.orientation = Axis.horizontal,
    this.style = const DividerStyler.create(),
  }) : variant = UiSeparatorVariant.defaultSeparator;

  /// The fainter `separator-secondary` color.
  const UiSeparator.secondary({
    super.key,
    this.orientation = Axis.horizontal,
    this.style = const DividerStyler.create(),
  }) : variant = UiSeparatorVariant.secondary;

  /// The faintest `separator-tertiary` color.
  const UiSeparator.tertiary({
    super.key,
    this.orientation = Axis.horizontal,
    this.style = const DividerStyler.create(),
  }) : variant = UiSeparatorVariant.tertiary;

  final UiSeparatorVariant variant;

  final Axis orientation;

  final DividerStyler style;

  @override
  Widget build(BuildContext context) {
    return RemixDivider(
      key: this.key,
      style: uiSeparatorStyle(
        variant: this.variant,
        orientation: this.orientation,
        style: this.style,
      ),
    );
  }
}
