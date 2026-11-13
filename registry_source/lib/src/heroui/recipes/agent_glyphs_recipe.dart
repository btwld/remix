import 'package:flutter/widgets.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../components/spinner.dart';

/// Draws the glyphs of the Agent widgets from this preset's icon set.
///
/// Wrap the conversation in `AgentGlyphs(builder: heroUiAgentGlyph, ...)`.
/// Each Agent widget sizes and colors its glyph through its own style, so this
/// only picks the shape. Returning null draws nothing there.
Widget? heroUiAgentGlyph(
  BuildContext context,
  AgentGlyph glyph,
  IconSpec spec,
) => switch (glyph) {
  // A call that waits for approval shows its status as a badge, without a
  // glyph.
  .toolWaiting => null,
  .toolPreparing || .toolRunning => HeroUiSpinner(
    color: .current,
    style: SpinnerStyler(size: spec.size),
  ),
  _ => Icon(_icon(glyph)),
};

/// Picks named tool icons; null keeps the generic tool glyph as the fallback.
/// Pass this to `AgentGlyphs.toolIconBuilder` beside `heroUiAgentGlyph`.
Widget? heroUiAgentToolIcon(BuildContext context, String name, IconSpec spec) =>
    switch (name) {
      'terminal.run' => const Icon(RemixIcons.terminal),
      _ => null,
    };

IconData _icon(AgentGlyph glyph) => switch (glyph) {
  .disclosureClosed => RemixIcons.chevronRight,
  .disclosureOpen => RemixIcons.chevronDown,
  .latest => RemixIcons.arrowDown,
  .send => RemixIcons.arrowUp,
  .stop => RemixIcons.square,
  .thinking || .thought => RemixIcons.wand,
  .waiting => RemixIcons.pause,
  .stepPending => RemixIcons.circle,
  .stepActive => RemixIcons.dotFilled,
  .stepComplete => RemixIcons.check,
  .stepCancelled => RemixIcons.close,
  .tool => RemixIcons.terminal,
  .approval => RemixIcons.shield,
  .toolSucceeded => RemixIcons.checkCircle,
  .toolFailed => RemixIcons.closeCircle,
  .toolDenied || .toolCancelled => RemixIcons.ban,
  .copy => RemixIcons.copy,
  .copied => RemixIcons.check,
  // remix_ui_icons draws no thumbs, so feedback reads as a vote.
  .positive => RemixIcons.arrowUp,
  .negative => RemixIcons.arrowDown,
  .retry => RemixIcons.refresh,
  .sources => RemixIcons.file,
  .toolPreparing || .toolRunning || .toolWaiting => RemixIcons.loader,
};
