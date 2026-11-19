part of 'combobox.dart';

/// Editable text with eligible suggestions. Arbitrary text remains valid.
///
/// RawAutocomplete owns editing, overlay geometry, keyboard navigation and
/// acceptance. Applications own filtering, asynchronous errors and debounce.
/// Supply small result sets: all rows are built eagerly so keyboard navigation
/// can reveal any suggestion. No results closes the panel.
class RemixCombobox<T extends Object> extends StatefulWidget {
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
    this.isOptionDisabled,
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

  /// Returns suggestions for the editing value. Filter out unavailable
  /// results, or keep them visible with [isOptionDisabled].
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

  /// Marks suggestions that stay visible but cannot be highlighted or
  /// accepted. Keyboard navigation skips them; Enter and pointer activation
  /// never accept them. Their rows resolve the option style with
  /// `WidgetState.disabled`, so style them with `onDisabled`. Results with
  /// no enabled suggestion close the panel, as no results do.
  ///
  /// Called once per suggestion when results arrive.
  final bool Function(T option)? isOptionDisabled;

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
  State<RemixCombobox<T>> createState() => _RemixComboboxState<T>();
}

class _RemixComboboxState<T extends Object> extends State<RemixCombobox<T>>
    with SingleTickerProviderStateMixin {
  late final _panelTransition = RemixPanelTransitionHandle(
    vsync: this,
    // The panel is where the transition is resolved: nothing requests the
    // open, so the panel's host starts the animation.
    resolve: () => null,
    reduceMotion: () => remixReducedMotionOf(context),
  );
  final _fieldKey = GlobalKey();

  /// The transition the live panel resolved last, kept for the exit layer,
  /// which is built outside the panel's scope.
  RemixPanelTransition? _lastTransition;
  Rect _lastAnchor = Rect.zero;

  @override
  void dispose() {
    _panelTransition.dispose();
    super.dispose();
  }

  /// The editor's bounds in the overlay the panel is shown in.
  Rect _anchorRect(BuildContext context) {
    final field = _fieldKey.currentContext?.findRenderObject();
    final overlay = Overlay.maybeOf(context)?.context.findRenderObject();
    if (field is! RenderBox ||
        overlay is! RenderBox ||
        !field.attached ||
        !field.hasSize) {
      return _lastAnchor;
    }
    return _lastAnchor =
        overlay.globalToLocal(field.localToGlobal(Offset.zero)) & field.size;
  }

  @override
  Widget build(BuildContext context) {
    final RemixCombobox<T>(
      :optionsBuilder,
      :onSelected,
      :displayStringForOption,
      :controller,
      :focusNode,
      :initialValue,
      :label,
      :hintText,
      :enabled,
      :autofocus,
      :semanticLabel,
      :fieldBuilder,
      :optionBuilder,
      :optionsViewOpenDirection,
      :isOptionDisabled,
      :onOpen,
      :onClose,
      :excludeSemantics,
      :style,
      :styleSpec,
    ) = widget;
    final base = ComboboxStyler()
        .field(TextFieldStyler().constraints(.minHeight(48)))
        .option(ComboboxOptionStyler().minHeight(48))
        .panel(ComboboxPanelStyler().maxHeight(288))
        .merge(style);
    final inherited = Style.maybeOf<ComboboxSpec>(context);
    final effective = (inherited is ComboboxStyler
        ? inherited.merge(base)
        : base);
    return NakedCombobox<T>(
      exitBuilder: (context, view, dismiss) => _ComboboxExit(
        handle: _panelTransition,
        transition: _lastTransition,
        anchorRect: _lastAnchor,
        dismiss: dismiss,
        child: view,
      ),
      optionsBuilder: optionsBuilder,
      onSelected: onSelected,
      displayStringForOption: displayStringForOption,
      controller: controller,
      focusNode: focusNode,
      initialValue: initialValue,
      enabled: enabled,
      optionsViewOpenDirection: optionsViewOpenDirection,
      isOptionDisabled: isOptionDisabled,
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
          builder: (context, spec) => KeyedSubtree(
            key: _fieldKey,
            child: RemixBoxAdapter(
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
          ),
        );
      },
      overlayBuilder: (context, options) {
        final panel =
            styleSpec?.panel ??
            _ComboboxProjection(effective, .panel).build(context).spec.panel;
        return StyleSpecBuilder<ComboboxPanelSpec>(
          styleSpec: panel,
          builder: (context, spec) => _panelHost(
            context,
            spec,
            StyleSpecBuilder<BoxSpec>(
              styleSpec: spec.container,
              builder: (context, box) => _ComboboxOptionsViewport(
                panel: spec,
                box: box,
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
                                        child: Align(
                                          alignment:
                                              AlignmentDirectional.centerStart,
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

  /// Runs the panel through its transition, and keeps what the exit layer
  /// needs once the panel has gone.
  Widget _panelHost(
    BuildContext context,
    ComboboxPanelSpec spec,
    Widget panel,
  ) {
    _lastTransition = spec.panelTransition;
    // In the exit layer the exit host already runs the transition around this
    // panel; a second host would run it twice.
    if (_ComboboxExitScope.maybeOf(context) != null) return panel;
    return RemixPanelTransitionHost(
      handle: _panelTransition,
      transition: spec.panelTransition,
      anchorRect: _anchorRect(context),
      child: panel,
    );
  }
}

/// The panel's exit: the last panel, held by the combobox, plays the
/// transition backwards and then lets go.
class _ComboboxExit extends StatefulWidget {
  const _ComboboxExit({
    required this.handle,
    required this.transition,
    required this.anchorRect,
    required this.dismiss,
    required this.child,
  });

  final RemixPanelTransitionHandle handle;
  final RemixPanelTransition? transition;
  final Rect anchorRect;
  final VoidCallback dismiss;
  final Widget child;

  @override
  State<_ComboboxExit> createState() => _ComboboxExitState();
}

class _ComboboxExitState extends State<_ComboboxExit> {
  @override
  void initState() {
    super.initState();
    // The exit starts in the build that shows this layer, the frame the panel
    // is dropped, so its clock runs from that frame like the other panels'.
    // An exit that has nothing to play hides the layer, which cannot happen
    // during build, so that waits for the frame to end.
    var building = true;
    widget.handle.closeRequested(() {
      if (building) {
        _dismissAfterFrame();
      } else {
        widget.dismiss();
      }
    }, null);
    building = false;
  }

  void _dismissAfterFrame() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.dismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.transition == null) {
      // No transition: nothing to play, so the layer goes at once.
      _dismissAfterFrame();
      return const SizedBox.shrink();
    }
    return RemixPanelTransitionHost(
      handle: widget.handle,
      transition: widget.transition,
      anchorRect: widget.anchorRect,
      exiting: true,
      child: _ComboboxExitScope(child: widget.child),
    );
  }
}

/// Marks the panel rebuilt inside the exit layer, which the exit host
/// animates, so it does not start a transition of its own.
class _ComboboxExitScope extends InheritedWidget {
  const _ComboboxExitScope({required super.child});

  static _ComboboxExitScope? maybeOf(BuildContext context) =>
      context.getInheritedWidgetOfExactType<_ComboboxExitScope>();

  @override
  bool updateShouldNotify(_ComboboxExitScope oldWidget) => false;
}

/// Own the controller for the entire mounted panel, including keyboard reveal.
/// Contain notifications and clamp like Select/Menu's overlay scroll adapter.
class _ComboboxOptionsViewport extends StatefulWidget {
  const _ComboboxOptionsViewport({
    required this.child,
    required this.panel,
    required this.box,
  });

  final Widget child;
  final ComboboxPanelSpec panel;
  final BoxSpec box;

  @override
  State<_ComboboxOptionsViewport> createState() =>
      _ComboboxOptionsViewportState();
}

class _ComboboxOptionsViewportState extends State<_ComboboxOptionsViewport> {
  final _controller = ScrollController();
  bool _fadeTop = false;
  bool _fadeBottom = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final direction = Directionality.of(context);
    final thickness = widget.panel.scrollbarThickness ?? 4;
    final box = widget.box;
    final padding = (box.padding ?? EdgeInsets.zero).resolve(direction);
    final margin = (box.margin ?? EdgeInsets.zero).resolve(direction);
    final border = box.decoration is BoxDecoration
        ? ((box.decoration as BoxDecoration).border?.dimensions ??
                  EdgeInsets.zero)
              .resolve(direction)
        : EdgeInsets.zero;
    // Reuse the panel's padding for the thumb. Unpadded custom panels get the
    // same minimum space on both sides, independent of their scroll range.
    final extra =
        (thickness -
                (padding.left < padding.right ? padding.left : padding.right))
            .clamp(0.0, thickness);
    return NotificationListener<ViewportNotificationMixin>(
      onNotification: (notification) {
        final metrics = switch (notification) {
          ScrollNotification(:final metrics) => metrics,
          ScrollMetricsNotification(:final metrics) => metrics,
          _ => null,
        };
        if (metrics != null) {
          final top = metrics.extentBefore > 0;
          final bottom = metrics.extentAfter > 0;
          if (top != _fadeTop || bottom != _fadeBottom) {
            setState(() {
              _fadeTop = top;
              _fadeBottom = bottom;
            });
          }
        }
        return true;
      },
      child: RawScrollbar(
        controller: _controller,
        thumbVisibility: true,
        thumbColor:
            widget.panel.scrollbarColor ??
            DefaultTextStyle.of(context).style.color?.withValues(alpha: 0.35),
        thickness: thickness,
        padding: margin + border,
        radius: const Radius.circular(2),
        child: RemixBoxAdapter(
          styleSpec: StyleSpec(spec: box),
          containerEffects: widget.panel.containerEffects,
          child: ScrollConfiguration(
            // Own exactly one thumb even when the host adds desktop scrollbars.
            behavior: ScrollConfiguration.of(context).copyWith(
              scrollbars: false,
              overscroll: false,
              physics: const ClampingScrollPhysics(),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: extra),
              child: ShaderMask(
                blendMode: BlendMode.dstIn,
                shaderCallback: (bounds) {
                  // Wrapped rows cannot snap to a fixed row height. Fade just
                  // the edges with more content beyond them, leaving the panel
                  // chrome and thumb untouched. Clamp for very short panels.
                  final edge = bounds.height > 0
                      ? (12 / bounds.height).clamp(0.0, 0.5)
                      : 0.0;
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(_fadeTop ? 0x00FFFFFF : 0xFFFFFFFF),
                      const Color(0xFFFFFFFF),
                      const Color(0xFFFFFFFF),
                      Color(_fadeBottom ? 0x00FFFFFF : 0xFFFFFFFF),
                    ],
                    stops: [0, edge, 1 - edge, 1],
                  ).createShader(bounds);
                },
                child: SingleChildScrollView(
                  controller: _controller,
                  primary: false,
                  child: widget.child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
