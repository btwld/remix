import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:remix/remix.dart';

import 'preview_helper.dart';

@Preview(name: 'Checkbox States', size: Size(300, 200))
Widget previewCheckboxStates() {
  return createRemixPreview(
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RemixCheckbox(
          selected: false,
          onChanged: (value) {},
          label: 'Unchecked',
        ),
        const SizedBox(height: 12),
        RemixCheckbox(
          selected: true,
          onChanged: (value) {},
          label: 'Checked',
        ),
        const SizedBox(height: 12),
        RemixCheckbox(
          selected: false,
          enabled: false,
          onChanged: (value) {},
          label: 'Disabled',
        ),
      ],
    ),
  );
}

@Preview(name: 'Switch States', size: Size(300, 200))
Widget previewSwitchStates() {
  return createRemixPreview(
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RemixSwitch(
          selected: true,
          onChanged: (value) {},
        ),
        const SizedBox(height: 12),
        RemixSwitch(
          selected: false,
          onChanged: (value) {},
        ),
        const SizedBox(height: 12),
        RemixSwitch(
          selected: true,
          enabled: false,
          onChanged: (value) {},
        ),
        const SizedBox(height: 12),
        RemixSwitch(
          selected: false,
          enabled: false,
          onChanged: (value) {},
        ),
      ],
    ),
  );
}

@Preview(name: 'Radio Group', size: Size(300, 250))
Widget previewRadioGroup() {
  return createRemixPreview(
    RemixRadioGroup<String>(
      groupValue: 'option1',
      onChanged: (value) {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: RemixRadio<String>(
              value: 'option1',
              label: 'Selected Option',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: RemixRadio<String>(
              value: 'option2',
              label: 'Unselected Option',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: RemixRadio<String>(
              value: 'option3',
              label: 'Another Option',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: RemixRadio<String>(
              value: 'option4',
              enabled: false,
              label: 'Disabled Option',
            ),
          ),
        ],
      ),
    ),
  );
}

@Preview(name: 'Text Fields', size: Size(400, 350))
Widget previewTextFields() {
  return createRemixPreview(
    SizedBox(
      width: 350,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RemixTextField(
            hintText: 'Enter your name',
          ),
          const SizedBox(height: 16),
          RemixTextField(
            hintText: 'Enter your email',
            leading: const Icon(Icons.email),
          ),
          const SizedBox(height: 16),
          RemixTextField(
            hintText: 'Enter password',
            obscureText: true,
            trailing: const Icon(Icons.visibility),
          ),
          const SizedBox(height: 16),
          RemixTextField(
            hintText: 'This field is disabled',
            enabled: false,
          ),
        ],
      ),
    ),
  );
}

@Preview(name: 'Slider Examples', size: Size(350, 200))
Widget previewSliders() {
  return createRemixPreview(
    SizedBox(
      width: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Volume: 50%'),
          RemixSlider(
            value: 0.5,
            onChanged: (value) {},
          ),
          const SizedBox(height: 20),
          const Text('Brightness: 75%'),
          RemixSlider(
            value: 0.75,
            onChanged: (value) {},
          ),
          const SizedBox(height: 20),
          const Text('Disabled Slider'),
          RemixSlider(
            value: 0.3,
            enabled: false,
            onChanged: (value) {},
          ),
        ],
      ),
    ),
  );
}

@Preview(name: 'Select Dropdown', size: Size(350, 200))
Widget previewSelect() {
  return createRemixPreview(
    SizedBox(
      width: 300,
      child: RemixSelect<String>(
        selectedValue: 'option1',
        items: const [
          RemixSelectItem(value: 'option1', label: 'First Option'),
          RemixSelectItem(value: 'option2', label: 'Second Option'),
          RemixSelectItem(value: 'option3', label: 'Third Option'),
        ],
        onChanged: (value) {},
        child: const RemixSelectTrigger(label: 'First Option'),
      ),
    ),
  );
}
