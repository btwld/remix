import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../components/button/button.dart';
import '../../components/disclosure/disclosure.dart';
import '../../utilities/remix_style.dart';
import '../models/source.dart';
import 'glyphs.dart';

part 'sources.g.dart';

/// The sources an answer refers to, as one line that opens a list.
///
/// The line reads "2 files referenced" by default and opens the sources as
/// chips. With [onSourcePressed], each chip is a button.
class AgentSources extends StatelessWidget {
  /// Creates the sources line for [sources].
  const AgentSources({
    super.key,
    required this.sources,
    this.labelBuilder,
    this.expanded,
    this.defaultExpanded = false,
    this.onExpandedChanged,
    this.onSourcePressed,
    this.glyphBuilder,
    this.disclosureStyle = const DisclosureStyler.create(),
    this.sourceStyle = const ButtonStyler.create(),
    this.style = const AgentSourcesStyler.create(),
    this.styleSpec,
  });

  /// The sources in order.
  final List<AgentSource> sources;

  /// Builds the line from the number of sources; defaults to
  /// [defaultLabel].
  final String Function(int count)? labelBuilder;

  /// Whether the list is open. Null lets the widget own the state.
  final bool? expanded;

  /// Whether the list starts open when uncontrolled.
  final bool defaultExpanded;

  /// Receives every request to open or close the list.
  final ValueChanged<bool>? onExpandedChanged;

  /// Opens a source; makes each chip a button.
  final ValueChanged<AgentSource>? onSourcePressed;

  /// Draws the glyphs; defaults to the nearest [AgentGlyphs].
  final AgentGlyphBuilder? glyphBuilder;

  /// The style of the disclosure behind the line and the list.
  final DisclosureStyler disclosureStyle;

  /// The style of a source that is a button.
  final ButtonStyler sourceStyle;

  /// The style of the line and the list.
  final AgentSourcesStyler style;

  /// A resolved spec that bypasses [style].
  final AgentSourcesSpec? styleSpec;

  /// The default line: "1 file referenced", "2 files referenced".
  static String defaultLabel(int count) =>
      '$count ${count == 1 ? 'file' : 'files'} referenced';

  static final _layout = AgentSourcesStyler(
    trigger: FlexBoxStyler().mainAxisSize(MainAxisSize.min),
  );

  Widget _source(AgentSourcesSpec spec, AgentSource source) {
    final onPressed = onSourcePressed;
    if (onPressed != null) {
      return RemixButton(
        key: ValueKey('agent-source-${source.id}'),
        label: source.title,
        onPressed: () => onPressed(source),
        style: sourceStyle,
      );
    }

    return Box(
      key: ValueKey('agent-source-${source.id}'),
      styleSpec: spec.source,
      child: StyledText(source.title, styleSpec: spec.sourceLabel),
    );
  }

  @override
  Widget build(BuildContext context) {
    final label = (labelBuilder ?? defaultLabel)(sources.length);

    return RemixStyleSpecBuilder<AgentSourcesSpec>(
      style: _layout.merge(style),
      styleSpec: styleSpec,
      builder: (context, spec) => RemixDisclosure(
        expanded: expanded,
        defaultExpanded: defaultExpanded,
        onExpandedChanged: onExpandedChanged,
        semanticLabel: label,
        style: disclosureStyle,
        trigger: const SizedBox.shrink(),
        triggerBuilder: (context, state, _) {
          final icon = agentGlyph(
            context,
            glyphBuilder,
            AgentGlyph.sources,
            spec.icon,
          );
          final indicator = agentGlyph(
            context,
            glyphBuilder,
            state.isExpanded
                ? AgentGlyph.disclosureOpen
                : AgentGlyph.disclosureClosed,
            spec.indicator,
          );

          return RowBox(
            styleSpec: spec.trigger,
            children: [
              ?icon,
              Flexible(child: StyledText(label, styleSpec: spec.label)),
              ?indicator,
            ],
          );
        },
        content: WrapBox(
          styleSpec: spec.list,
          children: [for (final source in sources) _source(spec, source)],
        ),
      ),
    );
  }
}

/// Resolved visual properties for [AgentSources].
///
/// Every slot is empty by default; presets supply the look.
// No target: mix_generator 2.2.0-beta.3 emits InvalidType for constructor
// parameters typed with stylers generated in the same build (the nested
// component styles), as CalendarSpec notes.
@MixableSpec()
@immutable
final class AgentSourcesSpec with _$AgentSourcesSpec {
  /// The line: glyph, label and indicator.
  @override
  final StyleSpec<FlexBoxSpec> trigger;

  /// The line's leading glyph.
  @override
  final StyleSpec<IconSpec> icon;

  /// The line's text.
  @override
  final StyleSpec<TextSpec> label;

  /// The glyph that shows whether the list is open.
  @override
  final StyleSpec<IconSpec> indicator;

  /// The list of sources.
  @override
  final StyleSpec<WrapBoxSpec> list;

  /// A source that is not a button.
  @override
  final StyleSpec<BoxSpec> source;

  /// The title of a source that is not a button.
  @override
  final StyleSpec<TextSpec> sourceLabel;

  /// Creates a spec; every slot defaults to empty.
  const AgentSourcesSpec({
    StyleSpec<FlexBoxSpec>? trigger,
    StyleSpec<IconSpec>? icon,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? indicator,
    StyleSpec<WrapBoxSpec>? list,
    StyleSpec<BoxSpec>? source,
    StyleSpec<TextSpec>? sourceLabel,
  }) : trigger = trigger ?? const StyleSpec(spec: FlexBoxSpec()),
       icon = icon ?? const StyleSpec(spec: IconSpec()),
       label = label ?? const StyleSpec(spec: TextSpec()),
       indicator = indicator ?? const StyleSpec(spec: IconSpec()),
       list = list ?? const StyleSpec(spec: WrapBoxSpec()),
       source = source ?? const StyleSpec(spec: BoxSpec()),
       sourceLabel = sourceLabel ?? const StyleSpec(spec: TextSpec());
}
