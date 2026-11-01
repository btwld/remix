import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/heroui.dart';
import 'package:remix/remix.dart';
import '../helpers/heroui_long_content.dart';

Widget sweepCase(String name) => switch (name) {
  'chip' => const HeroUiChip(label: longHeroUiAction),
  'alert' => const HeroUiAlert(text: longHeroUiLabel, icon: IconData(0xe000)),
  'input' => const HeroUiTextField(
    label: longHeroUiLabel,
    hintText: longHeroUiAction,
    helperText: longHeroUiLabel,
  ),
  'textarea' => const HeroUiTextArea(
    label: longHeroUiLabel,
    hintText: longHeroUiAction,
    helperText: longHeroUiLabel,
  ),
  'input-group' => const HeroUiInputGroup(
    label: longHeroUiLabel,
    hintText: longHeroUiAction,
    helperText: longHeroUiLabel,
    leading: Text('Email'),
    trailing: Text('Verified'),
  ),
  'card' => const HeroUiCard(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeroUiCardTitle(longHeroUiLabel),
        HeroUiCardDescription(longHeroUiAction),
        Text(longHeroUiLabel),
      ],
    ),
  ),
  'menu' => HeroUiDropdown<String>(
    trigger: const RemixMenuTrigger(label: longHeroUiLabel),
    onSelected: (_) {},
    items: const [
      RemixMenuItem(value: 'one', label: longHeroUiAction),
      RemixMenuItem(value: 'two', label: 'Security and account management'),
    ],
  ),
  'toggle' => HeroUiToggleButton(
    label: longHeroUiLabel,
    selected: false,
    onChanged: (_) {},
  ),
  _ => throw ArgumentError(name),
};

void main() {
  setUpAll(loadHeroUiGeist);
  for (final mode in ['light', 'dark']) {
    for (final width in [375.0, 1024.0]) {
      for (final name in [
        'chip',
        'alert',
        'input',
        'textarea',
        'input-group',
        'card',
        'menu',
        'toggle',
      ]) {
        testWidgets('$name $mode $width', (tester) async {
          await pumpHeroUiLongContent(
            tester,
            sweepCase(name),
            width: width,
            mode: mode,
          );
          if (name == 'menu') {
            await tester.tap(find.text(longHeroUiLabel));
            await tester.pumpAndSettle();
          }
          expect(tester.takeException(), isNull);
          final viewport = name == 'menu'
              ? Rect.fromLTWH(0, 0, width, 768)
              : tester.getRect(find.byType(sweepCase(name).runtimeType));
          for (final text in find.byType(Text).evaluate()) {
            final widget = text.widget as Text;
            if (widget.data?.isNotEmpty == true) {
              expectHeroUiTextInside(tester, find.byWidget(widget), viewport);
            }
          }
          if (['input', 'textarea', 'input-group'].contains(name)) {
            final editable = find.byType(EditableText);
            await tester.enterText(editable, longHeroUiAction);
            await tester.pumpAndSettle();
            final RenderEditable render = tester
                .state<EditableTextState>(editable)
                .renderEditable;
            final rect = render.localToGlobal(Offset.zero) & render.size;
            expect(rect.left, greaterThanOrEqualTo(viewport.left));
            expect(rect.right, lessThanOrEqualTo(viewport.right));
            expect(rect.top, greaterThanOrEqualTo(viewport.top));
            expect(rect.bottom, lessThanOrEqualTo(viewport.bottom));
            expect(
              tester.widget<EditableText>(editable).controller.text,
              longHeroUiAction,
            );
            expect(tester.takeException(), isNull);
          }
        });
      }
    }
  }
}
