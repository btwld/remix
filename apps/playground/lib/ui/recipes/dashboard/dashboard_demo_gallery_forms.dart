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

class PlaygroundGalleryFormsPage extends StatefulWidget {
  const PlaygroundGalleryFormsPage({super.key});

  @override
  State<PlaygroundGalleryFormsPage> createState() =>
      _PlaygroundGalleryFormsPageState();
}

class _PlaygroundGalleryFormsPageState
    extends State<PlaygroundGalleryFormsPage> {
  bool _checked = true;
  bool _switched = true;
  int _radio = 1;
  String _alignment = 'left';
  String _density = 'comfortable';
  Set<String> _channels = {'email'};
  double _slider = 58;

  @override
  Widget build(BuildContext context) => PlaygroundGalleryPage(
    title: 'Forms & Inputs',
    intro: 'Production-ready fields and selection controls in every preset.',
    sections: [
      PlaygroundGallerySection(
        label: 'Text field',
        description: 'The native field with a leading icon and placeholder.',
        child: Box(
          style: BoxStyler().width(300),
          child: const PlaygroundTextField(
            hintText: 'Type something…',
            leading: Icon(
              RemixIcons.magnifyingGlass,
              size: PlaygroundTokens.icon,
            ),
          ),
        ),
      ),
      PlaygroundGallerySection(
        label: 'Text area',
        description: 'Multi-line input sharing the text field treatment.',
        child: Box(
          style: BoxStyler().width(360),
          child: const PlaygroundTextArea(hintText: 'Add a note…'),
        ),
      ),
      PlaygroundGallerySection(
        label: 'Segmented control',
        description: 'Exclusive selection using the native treatment.',
        child: Align(
          alignment: Alignment.centerLeft,
          child: PlaygroundSegmentedControl<String>(
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
      PlaygroundGallerySection(
        label: 'Select',
        description: 'A keyboard-accessible native select.',
        child: Align(
          alignment: Alignment.centerLeft,
          child: Box(
            style: BoxStyler().width(220),
            child: PlaygroundSelect<String>(
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
      PlaygroundGallerySection(
        label: 'Toggle group',
        description: 'Every native group variant and size.',
        child: PlaygroundGalleryEnumMatrix(
          rows: PlaygroundToggleGroupVariant.values,
          columns: PlaygroundToggleGroupSize.values,
          cellWidth: 230,
          cellBuilder: (_, variant, size) => PlaygroundToggleGroup<String>(
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
      PlaygroundGallerySection(
        label: 'Checkbox',
        description: 'The native tri-state checkbox recipe.',
        child: Align(
          alignment: Alignment.centerLeft,
          child: PlaygroundCheckbox(
            selected: _checked,
            label: 'Example checkbox',
            onChanged: (value) => setState(() => _checked = value ?? false),
          ),
        ),
      ),
      PlaygroundGallerySection(
        label: 'Checkbox group',
        description: 'Labelled options share the checkbox tap target.',
        child: RemixCheckboxGroup<String>(
          values: _channels,
          semanticLabel: 'Notification channels',
          onChanged: (values) => setState(() => _channels = values),
          child: WrapBox(
            style: WrapBoxStyler()
                .spacing(PlaygroundTokens.s4)
                .runSpacing(PlaygroundTokens.s1_5),
            children: [
              for (final (value, label) in const [
                ('email', 'Email'),
                ('sms', 'SMS'),
                ('push', 'Push'),
              ])
                PlaygroundCheckboxGroupItem<String>(value: value, label: label),
            ],
          ),
        ),
      ),
      PlaygroundGallerySection(
        label: 'Radio',
        description: 'Exclusive radio selection.',
        child: RemixRadioGroup<int>(
          groupValue: _radio,
          onChanged: (value) {
            if (value != null) setState(() => _radio = value);
          },
          child: WrapBox(
            style: WrapBoxStyler().spacing(PlaygroundTokens.s5),
            children: const [
              PlaygroundRadio<int>(value: 1, semanticLabel: 'First option'),
              PlaygroundRadio<int>(value: 2, semanticLabel: 'Second option'),
            ],
          ),
        ),
      ),
      PlaygroundGallerySection(
        label: 'Switch',
        description: 'The native binary setting control.',
        child: Align(
          alignment: Alignment.centerLeft,
          child: PlaygroundSwitch(
            selected: _switched,
            semanticLabel: 'Example switch',
            onChanged: (value) => setState(() => _switched = value),
          ),
        ),
      ),
      PlaygroundGallerySection(
        label: 'Slider',
        description: 'A discrete single-thumb slider.',
        child: Box(
          style: BoxStyler().width(300),
          child: PlaygroundSlider(
            value: _slider,
            min: 0,
            max: 100,
            snapDivisions: 100,
            onChanged: (value) => setState(() => _slider = value),
          ),
        ),
      ),
      PlaygroundGallerySection(
        label: 'States',
        description: 'Validation, disabled, and indeterminate states.',
        child: WrapBox(
          style: WrapBoxStyler()
              .spacing(PlaygroundTokens.s4)
              .runSpacing(PlaygroundTokens.s4)
              .crossAxisAlignment(.center),
          children: [
            Box(
              style: BoxStyler().width(240),
              child: const PlaygroundTextField(
                error: true,
                label: 'Workspace slug',
                hintText: 'remix',
                helperText: 'That slug is already in use.',
              ),
            ),
            const PlaygroundCheckbox(
              selected: null,
              tristate: true,
              semanticLabel: 'Indeterminate checkbox',
            ),
            const PlaygroundCheckbox(selected: true, label: 'Labelled'),
            const PlaygroundSwitch(
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
