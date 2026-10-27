part of 'remix_box_effects.dart';

/// Routes a resolved Mix [Box] through the simplest compatible renderer.
///
/// Ordinary boxes stay on Mix's standard renderer. Advanced effects use the
/// dedicated [_RemixBoxEffectsRenderer], while CSS-style negative margins are
/// handled by the independent outer-layout adapter.
@internal
final class RemixBoxAdapter extends StatefulWidget {
  const RemixBoxAdapter({
    super.key,
    required this.styleSpec,
    this.containerEffects,
    this.child,
  });

  final StyleSpec<BoxSpec> styleSpec;
  final RemixBoxEffectsSpec? containerEffects;
  final Widget? child;

  @override
  State<RemixBoxAdapter> createState() => _RemixBoxAdapterState();
}

final class _RemixBoxAdapterState extends State<RemixBoxAdapter> {
  final GlobalKey _childKey = GlobalKey(
    debugLabel: 'RemixBoxAdapter logical child',
  );

  @override
  Widget build(BuildContext context) {
    final effects = widget.containerEffects ?? const RemixBoxEffectsSpec();
    final child = widget.child == null
        ? null
        : KeyedSubtree(key: _childKey, child: widget.child!);
    _validateEffects(effects);
    return StyleSpecBuilder<BoxSpec>(
      styleSpec: widget.styleSpec,
      builder: (context, spec) {
        final margin = spec.margin;
        if (_canUseStandardMixRendering(effects: effects, margin: margin)) {
          return Box(
            styleSpec: StyleSpec(spec: spec),
            child: child,
          );
        }

        final innerSpec = _withoutOuterBoxLayout(spec);
        final Widget inner;
        if (effects.isEmpty) {
          inner = Box(
            styleSpec: StyleSpec(spec: innerSpec),
            child: child,
          );
        } else {
          _validateBoxDecoration(spec.decoration);
          inner = _RemixBoxEffectsRenderer(
            spec: innerSpec,
            effects: effects,
            child: child,
          );
        }
        return _applyRemixOuterBoxLayout(
          margin: margin,
          transform: spec.transform,
          transformAlignment: spec.transformAlignment,
          child: inner,
        );
      },
    );
  }
}

/// Flex counterpart of [RemixBoxAdapter].
@internal
final class RemixFlexBoxAdapter extends StatelessWidget {
  const RemixFlexBoxAdapter({
    super.key,
    required this.styleSpec,
    this.direction,
    this.containerEffects,
    this.scrollable = false,
    this.children = const [],
  }) : assert(
         !scrollable || direction == Axis.vertical,
         'Only a vertical flex box can scroll.',
       );

  final StyleSpec<FlexBoxSpec> styleSpec;
  final Axis? direction;
  final RemixBoxEffectsSpec? containerEffects;

  /// Whether the children scroll when they are taller than the room the box
  /// leaves them.
  ///
  /// The box's padding, decoration, constraints, and effects frame the scroll
  /// view and stay put while the children move. The children's column sizes to
  /// its content inside the scroll view, so main-axis alignment and a maximal
  /// main-axis size have no free space to distribute. Requires a vertical
  /// [direction].
  ///
  /// The scroll view is meant for overlay panels: it does not attach to the
  /// host page's primary scroll controller or notify the host page, and it
  /// clamps at the ends without overscroll effects.
  final bool scrollable;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final effects = containerEffects ?? const RemixBoxEffectsSpec();
    _validateEffects(effects);
    return StyleSpecBuilder<FlexBoxSpec>(
      styleSpec: styleSpec,
      builder: (context, spec) {
        final flexStyleSpec = StyleSpec(spec: FlexBoxSpec(flex: spec.flex));
        final content = switch (direction) {
          Axis.horizontal => RowBox(
            styleSpec: flexStyleSpec,
            children: children,
          ),
          Axis.vertical => ColumnBox(
            styleSpec: flexStyleSpec,
            children: children,
          ),
          null => FlexBox(styleSpec: flexStyleSpec, children: children),
        };
        return RemixBoxAdapter(
          styleSpec: spec.box ?? const StyleSpec(spec: BoxSpec()),
          containerEffects: effects,
          child: scrollable ? _ContainedScrollView(child: content) : content,
        );
      },
    );
  }
}

/// A vertical scroll view that stays inside the overlay panel it scrolls.
class _ContainedScrollView extends StatelessWidget {
  const _ContainedScrollView({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // The overlay sits under the host page in the widget tree. Without the
    // listener, its scrolling would reach the page's app bar and scrollbars as
    // though the page's own list had scrolled.
    return NotificationListener<ViewportNotificationMixin>(
      onNotification: (_) => true,
      child: ScrollConfiguration(
        // Like Flutter's own menus: stop at the ends rather than bounce or
        // stretch. The scrollbar stays.
        behavior: ScrollConfiguration.of(
          context,
        ).copyWith(overscroll: false, physics: const ClampingScrollPhysics()),
        child: SingleChildScrollView(
          // Otherwise the overlay attaches to the host page's primary scroll
          // controller, which a list on the page may already use.
          primary: false,
          child: child,
        ),
      ),
    );
  }
}

bool _canUseStandardMixRendering({
  required RemixBoxEffectsSpec effects,
  EdgeInsetsGeometry? margin,
}) => effects.isEmpty && (margin == null || margin.isNonNegative);

/// Validates at the adapter boundary so every rendering path rejects the same
/// unsupported values before choosing an implementation.
void _validateEffects(RemixBoxEffectsSpec effects) {
  if (!effects.backdropBlur.isFinite) {
    throw FlutterError(
      'RemixBoxEffectsSpec.backdropBlur must be finite. '
      'Received ${effects.backdropBlur}.',
    );
  }
  if (effects.backdropBlur < 0) {
    throw FlutterError(
      'RemixBoxEffectsSpec.backdropBlur must be non-negative. '
      'Received ${effects.backdropBlur}.',
    );
  }
  if (!effects.outline.width.isFinite) {
    throw FlutterError(
      'RemixBoxEffectsSpec.outline.width must be finite. '
      'Received ${effects.outline.width}.',
    );
  }
  if (effects.outline.width < 0) {
    throw FlutterError(
      'RemixBoxEffectsSpec.outline.width must be non-negative. '
      'Received ${effects.outline.width}.',
    );
  }
  if (!effects.outlineOffset.isFinite) {
    throw FlutterError(
      'RemixBoxEffectsSpec.outlineOffset must be finite. '
      'Received ${effects.outlineOffset}.',
    );
  }
  if (effects.outline.style != BorderStyle.none &&
      effects.outline.strokeAlign != BorderSide.strokeAlignInside) {
    throw FlutterError(
      'Remix box effects outlines must use BorderSide.strokeAlignInside.',
    );
  }
  if (effects.behindContent case final layer?) {
    _validateEffectLayer(layer, 'behindContent');
  }
  if (effects.overContent case final layer?) {
    _validateEffectLayer(layer, 'overContent');
  }
}

void _validateEffectLayer(RemixBoxEffectLayerSpec layer, String name) {
  if (layer.gradientInsets.isNotEmpty &&
      layer.gradientInsets.length != layer.gradients.length) {
    throw FlutterError(
      'RemixBoxEffectsSpec.$name.gradientInsets must be empty or match the '
      'gradients length.',
    );
  }
  for (final inset in layer.gradientInsets) {
    if (!inset.isFinite || inset < 0) {
      throw FlutterError(
        'RemixBoxEffectsSpec.$name.gradientInsets must contain finite '
        'non-negative values. Received ${layer.gradientInsets}.',
      );
    }
  }
  for (var index = 0; index < layer.shadows.length; index++) {
    final shadow = layer.shadows[index];
    final path = 'RemixBoxEffectsSpec.$name.shadows[$index]';
    if (!shadow.offset.dx.isFinite || !shadow.offset.dy.isFinite) {
      throw FlutterError(
        '$path.offset must contain finite values. Received ${shadow.offset}.',
      );
    }
    if (!shadow.blurRadius.isFinite || shadow.blurRadius < 0) {
      throw FlutterError(
        '$path.blurRadius must be finite and non-negative. '
        'Received ${shadow.blurRadius}.',
      );
    }
    if (!shadow.spreadRadius.isFinite) {
      throw FlutterError(
        '$path.spreadRadius must be finite. '
        'Received ${shadow.spreadRadius}.',
      );
    }
    if (!shadow.shapeInset.isFinite || shadow.shapeInset < 0) {
      throw FlutterError(
        '$path.shapeInset must be finite and non-negative. '
        'Received ${shadow.shapeInset}.',
      );
    }
  }
}

void _validateBoxDecoration(Decoration? decoration) {
  final unsupported =
      (decoration != null && decoration is! BoxDecoration) ||
      decoration is BoxDecoration && decoration.shape == BoxShape.circle;
  if (!unsupported) return;

  throw FlutterError(
    'Remix box effects require a rectangular BoxDecoration. '
    'ShapeDecoration and BoxShape.circle are not supported.',
  );
}
