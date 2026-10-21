import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

/// Extension methods for WidgetTester to simplify test setup and interactions
extension WidgetTesterHelpers on WidgetTester {
  /// Pumps a Remix widget in the Material interoperability test harness.
  ///
  /// `MaterialApp` and `Scaffold` are conveniences here, not Remix host
  /// requirements. Host-contract tests should provide only the capability
  /// under test, such as `Overlay.wrap` or a caller-owned `Navigator`.
  ///
  /// The scope is deliberately token-free: Remix's own styles resolve no design
  /// tokens, so this harness must not depend on a theme package. Themed
  /// behavior is covered by `remix_fortal`'s own suite.
  Future<void> pumpRemixApp(
    Widget widget, {
    TextDirection textDirection = TextDirection.ltr,
  }) async {
    await pumpWidget(
      MixScope.empty(
        child: MaterialApp(
          home: Directionality(
            textDirection: textDirection,
            child: Scaffold(body: Center(child: widget)),
          ),
        ),
      ),
    );
  }
}

class MockBuildContext extends BuildContext {
  final Map<MixToken, Object>? _tokens;
  final List<Type>? _orderOfModifiers;
  final ThemeData? _themeData;
  MixScope? _mixScope;

  MockBuildContext({
    Map<MixToken, Object>? tokens,
    List<Type>? orderOfModifiers,
    ThemeData? themeData,
  }) : _tokens = tokens,
       _orderOfModifiers = orderOfModifiers,
       _themeData = themeData {
    // Create MixScope instance once
    _mixScope = MixScope(
      tokens: _tokens,
      orderOfModifiers: _orderOfModifiers,
      child: const SizedBox(),
    );
  }

  @override
  bool get debugDoingBuild => false;

  @override
  bool get mounted => true;

  /// Inherited widget - supports both InheritedWidget and InheritedModel
  @override
  T? dependOnInheritedWidgetOfExactType<T extends InheritedWidget>({
    Object? aspect,
  }) {
    if (T == MixScope) {
      return _mixScope as T?;
    }
    if (T == Theme && _themeData != null) {
      return Theme(data: _themeData, child: const SizedBox()) as T?;
    }
    return null;
  }

  @override
  InheritedElement?
  getElementForInheritedWidgetOfExactType<T extends InheritedWidget>() {
    // For InheritedModel.inheritFrom to work, we need to return a mock element
    if (T == MixScope && _mixScope != null) {
      return _MockInheritedElement(_mixScope!);
    }
    return null;
  }

  @override
  T? getInheritedWidgetOfExactType<T extends InheritedWidget>() {
    if (T == MixScope) {
      return _mixScope as T?;
    }
    if (T == Theme && _themeData != null) {
      return Theme(data: _themeData, child: const SizedBox()) as T?;
    }
    return null;
  }

  @override
  Widget get widget => const SizedBox();

  @override
  BuildOwner? get owner => null;

  @override
  Size? get size => const Size(800, 600);

  @override
  RenderObject? findRenderObject() => null;

  @override
  InheritedWidget dependOnInheritedElement(
    InheritedElement ancestor, {
    Object? aspect,
  }) {
    return ancestor.widget as InheritedWidget;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

/// Mock InheritedElement for testing InheritedModel functionality
class _MockInheritedElement extends InheritedElement {
  _MockInheritedElement(super.widget);

  @override
  MixScope get widget => super.widget as MixScope;

  @override
  void updateDependencies(Element dependent, Object? aspect) {
    // Mock implementation - just track the dependency
  }

  @override
  void notifyDependent(InheritedWidget oldWidget, Element dependent) {
    // Mock implementation
  }
}

/// Extension to add Mix testing utilities to WidgetTester
extension WidgetTesterExtension on WidgetTester {
  /// Pumps a widget in the Material interoperability test harness.
  Future<void> pumpMaterialApp(Widget widget) async {
    await pumpWidget(MaterialApp(home: Scaffold(body: widget)));
  }
}
