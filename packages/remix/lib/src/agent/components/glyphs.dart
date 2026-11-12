import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../utilities/remix_style.dart';

/// A functional glyph an Agent widget asks its host to draw.
///
/// The Agent widgets ship no icons. Each place that shows one names a glyph
/// and asks an [AgentGlyphBuilder]; presets map the glyphs onto their icon
/// set.
enum AgentGlyph {
  /// The indicator of a collapsed surface, such as a chevron pointing right.
  disclosureClosed,

  /// The indicator of an expanded surface, such as a chevron pointing down.
  disclosureOpen,

  /// The conversation's way back to the latest output.
  latest,

  /// The composer's send action.
  send,

  /// The composer's stop action.
  stop,

  /// The steps line while the run works.
  thinking,

  /// The steps line while the run waits for the reader.
  waiting,

  /// The steps line once the run settled.
  thought,

  /// A step that has not started.
  stepPending,

  /// The step underway.
  stepActive,

  /// A finished step.
  stepComplete,

  /// An abandoned or skipped step.
  stepCancelled,

  /// A tool call's leading icon, when the call supplies none.
  tool,

  /// The approval card's leading icon.
  approval,

  /// A tool call whose input is still streaming.
  toolPreparing,

  /// A tool call that waits for approval.
  toolWaiting,

  /// A running tool call.
  toolRunning,

  /// A tool call that succeeded.
  toolSucceeded,

  /// A tool call that failed.
  toolFailed,

  /// A denied tool call.
  toolDenied,

  /// A cancelled tool call.
  toolCancelled,

  /// The answer's copy action.
  copy,

  /// The copy action right after it copied.
  copied,

  /// The answer's positive feedback action.
  positive,

  /// The answer's negative feedback action.
  negative,

  /// The answer's retry action.
  retry,

  /// The leading icon of the sources line.
  sources,
}

/// Draws [glyph] with the slot's resolved icon [spec], or returns null to
/// draw nothing.
///
/// The returned widget inherits [spec] as its icon theme, so a plain `Icon`
/// takes the slot's size and color.
typedef AgentGlyphBuilder =
    Widget? Function(BuildContext context, AgentGlyph glyph, IconSpec spec);

/// Supplies the glyphs of the Agent widgets below it.
///
/// A widget's own `glyphBuilder` wins over this one. Without either, the
/// widgets draw no glyphs.
class AgentGlyphs extends InheritedWidget {
  /// Supplies [builder] to the Agent widgets in [child].
  const AgentGlyphs({super.key, required this.builder, required super.child});

  /// Draws the glyphs.
  final AgentGlyphBuilder builder;

  /// The nearest builder above [context], if any.
  static AgentGlyphBuilder? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AgentGlyphs>()?.builder;

  @override
  bool updateShouldNotify(AgentGlyphs oldWidget) =>
      builder != oldWidget.builder;
}

/// Builds [glyph] with [override] or the nearest [AgentGlyphs], styled by
/// [spec]; null when neither draws it.
@internal
Widget? agentGlyph(
  BuildContext context,
  AgentGlyphBuilder? override,
  AgentGlyph glyph,
  StyleSpec<IconSpec> spec,
) {
  final builder = override ?? AgentGlyphs.maybeOf(context);
  final widget = builder?.call(context, glyph, spec.spec);
  if (widget == null) return null;

  return ExcludeSemantics(
    child: RemixDefaultContentStyle(icon: spec, child: widget),
  );
}
