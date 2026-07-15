part of 'toggle_group.dart';

/// Declarative data for one option in a [RemixToggleGroup].
class RemixToggleGroupItem<T> {
  /// The value selected when this item is activated.
  final T value;

  /// Optional text shown in the item.
  final String? label;

  /// Optional icon shown before [label].
  final IconData? icon;

  /// Accessibility label for this item.
  ///
  /// Falls back to [label] when omitted.
  final String? semanticLabel;

  /// Whether the item can receive focus and be activated.
  final bool enabled;

  /// Optional caller-owned focus node.
  final FocusNode? focusNode;

  /// Whether this item requests initial focus when the group mounts.
  final bool autofocus;

  /// Per-item style merged after the group's default item style.
  final RemixToggleGroupItemStyler style;

  const RemixToggleGroupItem({
    required this.value,
    this.label,
    this.icon,
    this.semanticLabel,
    this.enabled = true,
    this.focusNode,
    this.autofocus = false,
    this.style = const RemixToggleGroupItemStyler.create(),
  }) : assert(
         label != null || icon != null,
         'At least one of label or icon must be provided',
       );
}

/// A styled, single-select toggle group with roving keyboard focus.
class RemixToggleGroup<T> extends StatelessWidget {
  const RemixToggleGroup({
    super.key,
    required this.items,
    required this.selectedValue,
    this.onChanged,
    this.enabled = true,
    this.orientation = .horizontal,
    this.loop = true,
    this.semanticLabel,
    this.excludeSemantics = false,
    this.style = const RemixToggleGroupStyler.create(),
    this.styleSpec,
  });

  /// Items rendered in visual and focus-traversal order.
  final List<RemixToggleGroupItem<T>> items;

  /// The currently selected item value.
  final T? selectedValue;

  /// Called when an item is activated with a different value.
  final ValueChanged<T?>? onChanged;

  /// Whether the whole group is interactive.
  final bool enabled;

  /// Axis used for layout and arrow-key navigation.
  final Axis orientation;

  /// Whether arrow navigation wraps at the ends.
  final bool loop;

  /// Accessibility label for the group.
  final String? semanticLabel;

  /// Whether the group and all items are hidden from semantics.
  final bool excludeSemantics;

  /// Fluent visual style for the group and its default item style.
  final RemixToggleGroupStyler style;

  /// Optional raw style spec that bypasses fluent group style resolution.
  final RemixToggleGroupSpec? styleSpec;

  static final styleFrom = RemixToggleGroupStyler.new;

  StyleSpec<FlexBoxSpec> _withOrientation(StyleSpec<FlexBoxSpec> container) {
    final flex = container.spec.flex ?? const StyleSpec(spec: FlexSpec());

    return container.copyWith(
      spec: container.spec.copyWith(
        flex: flex.copyWith(spec: flex.spec.copyWith(direction: orientation)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = RemixToggleGroupStyler(
      container: FlexBoxStyler(
        direction: orientation,
        mainAxisSize: .min,
      ).wrap(.intrinsicWidth().intrinsicHeight()),
    ).merge(style);
    // Resolve group-level context variants now, while retaining nested item
    // variants for resolution inside each option's WidgetStateProvider.
    final activeStyle =
        // Mix does not expose another way to retain nested item variants.
        // ignore: invalid_use_of_visible_for_testing_member
        effectiveStyle.mergeActiveVariants(context, namedVariants: const {})
            as RemixToggleGroupStyler;

    return NakedToggleGroup<T>(
      selectedValue: selectedValue,
      onChanged: onChanged,
      enabled: enabled,
      orientation: orientation,
      loop: loop,
      semanticLabel: semanticLabel,
      excludeSemantics: excludeSemantics,
      child: RemixStyleSpecBuilder<RemixToggleGroupSpec>(
        style: effectiveStyle,
        styleSpec: styleSpec,
        builder: (context, spec) {
          return FlexBox(
            styleSpec: _withOrientation(spec.container),
            children: [
              for (final item in items)
                _RemixToggleGroupItemWidget(
                  key: ValueKey(item.value),
                  data: item,
                  defaultStyle: styleSpec == null ? activeStyle.$item : null,
                  defaultStyleSpec: styleSpec == null ? null : spec.item,
                ),
            ],
          );
        },
      ),
    );
  }
}

class _RemixToggleGroupItemWidget<T> extends StatelessWidget {
  const _RemixToggleGroupItemWidget({
    super.key,
    required this.data,
    this.defaultStyle,
    this.defaultStyleSpec,
  });

  final RemixToggleGroupItem<T> data;
  final Prop<StyleSpec<RemixToggleGroupItemSpec>>? defaultStyle;
  final StyleSpec<RemixToggleGroupItemSpec>? defaultStyleSpec;

  StyleSpec<RemixToggleGroupItemSpec> _resolveStyle(BuildContext context) {
    final rawDefault = defaultStyleSpec;
    if (rawDefault != null) {
      final resolved = RemixToggleGroupItemStyler.create(
        container: Prop.value(rawDefault.spec.container),
        label: Prop.value(rawDefault.spec.label),
        icon: Prop.value(rawDefault.spec.icon),
      ).merge(data.style).build(context);
      final modifiers = [
        ...?rawDefault.widgetModifiers,
        ...?resolved.widgetModifiers,
      ];

      return StyleSpec(
        spec: resolved.spec,
        animation: resolved.animation ?? rawDefault.animation,
        widgetModifiers: modifiers.isEmpty ? null : modifiers,
      );
    }

    final itemStyle = MixOps.merge(
      defaultStyle,
      Prop.maybeMix<StyleSpec<RemixToggleGroupItemSpec>>(data.style),
    );

    return MixOps.resolve(context, itemStyle) ??
        const StyleSpec(spec: RemixToggleGroupItemSpec());
  }

  @override
  Widget build(BuildContext context) {
    return NakedToggleOption<T>(
      value: data.value,
      enabled: data.enabled,
      focusNode: data.focusNode,
      autofocus: data.autofocus,
      semanticLabel: data.semanticLabel ?? data.label,
      builder: (context, state, _) {
        return WidgetStateProvider(
          states: state.states,
          child: Builder(
            builder: (context) {
              return StyleSpecBuilder<RemixToggleGroupItemSpec>(
                styleSpec: _resolveStyle(context),
                builder: (context, spec) {
                  return RowBox(
                    styleSpec: spec.container,
                    children: [
                      if (data.icon != null)
                        StyledIcon(icon: data.icon!, styleSpec: spec.icon),
                      if (data.label != null)
                        StyledText(data.label!, styleSpec: spec.label),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
