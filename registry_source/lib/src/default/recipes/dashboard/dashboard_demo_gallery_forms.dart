import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../components/checkbox.dart';
import '../../components/radio.dart';
import '../../components/segmented_control.dart';
import '../../components/select.dart';
import '../../components/slider.dart';
import '../../components/switch.dart';
import '../../components/textfield.dart';
import '../../components/toggle_group.dart';
import '../../theme/tokens.dart';
import 'dashboard_demo_gallery_scaffold.dart';

class VanillaGalleryFormsPage extends StatefulWidget {
  const VanillaGalleryFormsPage({super.key});

  @override
  State<VanillaGalleryFormsPage> createState() =>
      _VanillaGalleryFormsPageState();
}

class _VanillaGalleryFormsPageState extends State<VanillaGalleryFormsPage> {
  bool _checked = true;
  bool _switched = true;
  int _radio = 1;
  String _alignment = 'left';
  String _density = 'comfortable';
  Set<String> _channels = {'email'};
  double _slider = 58;

  @override
  Widget build(BuildContext context) => VanillaGalleryPage(
    title: 'Forms & Inputs',
    intro: 'Production-ready fields and selection controls in every preset.',
    sections: [
      VanillaGallerySection(
        label: 'Text field',
        description: 'The native field with a leading icon and placeholder.',
        child: Box(
          style: BoxStyler().width(300),
          child: const VanillaTextField(
            hintText: 'Type something…',
            leading: Icon(RemixIcons.magnifyingGlass, size: VanillaTokens.icon),
          ),
        ),
      ),
      VanillaGallerySection(
        label: 'Text area',
        description: 'Multi-line input sharing the text field treatment.',
        child: Box(
          style: BoxStyler().width(360),
          child: const VanillaTextArea(hintText: 'Add a note…'),
        ),
      ),
      VanillaGallerySection(
        label: 'Segmented control',
        description: 'Exclusive selection using the native treatment.',
        child: Align(
          alignment: Alignment.centerLeft,
          child: VanillaSegmentedControl<String>(
            selectedValue: _density,
            semanticLabel: 'Row density',
            items: const [
              RemixSegmentedControlItem(value: 'compact', label: 'Compact'),
              RemixSegmentedControlItem(value: 'comfortable', label: 'Cozy'),
            ],
            onChanged: (value) => setState(() => _density = value),
          ),
        ),
      ),
      VanillaGallerySection(
        label: 'Select',
        description: 'A keyboard-accessible native select.',
        child: Align(
          alignment: Alignment.centerLeft,
          child: Box(
            style: BoxStyler().width(220),
            child: VanillaSelect<String>(
              trigger: const RemixSelectTrigger(placeholder: 'Fruit'),
              items: const [
                RemixSelectItem(value: 'apple', label: 'Apple'),
                RemixSelectItem(value: 'orange', label: 'Orange'),
                RemixSelectItem(value: 'pear', label: 'Pear'),
              ],
              selectedValue: 'apple',
              onChanged: (_) {},
            ),
          ),
        ),
      ),
      VanillaGallerySection(
        label: 'Toggle group',
        description: 'Every native group variant and size.',
        child: VanillaGalleryEnumMatrix(
          rows: VanillaToggleGroupVariant.values,
          columns: VanillaToggleGroupSize.values,
          cellWidth: 230,
          cellBuilder: (_, variant, size) => VanillaToggleGroup<String>(
            variant: variant,
            size: size,
            selectedValue: _alignment,
            semanticLabel: 'Text alignment',
            items: const [
              RemixToggleGroupItem(
                value: 'left',
                icon: RemixIcons.alignLeft,
                semanticLabel: 'Left',
              ),
              RemixToggleGroupItem(
                value: 'center',
                icon: RemixIcons.alignCenterHorizontally,
                semanticLabel: 'Center',
              ),
              RemixToggleGroupItem(
                value: 'right',
                icon: RemixIcons.alignRight,
                semanticLabel: 'Right',
              ),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _alignment = value);
            },
          ),
        ),
      ),
      VanillaGallerySection(
        label: 'Checkbox',
        description: 'The native tri-state checkbox recipe.',
        child: Align(
          alignment: Alignment.centerLeft,
          child: VanillaCheckbox(
            selected: _checked,
            label: 'Example checkbox',
            onChanged: (value) => setState(() => _checked = value ?? false),
          ),
        ),
      ),
      VanillaGallerySection(
        label: 'Checkbox group',
        description: 'Labelled options share the checkbox tap target.',
        child: RemixCheckboxGroup<String>(
          values: _channels,
          semanticLabel: 'Notification channels',
          onChanged: (values) => setState(() => _channels = values),
          child: WrapBox(
            style: WrapBoxStyler()
                .spacing(VanillaTokens.s4)
                .runSpacing(VanillaTokens.s1_5),
            children: [
              for (final (value, label) in const [
                ('email', 'Email'),
                ('sms', 'SMS'),
                ('push', 'Push'),
              ])
                VanillaCheckboxGroupItem<String>(value: value, label: label),
            ],
          ),
        ),
      ),
      VanillaGallerySection(
        label: 'Radio',
        description: 'Exclusive radio selection.',
        child: RemixRadioGroup<int>(
          groupValue: _radio,
          onChanged: (value) {
            if (value != null) setState(() => _radio = value);
          },
          child: WrapBox(
            style: WrapBoxStyler().spacing(VanillaTokens.s5),
            children: const [
              VanillaRadio<int>(value: 1, semanticLabel: 'First option'),
              VanillaRadio<int>(value: 2, semanticLabel: 'Second option'),
            ],
          ),
        ),
      ),
      VanillaGallerySection(
        label: 'Switch',
        description: 'The native binary setting control.',
        child: Align(
          alignment: Alignment.centerLeft,
          child: VanillaSwitch(
            selected: _switched,
            semanticLabel: 'Example switch',
            onChanged: (value) => setState(() => _switched = value),
          ),
        ),
      ),
      VanillaGallerySection(
        label: 'Slider',
        description: 'A discrete single-thumb slider.',
        child: Box(
          style: BoxStyler().width(300),
          child: VanillaSlider(
            value: _slider,
            min: 0,
            max: 100,
            snapDivisions: 100,
            onChanged: (value) => setState(() => _slider = value),
          ),
        ),
      ),
      VanillaGallerySection(
        label: 'States',
        description: 'Validation, disabled, and indeterminate states.',
        child: WrapBox(
          style: WrapBoxStyler()
              .spacing(VanillaTokens.s4)
              .runSpacing(VanillaTokens.s4)
              .crossAxisAlignment(.center),
          children: [
            Box(
              style: BoxStyler().width(240),
              child: const VanillaTextField(
                error: true,
                label: 'Workspace slug',
                hintText: 'remix',
                helperText: 'That slug is already in use.',
              ),
            ),
            const VanillaCheckbox(
              selected: null,
              tristate: true,
              semanticLabel: 'Indeterminate checkbox',
            ),
            const VanillaCheckbox(selected: true, label: 'Labelled'),
            const VanillaSwitch(
              selected: false,
              enabled: false,
              semanticLabel: 'Disabled switch',
            ),
          ],
        ),
      ),
    ],
  );
}
