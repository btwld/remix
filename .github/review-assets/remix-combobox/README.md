# RemixCombobox review captures

Actual macOS native debug renders, Flutter 3.44.0, captured 2026-11-06.
WidgetsApp/Overlay reference, bundled Geist, 800×600 logical viewport,
PNG capture pixel ratio 1. No Material host or generated mockups.

- `native-wide-idle.png`: default editor and disabled saved destination.
- `native-wide-open.png`: focused search, named suggestions and highlighted row.
- `native-wide-dark-open.png`: the same open state in the dark reference palette.
- `native-narrow-rtl-large-dark.png`: a 320-wide constrained reference subtree
  inside the 800×600 native window, RTL and text scale 2, scrolled to the editor
  and the last keyboard-highlighted suggestion. This is not a 320-wide OS window.

The committed `apps/playground/lib/combobox_reference.dart` is the source of
these compositions. An ignored FlutterDriver/RepaintBoundary wrapper captures
actual engine output. Text entry is driver-emulated; keyboard navigation was
exercised in the native window. No physical IME or screen-reader claim.

Executed RGBA assertions cover independent editor/row states and raw-style
precedence; geometry assertions separately cover a true 320×640 viewport.
Screenshots are manual visual evidence, not full-composition golden baselines.
