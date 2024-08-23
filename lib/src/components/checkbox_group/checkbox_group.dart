// import 'package:flutter/material.dart';
// import 'package:mix/mix.dart';
// import '../checkbox/checkbox.dart';

// class RxCheckboxGroup extends StatefulWidget {
//   const RxCheckboxGroup({
//     super.key,
//     required this.items,
//     this.defaultValue = const [],
//     this.onValueChange,
//     this.size = CheckboxSize.medium,
//     this.variant = CheckboxVariant.soft,
//   });

//   final List<RxCheckboxItem> items;
//   final List<String> defaultValue;
//   final ValueChanged<List<String>>? onValueChange;
//   final CheckboxSize size;
//   final CheckboxVariant variant;

//   @override
//   _RxCheckboxGroupState createState() => _RxCheckboxGroupState();
// }

// class _RxCheckboxGroupState extends State<RxCheckboxGroup> {
//   late List<String> _selectedValues;

//   @override
//   void initState() {
//     super.initState();
//     _selectedValues = List<String>.of(widget.defaultValue);
//   }

//   void _handleValueChange(String value, bool isSelected) {
//     setState(() {
//       if (isSelected) {
//         _selectedValues.add(value);
//       } else {
//         _selectedValues.remove(value);
//       }
//     });

//     widget.onValueChange?.call(_selectedValues);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: widget.items.map((item) {
//         final isSelected = _selectedValues.contains(item.value);

//         return RxCheckbox(
//           value: isSelected,
//           onChanged: (isSelected) => _handleValueChange(item.value, isSelected),
//           style: item.style,
//           size: widget.size,
//           variant: widget.variant,
//         );
//       }).toList(),
//     );
//   }
// }

// class RxCheckboxItem {
//   final String value;
//   final Style? style;
//   const RxCheckboxItem({required this.value, this.style});
// }
