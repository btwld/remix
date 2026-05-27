part of 'spinner.dart';

enum FortalSpinnerSize { size1, size2, size3 }

@MixWidget()
RemixSpinnerStyle fortalSpinnerStyle({FortalSpinnerSize size = .size2}) {
  return RemixSpinnerStyle(
    indicatorColor: FortalTokens.accent9(),
    duration: const Duration(milliseconds: 800),
  ).merge(_fortalSpinnerSizeStyle(size));
}

RemixSpinnerStyle _fortalSpinnerSizeStyle(FortalSpinnerSize size) {
  return switch (size) {
    .size1 => RemixSpinnerStyle(size: 16.0, strokeWidth: 1.5),
    .size2 => RemixSpinnerStyle(size: 20.0, strokeWidth: 2.0),
    .size3 => RemixSpinnerStyle(size: 24.0, strokeWidth: 2.5),
  };
}
