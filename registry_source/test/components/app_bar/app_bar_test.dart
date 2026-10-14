import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:registry_source/fortal.dart';

import '../../helpers/test_helpers.dart';

/// Pumps [child] at a fixed width under a Fortal scope with no Material.
Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  FortalScaling? scaling,
}) => tester.pumpWidget(
  FortalTheme(
    scaling: scaling,
    child: WidgetsApp(
      color: const Color(0xFF000000),
      builder: (_, _) => Align(
        alignment: Alignment.topLeft,
        child: SizedBox(width: 600, child: child),
      ),
    ),
  ),
);

void main() {
  testWidgets('recipe paints the panel surface with a bottom edge', (
    tester,
  ) async {
    late Color panel;
    late Color edge;
    late double edgeWidth;
    late AppBarSpec spec;
    await tester.pumpRemixApp(
      Builder(
        builder: (context) {
          panel = MixScope.tokenOf(FortalTokens.colorPanelSolid, context);
          edge = MixScope.tokenOf(FortalTokens.grayA6, context);
          edgeWidth = MixScope.tokenOf(FortalTokens.borderWidth1, context);
          spec = fortalAppBarStyle().resolve(context).spec;
          return const SizedBox.shrink();
        },
      ),
    );

    final surface = spec.container.spec.decoration as BoxDecoration?;
    final row = spec.toolbar.spec.decoration as BoxDecoration?;
    expect(surface?.color, panel);
    expect(
      (row?.border as Border?)?.bottom,
      BorderSide(color: edge, width: edgeWidth),
    );
    expect(spec.toolbarHeight, 64);
    expect(
      spec.toolbar.spec.padding,
      const EdgeInsets.symmetric(horizontal: 16),
    );
    expect(spec.spacing, 12);
    expect(spec.actions.spec.flex?.spec.spacing, 12);
  });

  testWidgets('the toolbar height follows Fortal scaling', (tester) async {
    await _pump(
      tester,
      const FortalAppBar(title: 'Orders', safeArea: false),
      scaling: .percent110,
    );

    expect(
      tester.getSize(find.byType(FortalAppBar)).height,
      moreOrLessEquals(64 * 1.1),
    );
  });

  testWidgets('renders a heading and actions without Material', (tester) async {
    final semantics = tester.ensureSemantics();
    await _pump(
      tester,
      FortalAppBar(
        title: 'Orders',
        actions: [FortalButton(label: 'Export', onPressed: () {})],
      ),
    );

    expect(tester.getSize(find.byType(FortalAppBar)).height, 64);
    expect(
      tester.getSemantics(find.bySemanticsLabel('Orders')),
      isSemantics(label: 'Orders', isHeader: true),
    );
    expect(find.text('Export'), findsOneWidget);
    expect(tester.takeException(), isNull);

    semantics.dispose();
  });
}
