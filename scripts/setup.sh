#!/bin/bash
# Remix Development Environment Setup Script
# Automatically runs when Claude Code session starts

set -e  # Exit immediately if a command exits with a non-zero status

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_step() {
    echo -e "${BLUE}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Detect environment
if [ "${CLAUDE_CODE_REMOTE:-false}" = "true" ]; then
    IS_REMOTE=true
    print_step "Running in Claude Code remote environment"
else
    IS_REMOTE=false
    print_step "Running in local environment"
fi

echo ""
print_step "Setting up Remix development environment..."
echo ""

# Step 1: Verify context files exist
print_step "[1/10] Verifying project context files..."
if [ -f "AGENTS.md" ] && [ -f "CLAUDE.md" ]; then
    print_success "AGENTS.md and CLAUDE.md found"
else
    print_error "Missing AGENTS.md or CLAUDE.md"
    exit 1
fi

# Step 2: Configure PATH for Dart/Flutter tools
print_step "[2/10] Configuring PATH for Dart and Flutter tools..."

# Add pub-cache to PATH if not already present
PUB_CACHE_BIN="$HOME/.pub-cache/bin"
if [[ ":$PATH:" != *":$PUB_CACHE_BIN:"* ]]; then
    export PATH="$PUB_CACHE_BIN:$PATH"
    print_success "Added $PUB_CACHE_BIN to PATH"
else
    print_success "pub-cache already in PATH"
fi

# Add FVM to PATH if not already present
FVM_BIN="$HOME/fvm/default/bin"
if [[ ":$PATH:" != *":$FVM_BIN:"* ]]; then
    export PATH="$FVM_BIN:$PATH"
    print_success "Added $FVM_BIN to PATH"
else
    print_success "FVM already in PATH"
fi

# Step 3: Install/verify FVM
print_step "[3/10] Installing/verifying FVM (Flutter Version Management)..."
if ! command -v fvm &> /dev/null; then
    print_warning "FVM not found, installing..."
    dart pub global activate fvm
    print_success "FVM installed"
else
    FVM_VERSION=$(fvm --version 2>&1 | head -n 1 || echo "unknown")
    print_success "FVM already installed: $FVM_VERSION"
fi

# Step 4: Install Flutter via FVM
print_step "[4/10] Installing Flutter via FVM..."
if [ -f ".fvmrc" ]; then
    FLUTTER_CHANNEL=$(cat .fvmrc | grep -oP '(?<="flutter": ")[^"]*')
    print_step "Installing Flutter from .fvmrc: $FLUTTER_CHANNEL"

    if ! fvm list | grep -q "$FLUTTER_CHANNEL"; then
        print_warning "Flutter $FLUTTER_CHANNEL not installed, installing now..."
        fvm install
        print_success "Flutter $FLUTTER_CHANNEL installed"
    else
        print_success "Flutter $FLUTTER_CHANNEL already installed"
    fi

    # Use the installed Flutter version
    fvm use --force
    print_success "Flutter $FLUTTER_CHANNEL activated"
else
    print_warning ".fvmrc not found, skipping Flutter installation via FVM"
fi

# Update PATH to include FVM Flutter
if [ -d ".fvm/flutter_sdk/bin" ]; then
    export PATH="$(pwd)/.fvm/flutter_sdk/bin:$PATH"
    print_success "FVM Flutter added to PATH"
fi

# Step 5: Install/verify Melos
print_step "[5/10] Installing/verifying Melos (workspace manager)..."
if ! command -v melos &> /dev/null; then
    print_warning "Melos not found, installing..."
    dart pub global activate melos
    print_success "Melos installed"
else
    MELOS_VERSION=$(melos --version 2>&1 || echo "unknown")
    print_success "Melos already installed: $MELOS_VERSION"
fi

# Step 6: Install/verify DCM (Dart Code Metrics)
print_step "[6/10] Installing/verifying DCM (Dart Code Metrics)..."
if ! command -v dcm &> /dev/null; then
    print_warning "DCM not found, installing..."
    dart pub global activate dart_code_metrics_presets
    print_success "DCM installed"
else
    DCM_VERSION=$(dcm --version 2>&1 | head -n 1 || echo "unknown")
    print_success "DCM already installed: $DCM_VERSION"
fi

# Step 7: Bootstrap workspace
print_step "[7/10] Bootstrapping workspace with Melos..."
if melos bootstrap; then
    print_success "Workspace bootstrapped successfully"
else
    print_error "Failed to bootstrap workspace"
    exit 1
fi

# Step 8: Verify Flutter doctor
print_step "[8/10] Verifying Flutter installation..."
echo ""
flutter doctor || print_warning "Flutter doctor reported issues (this may be normal)"
echo ""
print_success "Flutter doctor check completed"

# Step 9: Show workspace info
print_step "[9/10] Workspace information..."
echo ""
if [ -f "pubspec.yaml" ]; then
    echo "Workspace packages:"
    grep -A 10 "workspace:" pubspec.yaml | grep "  -" | sed 's/  - /  • /'
    echo ""
fi

# Step 10: Summary
print_step "[10/10] Setup complete!"
echo ""
echo -e "${GREEN}✓ Environment ready for Remix development${NC}"
echo ""
echo "Quick commands:"
echo "  • melos bootstrap        - Bootstrap workspace"
echo "  • melos run test:flutter - Run all tests"
echo "  • melos run ci          - Run CI tests"
echo "  • cd packages/demo && flutter run - Run demo app"
echo "  • flutter doctor        - Check Flutter setup"
echo ""
echo "Documentation:"
echo "  • AGENTS.md   - Project architecture"
echo "  • CLAUDE.md   - Claude Code context"
echo "  • README.md   - Project overview"
echo ""
print_success "Happy coding! 🚀"
