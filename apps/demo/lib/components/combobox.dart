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

  static const _arabicCities = [
    'سان فرانسيسكو، كاليفورنيا · الولايات المتحدة',
    'سان سيباستيان، إقليم الباسك · إسبانيا',
    'سان ميغيل دي أليندي، غواناخواتو · المكسيك',
    'سانتا كروث دي تينيريفه، جزر الكناري · إسبانيا',
    'سانتياغو دي كومبوستيلا، غاليسيا · إسبانيا',
    'سانتو دومينغو، المقاطعة الوطنية · جمهورية الدومينيكان',
    'ساو باولو، ساو باولو · البرازيل',
  ];

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final cities = rtl ? _arabicCities : _cities;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RemixCombobox<String>(
                controller: _controller,
                focusNode: _focusNode,
                label: rtl ? 'الوجهة' : 'Destination',
                hintText: rtl ? 'جرّب «سان»' : 'Try “san”',
                enabled: widget.enabled,
                optionsBuilder: (query) => query.text.isEmpty
                    ? const []
                    : cities.where(
                        (city) => city.toLowerCase().contains(
                          query.text.toLowerCase(),
                        ),
                      ),
                onSelected: (city) => setState(() => _selected = city),
                style: ComboboxStyler()
                    .field(
                      TextFieldStyler()
                          .padding(.symmetric(horizontal: 12, vertical: 8))
                          .constraints(.minHeight(36))
                          .borderRadius(.all(FortalTokens.radius3()))
                          .color(FortalTokens.gray2())
                          .text(
                            TextStyler()
                                .fontSize(14)
                                .color(FortalTokens.gray12()),
                          )
                          .label(
                            TextStyler()
                                .fontSize(14)
                                .color(FortalTokens.gray12()),
                          )
                          .hintText(
                            TextStyler()
                                .fontSize(14)
                                .color(FortalTokens.gray11()),
                          )
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
                                .text(TextStyler().color(FortalTokens.gray9()))
                                .hintText(
                                  TextStyler().color(FortalTokens.gray9()),
                                )
                                .label(
                                  TextStyler().color(FortalTokens.gray11()),
                                ),
                          ),
                    )
                    .panel(
                      ComboboxPanelStyler()
                          .margin(.top(8))
                          .scrollbarColor(FortalTokens.gray9())
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
                          .minHeight(32)
                          .padding(.symmetric(horizontal: 12, vertical: 6))
                          .margin(.bottom(1))
                          .borderRadius(.all(FortalTokens.radius2()))
                          .border(
                            .all(
                              .color(
                                FortalTokens.accent8().withValues(alpha: 0),
                              ).width(1),
                            ),
                          )
                          .onHovered(.color(FortalTokens.accentA3()))
                          .onFocused(
                            .color(FortalTokens.accentA5()).border(
                              .all(.color(FortalTokens.accent8()).width(1)),
                            ),
                          )
                          .onPressed(.color(FortalTokens.accentA7()))
                          .label(
                            TextStyler()
                                .color(FortalTokens.gray12())
                                .fontSize(14),
                          ),
                    ),
              ),
              const SizedBox(height: 12),
              Semantics(
                liveRegion: true,
                child: Text(
                  _selected == null
                      ? (rtl
                            ? 'اختر وجهة من الاقتراحات.'
                            : 'Choose a suggested destination.')
                      : (rtl
                            ? 'الوجهة المختارة: $_selected'
                            : 'Selected: $_selected'),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        (widget.enabled
                                ? FortalTokens.gray11
                                : FortalTokens.gray9)
                            .resolve(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
