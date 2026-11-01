import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/heroui.dart';

import '../helpers/heroui.dart';

void main() {
  for (final radio in [true, false]) {
    testWidgets(
      '${radio ? 'radio' : 'switch'} group exposes one actionable option name '
      'and its description',
      (tester) async {
        final semantics = tester.ensureSemantics();
        try {
          const name = 'Product updates';
          const description = 'News about releases and features.';
          var selected = false;

          await tester.pumpHeroUi(
            StatefulBuilder(
              builder: (context, setState) => radio
                  ? HeroUiRadioGroup<String>(
                      groupValue: selected ? 'updates' : null,
                      onChanged: (value) =>
                          setState(() => selected = value == 'updates'),
                      options: const [
                        HeroUiRadioOption(
                          value: 'updates',
                          label: name,
                          description: description,
                        ),
                      ],
                    )
                  : HeroUiSwitchGroup(
                      items: [
                        HeroUiSwitchOption(
                          selected: selected,
                          onChanged: (value) =>
                              setState(() => selected = value),
                          label: name,
                          description: description,
                        ),
                      ],
                    ),
            ),
          );
          await tester.pumpAndSettle();

          final names = find.semantics.byPredicate(
            (node) =>
                !node.isMergedIntoParent &&
                node.getSemanticsData().label.contains(name),
          );
          final descriptions = find.semantics.byPredicate(
            (node) =>
                !node.isMergedIntoParent &&
                node.getSemanticsData().label.contains(description),
          );
          expect(
            names,
            findsOne,
            reason: 'the control already supplies its name',
          );
          final control = names.evaluate().single.getSemanticsData();
          // A radio can merge its description into the same platform node.
          // The option name must still occur only once in that announcement.
          expect(
            RegExp(RegExp.escape(name)).allMatches(control.label),
            hasLength(1),
          );
          expect(control.hasAction(SemanticsAction.tap), isTrue);
          expect(descriptions, findsOne);

          tester.semantics.tap(names);
          await tester.pumpAndSettle();
          expect(selected, isTrue);
          expect(names, findsOne);
          expect(
            RegExp(
              RegExp.escape(name),
            ).allMatches(names.evaluate().single.getSemanticsData().label),
            hasLength(1),
          );
          expect(descriptions, findsOne);
        } finally {
          semantics.dispose();
        }
      },
    );
  }
}
