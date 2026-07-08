part of 'spinner.dart';

/// Fortal spinner size presets.
enum FortalSpinnerSize { size1, size2, size3 }

/// Creates a Fortal-themed [RemixSpinnerStyler].
@MixWidget(name: 'FortalSpinner')
RemixSpinnerStyler fortalSpinnerStyler({FortalSpinnerSize size = .size2}) {
  return RemixSpinnerStyler(
    indicatorColor: FortalTokens.accent9(),
    duration: const Duration(milliseconds: 800),
  ).merge(_fortalSpinnerSizeStyler(size));
}

RemixSpinnerStyler _fortalSpinnerSizeStyler(FortalSpinnerSize size) {
  return switch (size) {
    .size1 => RemixSpinnerStyler(size: 16.0, strokeWidth: 1.5),
    .size2 => RemixSpinnerStyler(size: 20.0, strokeWidth: 2.0),
    .size3 => RemixSpinnerStyler(size: 24.0, strokeWidth: 2.5),
  };
}
