# NakedCombobox correction captures

Real macOS debug renders on Flutter 3.44.0, captured on 2026-11-06.
WidgetsApp/Overlay host, 800×600 logical viewport, PNG capture DPR 1,
LTR, English, text scale 1, fixed light palette and fruit suggestions.
No Material host or generated mockup.

The same local review fixture focuses an editor, sets the query to `Ap`,
then `Apr`, then changes only the parent combobox's `enabled` to false.
The editor stays enabled and focused. Captures include the complete Overlay.
The sequence is programmatic parent-update evidence, not a physical IME or
screen-reader test.

- `before-stale-text.png`: the editor reads `Apr`, the snapshot still reads `Ap`.
- `after-stale-text.png`: both read `Apr`.
- `before-disabled.png`: the option popup remains while suggestions are paused.
- `after-disabled.png`: the popup is absent; the query, selection and focus remain.

Before source: `b8e4f68a218195e91703614dc2a5498ffcda95bf` NakedCombobox
(the preserved coordinator checkout has identical source for this component).
After source: this branch's corrective NakedCombobox implementation.

Local fixture SHA-256: `6b00e871fa1d351dd4ca1375682c3418f21570d378bfb4dceb943f8be0a60459`.
After component SHA-256: `896a2abe4c46f1b15c753fa084b972186c7754bf6b586c47a5d3ab9df32504ac`.
