import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/date_picker_test_helpers.dart';

const _chevron = IconData(0xe5cf);

Future<void> _open(WidgetTester tester) async {
  await tester.tap(find.byType(RemixButton).first);
  await tester.pumpAndSettle();
}

Widget _picker({
  DateTime? value,
  ValueChanged<DateTime>? onChanged,
  VoidCallback? onClose,
  IconData? trailingIcon,
  RemixButtonTextBuilder? textBuilder,
  Widget Function(BuildContext, DateTime?)? footerBuilder,
  Duration closeDelay = Duration.zero,
}) => RemixDatePicker(
  value: value,
  firstDate: DateTime(2024),
  lastDate: DateTime(2024, 12, 31),
  currentDate: DateTime(2024, 2, 15),
  onChanged: onChanged ?? (_) {},
  onClose: onClose,
  trailingIcon: trailingIcon,
  textBuilder: textBuilder,
  footerBuilder: footerBuilder,
  closeDelay: closeDelay,
);

void main() {
  group('RemixDatePicker host slots', () {
    testWidgets('forwards the trailing icon to the trigger', (tester) async {
      await tester.pumpWidget(pickerHost(_picker(trailingIcon: _chevron)));

      expect(
        tester.widget<RemixButton>(find.byType(RemixButton).first).trailingIcon,
        _chevron,
      );
    });

    testWidgets('builds the trigger text with the text builder', (
      tester,
    ) async {
      await tester.pumpWidget(
        pickerHost(
          _picker(
            value: DateTime(2024, 2, 20),
            textBuilder: (context, spec, text) =>
                Text('[$text]', textDirection: TextDirection.ltr),
          ),
        ),
      );

      expect(
        find.textContaining(RegExp(r'^\[.*February 20.*\]$')),
        findsOneWidget,
      );
    });

    testWidgets('puts the footer under the calendar at its width', (
      tester,
    ) async {
      DateTime? seen;
      await tester.pumpWidget(
        pickerHost(
          _picker(
            value: DateTime(2024, 2, 20),
            footerBuilder: (context, value) {
              seen = value;
              return const SizedBox(height: 24, child: Text('Footer'));
            },
          ),
        ),
      );
      expect(find.text('Footer'), findsNothing);
      await _open(tester);

      final calendar = tester.getRect(find.byType(RemixCalendar));
      final footer = tester.getRect(
        find.ancestor(of: find.text('Footer'), matching: find.byType(SizedBox)),
      );
      expect(seen, DateTime(2024, 2, 20));
      expect(footer.top, calendar.bottom);
      expect(footer.left, calendar.left);
      expect(footer.width, calendar.width);
      expect(footer.height, 24);
    });

    testWidgets('a roomy panel keeps the calendar at its natural height', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      Future<double> calendarHeight(bool withFooter) async {
        await tester.pumpWidget(
          pickerHost(
            _picker(
              footerBuilder: withFooter
                  ? (context, value) => const SizedBox(height: 24)
                  : null,
            ),
          ),
        );
        await _open(tester);
        final height = tester.getSize(find.byType(RemixCalendar)).height;
        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();
        return height;
      }

      expect(await calendarHeight(true), await calendarHeight(false));
    });

    testWidgets('a close delay keeps the popover open after a pick', (
      tester,
    ) async {
      final picked = <DateTime>[];
      var closes = 0;
      await tester.pumpWidget(
        pickerHost(
          _picker(
            onChanged: picked.add,
            onClose: () => closes++,
            closeDelay: const Duration(milliseconds: 300),
          ),
        ),
      );
      await _open(tester);

      await tester.tap(find.text('20'));
      await tester.pump(const Duration(milliseconds: 100));
      expect(picked, [DateTime(2024, 2, 20)]);
      expect(find.byType(RemixCalendar), findsOneWidget);
      expect(closes, 0);

      await tester.tap(find.text('21'));
      await tester.pump(const Duration(milliseconds: 250));
      await tester.pumpAndSettle();
      expect(picked, [DateTime(2024, 2, 20)]);
      expect(find.byType(RemixCalendar), findsNothing);
      expect(closes, 1);
    });

    testWidgets('dismissal during a close delay closes at once', (
      tester,
    ) async {
      await tester.pumpWidget(
        pickerHost(_picker(closeDelay: const Duration(milliseconds: 300))),
      );
      await _open(tester);
      await tester.tap(find.text('20'));
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(find.byType(RemixCalendar), findsNothing);
    });

    testWidgets('reduced motion skips the close delay', (tester) async {
      await tester.pumpWidget(
        pickerHost(
          Builder(
            builder: (context) => MediaQuery(
              data: MediaQuery.of(context).copyWith(disableAnimations: true),
              child: _picker(closeDelay: const Duration(milliseconds: 300)),
            ),
          ),
        ),
      );
      await _open(tester);
      await tester.tap(find.text('20'));
      await tester.pump();
      await tester.pump();

      expect(find.byType(RemixCalendar), findsNothing);
    });

    testWidgets('by default a pick closes at once and there is no footer', (
      tester,
    ) async {
      await tester.pumpWidget(pickerHost(_picker()));
      await _open(tester);
      final panel = tester.getSize(find.byType(RemixCalendar));
      await tester.tap(find.text('20'));
      await tester.pump();
      await tester.pump();

      expect(find.byType(RemixCalendar), findsNothing);
      expect(panel.height, greaterThan(0));
    });
  });

  group('RemixDateRangePicker host slots', () {
    testWidgets('forwards the icon, text builder and footer', (tester) async {
      final range = CivilDateRange(
        start: DateTime(2024, 2, 10),
        end: DateTime(2024, 2, 12),
      );
      CivilDateRange? seen;
      await tester.pumpWidget(
        pickerHost(
          RemixDateRangePicker(
            value: range,
            firstDate: DateTime(2024),
            lastDate: DateTime(2024, 12, 31),
            currentDate: DateTime(2024, 2, 15),
            onChanged: (_) {},
            trailingIcon: _chevron,
            textBuilder: (context, spec, text) =>
                const Text('custom', textDirection: TextDirection.ltr),
            footerBuilder: (context, value) {
              seen = value;
              return const Text('Footer');
            },
          ),
        ),
      );

      expect(
        tester.widget<RemixButton>(find.byType(RemixButton).first).trailingIcon,
        _chevron,
      );
      expect(find.text('custom'), findsOneWidget);
      await _open(tester);
      expect(find.text('Footer'), findsOneWidget);
      expect(seen, range);
    });
  });
}
