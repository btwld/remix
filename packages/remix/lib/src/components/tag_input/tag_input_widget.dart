part of 'tag_input.dart';

/// A text field that turns typed text into a list of removable tags.
///
/// The caller owns [value]. Enter, a [separators] character, and focus loss
/// commit the draft; Backspace and the arrow keys pick a tag, and Backspace or
/// Delete removes it. Behavior, keyboard, and semantics come from
/// [NakedTagInput]; this widget adds the label, the wrapping shell, the tags,
/// and the helper text.
///
/// ## Example
///
/// ```dart
/// RemixTagInput(
///   label: 'Topics',
///   hintText: 'Add a tag',
///   value: topics,
///   onChanged: (next) => setState(() => topics = next),
/// )
/// ```
class RemixTagInput extends StatefulWidget {
  const RemixTagInput({
    super.key,
    required this.value,
    this.onChanged,
    this.onDuplicate,
    this.controller,
    this.focusNode,
    this.label,
    this.hintText,
    this.helperText,
    this.error = false,
    this.separators = const [','],
    this.duplicates = NakedTagInputDuplicates.rejectIgnoringCase,
    this.maxTags,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.textInputAction,
    this.semanticLabel,
    this.messages = const NakedTagInputMessages(),
    this.removeLabelBuilder = _defaultRemoveLabel,
    this.style = const TagInputStyler.create(),
    this.styleSpec,
  });

  static final styleFrom = TagInputStyler.new;

  /// The tags, owned by the caller.
  final List<String> value;

  /// Receives the proposed list once per user action. When null, tags
  /// cannot be added or removed.
  final ValueChanged<List<String>>? onChanged;

  /// Called with the index of the existing tag a commit duplicated.
  final ValueChanged<int>? onDuplicate;

  /// Optional caller-owned controller for the draft.
  final TextEditingController? controller;

  /// Optional caller-owned editor focus node.
  final FocusNode? focusNode;

  /// Text above the field. Also the editor's accessible name unless
  /// [semanticLabel] is set.
  final String? label;

  /// Shown while there are no tags and no draft.
  final String? hintText;

  /// Text below the field, announced as the editor's hint, or as its error
  /// when [error] is true.
  final String? helperText;

  /// Whether the field shows its error state.
  final bool error;

  /// Strings that commit the text before them.
  final List<String> separators;

  /// Which commits count as duplicates.
  final NakedTagInputDuplicates duplicates;

  /// The most tags a user can add. Null means no limit.
  final int? maxTags;

  final bool enabled;
  final bool readOnly;
  final bool autofocus;

  /// The keyboard action button. Its press commits the draft.
  final TextInputAction? textInputAction;

  /// The editor's accessible name. Defaults to [label].
  final String? semanticLabel;

  /// Text given to assistive technology.
  final NakedTagInputMessages messages;

  /// Names the remove button for a tag, for pointer tooltips and tests. The
  /// screen reader action uses [NakedTagInputMessages.removeAction].
  final String Function(String tag) removeLabelBuilder;

  final TagInputStyler style;

  /// Optional raw spec that bypasses fluent style resolution.
  final TagInputSpec? styleSpec;

  @override
  State<RemixTagInput> createState() => _RemixTagInputState();
}

String _defaultRemoveLabel(String tag) => 'Remove $tag';

class _RemixTagInputState extends State<RemixTagInput> {
  // Naked owns behavior; this controller only feeds Mix variants for chrome
  // outside the editor (hover over the shell, focus within it).
  late final WidgetStatesController _styleController;

  @override
  void initState() {
    super.initState();
    _styleController = WidgetStatesController({
      if (!widget.enabled) .disabled,
      if (widget.error) .error,
    });
  }

  @override
  void didUpdateWidget(RemixTagInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    _styleController
      ..update(.disabled, !widget.enabled)
      ..update(.error, widget.error);
    if (!widget.enabled) _styleController.update(.hovered, false);
  }

  @override
  void dispose() {
    _styleController.dispose();
    super.dispose();
  }

  Widget _editor(TagInputSpec spec, NakedTagInputBindings field) {
    final showHint = widget.hintText != null && widget.value.isEmpty;
    return NakedTextField(
      controller: field.controller,
      focusNode: field.focusNode,
      enabled: field.enabled,
      readOnly: field.readOnly,
      autofocus: widget.autofocus,
      textInputAction: widget.textInputAction,
      onChanged: field.onChanged,
      onEditingComplete: field.onEditingComplete,
      error: widget.error,
      cursorWidth: spec.cursorWidth ?? 2.0,
      cursorHeight: spec.cursorHeight,
      cursorColor: spec.cursorColor,
      onFocusChange: (focused) => _styleController.update(.focused, focused),
      semanticLabel: widget.semanticLabel ?? widget.label,
      semanticHint: widget.error ? null : widget.helperText,
      semanticErrorText: widget.error ? widget.helperText : null,
      builder: (context, state, editable) {
        final styled = StyleSpecBuilder(
          styleSpec: spec.text,
          builder: (context, textSpec) =>
              DefaultTextStyle.merge(style: textSpec.style, child: editable),
        );
        if (!showHint || state.text.isNotEmpty) return styled;
        return Stack(
          alignment: AlignmentDirectional.centerStart,
          children: [
            Positioned.fill(
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: ExcludeSemantics(
                  child: StyledText(widget.hintText!, styleSpec: spec.hintText),
                ),
              ),
            ),
            styled,
          ],
        );
      },
    );
  }

  Widget _buildResolved(
    BuildContext context,
    TagInputSpec spec,
    NakedTagInputBindings field,
  ) {
    final occurrences = <String, int>{};
    final tags = [
      for (final tag in field.tags)
        _RemixTagInputTag(
          key: ValueKey((
            tag.value,
            occurrences.update(tag.value, (n) => n + 1, ifAbsent: () => 0),
          )),
          item: tag,
          enabled: widget.enabled,
          style: spec.tag,
          removeLabel: widget.removeLabelBuilder(tag.value),
        ),
    ];

    Widget shell = RemixBoxAdapter(
      styleSpec: spec.container,
      containerEffects: spec.containerEffects,
      child: _TagInputFlow(
        spacing: spec.spacing ?? 0,
        runSpacing: spec.runSpacing ?? 0,
        editorMinWidth: spec.editorMinWidth ?? 80,
        children: [
          ...tags,
          DefaultSelectionStyle.merge(
            selectionColor: spec.text.spec.selectionColor,
            child: _editor(spec, field),
          ),
        ],
      ),
    );

    // Taps on tags and the shell's padding stay inside the editor's tap
    // region, so they do not count as taps outside the field.
    shell = TextFieldTapRegion(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: widget.enabled ? field.focusNode.requestFocus : null,
        child: shell,
      ),
    );

    if (widget.enabled) {
      shell = MouseRegion(
        onEnter: (_) => _styleController.update(.hovered, true),
        onExit: (_) => _styleController.update(.hovered, false),
        cursor: SystemMouseCursors.text,
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
    return NakedTagInput(
      value: widget.value,
      onChanged: widget.onChanged,
      onDuplicate: widget.onDuplicate,
      controller: widget.controller,
      focusNode: widget.focusNode,
      separators: widget.separators,
      duplicates: widget.duplicates,
      maxTags: widget.maxTags,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      messages: widget.messages,
      builder: (context, field) => RemixStyleSpecBuilder<TagInputSpec>(
        style: _baseStyle.merge(widget.style),
        styleSpec: widget.styleSpec,
        controller: _styleController,
        builder: (context, spec) => _buildResolved(context, spec, field),
      ),
    );
  }
}

class _RemixTagInputTag extends StatefulWidget {
  const _RemixTagInputTag({
    super.key,
    required this.item,
    required this.enabled,
    required this.style,
    required this.removeLabel,
  });

  final NakedTagInputItem item;
  final bool enabled;
  final Style<TagInputTagSpec>? style;
  final String removeLabel;

  @override
  State<_RemixTagInputTag> createState() => _RemixTagInputTagState();
}

class _RemixTagInputTagState extends State<_RemixTagInputTag> {
  late final WidgetStatesController _states = WidgetStatesController({
    if (widget.item.isPicked) .selected,
    if (!widget.enabled) .disabled,
  });

  @override
  void didUpdateWidget(_RemixTagInputTag oldWidget) {
    super.didUpdateWidget(oldWidget);
    _states
      ..update(.selected, widget.item.isPicked)
      ..update(.disabled, !widget.enabled);
  }

  @override
  void dispose() {
    _states.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return NakedTagInputTag(
      item: item,
      child: StyleBuilder<TagInputTagSpec>(
        style: switch (widget.style) {
          final TagInputTagStyler style => _baseTagStyle.merge(style),
          final Style<TagInputTagSpec> style => style,
          null => _baseTagStyle,
        },
        controller: _states,
        builder: (context, spec) {
          final remove = item.remove;
          final removeButton = spec.removeButton;
          Widget button = RemixIconButton(
            icon: null,
            iconBuilder: (context, iconSpec, _) => RemixPathIcon(
              glyph: RemixPathGlyph.cross,
              styleSpec: StyleSpec(spec: iconSpec),
            ),
            semanticLabel: widget.removeLabel,
            excludeSemantics: true,
            onPressed: remove,
          );
          if (removeButton != null) {
            button = StyleProvider<IconButtonSpec>(
              style: removeButton,
              child: button,
            );
          }
          return RemixFlexBoxAdapter(
            styleSpec: spec.container,
            direction: Axis.horizontal,
            children: [
              Flexible(child: StyledText(item.value, styleSpec: spec.label)),
              // The editor keeps focus; the tag's remove action is offered
              // to the keyboard as Backspace and to screen readers on the
              // tag node.
              if (remove != null) ExcludeFocus(child: button),
            ],
          );
        },
      ),
    );
  }
}

final TagInputStyler _baseStyle = TagInputStyler(
  layout: FlexBoxStyler()
      .direction(.vertical)
      .mainAxisSize(.min)
      .crossAxisAlignment(.start)
      .spacing(8),
);

final TagInputTagStyler _baseTagStyle = TagInputTagStyler(
  container: FlexBoxStyler().mainAxisSize(.min).crossAxisAlignment(.center),
);
