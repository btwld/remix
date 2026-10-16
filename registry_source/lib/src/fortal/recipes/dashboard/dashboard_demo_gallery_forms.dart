import 'package:flutter/widgets.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';
import 'package:remix/remix.dart';
import 'dashboard_demo_ui.dart';

import 'dashboard_demo_gallery_scaffold.dart';

class FortalGalleryFormsPage extends StatefulWidget {
  const FortalGalleryFormsPage({super.key});

  @override
  State<FortalGalleryFormsPage> createState() => _FortalGalleryFormsPageState();
}

class _FortalGalleryFormsPageState extends State<FortalGalleryFormsPage> {
  bool _checked = true;
  bool _switched = true;
  int _radio = 1;
  String _fruit = 'apple';
  String _alignment = 'left';
  String _density = 'comfortable';
  Set<String> _channels = {'email'};
  double _slider = 58;

  @override
  Widget build(BuildContext context) {
    return FortalGalleryPage(
      title: 'Forms & Inputs',
      intro: 'Production-ready fields and selection controls in every preset.',
      sections: [
        FortalGallerySection(
          label: 'Text field',
          description:
              'All field variants and sizes with a leading icon and placeholder.',
          child: FortalGalleryEnumMatrix(
            rows: FortalTextFieldVariant.values,
            columns: FortalTextFieldSize.values,
            cellWidth: 210,
            cellBuilder: (_, variant, size) => FortalTextField(
              variant: variant,
              size: size,
              hintText: 'Type something…',
              leading: const StyledIcon(icon: RemixIcons.magnifyingGlass),
            ),
          ),
        ),
        FortalGallerySection(
          label: 'Text area',
          description:
              'Multi-line input sharing the text field variants and sizes.',
          child: FortalGalleryEnumMatrix(
            rows: FortalTextAreaVariant.values,
            columns: FortalTextAreaSize.values,
            cellWidth: 230,
            cellBuilder: (_, variant, size) => FortalTextArea(
              variant: variant,
              size: size,
              hintText: 'Add a note…',
            ),
          ),
        ),
        FortalGallerySection(
          label: 'Segmented control',
          description: 'Exclusive selection in surface and classic treatments.',
          child: FortalGalleryEnumMatrix(
            rows: FortalSegmentedControlVariant.values,
            columns: FortalSegmentedControlSize.values,
            cellWidth: 250,
            cellBuilder: (_, variant, size) => FortalSegmentedControl<String>(
              variant: variant,
              size: size,
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
        FortalGallerySection(
          label: 'Select',
          description: 'Every visual variant across the three sizes.',
          child: FortalGalleryEnumMatrix(
            rows: FortalSelectVariant.values,
            columns: FortalSelectSize.values,
            cellBuilder: (_, variant, size) => FortalSelect<String>(
              key: ValueKey('select-${variant.name}-${size.name}'),
              variant: variant,
              size: size,
              trigger: const RemixSelectTrigger(placeholder: 'Fruit'),
              items: const [
                RemixSelectItem(value: 'apple', label: 'Apple'),
                RemixSelectItem(value: 'orange', label: 'Orange'),
                RemixSelectItem(value: 'pear', label: 'Pear'),
              ],
              selectedValue: _fruit,
              onChanged: (value) {
                if (value != null) setState(() => _fruit = value);
              },
            ),
          ),
        ),
        FortalGallerySection(
          label: 'Toggle group',
          description:
              'Single-selection groups in soft and surface treatments.',
          child: FortalGalleryEnumMatrix(
            rows: FortalToggleGroupVariant.values,
            columns: FortalToggleGroupSize.values,
            cellWidth: 230,
            cellBuilder: (_, variant, size) => FortalToggleGroup<String>(
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
        FortalGallerySection(
          label: 'Checkbox',
          description: 'Classic, surface, and soft checkbox recipes.',
          child: FortalGalleryEnumMatrix(
            rows: FortalCheckboxVariant.values,
            columns: FortalCheckboxSize.values,
            cellBuilder: (_, variant, size) => FortalCheckbox(
              variant: variant,
              size: size,
              selected: _checked,
              semanticLabel: 'Example checkbox',
              onChanged: (value) => setState(() => _checked = value ?? false),
            ),
          ),
        ),
        FortalGallerySection(
          label: 'Checkbox group',
          description:
              'Labelled options whose text shares the checkbox tap target.',
          child: RemixCheckboxGroup<String>(
            values: _channels,
            semanticLabel: 'Notification channels',
            onChanged: (values) => setState(() => _channels = values),
            child: WrapBox(
              style: WrapBoxStyler().spacing(18).runSpacing(6),
              children: [
                for (final (value, label) in const [
                  ('email', 'Email'),
                  ('sms', 'SMS'),
                  ('push', 'Push'),
                ])
                  FortalCheckboxGroupItem<String>(value: value, label: label),
              ],
            ),
          ),
        ),
        FortalGallerySection(
          label: 'Radio',
          description: 'Radio selection shown across every variant and size.',
          child: FortalGalleryEnumMatrix(
            rows: FortalRadioVariant.values,
            columns: FortalRadioSize.values,
            cellBuilder: (_, variant, size) => RemixRadioGroup<int>(
              groupValue: _radio,
              onChanged: (value) {
                if (value != null) setState(() => _radio = value);
              },
              child: FortalRadio<int>(
                variant: variant,
                size: size,
                value: 1,
                semanticLabel: 'Option',
              ),
            ),
          ),
        ),
        FortalGallerySection(
          label: 'Switch',
          description: 'Binary settings controls with all visual treatments.',
          child: FortalGalleryEnumMatrix(
            rows: FortalSwitchVariant.values,
            columns: FortalSwitchSize.values,
            cellBuilder: (_, variant, size) => FortalSwitch(
              variant: variant,
              size: size,
              selected: _switched,
              semanticLabel: 'Example switch',
              onChanged: (value) => setState(() => _switched = value),
            ),
          ),
        ),
        FortalGallerySection(
          label: 'Slider',
          description: 'Discrete single-thumb sliders in every Fortal recipe.',
          child: FortalGalleryEnumMatrix(
            rows: FortalSliderVariant.values,
            columns: FortalSliderSize.values,
            cellWidth: 210,
            cellBuilder: (_, variant, size) => Box(
              style: BoxStyler().width(170),
              child: FortalSlider(
                variant: variant,
                size: size,
                value: _slider,
                min: 0,
                max: 100,
                snapDivisions: 100,
                onChanged: (value) => setState(() => _slider = value),
              ),
            ),
          ),
        ),
        FortalGallerySection(
          label: 'States',
          description: 'Validation, disabled, and indeterminate states.',
          child: WrapBox(
            style: WrapBoxStyler()
                .spacing(16)
                .runSpacing(16)
                .crossAxisAlignment(.center),
            children: [
              Box(
                style: BoxStyler().width(240),
                child: const FortalTextField(
                  error: true,
                  label: 'Workspace slug',
                  hintText: 'remix',
                  helperText: 'That slug is already in use.',
                ),
              ),
              const FortalCheckbox(
                selected: null,
                tristate: true,
                semanticLabel: 'Indeterminate checkbox',
              ),
              const FortalCheckbox(selected: true, label: 'Labelled'),
              const FortalSwitch(
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
}
