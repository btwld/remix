import 'package:demo/addons/icon_data_knob.dart';
import 'package:demo/components/icon_button.dart';
import 'package:demo/components/select.dart';
import 'package:demo/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook/widgetbook.dart';

void main() {
  test('icon knob honors initialValue and lets None stay None', () {
    final add = IconDataKnob(label: 'Icon', initialValue: Icons.add);
    final addField = add.fields.single as ObjectDropdownField<IconDataEnum>;
    expect(addField.initialValue, IconDataEnum.add);
    expect(add.valueFromQueryGroup(const {}), Icons.add);
    expect(add.valueFromQueryGroup(const {'Icon': 'add'}), Icons.add);
    expect(add.valueFromQueryGroup(const {'Icon': 'none'}), isNull);
    expect(add.valueFromQueryGroup(const {'Icon': 'home'}), Icons.home);

    final empty = IconDataKnob(label: 'Leading Icon');
    final emptyField = empty.fields.single as ObjectDropdownField<IconDataEnum>;
    expect(emptyField.initialValue, IconDataEnum.none);
    expect(empty.valueFromQueryGroup(const {}), isNull);
    expect(empty.valueFromQueryGroup(const {'Leading Icon': 'none'}), isNull);

    IconData? read(Map<String, String> group) {
      final builder = KnobsBuilder(
        <T>(knob) => knob.valueFromQueryGroup(group),
      );
      return builder.iconData(label: 'Icon', initialValue: Icons.add);
    }

    expect(read(const {}), Icons.add);
    expect(read(const {'Icon': 'none'}), isNull);
  });

  testWidgets('icon button story keeps its icon when None is chosen', (
    tester,
  ) async {
    final state = WidgetbookState(
      root: WidgetbookRoot(children: const []),
      queryParams: {
        'knobs': FieldCodec.encodeQueryGroup({'Icon': 'none'}),
      },
    );
    addTearDown(state.dispose);

    await tester.pumpWidget(
      WidgetbookScope(
        state: state,
        child: const MaterialApp(
          home: FortalTheme(child: Builder(builder: buildIconButtonUseCase)),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(
      tester.widget<FortalIconButton>(find.byType(FortalIconButton)).icon,
      Icons.add,
    );
  });

  testWidgets('select keeps its selection when a knob remounts the story', (
    tester,
  ) async {
    final state = WidgetbookState(
      root: WidgetbookRoot(children: const []),
      queryParams: {},
    );
    addTearDown(state.dispose);

    // Widgetbook rebuilds a story under ValueKey(state.uri), so every knob
    // change remounts it; only a GlobalKey keeps the story's state.
    await tester.pumpWidget(
      WidgetbookScope(
        state: state,
        child: MaterialApp(
          home: FortalTheme(
            child: ListenableBuilder(
              listenable: state,
              builder: (context, _) => KeyedSubtree(
                key: ValueKey(state.uri),
                child: const Builder(builder: buildSelectUseCase),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(RemixSelect<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Banana'));
    await tester.pumpAndSettle();
    expect(find.text('Banana'), findsOneWidget);

    state.updateQueryField(group: 'knobs', field: 'size', value: 'size3');
    await tester.pumpAndSettle();

    final select = tester.widget<FortalSelect<String>>(
      find.byType(FortalSelect<String>),
    );
    expect(select.size, FortalSelectSize.size3);
    expect(select.selectedValue, 'Banana');
  });
}
