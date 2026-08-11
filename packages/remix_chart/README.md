# remix_chart

Fortal chart recipes and generated widgets for
[`mix_chart`](https://pub.dev/packages/mix_chart).

`remix_chart` is an optional integration package. Core `remix` does not depend
on it: this package depends on both `remix` and `mix_chart`, keeping the chart
renderer out of applications that only need Remix components.

## Usage

```dart
import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:remix_chart/remix_chart.dart';

FortalScope(
  accent: .indigo,
  child: SizedBox(
    width: 640,
    height: 320,
    child: FortalLineChart(
      semanticsLabel: 'Weekly revenue',
      series: [
        LineSeries(
          id: 'revenue',
          label: 'Revenue',
          points: [
            ChartPoint(id: 'mon', x: 0, y: 18),
            ChartPoint(id: 'tue', x: 1, y: 31),
            ChartPoint(id: 'wed', x: 2, y: 27),
          ],
        ),
      ],
    ),
  ),
)
```

The generated widgets are:

- `FortalLineChart`
- `FortalBarChart`
- `FortalPieChart`

Use `fortalLineChartStyle`, `fortalBarChartStyle`, or
`fortalPieChartStyle` directly when composing a customized base chart.

## Code generation

The Fortal widgets are generated from `@MixWidget` recipe functions. Generated
files are committed. Regenerate them from the repository root with:

```sh
fvm dart run melos run generate
```

`mix_chart` owns chart data, behavior, Specs, and rendering. This package owns
only Fortal presentation and convenience widgets; it never imports `fl_chart`.
