// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_list.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's DataList recipe.
///
/// Label/value pairs in `textSm`: the label in `mutedForeground` and the value
/// in `foreground`, so the eye lands on the answers. It has no size or variant;
/// override the spacings through [style] for a denser block.
///
/// ```dart
/// PlaygroundDataList(
///   items: const [
///     RemixDataListItem(label: 'Status', value: 'Active'),
///     RemixDataListItem(label: 'Plan', value: 'Pro'),
///   ],
/// )
/// ```
class PlaygroundDataList extends StatelessWidget {
  const PlaygroundDataList({
    super.key,
    this.style = const DataListStyler.create(),
    required this.items,
    this.orientation = Axis.horizontal,
    this.semanticLabel,
    this.excludeSemantics = false,
  });

  final DataListStyler style;

  final List<RemixDataListItem> items;

  final Axis orientation;

  final String? semanticLabel;

  final bool excludeSemantics;

  @override
  Widget build(BuildContext context) {
    return RemixDataList(
      key: this.key,
      style: playgroundDataListStyle(style: this.style),
      items: this.items,
      orientation: this.orientation,
      semanticLabel: this.semanticLabel,
      excludeSemantics: this.excludeSemantics,
    );
  }
}
