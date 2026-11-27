part of 'select.dart';

/// Data class representing a select trigger.
///
/// Used with [RemixSelect] to define the trigger button that opens the dropdown.
/// Displays placeholder text when no value is selected, or the selected value's label.
class RemixSelectTrigger {
  /// Placeholder text to display when no value is selected.
  final String placeholder;

  /// Optional content icon to display before the label/placeholder.
  final IconData? icon;

  /// Optional indicator icon to display while the select is collapsed.
  ///
  /// When null, the default downward chevron is displayed.
  final IconData? collapsedIcon;

  /// Optional indicator icon to display while the select is expanded.
  ///
  /// When null, the default upward chevron is displayed.
  final IconData? expandedIcon;

  const RemixSelectTrigger({
    required this.placeholder,
    this.icon,
    this.collapsedIcon,
    this.expandedIcon,
  });
}

/// Data class representing a selectable option.
///
/// Used with [RemixSelect]'s items list to define selectable options.
class RemixSelectItem<T> {
  /// The value associated with this option.
  /// Passed to onChanged callback when selected.
  final T value;

  /// The text label to display.
  final String label;

  /// Whether this option can be selected.
  final bool enabled;

  /// The style for the item.
  final SelectMenuItemStyler style;

  /// Semantic label for accessibility.
  final String? semanticLabel;

  const RemixSelectItem({
    required this.value,
    required this.label,
    this.enabled = true,
    this.style = const SelectMenuItemStyler.create(),
    this.semanticLabel,
  });
}

/// A customizable select component with data-driven API.
///
/// Uses a simple, declarative API with data classes for trigger and items.
/// Form input component for selecting a single value from a dropdown list.
///
/// ## Example
///
/// ```dart
/// RemixSelect<String>(
///   trigger: RemixSelectTrigger(placeholder: 'Select a fruit'),
///   items: [
///     RemixSelectItem(value: 'apple', label: 'Apple'),
///     RemixSelectItem(value: 'banana', label: 'Banana'),
///     RemixSelectItem(value: 'orange', label: 'Orange'),
///   ],
///   selectedValue: selectedValue,
///   onChanged: (value) => setState(() => selectedValue = value),
/// )
/// ```
class RemixSelect<T> extends StatefulWidget {
  const RemixSelect({
    super.key,
    required this.trigger,
    required this.items,
    this.selectedValue,
    this.positioning = const OverlayPositionConfig(
      side: .bottom,
      alignment: .center,
    ),
    this.onChanged,
    this.onOpen,
    this.onClose,
    this.enabled = true,
    this.mouseCursor = SystemMouseCursors.click,
    this.semanticLabel,
    this.closeOnSelect = true,
    this.focusNode,
    this.style = const SelectStyler.create(),
    this.styleSpec,
  });

  /// The trigger data that defines the select's button.
  final RemixSelectTrigger trigger;

  /// The list of selectable items.
  final List<RemixSelectItem<T>> items;

  /// The currently selected value.
  final T? selectedValue;

  /// Overlay positioning configuration for the dropdown.
  final OverlayPositionConfig positioning;

  /// Called when the selected value changes.
  ///
  /// When null, the select is disabled. NakedSelect derives interactivity
  /// from this callback; a no-op wrapper must not be used to fake a
  /// read-only inspectable mode.
  final ValueChanged<T?>? onChanged;

  /// Called when the dropdown opens.
  final VoidCallback? onOpen;

  /// Called when the dropdown closes.
  final VoidCallback? onClose;

  /// Whether the select is enabled and can be interacted with.
  final bool enabled;

  /// The mouse cursor for the select trigger.
  final MouseCursor mouseCursor;

  /// Semantic label for accessibility.
  final String? semanticLabel;

  /// Whether to automatically close the dropdown when an item is selected.
  final bool closeOnSelect;

  /// Optional focus node to control focus behavior.
  final FocusNode? focusNode;

  /// The style configuration for the select.
  final SelectStyler style;

  /// Optional raw style spec that bypasses fluent style resolution.
  final SelectSpec? styleSpec;

  static final styleFrom = SelectStyler.new;

  @override
  State<RemixSelect<T>> createState() => _RemixSelectState<T>();
}

class _RemixSelectState<T> extends State<RemixSelect<T>>
    with SingleTickerProviderStateMixin {
  late final _panelTransition = RemixPanelTransitionHandle(vsync: this);

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

  /// Carries only the item branch of [style], merged with the row's own style.
  ///
  /// A row must resolve under its own option states, so it cannot reuse the
  /// menu's already-resolved spec. It must not resolve the whole [SelectStyler]
  /// either: that re-applies the root animation and widget modifiers the
  /// trigger and overlay already own, once per row.
  SelectStyler _itemStyle(SelectStyler style, RemixSelectItem<T> item) {
    return SelectStyler.create(
      item: MixOps.merge(
        style.$item,
        Prop.maybeMix<StyleSpec<SelectMenuItemSpec>>(item.style),
      ),
    );
  }

  /// Menu chrome resolves once from [spec], without option states; each row
  /// re-resolves its own branch from [style]. The two inputs are two different
  /// resolution scopes, not a duplicated one.
  Widget _buildOverlayMenu(
    SelectSpec spec,
    SelectStyler style,
    Rect anchorRect,
  ) {
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
            children: widget.items
                .map(
                  (item) => _RemixSelectItemWidget(
                    data: item,
                    itemStyle: _itemStyle(style, item),
                    selectStyleSpec: widget.styleSpec,
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  /// The selected item's position in [RemixSelect.items], or `-1`.
  int _findSelectedIndex() {
    final selectedValue = widget.selectedValue;
    if (selectedValue == null) return -1;

    return widget.items.indexWhere((item) => item.value == selectedValue);
  }

  /// Returns true so the whole check, loop included, is stripped in release.
  bool _debugValidate(RemixSelectItem<T>? selectedItem) {
    assert(
      widget.trigger.placeholder.trim().isNotEmpty,
      'RemixSelect trigger placeholder must be a nonblank string.',
    );

    final seen = <T>{};
    for (final item in widget.items) {
      assert(
        item.label.trim().isNotEmpty,
        'RemixSelect item labels must be nonblank. Value: ${item.value}',
      );
      final semanticLabel = item.semanticLabel;
      assert(
        semanticLabel == null || semanticLabel.trim().isNotEmpty,
        'RemixSelect item semantic labels must be nonblank when provided. '
        'Value: ${item.value}',
      );
      assert(
        seen.add(item.value),
        'RemixSelect item values must be unique. Duplicate: ${item.value}',
      );
    }

    assert(
      widget.selectedValue == null || selectedItem != null,
      'RemixSelect selectedValue "${widget.selectedValue}" is not present '
      'in items. Do not treat an unmatched selection as the placeholder.',
    );

    return true;
  }

  /// Whether the style opts the trigger into `selected` while open. Read
  /// without the open state, so the flag cannot depend on it.
  bool _selectedWhileOpen(BuildContext context, SelectStyler style) =>
      (widget.styleSpec ?? style.build(context).spec)
          .trigger
          .spec
          .selectedWhileOpen ??
      false;

  @override
  void dispose() {
    _panelTransition.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = _buildStyle();
    final selectedIndex = _findSelectedIndex();
    final selectedItem = selectedIndex < 0 ? null : widget.items[selectedIndex];
    assert(_debugValidate(selectedItem));
    final hasSelection = widget.selectedValue != null;

    final anchor = NakedSelect<T>(
      overlayBuilder: (context, info) {
        return RemixAnchorScope(
          width: info.anchorRect.width,
          child: RemixStyleSpecBuilder<SelectSpec>(
            style: style,
            styleSpec: widget.styleSpec,
            builder: (context, spec) =>
                _buildOverlayMenu(spec, style, info.anchorRect),
          ),
        );
      },
      value: widget.selectedValue,
      onChanged: widget.onChanged,
      closeOnSelect: widget.closeOnSelect,
      enabled: widget.enabled,
      mouseCursor: widget.mouseCursor,
      triggerFocusNode: widget.focusNode,
      semanticLabel: widget.semanticLabel,
      semanticValue: selectedItem?.semanticLabel ?? selectedItem?.label,
      positioning: widget.positioning,
      constrainToAvailableSpace: true,
      onOpen: widget.onOpen,
      onOpenRequested: (position, showOverlay) =>
          _panelTransition.openRequested(position, showOverlay, null),
      onCloseRequested: (hideOverlay) =>
          _panelTransition.closeRequested(hideOverlay, null),
      onClose: widget.onClose,
      builder: (context, state, _) {
        final controller = NakedSelectState.controllerOf<T>(context);
        return ListenableBuilder(
          listenable: Listenable.merge([controller, _panelTransition]),
          builder: (context, _) => WidgetStateProvider(
            states: {
              ...controller.value,
              if (state.isOpen &&
                  !_panelTransition.isExiting &&
                  _selectedWhileOpen(context, style))
                .selected,
            },
            child: RemixStyleSpecBuilder<SelectSpec>(
              style: style,
              styleSpec: widget.styleSpec,
              trackFocusVisibility: true,
              builder: (context, spec) {
                return _RemixSelectTriggerWidget(
                  trigger: widget.trigger,
                  displayLabel:
                      selectedItem?.label ??
                      (hasSelection
                          ? '${widget.selectedValue}'
                          : widget.trigger.placeholder),
                  isPlaceholder: !hasSelection,
                  selection: (hasSelection, widget.selectedValue),
                  selectionIndex: selectedIndex,
                  isOpen: state.isOpen,
                  styleSpec: spec.trigger,
                );
              },
            ),
          ),
        );
      },
    );
    return _panelTransition.wrapAnchor(anchor);
  }
}

/// The select's panel motion when its style sets none: a 150 ms ease-in-out
/// fade and scale from 95 percent.
const _defaultPanelTransition = RemixPanelTransition(
  duration: Duration(milliseconds: 150),
  builder: _defaultPanelBuilder,
);

Widget _defaultPanelBuilder(
  BuildContext context,
  RemixPanelTransitionInfo info,
  Widget panel,
) {
  final curved = info.animation.drive(CurveTween(curve: Curves.easeInOut));
  return FadeTransition(
    opacity: curved,
    child: ScaleTransition(
      scale: Tween<double>(begin: 0.95, end: 1).animate(curved),
      child: panel,
    ),
  );
}

/// Internal widget for rendering the select trigger.
class _RemixSelectTriggerWidget extends StatelessWidget {
  const _RemixSelectTriggerWidget({
    required this.trigger,
    required this.displayLabel,
    required this.isPlaceholder,
    required this.selection,
    required this.selectionIndex,
    required this.isOpen,
    required this.styleSpec,
  });

  final RemixSelectTrigger trigger;
  final String displayLabel;
  final bool isPlaceholder;
  final Object selection;
  final int selectionIndex;
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
        final indicatorAngle =
            spec.indicatorAngle ??
            (indicatorIcon == null ? (isOpen ? math.pi : 0.0) : null);
        final indicator = indicatorIcon == null
            ? RemixPathIcon(
                key: const ValueKey('remix-select-indicator'),
                glyph: RemixPathGlyph.chevronDown,
                styleSpec: spec.indicator,
              )
            : StyledIcon(
                key: const ValueKey('remix-select-indicator'),
                icon: indicatorIcon,
                styleSpec: spec.indicator,
              );

        return RemixFlexBoxAdapter(
          styleSpec: spec.container,
          direction: Axis.horizontal,
          containerEffects: spec.containerEffects,
          children: [
            if (trigger.icon != null)
              StyledIcon(icon: trigger.icon!, styleSpec: spec.icon),
            Expanded(
              child: _RemixSelectLabelSwitcher(
                selection: selection,
                index: selectionIndex,
                transition: spec.labelTransition,
                label: Opacity(
                  opacity: isPlaceholder ? spec.placeholderOpacity ?? 1 : 1,
                  child: StyledText(
                    displayLabel,
                    styleSpec: isPlaceholder ? spec.placeholder : spec.label,
                  ),
                ),
              ),
            ),
            Opacity(
              opacity: spec.indicatorOpacity ?? 1,
              child: indicatorAngle == null
                  ? indicator
                  : Transform.rotate(angle: indicatorAngle, child: indicator),
            ),
          ],
        );
      },
    );
  }
}

/// Internal widget for rendering a selectable item.
class _RemixSelectItemWidget<T> extends StatelessWidget {
  const _RemixSelectItemWidget({
    required this.data,
    required this.itemStyle,
    this.selectStyleSpec,
  });

  final RemixSelectItem<T> data;

  /// A [SelectStyler] carrying only this row's merged item branch.
  final SelectStyler itemStyle;
  final SelectSpec? selectStyleSpec;

  @override
  Widget build(BuildContext context) {
    return NakedSelectOption<T>(
      value: data.value,
      enabled: data.enabled,
      semanticLabel: data.semanticLabel ?? data.label,
      builder: (context, state, _) {
        return RemixStyleSpecBuilder<SelectSpec>(
          style: itemStyle,
          styleSpec: selectStyleSpec,
          controller: NakedSelectOptionState.controllerOf<T>(context),
          // The item spec is built here rather than unwrapped with `.spec` so
          // the item's own animation and widget modifiers still render.
          builder: (context, spec) => StyleSpecBuilder<SelectMenuItemSpec>(
            styleSpec: spec.item,
            builder: (context, item) => ExcludeSemantics(
              child: RemixFlexBoxAdapter(
                styleSpec: item.container,
                direction: Axis.horizontal,
                containerEffects: item.containerEffects,
                children: [
                  Expanded(child: StyledText(data.label, styleSpec: item.text)),
                  if (state.isSelected)
                    Box(
                      styleSpec: item.indicator,
                      child: RemixPathIcon(
                        key: const ValueKey('fortal-select-indicator'),
                        glyph: RemixPathGlyph.thickCheck,
                        styleSpec: item.icon,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
