import 'package:flutter/widgets.dart';
import 'ui/ui.dart';

const _rtl = bool.fromEnvironment('COMBOBOX_RTL');
const _large = bool.fromEnvironment('COMBOBOX_LARGE_TEXT');
const _narrow = bool.fromEnvironment('COMBOBOX_NARROW');
const _dark = bool.fromEnvironment('COMBOBOX_DARK');

void main() => runApp(const ComboboxReferenceApp());

/// A standalone, widgets-only consumer of the default Combobox editor.
class ComboboxReferenceApp extends StatelessWidget {
  const ComboboxReferenceApp({super.key});

  @override
  Widget build(BuildContext context) => WidgetsApp(
    debugShowCheckedModeBanner: false,
    color: (const PlaygroundThemeData.light()).background,
    pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    ),
    builder: (context, navigator) => PlaygroundTheme(
      mode: _dark ? .dark : .light,
      child: Directionality(
        textDirection: _rtl ? TextDirection.rtl : TextDirection.ltr,
        child: MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(_large ? 2 : 1)),
          child: navigator!,
        ),
      ),
    ),
    home: const _DestinationSearch(),
  );
}

const _destinations = [
  'San Francisco, California · United States',
  'San Sebastián, Basque Country · Spain',
  'San Miguel de Allende, Guanajuato · Mexico',
  'Santa Cruz de Tenerife, Canary Islands · Spain',
  'Santiago de Compostela, Galicia · Spain',
  'Santo Domingo, Distrito Nacional · Dominican Republic',
  'Santa Barbara, California · United States',
  'San José, Central Valley · Costa Rica',
  'Recife, Pernambuco · Brazil',
  'São Paulo, São Paulo · Brazil',
];

const _arabicDestinations = [
  'سان فرانسيسكو، كاليفورنيا · الولايات المتحدة',
  'سان سيباستيان، إقليم الباسك · إسبانيا',
  'سان ميغيل دي أليندي، غواناخواتو · المكسيك',
  'سانتا كروث دي تينيريفه، جزر الكناري · إسبانيا',
  'سانتياغو دي كومبوستيلا، غاليسيا · إسبانيا',
  'سانتو دومينغو، المقاطعة الوطنية · جمهورية الدومينيكان',
  'سانتا باربرا، كاليفورنيا · الولايات المتحدة',
  'سان خوسيه، الوادي الأوسط · كوستاريكا',
];

class _DestinationSearch extends StatefulWidget {
  const _DestinationSearch();
  @override
  State<_DestinationSearch> createState() => _DestinationSearchState();
}

class _DestinationSearchState extends State<_DestinationSearch> {
  String? _picked;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: _narrow ? 320 : 640,
        child: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.fromSTEB(24, 48, 24, 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                _rtl ? 'ملاحظات الرحلة / سفر' : 'FIELD NOTES / TRAVEL',
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                _rtl ? 'اكتشف وجهتك القادمة.' : 'Find your next stop.',
                style: TextStyle(
                  fontSize: 36,
                  height: 1.15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                _rtl
                    ? 'استكشف مدينة واجعلها وجهتك. اكتب «سان» لتصفّح الوجهات.'
                    : 'Explore a city, then make it yours. Type “san” to browse destinations.',
              ),
              const SizedBox(height: 32),
              PlaygroundCombobox<String>(
                label: _rtl ? 'الوجهة' : 'Destination',
                hintText: _rtl ? 'ابحث عن مدينة' : 'Search cities',
                optionsBuilder: (query) => query.text.isEmpty
                    ? const Iterable<String>.empty()
                    : (_rtl ? _arabicDestinations : _destinations).where(
                        (city) => city.toLowerCase().contains(
                          query.text.toLowerCase(),
                        ),
                      ),
                onSelected: (city) => setState(() => _picked = city),
              ),
              // Reserve the open panel's 320px bound plus a helper gap at
              // large text sizes; the recipe should not own page layout.
              const SizedBox(height: _large ? 352 : 24),
              Semantics(
                liveRegion: true,
                child: Text(
                  _picked == null
                      ? (_rtl
                            ? 'وجهتك القادمة بانتظارك.'
                            : 'Your next destination is waiting.')
                      : (_rtl
                            ? 'الوجهة المختارة: $_picked'
                            : 'Selected: $_picked'),
                ),
              ),
              const SizedBox(height: 36),
              const Text(
                _rtl ? 'خطة الرحلة المحفوظة' : 'Saved itinerary',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              PlaygroundCombobox<String>(
                label: _rtl ? 'الوجهة مقفلة' : 'Destination locked',
                hintText: _rtl
                    ? 'افتح خطة الرحلة للتعديل'
                    : 'Unlock your itinerary to edit',
                enabled: false,
                optionsBuilder: (_) => const [],
              ),
              const SizedBox(height: 24),
              const Text(
                _rtl
                    ? 'استخدم ↑ و↓ للاستكشاف. Enter يختار المدينة وEscape يحتفظ بالبحث.'
                    : 'Use ↑ and ↓ to explore. Enter chooses a city. Escape keeps your search.',
                style: TextStyle(fontSize: 13, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
