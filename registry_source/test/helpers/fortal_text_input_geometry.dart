import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Measures the painted field, inside its expanded touch target.
void expectFortalTextInputGeometry(
  WidgetTester tester, {
  required double scale,
  required double height,
  required double paddingY,
}) {
  final editor = find.byType(EditableText);
  final render = tester.state<EditableTextState>(editor).renderEditable;
  final chrome = find
      .ancestor(of: editor, matching: find.byType(DecoratedBox))
      .first;
  final rect = tester.getRect(chrome);
  final editorRect = tester.getRect(editor);
  if (scale == 1) {
    expect(rect.height, closeTo(height, 1e-9));
    expect(editorRect.center.dy, closeTo(rect.center.dy, 0.001));
  } else {
    expect(
      rect.height,
      greaterThanOrEqualTo(render.preferredLineHeight + 2 * paddingY - 1e-6),
    );
    expect(
      render.size.height,
      greaterThanOrEqualTo(render.preferredLineHeight),
    );
    expect(editorRect.top - rect.top, greaterThanOrEqualTo(paddingY - 1e-6));
    expect(
      rect.bottom - editorRect.bottom,
      greaterThanOrEqualTo(paddingY - 1e-6),
    );
  }
  expect(tester.takeException(), isNull);
}
