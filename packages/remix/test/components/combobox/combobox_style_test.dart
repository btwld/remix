import 'package:flutter/widgets.dart';
import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:naked_ui/naked_ui.dart' show NakedComboboxOption;
import 'combobox_test_host.dart';

void main() {
  testWidgets('panel effects reach the rendering adapter', (tester) async {
    await tester.pumpWidget(
      comboboxHost(
        RemixCombobox<String>(
          optionsBuilder: (_) => suggestions,
          style: testComboboxStyle().panel(
            ComboboxPanelStyler().containerEffects(
              .outline(.color(const Color(0xFFFF0000)).width(2)),
            ),
          ),
        ),
      ),
    );
    await openCombobox(tester);
    expect(
      find.byWidgetPredicate(
        (w) => w.runtimeType.toString() == '_RemixBoxEffectsRenderer',
      ),
      findsOneWidget,
    );
  });

  testWidgets('panel styles own the viewport bound and render effects', (
    tester,
  ) async {
    await tester.pumpWidget(
      comboboxHost(
        RemixCombobox<String>(
          optionsBuilder: (_) => List.generate(24, (i) => 'Suggestion $i'),
          style: testComboboxStyle().panel(
            ComboboxPanelStyler()
                .maxHeight(360)
                .containerEffects(
                  .outline(.color(const Color(0xFFFF0000)).width(2)),
                ),
          ),
        ),
      ),
    );
    await openCombobox(tester);
    expect(tester.getSize(find.byType(SingleChildScrollView).last).height, 360);
    expect(
      find.byWidgetPredicate(
        (w) => w.runtimeType.toString() == '_RemixBoxEffectsRenderer',
      ),
      findsOneWidget,
    );
  });

  testWidgets(
    'field projection retains inherited and parent variants in editor states',
    (tester) async {
      await tester.pumpWidget(
        comboboxHost(
          StyleProvider<TextFieldSpec>(
            style: TextFieldStyler().cursorWidth(3).cursorHeight(32),
            child: StyleProvider<ComboboxSpec>(
              style: ComboboxStyler()
                  .onBuilder(
                    (context) => ComboboxStyler().field(
                      TextFieldStyler().cursorWidth(
                        MediaQuery.textScalerOf(context).scale(4),
                      ),
                    ),
                  )
                  .onHovered(.field(TextFieldStyler().cursorHeight(25))),
              child: RemixCombobox<String>(
                optionsBuilder: (_) => const [],
                style: ComboboxStyler()
                    .width(280)
                    .field(
                      TextFieldStyler()
                          .textAlign(.end)
                          .cursorColor(const Color(0xFFFF0000))
                          .onHovered(.cursorColor(const Color(0xFF0000FF))),
                    ),
              ),
            ),
          ),
          scale: 1.25,
        ),
      );
      EditableText editor() =>
          tester.widget<EditableText>(find.byType(EditableText));
      expect(editor().cursorWidth, 5);
      expect(editor().cursorHeight, 32);
      expect(editor().textAlign, TextAlign.end);
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: const Offset(700, 500));
      await mouse.moveTo(tester.getCenter(find.byType(EditableText)));
      await tester.pumpAndSettle();
      expect(editor().cursorWidth, 5);
      expect(editor().cursorHeight, 25);
      expect(editor().cursorColor, const Color(0xFF0000FF));
      expect(editor().textAlign, TextAlign.end);
      await mouse.moveTo(const Offset(700, 500));
      await tester.pumpAndSettle();
      expect(editor().cursorHeight, 32);
      expect(editor().cursorColor, const Color(0xFFFF0000));
      await mouse.removePointer();
    },
  );

  testWidgets(
    'field animation and modifier survive TextField base-style merging once',
    (tester) async {
      await tester.pumpWidget(
        comboboxHost(
          RemixCombobox<String>(
            optionsBuilder: (_) => const [],
            style: ComboboxStyler()
                .width(280)
                .wrap(.opacity(0.4))
                .animate(.linear(const Duration(milliseconds: 20)))
                .field(
                  TextFieldStyler()
                      .cursorWidth(2)
                      .onHovered(.cursorWidth(10))
                      .wrap(.opacity(0.6))
                      .animate(.linear(const Duration(milliseconds: 100))),
                ),
          ),
        ),
      );
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: const Offset(700, 500));
      await mouse.moveTo(tester.getCenter(find.byType(EditableText)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      final width = tester
          .widget<EditableText>(find.byType(EditableText))
          .cursorWidth;
      expect(width, greaterThan(2));
      expect(width, lessThan(10));
      await tester.pumpAndSettle();
      expect(
        tester.widget<EditableText>(find.byType(EditableText)).cursorWidth,
        10,
      );
      for (final opacity in [0.4, 0.6]) {
        expect(
          find.byWidgetPredicate(
            (widget) => widget is Opacity && widget.opacity == opacity,
          ),
          findsOneWidget,
        );
      }
      await mouse.removePointer();
      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    'inherited context variants and local slot overrides survive overlays',
    (tester) async {
      final inherited = ComboboxStyler()
          .option(
            ComboboxOptionStyler().label(
              TextStyler().fontFamily('InheritedFont').fontSize(19),
            ),
          )
          .onBuilder(
            (context) => ComboboxStyler().option(
              ComboboxOptionStyler().label(
                TextStyler().fontSize(
                  MediaQuery.textScalerOf(context).scale(20),
                ),
              ),
            ),
          );
      await tester.pumpWidget(
        comboboxHost(
          StyleProvider<ComboboxSpec>(
            style: inherited,
            child: RemixCombobox<String>(
              optionsBuilder: (_) => suggestions,
              style: ComboboxStyler()
                  .width(280)
                  .option(
                    ComboboxOptionStyler().label(
                      TextStyler().color(const Color(0xFFAA0000)),
                    ),
                  ),
            ),
          ),
          scale: 1.25,
        ),
      );
      await openCombobox(tester);
      final label = tester.widget<RichText>(
        find.descendant(
          of: find.text('Apple'),
          matching: find.byType(RichText),
        ),
      );
      expect(label.text.style!.fontSize, 25);
      expect(label.text.style!.fontFamily, 'InheritedFont');
      expect(label.text.style!.color, const Color(0xFFAA0000));
    },
  );

  testWidgets('root modifier and animation occur once with eager rows', (
    tester,
  ) async {
    await tester.pumpWidget(
      comboboxHost(
        RemixCombobox<String>(
          optionsBuilder: (_) => suggestions,
          style: testComboboxStyle()
              .wrap(.opacity(0.4))
              .animate(.linear(const Duration(milliseconds: 20))),
        ),
      ),
    );
    await openCombobox(tester);
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Opacity && widget.opacity == 0.4,
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget.runtimeType.toString() ==
            'StyleAnimationBuilder<ComboboxSpec>',
      ),
      findsOneWidget,
    );
    expect(find.text('Apple'), findsOneWidget);
    expect(find.text('Apricot'), findsOneWidget);
    expect(find.text('Avocado'), findsOneWidget);
  });

  for (final (style, expected) in [
    (ComboboxStyler().width(240), 240.0),
    (ComboboxStyler().minWidth(220).maxWidth(260), 260.0),
  ]) {
    testWidgets(
      'ordinary width/min/max constraints produce $expected px editor',
      (tester) async {
        await tester.pumpWidget(
          comboboxHost(
            RemixCombobox<String>(
              optionsBuilder: (_) => suggestions,
              style: style,
            ),
          ),
        );
        expect(tester.getSize(find.byType(RemixTextField)).width, expected);
        await openCombobox(tester);
        final panel = tester.getRect(find.byType(SingleChildScrollView).last);
        expect(panel.width, expected);
      },
    );
  }

  testWidgets('320px RTL at scale 2 grows long rows and eagerly reveals last', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final values = List.generate(
      18,
      (i) => 'مدينة طويلة الاسم للبحث والاختيار رقم $i',
    );
    await tester.pumpWidget(
      comboboxHost(
        RemixCombobox<String>(
          label: 'المدينة',
          optionsBuilder: (_) => values,
          style: testComboboxStyle().width(296),
        ),
        direction: TextDirection.rtl,
        scale: 2,
      ),
    );
    await openCombobox(tester);
    final viewport = tester.getRect(find.byType(SingleChildScrollView).last);
    expect(viewport.left, greaterThanOrEqualTo(0));
    expect(viewport.right, lessThanOrEqualTo(320));
    expect(viewport.height, lessThanOrEqualTo(288));
    final first = tester.getRect(find.text(values.first));
    expect(first.height, greaterThan(48));
    expect(first.left, greaterThanOrEqualTo(viewport.left));
    expect(first.right, lessThanOrEqualTo(viewport.right));
    for (final align in tester.widgetList<Align>(
      find.descendant(
        of: find.byType(SingleChildScrollView).last,
        matching: find.byType(Align),
      ),
    )) {
      expect(align.alignment, AlignmentDirectional.centerStart);
    }
    Actions.invoke(
      tester.element(find.byType(EditableText)),
      const AutocompleteLastOptionIntent(),
    );
    await tester.pumpAndSettle();
    final last = tester.getRect(find.text(values.last));
    expect(last.top, greaterThanOrEqualTo(viewport.top));
    expect(last.bottom, lessThanOrEqualTo(viewport.bottom));
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'default rows have 48px hit targets and initialValue is text only',
    (tester) async {
      NakedComboboxState<String>? snapshot;
      await tester.pumpWidget(
        comboboxHost(
          RemixCombobox<String>(
            initialValue: const TextEditingValue(text: 'Apple'),
            optionsBuilder: (_) => suggestions,
            fieldBuilder: (_, state, controller, focus, submit) {
              snapshot = state;
              return RemixTextField(
                controller: controller,
                focusNode: focus,
                onSubmitted: (_) => submit(),
              );
            },
          ),
        ),
      );
      expect(snapshot!.text, 'Apple');
      expect(snapshot!.value, isNull);
      await openCombobox(tester);
      final rows = tester.widgetList<Align>(
        find.descendant(
          of: find.byType(SingleChildScrollView).last,
          matching: find.byType(Align),
        ),
      );
      expect(rows.length, 3);
      for (final element
          in find
              .descendant(
                of: find.byType(SingleChildScrollView).last,
                matching: find.byType(NakedComboboxOption<String>),
              )
              .evaluate()) {
        expect(
          (element.findRenderObject()! as RenderBox).size.height,
          greaterThanOrEqualTo(48),
        );
      }
    },
  );
}
