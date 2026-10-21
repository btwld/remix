# Naked UI Example App

A showcase application demonstrating the Naked UI library.

## Getting Started

This project demonstrates how to use the Naked UI library to create customizable UI components with separation of concerns between behavior and appearance.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Testing

From this directory, widget tests in `test/` (including goldens under `test/goldens/`) run with:

```bash
flutter test
```

That is the command `melos run ci:flutter` runs for this package. It does not run `integration_test/`.

Behavior coverage is aggregated in `integration_test/all_tests.dart`:

```bash
flutter test integration_test/all_tests.dart -d macos
```

Web disclosure semantics are a separate entry point. Flutter runs web
integration tests only through `flutter drive`, with `chromedriver` listening
on port 4444:

```bash
flutter drive -d chrome \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/web_disclosure_semantics.dart
```
