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

  testWidgets('select keeps its selection across a knob rebuild', (
    tester,
  ) async {
    late StateSetter rebuild;
    var size = FortalSelectSize.size2;

    await tester.pumpWidget(
      FortalTheme(
        child: WidgetsApp(
          color: const Color(0xFFFFFFFF),
          pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
            settings: settings,
            pageBuilder: (context, _, _) => builder(context),
          ),
          home: StatefulBuilder(
            builder: (context, setState) {
              rebuild = setState;
              return SelectExample(
                variant: .surface,
                size: size,
                placeholder: 'Select item...',
              );
            },
          ),
        ),
      ),
    );

    expect(find.text('Apple'), findsOneWidget);
    expect(find.text('Banana'), findsNothing);

    await tester.tap(find.byType(RemixSelect<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Banana'));
    await tester.pumpAndSettle();

    expect(find.text('Banana'), findsOneWidget);
    expect(find.text('Apple'), findsNothing);

    rebuild(() => size = FortalSelectSize.size3);
    await tester.pump();

    final select = tester.widget<FortalSelect<String>>(
      find.byType(FortalSelect<String>),
    );
    expect(select.selectedValue, 'Banana');
    expect(select.size, FortalSelectSize.size3);
    expect(find.text('Banana'), findsOneWidget);
    expect(find.text('Apple'), findsNothing);
  });
}
