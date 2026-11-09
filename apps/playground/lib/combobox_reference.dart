import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

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
    color: const Color(0xFFFAF9F6),
    textStyle: TextStyle(
      fontFamily: 'Arial',
      fontSize: 16,
      color: _dark ? const Color(0xFFF1F0EC) : const Color(0xFF202E2A),
    ),
    pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    ),
    builder: (context, navigator) => Directionality(
      textDirection: _rtl ? TextDirection.rtl : TextDirection.ltr,
      child: MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(_large ? 2 : 1)),
        child: navigator!,
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

class _DestinationSearch extends StatefulWidget {
  const _DestinationSearch();
  @override
  State<_DestinationSearch> createState() => _DestinationSearchState();
}

class _DestinationSearchState extends State<_DestinationSearch> {
  String? _picked;

  ComboboxStyler get _style {
    final ink = _dark ? const Color(0xFFF1F0EC) : const Color(0xFF202E2A);
    final surface = _dark ? const Color(0xFF202D29) : const Color(0xFFFFFFFF);
    return ComboboxStyler()
        .field(
          TextFieldStyler()
              .constraints(.minHeight(56))
              .padding(.all(14))
              .borderRadius(.circular(12))
              .color(surface)
              .border(.all(.color(const Color(0xFF8A9991)).width(1)))
              .text(TextStyler().color(ink).fontSize(17))
              .label(TextStyler().color(ink).fontSize(14).fontWeight(.w600))
              .cursorColor(const Color(0xFF28775E))
              .onFocused(
                .border(.all(.color(const Color(0xFF28775E)).width(2))),
              ),
        )
        .panel(
          ComboboxPanelStyler()
              .color(surface)
              .padding(.all(6))
              .borderRadius(.circular(12))
              .border(.all(.color(const Color(0xFF8A9991)).width(1)))
              .shadow(
                .color(const Color(0x24000000)).blurRadius(18).offset(y: 6),
              ),
        )
        .option(
          ComboboxOptionStyler()
              .padding(.horizontal(12))
              .borderRadius(.circular(7))
              .onHovered(
                .color(
                  _dark ? const Color(0xFF31463D) : const Color(0xFFF1F5F2),
                ),
              )
              .onFocused(
                .color(
                  _dark ? const Color(0xFF335847) : const Color(0xFFDEEEE5),
                ),
              )
              .label(TextStyler().color(ink).fontSize(16).height(1.5)),
        );
  }

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: _dark ? const Color(0xFF14201B) : const Color(0xFFFAF9F6),
    child: SafeArea(
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
                  'FIELD NOTES / TRAVEL',
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Find your next stop.',
                  style: TextStyle(
                    fontSize: 36,
                    height: 1.15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Explore a city, then make it yours. Type “san” to browse destinations.',
                ),
                const SizedBox(height: 32),
                RemixCombobox<String>(
                  label: _rtl ? 'الوجهة' : 'Destination',
                  hintText: 'Search cities',
                  optionsBuilder: (query) => query.text.isEmpty
                      ? const Iterable<String>.empty()
                      : _destinations.where(
                          (city) => city.toLowerCase().contains(
                            query.text.toLowerCase(),
                          ),
                        ),
                  onSelected: (city) => setState(() => _picked = city),
                  style: _style,
                ),
                const SizedBox(height: 24),
                Semantics(
                  liveRegion: true,
                  child: Text(
                    _picked == null
                        ? 'Your next destination is waiting.'
                        : 'Selected: $_picked',
                  ),
                ),
                const SizedBox(height: 36),
                const Text(
                  'Saved itinerary',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                RemixCombobox<String>(
                  label: 'Destination locked',
                  hintText: 'Unlock your itinerary to edit',
                  enabled: false,
                  optionsBuilder: (_) => const [],
                  style: _style.field(
                    TextFieldStyler().color(
                      _dark ? const Color(0xFF25332D) : const Color(0xFFEEEFEA),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Use ↑ and ↓ to explore. Enter chooses a city. Escape keeps your search.',
                  style: TextStyle(fontSize: 13, height: 1.5),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
