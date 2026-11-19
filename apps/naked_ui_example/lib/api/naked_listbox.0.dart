import 'package:flutter/widgets.dart';
import 'package:naked_ui/naked_ui.dart';

class ReviewerPickerExample extends StatefulWidget {
  const ReviewerPickerExample({super.key});

  @override
  State<ReviewerPickerExample> createState() => _ReviewerPickerExampleState();
}

class _ReviewerPickerExampleState extends State<ReviewerPickerExample> {
  Set<String> _reviewers = {'ada'};

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: NakedListbox<String>.multiple(
        semanticLabel: 'Project reviewers',
        selectedValues: _reviewers,
        onChanged: (values) => setState(() => _reviewers = values),
        options: [
          _option('ada', 'Ada'),
          _option('leo', 'Leo'),
          _option('maya', 'Maya (unavailable)', enabled: false),
        ],
      ),
    );
  }

  NakedListboxOption<String> _option(
    String id,
    String name, {
    bool enabled = true,
  }) {
    return NakedListboxOption(
      value: id,
      semanticLabel: name,
      enabled: enabled,
      child: Text(name),
      builder: (context, state, child) => DecoratedBox(
        decoration: BoxDecoration(
          color: state.isSelected ? const Color(0xFFDCEBFA) : null,
          border: Border.all(
            color: state.isFocused
                ? const Color(0xFF0059B3)
                : const Color(0x00000000),
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: DefaultTextStyle.merge(
            style: TextStyle(
              color: state.isSelected ? const Color(0xFF15283D) : null,
              fontWeight: state.isSelected ? FontWeight.bold : null,
            ),
            child: child!,
          ),
        ),
      ),
    );
  }
}
