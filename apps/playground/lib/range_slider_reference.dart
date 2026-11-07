import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_fonts/remix_ui_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) SemanticsBinding.instance.ensureSemantics();
  final query = Uri.base.queryParameters;
  runApp(
    RangeSliderReferenceApp(
      dark: query['dark'] == '1' || const bool.fromEnvironment('DARK'),
      rtl: query['rtl'] == '1' || const bool.fromEnvironment('RTL'),
      textScale: double.tryParse(query['scale'] ?? '') ?? 1,
    ),
  );
}

/// Standalone native/web price-filter reference with deterministic sample data.
class RangeSliderReferenceApp extends StatelessWidget {
  const RangeSliderReferenceApp({
    super.key,
    this.dark = false,
    this.rtl = false,
    this.textScale = 1,
  });
  final bool dark;
  final bool rtl;
  final double textScale;

  @override
  Widget build(BuildContext context) => WidgetsApp(
    title: 'Fieldnotes · Nightly budget',
    debugShowCheckedModeBanner: false,
    color: dark ? const Color(0xff17211b) : const Color(0xfff5f4ee),
    textStyle: TextStyle(
      fontFamily: RemixFonts.geist,
      color: dark ? const Color(0xfff0f3e9) : const Color(0xff24372c),
      fontSize: 16,
    ),
    builder: (context, _) => MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: TextScaler.linear(textScale)),
      child: Directionality(
        textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
        child: _BudgetFilter(dark: dark),
      ),
    ),
  );
}

class _BudgetFilter extends StatefulWidget {
  const _BudgetFilter({required this.dark});
  final bool dark;
  @override
  State<_BudgetFilter> createState() => _BudgetFilterState();
}

class _BudgetFilterState extends State<_BudgetFilter> {
  List<double> _prices = [80, 240];
  static const _stays = [
    (name: 'The courtyard room', location: 'Old town', price: 95.0),
    (name: 'A cabin among the pines', location: 'Mountain edge', price: 165.0),
    (name: 'The riverside studio', location: 'Riverside', price: 230.0),
  ];

  @override
  Widget build(BuildContext context) {
    final dark = widget.dark;
    final ink = dark ? const Color(0xfff0f3e9) : const Color(0xff24372c);
    final muted = dark ? const Color(0xffb0bfaf) : const Color(0xff647464);
    final accent = dark ? const Color(0xffc2d9a7) : const Color(0xff41654c);
    final line = dark ? const Color(0xff405043) : const Color(0xffd8dfd2);
    final matches = _stays
        .where((s) => s.price >= _prices[0] && s.price <= _prices[1])
        .toList();
    final sliderStyle = SliderStyler()
        .thumbSize(const Size(24, 24))
        .thumb(
          BoxStyler()
              .borderRadius(.circular(12))
              .border(.all(BorderSideMix(color: accent, width: 2))),
        )
        .thumbColor(dark ? const Color(0xff27382c) : const Color(0xffffffff))
        .thickness(4)
        .trackColor(line)
        .rangeColor(accent)
        .thumbFocusEffects(
          RemixBoxEffectsMix.outline(
            BorderSideMix(color: accent, width: 2),
          ).outlineOffset(4),
        )
        .onHovered(
          SliderStyler().thumbColor(
            dark ? const Color(0xff526849) : const Color(0xffe2ecd8),
          ),
        )
        .onPressed(SliderStyler().thumbColor(accent));
    Text text(
      String value,
      double size, {
      Color? color,
      FontWeight weight = FontWeight.w400,
    }) => Text(
      value,
      style: TextStyle(
        fontSize: size,
        color: color ?? ink,
        fontWeight: weight,
        height: 1.35,
      ),
    );
    return ColoredBox(
      color: dark ? const Color(0xff17211b) : const Color(0xfff5f4ee),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 48),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    text(
                      'FIELDNOTES  /  STAYS',
                      12,
                      color: muted,
                      weight: FontWeight.w600,
                    ),
                    const SizedBox(height: 40),
                    text(
                      'A little room\nto get away.',
                      44,
                      weight: FontWeight.w500,
                    ),
                    const SizedBox(height: 12),
                    text(
                      'Find a stay that feels right, at a price that leaves room for the rest.',
                      16,
                      color: muted,
                    ),
                    const SizedBox(height: 32),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: dark
                            ? const Color(0xff222f26)
                            : const Color(0xfffdfef9),
                        border: Border.all(color: line),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 24,
                              runSpacing: 8,
                              children: [
                                text(
                                  'Your nightly budget',
                                  20,
                                  weight: FontWeight.w600,
                                ),
                                RemixButton(
                                  label: 'Reset',
                                  onPressed: () =>
                                      setState(() => _prices = [80, 240]),
                                  style: ButtonStyler()
                                      .labelColor(accent)
                                      .padding(
                                        .symmetric(horizontal: 12, vertical: 8),
                                      )
                                      .borderRadius(.circular(8))
                                      .onFocused(ButtonStyler().color(line)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Wrap(
                              spacing: 32,
                              runSpacing: 16,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    text(
                                      'MINIMUM',
                                      11,
                                      color: muted,
                                      weight: FontWeight.w600,
                                    ),
                                    text(
                                      '\$${_prices[0].round()}',
                                      30,
                                      weight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    text(
                                      'MAXIMUM',
                                      11,
                                      color: muted,
                                      weight: FontWeight.w600,
                                    ),
                                    text(
                                      '\$${_prices[1].round()}',
                                      30,
                                      weight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            RemixRangeSlider(
                              values: _prices,
                              min: 0,
                              max: 400,
                              minSpacing: 20,
                              snapDivisions: 80,
                              style: sliderStyle,
                              semanticLabels: const [
                                'Minimum nightly price',
                                'Maximum nightly price',
                              ],
                              semanticFormatterCallbacks: [
                                (v) => '${v.round()} dollars per night',
                                (v) => '${v.round()} dollars per night',
                              ],
                              onChanged: (next) =>
                                  setState(() => _prices = next),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                text('\$0', 12, color: muted),
                                text('\$400', 12, color: muted),
                              ],
                            ),
                            const SizedBox(height: 16),
                            text(
                              'Per night, before taxes and fees.',
                              12,
                              color: muted,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    text(
                      '${matches.length} matching sample stays',
                      14,
                      weight: FontWeight.w600,
                    ),
                    const SizedBox(height: 8),
                    for (final stay in matches)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            text(stay.name, 17, weight: FontWeight.w500),
                            text(
                              '${stay.location}  ·  \$${stay.price.round()} / night',
                              13,
                              color: muted,
                            ),
                          ],
                        ),
                      ),
                    if (matches.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: text(
                          'No sample stays in this budget. Try widening the range.',
                          14,
                          color: muted,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
