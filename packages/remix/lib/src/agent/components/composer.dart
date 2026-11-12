import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../components/icon_button/icon_button.dart';
import '../../components/textfield/textfield.dart';
import '../../utilities/remix_style.dart';
import '../behavior/composer.dart';
import 'glyphs.dart';

part 'composer.g.dart';

/// The prompt input of a conversation: a growing text field over a toolbar
/// with the host's actions and Send, which becomes Stop while a run is live.
///
/// The field starts at one line and grows with the draft up to
/// [AgentComposerSpec.fieldMaxHeight], then scrolls. A tap anywhere on the
/// composer's surface focuses the field.
///
/// [controller] holds the draft and the run state: while
/// [AgentComposerController.running] is true, the composer offers Stop
/// instead of Send. Enter sends, Shift+Enter adds a line, and Enter during
/// IME composition belongs to the input method (see
/// [AgentComposerController.handleKeyEvent]). Without [onSubmit], the
/// composer is a plain multiline field.
///
/// The surface resolves `focused` while the field has focus, so a style can
/// mark the whole composer.
class AgentComposer extends StatefulWidget {
  /// Creates a composer.
  const AgentComposer({
    super.key,
    this.controller,
    this.focusNode,
    this.onSubmit,
    this.onStop,
    this.enabled = true,
    this.autofocus = false,
    this.hintText = 'Message',
    this.semanticLabel = 'Message',
    this.leading,
    this.trailing,
    this.submitLabel = 'Send',
    this.stopLabel = 'Stop',
    this.glyphBuilder,
    this.fieldStyle = const TextFieldStyler.create(),
    this.submitStyle = const IconButtonStyler.create(),
    this.stopStyle = const IconButtonStyler.create(),
    this.style = const AgentComposerStyler.create(),
    this.styleSpec,
  });

  /// The draft and the run state; when null, the composer owns one.
  final AgentComposerController? controller;

  /// The field's focus node; when null, the composer owns one.
  final FocusNode? focusNode;

  /// Receives the trimmed draft when the reader sends it.
  final ValueChanged<String>? onSubmit;

  /// Stops the live run.
  final VoidCallback? onStop;

  /// Whether the reader can edit and send.
  final bool enabled;

  /// Whether the field takes focus when it first builds.
  final bool autofocus;

  /// The field's placeholder.
  final String hintText;

  /// The composer's accessible name.
  final String semanticLabel;

  /// The host's actions at the toolbar's leading edge, such as attach.
  final Widget? leading;

  /// The host's actions before Send.
  final Widget? trailing;

  /// The accessible name of Send.
  final String submitLabel;

  /// The accessible name of Stop.
  final String stopLabel;

  /// Draws [AgentGlyph.send] and [AgentGlyph.stop]; defaults to the
  /// nearest [AgentGlyphs].
  final AgentGlyphBuilder? glyphBuilder;

  /// The style of the text field.
  final TextFieldStyler fieldStyle;

  /// The style of Send.
  final IconButtonStyler submitStyle;

  /// The style of Stop.
  final IconButtonStyler stopStyle;

  /// The style of the surface and the toolbar.
  final AgentComposerStyler style;

  /// A resolved spec that bypasses [style].
  final AgentComposerSpec? styleSpec;

  @override
  State<AgentComposer> createState() => _AgentComposerState();
}

class _AgentComposerState extends State<AgentComposer> {
  AgentComposerController? _ownedController;
  FocusNode? _ownedFocusNode;
  final WidgetStatesController _states = WidgetStatesController();
  late AgentComposerController _controller;
  late bool _canSubmit;
  late bool _running;

  FocusNode get _focusNode =>
      widget.focusNode ?? (_ownedFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _adopt(widget.controller ?? (_ownedController = AgentComposerController()));
    _focusNode.addListener(_handleFocus);
    _states.update(WidgetState.disabled, !widget.enabled);
  }

  void _adopt(AgentComposerController controller) {
    _controller = controller..addListener(_handleController);
    _canSubmit = controller.canSubmit;
    _running = controller.running;
  }

  @override
  void didUpdateWidget(AgentComposer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.controller, widget.controller)) {
      final seed = _controller.value;
      _controller.removeListener(_handleController);
      final superseded = _ownedController;
      _ownedController = null;
      _adopt(
        widget.controller ??
            (_ownedController = AgentComposerController.fromValue(seed)),
      );
      _disposeAfterFrame(superseded);
    }
    if (!identical(oldWidget.focusNode, widget.focusNode)) {
      final previous = oldWidget.focusNode ?? _ownedFocusNode;
      previous?.removeListener(_handleFocus);
      if (widget.focusNode != null) {
        _disposeAfterFrame(_ownedFocusNode);
        _ownedFocusNode = null;
      }
      _focusNode.addListener(_handleFocus);
    }
    _states.update(WidgetState.disabled, !widget.enabled);
  }

  /// Disposes a superseded owned object once the field has let go of it.
  void _disposeAfterFrame(ChangeNotifier? superseded) {
    if (superseded == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) => superseded.dispose());
  }

  void _handleController() {
    final canSubmit = _controller.canSubmit;
    final running = _controller.running;
    if (canSubmit == _canSubmit && running == _running) return;
    setState(() {
      _canSubmit = canSubmit;
      _running = running;
    });
  }

  void _handleFocus() =>
      _states.update(WidgetState.focused, _focusNode.hasFocus);

  bool get _sendEnabled =>
      widget.enabled && widget.onSubmit != null && _canSubmit;

  void _send() {
    final onSubmit = widget.onSubmit;
    if (!widget.enabled || onSubmit == null) return;
    final prompt = _controller.submit();
    if (prompt != null) onSubmit(prompt);
    _focusNode.requestFocus();
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    final onSubmit = widget.onSubmit;

    return _controller.handleKeyEvent(
      event,
      onSubmit: onSubmit,
      allowSubmit: widget.enabled,
    );
  }

  Widget _action() {
    final running = _running;
    final glyph = running ? AgentGlyph.stop : AgentGlyph.send;

    return RemixIconButton(
      key: ValueKey(running ? 'agent-composer-stop' : 'agent-composer-send'),
      icon: null,
      iconBuilder: (context, iconSpec, icon) =>
          agentGlyph(
            context,
            widget.glyphBuilder,
            glyph,
            StyleSpec(spec: iconSpec),
          ) ??
          const SizedBox.shrink(),
      semanticLabel: running ? widget.stopLabel : widget.submitLabel,
      enabled: running ? widget.enabled && widget.onStop != null : _sendEnabled,
      onPressed: running ? widget.onStop : _send,
      style: running ? widget.stopStyle : widget.submitStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return RemixStyleSpecBuilder<AgentComposerSpec>(
      style: widget.style,
      styleSpec: widget.styleSpec,
      controller: _states,
      builder: (context, spec) {
        final leading = widget.leading;
        final trailing = widget.trailing;
        final maxHeight = spec.fieldMaxHeight;

        return Semantics(
          container: true,
          explicitChildNodes: true,
          label: widget.semanticLabel,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            excludeFromSemantics: true,
            onTap: widget.enabled ? _focusNode.requestFocus : null,
            child: Box(
              styleSpec: spec.container,
              // The surface's state belongs to the surface; the controls
              // inside resolve their own.
              child: WidgetStateProvider(
                states: const {},
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Box(
                      styleSpec: spec.field,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: maxHeight ?? double.infinity,
                        ),
                        child: Focus(
                          canRequestFocus: false,
                          skipTraversal: true,
                          onKeyEvent: _handleKey,
                          child: RemixTextArea(
                            controller: _controller,
                            focusNode: _focusNode,
                            enabled: widget.enabled,
                            autofocus: widget.autofocus,
                            hintText: widget.hintText,
                            semanticLabel: widget.semanticLabel,
                            minLines: 1,
                            maxLines: null,
                            style: widget.fieldStyle,
                          ),
                        ),
                      ),
                    ),
                    RowBox(
                      styleSpec: spec.toolbar,
                      children: [
                        ?leading,
                        const Spacer(),
                        ?trailing,
                        _action(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_handleController);
    _focusNode.removeListener(_handleFocus);
    _ownedController?.dispose();
    _ownedFocusNode?.dispose();
    _states.dispose();
    super.dispose();
  }
}

/// Resolved visual properties for an [AgentComposer].
///
/// Every slot is empty by default; presets supply the look.
// No target: mix_generator 2.2.0-beta.3 emits InvalidType for constructor
// parameters typed with stylers generated in the same build (the nested
// component styles), as CalendarSpec notes.
@MixableSpec()
@immutable
final class AgentComposerSpec with _$AgentComposerSpec {
  /// The composer's surface.
  @override
  final StyleSpec<BoxSpec> container;

  /// Wraps the text field.
  @override
  final StyleSpec<BoxSpec> field;

  /// The tallest the field grows before it scrolls, such as 240.
  @override
  final double? fieldMaxHeight;

  /// The toolbar under the field.
  @override
  final StyleSpec<FlexBoxSpec> toolbar;

  /// Creates a spec; every slot defaults to empty.
  const AgentComposerSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<BoxSpec>? field,
    this.fieldMaxHeight,
    StyleSpec<FlexBoxSpec>? toolbar,
  }) : container = container ?? const StyleSpec(spec: BoxSpec()),
       field = field ?? const StyleSpec(spec: BoxSpec()),
       toolbar = toolbar ?? const StyleSpec(spec: FlexBoxSpec());
}
