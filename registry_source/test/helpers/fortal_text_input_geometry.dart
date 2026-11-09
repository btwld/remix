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
    expect(rect.height, height);
    expect(editorRect.center.dy, closeTo(rect.center.dy, 0.001));
  } else {
    expect(
      rect.height,
      greaterThanOrEqualTo(render.preferredLineHeight + 2 * paddingY),
    );
    expect(
      render.size.height,
      greaterThanOrEqualTo(render.preferredLineHeight),
    );
    expect(editorRect.top - rect.top, greaterThanOrEqualTo(paddingY));
    expect(rect.bottom - editorRect.bottom, greaterThanOrEqualTo(paddingY));
  }
  expect(tester.takeException(), isNull);
}
