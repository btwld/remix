import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:registry_source/fortal.dart';

import '../../helpers/contrast.dart';
import '../../helpers/test_helpers.dart';

void main() {
  testWidgets('shrink-wraps the segmented-control container', (tester) async {
    final nodes = _focusNodes();
    addTearDown(() => _disposeNodes(nodes));

    await tester.pumpRemixApp(
      FortalToggleGroup<String>(
        items: _items(nodes),
        selectedValue: 'list',
        onChanged: (_) {},
      ),
    );
    await tester.pumpAndSettle();

    final size = tester.getSize(find.byType(FlexBox));
    expect(size.width, lessThan(400));
    expect(size.height, lessThan(100));
  });

  testWidgets('a disabled item shows at 45%', (tester) async {
    await tester.pumpRemixApp(
      FortalToggleGroup<String>(
        items: const [
          RemixToggleGroupItem(value: 'list', label: 'List'),
          RemixToggleGroupItem(value: 'grid', label: 'Grid', enabled: false),
        ],
        selectedValue: 'list',
        onChanged: (_) {},
      ),
    );
    await tester.pumpAndSettle();

    expect(_shownOpacity(tester, find.text('List')), closeTo(1, 1e-9));
    expect(_shownOpacity(tester, find.text('Grid')), closeTo(0.45, 1e-9));
  });

  testWidgets('resting item text keeps 4.5:1 on the group in light and dark', (
    tester,
  ) async {
    for (final mode in [FortalThemeMode.light, FortalThemeMode.dark]) {
      final spec = await resolveInFortalTheme(
        tester,
        (context) => fortalToggleGroupStyle().build(context).spec,
        mode: mode,
      );
      final fill =
          (spec.container.spec.box!.spec.decoration! as BoxDecoration).color!;
      final item = spec.item.spec;

      expect(
        contrastRatio(item.label.spec.style!.color!, fill),
        greaterThanOrEqualTo(4.5),
        reason: '${mode.name} label',
      );
      expect(
        contrastRatio(item.icon.spec.color!, fill),
        greaterThanOrEqualTo(4.5),
        reason: '${mode.name} icon',
      );
    }
  });
}

double _shownOpacity(WidgetTester tester, Finder finder) => tester
    .widgetList<Opacity>(
      find.ancestor(of: finder, matching: find.byType(Opacity)),
    )
    .fold(1.0, (shown, layer) => shown * layer.opacity);

List<RemixToggleGroupItem<String>> _items(List<FocusNode> nodes) {
  return [
    RemixToggleGroupItem(
      value: 'list',
      label: 'List',
      icon: Icons.view_list,
      focusNode: nodes[0],
    ),
    RemixToggleGroupItem(
      value: 'grid',
      label: 'Grid',
      icon: Icons.grid_view,
      focusNode: nodes[1],
    ),
    RemixToggleGroupItem(
      value: 'board',
      label: 'Board',
      icon: Icons.view_kanban,
      focusNode: nodes[2],
    ),
  ];
}

List<FocusNode> _focusNodes() => List.generate(3, (index) => FocusNode());

void _disposeNodes(List<FocusNode> nodes) {
  for (final node in nodes) {
    node.dispose();
  }
}
