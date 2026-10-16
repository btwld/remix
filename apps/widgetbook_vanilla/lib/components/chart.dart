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
          ChartSeries(
            id: 'revenue',
            label: 'Revenue',
            points: const [
              ChartPoint(x: 0, y: 18, label: 'Jan'),
              ChartPoint(x: 1, y: 24, label: 'Feb'),
              ChartPoint(x: 2, y: 21, label: 'Mar'),
              ChartPoint(x: 3, y: 32, label: 'Apr'),
            ],
          ),
        ],
      ),
    ),
  ),
);
