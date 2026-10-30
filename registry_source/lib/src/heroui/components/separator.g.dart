// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'separator.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// HeroUI recipe for [RemixDivider]: a 1px line that spans its container.
class HeroUiSeparator extends StatelessWidget {
  const HeroUiSeparator({
    super.key,
    this.variant = .defaultSeparator,
    this.orientation = Axis.horizontal,
    this.style = const DividerStyler.create(),
  });

  const HeroUiSeparator.defaultSeparator({
    super.key,
    this.orientation = Axis.horizontal,
    this.style = const DividerStyler.create(),
  }) : variant = HeroUiSeparatorVariant.defaultSeparator;

  const HeroUiSeparator.secondary({
    super.key,
    this.orientation = Axis.horizontal,
    this.style = const DividerStyler.create(),
  }) : variant = HeroUiSeparatorVariant.secondary;

  const HeroUiSeparator.tertiary({
    super.key,
    this.orientation = Axis.horizontal,
    this.style = const DividerStyler.create(),
  }) : variant = HeroUiSeparatorVariant.tertiary;

  final HeroUiSeparatorVariant variant;

  final Axis orientation;

  final DividerStyler style;

  @override
  Widget build(BuildContext context) {
    return RemixDivider(
      key: this.key,
      style: heroUiSeparatorStyle(
        variant: this.variant,
        orientation: this.orientation,
        style: this.style,
      ),
    );
  }
}
