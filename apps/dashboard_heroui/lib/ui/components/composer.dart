import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../support/functional_glyph.dart';

part 'composer.g.dart';

/// Growable prompt input composed from Remix text-area and icon-button controls.
class UiComposer extends StatefulWidget {
  const UiComposer({
    super.key,
    this.controller,
    this.initialValue,
    this.focusNode,
    this.onChanged,
    this.onSubmit,
    this.onStop,
    this.running = false,
    this.enabled = true,
    this.canSubmit,
    this.clearOnSubmit = true,
    this.autofocus = false,
    this.hintText = 'Message',
    this.semanticLabel = 'Message',
    this.minLines = 2,
    this.maxLines = 8,
    this.leading,
    this.trailing,
    this.submitIconBuilder,
    this.stopIconBuilder,
    this.submitLabel = 'Send',
    this.stopLabel = 'Stop',
    this.surfaceStyle = const CardStyler.create(),
    this.fieldStyle = const TextFieldStyler.create(),
    this.submitStyle = const IconButtonStyler.create(),
    this.stopStyle = const IconButtonStyler.create(),
    this.style = const UiComposerStyler.create(),
    this.styleSpec,
  }) : assert(
         controller == null || initialValue == null,
         'initialValue cannot be used with an external controller.',
       );

  final TextEditingController? controller;
  final String? initialValue;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmit;
  final VoidCallback? onStop;
  final bool running;
  final bool enabled;
  final bool? canSubmit;
  final bool clearOnSubmit;
  final bool autofocus;
  final String hintText;
  final String semanticLabel;
  final int minLines;
  final int maxLines;
  final Widget? leading;
  final Widget? trailing;
  final RemixIconButtonIconBuilder? submitIconBuilder;
  final RemixIconButtonIconBuilder? stopIconBuilder;
  final String submitLabel;
  final String stopLabel;
  final CardStyler surfaceStyle;
  final TextFieldStyler fieldStyle;
  final IconButtonStyler submitStyle;
  final IconButtonStyler stopStyle;
  final UiComposerStyler style;
  final UiComposerSpec? styleSpec;

  @override
  State<UiComposer> createState() => _UiComposerState();
}

class _UiComposerState extends State<UiComposer> {
  TextEditingController? _ownedController;
  FocusNode? _ownedFocusNode;
  late TextEditingController _controller;

  /// The last text reported through [UiComposer.onChanged].
  late String _text;

  /// Whether the draft has something to send. Typing rebuilds the composer
  /// only when this flips; the text field repaints its own text.
  late bool _hasDraft;

  /// Whether the text field holds focus, published to [UiComposer.surfaceStyle]
  /// as [WidgetState.focused] so a recipe can mark the whole card, the way a
  /// text input marks its own frame.
  bool _fieldFocused = false;

  FocusNode get _focusNode =>
      widget.focusNode ?? (_ownedFocusNode ??= FocusNode());

  bool get _isComposing {
    final composing = _controller.value.composing;
    return composing.isValid && !composing.isCollapsed;
  }

  bool get _canSubmit =>
      widget.enabled &&
      !widget.running &&
      _hasDraft &&
      widget.onSubmit != null &&
      (widget.canSubmit ?? true);

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ??
        (_ownedController = TextEditingController(text: widget.initialValue));
    _adoptText();
    _controller.addListener(_handleControllerChanged);
  }

  void _adoptText() {
    _text = _controller.text;
    _hasDraft = _text.trim().isNotEmpty;
  }

  void _handleControllerChanged() {
    final next = _controller.text;
    if (next == _text) return;
    _text = next;
    final hasDraft = next.trim().isNotEmpty;
    if (hasDraft != _hasDraft) setState(() => _hasDraft = hasDraft);
    widget.onChanged?.call(next);
  }

  @override
  void didUpdateWidget(UiComposer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.controller, widget.controller)) {
      final seed = _controller.text;
      _controller.removeListener(_handleControllerChanged);
      final oldOwnedController = _ownedController;
      _ownedController = null;
      _controller =
          widget.controller ??
          (_ownedController = TextEditingController(text: seed));
      _adoptText();
      _controller.addListener(_handleControllerChanged);
      _disposeAfterFrame(oldOwnedController);
    }
    if (!identical(oldWidget.focusNode, widget.focusNode)) {
      final oldOwnedFocusNode = _ownedFocusNode;
      _ownedFocusNode = null;
      _disposeAfterFrame(oldOwnedFocusNode);
    }
  }

  /// Releases a superseded owned object once the child has let go of it.
  ///
  /// The same deferral the transcript uses for its scroll controller: the child
  /// RemixTextArea still holds the old controller and focus node until this
  /// frame's rebuild detaches them, and detaching touches a disposed object.
  void _disposeAfterFrame(ChangeNotifier? superseded) {
    if (superseded == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) => superseded.dispose());
  }

  void _submit() {
    if (!_canSubmit || _isComposing) return;
    final prompt = _text.trim();
    widget.onSubmit?.call(prompt);
    if (widget.clearOnSubmit) _controller.clear();
    _focusNode.requestFocus();
  }

  /// Enter belongs to sending whenever the composer can send at all.
  ///
  /// It submits when there is something to send, and otherwise does nothing:
  /// an empty draft, a live run or `canSubmit: false` must not turn Enter into
  /// a newline, and a held Enter must not add newlines after it sent. Shift+
  /// Enter and IME composition keep the field's own handling, and a composer
  /// without [UiComposer.onSubmit] is a plain multiline field.
  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is KeyUpEvent) return KeyEventResult.ignored;
    final isEnter =
        event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter;
    if (!isEnter ||
        widget.onSubmit == null ||
        HardwareKeyboard.instance.isShiftPressed ||
        _isComposing) {
      return KeyEventResult.ignored;
    }
    if (event is KeyDownEvent) _submit();
    return KeyEventResult.handled;
  }

  Widget _defaultSubmitIcon(
    BuildContext context,
    IconSpec spec,
    IconData? icon,
  ) => UiFunctionalGlyph(kind: .send, spec: spec);

  Widget _defaultStopIcon(
    BuildContext context,
    IconSpec spec,
    IconData? icon,
  ) => UiFunctionalGlyph(kind: .stop, spec: spec);

  @override
  Widget build(BuildContext context) {
    return RemixStyleSpecBuilder<UiComposerSpec>(
      style: widget.style,
      styleSpec: widget.styleSpec,
      // Keep the field and action in separate accessibility nodes.
      builder: (context, spec) => Semantics(
        container: true,
        explicitChildNodes: true,
        label: widget.semanticLabel,
        child: Focus(
          canRequestFocus: false,
          skipTraversal: true,
          onKeyEvent: _handleKey,
          child: WidgetStateProvider(
            states: {if (_fieldFocused) WidgetState.focused},
            child: RemixCard(
              style: widget.surfaceStyle,
              // The card's state belongs to the card alone, as a disclosure
              // panel's does; its controls resolve their own.
              child: WidgetStateProvider(
                states: const {},
                child: _content(spec),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _content(UiComposerSpec spec) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Focus(
        canRequestFocus: false,
        skipTraversal: true,
        onFocusChange: (focused) {
          if (focused != _fieldFocused) {
            setState(() => _fieldFocused = focused);
          }
        },
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: RemixTextArea(
            controller: _controller,
            focusNode: _focusNode,
            enabled: widget.enabled,
            autofocus: widget.autofocus,
            hintText: widget.hintText,
            semanticLabel: widget.semanticLabel,
            minLines: widget.minLines,
            maxLines: widget.maxLines,
            textInputAction: TextInputAction.newline,
            style: widget.fieldStyle,
          ),
        ),
      ),
      RowBox(
        styleSpec: spec.toolbar,
        children: [
          if (widget.leading != null) widget.leading!,
          const Spacer(),
          if (widget.trailing != null) widget.trailing!,
          Semantics(
            container: true,
            child: RemixIconButton(
              key: ValueKey(
                widget.running ? 'ui-composer-stop' : 'ui-composer-send',
              ),
              icon: null,
              iconBuilder: widget.running
                  ? (widget.stopIconBuilder ?? _defaultStopIcon)
                  : (widget.submitIconBuilder ?? _defaultSubmitIcon),
              semanticLabel: widget.running
                  ? widget.stopLabel
                  : widget.submitLabel,
              enabled: widget.running
                  ? widget.enabled && widget.onStop != null
                  : _canSubmit,
              onPressed: widget.running ? widget.onStop : _submit,
              style: widget.running ? widget.stopStyle : widget.submitStyle,
            ),
          ),
        ],
      ),
    ],
  );

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChanged);
    _ownedController?.dispose();
    _ownedFocusNode?.dispose();
    super.dispose();
  }
}

@MixableSpec(target: UiComposer.new)
@immutable
final class UiComposerSpec with _$UiComposerSpec {
  @override
  final StyleSpec<FlexBoxSpec> toolbar;

  const UiComposerSpec({StyleSpec<FlexBoxSpec>? toolbar})
    : toolbar = toolbar ?? const StyleSpec(spec: FlexBoxSpec());
}
