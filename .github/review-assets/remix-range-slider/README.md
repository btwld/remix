# RemixRangeSlider review captures

Actual macOS native debug renders, Flutter 3.44.0, captured 2026-11-06.
WidgetsApp reference with bundled Geist, 800×600 logical viewport and capture
pixel ratio 1. No Material host or generated mockups.

- `native-lower-focus.png`: lower thumb focused; controlled values $75–$250.
- `native-upper-focus.png`: upper thumb focused at the same values.
- `native-dark.png`: dark reference, values $80–$240.
- `native-narrow-rtl-large.png`: a 320-wide constrained reference subtree inside
  the 800×600 native window, RTL and text scale 2, scrolled to the control.
  This is not a 320-wide OS window.

The composition is `apps/playground/lib/range_slider_reference.dart`. An ignored
FlutterDriver/RepaintBoundary capture wrapper records actual engine output.
Both bounds were independently changed by native keyboard input and forward
Tab traversal exercised. Chrome accessibility increment/decrement actions also
updated the corresponding visible values independently.

Geometry and executed RGBA tests independently cover endpoints, interval fill,
state isolation, raw styling and animation effects. These screenshots are manual
visual evidence, not full-composition golden baselines or physical AT validation.
Native reverse traversal is unmeasured: the input tool emitted plain Tab without
Shift; the real Shift+Tab widget regressions pass.
