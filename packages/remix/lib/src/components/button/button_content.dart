part of 'button.dart';

/// Keeps the styled box outside the row, so the row sees its actual available
/// width after the caller's constraints, padding, and decorations are applied.
class _ButtonContentRow extends StatelessWidget {
  const _ButtonContentRow({
    required this.styleSpec,
    required this.containerEffects,
    required this.children,
  });

  final StyleSpec<FlexBoxSpec> styleSpec;
  final RemixBoxEffectsSpec? containerEffects;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => StyleSpecBuilder<FlexBoxSpec>(
    styleSpec: styleSpec,
    builder: (context, spec) => RemixBoxAdapter(
      styleSpec: spec.box ?? const StyleSpec(spec: BoxSpec()),
      containerEffects: containerEffects,
      child: _ButtonFlex(spec: spec.flex?.spec, children: children),
    ),
  );
}

class _ButtonFlex extends Flex {
  _ButtonFlex({required FlexSpec? spec, required super.children})
    : assert(spec?.direction != Axis.vertical),
      super(
        direction: Axis.horizontal,
        mainAxisAlignment: spec?.mainAxisAlignment ?? .start,
        mainAxisSize: spec?.mainAxisSize ?? .max,
        crossAxisAlignment: spec?.crossAxisAlignment ?? .center,
        textDirection: spec?.textDirection,
        verticalDirection: spec?.verticalDirection ?? .down,
        textBaseline: spec?.textBaseline,
        clipBehavior: spec?.clipBehavior ?? .none,
        spacing: spec?.spacing ?? 0,
      );

  @override
  RenderFlex createRenderObject(BuildContext context) => _RenderButtonFlex(
    direction: direction,
    mainAxisAlignment: mainAxisAlignment,
    mainAxisSize: mainAxisSize,
    crossAxisAlignment: crossAxisAlignment,
    textDirection: getEffectiveTextDirection(context),
    verticalDirection: verticalDirection,
    textBaseline: textBaseline,
    clipBehavior: clipBehavior,
    spacing: spacing,
  );
}

class _RenderButtonFlex extends RenderFlex {
  _RenderButtonFlex({
    required super.direction,
    required super.mainAxisAlignment,
    required super.mainAxisSize,
    required super.crossAxisAlignment,
    required super.textDirection,
    required super.verticalDirection,
    required super.textBaseline,
    required super.clipBehavior,
    required super.spacing,
  });

  bool _shrinkWrapWidth = false;

  // Flex cannot expand along an infinite axis. With loose Flexible children,
  // min uses their natural widths; finite layouts retain the caller's setting.
  @override
  MainAxisSize get mainAxisSize =>
      _shrinkWrapWidth ? MainAxisSize.min : super.mainAxisSize;

  T _withWidthConstraints<T>(BoxConstraints constraints, T Function() size) {
    final previous = _shrinkWrapWidth;
    _shrinkWrapWidth = !constraints.hasBoundedWidth;
    try {
      return size();
    } finally {
      _shrinkWrapWidth = previous;
    }
  }

  @override
  void performLayout() =>
      _withWidthConstraints(constraints, super.performLayout);

  @override
  Size computeDryLayout(BoxConstraints constraints) => _withWidthConstraints(
    constraints,
    () => super.computeDryLayout(constraints),
  );

  @override
  double? computeDryBaseline(
    BoxConstraints constraints,
    TextBaseline baseline,
  ) => _withWidthConstraints(
    constraints,
    () => super.computeDryBaseline(constraints, baseline),
  );
}
