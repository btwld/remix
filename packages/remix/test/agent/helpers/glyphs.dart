import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';

/// Draws every glyph as an empty box keyed by its name, sized by its spec.
Widget? testGlyphs(BuildContext context, AgentGlyph glyph, IconSpec spec) =>
    SizedBox.square(
      key: ValueKey('glyph-${glyph.name}'),
      dimension: spec.size ?? 16,
    );

/// Finds the box [testGlyphs] drew for [glyph].
Finder findGlyph(AgentGlyph glyph) =>
    find.byKey(ValueKey('glyph-${glyph.name}'));
