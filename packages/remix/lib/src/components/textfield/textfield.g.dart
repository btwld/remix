// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'textfield.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixTextFieldSpec implements Spec<RemixTextFieldSpec>, Diagnosticable {
  StyleSpec<TextSpec> get text;
  StyleSpec<TextSpec> get hintText;
  TextAlign? get textAlign;
  double? get cursorWidth;
  double? get cursorHeight;
  Radius? get cursorRadius;
  Color? get cursorColor;
  Offset? get cursorOffset;
  BoxHeightStyle? get selectionHeightStyle;
  BoxWidthStyle? get selectionWidthStyle;
  EdgeInsets? get scrollPadding;
  Brightness? get keyboardAppearance;
  bool? get cursorOpacityAnimates;
  double? get spacing;
  StyleSpec<FlexBoxSpec> get container;
  StyleSpec<TextSpec> get helperText;
  StyleSpec<TextSpec> get label;

  @override
  Type get type => RemixTextFieldSpec;

  @override
  RemixTextFieldSpec copyWith({
    StyleSpec<TextSpec>? text,
    StyleSpec<TextSpec>? hintText,
    TextAlign? textAlign,
    double? cursorWidth,
    double? cursorHeight,
    Radius? cursorRadius,
    Color? cursorColor,
    Offset? cursorOffset,
    BoxHeightStyle? selectionHeightStyle,
    BoxWidthStyle? selectionWidthStyle,
    EdgeInsets? scrollPadding,
    Brightness? keyboardAppearance,
    bool? cursorOpacityAnimates,
    double? spacing,
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? helperText,
    StyleSpec<TextSpec>? label,
  }) {
    return RemixTextFieldSpec(
      text: text ?? this.text,
      hintText: hintText ?? this.hintText,
      textAlign: textAlign ?? this.textAlign,
      cursorWidth: cursorWidth ?? this.cursorWidth,
      cursorHeight: cursorHeight ?? this.cursorHeight,
      cursorRadius: cursorRadius ?? this.cursorRadius,
      cursorColor: cursorColor ?? this.cursorColor,
      cursorOffset: cursorOffset ?? this.cursorOffset,
      selectionHeightStyle: selectionHeightStyle ?? this.selectionHeightStyle,
      selectionWidthStyle: selectionWidthStyle ?? this.selectionWidthStyle,
      scrollPadding: scrollPadding ?? this.scrollPadding,
      keyboardAppearance: keyboardAppearance ?? this.keyboardAppearance,
      cursorOpacityAnimates:
          cursorOpacityAnimates ?? this.cursorOpacityAnimates,
      spacing: spacing ?? this.spacing,
      container: container ?? this.container,
      helperText: helperText ?? this.helperText,
      label: label ?? this.label,
    );
  }

  @override
  RemixTextFieldSpec lerp(RemixTextFieldSpec? other, double t) {
    return RemixTextFieldSpec(
      text: text.lerp(other?.text, t),
      hintText: hintText.lerp(other?.hintText, t),
      textAlign: MixOps.lerpSnap(textAlign, other?.textAlign, t),
      cursorWidth: MixOps.lerp(cursorWidth, other?.cursorWidth, t),
      cursorHeight: MixOps.lerp(cursorHeight, other?.cursorHeight, t),
      cursorRadius: MixOps.lerpSnap(cursorRadius, other?.cursorRadius, t),
      cursorColor: MixOps.lerp(cursorColor, other?.cursorColor, t),
      cursorOffset: MixOps.lerp(cursorOffset, other?.cursorOffset, t),
      selectionHeightStyle: MixOps.lerpSnap(
        selectionHeightStyle,
        other?.selectionHeightStyle,
        t,
      ),
      selectionWidthStyle: MixOps.lerpSnap(
        selectionWidthStyle,
        other?.selectionWidthStyle,
        t,
      ),
      scrollPadding: MixOps.lerp(scrollPadding, other?.scrollPadding, t),
      keyboardAppearance: MixOps.lerpSnap(
        keyboardAppearance,
        other?.keyboardAppearance,
        t,
      ),
      cursorOpacityAnimates: MixOps.lerpSnap(
        cursorOpacityAnimates,
        other?.cursorOpacityAnimates,
        t,
      ),
      spacing: MixOps.lerp(spacing, other?.spacing, t),
      container: container.lerp(other?.container, t),
      helperText: helperText.lerp(other?.helperText, t),
      label: label.lerp(other?.label, t),
    );
  }

  @override
  List<Object?> get props => [
    text,
    hintText,
    textAlign,
    cursorWidth,
    cursorHeight,
    cursorRadius,
    cursorColor,
    cursorOffset,
    selectionHeightStyle,
    selectionWidthStyle,
    scrollPadding,
    keyboardAppearance,
    cursorOpacityAnimates,
    spacing,
    container,
    helperText,
    label,
  ];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RemixTextFieldSpec &&
            runtimeType == other.runtimeType &&
            propsEquals(props, other.props);
  }

  @override
  int get hashCode => propsHash(runtimeType, props);

  @override
  bool get stringify => true;

  @override
  Map<String, String> getDiff(Equatable other) {
    if (this == other) return const {};

    return propsDiff(props, other.props);
  }

  @override
  String toStringShort() => '$runtimeType';

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      toDiagnosticsNode(
        style: DiagnosticsTreeStyle.singleLine,
      ).toString(minLevel: minLevel);

  @override
  DiagnosticsNode toDiagnosticsNode({
    String? name,
    DiagnosticsTreeStyle? style,
  }) =>
      DiagnosticableNode<Diagnosticable>(name: name, value: this, style: style);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('text', text))
      ..add(DiagnosticsProperty('hintText', hintText))
      ..add(EnumProperty<TextAlign>('textAlign', textAlign))
      ..add(DoubleProperty('cursorWidth', cursorWidth))
      ..add(DoubleProperty('cursorHeight', cursorHeight))
      ..add(DiagnosticsProperty('cursorRadius', cursorRadius))
      ..add(ColorProperty('cursorColor', cursorColor))
      ..add(DiagnosticsProperty('cursorOffset', cursorOffset))
      ..add(DiagnosticsProperty('selectionHeightStyle', selectionHeightStyle))
      ..add(DiagnosticsProperty('selectionWidthStyle', selectionWidthStyle))
      ..add(DiagnosticsProperty('scrollPadding', scrollPadding))
      ..add(DiagnosticsProperty('keyboardAppearance', keyboardAppearance))
      ..add(DiagnosticsProperty('cursorOpacityAnimates', cursorOpacityAnimates))
      ..add(DoubleProperty('spacing', spacing))
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('helperText', helperText))
      ..add(DiagnosticsProperty('label', label));
  }
}

@Deprecated(
  'Rename to `_\$RemixTextFieldSpec` and migrate the class declaration to `class RemixTextFieldSpec with _\$RemixTextFieldSpec`. The `_\$RemixTextFieldSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$RemixTextFieldSpecMethods = _$RemixTextFieldSpec; // ignore: unused_element

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// Creates a Fortal-themed [RemixTextFieldStyle].
class FortalTextField extends StatelessWidget {
  const FortalTextField({
    super.key,
    this.variant = .surface,
    this.size = .size2,
    this.controller,
    this.focusNode,
    this.label,
    this.hintText,
    this.helperText,
    this.error = false,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = .none,
    this.textDirection,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.maxLengthEnforcement,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onAppPrivateCommand,
    this.inputFormatters,
    this.showCursor,
    this.obscuringCharacter = '•',
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.dragStartBehavior = .start,
    this.enableInteractiveSelection = true,
    this.selectionControls,
    this.onTapOutside,
    this.onPressUpOutside,
    this.onTapAlwaysCalled = false,
    this.scrollController,
    this.scrollPhysics,
    this.autofillHints,
    this.contentInsertionConfiguration,
    this.clipBehavior = .hardEdge,
    this.restorationId,
    this.stylusHandwritingEnabled = true,
    this.enableIMEPersonalizedLearning = true,
    this.contextMenuBuilder,
    this.spellCheckConfiguration,
    this.magnifierConfiguration,
    this.canRequestFocus = true,
    this.ignorePointers,
    this.undoController,
    this.groupId = EditableText,
    this.leading,
    this.trailing,
    this.semanticLabel,
    this.semanticHint,
    this.excludeSemantics = false,
  });

  final FortalTextFieldVariant variant;

  final FortalTextFieldSize size;

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final String? label;

  final String? hintText;

  final String? helperText;

  final bool error;

  final TextInputType? keyboardType;

  final TextInputAction? textInputAction;

  final TextCapitalization textCapitalization;

  final TextDirection? textDirection;

  final bool obscureText;

  final bool enabled;

  final bool readOnly;

  final bool autofocus;

  final int? maxLines;

  final int? minLines;

  final bool expands;

  final int? maxLength;

  final MaxLengthEnforcement? maxLengthEnforcement;

  final ValueChanged<String>? onChanged;

  final VoidCallback? onEditingComplete;

  final ValueChanged<String>? onSubmitted;

  final AppPrivateCommandCallback? onAppPrivateCommand;

  final List<TextInputFormatter>? inputFormatters;

  final bool? showCursor;

  final String obscuringCharacter;

  final bool autocorrect;

  final bool enableSuggestions;

  final SmartDashesType? smartDashesType;

  final SmartQuotesType? smartQuotesType;

  final DragStartBehavior dragStartBehavior;

  final bool enableInteractiveSelection;

  final TextSelectionControls? selectionControls;

  final TapRegionCallback? onTapOutside;

  final TapRegionUpCallback? onPressUpOutside;

  final bool onTapAlwaysCalled;

  final ScrollController? scrollController;

  final ScrollPhysics? scrollPhysics;

  final Iterable<String>? autofillHints;

  final ContentInsertionConfiguration? contentInsertionConfiguration;

  final Clip clipBehavior;

  final String? restorationId;

  final bool stylusHandwritingEnabled;

  final bool enableIMEPersonalizedLearning;

  final EditableTextContextMenuBuilder? contextMenuBuilder;

  final SpellCheckConfiguration? spellCheckConfiguration;

  final TextMagnifierConfiguration? magnifierConfiguration;

  final bool canRequestFocus;

  final bool? ignorePointers;

  final UndoHistoryController? undoController;

  final Object groupId;

  final Widget? leading;

  final Widget? trailing;

  final String? semanticLabel;

  final String? semanticHint;

  final bool excludeSemantics;

  @override
  Widget build(BuildContext context) {
    return fortalTextFieldStyle(variant: this.variant, size: this.size).call(
      controller: this.controller,
      focusNode: this.focusNode,
      label: this.label,
      hintText: this.hintText,
      helperText: this.helperText,
      error: this.error,
      keyboardType: this.keyboardType,
      textInputAction: this.textInputAction,
      textCapitalization: this.textCapitalization,
      textDirection: this.textDirection,
      obscureText: this.obscureText,
      enabled: this.enabled,
      readOnly: this.readOnly,
      autofocus: this.autofocus,
      maxLines: this.maxLines,
      minLines: this.minLines,
      expands: this.expands,
      maxLength: this.maxLength,
      maxLengthEnforcement: this.maxLengthEnforcement,
      onChanged: this.onChanged,
      onEditingComplete: this.onEditingComplete,
      onSubmitted: this.onSubmitted,
      onAppPrivateCommand: this.onAppPrivateCommand,
      inputFormatters: this.inputFormatters,
      showCursor: this.showCursor,
      obscuringCharacter: this.obscuringCharacter,
      autocorrect: this.autocorrect,
      enableSuggestions: this.enableSuggestions,
      smartDashesType: this.smartDashesType,
      smartQuotesType: this.smartQuotesType,
      dragStartBehavior: this.dragStartBehavior,
      enableInteractiveSelection: this.enableInteractiveSelection,
      selectionControls: this.selectionControls,
      onTapOutside: this.onTapOutside,
      onPressUpOutside: this.onPressUpOutside,
      onTapAlwaysCalled: this.onTapAlwaysCalled,
      scrollController: this.scrollController,
      scrollPhysics: this.scrollPhysics,
      autofillHints: this.autofillHints,
      contentInsertionConfiguration: this.contentInsertionConfiguration,
      clipBehavior: this.clipBehavior,
      restorationId: this.restorationId,
      stylusHandwritingEnabled: this.stylusHandwritingEnabled,
      enableIMEPersonalizedLearning: this.enableIMEPersonalizedLearning,
      contextMenuBuilder: this.contextMenuBuilder,
      spellCheckConfiguration: this.spellCheckConfiguration,
      magnifierConfiguration: this.magnifierConfiguration,
      canRequestFocus: this.canRequestFocus,
      ignorePointers: this.ignorePointers,
      undoController: this.undoController,
      groupId: this.groupId,
      leading: this.leading,
      trailing: this.trailing,
      semanticLabel: this.semanticLabel,
      semanticHint: this.semanticHint,
      excludeSemantics: this.excludeSemantics,
    );
  }
}

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$RemixTextFieldStyleMixin on Style<RemixTextFieldSpec>, Diagnosticable {
  Prop<StyleSpec<TextSpec>>? get $text;
  Prop<StyleSpec<TextSpec>>? get $hintText;
  Prop<TextAlign>? get $textAlign;
  Prop<double>? get $cursorWidth;
  Prop<double>? get $cursorHeight;
  Prop<Radius>? get $cursorRadius;
  Prop<Color>? get $cursorColor;
  Prop<Offset>? get $cursorOffset;
  Prop<bool>? get $cursorOpacityAnimates;
  Prop<BoxHeightStyle>? get $selectionHeightStyle;
  Prop<BoxWidthStyle>? get $selectionWidthStyle;
  Prop<EdgeInsets>? get $scrollPadding;
  Prop<Brightness>? get $keyboardAppearance;
  Prop<double>? get $spacing;
  Prop<StyleSpec<FlexBoxSpec>>? get $container;
  Prop<StyleSpec<TextSpec>>? get $helperText;
  Prop<StyleSpec<TextSpec>>? get $label;

  /// Sets the text.
  RemixTextFieldStyle text(TextStyler value) {
    return merge(RemixTextFieldStyle(text: value));
  }

  /// Sets the hintText.
  RemixTextFieldStyle hintText(TextStyler value) {
    return merge(RemixTextFieldStyle(hintText: value));
  }

  /// Sets the textAlign.
  RemixTextFieldStyle textAlign(TextAlign value) {
    return merge(RemixTextFieldStyle(textAlign: value));
  }

  /// Sets the cursorWidth.
  RemixTextFieldStyle cursorWidth(double value) {
    return merge(RemixTextFieldStyle(cursorWidth: value));
  }

  /// Sets the cursorHeight.
  RemixTextFieldStyle cursorHeight(double value) {
    return merge(RemixTextFieldStyle(cursorHeight: value));
  }

  /// Sets the cursorRadius.
  RemixTextFieldStyle cursorRadius(Radius value) {
    return merge(RemixTextFieldStyle(cursorRadius: value));
  }

  /// Sets the cursorColor.
  RemixTextFieldStyle cursorColor(Color value) {
    return merge(RemixTextFieldStyle(cursorColor: value));
  }

  /// Sets the cursorOffset.
  RemixTextFieldStyle cursorOffset(Offset value) {
    return merge(RemixTextFieldStyle(cursorOffset: value));
  }

  /// Sets the cursorOpacityAnimates.
  RemixTextFieldStyle cursorOpacityAnimates(bool value) {
    return merge(RemixTextFieldStyle(cursorOpacityAnimates: value));
  }

  /// Sets the selectionHeightStyle.
  RemixTextFieldStyle selectionHeightStyle(BoxHeightStyle value) {
    return merge(RemixTextFieldStyle(selectionHeightStyle: value));
  }

  /// Sets the selectionWidthStyle.
  RemixTextFieldStyle selectionWidthStyle(BoxWidthStyle value) {
    return merge(RemixTextFieldStyle(selectionWidthStyle: value));
  }

  /// Sets the scrollPadding.
  RemixTextFieldStyle scrollPadding(EdgeInsets value) {
    return merge(RemixTextFieldStyle(scrollPadding: value));
  }

  /// Sets the keyboardAppearance.
  RemixTextFieldStyle keyboardAppearance(Brightness value) {
    return merge(RemixTextFieldStyle(keyboardAppearance: value));
  }

  /// Sets the spacing.
  RemixTextFieldStyle spacing(double value) {
    return merge(RemixTextFieldStyle(spacing: value));
  }

  /// Sets the container.
  RemixTextFieldStyle container(FlexBoxStyler value) {
    return merge(RemixTextFieldStyle(container: value));
  }

  /// Sets the helperText.
  RemixTextFieldStyle helperText(TextStyler value) {
    return merge(RemixTextFieldStyle(helperText: value));
  }

  /// Sets the label.
  RemixTextFieldStyle label(TextStyler value) {
    return merge(RemixTextFieldStyle(label: value));
  }

  /// Sets the animation configuration.
  RemixTextFieldStyle animate(AnimationConfig value) {
    return merge(RemixTextFieldStyle(animation: value));
  }

  /// Sets the style variants.
  RemixTextFieldStyle variants(List<VariantStyle<RemixTextFieldSpec>> value) {
    return merge(RemixTextFieldStyle(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixTextFieldStyle wrap(WidgetModifierConfig value) {
    return merge(RemixTextFieldStyle(modifier: value));
  }

  /// Sets the widget modifier.
  RemixTextFieldStyle modifier(WidgetModifierConfig value) {
    return merge(RemixTextFieldStyle(modifier: value));
  }

  /// Merges with another [RemixTextFieldStyle].
  @override
  RemixTextFieldStyle merge(RemixTextFieldStyle? other) {
    return RemixTextFieldStyle.create(
      text: MixOps.merge($text, other?.$text),
      hintText: MixOps.merge($hintText, other?.$hintText),
      textAlign: MixOps.merge($textAlign, other?.$textAlign),
      cursorWidth: MixOps.merge($cursorWidth, other?.$cursorWidth),
      cursorHeight: MixOps.merge($cursorHeight, other?.$cursorHeight),
      cursorRadius: MixOps.merge($cursorRadius, other?.$cursorRadius),
      cursorColor: MixOps.merge($cursorColor, other?.$cursorColor),
      cursorOffset: MixOps.merge($cursorOffset, other?.$cursorOffset),
      cursorOpacityAnimates: MixOps.merge(
        $cursorOpacityAnimates,
        other?.$cursorOpacityAnimates,
      ),
      selectionHeightStyle: MixOps.merge(
        $selectionHeightStyle,
        other?.$selectionHeightStyle,
      ),
      selectionWidthStyle: MixOps.merge(
        $selectionWidthStyle,
        other?.$selectionWidthStyle,
      ),
      scrollPadding: MixOps.merge($scrollPadding, other?.$scrollPadding),
      keyboardAppearance: MixOps.merge(
        $keyboardAppearance,
        other?.$keyboardAppearance,
      ),
      spacing: MixOps.merge($spacing, other?.$spacing),
      container: MixOps.merge($container, other?.$container),
      helperText: MixOps.merge($helperText, other?.$helperText),
      label: MixOps.merge($label, other?.$label),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixTextFieldSpec>] using [context].
  @override
  StyleSpec<RemixTextFieldSpec> resolve(BuildContext context) {
    final spec = RemixTextFieldSpec(
      text: MixOps.resolve(context, $text),
      hintText: MixOps.resolve(context, $hintText),
      textAlign: MixOps.resolve(context, $textAlign),
      cursorWidth: MixOps.resolve(context, $cursorWidth),
      cursorHeight: MixOps.resolve(context, $cursorHeight),
      cursorRadius: MixOps.resolve(context, $cursorRadius),
      cursorColor: MixOps.resolve(context, $cursorColor),
      cursorOffset: MixOps.resolve(context, $cursorOffset),
      cursorOpacityAnimates: MixOps.resolve(context, $cursorOpacityAnimates),
      selectionHeightStyle: MixOps.resolve(context, $selectionHeightStyle),
      selectionWidthStyle: MixOps.resolve(context, $selectionWidthStyle),
      scrollPadding: MixOps.resolve(context, $scrollPadding),
      keyboardAppearance: MixOps.resolve(context, $keyboardAppearance),
      spacing: MixOps.resolve(context, $spacing),
      container: MixOps.resolve(context, $container),
      helperText: MixOps.resolve(context, $helperText),
      label: MixOps.resolve(context, $label),
    );

    return StyleSpec(
      spec: spec,
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('text', $text))
      ..add(DiagnosticsProperty('hintText', $hintText))
      ..add(DiagnosticsProperty('textAlign', $textAlign))
      ..add(DiagnosticsProperty('cursorWidth', $cursorWidth))
      ..add(DiagnosticsProperty('cursorHeight', $cursorHeight))
      ..add(DiagnosticsProperty('cursorRadius', $cursorRadius))
      ..add(DiagnosticsProperty('cursorColor', $cursorColor))
      ..add(DiagnosticsProperty('cursorOffset', $cursorOffset))
      ..add(
        DiagnosticsProperty('cursorOpacityAnimates', $cursorOpacityAnimates),
      )
      ..add(DiagnosticsProperty('selectionHeightStyle', $selectionHeightStyle))
      ..add(DiagnosticsProperty('selectionWidthStyle', $selectionWidthStyle))
      ..add(DiagnosticsProperty('scrollPadding', $scrollPadding))
      ..add(DiagnosticsProperty('keyboardAppearance', $keyboardAppearance))
      ..add(DiagnosticsProperty('spacing', $spacing))
      ..add(DiagnosticsProperty('container', $container))
      ..add(DiagnosticsProperty('helperText', $helperText))
      ..add(DiagnosticsProperty('label', $label));
  }

  @override
  List<Object?> get props => [
    $text,
    $hintText,
    $textAlign,
    $cursorWidth,
    $cursorHeight,
    $cursorRadius,
    $cursorColor,
    $cursorOffset,
    $cursorOpacityAnimates,
    $selectionHeightStyle,
    $selectionWidthStyle,
    $scrollPadding,
    $keyboardAppearance,
    $spacing,
    $container,
    $helperText,
    $label,
    $animation,
    $modifier,
    $variants,
  ];
}
