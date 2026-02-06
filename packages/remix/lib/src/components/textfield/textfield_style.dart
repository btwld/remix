part of 'textfield.dart';

@MixableStyler()
class RemixTextFieldStyle
    extends RemixFlexContainerStyle<RemixTextFieldSpec, RemixTextFieldStyle>
    with
        LabelStyleMixin<RemixTextFieldStyle>,
        Diagnosticable,
        _$RemixTextFieldStyleMixin {
  @MixableField(setterType: TextStyler)
  final Prop<StyleSpec<TextSpec>>? $text;
  @MixableField(setterType: TextStyler)
  final Prop<StyleSpec<TextSpec>>? $hintText;
  @MixableField()
  final Prop<TextAlign>? $textAlign;
  @MixableField()
  final Prop<double>? $cursorWidth;
  @MixableField()
  final Prop<double>? $cursorHeight;
  @MixableField()
  final Prop<Radius>? $cursorRadius;
  @MixableField()
  final Prop<Color>? $cursorColor;
  @MixableField()
  final Prop<Offset>? $cursorOffset;
  @MixableField()
  final Prop<bool>? $cursorOpacityAnimates;
  @MixableField()
  final Prop<BoxHeightStyle>? $selectionHeightStyle;
  @MixableField()
  final Prop<BoxWidthStyle>? $selectionWidthStyle;
  @MixableField()
  final Prop<EdgeInsets>? $scrollPadding;
  @MixableField()
  final Prop<Brightness>? $keyboardAppearance;
  @MixableField()
  final Prop<double>? $spacing;
  @MixableField(setterType: FlexBoxStyler)
  final Prop<StyleSpec<FlexBoxSpec>>? $container;
  @MixableField(setterType: TextStyler)
  final Prop<StyleSpec<TextSpec>>? $helperText;
  @MixableField(setterType: TextStyler)
  final Prop<StyleSpec<TextSpec>>? $label;

  const RemixTextFieldStyle.create({
    Prop<StyleSpec<TextSpec>>? text,
    Prop<StyleSpec<TextSpec>>? hintText,
    Prop<TextAlign>? textAlign,
    Prop<double>? cursorWidth,
    Prop<double>? cursorHeight,
    Prop<Radius>? cursorRadius,
    Prop<Color>? cursorColor,
    Prop<Offset>? cursorOffset,
    Prop<bool>? cursorOpacityAnimates,
    Prop<BoxHeightStyle>? selectionHeightStyle,
    Prop<BoxWidthStyle>? selectionWidthStyle,
    Prop<EdgeInsets>? scrollPadding,
    Prop<Brightness>? keyboardAppearance,
    Prop<double>? spacing,
    Prop<StyleSpec<FlexBoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? helperText,
    Prop<StyleSpec<TextSpec>>? label,
    super.variants,
    super.animation,
    super.modifier,
  }) : $text = text,
       $hintText = hintText,
       $textAlign = textAlign,
       $cursorWidth = cursorWidth,
       $cursorHeight = cursorHeight,
       $cursorRadius = cursorRadius,
       $cursorColor = cursorColor,
       $cursorOffset = cursorOffset,
       $cursorOpacityAnimates = cursorOpacityAnimates,
       $selectionHeightStyle = selectionHeightStyle,
       $selectionWidthStyle = selectionWidthStyle,
       $scrollPadding = scrollPadding,
       $keyboardAppearance = keyboardAppearance,
       $spacing = spacing,
       $container = container,
       $helperText = helperText,
       $label = label;

  RemixTextFieldStyle({
    TextStyler? text,
    TextStyler? hintText,
    TextAlign? textAlign,
    double? cursorWidth,
    double? cursorHeight,
    Radius? cursorRadius,
    Color? cursorColor,
    Offset? cursorOffset,
    bool? cursorOpacityAnimates,
    BoxHeightStyle? selectionHeightStyle,
    BoxWidthStyle? selectionWidthStyle,
    EdgeInsets? scrollPadding,
    Brightness? keyboardAppearance,
    double? spacing,
    FlexBoxStyler? container,
    TextStyler? helperText,
    TextStyler? label,
    AnimationConfig? animation,
    List<VariantStyle<RemixTextFieldSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
         text: Prop.maybeMix(text),
         hintText: Prop.maybeMix(hintText),
         textAlign: Prop.maybe(textAlign),
         cursorWidth: Prop.maybe(cursorWidth),
         cursorHeight: Prop.maybe(cursorHeight),
         cursorRadius: Prop.maybe(cursorRadius),
         cursorColor: Prop.maybe(cursorColor),
         cursorOffset: Prop.maybe(cursorOffset),
         cursorOpacityAnimates: Prop.maybe(cursorOpacityAnimates),
         selectionHeightStyle: Prop.maybe(selectionHeightStyle),
         selectionWidthStyle: Prop.maybe(selectionWidthStyle),
         scrollPadding: Prop.maybe(scrollPadding),
         keyboardAppearance: Prop.maybe(keyboardAppearance),
         spacing: Prop.maybe(spacing),
         container: Prop.maybeMix(container),
         helperText: Prop.maybeMix(helperText),
         label: Prop.maybeMix(label),
         variants: variants,
         animation: animation,
         modifier: modifier,
       );

  // Instance methods (chainable)

  /// Sets text color
  RemixTextFieldStyle color(Color value) {
    return merge(
      RemixTextFieldStyle(
        text: TextStyler(style: TextStyleMix(color: value)),
      ),
    );
  }

  /// Sets background color
  RemixTextFieldStyle backgroundColor(Color value) {
    return merge(
      RemixTextFieldStyle(
        container: FlexBoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  /// Sets container that wraps editable text area
  RemixTextFieldStyle container(FlexBoxStyler value) {
    return merge(RemixTextFieldStyle(container: value));
  }

  /// Sets border radius
  RemixTextFieldStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(
      RemixTextFieldStyle(
        container: FlexBoxStyler(
          decoration: BoxDecorationMix(borderRadius: radius),
        ),
      ),
    );
  }

  /// Sets padding
  RemixTextFieldStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixTextFieldStyle(container: FlexBoxStyler(padding: value)));
  }

  /// Sets border
  RemixTextFieldStyle border(BoxBorderMix value) {
    return merge(
      RemixTextFieldStyle(
        container: FlexBoxStyler(decoration: BoxDecorationMix(border: value)),
      ),
    );
  }

  /// Sets width
  RemixTextFieldStyle width(double value) {
    return merge(
      RemixTextFieldStyle(
        container: FlexBoxStyler(
          constraints: BoxConstraintsMix(minWidth: value, maxWidth: value),
        ),
      ),
    );
  }

  /// Sets height
  RemixTextFieldStyle height(double value) {
    return merge(
      RemixTextFieldStyle(
        container: FlexBoxStyler(
          constraints: BoxConstraintsMix(minHeight: value, maxHeight: value),
        ),
      ),
    );
  }

  /// Sets cursor color
  RemixTextFieldStyle cursorColor(Color value) {
    return merge(RemixTextFieldStyle(cursorColor: value));
  }

  /// Sets hint text color
  RemixTextFieldStyle hintColor(Color value) {
    return merge(
      RemixTextFieldStyle(
        hintText: TextStyler(style: TextStyleMix(color: value)),
      ),
    );
  }

  /// Sets hint text color
  RemixTextFieldStyle hintText(TextStyler value) {
    return merge(RemixTextFieldStyle(hintText: value));
  }

  // Additional convenience methods that delegate to container

  /// Sets margin
  RemixTextFieldStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixTextFieldStyle(container: FlexBoxStyler(margin: value)));
  }

  /// Sets flex spacing
  RemixTextFieldStyle spacing(double value) {
    return merge(RemixTextFieldStyle(container: FlexBoxStyler(spacing: value)));
  }

  /// Sets decoration
  RemixTextFieldStyle decoration(DecorationMix value) {
    return merge(
      RemixTextFieldStyle(container: FlexBoxStyler(decoration: value)),
    );
  }

  /// Sets container alignment
  RemixTextFieldStyle alignment(Alignment value) {
    return merge(
      RemixTextFieldStyle(container: FlexBoxStyler(alignment: value)),
    );
  }

  /// Sets constraints
  RemixTextFieldStyle constraints(BoxConstraintsMix value) {
    return merge(
      RemixTextFieldStyle(container: FlexBoxStyler(constraints: value)),
    );
  }

  /// Sets text alignment
  RemixTextFieldStyle textAlign(TextAlign value) {
    return merge(RemixTextFieldStyle(textAlign: value));
  }

  /// Sets helper text
  RemixTextFieldStyle helperText(TextStyler value) {
    return merge(RemixTextFieldStyle(helperText: value));
  }

  /// Sets label text
  @override
  RemixTextFieldStyle label(TextStyler value) {
    return merge(RemixTextFieldStyle(label: value));
  }

  // Abstract method implementations for mixins

  @override
  RemixTextFieldStyle foregroundDecoration(DecorationMix value) {
    return merge(
      RemixTextFieldStyle(
        container: FlexBoxStyler(foregroundDecoration: value),
      ),
    );
  }

  @override
  RemixTextFieldStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixTextFieldStyle(
        container: FlexBoxStyler(
          transform: value,
          transformAlignment: alignment,
        ),
      ),
    );
  }

  // FlexStyleMixin implementation
  @override
  RemixTextFieldStyle flex(FlexStyler value) {
    return merge(RemixTextFieldStyle(container: FlexBoxStyler().flex(value)));
  }

  /// Creates a [RemixTextField] widget with this style applied.
  ///
  /// Example:
  /// ```dart
  /// final textField = RemixTextFieldStyle()
  ///   .backgroundColor(Colors.grey.shade100)
  ///   .borderRadius(BorderRadiusMix.circular(8));
  ///
  /// // Use it like a function
  /// textField(
  ///   hintText: 'Enter your name',
  ///   onChanged: (value) => print(value),
  /// )
  /// ```
  RemixTextField call({
    TextEditingController? controller,
    FocusNode? focusNode,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    TextCapitalization textCapitalization = .none,
    TextDirection? textDirection,
    bool readOnly = false,
    bool? showCursor,
    bool autofocus = false,
    String obscuringCharacter = '•',
    bool obscureText = false,
    bool autocorrect = true,
    bool enableSuggestions = true,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    int? maxLines = 1,
    int? minLines,
    bool expands = false,
    int? maxLength,
    MaxLengthEnforcement? maxLengthEnforcement,
    ValueChanged<String>? onChanged,
    VoidCallback? onEditingComplete,
    ValueChanged<String>? onSubmitted,
    AppPrivateCommandCallback? onAppPrivateCommand,
    List<TextInputFormatter>? inputFormatters,
    bool enabled = true,
    DragStartBehavior dragStartBehavior = .start,
    bool enableInteractiveSelection = true,
    TextSelectionControls? selectionControls,
    TapRegionCallback? onTapOutside,
    TapRegionUpCallback? onPressUpOutside,
    bool onTapAlwaysCalled = false,
    ScrollController? scrollController,
    ScrollPhysics? scrollPhysics,
    Iterable<String>? autofillHints,
    ContentInsertionConfiguration? contentInsertionConfiguration,
    Clip clipBehavior = .hardEdge,
    String? restorationId,
    bool stylusHandwritingEnabled = true,
    bool enableIMEPersonalizedLearning = true,
    EditableTextContextMenuBuilder? contextMenuBuilder,
    SpellCheckConfiguration? spellCheckConfiguration,
    TextMagnifierConfiguration? magnifierConfiguration,
    bool canRequestFocus = true,
    bool? ignorePointers,
    UndoHistoryController? undoController,
    Object groupId = EditableText,
    String? hintText,
    String? helperText,
    String? label,
    bool error = false,
    Widget? leading,
    Widget? trailing,
    String? semanticLabel,
    String? semanticHint,
    bool excludeSemantics = false,
  }) {
    return RemixTextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      textDirection: textDirection,
      readOnly: readOnly,
      showCursor: showCursor,
      autofocus: autofocus,
      obscuringCharacter: obscuringCharacter,
      obscureText: obscureText,
      autocorrect: autocorrect,
      enableSuggestions: enableSuggestions,
      smartDashesType: smartDashesType,
      smartQuotesType: smartQuotesType,
      maxLines: maxLines,
      minLines: minLines,
      expands: expands,
      maxLength: maxLength,
      maxLengthEnforcement: maxLengthEnforcement,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      onSubmitted: onSubmitted,
      onAppPrivateCommand: onAppPrivateCommand,
      inputFormatters: inputFormatters,
      enabled: enabled,
      dragStartBehavior: dragStartBehavior,
      enableInteractiveSelection: enableInteractiveSelection,
      selectionControls: selectionControls,
      onTapOutside: onTapOutside,
      onPressUpOutside: onPressUpOutside,
      onTapAlwaysCalled: onTapAlwaysCalled,
      scrollController: scrollController,
      scrollPhysics: scrollPhysics,
      autofillHints: autofillHints,
      contentInsertionConfiguration: contentInsertionConfiguration,
      clipBehavior: clipBehavior,
      restorationId: restorationId,
      stylusHandwritingEnabled: stylusHandwritingEnabled,
      enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
      contextMenuBuilder: contextMenuBuilder,
      spellCheckConfiguration: spellCheckConfiguration,
      magnifierConfiguration: magnifierConfiguration,
      canRequestFocus: canRequestFocus,
      ignorePointers: ignorePointers,
      undoController: undoController,
      groupId: groupId,
      hintText: hintText,
      helperText: helperText,
      label: label,
      error: error,
      leading: leading,
      trailing: trailing,
      semanticLabel: semanticLabel,
      semanticHint: semanticHint,
      excludeSemantics: excludeSemantics,
      style: this,
    );
  }
}
