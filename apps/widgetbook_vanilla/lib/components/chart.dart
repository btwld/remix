import 'package:flutter/material.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_vanilla/ui/ui.dart';

@widgetbook.UseCase(name: 'LineChart', type: VanillaLineChart)
Widget buildVanillaChartUseCase(BuildContext context) => Scaffold(
  body: Center(
    child: SizedBox(
      width: 360,
      height: 220,
      child: VanillaLineChart(
        series: [
          LineSeries(
            id: 'revenue',
            label: 'Revenue',
            points: [
              ChartPoint(id: 'Jan', x: 0, y: 18),
              ChartPoint(id: 'Feb', x: 1, y: 24),
              ChartPoint(id: 'Mar', x: 2, y: 21),
              ChartPoint(id: 'Apr', x: 3, y: 32),
            ],
          ),
        ],
      ),
    ),
  ),
);
