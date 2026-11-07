# Calendar visual evidence

Actual macOS renders of `apps/playground/lib/calendar_reference.dart`.

- Flutter 3.44.0 / Dart 3.12.0; 800×600 logical-pixel content, capture ratio 1.
- Playground system dark theme with shipped Geist and platform Arabic fallback.
- Fixed current date: 2026-11-06. Initial selected date: 2026-11-12.
- `calendar-inline.png`: inline-only calendar, complete November grid.
- `calendar-year-open.png`: year selector aligned with its field; normal menu layering.
- `calendar-rtl-large.png`: Arabic RTL, 200% text, selected November 13, after page scrolling. The heading is partly outside the page viewport; the entire calendar grid remains visible.

Live checks exercised year-menu Escape, selecting the 13th, language/scale changes and scrolling. Hot reload succeeded; runtime-error query returned no errors. These captures are representative native evidence, not automated golden comparisons or physical screen-reader certification. A temporary build-only macOS deployment override was used; product platform floors were unchanged.
