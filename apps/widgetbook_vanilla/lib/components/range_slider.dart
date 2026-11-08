import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_vanilla/ui/ui.dart';

@widgetbook.UseCase(name: 'Interval', type: VanillaRangeSlider)
Widget buildVanillaRangeSliderUseCase(BuildContext context) =>
    const _RangeSliderStory();

@widgetbook.UseCase(name: 'Disabled', type: VanillaRangeSlider)
Widget buildVanillaRangeSliderDisabledUseCase(BuildContext context) =>
    const _RangeSliderStory(enabled: false);

@widgetbook.UseCase(name: 'RTL · 200% text', type: VanillaRangeSlider)
Widget buildVanillaRangeSliderRtlUseCase(BuildContext context) =>
    Directionality(
      textDirection: TextDirection.rtl,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(2)),
        child: const _RangeSliderStory(),
      ),
    );

class _RangeSliderStory extends StatefulWidget {
  const _RangeSliderStory({this.enabled = true});
  final bool enabled;

  @override
  State<_RangeSliderStory> createState() => _RangeSliderStoryState();
}

class _RangeSliderStoryState extends State<_RangeSliderStory> {
  List<double> values = [20, 80];

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: SizedBox(
        width: 280,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Budget: ${values[0].round()} – ${values[1].round()}'),
            VanillaRangeSlider(
              values: values,
              min: 0,
              max: 100,
              minSpacing: 10,
              snapDivisions: 20,
              enabled: widget.enabled,
              semanticLabels: const ['Minimum budget', 'Maximum budget'],
              onChanged: (next) => setState(() => values = next),
            ),
          ],
        ),
      ),
    ),
  );
}
