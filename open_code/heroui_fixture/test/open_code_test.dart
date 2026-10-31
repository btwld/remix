import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_code_fixture/main.dart';
import 'package:open_code_fixture/ui/ui.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_fonts/remix_ui_fonts.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

void main() {
  group('gallery', () {
    setUpAll(_loadGeist);

    for (final width in [1024.0, 375.0]) {
      testWidgets('renders in both modes at ${width.round()} logical pixels', (
        tester,
      ) async {
        await _pumpGallery(tester, width: width);
        expect(find.byType(AcmeCard), findsWidgets);
        expect(_theme(tester).brightness, Brightness.light);
        final light = _background(tester);

        await tester.tap(find.byType(AcmeSwitch).first);
        await tester.pump(const Duration(milliseconds: 300));
        expect(_theme(tester).brightness, Brightness.dark);
        expect(_background(tester), isNot(light));
        expect(tester.takeException(), isNull);

        await tester.tap(find.byType(AcmeSwitch).first);
        await tester.pump(const Duration(milliseconds: 300));
        expect(_theme(tester).brightness, Brightness.light);
        expect(_background(tester), light);
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('a checkbox label toggles its checkbox', (tester) async {
      await _pumpGallery(tester, width: 1024);
      bool selected() =>
          tester
              .widget<AcmeCheckbox>(find.byType(AcmeCheckbox).first)
              .selected ==
          true;
      expect(selected(), isTrue);

      await _tap(tester, find.text('Accept terms'));
      expect(selected(), isFalse);
    });

    testWidgets('choosing a tab shows its panel', (tester) async {
      await _pumpGallery(tester, width: 1024);
      expect(find.text('Panel: overview'), findsOneWidget);

      await _tap(tester, find.text('Usage').first);
      expect(find.text('Panel: usage'), findsOneWidget);
      expect(find.text('Panel: overview'), findsNothing);
    });

    testWidgets('choosing a select item selects its value', (tester) async {
      await _pumpGallery(tester, width: 1024);
      AcmeSelect<String> select() =>
          tester.widget(find.byType(AcmeSelect<String>).first);
      expect(select().selectedValue, isNull);

      await _tap(tester, find.text('Choose a fruit').first);
      await _tap(tester, find.text('Banana'));
      expect(select().selectedValue, 'banana');
      expect(tester.takeException(), isNull);
    });

    testWidgets('the modal opens and closes from its actions', (tester) async {
      await _pumpGallery(tester, width: 1024);

      await _tap(tester, find.text('Open modal'));
      expect(find.byType(AcmeModal), findsOneWidget);
      expect(find.text('Delete project?'), findsOneWidget);

      await _tap(tester, find.text('Cancel'));
      expect(find.byType(AcmeModal), findsNothing);
    });

    testWidgets('a button opens a popover and its action closes it', (
      tester,
    ) async {
      await _pumpGallery(tester, width: 1024);
      expect(find.text('Share project'), findsNothing);

      await _tap(tester, find.text('Open popover'));
      expect(find.text('Share project'), findsOneWidget);
      // The surface wraps its content instead of filling the overlay.
      final content = find.ancestor(
        of: find.text('Copy link'),
        matching: find.byType(Column),
      );
      expect(tester.getSize(content.first).height, lessThan(120));

      await _tap(tester, find.text('Copy link'));
      expect(find.text('Share project'), findsNothing);
      // The button shares its focus node with the popover, so it takes focus
      // back.
      expect(_focused('Open popover'), findsOneWidget);
    });

    testWidgets('the dropdown button opens its menu and a row reports its '
        'action', (tester) async {
      await _pumpGallery(tester, width: 1024);
      expect(find.text('Last action: none'), findsOneWidget);

      await _tap(tester, find.text('Actions'));
      expect(find.text('Duplicate'), findsOneWidget);

      await _tap(tester, find.text('Duplicate'));
      expect(find.text('Last action: copy'), findsOneWidget);
      expect(_focused('Actions'), findsOneWidget);
    });

    testWidgets('gallery dropdown has one button, tab stop and expanded node', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      try {
        await _pumpGallery(tester, width: 1024);
        await tester.ensureVisible(find.text('Actions'));
        await tester.pump();

        expect(
          find.descendant(
            of: find.byType(AcmeDropdown<String>),
            matching: find.byType(AcmeButton),
          ),
          findsOneWidget,
          reason: 'the installed Gallery supplies the styled control itself',
        );
        await _expectOneTabStop(tester, 'Actions');
        expect(find.semantics.byLabel('Actions'), findsOne);
        expect(
          tester.getSemantics(find.text('Actions')),
          isSemantics(
            label: 'Actions',
            isButton: true,
            hasTapAction: true,
            hasExpandedState: true,
            isExpanded: false,
          ),
        );
        tester.semantics.tap(find.semantics.byLabel('Actions'));
        await tester.pump(const Duration(milliseconds: 400));
        expect(find.text('Duplicate'), findsOneWidget);
        expect(find.semantics.byLabel('Actions'), findsOne);
        expect(
          tester.getSemantics(find.text('Actions')),
          isSemantics(
            label: 'Actions',
            hasExpandedState: true,
            isExpanded: true,
          ),
        );
        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pump(const Duration(milliseconds: 400));
        expect(_galleryButtonFocus(tester, 'Actions').hasPrimaryFocus, isTrue);
      } finally {
        semantics.dispose();
      }
    });

    testWidgets('gallery popover returns focus to its own single control', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      try {
        await _pumpGallery(tester, width: 1024);
        await tester.ensureVisible(find.text('Open popover'));
        await tester.pump();
        await _expectOneTabStop(tester, 'Open popover');

        // Remix merges the popover's expanded state onto the caller's button.
        expect(find.semantics.byLabel('Open popover'), findsOne);
        expect(
          tester.getSemantics(find.text('Open popover')),
          isSemantics(
            label: 'Open popover',
            isButton: true,
            hasTapAction: true,
            hasExpandedState: true,
            isExpanded: false,
          ),
        );

        // Opening without clicking the trigger distinguishes the Gallery's
        // explicit shared-node wiring from incidental previous-focus return.
        _galleryButtonFocus(tester, 'Open popover').unfocus();
        await tester.pump();
        final popover = tester.widget<AcmePopover>(find.byType(AcmePopover));
        popover.controller!.open();
        await tester.pump(const Duration(milliseconds: 400));
        expect(find.text('Share project'), findsOneWidget);
        expect(
          tester.getSemantics(find.text('Open popover')),
          isSemantics(
            label: 'Open popover',
            hasExpandedState: true,
            isExpanded: true,
          ),
        );
        popover.controller!.close();
        await tester.pump(const Duration(milliseconds: 400));
        expect(find.text('Share project'), findsNothing);
        expect(
          tester.getSemantics(find.text('Open popover')),
          isSemantics(
            label: 'Open popover',
            hasExpandedState: true,
            isExpanded: false,
          ),
        );
        expect(
          _galleryButtonFocus(tester, 'Open popover').hasPrimaryFocus,
          isTrue,
        );
      } finally {
        semantics.dispose();
      }
    });

    testWidgets('a toast appears from the app-level scope', (tester) async {
      await _pumpGallery(tester, width: 1024);

      await _tap(tester, find.text('Show toast'));
      expect(find.text('Draft saved'), findsOneWidget);

      await tester.pump(const Duration(seconds: 6));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Draft saved'), findsNothing);
    });
  });

  testWidgets('every installed Acme widget builds below AcmeTheme', (
    tester,
  ) async {
    final seen = <String>{};

    for (final widgetCase in _cases) {
      await tester.pumpWidget(_host(widgetCase.child));
      await tester.pump();

      for (final type in widgetCase.types) {
        expect(
          find.byType(type),
          findsOneWidget,
          reason: '${widgetCase.name} must build $type',
        );
        seen.add(_name(type));
      }
      expect(
        tester.takeException(),
        isNull,
        reason: '${widgetCase.name} must build without framework errors',
      );
    }

    expect(
      seen,
      _installedWidgetNames(),
      reason: 'every installed widget needs a case',
    );
    await tester.pumpWidget(const SizedBox.shrink());
  });
}

/// Tests draw every family as Ahem unless it is loaded. The gallery sets
/// Geist, so load it to lay the narrow screen out with real glyph widths.
Future<void> _loadGeist() async {
  final loader = FontLoader(RemixFonts.geist);
  for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
    loader.addFont(
      rootBundle.load(
        'packages/remix_ui_fonts/lib/fonts/geist/Geist-$weight.ttf',
      ),
    );
  }
  await loader.load();
}

Future<void> _pumpGallery(WidgetTester tester, {required double width}) async {
  tester.view
    ..physicalSize = Size(width, 900)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(const AcmeApp());
  // Spinners and skeletons animate forever, so never wait for a settle.
  await tester.pump(const Duration(milliseconds: 100));
  expect(tester.takeException(), isNull);
}

AcmeThemeData _theme(WidgetTester tester) =>
    AcmeTheme.of(tester.element(find.byType(Gallery)));

/// The page background the Mix tokens resolve to below the theme.
Color _background(WidgetTester tester) =>
    AcmeTokens.background.resolve(tester.element(find.byType(Gallery)));

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pump();
  await tester.tap(finder);
  await tester.pump(const Duration(milliseconds: 400));
}

Future<void> _expectOneTabStop(WidgetTester tester, String label) async {
  final control = _galleryButtonFocus(tester, label);
  control.requestFocus();
  await tester.pump();
  expect(control.hasPrimaryFocus, isTrue);

  await tester.sendKeyEvent(LogicalKeyboardKey.tab);
  await tester.pump();
  expect(control.hasFocus, isFalse);
  await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
  await tester.sendKeyEvent(LogicalKeyboardKey.tab);
  await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
  await tester.pump();
  expect(
    control.hasPrimaryFocus,
    isTrue,
    reason: '$label has exactly one tab stop',
  );
}

FocusNode _galleryButtonFocus(WidgetTester tester, String label) {
  final button = tester.widget<AcmeButton>(
    find.ancestor(of: find.text(label), matching: find.byType(AcmeButton)),
  );
  expect(
    button.focusNode,
    isNotNull,
    reason: 'the Gallery attaches the trigger-owned node to its actual button',
  );
  return button.focusNode!;
}

/// [label] inside the control that has primary focus.
Finder _focused(String label) => find.descendant(
  of: find.byElementPredicate(
    (element) => element == FocusManager.instance.primaryFocus?.context,
  ),
  matching: find.text(label),
);

Widget _host(Widget child) {
  return WidgetsApp(
    color: const Color(0xFFFFFFFF),
    pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, _, _) => builder(context),
    ),
    builder: (context, navigator) => AcmeTheme(child: navigator!),
    home: Center(child: SizedBox(width: 640, height: 480, child: child)),
  );
}

/// The class name without type arguments: `AcmeSelect<String>` is
/// `AcmeSelect`.
String _name(Type type) => type.toString().split('<').first;

/// Every public widget class the installed components declare, read from the
/// consumer's own source so a newly installed widget fails here until it has a
/// case.
Set<String> _installedWidgetNames() {
  final declaration = RegExp(
    r'^class (Acme\w+)(?:<[^{]*?>)? extends StatelessWidget',
    multiLine: true,
  );
  return {
    for (final file in Directory('lib/ui/components').listSync())
      if (file is File && file.path.endsWith('.dart'))
        for (final match in declaration.allMatches(file.readAsStringSync()))
          match[1]!,
  };
}

final _cases = <_WidgetCase>[
  _WidgetCase(
    'accordion',
    AcmeAccordionGroup<String>(
      controller: RemixAccordionController<String>(),
      child: const AcmeAccordion<String>(
        value: 'item',
        title: 'Item',
        child: Text('Content'),
      ),
    ),
    {AcmeAccordionGroup<String>, AcmeAccordion<String>},
  ),
  const _WidgetCase('alert', AcmeAlert(text: 'Notice'), {AcmeAlert}),
  const _WidgetCase('avatar', AcmeAvatar(label: 'AB'), {AcmeAvatar}),
  const _WidgetCase(
    'avatar group',
    AcmeAvatarGroup(children: [AcmeAvatar(label: 'AB')]),
    {AcmeAvatarGroup},
  ),
  const _WidgetCase(
    'badge',
    AcmeBadge(
      label: '3',
      child: AcmeAvatar(label: 'AB'),
    ),
    {AcmeBadge},
  ),
  const _WidgetCase(
    'breadcrumbs',
    AcmeBreadcrumbs(items: [AcmeBreadcrumb('Home'), AcmeBreadcrumb('Docs')]),
    {AcmeBreadcrumbs},
  ),
  const _WidgetCase('button', AcmeButton(label: 'Save'), {AcmeButton}),
  _WidgetCase(
    'button group',
    AcmeButtonGroup(
      buttons: [
        (context, style) => RemixButton(label: 'One', style: style),
        (context, style) => RemixButton(label: 'Two', style: style),
      ],
    ),
    {AcmeButtonGroup},
  ),
  const _WidgetCase(
    'card',
    AcmeCard(
      child: Column(
        children: [AcmeCardTitle('Title'), AcmeCardDescription('Body')],
      ),
    ),
    {AcmeCard, AcmeCardTitle, AcmeCardDescription},
  ),
  const _WidgetCase(
    'checkbox',
    AcmeCheckbox(selected: false, label: 'Choice'),
    {AcmeCheckbox},
  ),
  const _WidgetCase(
    'checkbox group',
    AcmeCheckboxGroup<String>(
      values: {},
      options: [AcmeCheckboxOption(value: 'a', label: 'Choice A')],
    ),
    {AcmeCheckboxGroup<String>, AcmeCheckboxGroupItem<String>},
  ),
  const _WidgetCase('chip', AcmeChip(label: 'New'), {AcmeChip}),
  const _WidgetCase('close button', AcmeCloseButton(), {AcmeCloseButton}),
  const _WidgetCase(
    'disclosure',
    AcmeDisclosure(trigger: Text('More'), content: Text('Details')),
    {AcmeDisclosure},
  ),
  const _WidgetCase(
    'dropdown',
    AcmeDropdown<String>(
      trigger: RemixMenuTrigger(label: 'Menu'),
      items: [RemixMenuItem(value: 'a', label: 'A')],
    ),
    {AcmeDropdown<String>},
  ),
  const _WidgetCase(
    'icon button',
    AcmeIconButton(icon: RemixIcons.plus, semanticLabel: 'Add'),
    {AcmeIconButton},
  ),
  const _WidgetCase(
    'input group',
    AcmeInputGroup(label: 'Website', leading: Text('https://')),
    {AcmeInputGroup},
  ),
  const _WidgetCase('kbd', AcmeKbd(keys: ['Ctrl', 'K']), {AcmeKbd}),
  const _WidgetCase('link', AcmeLink(label: 'Docs'), {AcmeLink}),
  const _WidgetCase('modal', AcmeModal(title: 'Dialog'), {AcmeModal}),
  const _WidgetCase(
    'popover',
    AcmePopover(popoverChild: Text('Content'), child: Text('Open')),
    {AcmePopover},
  ),
  const _WidgetCase('progress', AcmeProgress(value: 0.5), {AcmeProgress}),
  const _WidgetCase(
    'radio group',
    AcmeRadioGroup<String>(
      groupValue: 'a',
      options: [AcmeRadioOption(value: 'a', label: 'Choice A')],
    ),
    {
      AcmeRadioGroup<String>,
      AcmeFieldLayout,
      AcmeDescribedControl,
      AcmeRadio<String>,
    },
  ),
  const _WidgetCase(
    'search field',
    AcmeSearchField(
      hintText: 'Search',
      leading: AcmeSearchIcon(),
      trailing: AcmeSearchClearButton(),
    ),
    {AcmeSearchField, AcmeSearchIcon, AcmeSearchClearButton},
  ),
  const _WidgetCase(
    'select',
    AcmeSelect<String>(
      trigger: RemixSelectTrigger(placeholder: 'Pick'),
      items: [RemixSelectItem(value: 'a', label: 'A')],
    ),
    {AcmeSelect<String>},
  ),
  const _WidgetCase('separator', AcmeSeparator(), {AcmeSeparator}),
  const _WidgetCase(
    'skeleton',
    AcmeSkeleton(child: SizedBox(width: 80, height: 20)),
    {AcmeSkeleton},
  ),
  const _WidgetCase('slider', AcmeSlider(value: 0.5), {AcmeSlider}),
  const _WidgetCase('spinner', AcmeSpinner(), {AcmeSpinner}),
  const _WidgetCase('surface', AcmeSurface(child: Text('Surface')), {
    AcmeSurface,
  }),
  const _WidgetCase(
    'switch group',
    AcmeSwitchGroup(
      items: [AcmeSwitchOption(selected: false, label: 'Alerts')],
    ),
    {AcmeSwitchGroup, AcmeSwitch},
  ),
  const _WidgetCase(
    'table',
    AcmeTable<String>(
      rows: [],
      columns: [
        RemixDataTableColumn<String>(
          id: 'value',
          label: 'Value',
          cellBuilder: _stringCell,
        ),
      ],
    ),
    {AcmeTable<String>},
  ),
  const _WidgetCase(
    'tabs',
    RemixTabs(
      selectedTabId: 'a',
      child: Column(
        children: [
          AcmeTabBar(
            child: Row(
              children: [AcmeTab(tabId: 'a', label: 'A')],
            ),
          ),
          AcmeTabView(tabId: 'a', child: Text('A view')),
        ],
      ),
    ),
    {AcmeTabBar, AcmeTab, AcmeTabView},
  ),
  const _WidgetCase('text area', AcmeTextArea(label: 'Notes'), {AcmeTextArea}),
  const _WidgetCase('text field', AcmeTextField(label: 'Name'), {
    AcmeTextField,
  }),
  const _WidgetCase('toast', AcmeToast(title: 'Draft saved'), {AcmeToast}),
  const _WidgetCase(
    'toggle button',
    AcmeToggleButton(selected: false, label: 'Bold'),
    {AcmeToggleButton},
  ),
  const _WidgetCase(
    'toggle button group',
    AcmeToggleButtonGroup<String>(
      items: [RemixToggleGroupItem(value: 'a', label: 'A')],
      selectedValue: 'a',
    ),
    {AcmeToggleButtonGroup<String>},
  ),
  const _WidgetCase(
    'tooltip',
    AcmeTooltip(tooltipChild: Text('Help'), child: Text('Hover')),
    {AcmeTooltip},
  ),
  const _WidgetCase('typography', AcmeTypography('Heading', type: .h2), {
    AcmeTypography,
  }),
];

final class _WidgetCase {
  const _WidgetCase(this.name, this.child, this.types);

  final String name;
  final Widget child;
  final Set<Type> types;
}

Widget _stringCell(BuildContext context, String value) => Text(value);
