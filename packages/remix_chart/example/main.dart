import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:remix_chart/remix_chart.dart';

void main() => runApp(const ChartExampleApp());

class ChartExampleApp extends StatelessWidget {
  const ChartExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FortalScope(
      accent: .indigo,
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 720,
              height: 360,
              child: FortalCard(
                size: .size3,
                child: FortalLineChart(
                  semanticsLabel: 'Weekly revenue',
                  showMarkers: true,
                  series: [
                    LineSeries(
                      id: 'revenue',
                      label: 'Revenue',
                      points: [
                        ChartPoint(id: 'mon', x: 0, y: 18),
                        ChartPoint(id: 'tue', x: 1, y: 31),
                        ChartPoint(id: 'wed', x: 2, y: 27),
                        ChartPoint(id: 'thu', x: 3, y: 42),
                        ChartPoint(id: 'fri', x: 4, y: 48),
                      ],
                    ),
                  ],
                  xAxis: ChartAxis.numeric(interval: 1),
                  yAxis: ChartAxis.numeric(min: 0),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
