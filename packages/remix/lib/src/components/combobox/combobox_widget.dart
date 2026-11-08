part of 'combobox.dart';

/// Editable text with eligible suggestions. Arbitrary text remains valid.
///
/// RawAutocomplete owns editing, overlay geometry, keyboard navigation and
/// acceptance. Applications own filtering, asynchronous errors and debounce.
/// Supply small result sets: all rows are built eagerly so keyboard navigation
/// can reveal any suggestion. No results closes the panel.
class RemixCombobox<T extends Object> extends StatelessWidget {
  /// Creates an editable field with eligible suggestions.
  const RemixCombobox({
    super.key,
    required this.optionsBuilder,
    this.onSelected,
    this.displayStringForOption = RawAutocomplete.defaultStringForOption,
    this.controller,
    this.focusNode,
    this.initialValue,
    this.label,
    this.hintText,
    this.enabled = true,
    this.autofocus = false,
    this.semanticLabel,
    this.fieldBuilder,
    this.optionBuilder,
    this.optionsViewOpenDirection = OptionsViewOpenDirection.down,
    this.onOpen,
    this.onClose,
    this.excludeSemantics = false,
    this.style = const ComboboxStyler.create(),
    this.styleSpec,
  }) : assert(
         (controller == null) == (focusNode == null),
         'controller and focusNode must both be supplied or both be null.',
       ),
       assert(controller == null || initialValue == null);

  /// Returns eligible suggestions only; unavailable results must be filtered.
  final AutocompleteOptionsBuilder<T> optionsBuilder;

  /// Selection notification after the display string is written to the editor.
  /// Synchronous controller changes here are preserved. Editing does not emit
  /// a nullable selection notification.
  final ValueChanged<T>? onSelected;

  /// Text written into the editor and used to name each suggestion.
  final AutocompleteOptionToString<T> displayStringForOption;

  /// Caller-owned editor controller; must be paired with [focusNode].
  final TextEditingController? controller;

  /// Caller-owned editor focus node; must be paired with [controller].
  final FocusNode? focusNode;

  /// Initializes text, without selecting an entity.
  final TextEditingValue? initialValue;

  /// Visible label and fallback accessible name of the default editor.
  final String? label;

  /// Placeholder shown while the default editor is empty.
  final String? hintText;

  /// Whether editing and suggestion acceptance are enabled.
  final bool enabled;

  /// Whether the enabled default editor requests focus when mounted.
  /// Custom [fieldBuilder] implementations own their autofocus behavior.
  final bool autofocus;

  /// Accessible name, replacing [label] for the default editor.
  /// Custom editors must apply this name to their editable semantics node.
  final String? semanticLabel;

  /// Replaces the default editor. Own its label, disabled state and appearance;
  /// forward the supplied controller, focus node and submit callback unchanged.
  final NakedComboboxFieldBuilder<T>? fieldBuilder;

  /// Visual content only, beneath one named interactive option wrapper. Do not
  /// return another button. Its accessible name is [displayStringForOption].
  final Widget Function(BuildContext context, T option)? optionBuilder;

  /// Preferred direction for opening the suggestions panel.
  final OptionsViewOpenDirection optionsViewOpenDirection;

  /// Called after the suggestions subtree mounts.
  final VoidCallback? onOpen;

  /// Called after the suggestions subtree unmounts.
  final VoidCallback? onClose;

  /// Hides both the editor and suggestions from assistive technology.
  final bool excludeSemantics;

  /// Fluent styling for the editor root, field, panel and suggestions.
  final ComboboxStyler style;

  /// Bypasses fluent defaults and resolution, including nested slots.
  final ComboboxSpec? styleSpec;

  /// Creates fluent styles for a combobox and its anatomy.
  static final styleFrom = ComboboxStyler.new;

  @override
  Widget build(BuildContext context) {
    final fieldBuilder = this.fieldBuilder;
    final optionBuilder = this.optionBuilder;
    final base = ComboboxStyler()
        .field(TextFieldStyler().constraints(.minHeight(48)))
        .merge(style);
    final inherited = Style.maybeOf<ComboboxSpec>(context);
    final effective = (inherited is ComboboxStyler
        ? inherited.merge(base)
        : base);
    return NakedCombobox<T>(
      optionsBuilder: optionsBuilder,
      onSelected: onSelected,
      displayStringForOption: displayStringForOption,
      controller: controller,
      focusNode: focusNode,
      initialValue: initialValue,
      enabled: enabled,
      optionsViewOpenDirection: optionsViewOpenDirection,
      onOpen: onOpen,
      onClose: onClose,
      excludeSemantics: excludeSemantics,
      // The default editor names its editable node directly, avoiding a second
      // named container. Custom editors receive Naked's container name too.
      semanticLabel: fieldBuilder == null ? null : semanticLabel,
      fieldBuilder: (context, state, controller, focusNode, submit) {
        Widget defaultField(TextFieldSpec? rawSpec) => RemixTextField(
          controller: controller,
          focusNode: focusNode,
          label: label,
          hintText: hintText,
          enabled: enabled,
          autofocus: autofocus,
          semanticLabel: semanticLabel,
          // Finalize IME text while retaining editor focus. Naked suppresses
          // acceptance for this composing submit.
          onEditingComplete: controller.clearComposing,
          onSubmitted: (_) => submit(),
          styleSpec: rawSpec,
        );

        return RemixStyleSpecBuilder<ComboboxSpec>(
          style: base,
          styleSpec: styleSpec,
          controller: NakedComboboxState.controllerOf<T>(context),
          builder: (context, spec) => RemixBoxAdapter(
            styleSpec: spec.container,
            child: fieldBuilder != null
                ? fieldBuilder(context, state, controller, focusNode, submit)
                : styleSpec != null
                ? StyleSpecBuilder<TextFieldSpec>(
                    styleSpec: spec.field,
                    builder: (context, fieldSpec) => defaultField(fieldSpec),
                  )
                : StyleProvider<TextFieldSpec>(
                    style: _ComboboxFieldStyle(
                      effective,
                      Style.maybeOf<TextFieldSpec>(context),
                    ),
                    child: defaultField(null),
                  ),
          ),
        );
      },
      overlayBuilder: (context, options) {
        final panel =
            styleSpec?.panel ??
            _ComboboxProjection(effective, .panel).build(context).spec.panel;
        return RemixBoxAdapter(
          styleSpec: panel,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 288),
            // The portal keeps the host's widget ancestry. Contain viewport
            // notifications as well as primary-controller ownership so popup
            // scrolling cannot drive the host's refresh indicator or scrollbar.
            child: NotificationListener<ViewportNotificationMixin>(
              onNotification: (_) => true,
              child: SingleChildScrollView(
                primary: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final (index, option) in options.indexed)
                      NakedComboboxOption<T>(
                        // Replacing or moving a pressed option cancels its
                        // press rather than accepting a different result.
                        key: ValueKey((index, option)),
                        value: option,
                        semanticLabel: displayStringForOption(option),
                        builder: (context, state, _) => FocusVisibilityScope(
                          child: WidgetStateProvider(
                            states: state.states,
                            child: Builder(
                              builder: (context) {
                                final spec =
                                    styleSpec ??
                                    _ComboboxProjection(
                                      effective,
                                      .option,
                                    ).build(context).spec;
                                return StyleSpecBuilder<ComboboxOptionSpec>(
                                  styleSpec: spec.option,
                                  builder: (context, optionSpec) =>
                                      RemixBoxAdapter(
                                        styleSpec: optionSpec.container,
                                        child: ConstrainedBox(
                                          constraints: const BoxConstraints(
                                            minHeight: 48,
                                          ),
                                          child: Align(
                                            alignment: AlignmentDirectional
                                                .centerStart,
                                            heightFactor: 1,
                                            child: optionBuilder == null
                                                ? StyledText(
                                                    displayStringForOption(
                                                      option,
                                                    ),
                                                    styleSpec: optionSpec.label,
                                                  )
                                                : RemixDefaultContentStyle(
                                                    text: optionSpec.label,
                                                    child: optionBuilder(
                                                      context,
                                                      option,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                );
                              },
                            ),
                          ),
                        ),
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
}
