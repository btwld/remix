import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:remix/src/utilities/remix_path_icon.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('CheckboxSpec.indicatorBuilder', () {
    setUp(_IndicatorProbeState.reset);

    testWidgets('stays mounted while the value toggles', (tester) async {
      Future<void> pump(bool selected) => tester.pumpRemixApp(
        RemixCheckbox(
          selected: selected,
          onChanged: (_) {},
          style: _probeStyle,
        ),
      );

      await pump(true);
      expect(_IndicatorProbeState.values, [true]);
      await pump(false);
      await pump(true);

      expect(_IndicatorProbeState.values, [true, false, true]);
      expect(_IndicatorProbeState.mounts, 1);
      expect(find.byType(_IndicatorProbe), findsOneWidget);
    });

    testWidgets('receives null for an indeterminate tristate checkbox', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        RemixCheckbox(
          selected: null,
          tristate: true,
          onChanged: (_) {},
          style: _probeStyle,
        ),
      );

      expect(_IndicatorProbeState.values, [null]);
    });

    testWidgets('replaces the default glyph and the icon parameters', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        RemixCheckbox(
          selected: true,
          checkedIcon: Icons.done,
          onChanged: (_) {},
          style: _probeStyle,
        ),
      );

      expect(find.byType(_IndicatorProbe), findsOneWidget);
      expect(find.byType(RemixPathIcon), findsNothing);
      expect(find.byIcon(Icons.done), findsNothing);
    });

    testWidgets('without a builder an unchecked box has no indicator', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        RemixCheckbox(selected: false, onChanged: (_) {}),
      );

      expect(find.byType(RemixPathIcon), findsNothing);
      expect(find.byType(StyledIcon), findsNothing);
    });
  });
}

final _probeStyle = CheckboxStyler().indicatorBuilder(_buildProbe);

Widget _buildProbe(
  BuildContext context,
  bool? value,
  StyleSpec<IconSpec> indicator,
) => _IndicatorProbe(value: value);

class _IndicatorProbe extends StatefulWidget {
  const _IndicatorProbe({required this.value});

  final bool? value;

  @override
  State<_IndicatorProbe> createState() => _IndicatorProbeState();
}

class _IndicatorProbeState extends State<_IndicatorProbe> {
  static int mounts = 0;
  static final values = <bool?>[];

  static void reset() {
    mounts = 0;
    values.clear();
  }

  @override
  void initState() {
    super.initState();
    mounts++;
  }

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty || values.last != widget.value) values.add(widget.value);
    return const SizedBox.square(dimension: 10);
  }
}
