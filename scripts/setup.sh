#!/bin/bash
# Setup script for Remix - Flutter/Dart Monorepo
# Compatible with both local and Claude Code remote environments

set -e  # Exit immediately if a command exits with a non-zero status
set -u  # Treat unset variables as an error

# ANSI color codes for output
readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly YELLOW='\033[1;33m'
readonly RED='\033[0;31m'
readonly NC='\033[0m'

# Logging functions
log_info() {
  echo -e "${BLUE}ℹ${NC} $1"
}

log_success() {
  echo -e "${GREEN}✓${NC} $1"
}

log_warning() {
  echo -e "${YELLOW}⚠${NC} $1"
}

log_error() {
  echo -e "${RED}✗${NC} $1"
  exit 1
}

log_step() {
  echo ""
  echo -e "${BLUE}▶${NC} ${GREEN}$1${NC}"
  echo "─────────────────────────────────────────────────"
}

# Detect environment
detect_environment() {
  if [ "${CLAUDE_CODE_REMOTE:-false}" = "true" ]; then
    log_info "Environment: Claude Code Remote"
    export IS_REMOTE=true
  else
    log_info "Environment: Local"
    export IS_REMOTE=false
  fi
}

# Setup Claude Code memory symlink
setup_claude_memory() {
  log_step "Setting up Claude Code memory"

  if [ ! -f "AGENTS.md" ]; then
    log_warning "AGENTS.md not found, skipping symlink creation"
    return 0
  fi

  # Remove existing CLAUDE.local.md if it's a regular file
  if [ -f "CLAUDE.local.md" ] && [ ! -L "CLAUDE.local.md" ]; then
    log_info "Removing existing CLAUDE.local.md file"
    rm "CLAUDE.local.md"
  fi

  # Create symlink if it doesn't exist
  if [ ! -e "CLAUDE.local.md" ]; then
    log_info "Creating symlink: CLAUDE.local.md -> AGENTS.md"
    ln -s AGENTS.md CLAUDE.local.md
    log_success "Symlink created successfully"
  else
    log_info "CLAUDE.local.md already exists"
  fi

  # Verify the symlink
  if [ -L "CLAUDE.local.md" ]; then
    local target=$(readlink CLAUDE.local.md)
    log_success "CLAUDE.local.md -> $target"
  fi
}

# Setup PATH for tools
setup_path() {
  log_step "Setting up environment PATH"

  # Add common tool paths
  export PATH="$HOME/.local/bin:$PATH"
  export PATH="$HOME/.pub-cache/bin:$PATH"
  export PATH="$HOME/.local/share/mise/shims:$PATH"

  log_success "PATH configured"
}

# Check if tool is installed
check_tool() {
  local tool=$1
  local name=$2

  if command -v "$tool" &> /dev/null; then
    log_success "$name found: $(command -v $tool)"
    return 0
  else
    log_warning "$name not found"
    return 1
  fi
}

# Install FVM (Flutter Version Manager)
install_fvm() {
  log_step "Setting up FVM"

  if ! command -v fvm &> /dev/null; then
    log_info "Installing FVM..."
    dart pub global activate fvm

    # Re-check PATH
    export PATH="$HOME/.pub-cache/bin:$PATH"

    if command -v fvm &> /dev/null; then
      log_success "FVM installed successfully"
    else
      log_error "FVM installation failed"
    fi
  else
    log_success "FVM already installed: $(fvm --version)"
  fi
}

# Setup Flutter via FVM
setup_flutter() {
  log_step "Setting up Flutter via FVM"

  if [ ! -f ".fvmrc" ]; then
    log_warning ".fvmrc not found, skipping Flutter installation"
    return 0
  fi

  # Install Flutter version from .fvmrc
  log_info "Installing Flutter from .fvmrc..."
  fvm install

  # Use the Flutter version
  log_info "Setting Flutter version..."
  fvm use --force

  # Verify Flutter installation
  if fvm flutter --version &> /dev/null; then
    log_success "Flutter ready: $(fvm flutter --version | head -n 1)"
  else
    log_error "Flutter setup failed"
  fi
}

# Install Melos
install_melos() {
  log_step "Setting up Melos"

  if ! command -v melos &> /dev/null; then
    log_info "Installing Melos..."
    dart pub global activate melos

    # Re-check PATH
    export PATH="$HOME/.pub-cache/bin:$PATH"

    if command -v melos &> /dev/null; then
      log_success "Melos installed successfully"
    else
      log_error "Melos installation failed"
    fi
  else
    log_success "Melos already installed: $(melos --version)"
  fi
}

# Bootstrap workspace with Melos
bootstrap_workspace() {
  log_step "Bootstrapping Melos workspace"

  if [ ! -f "pubspec.yaml" ]; then
    log_error "pubspec.yaml not found. Are you in the project root?"
  fi

  log_info "Running melos bootstrap..."
  melos bootstrap

  log_success "Workspace bootstrapped successfully"
}

# Verify Dart packages
verify_packages() {
  log_step "Verifying package setup"

  # Check if main packages exist
  local packages=("packages/remix" "packages/demo" "packages/example" "packages/playground")

  for pkg in "${packages[@]}"; do
    if [ -d "$pkg" ]; then
      log_success "Package found: $pkg"
    else
      log_warning "Package not found: $pkg"
    fi
  done
}

# Display helpful information
display_info() {
  echo ""
  echo "════════════════════════════════════════════════"
  echo -e "  ${GREEN}✓ Setup Complete!${NC}"
  echo "════════════════════════════════════════════════"
  echo ""
  echo "Available commands:"
  echo ""
  echo "  Melos (monorepo management):"
  echo "    melos bootstrap      # Re-link packages and install deps"
  echo "    melos clean          # Clean all packages"
  echo "    melos run ci         # Run CI checks"
  echo "    melos run test:flutter  # Run all tests"
  echo ""
  echo "  Flutter (use with FVM):"
  echo "    fvm flutter test     # Run tests"
  echo "    fvm flutter analyze  # Analyze code"
  echo "    fvm flutter run      # Run app"
  echo ""
  echo "  Demo & Playground:"
  echo "    cd packages/demo && fvm flutter run -d chrome"
  echo "    cd packages/playground && fvm flutter run -d chrome"
  echo ""
  echo "  Package structure:"
  echo "    • remix      - Core component library"
  echo "    • demo       - Interactive demo app"
  echo "    • example    - Code examples"
  echo "    • playground - Component playground"
  echo ""
  echo "Ready to build! 🚀"
  echo ""
}

# Main setup flow
main() {
  echo ""
  echo "════════════════════════════════════════════════"
  echo "  Remix - Flutter Component Library Setup"
  echo "════════════════════════════════════════════════"
  echo ""

  detect_environment
  setup_claude_memory
  setup_path

  # Check for Dart
  if ! check_tool "dart" "Dart SDK"; then
    log_error "Dart SDK not found. Please install Dart first."
  fi

  install_fvm
  setup_flutter
  install_melos
  bootstrap_workspace
  verify_packages
  display_info
}

# Run main function
main

exit 0
