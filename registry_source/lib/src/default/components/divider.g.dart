// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'divider.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's Divider recipe.
///
/// A `border` hairline, the same color and weight as every control outline. It
/// fills the axis it runs along; a shorter rule is a layout decision, made with
/// padding.
///
/// [orientation] is Flutter's [Axis] and is not named `variant`, so the
/// generator emits no named constructors for it.
class VanillaDivider extends StatelessWidget {
  const VanillaDivider({
    super.key,
    this.orientation = Axis.horizontal,
    this.style = const DividerStyler.create(),
  });

  final Axis orientation;

  final DividerStyler style;

  @override
  Widget build(BuildContext context) {
    return RemixDivider(
      key: this.key,
      style: vanillaDividerStyle(
        orientation: this.orientation,
        style: this.style,
      ),
    );
  }
}
