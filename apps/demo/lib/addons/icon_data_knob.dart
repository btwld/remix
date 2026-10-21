import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

enum IconDataEnum { none, home, settings, favorite, add, delete }

class IconDataKnob extends Knob<IconData?> {
  IconDataKnob({required super.label, super.initialValue});

  @override
  List<Field> get fields => [
    ObjectDropdownField<IconDataEnum>(
      name: label,
      initialValue: _enumFromIcon(initialValue),
      labelBuilder: (value) => value.name,
      values: IconDataEnum.values,
    ),
  ];

  @override
  IconData? valueFromQueryGroup(Map<String, String> group) {
    final iconDataString = group[label];
    if (iconDataString == null) return initialValue;
    final iconDataEnum = IconDataEnum.values.firstWhere(
      (e) => e.toString() == 'IconDataEnum.$iconDataString',
      orElse: () => IconDataEnum.home,
    );
    return _iconDataFromEnum(iconDataEnum);
  }

  IconData? _iconDataFromEnum(IconDataEnum iconDataEnum) {
    return switch (iconDataEnum) {
      IconDataEnum.home => Icons.home,
      IconDataEnum.settings => Icons.settings,
      IconDataEnum.favorite => Icons.favorite,
      IconDataEnum.add => Icons.add,
      IconDataEnum.delete => Icons.delete,
      IconDataEnum.none => null,
    };
  }
}

IconDataEnum _enumFromIcon(IconData? icon) {
  if (icon == Icons.home) return IconDataEnum.home;
  if (icon == Icons.settings) return IconDataEnum.settings;
  if (icon == Icons.favorite) return IconDataEnum.favorite;
  if (icon == Icons.add) return IconDataEnum.add;
  if (icon == Icons.delete) return IconDataEnum.delete;
  return IconDataEnum.none;
}

extension IconDataKnobBuilder on KnobsBuilder {
  IconData? iconData({required String label, IconData? initialValue}) =>
      onKnobAdded(IconDataKnob(label: label, initialValue: initialValue));
}
