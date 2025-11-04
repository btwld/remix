#!/usr/bin/env bash
set -euo pipefail

# Playground launcher for Remix components
# Usage:
#   scripts/playground_component.sh <component_path_or_name>
# Examples:
#   scripts/playground_component.sh button
#   scripts/playground_component.sh RemixButton
#   scripts/playground_component.sh lib/src/components/button/button_widget.dart

TARGET="${1:-}"
if [[ -z "${TARGET}" ]]; then
  echo "Usage: scripts/playground_component.sh <component_path_or_name>" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
APP_DIR="${REPO_ROOT}/playground"

if [[ ! -d "${APP_DIR}" ]]; then
  echo "❌ playground app not found at ${APP_DIR}" >&2
  exit 1
fi

slug_from_input() {
  local input="$1"
  if [[ -f "$input" ]]; then
    # Expect path like lib/src/components/<slug>/...
    if [[ "$input" == *"lib/src/components/"* ]]; then
      local sub="${input#*lib/src/components/}"
      echo "${sub%%/*}"
      return
    fi
  fi
  # Normalize class names like RemixButton -> button
  local norm="${input#Remix}"
  echo "${norm,,}"
}

SLUG="$(slug_from_input "${TARGET}")"

cd "${APP_DIR}"
flutter pub get >/dev/null

# Prefer --dart-define; web query works too (?component=slug)
flutter run -d chrome -t lib/main.dart --dart-define=COMPONENT="${SLUG}"

