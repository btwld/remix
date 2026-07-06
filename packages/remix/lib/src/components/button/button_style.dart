part of 'button.dart';

/// Style builder for [RemixButton].
///
/// Use this class to style the button container, label, icons, and loading
/// spinner. It supports Mix variants and widget state variants for focused,
/// hovered, pressed, disabled, and loading states.
@MixableStyler()
class RemixButtonStyle extends MixStyler<RemixButtonStyle, RemixButtonSpec>
    with
        LabelStyleMixin<RemixButtonStyle>,
        IconStyleMixin<RemixButtonStyle>,
        SpinnerStyleMixin<RemixButtonStyle>,
        Diagnosticable,
        _$RemixButtonStyleMixin {
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
  @MixableField(setterType: RemixSpinnerStyle)
  final Prop<StyleSpec<RemixSpinnerSpec>>? $spinner;

  /// Alignment used when rendering an icon next to the label.
  final Prop<IconAlignment>? $iconAlignment;

  /// Creates a button style from raw Mix properties.
  const RemixButtonStyle.create({
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
  RemixButtonStyle({
    FlexBoxStyler? container,
    TextStyler? label,
    IconStyler? icon,
    RemixSpinnerStyle? spinner,
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
  factory RemixButtonStyle.iconAlignment(IconAlignment value) {
    return RemixButtonStyle().iconAlignment(value);
  }

  /// Sets the widget modifier.
  RemixButtonStyle modifier(WidgetModifierConfig value) {
    return merge(RemixButtonStyle(modifier: value));
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
      style: this,
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
    );
  }
}

extension RemixButtonStyleContainerHelpers on RemixButtonStyle {
  RemixButtonStyle padding(EdgeInsetsGeometryMix value) {
    return container(FlexBoxStyler(padding: value));
  }

  RemixButtonStyle paddingTop(double value) {
    return padding(EdgeInsetsGeometryMix.top(value));
  }

  RemixButtonStyle paddingBottom(double value) {
    return padding(EdgeInsetsGeometryMix.bottom(value));
  }

  RemixButtonStyle paddingLeft(double value) {
    return padding(EdgeInsetsGeometryMix.left(value));
  }

  RemixButtonStyle paddingRight(double value) {
    return padding(EdgeInsetsGeometryMix.right(value));
  }

  RemixButtonStyle paddingX(double value) {
    return padding(EdgeInsetsGeometryMix.horizontal(value));
  }

  RemixButtonStyle paddingY(double value) {
    return padding(EdgeInsetsGeometryMix.vertical(value));
  }

  RemixButtonStyle paddingAll(double value) {
    return padding(EdgeInsetsGeometryMix.all(value));
  }

  RemixButtonStyle paddingStart(double value) {
    return padding(EdgeInsetsGeometryMix.start(value));
  }

  RemixButtonStyle paddingEnd(double value) {
    return padding(EdgeInsetsGeometryMix.end(value));
  }

  RemixButtonStyle paddingOnly({
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

  RemixButtonStyle margin(EdgeInsetsGeometryMix value) {
    return container(FlexBoxStyler(margin: value));
  }

  RemixButtonStyle marginTop(double value) {
    return margin(EdgeInsetsGeometryMix.top(value));
  }

  RemixButtonStyle marginBottom(double value) {
    return margin(EdgeInsetsGeometryMix.bottom(value));
  }

  RemixButtonStyle marginLeft(double value) {
    return margin(EdgeInsetsGeometryMix.left(value));
  }

  RemixButtonStyle marginRight(double value) {
    return margin(EdgeInsetsGeometryMix.right(value));
  }

  RemixButtonStyle marginX(double value) {
    return margin(EdgeInsetsGeometryMix.horizontal(value));
  }

  RemixButtonStyle marginY(double value) {
    return margin(EdgeInsetsGeometryMix.vertical(value));
  }

  RemixButtonStyle marginAll(double value) {
    return margin(EdgeInsetsGeometryMix.all(value));
  }

  RemixButtonStyle marginStart(double value) {
    return margin(EdgeInsetsGeometryMix.start(value));
  }

  RemixButtonStyle marginEnd(double value) {
    return margin(EdgeInsetsGeometryMix.end(value));
  }

  RemixButtonStyle marginOnly({
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

  RemixButtonStyle decoration(DecorationMix value) {
    return container(FlexBoxStyler(decoration: value));
  }

  RemixButtonStyle foregroundDecoration(DecorationMix value) {
    return container(FlexBoxStyler(foregroundDecoration: value));
  }

  RemixButtonStyle alignment(AlignmentGeometry value) {
    return container(FlexBoxStyler(alignment: value));
  }

  RemixButtonStyle constraints(BoxConstraintsMix value) {
    return container(FlexBoxStyler(constraints: value));
  }

  RemixButtonStyle constraintsOnly({
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

  RemixButtonStyle width(double value) {
    return constraints(BoxConstraintsMix.width(value));
  }

  RemixButtonStyle height(double value) {
    return constraints(BoxConstraintsMix.height(value));
  }

  RemixButtonStyle minWidth(double value) {
    return constraints(BoxConstraintsMix.minWidth(value));
  }

  RemixButtonStyle maxWidth(double value) {
    return constraints(BoxConstraintsMix.maxWidth(value));
  }

  RemixButtonStyle minHeight(double value) {
    return constraints(BoxConstraintsMix.minHeight(value));
  }

  RemixButtonStyle maxHeight(double value) {
    return constraints(BoxConstraintsMix.maxHeight(value));
  }

  RemixButtonStyle size(double width, double height) {
    return constraintsOnly(width: width, height: height);
  }

  RemixButtonStyle minimumSize(Size value) {
    return constraintsOnly(minWidth: value.width, minHeight: value.height);
  }

  RemixButtonStyle fixedSize(Size value) {
    return constraintsOnly(
      minWidth: value.width,
      maxWidth: value.width,
      minHeight: value.height,
      maxHeight: value.height,
    );
  }

  RemixButtonStyle maximumSize(Size value) {
    return constraintsOnly(maxWidth: value.width, maxHeight: value.height);
  }

  RemixButtonStyle flex(FlexStyler value) {
    return container(FlexBoxStyler().flex(value));
  }

  RemixButtonStyle direction(Axis value) {
    return container(FlexBoxStyler(direction: value));
  }

  RemixButtonStyle mainAxisAlignment(MainAxisAlignment value) {
    return container(FlexBoxStyler(mainAxisAlignment: value));
  }

  RemixButtonStyle crossAxisAlignment(CrossAxisAlignment value) {
    return container(FlexBoxStyler(crossAxisAlignment: value));
  }

  RemixButtonStyle mainAxisSize(MainAxisSize value) {
    return container(FlexBoxStyler(mainAxisSize: value));
  }

  RemixButtonStyle verticalDirection(VerticalDirection value) {
    return container(FlexBoxStyler(verticalDirection: value));
  }

  RemixButtonStyle textDirection(TextDirection value) {
    return container(FlexBoxStyler(textDirection: value));
  }

  RemixButtonStyle textBaseline(TextBaseline value) {
    return container(FlexBoxStyler(textBaseline: value));
  }

  RemixButtonStyle spacing(double value) {
    return container(FlexBoxStyler(spacing: value));
  }

  RemixButtonStyle row() {
    return direction(.horizontal);
  }

  RemixButtonStyle column() {
    return direction(.vertical);
  }

  RemixButtonStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return container(
      FlexBoxStyler(transform: value, transformAlignment: alignment),
    );
  }

  RemixButtonStyle rotate(
    double radians, {
    Alignment alignment = Alignment.center,
  }) {
    return wrap(
      WidgetModifierConfig.rotate(radians: radians, alignment: alignment),
    );
  }

  RemixButtonStyle scale(
    double value, {
    Alignment alignment = Alignment.center,
  }) {
    return transform(
      Matrix4.diagonal3Values(value, value, 1.0),
      alignment: alignment,
    );
  }

  RemixButtonStyle translate(double x, double y, [double z = 0.0]) {
    return transform(Matrix4.translationValues(x, y, z));
  }

  RemixButtonStyle skew(double skewX, double skewY) {
    final matrix = Matrix4.identity()
      ..setEntry(0, 1, skewX)
      ..setEntry(1, 0, skewY);

    return transform(matrix);
  }

  RemixButtonStyle transformReset() {
    return transform(Matrix4.identity());
  }
}

extension RemixButtonStyleDecorationHelpers on RemixButtonStyle {
  RemixButtonStyle color(Color value) {
    return decoration(BoxDecorationMix(color: value));
  }

  RemixButtonStyle backgroundColor(Color value) => color(value);

  RemixButtonStyle foregroundColor(Color value) {
    return label(.color(value)).icon(.color(value));
  }

  RemixButtonStyle border(BoxBorderMix value) {
    return decoration(BoxDecorationMix(border: value));
  }

  RemixButtonStyle borderTop({
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

  RemixButtonStyle borderBottom({
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

  RemixButtonStyle borderLeft({
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

  RemixButtonStyle borderRight({
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

  RemixButtonStyle borderStart({
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

  RemixButtonStyle borderEnd({
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

  RemixButtonStyle borderVertical({
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

  RemixButtonStyle borderHorizontal({
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

  RemixButtonStyle borderAll({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) {
    return border(
      BoxBorderMix.all(
        BorderSideMix(
          color: color,
          width: width,
          style: style,
          strokeAlign: strokeAlign,
        ),
      ),
    );
  }

  RemixButtonStyle borderRadius(BorderRadiusGeometryMix value) {
    return decoration(BoxDecorationMix(borderRadius: value));
  }

  RemixButtonStyle borderRadiusAll(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.all(radius));
  }

  RemixButtonStyle borderRadiusTop(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.top(radius));
  }

  RemixButtonStyle borderRadiusBottom(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.bottom(radius));
  }

  RemixButtonStyle borderRadiusLeft(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.left(radius));
  }

  RemixButtonStyle borderRadiusRight(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.right(radius));
  }

  RemixButtonStyle borderRadiusTopLeft(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.topLeft(radius));
  }

  RemixButtonStyle borderRadiusTopRight(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.topRight(radius));
  }

  RemixButtonStyle borderRadiusBottomLeft(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.bottomLeft(radius));
  }

  RemixButtonStyle borderRadiusBottomRight(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.bottomRight(radius));
  }

  RemixButtonStyle borderRadiusTopStart(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.topStart(radius));
  }

  RemixButtonStyle borderRadiusTopEnd(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.topEnd(radius));
  }

  RemixButtonStyle borderRadiusBottomStart(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.bottomStart(radius));
  }

  RemixButtonStyle borderRadiusBottomEnd(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.bottomEnd(radius));
  }

  RemixButtonStyle borderRounded(double radius) {
    return borderRadius(BorderRadiusGeometryMix.circular(radius));
  }

  RemixButtonStyle borderRoundedTop(double radius) {
    return borderRadius(BorderRadiusGeometryMix.top(.circular(radius)));
  }

  RemixButtonStyle borderRoundedBottom(double radius) {
    return borderRadius(BorderRadiusGeometryMix.bottom(.circular(radius)));
  }

  RemixButtonStyle borderRoundedLeft(double radius) {
    return borderRadius(BorderRadiusGeometryMix.left(.circular(radius)));
  }

  RemixButtonStyle borderRoundedRight(double radius) {
    return borderRadius(BorderRadiusGeometryMix.right(.circular(radius)));
  }

  RemixButtonStyle borderRoundedTopLeft(double radius) {
    return borderRadius(BorderRadiusGeometryMix.topLeft(.circular(radius)));
  }

  RemixButtonStyle borderRoundedTopRight(double radius) {
    return borderRadius(BorderRadiusGeometryMix.topRight(.circular(radius)));
  }

  RemixButtonStyle borderRoundedBottomLeft(double radius) {
    return borderRadius(BorderRadiusGeometryMix.bottomLeft(.circular(radius)));
  }

  RemixButtonStyle borderRoundedBottomRight(double radius) {
    return borderRadius(BorderRadiusGeometryMix.bottomRight(.circular(radius)));
  }

  RemixButtonStyle borderRoundedTopStart(double radius) {
    return borderRadius(BorderRadiusGeometryMix.topStart(.circular(radius)));
  }

  RemixButtonStyle borderRoundedTopEnd(double radius) {
    return borderRadius(BorderRadiusGeometryMix.topEnd(.circular(radius)));
  }

  RemixButtonStyle borderRoundedBottomStart(double radius) {
    return borderRadius(BorderRadiusGeometryMix.bottomStart(.circular(radius)));
  }

  RemixButtonStyle borderRoundedBottomEnd(double radius) {
    return borderRadius(BorderRadiusGeometryMix.bottomEnd(.circular(radius)));
  }

  RemixButtonStyle shadow(BoxShadowMix value) {
    return decoration(BoxDecorationMix(boxShadow: [value]));
  }

  RemixButtonStyle shadows(List<BoxShadowMix> value) {
    return decoration(BoxDecorationMix(boxShadow: value));
  }

  RemixButtonStyle shadowOnly({
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

  RemixButtonStyle boxShadows(List<BoxShadowMix> value) {
    return shadows(value);
  }

  RemixButtonStyle elevation(ElevationShadow value) {
    return container(FlexBoxStyler().elevation(value));
  }

  RemixButtonStyle boxElevation(ElevationShadow value) {
    return elevation(value);
  }

  RemixButtonStyle gradient(GradientMix value) {
    return container(FlexBoxStyler().gradient(value));
  }

  RemixButtonStyle image(DecorationImageMix value) {
    return container(FlexBoxStyler().image(value));
  }

  RemixButtonStyle shape(ShapeBorderMix value) {
    return decoration(ShapeDecorationMix(shape: value));
  }

  RemixButtonStyle shapeCircle({BorderSideMix? side}) {
    return shape(CircleBorderMix(side: side));
  }

  RemixButtonStyle shapeStadium({BorderSideMix? side}) {
    return shape(StadiumBorderMix(side: side));
  }

  RemixButtonStyle shapeRoundedRectangle({
    BorderSideMix? side,
    BorderRadiusMix? borderRadius,
  }) {
    return shape(
      RoundedRectangleBorderMix(borderRadius: borderRadius, side: side),
    );
  }

  RemixButtonStyle shapeBeveledRectangle({
    BorderSideMix? side,
    BorderRadiusMix? borderRadius,
  }) {
    return shape(
      BeveledRectangleBorderMix(borderRadius: borderRadius, side: side),
    );
  }

  RemixButtonStyle shapeContinuousRectangle({
    BorderSideMix? side,
    BorderRadiusMix? borderRadius,
  }) {
    return shape(
      ContinuousRectangleBorderMix(borderRadius: borderRadius, side: side),
    );
  }

  RemixButtonStyle shapeStar({
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

  RemixButtonStyle shapeLinear({
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

  RemixButtonStyle shapeSuperellipse({
    BorderSideMix? side,
    BorderRadiusMix? borderRadius,
  }) {
    return shape(
      RoundedSuperellipseBorderMix(borderRadius: borderRadius, side: side),
    );
  }

  RemixButtonStyle backgroundImage(
    ImageProvider image, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = ImageRepeat.noRepeat,
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

  RemixButtonStyle backgroundImageUrl(
    String url, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = ImageRepeat.noRepeat,
  }) {
    return backgroundImage(
      NetworkImage(url),
      fit: fit,
      alignment: alignment,
      repeat: repeat,
    );
  }

  RemixButtonStyle backgroundImageAsset(
    String path, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = ImageRepeat.noRepeat,
  }) {
    return backgroundImage(
      AssetImage(path),
      fit: fit,
      alignment: alignment,
      repeat: repeat,
    );
  }

  RemixButtonStyle foregroundLinearGradient({
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

  RemixButtonStyle foregroundRadialGradient({
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

  RemixButtonStyle foregroundSweepGradient({
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

  RemixButtonStyle linearGradient({
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

  RemixButtonStyle radialGradient({
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

  RemixButtonStyle sweepGradient({
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
