import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import 'dashboard_demo_gallery_scaffold.dart';
import 'dashboard_demo_ui.dart';

class UiGalleryFormsPage extends StatefulWidget {
  const UiGalleryFormsPage({super.key});

  @override
  State<UiGalleryFormsPage> createState() => _UiGalleryFormsPageState();
}

class _UiGalleryFormsPageState extends State<UiGalleryFormsPage> {
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
    return UiGalleryPage(
      title: 'Forms & Inputs',
      intro: 'Production-ready fields and selection controls in every preset.',
      sections: [
        UiGallerySection(
          label: 'Text field',
          description:
              'All field variants and sizes with a leading icon and placeholder.',
          child: UiGalleryEnumMatrix(
            rows: UiTextFieldVariant.values,
            columns: UiTextFieldSize.values,
            cellWidth: 210,
            cellBuilder: (_, variant, size) => UiTextField(
              variant: variant,
              size: size,
              hintText: 'Type something…',
              leading: const StyledIcon(icon: RemixIcons.magnifyingGlass),
            ),
          ),
        ),
        UiGallerySection(
          label: 'Text area',
          description:
              'Multi-line input sharing the text field variants and sizes.',
          child: UiGalleryEnumMatrix(
            rows: UiTextAreaVariant.values,
            columns: UiTextAreaSize.values,
            cellWidth: 230,
            cellBuilder: (_, variant, size) => UiTextArea(
              variant: variant,
              size: size,
              hintText: 'Add a note…',
            ),
          ),
        ),
        UiGallerySection(
          label: 'Segmented control',
          description: 'Exclusive selection in surface and classic treatments.',
          child: UiGalleryEnumMatrix(
            rows: UiSegmentedControlVariant.values,
            columns: UiSegmentedControlSize.values,
            cellWidth: 250,
            cellBuilder: (_, variant, size) => UiSegmentedControl<String>(
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
        UiGallerySection(
          label: 'Select',
          description: 'Every visual variant across the three sizes.',
          child: UiGalleryEnumMatrix(
            rows: UiSelectVariant.values,
            columns: UiSelectSize.values,
            cellBuilder: (_, variant, size) => UiSelect<String>(
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
        UiGallerySection(
          label: 'Toggle group',
          description:
              'Single-selection groups in soft and surface treatments.',
          child: UiGalleryEnumMatrix(
            rows: UiToggleGroupVariant.values,
            columns: UiToggleGroupSize.values,
            cellWidth: 230,
            cellBuilder: (_, variant, size) => UiToggleGroup<String>(
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
        UiGallerySection(
          label: 'Checkbox',
          description: 'Classic, surface, and soft checkbox recipes.',
          child: UiGalleryEnumMatrix(
            rows: UiCheckboxVariant.values,
            columns: UiCheckboxSize.values,
            cellBuilder: (_, variant, size) => UiCheckbox(
              variant: variant,
              size: size,
              selected: _checked,
              semanticLabel: 'Example checkbox',
              onChanged: (value) => setState(() => _checked = value ?? false),
            ),
          ),
        ),
        UiGallerySection(
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
                  UiCheckboxGroupItem<String>(value: value, label: label),
              ],
            ),
          ),
        ),
        UiGallerySection(
          label: 'Radio',
          description: 'Radio selection shown across every variant and size.',
          child: UiGalleryEnumMatrix(
            rows: UiRadioVariant.values,
            columns: UiRadioSize.values,
            cellBuilder: (_, variant, size) => RemixRadioGroup<int>(
              groupValue: _radio,
              onChanged: (value) {
                if (value != null) setState(() => _radio = value);
              },
              child: UiRadio<int>(
                variant: variant,
                size: size,
                value: 1,
                semanticLabel: 'Option',
              ),
            ),
          ),
        ),
        UiGallerySection(
          label: 'Switch',
          description: 'Binary settings controls with all visual treatments.',
          child: UiGalleryEnumMatrix(
            rows: UiSwitchVariant.values,
            columns: UiSwitchSize.values,
            cellBuilder: (_, variant, size) => UiSwitch(
              variant: variant,
              size: size,
              selected: _switched,
              semanticLabel: 'Example switch',
              onChanged: (value) => setState(() => _switched = value),
            ),
          ),
        ),
        UiGallerySection(
          label: 'Slider',
          description: 'Discrete single-thumb sliders in every Ui recipe.',
          child: UiGalleryEnumMatrix(
            rows: UiSliderVariant.values,
            columns: UiSliderSize.values,
            cellWidth: 210,
            cellBuilder: (_, variant, size) => Box(
              style: BoxStyler().width(170),
              child: UiSlider(
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
        UiGallerySection(
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
                child: const UiTextField(
                  error: true,
                  label: 'Workspace slug',
                  hintText: 'remix',
                  helperText: 'That slug is already in use.',
                ),
              ),
              const UiCheckbox(
                selected: null,
                tristate: true,
                semanticLabel: 'Indeterminate checkbox',
              ),
              const UiCheckbox(selected: true, label: 'Labelled'),
              const UiSwitch(
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
