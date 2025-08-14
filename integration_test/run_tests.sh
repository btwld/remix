#!/bin/bash

echo "========================================="
echo "Integration Test Runner for Remix Components"
echo "========================================="
echo ""
echo "This script will run integration tests for the Remix component library."
echo ""

# Check if running on macOS or Linux
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Running on macOS..."
    DEVICE="macos"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Running on Linux..."
    DEVICE="linux"
else
    echo "Running on Web (Chrome)..."
    DEVICE="chrome"
fi

echo ""
echo "Available test files:"
echo "1. basic_button_test.dart - Basic button functionality tests"
echo "2. simple_button_test.dart - Simple integration test verification"
echo "3. components/button_test.dart - Full RemixButton test suite"
echo ""

# Function to run a specific test
run_test() {
    local test_file=$1
    echo "Running: $test_file"
    echo "----------------------------------------"
    
    if [ "$DEVICE" == "chrome" ]; then
        echo "Note: For Chrome tests, ChromeDriver must be running on port 4444"
        echo "Install with: npx @puppeteer/browsers install chromedriver@stable"
        echo "Run with: chromedriver --port=4444"
        echo ""
        flutter drive \
            --driver=test_driver/integration_test.dart \
            --target=integration_test/$test_file \
            -d chrome
    else
        flutter test integration_test/$test_file -d $DEVICE
    fi
}

# Check if flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "Error: Flutter is not installed or not in PATH"
    exit 1
fi

# Run flutter doctor to check setup
echo "Checking Flutter setup..."
flutter doctor -v | grep -E "(Flutter|Chrome|macOS|Linux)" || true
echo ""

# Main execution
echo "Select an option:"
echo "1. Run all integration tests"
echo "2. Run basic_button_test.dart only"
echo "3. Run with widget test runner (no device required)"
echo ""
read -p "Enter choice (1-3): " choice

case $choice in
    1)
        echo "Running all integration tests..."
        run_test "basic_button_test.dart"
        run_test "simple_button_test.dart"
        ;;
    2)
        echo "Running basic button test..."
        run_test "basic_button_test.dart"
        ;;
    3)
        echo "Running as widget tests (no device required)..."
        flutter test test/simple_button_test.dart
        flutter test test/components/button_integration_test.dart
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

echo ""
echo "========================================="
echo "Test execution completed!"
echo "========================================="