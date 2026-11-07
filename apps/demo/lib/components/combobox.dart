import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Combobox Component', type: RemixCombobox)
Widget buildComboboxUseCase(BuildContext context) => _ComboboxExample(
  enabled: context.knobs.boolean(label: 'Enabled', initialValue: true),
);

class _ComboboxExample extends StatefulWidget {
  const _ComboboxExample({required this.enabled});
  final bool enabled;

  @override
  State<_ComboboxExample> createState() => _ComboboxExampleState();
}

class _ComboboxExampleState extends State<_ComboboxExample> {
  String? _selected;
  static const _cities = [
    'San Francisco, California · United States',
    'San Sebastián, Basque Country · Spain',
    'San Miguel de Allende, Guanajuato · Mexico',
    'Santa Cruz de Tenerife, Canary Islands · Spain',
    'Santiago de Compostela, Galicia · Spain',
    'Santo Domingo, Distrito Nacional · Dominican Republic',
    'São Paulo, São Paulo · Brazil',
  ];

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RemixCombobox<String>(
              label: 'Destination',
              hintText: 'Try “san”',
              enabled: widget.enabled,
              optionsBuilder: (query) => query.text.isEmpty
                  ? const []
                  : _cities.where(
                      (city) =>
                          city.toLowerCase().contains(query.text.toLowerCase()),
                    ),
              onSelected: (city) => setState(() => _selected = city),
              style: ComboboxStyler()
                  .field(
                    TextFieldStyler()
                        .padding(.all(12))
                        .constraints(.minHeight(48))
                        .borderRadius(.circular(8))
                        .color(const Color(0xFFFFFFFF))
                        .text(TextStyler().color(const Color(0xFF202020)))
                        .label(TextStyler().color(const Color(0xFF202020)))
                        .border(.all(.color(const Color(0xFF999999)).width(1)))
                        .onFocused(
                          .border(
                            .all(.color(const Color(0xFF256A50)).width(2)),
                          ),
                        ),
                  )
                  .panel(
                    BoxStyler()
                        .color(const Color(0xFFFFFFFF))
                        .padding(.all(4))
                        .border(.all(.color(const Color(0xFF999999)).width(1))),
                  )
                  .option(
                    BoxStyler()
                        .padding(.horizontal(12))
                        .onHovered(.color(const Color(0xFFF0F5F2)))
                        .onFocused(.color(const Color(0xFFDCEEE3))),
                  )
                  .optionLabel(
                    TextStyler().color(const Color(0xFF202020)).fontSize(16),
                  ),
            ),
            const SizedBox(height: 20),
            Semantics(
              liveRegion: true,
              child: Text(
                _selected == null
                    ? 'Choose a suggested destination.'
                    : 'Selected: $_selected',
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
