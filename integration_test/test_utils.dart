import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:remix/remix.dart';

/// Base class for integration test setup
class IntegrationTestHelper {
  static void setupBinding() {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  }
}

/// Extension methods for WidgetTester to simplify integration testing
extension IntegrationTestExtensions on WidgetTester {
  /// Pumps a widget wrapped in a MaterialApp with Remix theme
  Future<void> pumpRemixApp(Widget child) async {
    await pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: child,
          ),
        ),
      ),
    );
  }

  /// Pumps a widget wrapped in a MaterialApp with custom scaffold
  Future<void> pumpRemixAppWithScaffold(Widget scaffold) async {
    await pumpWidget(
      MaterialApp(
        home: scaffold,
      ),
    );
  }

  /// Waits for animations to complete with a timeout
  Future<void> pumpAndSettleWithTimeout({
    Duration timeout = const Duration(seconds: 10),
  }) async {
    await pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      timeout,
    );
  }

  /// Finds a widget by its key
  Finder findByKey(String key) {
    return find.byKey(ValueKey(key));
  }

  /// Scrolls until a widget is visible
  Future<void> scrollUntilVisible(
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

  /// Types text into a RemixTextField
  Future<void> enterTextInRemixField(String key, String text) async {
    final textFieldFinder = findByKey(key);
    await tap(textFieldFinder);
    await pumpAndSettle();
    await enterText(textFieldFinder, text);
    await pumpAndSettle();
  }

  /// Taps a RemixButton by key
  Future<void> tapRemixButton(String key) async {
    final buttonFinder = findByKey(key);
    await tap(buttonFinder);
    await pumpAndSettle();
  }

  /// Toggles a RemixCheckbox by key
  Future<void> toggleRemixCheckbox(String key) async {
    final checkboxFinder = findByKey(key);
    await tap(checkboxFinder);
    await pumpAndSettle();
  }

  /// Toggles a RemixSwitch by key
  Future<void> toggleRemixSwitch(String key) async {
    final switchFinder = findByKey(key);
    await tap(switchFinder);
    await pumpAndSettle();
  }

  /// Selects a RemixRadio option by key
  Future<void> selectRemixRadio(String key) async {
    final radioFinder = findByKey(key);
    await tap(radioFinder);
    await pumpAndSettle();
  }

  /// Drags a RemixSlider to a specific value
  Future<void> dragRemixSlider(String key, {required double dx}) async {
    final sliderFinder = findByKey(key);
    final center = getCenter(sliderFinder);
    final gesture = await startGesture(center);
    await gesture.moveBy(Offset(dx, 0));
    await gesture.up();
    await pumpAndSettle();
  }

  /// Opens a RemixSelect dropdown by key
  Future<void> openRemixSelect(String key) async {
    final selectFinder = findByKey(key);
    await tap(selectFinder);
    await pumpAndSettle();
  }

  /// Selects an option from an open RemixSelect dropdown
  Future<void> selectRemixOption(String optionText) async {
    final optionFinder = find.text(optionText);
    await tap(optionFinder);
    await pumpAndSettle();
  }

  /// Expands or collapses a RemixAccordion item by key
  Future<void> toggleRemixAccordion(String key) async {
    final accordionFinder = findByKey(key);
    await tap(accordionFinder);
    await pumpAndSettle();
  }

  /// Verifies text is visible on screen
  void expectTextVisible(String text) {
    expect(find.text(text), findsOneWidget);
  }

  /// Verifies text is not visible on screen
  void expectTextNotVisible(String text) {
    expect(find.text(text), findsNothing);
  }

  /// Verifies a widget with specific key is visible
  void expectWidgetVisible(String key) {
    expect(findByKey(key), findsOneWidget);
  }

  /// Verifies a widget with specific key is not visible
  void expectWidgetNotVisible(String key) {
    expect(findByKey(key), findsNothing);
  }

  /// Verifies an icon is visible
  void expectIconVisible(IconData icon) {
    expect(find.byIcon(icon), findsOneWidget);
  }

  /// Verifies an icon is not visible
  void expectIconNotVisible(IconData icon) {
    expect(find.byIcon(icon), findsNothing);
  }

  /// Simulates a long press on a widget
  Future<void> longPressWidget(String key) async {
    final widgetFinder = findByKey(key);
    await longPress(widgetFinder);
    await pumpAndSettle();
  }

  /// Simulates a double tap on a widget
  Future<void> doubleTapWidget(String key) async {
    final widgetFinder = findByKey(key);
    await tap(widgetFinder);
    await pump(const Duration(milliseconds: 100));
    await tap(widgetFinder);
    await pumpAndSettle();
  }

  /// Tests widget states (hover, focus, pressed)
  Future<void> testWidgetStates(String key) async {
    final widgetFinder = findByKey(key);
    
    // Test hover state (for platforms that support it)
    final gesture = await createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer();
    await gesture.moveTo(getCenter(widgetFinder));
    await pumpAndSettle();
    
    // Test pressed state
    await gesture.down(getCenter(widgetFinder));
    await pumpAndSettle();
    await gesture.up();
    await pumpAndSettle();
    
    await gesture.removePointer();
  }

  /// Verifies a RemixCheckbox is checked
  void expectCheckboxChecked(String key) {
    final checkboxFinder = findByKey(key);
    final checkbox = widget<RemixCheckbox>(checkboxFinder);
    expect(checkbox.selected, true);
  }

  /// Verifies a RemixCheckbox is unchecked
  void expectCheckboxUnchecked(String key) {
    final checkboxFinder = findByKey(key);
    final checkbox = widget<RemixCheckbox>(checkboxFinder);
    expect(checkbox.selected, false);
  }

  /// Verifies a RemixSwitch is on
  void expectSwitchOn(String key) {
    final switchFinder = findByKey(key);
    final switchWidget = widget<RemixSwitch>(switchFinder);
    expect(switchWidget.value, true);
  }

  /// Verifies a RemixSwitch is off
  void expectSwitchOff(String key) {
    final switchFinder = findByKey(key);
    final switchWidget = widget<RemixSwitch>(switchFinder);
    expect(switchWidget.value, false);
  }

  /// Verifies a RemixRadio is selected
  void expectRadioSelected(String key) {
    final radioFinder = findByKey(key);
    final radio = widget<RemixRadio>(radioFinder);
    expect(radio.selected, true);
  }

  /// Verifies a RemixRadio is not selected
  void expectRadioNotSelected(String key) {
    final radioFinder = findByKey(key);
    final radio = widget<RemixRadio>(radioFinder);
    expect(radio.selected, false);
  }

  /// Gets the current value of a RemixSlider
  double getSliderValue(String key) {
    final sliderFinder = findByKey(key);
    final slider = widget<RemixSlider>(sliderFinder);
    return slider.value;
  }

  /// Verifies a RemixSlider has a specific value
  void expectSliderValue(String key, double expectedValue) {
    final value = getSliderValue(key);
    expect(value, expectedValue);
  }

  /// Gets the text from a RemixTextField
  String getTextFieldValue(String key) {
    final textFieldFinder = findByKey(key);
    final textField = widget<RemixTextField>(textFieldFinder);
    return textField.controller?.text ?? '';
  }

  /// Verifies a RemixTextField has specific text
  void expectTextFieldValue(String key, String expectedText) {
    final value = getTextFieldValue(key);
    expect(value, expectedText);
  }

  /// Tests accessibility by verifying semantic labels
  void expectSemanticLabel(String label) {
    expect(
      find.bySemanticsLabel(label),
      findsOneWidget,
      reason: 'Expected to find semantic label: $label',
    );
  }

  /// Simulates device orientation change
  Future<void> changeOrientation(Orientation orientation) async {
    final Size size = orientation == Orientation.portrait
        ? const Size(400, 800)
        : const Size(800, 400);
    
    await binding.setSurfaceSize(size);
    await pumpAndSettle();
  }

  /// Takes a screenshot for visual regression testing
  Future<void> takeScreenshot(String name) async {
    await binding.takeScreenshot(name);
  }
}

/// Test data builder for creating consistent test data
class TestDataBuilder {
  static const String defaultButtonKey = 'test_button';
  static const String defaultTextFieldKey = 'test_textfield';
  static const String defaultCheckboxKey = 'test_checkbox';
  static const String defaultSwitchKey = 'test_switch';
  static const String defaultRadioKey = 'test_radio';
  static const String defaultSliderKey = 'test_slider';
  static const String defaultSelectKey = 'test_select';
  static const String defaultAccordionKey = 'test_accordion';

  static const String sampleText = 'Test Input Text';
  static const String sampleLabel = 'Test Label';
  static const String sampleHint = 'Enter text here';
  static const String sampleHelper = 'Helper text';
  static const String sampleError = 'Error message';

  static List<String> get sampleOptions => [
        'Option 1',
        'Option 2',
        'Option 3',
        'Option 4',
        'Option 5',
      ];

  static List<String> get sampleRadioOptions => [
        'Radio Option A',
        'Radio Option B',
        'Radio Option C',
      ];
}

/// Performance test utilities
class PerformanceTestHelper {
  static Future<void> measureWidgetBuildTime(
    WidgetTester tester,
    Widget widget,
    String widgetName,
  ) async {
    final stopwatch = Stopwatch()..start();
    await tester.pumpWidget(MaterialApp(home: widget));
    stopwatch.stop();
    
    final buildTime = stopwatch.elapsedMilliseconds;
    print('$widgetName build time: ${buildTime}ms');
    
    // Assert reasonable build time (adjust threshold as needed)
    expect(
      buildTime,
      lessThan(100),
      reason: '$widgetName took too long to build: ${buildTime}ms',
    );
  }

  static Future<void> measureInteractionResponseTime(
    WidgetTester tester,
    Future<void> Function() interaction,
    String interactionName,
  ) async {
    final stopwatch = Stopwatch()..start();
    await interaction();
    await tester.pumpAndSettle();
    stopwatch.stop();
    
    final responseTime = stopwatch.elapsedMilliseconds;
    print('$interactionName response time: ${responseTime}ms');
    
    // Assert reasonable response time
    expect(
      responseTime,
      lessThan(500),
      reason: '$interactionName took too long: ${responseTime}ms',
    );
  }
}