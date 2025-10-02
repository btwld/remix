# Task: Surface RemixMenu overlay styling

## Background
`RemixMenuStyle` defines `$menuContainer` and `$item` specs, but the runtime widget only resolves the trigger portion. The overlay created inside `lib/src/components/menu/menu_widget.dart` bypasses `StyleBuilder`, and the separate `RemixMenuItem` already has its own style prop. This leaves the container spec unused and creates another hidden inheritance path for menu items—both patterns we are trying to phase out.

## Goal
Adopt the explicit-style approach: make overlay styling a first-class option on `RemixMenu`, remove the unused `$item` inheritance, and keep `RemixMenuItem` responsible for its own styling.

## Scope & Steps
- **Audit** `lib/src/components/menu/menu_widget.dart` and the associated styles/specs to document which pieces are currently unused (`menuContainer`, `$item`).
- **Simplify** `RemixMenuStyle`/`RemixMenuSpec` by removing the `$item` field entirely; the dedicated `RemixMenuItemStyle` remains the single source of truth for item appearance.
- **Expose** overlay styling explicitly by introducing an `overlay` (BoxStyler) prop on `RemixMenuStyle`/`RemixMenu` and applying it around the builder output.
- **Wrap** the overlay path so the resolved container style is applied (e.g., via `StyleBuilder` → `Box` around `overlayBuilder` output) while preserving custom builders.
- **Update** examples/tests to showcase styling the trigger, overlay container, and items separately (no inheritance).

## Acceptance Criteria
- Overlay styling (`overlay` prop) is applied automatically around the builder output. Pending
- Menu items keep using their own `style` prop; there is no implicit inheritance from the menu group. Pending
- Custom builders continue to function as before, and analyzer/tests remain green. Pending
