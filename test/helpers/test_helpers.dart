import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

/// Extension methods for WidgetTester to simplify test setup and interactions
extension WidgetTesterHelpers on WidgetTester {
  /// Pumps a Remix widget wrapped in a MaterialApp with Scaffold
  Future<void> pumpRemixApp(Widget widget) async {
    await pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(child: widget),
        ),
      ),
    );
  }

  /// Pumps a widget with custom scaffold
  Future<void> pumpRemixAppWithScaffold(Widget scaffold) async {
    await pumpWidget(MaterialApp(home: scaffold));
  }

  /// Finds a widget by its key string
  Finder findByKey(String key) {
    return find.byKey(ValueKey(key));
  }

  /// Taps a RemixButton by key
  Future<void> tapRemixButton(String key) async {
    await tap(findByKey(key));
    await pump();
  }

  /// Enters text into a RemixTextField by key
  Future<void> enterTextInRemixField(String key, String text) async {
    await tap(findByKey(key));
    await pump();
    await enterText(findByKey(key), text);
    await pump();
  }

  /// Toggles a RemixCheckbox by key
  Future<void> toggleRemixCheckbox(String key) async {
    await tap(findByKey(key));
    await pump();
  }

  /// Toggles a RemixSwitch by key
  Future<void> toggleRemixSwitch(String key) async {
    await tap(findByKey(key));
    await pump();
  }

  /// Selects a RemixRadio option by key
  Future<void> selectRemixRadio(String key) async {
    await tap(findByKey(key));
    await pump();
  }

  /// Long presses a widget by key
  Future<void> longPressWidget(String key) async {
    await longPress(findByKey(key));
    await pump();
  }

  /// Changes orientation
  Future<void> changeOrientation(Orientation orientation) async {
    final size = orientation == Orientation.portrait
        ? const Size(400, 800)
        : const Size(800, 400);
    await binding.setSurfaceSize(size);
    await pumpAndSettle();
  }

  /// Checks if a widget is visible by key
  void expectWidgetVisible(String key) {
    expect(findByKey(key), findsOneWidget);
  }

  /// Checks if text is visible
  void expectTextVisible(String text) {
    expect(find.text(text), findsOneWidget);
  }

  /// Checks if an icon is visible
  void expectIconVisible(IconData icon) {
    expect(find.byIcon(icon), findsOneWidget);
  }

  /// Checks if a widget is not visible by key
  void expectWidgetNotVisible(String key) {
    expect(findByKey(key), findsNothing);
  }

  /// Checks if text is not visible
  void expectTextNotVisible(String text) {
    expect(find.text(text), findsNothing);
  }

  /// Scrolls until a widget is visible
  Future<void> scrollUntilWidgetVisible(
    Finder finder, {
    double delta = 300,
    Finder? scrollable,
    int maxScrolls = 20,
  }) async {
    for (int i = 0; i < maxScrolls; i++) {
      if (finder.evaluate().isNotEmpty) break;

      await drag(
        scrollable ?? find.byType(Scrollable).first,
        Offset(0, -delta),
      );
      await pumpAndSettle();
    }
  }
}

/// Test data builder for consistent test data
class TestDataBuilder {
  static const String defaultButtonKey = 'test_button';
  static const String defaultTextFieldKey = 'test_textfield';
  static const String defaultCheckboxKey = 'test_checkbox';
  static const String defaultSwitchKey = 'test_switch';
  static const String defaultRadioKey = 'test_radio';
  static const String defaultSliderKey = 'test_slider';
  static const String defaultSelectKey = 'test_select';

  static const String sampleLabel = 'Test Label';
  static const String sampleText = 'Sample Text';
  static const String sampleError = 'Error Message';
  static const String sampleHint = 'Hint Text';
  static const String sampleHelper = 'Helper Text';
}

/// Performance test helper
class PerformanceTestHelper {
  /// Measures widget build time
  static Future<void> measureWidgetBuildTime(
    WidgetTester tester,
    Widget widget,
    String widgetName,
  ) async {
    final stopwatch = Stopwatch()..start();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(child: widget),
        ),
      ),
    );
    stopwatch.stop();
    print('$widgetName build time: ${stopwatch.elapsedMilliseconds}ms');
  }

  /// Measures interaction response time
  static Future<void> measureInteractionResponseTime(
    WidgetTester tester,
    Future<void> Function() interaction,
    String interactionName,
  ) async {
    final stopwatch = Stopwatch()..start();
    await interaction();
    stopwatch.stop();
    print('$interactionName response time: ${stopwatch.elapsedMilliseconds}ms');
  }
}