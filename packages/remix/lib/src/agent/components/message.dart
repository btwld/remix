import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../components/button/button.dart';
import '../../utilities/remix_style.dart';
import '../behavior/disclosure.dart';
import '../models/statuses.dart';
import 'internal.dart';

part 'message.g.dart';

/// One message of a conversation: the reader's bubble or the assistant's
/// reply.
///
/// A [AgentRole.user] message sits at the end of the line, as wide as its
/// text up to [AgentMessageSpec.maxWidthFactor] of the line. When it is taller
/// than [AgentMessageSpec.collapsedHeight], it shows that much and offers
/// "Show more"; the clipped text stays readable to assistive technology.
///
/// An [AgentRole.assistant] message spans the line and never collapses. Its
/// [header] and [footer] slots hold what surrounds the reply, such as a name
/// or actions.
///
/// Style each role with [AgentMessageStylerRole.onUser] and
/// [AgentMessageStylerRole.onAssistant].
class AgentMessage extends StatefulWidget {
  /// Creates a message from [role] holding [child].
  const AgentMessage({
    super.key,
    required this.role,
    required this.child,
    this.header,
    this.footer,
    this.semanticLabel,
    this.expanded,
    this.defaultExpanded = false,
    this.onExpandedChanged,
    this.showMoreLabel = 'Show more',
    this.showLessLabel = 'Show less',
    this.toggleStyle = const ButtonStyler.create(),
    this.style = const AgentMessageStyler.create(),
    this.styleSpec,
  });

  /// Who wrote the message.
  final AgentRole role;

  /// The message content, usually text.
  final Widget child;

  /// Shown above the content.
  final Widget? header;

  /// Shown below the content.
  final Widget? footer;

  /// The message's accessible name; defaults to "User message" or
  /// "Assistant message".
  final String? semanticLabel;

  /// Whether a long user message shows in full. Null lets the message own
  /// the state, starting at [defaultExpanded].
  final bool? expanded;

  /// Whether a long user message starts in full when uncontrolled.
  final bool defaultExpanded;

  /// Receives each request to show a long user message in full or not.
  final ValueChanged<bool>? onExpandedChanged;

  /// The label of the action that shows a long user message in full.
  final String showMoreLabel;

  /// The label of the action that collapses a long user message again.
  final String showLessLabel;

  /// The style of the show more and show less action.
  final ButtonStyler toggleStyle;

  /// The message's style.
  final AgentMessageStyler style;

  /// A resolved spec that bypasses [style].
  final AgentMessageSpec? styleSpec;

  @override
  State<AgentMessage> createState() => _AgentMessageState();
}

class _AgentMessageState extends State<AgentMessage> {
  late final AgentDisclosureController _disclosure;
  bool _overflows = false;

  bool get _isUser => widget.role == AgentRole.user;

  @override
  void initState() {
    super.initState();
    _disclosure = AgentDisclosureController(
      expanded: widget.expanded,
      defaultExpanded: widget.defaultExpanded,
      onExpandedChanged: widget.onExpandedChanged,
    )..addListener(_changed);
  }

  @override
  void didUpdateWidget(AgentMessage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _disclosure
      ..onExpandedChanged = widget.onExpandedChanged
      ..updateExpanded(widget.expanded);
  }

  void _changed() {
    if (mounted) setState(() {});
  }

  void _handleOverflow(bool overflows) {
    if (mounted && overflows != _overflows) {
      setState(() => _overflows = overflows);
    }
  }

  Widget _content(AgentMessageSpec spec) {
    final height = spec.collapsedHeight;
    if (!_isUser || height == null) return widget.child;
    final collapsed = !_disclosure.expanded;
    Widget content = AgentOverflowClip(
      maxHeight: height,
      clip: collapsed,
      onOverflowChanged: _handleOverflow,
      child: widget.child,
    );
    if (collapsed && _overflows) {
      // The clipped text stays in the semantics tree, but nothing hidden
      // takes a pointer or focus.
      content = IgnorePointer(child: ExcludeFocus(child: content));
    }
    if (!_overflows) return content;
    final label = _disclosure.expanded
        ? widget.showLessLabel
        : widget.showMoreLabel;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        content,
        RemixButton(
          key: const ValueKey('agent-message-toggle'),
          label: label,
          onPressed: () => _disclosure.toggle(!_disclosure.expanded),
          style: widget.toggleStyle,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isUser = _isUser;

    return AgentValueScope<AgentRole>(
      value: widget.role,
      child: RemixStyleSpecBuilder<AgentMessageSpec>(
        style: widget.style,
        styleSpec: widget.styleSpec,
        builder: (context, spec) {
          final surface = Box(
            styleSpec: spec.surface,
            child: RemixDefaultContentStyle(
              text: spec.text,
              child: _content(spec),
            ),
          );
          final header = widget.header;
          final footer = widget.footer;
          final column = Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: isUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.stretch,
            children: [
              if (header != null) Box(styleSpec: spec.header, child: header),
              surface,
              if (footer != null) Box(styleSpec: spec.footer, child: footer),
            ],
          );
          final factor = spec.maxWidthFactor;

          return Semantics(
            container: true,
            explicitChildNodes: true,
            label:
                widget.semanticLabel ??
                (isUser ? 'User message' : 'Assistant message'),
            child: Box(
              styleSpec: spec.container,
              child: !isUser
                  ? column
                  : LayoutBuilder(
                      builder: (context, constraints) => Align(
                        alignment: AlignmentDirectional.centerEnd,
                        heightFactor: 1,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: factor == null
                                ? constraints.maxWidth
                                : constraints.maxWidth * factor,
                          ),
                          child: column,
                        ),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _disclosure.dispose();
    super.dispose();
  }
}

final _roleVariants = agentValueVariants<AgentRole>(
  'agentMessage.role',
  AgentRole.values,
);

/// Role variants for [AgentMessageStyler].
extension AgentMessageStylerRole on AgentMessageStyler {
  /// Applies [value] to messages from [AgentRole.user].
  AgentMessageStyler onUser(AgentMessageStyler value) =>
      variant(_roleVariants[AgentRole.user]!, value);

  /// Applies [value] to messages from [AgentRole.assistant].
  AgentMessageStyler onAssistant(AgentMessageStyler value) =>
      variant(_roleVariants[AgentRole.assistant]!, value);
}

/// Resolved visual properties for an [AgentMessage].
///
/// Every slot is empty by default; presets supply the look.
// No target: mix_generator 2.2.0-beta.3 emits InvalidType for constructor
// parameters typed with stylers generated in the same build (the nested
// component styles), as CalendarSpec notes.
@MixableSpec()
@immutable
final class AgentMessageSpec with _$AgentMessageSpec {
  /// The message's line.
  @override
  final StyleSpec<BoxSpec> container;

  /// The surface behind the content: the bubble of a user message.
  @override
  final StyleSpec<BoxSpec> surface;

  /// The default text style of the content.
  @override
  final StyleSpec<TextSpec> text;

  /// Wraps [AgentMessage.header].
  @override
  final StyleSpec<BoxSpec> header;

  /// Wraps [AgentMessage.footer].
  @override
  final StyleSpec<BoxSpec> footer;

  /// The widest share of the line a user message takes, such as 0.75.
  @override
  final double? maxWidthFactor;

  /// The height above which a user message collapses.
  @override
  final double? collapsedHeight;

  /// Creates a spec; every slot defaults to empty.
  const AgentMessageSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<BoxSpec>? surface,
    StyleSpec<TextSpec>? text,
    StyleSpec<BoxSpec>? header,
    StyleSpec<BoxSpec>? footer,
    this.maxWidthFactor,
    this.collapsedHeight,
  }) : container = container ?? const StyleSpec(spec: BoxSpec()),
       surface = surface ?? const StyleSpec(spec: BoxSpec()),
       text = text ?? const StyleSpec(spec: TextSpec()),
       header = header ?? const StyleSpec(spec: BoxSpec()),
       footer = footer ?? const StyleSpec(spec: BoxSpec());
}
