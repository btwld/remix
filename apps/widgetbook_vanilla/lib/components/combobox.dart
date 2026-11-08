import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_vanilla/ui/ui.dart';

@widgetbook.UseCase(name: 'Combobox', type: VanillaCombobox)
Widget buildVanillaComboboxUseCase(BuildContext context) {
  final rtl = Directionality.of(context) == TextDirection.rtl;
  return Scaffold(
    body: Center(
      child: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VanillaCombobox<String>(
              label: rtl ? 'الوجهة' : 'Destination',
              hintText: rtl ? 'جرّب «سان»' : 'Try “san”',
              optionsBuilder: (query) => query.text.isEmpty
                  ? const []
                  : (rtl ? _arabicCities : _cities).where(
                      (city) =>
                          city.toLowerCase().contains(query.text.toLowerCase()),
                    ),
            ),
            const SizedBox(height: 24),
            VanillaCombobox<String>(
              label: rtl ? 'الوجهة مقفلة' : 'Destination locked',
              hintText: rtl ? 'غير متاح' : 'Disabled',
              enabled: false,
              optionsBuilder: (_) => const [],
            ),
          ],
        ),
      ),
    ),
  );
}

const _cities = [
  'San Francisco, California · United States',
  'San Sebastián, Basque Country · Spain',
  'San Miguel de Allende, Guanajuato · Mexico',
  'Santa Cruz de Tenerife, Canary Islands · Spain',
  'Santiago de Compostela, Galicia · Spain',
  'Santo Domingo, Distrito Nacional · Dominican Republic',
  'São Paulo, São Paulo · Brazil',
];

const _arabicCities = [
  'سان فرانسيسكو، كاليفورنيا · الولايات المتحدة',
  'سان سيباستيان، إقليم الباسك · إسبانيا',
  'سان ميغيل دي أليندي، غواناخواتو · المكسيك',
  'سانتا كروث دي تينيريفه، جزر الكناري · إسبانيا',
  'سانتياغو دي كومبوستيلا، غاليسيا · إسبانيا',
  'سانتو دومينغو، المقاطعة الوطنية · جمهورية الدومينيكان',
];
