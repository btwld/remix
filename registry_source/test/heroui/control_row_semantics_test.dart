import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/heroui.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

void main() {
  for (final (radio, axis, enabled) in [
    for (final radio in [true, false])
      for (final axis in radio ? Axis.values : [Axis.vertical])
        for (final enabled in [true, false]) (radio, axis, enabled),
  ]) {
    testWidgets(
      '${radio ? 'radio' : 'checkbox'} group names its options once and keeps help and error readable (${axis.name}, enabled: $enabled)',
      (tester) async {
        final semantics = tester.ensureSemantics();
        try {
          var callbacks = 0;
          await tester.pumpHeroUi(
            radio
                ? HeroUiRadioGroup<String>(
                    groupValue: null,
                    onChanged: (_) => callbacks++,
                    label: 'Notifications',
                    orientation: axis,
                    enabled: enabled,
                    helperText: 'Choose your channels.',
                    errorText: 'Choose at least one channel.',
                    invalid: true,
                    options: const [
                      HeroUiRadioOption(value: 'email', label: 'Email'),
                      HeroUiRadioOption(value: 'sms', label: 'SMS'),
                    ],
                  )
                : HeroUiCheckboxGroup<String>(
                    values: const {},
                    onChanged: (_) => callbacks++,
                    label: 'Notifications',
                    enabled: enabled,
                    helperText: 'Choose your channels.',
                    errorText: 'Choose at least one channel.',
                    invalid: true,
                    options: const [
                      HeroUiCheckboxOption(value: 'email', label: 'Email'),
                      HeroUiCheckboxOption(value: 'sms', label: 'SMS'),
                    ],
                  ),
          );
          await tester.pumpAndSettle();
          final groups = find.semantics.byPredicate(
            (node) => node.getSemanticsData().label.contains('Notifications'),
          );
          expect(groups, findsOne);
          final group = groups.evaluate().single;
          expect(group.getSemanticsData().label, 'Notifications');
          if (radio) {
            final roles = find.semantics.byPredicate(
              (node) =>
                  node.getSemanticsData().role == SemanticsRole.radioGroup,
            );
            expect(roles, findsOne);
            SemanticsNode? ancestor = roles.evaluate().single.parent;
            while (ancestor != null && ancestor != group) {
              ancestor = ancestor.parent;
            }
            expect(
              ancestor,
              same(group),
              reason: 'the named container must wrap the radio-group role',
            );
          } else {
            expect(
              tester.getSemantics(find.byType(RemixCheckboxGroup<String>)),
              same(group),
              reason: 'the checkbox coordinator must own the group name',
            );
          }
          expect(find.semantics.byLabel('Choose your channels.'), findsOne);
          expect(
            find.semantics.byLabel('Choose at least one channel.'),
            findsOne,
          );
          final option = find.semantics.byLabel('Email');
          expect(option, findsOne);
          expect(find.semantics.byLabel('SMS'), findsOne);
          expect(
            option.evaluate().single.getSemanticsData().hasAction(
              SemanticsAction.tap,
            ),
            enabled,
          );
          if (enabled) {
            tester.semantics.tap(option);
            await tester.pumpAndSettle();
          }
          expect(callbacks, enabled ? 1 : 0);
        } finally {
          semantics.dispose();
        }
      },
    );
  }

  for (final axis in Axis.values) {
    for (final (label, controlProvidesName) in [
      (null, false),
      ('', false),
      ('Channels', true),
      ('Channels', false),
    ]) {
      testWidgets('field preserves traversal with label: $label, '
          'controlProvidesName: $controlProvidesName (${axis.name})', (
        tester,
      ) async {
        final semantics = tester.ensureSemantics();
        try {
          var taps = 0;
          await tester.pumpHeroUi(
            Semantics(
              container: true,
              explicitChildNodes: true,
              label: 'Page',
              child: HeroUiFieldLayout(
                axis: axis,
                label: label,
                controlProvidesName: controlProvidesName,
                helperText: 'Help',
                errorText: 'Error',
                invalid: true,
                items: [
                  for (final name in ['Email', 'SMS'])
                    Semantics(
                      container: true,
                      label: name,
                      onTap: () => taps++,
                      child: const SizedBox(width: 48, height: 48),
                    ),
                ],
              ),
            ),
          );
          await tester.pumpAndSettle();

          final hasLayoutName = !controlProvidesName && label == 'Channels';
          final parent = find.semantics
              .byLabel(hasLayoutName ? 'Channels' : 'Page')
              .evaluate()
              .single;
          expect(
            parent
                .debugListChildrenInOrder(
                  DebugSemanticsDumpOrder.traversalOrder,
                )
                .map((node) => node.getSemanticsData().label),
            ['Email', 'SMS', 'Help', 'Error'],
            reason: 'no empty field boundary should interrupt traversal',
          );
          if (controlProvidesName) {
            expect(find.semantics.byLabel('Channels'), findsNothing);
          }
          tester.semantics.tap(find.semantics.byLabel('Email'));
          tester.semantics.tap(find.semantics.byLabel('SMS'));
          expect(taps, 2);
        } finally {
          semantics.dispose();
        }
      });
    }
  }

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
