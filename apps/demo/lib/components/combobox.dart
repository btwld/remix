import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../ui/ui.dart';
import '../helpers/catalog.dart';

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
              FortalCombobox<String>(
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

@widgetbook.UseCase(name: 'Catalog', type: RemixCombobox)
Widget buildComboboxCatalogUseCase(BuildContext context) => CatalogMatrix(
  cellWidth: 220,
  columns: labelsOf(FortalComboboxSize.values),
  rows: labelsOf(FortalComboboxVariant.values),
  cell: (row, column) => FortalCombobox<String>(
    variant: FortalComboboxVariant.values[row],
    size: FortalComboboxSize.values[column],
    label: 'Destination',
    hintText: 'Search cities',
    optionsBuilder: (_) => const ['Recife', 'Porto', 'Chiang Mai'],
  ),
);
