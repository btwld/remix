import 'package:flutter_test/flutter_test.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';

import '../helpers/glyphs.dart';
import '../helpers/mock.dart';
import '../helpers/pump.dart';

void main() {
  testWidgets('reads "2 files referenced" and opens the list', (tester) async {
    final changes = <bool>[];
    await pumpAgent(
      tester,
      AgentSources(
        sources: sources,
        onExpandedChanged: changes.add,
        glyphBuilder: testGlyphs,
      ),
    );

    expect(find.text('2 files referenced'), findsOneWidget);
    expect(findGlyph(AgentGlyph.sources), findsOneWidget);
    expect(findGlyph(AgentGlyph.disclosureClosed), findsOneWidget);
    expect(find.text('cart_totals_test.dart'), findsNothing);

    await tester.tap(find.text('2 files referenced'));
    await tester.pumpAndSettle();
    expect(changes, [true]);
    expect(findGlyph(AgentGlyph.disclosureOpen), findsOneWidget);
    expect(find.text('cart_totals_test.dart'), findsOneWidget);
    expect(find.text('checkout_flow_test.dart'), findsOneWidget);
    // Without a handler, a source is text, not a button.
    expect(find.byType(RemixButton), findsNothing);
  });

  testWidgets('with a handler each source is a button', (tester) async {
    final opened = <AgentSource>[];
    await pumpAgent(
      tester,
      AgentSources(
        sources: sources,
        defaultExpanded: true,
        onSourcePressed: opened.add,
      ),
    );

    await tester.tap(find.text('checkout_flow_test.dart'));
    expect(opened, [sources.last]);
  });

  testWidgets('counts one source in the singular', (tester) async {
    await pumpAgent(tester, AgentSources(sources: [sources.first]));

    expect(find.text('1 file referenced'), findsOneWidget);
  });

  testWidgets('a host label builder replaces the English line', (tester) async {
    await pumpAgent(
      tester,
      AgentSources(sources: sources, labelBuilder: (count) => '$count sources'),
    );

    expect(find.text('2 sources'), findsOneWidget);
  });

  testWidgets('the line is a disclosure named by its label', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpAgent(tester, const AgentSources(sources: sources));

    expect(
      tester.getSemantics(find.bySemanticsLabel('2 files referenced')),
      isSemantics(isButton: true, isExpanded: false),
    );
    semantics.dispose();
  });
}
