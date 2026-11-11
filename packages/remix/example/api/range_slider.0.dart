import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

void main() => runApp(
  WidgetsApp(
    color: const Color(0xfff5f4ef),
    debugShowCheckedModeBanner: false,
    textStyle: const TextStyle(color: Color(0xff242922), fontSize: 16),
    builder: (context, _) => const Center(child: RangeSliderExample()),
  ),
);

/// A host-owned price interval, with independent accessible bound names.
class RangeSliderExample extends StatefulWidget {
  const RangeSliderExample({super.key});
  @override
  State<RangeSliderExample> createState() => _RangeSliderExampleState();
}

class _RangeSliderExampleState extends State<RangeSliderExample> {
  List<double> _prices = [80, 240];

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 280,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Nightly price'),
        Text('\$${_prices[0].round()} – \$${_prices[1].round()}'),
        RemixRangeSlider(
          values: _prices,
          min: 0,
          max: 400,
          snapDivisions: 80,
          minSpacing: 20,
          semanticLabels: const [
            'Minimum nightly price',
            'Maximum nightly price',
          ],
          semanticFormatterCallbacks: [
            (v) => '\$${v.round()} per night',
            (v) => '\$${v.round()} per night',
          ],
          onChanged: (next) => setState(() => _prices = next),
          style: SliderStyler()
              .thumbSize(const Size(20, 20))
              .thumbColor(const Color(0xff42654b))
              .thickness(4)
              .trackColor(const Color(0xffd5ddd1))
              .rangeColor(const Color(0xff42654b))
              .onFocused(SliderStyler().thumbColor(const Color(0xff1f3924))),
        ),
      ],
    ),
  );
}
