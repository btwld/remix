## Unreleased

### Fixes

- `showNakedDialog`, `showNakedAlertDialog`, and `NakedTooltip` now show and
  hide at once when the user asks to reduce motion, whatever durations they were
  given. They honor both `MediaQuery.disableAnimations` and the platform's
  Reduce Motion setting, which iOS reports separately and
  `disableAnimations` does not reflect. A dialog reads the setting when it
  opens and again when it is dismissed. A tooltip follows changes while it is
  mounted.
