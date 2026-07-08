part of 'textfield.dart';

/// Style builder for [RemixTextField].
///
/// Use this class to style the text field container, text, hint text, helper
/// text, label, cursor, selection behavior, and spacing.
@MixableStyler()
class RemixTextFieldStyler
    extends RemixFlexContainerStyler<RemixTextFieldSpec, RemixTextFieldStyler>
    with
        LabelStyleMixin<RemixTextFieldStyler>,
        Diagnosticable,
        _$RemixTextFieldStylerMixin {
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

  const RemixTextFieldStyler.create({
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

  RemixTextFieldStyler({
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
  RemixTextFieldStyler color(Color value) {
    return merge(
      RemixTextFieldStyler(
        text: TextStyler(style: TextStyleMix(color: value)),
      ),
    );
  }

  /// Sets background color
  RemixTextFieldStyler backgroundColor(Color value) {
    return merge(
      RemixTextFieldStyler(
        container: FlexBoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  /// Sets container that wraps editable text area
  RemixTextFieldStyler container(FlexBoxStyler value) {
    return merge(RemixTextFieldStyler(container: value));
  }

  /// Sets border radius
  RemixTextFieldStyler borderRadius(BorderRadiusGeometryMix radius) {
    return merge(
      RemixTextFieldStyler(
        container: FlexBoxStyler(
          decoration: BoxDecorationMix(borderRadius: radius),
        ),
      ),
    );
  }

  /// Sets padding
  RemixTextFieldStyler padding(EdgeInsetsGeometryMix value) {
    return merge(
      RemixTextFieldStyler(container: FlexBoxStyler(padding: value)),
    );
  }

  /// Sets border
  RemixTextFieldStyler border(BoxBorderMix value) {
    return merge(
      RemixTextFieldStyler(
        container: FlexBoxStyler(decoration: BoxDecorationMix(border: value)),
      ),
    );
  }

  /// Sets width
  RemixTextFieldStyler width(double value) {
    return merge(
      RemixTextFieldStyler(
        container: FlexBoxStyler(
          constraints: BoxConstraintsMix(minWidth: value, maxWidth: value),
        ),
      ),
    );
  }

  /// Sets height
  RemixTextFieldStyler height(double value) {
    return merge(
      RemixTextFieldStyler(
        container: FlexBoxStyler(
          constraints: BoxConstraintsMix(minHeight: value, maxHeight: value),
        ),
      ),
    );
  }

  /// Sets cursor color
  RemixTextFieldStyler cursorColor(Color value) {
    return merge(RemixTextFieldStyler(cursorColor: value));
  }

  /// Sets hint text color
  RemixTextFieldStyler hintColor(Color value) {
    return merge(
      RemixTextFieldStyler(
        hintText: TextStyler(style: TextStyleMix(color: value)),
      ),
    );
  }

  /// Sets hint text color
  RemixTextFieldStyler hintText(TextStyler value) {
    return merge(RemixTextFieldStyler(hintText: value));
  }

  // Additional convenience methods that delegate to container

  /// Sets margin
  RemixTextFieldStyler margin(EdgeInsetsGeometryMix value) {
    return merge(RemixTextFieldStyler(container: FlexBoxStyler(margin: value)));
  }

  /// Sets flex spacing
  RemixTextFieldStyler spacing(double value) {
    return merge(
      RemixTextFieldStyler(container: FlexBoxStyler(spacing: value)),
    );
  }

  /// Sets decoration
  RemixTextFieldStyler decoration(DecorationMix value) {
    return merge(
      RemixTextFieldStyler(container: FlexBoxStyler(decoration: value)),
    );
  }

  /// Sets container alignment
  RemixTextFieldStyler alignment(Alignment value) {
    return merge(
      RemixTextFieldStyler(container: FlexBoxStyler(alignment: value)),
    );
  }

  /// Sets constraints
  RemixTextFieldStyler constraints(BoxConstraintsMix value) {
    return merge(
      RemixTextFieldStyler(container: FlexBoxStyler(constraints: value)),
    );
  }

  /// Sets text alignment
  RemixTextFieldStyler textAlign(TextAlign value) {
    return merge(RemixTextFieldStyler(textAlign: value));
  }

  /// Sets helper text
  RemixTextFieldStyler helperText(TextStyler value) {
    return merge(RemixTextFieldStyler(helperText: value));
  }

  /// Creates a [RemixTextField] widget with this style applied.
  ///
  /// Example:
  /// ```dart
  /// final textField = RemixTextFieldStyler()
  ///   .backgroundColor(Colors.grey.shade100)
  ///   .borderRadius(BorderRadiusMix.circular(8));
  ///
  /// // Use it like a function
  /// textField(
  ///   hintText: 'Enter your name',
  ///   onChanged: (value) => debugPrint(value),
  /// )
  /// ```
  RemixTextField call({
    TextEditingController? controller,
    FocusNode? focusNode,
    String? label,
    String? hintText,
    String? helperText,
    bool error = false,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    TextCapitalization textCapitalization = .none,
    TextDirection? textDirection,
    bool obscureText = false,
    bool enabled = true,
    bool readOnly = false,
    bool autofocus = false,
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
    bool? showCursor,
    String obscuringCharacter = '•',
    bool autocorrect = true,
    bool enableSuggestions = true,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
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
    Widget? leading,
    Widget? trailing,
    String? semanticLabel,
    String? semanticHint,
    bool excludeSemantics = false,
  }) {
    return RemixTextField(
      controller: controller,
      focusNode: focusNode,
      label: label,
      hintText: hintText,
      helperText: helperText,
      error: error,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      textDirection: textDirection,
      obscureText: obscureText,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
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
      showCursor: showCursor,
      obscuringCharacter: obscuringCharacter,
      autocorrect: autocorrect,
      enableSuggestions: enableSuggestions,
      smartDashesType: smartDashesType,
      smartQuotesType: smartQuotesType,
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
      leading: leading,
      trailing: trailing,
      semanticLabel: semanticLabel,
      semanticHint: semanticHint,
      excludeSemantics: excludeSemantics,
      style: this,
    );
  }

  /// Sets label text
  @override
  RemixTextFieldStyler label(TextStyler value) {
    return merge(RemixTextFieldStyler(label: value));
  }

  // Abstract method implementations for mixins

  @override
  RemixTextFieldStyler foregroundDecoration(DecorationMix value) {
    return merge(
      RemixTextFieldStyler(
        container: FlexBoxStyler(foregroundDecoration: value),
      ),
    );
  }

  @override
  RemixTextFieldStyler transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixTextFieldStyler(
        container: FlexBoxStyler(
          transform: value,
          transformAlignment: alignment,
        ),
      ),
    );
  }

  // FlexStyleMixin implementation
  @override
  RemixTextFieldStyler flex(FlexStyler value) {
    return merge(RemixTextFieldStyler(container: FlexBoxStyler().flex(value)));
  }
}
