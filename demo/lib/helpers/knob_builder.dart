import 'package:widgetbook/widgetbook.dart';

extension KnobsBuilderX on KnobsBuilder {
  // Note: Variant methods commented out as they are incompatible with Mix 2.0
  // Mix 2.0 has redesigned the Variant API - Variant is now abstract and 
  // doesn't have a 'name' property or string constructor.
  // These methods would need to be redesigned if variant support is needed.
  
  // Variant variant(List<Variant> variants) => list<Variant>(
  //       label: 'Variants',
  //       options: [const Variant('no Variant'), ...variants],
  //       labelBuilder: (value) => value.name.split('.').last,
  //     );

  // Variant variantRaw({
  //   required String label,
  //   required List<Variant> variants,
  //   required Variant initialOption,
  // }) =>
  //     list<Variant>(
  //       label: label,
  //       options: variants,
  //       initialOption: initialOption,
  //       labelBuilder: (value) => value.name.split('.').last,
  //     );
}
