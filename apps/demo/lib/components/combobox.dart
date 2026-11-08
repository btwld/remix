import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../ui/ui.dart';

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
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_clearStaleSelection);
  }

  void _clearStaleSelection() {
    if (_selected != null && _controller.text != _selected) {
      setState(() => _selected = null);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

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
            Semantics(
              liveRegion: true,
              child: Text(
                _selected == null
                    ? 'Choose a suggested destination.'
                    : 'Selected: $_selected',
                style: TextStyle(color: FortalTokens.gray11.resolve(context)),
              ),
            ),
            const SizedBox(height: 12),
            ScrollConfiguration(
              behavior: const _SuggestionScrollBehavior(),
              child: RemixCombobox<String>(
                controller: _controller,
                focusNode: _focusNode,
                label: 'Destination',
                hintText: 'Try “san”',
                enabled: widget.enabled,
                optionsBuilder: (query) => query.text.isEmpty
                    ? const []
                    : _cities.where(
                        (city) => city.toLowerCase().contains(
                          query.text.toLowerCase(),
                        ),
                      ),
                onSelected: (city) => setState(() => _selected = city),
                style: ComboboxStyler()
                    .field(
                      TextFieldStyler()
                          .padding(.all(12))
                          .constraints(.minHeight(48))
                          .borderRadius(.all(FortalTokens.radius3()))
                          .color(FortalTokens.gray2())
                          .text(TextStyler().color(FortalTokens.gray12()))
                          .label(TextStyler().color(FortalTokens.gray12()))
                          .hintText(TextStyler().color(FortalTokens.gray11()))
                          .cursorColor(FortalTokens.accentContent())
                          .border(
                            .all(.color(FortalTokens.controlBorder()).width(1)),
                          )
                          .onFocused(
                            .border(
                              .all(.color(FortalTokens.focus8()).width(2)),
                            ),
                          )
                          .onDisabled(
                            .color(FortalTokens.gray3())
                                .border(
                                  .all(.color(FortalTokens.gray6()).width(1)),
                                )
                                .text(TextStyler().color(FortalTokens.gray8()))
                                .hintText(
                                  TextStyler().color(FortalTokens.gray8()),
                                )
                                .label(
                                  TextStyler().color(FortalTokens.gray11()),
                                ),
                          ),
                    )
                    .panel(
                      BoxStyler()
                          .margin(.top(8))
                          .borderRadius(.all(FortalTokens.radius3()))
                          .color(FortalTokens.colorPanel())
                          .padding(.all(4))
                          .border(.all(.color(FortalTokens.gray7()).width(1)))
                          .decoration(
                            BoxDecorationMix.create(
                              boxShadow: FortalTokens.shadow3.mix(),
                            ),
                          ),
                    )
                    .option(
                      ComboboxOptionStyler()
                          .padding(.horizontal(12).vertical(8))
                          .borderRadius(.all(FortalTokens.radius2()))
                          .onHovered(.color(FortalTokens.accentA3()))
                          .onFocused(.color(FortalTokens.accentA4()))
                          .label(
                            TextStyler()
                                .color(FortalTokens.gray12())
                                .fontSize(16),
                          ),
                    ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Keep overflowing, wrapped suggestions discoverable in every pointer mode.
class _SuggestionScrollBehavior extends ScrollBehavior {
  const _SuggestionScrollBehavior();

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) => RawScrollbar(
    controller: details.controller,
    thumbVisibility: true,
    thumbColor: FortalTokens.gray8.resolve(context),
    radius: FortalTokens.radius2.resolve(context),
    thickness: 4,
    child: child,
  );
}
