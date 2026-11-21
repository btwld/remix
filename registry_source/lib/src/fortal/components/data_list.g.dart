// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_list.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Fortal DataList recipe: gray labels beside values in gray 12.
///
/// [highContrast] moves the labels to gray 12.
class FortalDataList extends StatelessWidget {
  const FortalDataList({
    super.key,
    this.size = .size2,
    this.highContrast = false,
    this.style = const DataListStyler.create(),
    required this.items,
    this.orientation = Axis.horizontal,
    this.semanticLabel,
    this.excludeSemantics = false,
  });

  final FortalDataListSize size;

  final bool highContrast;

  final DataListStyler style;

  final List<RemixDataListItem> items;

  final Axis orientation;

  final String? semanticLabel;

  final bool excludeSemantics;

  @override
  Widget build(BuildContext _) {
    return RemixDataList(
      style: fortalDataListStyle(
        size: size,
        highContrast: highContrast,
        style: style,
      ),
      items: items,
      orientation: orientation,
      semanticLabel: semanticLabel,
      excludeSemantics: excludeSemantics,
    );
  }
}
