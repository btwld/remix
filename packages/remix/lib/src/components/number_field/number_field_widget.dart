part of 'number_field.dart';

/// A numeric field with decrement and increment controls on either side of
/// the editor.
///
/// The value is controlled: [onChanged] proposes a value, and the field
/// shows [value] until it is rebuilt with the new one. Typing edits a draft
/// that commits on submit or when focus leaves. An empty draft commits null,
/// text that does not parse reverts, and a number is clamped to [min] and
/// [max].
///
/// The editor is the only Tab stop. While it has focus, Up and Down step by
/// [step], Page Up and Page Down by [largeStep], and Home and End jump to
/// finite bounds. The step controls take no focus, so a press keeps the
/// editor focused. They turn disabled at their bound.
///
/// Assistive technology reads the editor as a text field named by
/// [semanticLabel] or [label], with the value, the next and previous values,
/// and increase and decrease actions. Each step control is its own button,
/// named by [incrementSemanticLabel] and [decrementSemanticLabel]. The
/// visible label and helper text are not read twice.
///
/// ```dart
/// RemixNumberField(
///   label: 'Guests',
///   value: guests,
///   min: 1,
///   max: 12,
///   onChanged: (next) => setState(() => guests = next ?? 1),
/// )
/// ```
class RemixNumberField extends StatefulWidget {
  const RemixNumberField({
    super.key,
    required this.value,
    this.onChanged,
    this.min = double.negativeInfinity,
    this.max = double.infinity,
    this.step = 1,
    this.largeStep,
    this.format,
    this.parse,
    this.controller,
    this.focusNode,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.error = false,
    this.label,
    this.hintText,
    this.helperText,
    this.semanticLabel,
    this.semanticHint,
    this.incrementSemanticLabel = 'Increase',
    this.decrementSemanticLabel = 'Decrease',
    this.incrementIcon,
    this.decrementIcon,
    this.textInputAction = TextInputAction.done,
    this.style = const NumberFieldStyler.create(),
    this.styleSpec,
  });

  /// The committed value, or null for an empty field.
  final double? value;

  /// Receives a proposed value. Null makes the field read-only.
  final ValueChanged<double?>? onChanged;

  /// The smallest value. Negative infinity leaves the field unbounded below.
  final double min;

  /// The largest value. Infinity leaves the field unbounded above.
  final double max;

  /// The amount the step controls, Up and Down move.
  final double step;

  /// The amount Page Up and Page Down move. Defaults to ten steps.
  final double? largeStep;

  /// Turns a value into editor text.
  final String Function(double value)? format;

  /// Turns trimmed, nonempty editor text into a value, or null.
  final double? Function(String text)? parse;

  /// Optional caller-owned controller.
  final TextEditingController? controller;

  /// Optional caller-owned editor focus node.
  final FocusNode? focusNode;

  /// Whether the field accepts interaction.
  final bool enabled;

  /// Whether the field allows selection but not editing or stepping.
  final bool readOnly;

  /// Whether the editor takes focus when first built.
  final bool autofocus;

  /// Whether the field shows its error state and reports itself invalid.
  final bool error;

  /// The visible label above the shell. Also the default accessible name.
  final String? label;

  /// Placeholder shown while the editor is empty.
  final String? hintText;

  /// Text below the shell. Read as the editor's hint.
  final String? helperText;

  /// The editor's accessible name. Defaults to [label].
  final String? semanticLabel;

  /// The editor's accessible hint. Defaults to [helperText].
  final String? semanticHint;

  /// The increment control's accessible name.
  final String incrementSemanticLabel;

  /// The decrement control's accessible name.
  final String decrementSemanticLabel;

  /// The increment glyph. Defaults to a plus sign drawn as text.
  final IconData? incrementIcon;

  /// The decrement glyph. Defaults to a minus sign drawn as text.
  final IconData? decrementIcon;

  /// The keyboard's action button. Pressing it commits the draft.
  final TextInputAction textInputAction;

  /// Merged last into the field's style.
  final NumberFieldStyler style;

  /// A resolved spec that replaces [style].
  final NumberFieldSpec? styleSpec;

  static final styleFrom = NumberFieldStyler.new;

  @override
  State<RemixNumberField> createState() => _RemixNumberFieldState();
}

class _RemixNumberFieldState extends State<RemixNumberField> {
  late final WidgetStatesController _states;
  FocusNode? _ownedFocusNode;
  FocusNode get _focusNode => widget.focusNode ?? _ownedFocusNode!;

  @override
  void initState() {
    super.initState();
    _states = WidgetStatesController({
      if (!widget.enabled) WidgetState.disabled,
      if (widget.error) WidgetState.error,
    });
    if (widget.focusNode == null) {
      _ownedFocusNode = FocusNode(debugLabel: 'RemixNumberField (internal)');
    }
    _focusNode.addListener(_syncFocus);
  }

  @override
  void didUpdateWidget(RemixNumberField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      (oldWidget.focusNode ?? _ownedFocusNode)?.removeListener(_syncFocus);
      if (widget.focusNode == null) {
        _ownedFocusNode = FocusNode(debugLabel: 'RemixNumberField (internal)');
      } else {
        // Deferred: the editor still reads the outgoing node this frame.
        final obsolete = _ownedFocusNode;
        _ownedFocusNode = null;
        if (obsolete != null) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => obsolete.dispose(),
          );
        }
      }
      _focusNode.addListener(_syncFocus);
      _syncFocus();
    }
    _states
      ..update(WidgetState.disabled, !widget.enabled)
      ..update(WidgetState.error, widget.error);
    if (!widget.enabled) _states.update(WidgetState.hovered, false);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_syncFocus);
    _ownedFocusNode?.dispose();
    _states.dispose();
    super.dispose();
  }

  void _syncFocus() => _states.update(WidgetState.focused, _focusNode.hasFocus);

  NumberFieldStyler get _style => NumberFieldStyler(
    layout: FlexBoxStyler(
      direction: Axis.vertical,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
    ),
    field: TextFieldStyler(textAlign: TextAlign.center),
    step: NumberFieldStepStyler(container: BoxStyler(alignment: .center)),
  ).merge(widget.style);

  Widget _buildStep({
    required VoidCallback? onPressed,
    required String semanticLabel,
    required IconData? icon,
    required String glyph,
    required NumberFieldStyler style,
  }) => _NumberFieldStep(
    onPressed: onPressed,
    semanticLabel: semanticLabel,
    icon: icon,
    glyph: glyph,
    style: widget.styleSpec == null ? style : null,
    styleSpec: widget.styleSpec?.step,
  );

  Widget _buildResolved(
    BuildContext context,
    NakedNumberFieldBindings field,
    NumberFieldSpec spec,
    NumberFieldStyler style,
  ) {
    final editor = field.spinButton(
      RemixTextField(
        controller: field.controller,
        focusNode: field.focusNode,
        enabled: field.enabled,
        readOnly: field.readOnly,
        autofocus: widget.autofocus,
        error: widget.error,
        keyboardType: field.keyboardType,
        textInputAction: widget.textInputAction,
        onSubmitted: field.onSubmitted,
        hintText: widget.hintText,
        semanticLabel: widget.semanticLabel ?? widget.label,
        semanticHint: widget.semanticHint ?? widget.helperText,
        styleSpec: spec.field.spec,
      ),
    );

    Widget shell = RemixBoxAdapter(
      styleSpec: spec.container,
      containerEffects: spec.containerEffects,
      child: Row(
        spacing: spec.spacing ?? 0,
        children: [
          _buildStep(
            onPressed: field.decrement,
            semanticLabel: widget.decrementSemanticLabel,
            icon: widget.decrementIcon,
            glyph: '−',
            style: style,
          ),
          Expanded(child: editor),
          _buildStep(
            onPressed: field.increment,
            semanticLabel: widget.incrementSemanticLabel,
            icon: widget.incrementIcon,
            glyph: '+',
            style: style,
          ),
        ],
      ),
    );
    if (widget.enabled) {
      shell = MouseRegion(
        onEnter: (_) => _states.update(WidgetState.hovered, true),
        onExit: (_) => _states.update(WidgetState.hovered, false),
        child: shell,
      );
    }

    if (widget.label == null && widget.helperText == null) return shell;
    return FlexBox(
      styleSpec: spec.layout,
      children: [
        if (widget.label != null)
          ExcludeSemantics(
            child: StyledText(widget.label!, styleSpec: spec.label),
          ),
        shell,
        if (widget.helperText != null)
          ExcludeSemantics(
            child: StyledText(widget.helperText!, styleSpec: spec.helperText),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = _style;
    return NakedNumberField(
      value: widget.value,
      onChanged: widget.onChanged,
      min: widget.min,
      max: widget.max,
      step: widget.step,
      largeStep: widget.largeStep,
      format: widget.format,
      parse: widget.parse,
      controller: widget.controller,
      focusNode: _focusNode,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      builder: (context, field) => RemixStyleSpecBuilder<NumberFieldSpec>(
        style: style,
        styleSpec: widget.styleSpec,
        controller: _states,
        builder: (context, spec) => _buildResolved(context, field, spec, style),
      ),
    );
  }
}

class _NumberFieldStep extends StatelessWidget {
  const _NumberFieldStep({
    required this.onPressed,
    required this.semanticLabel,
    required this.icon,
    required this.glyph,
    required this.style,
    required this.styleSpec,
  });

  final VoidCallback? onPressed;
  final String semanticLabel;
  final IconData? icon;
  final String glyph;
  final NumberFieldStyler? style;
  final StyleSpec<NumberFieldStepSpec>? styleSpec;

  Widget _glyph(NumberFieldStepSpec spec) {
    final iconSpec = spec.icon.spec;
    final Widget child = icon != null
        ? StyledIcon(icon: icon!, styleSpec: spec.icon)
        : Text(
            glyph,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: iconSpec.color,
              fontSize: iconSpec.size,
              height: 1,
            ),
          );
    final scale = spec.iconScale ?? 1;
    return scale == 1 ? child : Transform.scale(scale: scale, child: child);
  }

  @override
  Widget build(BuildContext context) {
    // A step control never takes focus: the editor stays the one Tab stop and
    // keeps focus, and its draft, through a press.
    return ExcludeFocus(
      child: TextFieldTapRegion(
        child: NakedButton(
          onPressed: onPressed,
          semanticLabel: semanticLabel,
          builder: (context, state, _) => WidgetStateProvider(
            states: state.states,
            child: Builder(
              builder: (context) => StyleSpecBuilder<NumberFieldStepSpec>(
                // Resolve under this control's states so pressed and hovered
                // variants apply to it alone.
                styleSpec: styleSpec ?? style!.build(context).spec.step,
                builder: (context, spec) => RemixBoxAdapter(
                  styleSpec: spec.container,
                  containerEffects: spec.containerEffects,
                  child: _glyph(spec),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
