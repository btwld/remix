part of 'button.dart';

/// Style builder for [RemixButton].
///
/// Use this class to style the button container, label, icons, and loading
/// spinner. It supports Mix variants and widget state variants for focused,
/// hovered, pressed, disabled, and loading states.
@MixableStyler()
class RemixButtonStyler extends MixStyler<RemixButtonStyler, RemixButtonSpec>
    with
        LabelStyleMixin<RemixButtonStyler>,
        IconStyleMixin<RemixButtonStyler>,
        SpinnerStyleMixin<RemixButtonStyler>,
        _$RemixButtonStylerMixin {
  /// Style applied to the button's outer layout and decoration.
  @MixableField(setterType: FlexBoxStyler)
  final Prop<StyleSpec<FlexBoxSpec>>? $container;

  /// Style applied to the button label.
  @MixableField(setterType: TextStyler)
  final Prop<StyleSpec<TextSpec>>? $label;

  /// Style applied to leading and trailing icons.
  @MixableField(setterType: IconStyler)
  final Prop<StyleSpec<IconSpec>>? $icon;

  /// Style applied to the loading spinner.
  @MixableField(setterType: RemixSpinnerStyler)
  final Prop<StyleSpec<RemixSpinnerSpec>>? $spinner;

  /// Alignment used when rendering an icon next to the label.
  final Prop<IconAlignment>? $iconAlignment;

  /// Creates a button style from raw Mix properties.
  const RemixButtonStyler.create({
    Prop<StyleSpec<FlexBoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? label,
    Prop<StyleSpec<IconSpec>>? icon,
    Prop<StyleSpec<RemixSpinnerSpec>>? spinner,
    Prop<IconAlignment>? iconAlignment,
    super.variants,
    super.modifier,
    super.animation,
  }) : $container = container,
       $label = label,
       $icon = icon,
       $spinner = spinner,
       $iconAlignment = iconAlignment;

  /// Creates a button style from plain Dart values and Mix stylers.
  RemixButtonStyler({
    FlexBoxStyler? container,
    TextStyler? label,
    IconStyler? icon,
    RemixSpinnerStyler? spinner,
    IconAlignment? iconAlignment,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<RemixButtonSpec>>? variants,
  }) : this.create(
         container: Prop.maybeMix(container),
         label: Prop.maybeMix(label),
         icon: Prop.maybeMix(icon),
         spinner: Prop.maybeMix(spinner),
         iconAlignment: Prop.maybe(iconAlignment),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  /// Creates a button style that only sets [IconAlignment].
  factory RemixButtonStyler.iconAlignment(IconAlignment value) {
    return RemixButtonStyler().iconAlignment(value);
  }

  /// Creates a [RemixButton] widget with this style applied.
  RemixButton call({
    Key? key,
    required String label,
    IconData? leadingIcon,
    IconData? trailingIcon,
    RemixButtonTextBuilder? textBuilder,
    RemixButtonIconBuilder? leadingIconBuilder,
    RemixButtonIconBuilder? trailingIconBuilder,
    RemixButtonLoadingBuilder? loadingBuilder,
    bool loading = false,
    bool enabled = true,
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
    FocusNode? focusNode,
    bool autofocus = false,
    bool enableFeedback = true,
    String? semanticLabel,
    String? semanticHint,
    bool excludeSemantics = false,
    MouseCursor mouseCursor = SystemMouseCursors.click,
  }) {
    return RemixButton(
      key: key,
      label: label,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      textBuilder: textBuilder,
      leadingIconBuilder: leadingIconBuilder,
      trailingIconBuilder: trailingIconBuilder,
      loadingBuilder: loadingBuilder,
      loading: loading,
      enabled: enabled,
      onPressed: onPressed,
      onLongPress: onLongPress,
      focusNode: focusNode,
      autofocus: autofocus,
      enableFeedback: enableFeedback,
      semanticLabel: semanticLabel,
      semanticHint: semanticHint,
      excludeSemantics: excludeSemantics,
      mouseCursor: mouseCursor,
      style: this,
    );
  }
}

extension RemixButtonStyleContainerHelpers on RemixButtonStyler {
  RemixButtonStyler padding(EdgeInsetsGeometryMix value) {
    return container(FlexBoxStyler(padding: value));
  }

  RemixButtonStyler paddingTop(double value) {
    return padding(EdgeInsetsGeometryMix.top(value));
  }

  RemixButtonStyler paddingBottom(double value) {
    return padding(EdgeInsetsGeometryMix.bottom(value));
  }

  RemixButtonStyler paddingLeft(double value) {
    return padding(EdgeInsetsGeometryMix.left(value));
  }

  RemixButtonStyler paddingRight(double value) {
    return padding(EdgeInsetsGeometryMix.right(value));
  }

  RemixButtonStyler paddingX(double value) {
    return padding(EdgeInsetsGeometryMix.horizontal(value));
  }

  RemixButtonStyler paddingY(double value) {
    return padding(EdgeInsetsGeometryMix.vertical(value));
  }

  RemixButtonStyler paddingAll(double value) {
    return padding(EdgeInsetsGeometryMix.all(value));
  }

  RemixButtonStyler paddingStart(double value) {
    return padding(EdgeInsetsGeometryMix.start(value));
  }

  RemixButtonStyler paddingEnd(double value) {
    return padding(EdgeInsetsGeometryMix.end(value));
  }

  RemixButtonStyler paddingOnly({
    double? horizontal,
    double? vertical,
    double? start,
    double? end,
    double? left,
    double? right,
    double? top,
    double? bottom,
  }) {
    if (start != null || end != null) {
      return padding(
        EdgeInsetsGeometryMix.directional(
          start: start ?? left ?? horizontal,
          end: end ?? right ?? horizontal,
          top: top ?? vertical,
          bottom: bottom ?? vertical,
        ),
      );
    }

    return padding(
      EdgeInsetsGeometryMix.only(
        left: left ?? horizontal,
        right: right ?? horizontal,
        top: top ?? vertical,
        bottom: bottom ?? vertical,
      ),
    );
  }

  RemixButtonStyler margin(EdgeInsetsGeometryMix value) {
    return container(FlexBoxStyler(margin: value));
  }

  RemixButtonStyler marginTop(double value) {
    return margin(EdgeInsetsGeometryMix.top(value));
  }

  RemixButtonStyler marginBottom(double value) {
    return margin(EdgeInsetsGeometryMix.bottom(value));
  }

  RemixButtonStyler marginLeft(double value) {
    return margin(EdgeInsetsGeometryMix.left(value));
  }

  RemixButtonStyler marginRight(double value) {
    return margin(EdgeInsetsGeometryMix.right(value));
  }

  RemixButtonStyler marginX(double value) {
    return margin(EdgeInsetsGeometryMix.horizontal(value));
  }

  RemixButtonStyler marginY(double value) {
    return margin(EdgeInsetsGeometryMix.vertical(value));
  }

  RemixButtonStyler marginAll(double value) {
    return margin(EdgeInsetsGeometryMix.all(value));
  }

  RemixButtonStyler marginStart(double value) {
    return margin(EdgeInsetsGeometryMix.start(value));
  }

  RemixButtonStyler marginEnd(double value) {
    return margin(EdgeInsetsGeometryMix.end(value));
  }

  RemixButtonStyler marginOnly({
    double? horizontal,
    double? vertical,
    double? start,
    double? end,
    double? left,
    double? right,
    double? top,
    double? bottom,
  }) {
    if (start != null || end != null) {
      return margin(
        EdgeInsetsGeometryMix.directional(
          start: start ?? left ?? horizontal,
          end: end ?? right ?? horizontal,
          top: top ?? vertical,
          bottom: bottom ?? vertical,
        ),
      );
    }

    return margin(
      EdgeInsetsGeometryMix.only(
        left: left ?? horizontal,
        right: right ?? horizontal,
        top: top ?? vertical,
        bottom: bottom ?? vertical,
      ),
    );
  }

  RemixButtonStyler decoration(DecorationMix value) {
    return container(FlexBoxStyler(decoration: value));
  }

  RemixButtonStyler foregroundDecoration(DecorationMix value) {
    return container(FlexBoxStyler(foregroundDecoration: value));
  }

  RemixButtonStyler alignment(AlignmentGeometry value) {
    return container(FlexBoxStyler(alignment: value));
  }

  RemixButtonStyler constraints(BoxConstraintsMix value) {
    return container(FlexBoxStyler(constraints: value));
  }

  RemixButtonStyler constraintsOnly({
    double? width,
    double? height,
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
  }) {
    return constraints(
      BoxConstraintsMix(
        minWidth: minWidth ?? width,
        maxWidth: maxWidth ?? width,
        minHeight: minHeight ?? height,
        maxHeight: maxHeight ?? height,
      ),
    );
  }

  RemixButtonStyler width(double value) {
    return constraints(BoxConstraintsMix.width(value));
  }

  RemixButtonStyler height(double value) {
    return constraints(BoxConstraintsMix.height(value));
  }

  RemixButtonStyler minWidth(double value) {
    return constraints(BoxConstraintsMix.minWidth(value));
  }

  RemixButtonStyler maxWidth(double value) {
    return constraints(BoxConstraintsMix.maxWidth(value));
  }

  RemixButtonStyler minHeight(double value) {
    return constraints(BoxConstraintsMix.minHeight(value));
  }

  RemixButtonStyler maxHeight(double value) {
    return constraints(BoxConstraintsMix.maxHeight(value));
  }

  RemixButtonStyler size(double width, double height) {
    return constraintsOnly(width: width, height: height);
  }

  RemixButtonStyler minimumSize(Size value) {
    return constraintsOnly(minWidth: value.width, minHeight: value.height);
  }

  RemixButtonStyler fixedSize(Size value) {
    return constraintsOnly(
      minWidth: value.width,
      maxWidth: value.width,
      minHeight: value.height,
      maxHeight: value.height,
    );
  }

  RemixButtonStyler maximumSize(Size value) {
    return constraintsOnly(maxWidth: value.width, maxHeight: value.height);
  }

  RemixButtonStyler flex(FlexStyler value) {
    return container(FlexBoxStyler().flex(value));
  }

  RemixButtonStyler direction(Axis value) {
    return container(FlexBoxStyler(direction: value));
  }

  RemixButtonStyler mainAxisAlignment(MainAxisAlignment value) {
    return container(FlexBoxStyler(mainAxisAlignment: value));
  }

  RemixButtonStyler crossAxisAlignment(CrossAxisAlignment value) {
    return container(FlexBoxStyler(crossAxisAlignment: value));
  }

  RemixButtonStyler mainAxisSize(MainAxisSize value) {
    return container(FlexBoxStyler(mainAxisSize: value));
  }

  RemixButtonStyler verticalDirection(VerticalDirection value) {
    return container(FlexBoxStyler(verticalDirection: value));
  }

  RemixButtonStyler textDirection(TextDirection value) {
    return container(FlexBoxStyler(textDirection: value));
  }

  RemixButtonStyler textBaseline(TextBaseline value) {
    return container(FlexBoxStyler(textBaseline: value));
  }

  RemixButtonStyler spacing(double value) {
    return container(FlexBoxStyler(spacing: value));
  }

  RemixButtonStyler row() {
    return direction(.horizontal);
  }

  RemixButtonStyler column() {
    return direction(.vertical);
  }

  RemixButtonStyler transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return container(
      FlexBoxStyler(transform: value, transformAlignment: alignment),
    );
  }

  RemixButtonStyler rotate(double radians, {Alignment alignment = .center}) {
    return wrap(.rotate(radians: radians, alignment: alignment));
  }

  RemixButtonStyler scale(double value, {Alignment alignment = .center}) {
    return transform(
      Matrix4.diagonal3Values(value, value, 1.0),
      alignment: alignment,
    );
  }

  RemixButtonStyler translate(double x, double y, [double z = 0.0]) {
    return transform(Matrix4.translationValues(x, y, z));
  }

  RemixButtonStyler skew(double skewX, double skewY) {
    final matrix = Matrix4.identity()
      ..setEntry(0, 1, skewX)
      ..setEntry(1, 0, skewY);

    return transform(matrix);
  }

  RemixButtonStyler transformReset() {
    return transform(Matrix4.identity());
  }
}

extension RemixButtonStyleDecorationHelpers on RemixButtonStyler {
  RemixButtonStyler color(Color value) {
    return decoration(BoxDecorationMix(color: value));
  }

  RemixButtonStyler backgroundColor(Color value) => color(value);

  RemixButtonStyler foregroundColor(Color value) {
    return label(.color(value)).icon(.color(value));
  }

  RemixButtonStyler border(BoxBorderMix value) {
    return decoration(BoxDecorationMix(border: value));
  }

  RemixButtonStyler borderTop({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) {
    return container(
      FlexBoxStyler().borderTop(
        color: color,
        width: width,
        style: style,
        strokeAlign: strokeAlign,
      ),
    );
  }

  RemixButtonStyler borderBottom({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) {
    return container(
      FlexBoxStyler().borderBottom(
        color: color,
        width: width,
        style: style,
        strokeAlign: strokeAlign,
      ),
    );
  }

  RemixButtonStyler borderLeft({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) {
    return container(
      FlexBoxStyler().borderLeft(
        color: color,
        width: width,
        style: style,
        strokeAlign: strokeAlign,
      ),
    );
  }

  RemixButtonStyler borderRight({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) {
    return container(
      FlexBoxStyler().borderRight(
        color: color,
        width: width,
        style: style,
        strokeAlign: strokeAlign,
      ),
    );
  }

  RemixButtonStyler borderStart({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) {
    return container(
      FlexBoxStyler().borderStart(
        color: color,
        width: width,
        style: style,
        strokeAlign: strokeAlign,
      ),
    );
  }

  RemixButtonStyler borderEnd({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) {
    return container(
      FlexBoxStyler().borderEnd(
        color: color,
        width: width,
        style: style,
        strokeAlign: strokeAlign,
      ),
    );
  }

  RemixButtonStyler borderVertical({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) {
    return container(
      FlexBoxStyler().borderVertical(
        color: color,
        width: width,
        style: style,
        strokeAlign: strokeAlign,
      ),
    );
  }

  RemixButtonStyler borderHorizontal({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) {
    return container(
      FlexBoxStyler().borderHorizontal(
        color: color,
        width: width,
        style: style,
        strokeAlign: strokeAlign,
      ),
    );
  }

  RemixButtonStyler borderAll({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) {
    return border(
      BoxBorderMix.all(
        BorderSideMix(
          color: color,
          strokeAlign: strokeAlign,
          style: style,
          width: width,
        ),
      ),
    );
  }

  RemixButtonStyler borderRadius(BorderRadiusGeometryMix value) {
    return decoration(BoxDecorationMix(borderRadius: value));
  }

  RemixButtonStyler borderRadiusAll(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.all(radius));
  }

  RemixButtonStyler borderRadiusTop(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.top(radius));
  }

  RemixButtonStyler borderRadiusBottom(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.bottom(radius));
  }

  RemixButtonStyler borderRadiusLeft(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.left(radius));
  }

  RemixButtonStyler borderRadiusRight(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.right(radius));
  }

  RemixButtonStyler borderRadiusTopLeft(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.topLeft(radius));
  }

  RemixButtonStyler borderRadiusTopRight(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.topRight(radius));
  }

  RemixButtonStyler borderRadiusBottomLeft(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.bottomLeft(radius));
  }

  RemixButtonStyler borderRadiusBottomRight(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.bottomRight(radius));
  }

  RemixButtonStyler borderRadiusTopStart(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.topStart(radius));
  }

  RemixButtonStyler borderRadiusTopEnd(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.topEnd(radius));
  }

  RemixButtonStyler borderRadiusBottomStart(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.bottomStart(radius));
  }

  RemixButtonStyler borderRadiusBottomEnd(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.bottomEnd(radius));
  }

  RemixButtonStyler borderRounded(double radius) {
    return borderRadius(BorderRadiusGeometryMix.circular(radius));
  }

  RemixButtonStyler borderRoundedTop(double radius) {
    return borderRadius(BorderRadiusGeometryMix.top(.circular(radius)));
  }

  RemixButtonStyler borderRoundedBottom(double radius) {
    return borderRadius(BorderRadiusGeometryMix.bottom(.circular(radius)));
  }

  RemixButtonStyler borderRoundedLeft(double radius) {
    return borderRadius(BorderRadiusGeometryMix.left(.circular(radius)));
  }

  RemixButtonStyler borderRoundedRight(double radius) {
    return borderRadius(BorderRadiusGeometryMix.right(.circular(radius)));
  }

  RemixButtonStyler borderRoundedTopLeft(double radius) {
    return borderRadius(BorderRadiusGeometryMix.topLeft(.circular(radius)));
  }

  RemixButtonStyler borderRoundedTopRight(double radius) {
    return borderRadius(BorderRadiusGeometryMix.topRight(.circular(radius)));
  }

  RemixButtonStyler borderRoundedBottomLeft(double radius) {
    return borderRadius(BorderRadiusGeometryMix.bottomLeft(.circular(radius)));
  }

  RemixButtonStyler borderRoundedBottomRight(double radius) {
    return borderRadius(BorderRadiusGeometryMix.bottomRight(.circular(radius)));
  }

  RemixButtonStyler borderRoundedTopStart(double radius) {
    return borderRadius(BorderRadiusGeometryMix.topStart(.circular(radius)));
  }

  RemixButtonStyler borderRoundedTopEnd(double radius) {
    return borderRadius(BorderRadiusGeometryMix.topEnd(.circular(radius)));
  }

  RemixButtonStyler borderRoundedBottomStart(double radius) {
    return borderRadius(BorderRadiusGeometryMix.bottomStart(.circular(radius)));
  }

  RemixButtonStyler borderRoundedBottomEnd(double radius) {
    return borderRadius(BorderRadiusGeometryMix.bottomEnd(.circular(radius)));
  }

  RemixButtonStyler shadow(BoxShadowMix value) {
    return decoration(BoxDecorationMix(boxShadow: [value]));
  }

  RemixButtonStyler shadows(List<BoxShadowMix> value) {
    return decoration(BoxDecorationMix(boxShadow: value));
  }

  RemixButtonStyler shadowOnly({
    Color? color,
    Offset? offset,
    double? blurRadius,
    double? spreadRadius,
  }) {
    return container(
      FlexBoxStyler().shadowOnly(
        color: color,
        offset: offset,
        blurRadius: blurRadius,
        spreadRadius: spreadRadius,
      ),
    );
  }

  RemixButtonStyler boxShadows(List<BoxShadowMix> value) {
    return shadows(value);
  }

  RemixButtonStyler elevation(ElevationShadow value) {
    return container(FlexBoxStyler().elevation(value));
  }

  RemixButtonStyler boxElevation(ElevationShadow value) {
    return elevation(value);
  }

  RemixButtonStyler gradient(GradientMix value) {
    return container(FlexBoxStyler().gradient(value));
  }

  RemixButtonStyler image(DecorationImageMix value) {
    return container(FlexBoxStyler().image(value));
  }

  RemixButtonStyler shape(ShapeBorderMix value) {
    return decoration(ShapeDecorationMix(shape: value));
  }

  RemixButtonStyler shapeCircle({BorderSideMix? side}) {
    return shape(CircleBorderMix(side: side));
  }

  RemixButtonStyler shapeStadium({BorderSideMix? side}) {
    return shape(StadiumBorderMix(side: side));
  }

  RemixButtonStyler shapeRoundedRectangle({
    BorderSideMix? side,
    BorderRadiusMix? borderRadius,
  }) {
    return shape(
      RoundedRectangleBorderMix(borderRadius: borderRadius, side: side),
    );
  }

  RemixButtonStyler shapeBeveledRectangle({
    BorderSideMix? side,
    BorderRadiusMix? borderRadius,
  }) {
    return shape(
      BeveledRectangleBorderMix(borderRadius: borderRadius, side: side),
    );
  }

  RemixButtonStyler shapeContinuousRectangle({
    BorderSideMix? side,
    BorderRadiusMix? borderRadius,
  }) {
    return shape(
      ContinuousRectangleBorderMix(borderRadius: borderRadius, side: side),
    );
  }

  RemixButtonStyler shapeStar({
    BorderSideMix? side,
    double? points,
    double? innerRadiusRatio,
    double? pointRounding,
    double? valleyRounding,
    double? rotation,
    double? squash,
  }) {
    return shape(
      StarBorderMix(
        side: side,
        points: points,
        innerRadiusRatio: innerRadiusRatio,
        pointRounding: pointRounding,
        valleyRounding: valleyRounding,
        rotation: rotation,
        squash: squash,
      ),
    );
  }

  RemixButtonStyler shapeLinear({
    BorderSideMix? side,
    LinearBorderEdgeMix? start,
    LinearBorderEdgeMix? end,
    LinearBorderEdgeMix? top,
    LinearBorderEdgeMix? bottom,
  }) {
    return shape(
      LinearBorderMix(
        side: side,
        start: start,
        end: end,
        top: top,
        bottom: bottom,
      ),
    );
  }

  RemixButtonStyler shapeSuperellipse({
    BorderSideMix? side,
    BorderRadiusMix? borderRadius,
  }) {
    return shape(
      RoundedSuperellipseBorderMix(borderRadius: borderRadius, side: side),
    );
  }

  RemixButtonStyler backgroundImage(
    ImageProvider image, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) {
    return container(
      FlexBoxStyler().backgroundImage(
        image,
        fit: fit,
        alignment: alignment,
        repeat: repeat,
      ),
    );
  }

  RemixButtonStyler backgroundImageUrl(
    String url, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) {
    return backgroundImage(
      NetworkImage(url),
      fit: fit,
      alignment: alignment,
      repeat: repeat,
    );
  }

  RemixButtonStyler backgroundImageAsset(
    String path, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) {
    return backgroundImage(
      AssetImage(path),
      fit: fit,
      alignment: alignment,
      repeat: repeat,
    );
  }

  RemixButtonStyler foregroundLinearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
  }) {
    return container(
      FlexBoxStyler().foregroundLinearGradient(
        colors: colors,
        stops: stops,
        begin: begin,
        end: end,
        tileMode: tileMode,
      ),
    );
  }

  RemixButtonStyler foregroundRadialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
  }) {
    return container(
      FlexBoxStyler().foregroundRadialGradient(
        colors: colors,
        stops: stops,
        center: center,
        radius: radius,
        focal: focal,
        focalRadius: focalRadius,
        tileMode: tileMode,
      ),
    );
  }

  RemixButtonStyler foregroundSweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
  }) {
    return container(
      FlexBoxStyler().foregroundSweepGradient(
        colors: colors,
        stops: stops,
        center: center,
        startAngle: startAngle,
        endAngle: endAngle,
        tileMode: tileMode,
      ),
    );
  }

  RemixButtonStyler linearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
  }) {
    return container(
      FlexBoxStyler().linearGradient(
        colors: colors,
        stops: stops,
        begin: begin,
        end: end,
        tileMode: tileMode,
      ),
    );
  }

  RemixButtonStyler radialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
  }) {
    return container(
      FlexBoxStyler().radialGradient(
        colors: colors,
        stops: stops,
        center: center,
        radius: radius,
        focal: focal,
        focalRadius: focalRadius,
        tileMode: tileMode,
      ),
    );
  }

  RemixButtonStyler sweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
  }) {
    return container(
      FlexBoxStyler().sweepGradient(
        colors: colors,
        stops: stops,
        center: center,
        startAngle: startAngle,
        endAngle: endAngle,
        tileMode: tileMode,
      ),
    );
  }
}
