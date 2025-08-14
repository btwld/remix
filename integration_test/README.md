# Integration Tests for Remix Flutter Components

## Overview

This directory contains integration tests for the Remix Flutter component library. Integration tests verify that components work correctly across different platforms and that all parts of the application interact properly.

## Current Status

✅ **Test Infrastructure Setup Complete**
- Integration test dependencies added
- Test utilities created 
- Basic test structure implemented

⚠️ **Browser Test Behavior**
When running tests in Chrome without ChromeDriver, you'll see the actual UI being tested rather than automated test execution. This is why you see:
- A "State Button" with loading spinner
- A "Toggle Enabled" button
- Other UI elements from the test cases

This is normal behavior when ChromeDriver is not running.

## Test Files

### Core Test Files
- `basic_button_test.dart` - Integration tests for button functionality
- `simple_button_test.dart` - Simple test to verify integration test setup
- `test_utils.dart` - Utility functions for integration testing
- `app_test.dart` - Main test runner that imports all component tests

### Component Tests (To Be Implemented)
- `components/button_test.dart` - RemixButton integration tests
- `components/textfield_test.dart` - RemixTextField integration tests
- `components/checkbox_test.dart` - RemixCheckbox integration tests
- (and more...)

## Running Integration Tests

### Prerequisites

1. **For Web Testing (Chrome)**:
   ```bash
   # Install ChromeDriver
   npx @puppeteer/browsers install chromedriver@stable
   
   # Start ChromeDriver on port 4444
   chromedriver --port=4444
   ```

2. **For macOS Testing**:
   - Ensure CocoaPods is installed and working
   - Run `flutter doctor` to verify setup

3. **For Linux Testing**:
   - Ensure required dependencies are installed
   - Run `flutter doctor` to verify setup

### Running Tests

#### Method 1: Using Flutter Drive (for Web)
```bash
# With ChromeDriver running on port 4444:
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/basic_button_test.dart \
  -d chrome
```

#### Method 2: Using Flutter Test (for Desktop)
```bash
# On macOS
flutter test integration_test/basic_button_test.dart -d macos

# On Linux  
flutter test integration_test/basic_button_test.dart -d linux

# On Windows
flutter test integration_test/basic_button_test.dart -d windows
```

#### Method 3: Running as Widget Tests (No Device Required)
```bash
# Run tests without needing a device/emulator
flutter test test/simple_button_test.dart
flutter test test/components/button_integration_test.dart
```

## What You're Seeing in the Browser

When you run tests in Chrome without ChromeDriver, the browser shows the actual UI components being tested. Each test case creates widgets and the browser displays them. For example:

1. **"State Button"** - Tests loading state transitions
2. **"Toggle Enabled"** - Tests enabling/disabling functionality
3. **Loading Spinner** - Shows when button is in loading state

This is the test UI, not the actual application. With ChromeDriver properly configured, these tests would run automatically without manual interaction.

## Test Utilities

The `test_utils.dart` file provides helpful extensions and utilities:

- `pumpRemixApp()` - Sets up a test app with Remix theme
- `tapRemixButton()` - Taps a button by key
- `enterTextInRemixField()` - Enters text in a field
- `expectTextVisible()` - Verifies text is visible
- Performance testing utilities
- Accessibility testing utilities

## Known Issues

1. **Compilation Errors**: Some generated Mix package files have compatibility issues. Run `flutter pub run build_runner build --delete-conflicting-outputs` if you encounter issues.

2. **ChromeDriver Not Found**: Web tests require ChromeDriver to be installed and running. Without it, tests will display the UI but not run automatically.

3. **CocoaPods on macOS**: macOS tests may fail if CocoaPods is not properly configured.

## Next Steps

1. Fix remaining compilation issues with Mix package dependencies
2. Implement integration tests for all components
3. Set up CI/CD pipeline with GitHub Actions
4. Add visual regression testing
5. Implement accessibility testing for all components

## Running the Test Suite

Use the provided shell script for easy test execution:

```bash
chmod +x integration_test/run_tests.sh
./integration_test/run_tests.sh
```

This will guide you through running different test configurations based on your platform.

## Contributing

When adding new integration tests:

1. Create a new file in `integration_test/components/`
2. Follow the pattern established in `basic_button_test.dart`
3. Use the utilities from `test_utils.dart`
4. Add your test to `app_test.dart`
5. Update this README with any new requirements