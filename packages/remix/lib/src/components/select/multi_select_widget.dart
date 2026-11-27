part of 'select.dart';

/// A select that holds several values and shows them as chips in its trigger.
///
/// The trigger opens a popup list in which each option toggles independently.
/// The popup stays open while the user toggles options and closes on Escape,
/// on a tap outside it, or on a second press of the trigger. Closing returns
/// focus to the trigger.
///
/// The caller owns the selection: [onChanged] proposes the next set and the
/// widget shows [selectedValues] until the caller rebuilds it. Chips follow
/// the iteration order of [selectedValues]; the proposed set keeps that order
/// and appends a newly picked value.
///
/// It shares [SelectStyler] with [RemixSelect]. The trigger's chip, chipLabel
/// and overflowLabel style the chips, and the trigger resolves under
/// [WidgetState.selected] while the popup is open.
///
/// ## Keyboard
///
/// - **Space or Enter on the trigger**: opens or closes the popup.
/// - **Arrow Up, Arrow Down, Home, End**: move focus between enabled options
///   without changing the selection.
/// - **Space or Enter on an option**: toggles it.
/// - **Escape**: closes the popup.
///
/// ## Example
///
/// ```dart
/// RemixMultiSelect<String>(
///   trigger: const RemixSelectTrigger(placeholder: 'Select fruits'),
///   items: const [
///     RemixSelectItem(value: 'apple', label: 'Apple'),
///     RemixSelectItem(value: 'banana', label: 'Banana'),
///     RemixSelectItem(value: 'cherry', label: 'Cherry', enabled: false),
///   ],
///   selectedValues: fruits,
///   onChanged: (next) => setState(() => fruits = next),
/// )
/// ```
class RemixMultiSelect<T extends Object> extends StatefulWidget {
  const RemixMultiSelect({
    super.key,
    required this.trigger,
    required this.items,
    required this.selectedValues,
    this.onChanged,
    this.maxVisibleChips = 2,
    this.positioning = const OverlayPositionConfig(
      side: .bottom,
      alignment: .center,
    ),
    this.onOpen,
    this.onClose,
    this.enabled = true,
    this.mouseCursor = SystemMouseCursors.click,
    this.semanticLabel,
    this.focusNode,
    this.style = const SelectStyler.create(),
    this.styleSpec,
  }) : assert(maxVisibleChips >= 0);

  /// The trigger's placeholder and icons.
  final RemixSelectTrigger trigger;

  /// The options, in display and keyboard order.
  final List<RemixSelectItem<T>> items;

  /// The selected values. Each must be the value of one of [items].
  final Set<T> selectedValues;

  /// Proposes the next selection when the user toggles an option.
  ///
  /// When null, the select is disabled.
  final ValueChanged<Set<T>>? onChanged;

  /// How many chips the trigger shows before it folds the rest into a "+N"
  /// count.
  final int maxVisibleChips;

  /// Overlay positioning configuration for the popup.
  final OverlayPositionConfig positioning;

  /// Called when the popup opens.
  final VoidCallback? onOpen;

  /// Called when the popup closes.
  final VoidCallback? onClose;

  /// Whether the select is enabled and can be interacted with.
  final bool enabled;

  /// The mouse cursor for the trigger.
  final MouseCursor mouseCursor;

  /// The accessible name of the trigger and of the popup list.
  ///
  /// Defaults to the trigger's placeholder.
  final String? semanticLabel;

  /// Optional focus node for the trigger.
  final FocusNode? focusNode;

  /// The style configuration for the select.
  final SelectStyler style;

  /// Optional raw style spec that bypasses fluent style resolution.
  final SelectSpec? styleSpec;

  static final styleFrom = SelectStyler.new;

  @override
  State<RemixMultiSelect<T>> createState() => _RemixMultiSelectState<T>();
}

class _RemixMultiSelectState<T extends Object>
    extends State<RemixMultiSelect<T>>
    with SingleTickerProviderStateMixin {
  late final _panelTransition = RemixPanelTransitionHandle(vsync: this);
  final _controller = MenuController();
  final _internalFocusNode = FocusNode(debugLabel: 'RemixMultiSelect trigger');

  // Never attached. The overlay then focuses its first traversable node, the
  // list's entry option: the first selected option, else the first enabled.
  final _listEntryFocusNode = FocusNode(
    debugLabel: 'RemixMultiSelect list entry',
  );

  FocusNode get _triggerFocusNode => widget.focusNode ?? _internalFocusNode;
  bool get _interactive => widget.enabled && widget.onChanged != null;
  bool get _isOpen => _controller.isOpen && !_panelTransition.isExiting;

  @override
  void didUpdateWidget(covariant RemixMultiSelect<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_interactive && _controller.isOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_interactive && _controller.isOpen) {
          _controller.close();
        }
      });
    }
  }

  @override
  void dispose() {
    _panelTransition.dispose();
    _internalFocusNode.dispose();
    _listEntryFocusNode.dispose();
    super.dispose();
  }

  void _toggle() {
    if (!_interactive) return;
    if (_isOpen) {
      _controller.close();
    } else {
      _triggerFocusNode.requestFocus();
      _controller.open();
    }
  }

  void _handleOpen() {
    setState(() {});
    widget.onOpen?.call();
  }

  void _handleClose() {
    if (mounted) setState(() {});
    widget.onClose?.call();
  }

  SelectStyler _buildStyle() {
    return SelectStyler()
        .trigger(
          SelectTriggerStyler().mainAxisSize(.min).wrap(.intrinsicWidth()),
        )
        .menuContainer(
          FlexBoxStyler().mainAxisSize(.min).wrap(.intrinsicWidth()),
        )
        .merge(widget.style);
  }

  String get _semanticLabel =>
      widget.semanticLabel ?? widget.trigger.placeholder;

  /// Returns true so the whole check, loop included, is stripped in release.
  bool _debugValidate(List<RemixSelectItem<T>> selected) {
    assert(
      widget.trigger.placeholder.trim().isNotEmpty,
      'RemixMultiSelect trigger placeholder must be a nonblank string.',
    );
    final seen = <T>{};
    for (final item in widget.items) {
      assert(
        item.label.trim().isNotEmpty,
        'RemixMultiSelect item labels must be nonblank. Value: ${item.value}',
      );
      assert(
        seen.add(item.value),
        'RemixMultiSelect item values must be unique. Duplicate: ${item.value}',
      );
    }
    assert(
      selected.length == widget.selectedValues.length,
      'RemixMultiSelect selectedValues must all be present in items. '
      'Missing: ${widget.selectedValues.difference(seen)}',
    );

    return true;
  }

  Widget _buildPanel(SelectSpec spec, SelectStyler style, Rect anchorRect) {
    return RemixPanelTransitionHost(
      handle: _panelTransition,
      transition: spec.panelTransition ?? _defaultPanelTransition,
      anchorRect: anchorRect,
      child: StyleSpecBuilder<SelectContentSpec>(
        styleSpec: spec.content,
        builder: (context, content) => RemixBoxAdapter(
          styleSpec: content.container,
          containerEffects: content.containerEffects,
          child: RemixFlexBoxAdapter(
            styleSpec: spec.menuContainer,
            direction: Axis.vertical,
            scrollable: true,
            children: [
              NakedListbox<T>.multiple(
                options: [
                  for (final item in widget.items)
                    NakedListboxOption<T>(
                      value: item.value,
                      semanticLabel: item.semanticLabel ?? item.label,
                      enabled: item.enabled,
                      builder: (context, state, _) => _RemixMultiSelectOption(
                        data: item,
                        state: state,
                        itemStyle: SelectStyler.create(
                          item: MixOps.merge(
                            style.$item,
                            Prop.maybeMix<StyleSpec<SelectMenuItemSpec>>(
                              item.style,
                            ),
                          ),
                        ),
                        selectStyleSpec: widget.styleSpec,
                      ),
                    ),
                ],
                semanticLabel: _semanticLabel,
                selectedValues: widget.selectedValues,
                onChanged: _interactive ? widget.onChanged : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = _buildStyle();
    final selected = <RemixSelectItem<T>>[
      for (final value in widget.selectedValues)
        ...widget.items.where((item) => item.value == value),
    ];
    assert(_debugValidate(selected));
    final isOpen = _isOpen;
    final semanticValue = selected
        .map((item) => item.semanticLabel ?? item.label)
        .join(', ');

    final popover = NakedPopover(
      controller: _controller,
      openOnTap: false,
      triggerFocusNode: _triggerFocusNode,
      initialFocusNode: _listEntryFocusNode,
      positioning: widget.positioning,
      constrainToAvailableSpace: true,
      onOpen: _handleOpen,
      onClose: _handleClose,
      onOpenRequested: (position, showOverlay) =>
          _panelTransition.openRequested(position, showOverlay, null),
      onCloseRequested: (hideOverlay) =>
          _panelTransition.closeRequested(hideOverlay, null),
      popoverBuilder: (context, info) => RemixAnchorScope(
        width: info.anchorRect.width,
        child: RemixStyleSpecBuilder<SelectSpec>(
          style: style,
          styleSpec: widget.styleSpec,
          builder: (context, spec) => _buildPanel(spec, style, info.anchorRect),
        ),
      ),
      child: NakedButton(
        onPressed: _interactive ? _toggle : null,
        enabled: _interactive,
        mouseCursor: widget.mouseCursor,
        focusNode: _triggerFocusNode,
        semanticLabel: _semanticLabel,
        builder: (context, buttonState, _) => WidgetStateProvider(
          states: {...buttonState.states, if (isOpen) WidgetState.selected},
          child: RemixStyleSpecBuilder<SelectSpec>(
            style: style,
            styleSpec: widget.styleSpec,
            trackFocusVisibility: true,
            builder: (context, spec) => _RemixMultiSelectTrigger(
              trigger: widget.trigger,
              labels: [for (final item in selected) item.label],
              maxVisibleChips: widget.maxVisibleChips,
              isOpen: isOpen,
              styleSpec: spec.trigger,
            ),
          ),
        ),
      ),
    );

    // The trigger is one merged node: button, name, expanded, and the whole
    // selection as its value. As in NakedSelect, no container here, so the
    // popup's semantics keep the trigger's parent as their traversal parent.
    return MergeSemantics(
      child: Semantics(
        expanded: isOpen,
        value: semanticValue.isEmpty ? null : semanticValue,
        child: popover,
      ),
    );
  }
}

class _RemixMultiSelectTrigger extends StatelessWidget {
  const _RemixMultiSelectTrigger({
    required this.trigger,
    required this.labels,
    required this.maxVisibleChips,
    required this.isOpen,
    required this.styleSpec,
  });

  final RemixSelectTrigger trigger;
  final List<String> labels;
  final int maxVisibleChips;
  final bool isOpen;
  final StyleSpec<SelectTriggerSpec> styleSpec;

  @override
  Widget build(BuildContext context) {
    return StyleSpecBuilder<SelectTriggerSpec>(
      styleSpec: styleSpec,
      builder: (context, spec) {
        final indicatorIcon = isOpen
            ? trigger.expandedIcon
            : trigger.collapsedIcon;
        final visible = labels.take(maxVisibleChips);
        final hidden = labels.length - visible.length;

        return RemixFlexBoxAdapter(
          styleSpec: spec.container,
          direction: Axis.horizontal,
          containerEffects: spec.containerEffects,
          children: [
            if (trigger.icon != null)
              StyledIcon(icon: trigger.icon!, styleSpec: spec.icon),
            Expanded(
              child: ExcludeSemantics(
                child: labels.isEmpty
                    ? Opacity(
                        opacity: spec.placeholderOpacity ?? 1,
                        child: StyledText(
                          trigger.placeholder,
                          styleSpec: spec.placeholder,
                        ),
                      )
                    // The chips keep their natural width and the row clips
                    // where the trigger ends, rather than squeezing them.
                    : UnconstrainedBox(
                        alignment: AlignmentDirectional.centerStart,
                        constrainedAxis: Axis.vertical,
                        clipBehavior: Clip.hardEdge,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (final label in visible)
                              Box(
                                styleSpec: spec.chip,
                                child: StyledText(
                                  label,
                                  styleSpec: spec.chipLabel,
                                ),
                              ),
                            if (hidden > 0)
                              Box(
                                key: const ValueKey(
                                  'remix-multi-select-overflow',
                                ),
                                styleSpec: spec.chip,
                                child: StyledText(
                                  '+$hidden',
                                  styleSpec: spec.overflowLabel,
                                ),
                              ),
                          ],
                        ),
                      ),
              ),
            ),
            Opacity(
              opacity: spec.indicatorOpacity ?? 1,
              child: indicatorIcon == null
                  ? Transform.rotate(
                      angle: isOpen ? math.pi : 0,
                      child: RemixPathIcon(
                        key: const ValueKey('remix-select-indicator'),
                        glyph: RemixPathGlyph.chevronDown,
                        styleSpec: spec.indicator,
                      ),
                    )
                  : StyledIcon(
                      key: const ValueKey('remix-select-indicator'),
                      icon: indicatorIcon,
                      styleSpec: spec.indicator,
                    ),
            ),
          ],
        );
      },
    );
  }
}

/// One option row. The list owns focus, keys, taps and semantics; the row adds
/// only the pointer hover that the list does not track, for its look.
class _RemixMultiSelectOption<T extends Object> extends StatefulWidget {
  const _RemixMultiSelectOption({
    required this.data,
    required this.state,
    required this.itemStyle,
    this.selectStyleSpec,
  });

  final RemixSelectItem<T> data;
  final NakedListboxOptionState<T> state;

  /// A [SelectStyler] carrying only this row's merged item branch.
  final SelectStyler itemStyle;
  final SelectSpec? selectStyleSpec;

  @override
  State<_RemixMultiSelectOption<T>> createState() =>
      _RemixMultiSelectOptionState<T>();
}

class _RemixMultiSelectOptionState<T extends Object>
    extends State<_RemixMultiSelectOption<T>> {
  bool _hovered = false;

  void _setHovered(bool hovered) {
    if (_hovered != hovered) setState(() => _hovered = hovered);
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    return MouseRegion(
      cursor: state.isDisabled
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: WidgetStateProvider(
        states: {
          if (state.isSelected) WidgetState.selected,
          if (state.isFocused) WidgetState.focused,
          if (_hovered && !state.isDisabled) WidgetState.hovered,
          if (state.isDisabled) WidgetState.disabled,
        },
        child: RemixStyleSpecBuilder<SelectSpec>(
          style: widget.itemStyle,
          styleSpec: widget.selectStyleSpec,
          trackFocusVisibility: true,
          builder: (context, spec) => StyleSpecBuilder<SelectMenuItemSpec>(
            styleSpec: spec.item,
            builder: (context, item) => RemixFlexBoxAdapter(
              styleSpec: item.container,
              direction: Axis.horizontal,
              containerEffects: item.containerEffects,
              children: [
                Expanded(
                  child: StyledText(widget.data.label, styleSpec: item.text),
                ),
                if (state.isSelected)
                  Box(
                    styleSpec: item.indicator,
                    child: RemixPathIcon(
                      key: const ValueKey('remix-multi-select-check'),
                      glyph: RemixPathGlyph.thickCheck,
                      styleSpec: item.icon,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
