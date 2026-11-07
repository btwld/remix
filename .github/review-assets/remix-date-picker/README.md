# DatePicker visual evidence

Actual macOS renders of `apps/playground/lib/calendar_reference.dart`.

- Flutter 3.44.0 / Dart 3.12.0; 800×600 logical-pixel content, capture ratio 1.
- Playground system dark theme with shipped Geist and platform Arabic fallback.
- Fixed current date: 2026-11-06. Initial selected date: 2026-11-12.
- `datepicker-open.png`: open picker, selected November 12; the bounded calendar scrolls independently of the page.
- `datepicker-year-open.png`: nested year menu aligned with its field; Escape dismisses only that menu.
- `datepicker-rtl-large.png`: Arabic RTL, 200% text, selected November 13; overlay flips above the trigger to fit available space.
- `datepicker-rtl-last-week.png`: same RTL panel scrolled to its last week; selecting November 30 updated the trigger and dismissed the panel.

Live checks exercised nested-menu Escape, selection/dismissal, language/scale changes, and independent calendar scrolling. Hot reload succeeded; runtime-error query returned no errors. These captures are representative native evidence, not automated golden comparisons or physical screen-reader certification. A temporary build-only macOS deployment override was used; product platform floors were unchanged.
