// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'select.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides spec functionality for [SelectSpec].
mixin _$SelectSpec on Spec<SelectSpec> {
  static SelectSpec from(MixContext mix) {
    return mix.attributeOf<SelectSpecAttribute>()?.resolve(mix) ??
        const SelectSpec();
  }

  /// {@template select_spec_of}
  /// Retrieves the [SelectSpec] from the nearest [ComputedStyle] ancestor in the widget tree.
  ///
  /// This method uses [ComputedStyle.specOf] for surgical rebuilds - only widgets
  /// that call this method will rebuild when [SelectSpec] changes, not when other specs change.
  /// If no ancestor [ComputedStyle] is found, this method returns an empty [SelectSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final selectSpec = SelectSpec.of(context);
  /// ```
  /// {@endtemplate}
  static SelectSpec of(BuildContext context) {
    return ComputedStyle.specOf<SelectSpec>(context) ?? const SelectSpec();
  }

  /// Creates a copy of this [SelectSpec] but with the given fields
  /// replaced with the new values.
  @override
  SelectSpec copyWith({
    SelectTriggerSpec? trigger,
    BoxSpec? menuContainer,
    SelectMenuItemSpec? item,
    CompositedTransformFollowerSpec? position,
    WidgetModifiersConfig? modifiers,
    AnimatedData? animated,
  }) {
    return SelectSpec(
      trigger: trigger ?? _$this.trigger,
      menuContainer: menuContainer ?? _$this.menuContainer,
      item: item ?? _$this.item,
      position: position ?? _$this.position,
      modifiers: modifiers ?? _$this.modifiers,
      animated: animated ?? _$this.animated,
    );
  }

  /// Linearly interpolates between this [SelectSpec] and another [SelectSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [SelectSpec] is returned. When [t] is 1.0, the [other] [SelectSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [SelectSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [SelectSpec] instance.
  ///
  /// The interpolation is performed on each property of the [SelectSpec] using the appropriate
  /// interpolation method:
  /// - [SelectTriggerSpec.lerp] for [trigger].
  /// - [BoxSpec.lerp] for [menuContainer].
  /// - [SelectMenuItemSpec.lerp] for [item].
  /// - [CompositedTransformFollowerSpec.lerp] for [position].
  /// For [modifiers] and [animated], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [SelectSpec] is used. Otherwise, the value
  /// from the [other] [SelectSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [SelectSpec] configurations.
  @override
  SelectSpec lerp(SelectSpec? other, double t) {
    if (other == null) return _$this;

    return SelectSpec(
      trigger: _$this.trigger.lerp(other.trigger, t),
      menuContainer: _$this.menuContainer.lerp(other.menuContainer, t),
      item: _$this.item.lerp(other.item, t),
      position: _$this.position.lerp(other.position, t),
      modifiers: other.modifiers,
      animated: _$this.animated ?? other.animated,
    );
  }

  /// The list of properties that constitute the state of this [SelectSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [SelectSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.trigger,
        _$this.menuContainer,
        _$this.item,
        _$this.position,
        _$this.modifiers,
        _$this.animated,
      ];

  SelectSpec get _$this => this as SelectSpec;

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(
        DiagnosticsProperty('trigger', _$this.trigger, defaultValue: null));
    properties.add(DiagnosticsProperty('menuContainer', _$this.menuContainer,
        defaultValue: null));
    properties
        .add(DiagnosticsProperty('item', _$this.item, defaultValue: null));
    properties.add(
        DiagnosticsProperty('position', _$this.position, defaultValue: null));
    properties.add(
        DiagnosticsProperty('modifiers', _$this.modifiers, defaultValue: null));
    properties.add(
        DiagnosticsProperty('animated', _$this.animated, defaultValue: null));
  }
}

/// Represents the attributes of a [SelectSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [SelectSpec].
///
/// Use this class to configure the attributes of a [SelectSpec] and pass it to
/// the [SelectSpec] constructor.
class SelectSpecAttribute extends SpecAttribute<SelectSpec>
    with Diagnosticable {
  final SelectTriggerSpecAttribute? trigger;
  final BoxSpecAttribute? menuContainer;
  final SelectMenuItemSpecAttribute? item;
  final CompositedTransformFollowerSpecAttribute? position;

  const SelectSpecAttribute({
    this.trigger,
    this.menuContainer,
    this.item,
    this.position,
    super.modifiers,
    super.animated,
  });

  /// Resolves to [SelectSpec] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final selectSpec = SelectSpecAttribute(...).resolve(mix);
  /// ```
  @override
  SelectSpec resolve(MixContext mix) {
    return SelectSpec(
      trigger: trigger?.resolve(mix),
      menuContainer: menuContainer?.resolve(mix),
      item: item?.resolve(mix),
      position: position?.resolve(mix),
      modifiers: modifiers?.resolve(mix),
      animated: animated?.resolve(mix) ?? mix.animation,
    );
  }

  /// Merges the properties of this [SelectSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [SelectSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  SelectSpecAttribute merge(SelectSpecAttribute? other) {
    if (other == null) return this;

    return SelectSpecAttribute(
      trigger: trigger?.merge(other.trigger) ?? other.trigger,
      menuContainer:
          menuContainer?.merge(other.menuContainer) ?? other.menuContainer,
      item: item?.merge(other.item) ?? other.item,
      position: position?.merge(other.position) ?? other.position,
      modifiers: modifiers?.merge(other.modifiers) ?? other.modifiers,
      animated: animated?.merge(other.animated) ?? other.animated,
    );
  }

  /// The list of properties that constitute the state of this [SelectSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [SelectSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
        trigger,
        menuContainer,
        item,
        position,
        modifiers,
        animated,
      ];

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('trigger', trigger, defaultValue: null));
    properties.add(DiagnosticsProperty('menuContainer', menuContainer,
        defaultValue: null));
    properties.add(DiagnosticsProperty('item', item, defaultValue: null));
    properties
        .add(DiagnosticsProperty('position', position, defaultValue: null));
    properties
        .add(DiagnosticsProperty('modifiers', modifiers, defaultValue: null));
    properties
        .add(DiagnosticsProperty('animated', animated, defaultValue: null));
  }
}

/// Utility class for configuring [SelectSpec] properties.
///
/// This class provides methods to set individual properties of a [SelectSpec].
/// Use the methods of this class to configure specific properties of a [SelectSpec].
class SelectSpecUtility<T extends SpecAttribute>
    extends SpecUtility<T, SelectSpecAttribute> {
  /// Utility for defining [SelectSpecAttribute.trigger]
  late final trigger = SelectTriggerSpecUtility((v) => only(trigger: v));

  /// Utility for defining [SelectSpecAttribute.menuContainer]
  late final menuContainer = BoxSpecUtility((v) => only(menuContainer: v));

  /// Utility for defining [SelectSpecAttribute.item]
  late final item = SelectMenuItemSpecUtility((v) => only(item: v));

  /// Utility for defining [SelectSpecAttribute.position]
  late final position =
      CompositedTransformFollowerSpecUtility((v) => only(position: v));

  /// Utility for defining [SelectSpecAttribute.modifiers]
  late final wrap = SpecModifierUtility((v) => only(modifiers: v));

  /// Utility for defining [SelectSpecAttribute.animated]
  late final animated = AnimatedUtility((v) => only(animated: v));

  SelectSpecUtility(
    super.builder, {
    @Deprecated(
      'mutable parameter is no longer used. All SpecUtilities are now mutable by default.',
    )
    super.mutable,
  });

  @Deprecated(
    'Use "this" instead of "chain" for method chaining. '
    'The chain getter will be removed in a future version.',
  )
  SelectSpecUtility<T> get chain => SelectSpecUtility(attributeBuilder);

  static SelectSpecUtility<SelectSpecAttribute> get self =>
      SelectSpecUtility((v) => v);

  /// Returns a new [SelectSpecAttribute] with the specified properties.
  @override
  T only({
    SelectTriggerSpecAttribute? trigger,
    BoxSpecAttribute? menuContainer,
    SelectMenuItemSpecAttribute? item,
    CompositedTransformFollowerSpecAttribute? position,
    WidgetModifiersConfigDto? modifiers,
    AnimatedDataDto? animated,
  }) {
    return builder(SelectSpecAttribute(
      trigger: trigger,
      menuContainer: menuContainer,
      item: item,
      position: position,
      modifiers: modifiers,
      animated: animated,
    ));
  }
}

/// A tween that interpolates between two [SelectSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [SelectSpec] specifications.
class SelectSpecTween extends Tween<SelectSpec?> {
  SelectSpecTween({
    super.begin,
    super.end,
  });

  @override
  SelectSpec lerp(double t) {
    if (begin == null && end == null) {
      return const SelectSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}

/// A mixin that provides spec functionality for [SelectMenuItemSpec].
mixin _$SelectMenuItemSpec on Spec<SelectMenuItemSpec> {
  static SelectMenuItemSpec from(MixContext mix) {
    return mix.attributeOf<SelectMenuItemSpecAttribute>()?.resolve(mix) ??
        const SelectMenuItemSpec();
  }

  /// {@template select_menu_item_spec_of}
  /// Retrieves the [SelectMenuItemSpec] from the nearest [ComputedStyle] ancestor in the widget tree.
  ///
  /// This method uses [ComputedStyle.specOf] for surgical rebuilds - only widgets
  /// that call this method will rebuild when [SelectMenuItemSpec] changes, not when other specs change.
  /// If no ancestor [ComputedStyle] is found, this method returns an empty [SelectMenuItemSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final selectMenuItemSpec = SelectMenuItemSpec.of(context);
  /// ```
  /// {@endtemplate}
  static SelectMenuItemSpec of(BuildContext context) {
    return ComputedStyle.specOf<SelectMenuItemSpec>(context) ??
        const SelectMenuItemSpec();
  }

  /// Creates a copy of this [SelectMenuItemSpec] but with the given fields
  /// replaced with the new values.
  @override
  SelectMenuItemSpec copyWith({
    IconThemeData? icon,
    TextStyle? textStyle,
    FlexBoxSpec? container,
    WidgetModifiersConfig? modifiers,
    AnimatedData? animated,
  }) {
    return SelectMenuItemSpec(
      icon: icon ?? _$this.icon,
      textStyle: textStyle ?? _$this.textStyle,
      container: container ?? _$this.container,
      modifiers: modifiers ?? _$this.modifiers,
      animated: animated ?? _$this.animated,
    );
  }

  /// The list of properties that constitute the state of this [SelectMenuItemSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [SelectMenuItemSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.icon,
        _$this.textStyle,
        _$this.container,
        _$this.modifiers,
        _$this.animated,
      ];

  SelectMenuItemSpec get _$this => this as SelectMenuItemSpec;

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
        .add(DiagnosticsProperty('icon', _$this.icon, defaultValue: null));
    properties.add(
        DiagnosticsProperty('textStyle', _$this.textStyle, defaultValue: null));
    properties.add(
        DiagnosticsProperty('container', _$this.container, defaultValue: null));
    properties.add(
        DiagnosticsProperty('modifiers', _$this.modifiers, defaultValue: null));
    properties.add(
        DiagnosticsProperty('animated', _$this.animated, defaultValue: null));
  }
}

/// Represents the attributes of a [SelectMenuItemSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [SelectMenuItemSpec].
///
/// Use this class to configure the attributes of a [SelectMenuItemSpec] and pass it to
/// the [SelectMenuItemSpec] constructor.
class SelectMenuItemSpecAttribute extends SpecAttribute<SelectMenuItemSpec>
    with Diagnosticable {
  final IconThemeDataDto? icon;
  final TextStyleDto? textStyle;
  final FlexBoxSpecAttribute? container;

  const SelectMenuItemSpecAttribute({
    this.icon,
    this.textStyle,
    this.container,
    super.modifiers,
    super.animated,
  });

  /// Resolves to [SelectMenuItemSpec] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final selectMenuItemSpec = SelectMenuItemSpecAttribute(...).resolve(mix);
  /// ```
  @override
  SelectMenuItemSpec resolve(MixContext mix) {
    return SelectMenuItemSpec(
      icon: icon?.resolve(mix),
      textStyle: textStyle?.resolve(mix),
      container: container?.resolve(mix),
      modifiers: modifiers?.resolve(mix),
      animated: animated?.resolve(mix) ?? mix.animation,
    );
  }

  /// Merges the properties of this [SelectMenuItemSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [SelectMenuItemSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  SelectMenuItemSpecAttribute merge(SelectMenuItemSpecAttribute? other) {
    if (other == null) return this;

    return SelectMenuItemSpecAttribute(
      icon: icon?.merge(other.icon) ?? other.icon,
      textStyle: textStyle?.merge(other.textStyle) ?? other.textStyle,
      container: container?.merge(other.container) ?? other.container,
      modifiers: modifiers?.merge(other.modifiers) ?? other.modifiers,
      animated: animated?.merge(other.animated) ?? other.animated,
    );
  }

  /// The list of properties that constitute the state of this [SelectMenuItemSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [SelectMenuItemSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
        icon,
        textStyle,
        container,
        modifiers,
        animated,
      ];

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('icon', icon, defaultValue: null));
    properties
        .add(DiagnosticsProperty('textStyle', textStyle, defaultValue: null));
    properties
        .add(DiagnosticsProperty('container', container, defaultValue: null));
    properties
        .add(DiagnosticsProperty('modifiers', modifiers, defaultValue: null));
    properties
        .add(DiagnosticsProperty('animated', animated, defaultValue: null));
  }
}

/// Utility class for configuring [SelectMenuItemSpec] properties.
///
/// This class provides methods to set individual properties of a [SelectMenuItemSpec].
/// Use the methods of this class to configure specific properties of a [SelectMenuItemSpec].
class SelectMenuItemSpecUtility<T extends SpecAttribute>
    extends SpecUtility<T, SelectMenuItemSpecAttribute> {
  /// Utility for defining [SelectMenuItemSpecAttribute.icon]
  late final icon = IconThemeDataUtility((v) => only(icon: v));

  /// Utility for defining [SelectMenuItemSpecAttribute.textStyle]
  late final textStyle = TextStyleUtility((v) => only(textStyle: v));

  /// Utility for defining [SelectMenuItemSpecAttribute.container]
  late final container = FlexBoxSpecUtility((v) => only(container: v));

  /// Utility for defining [SelectMenuItemSpecAttribute.modifiers]
  late final wrap = SpecModifierUtility((v) => only(modifiers: v));

  /// Utility for defining [SelectMenuItemSpecAttribute.animated]
  late final animated = AnimatedUtility((v) => only(animated: v));

  SelectMenuItemSpecUtility(
    super.builder, {
    @Deprecated(
      'mutable parameter is no longer used. All SpecUtilities are now mutable by default.',
    )
    super.mutable,
  });

  @Deprecated(
    'Use "this" instead of "chain" for method chaining. '
    'The chain getter will be removed in a future version.',
  )
  SelectMenuItemSpecUtility<T> get chain =>
      SelectMenuItemSpecUtility(attributeBuilder);

  static SelectMenuItemSpecUtility<SelectMenuItemSpecAttribute> get self =>
      SelectMenuItemSpecUtility((v) => v);

  /// Returns a new [SelectMenuItemSpecAttribute] with the specified properties.
  @override
  T only({
    IconThemeDataDto? icon,
    TextStyleDto? textStyle,
    FlexBoxSpecAttribute? container,
    WidgetModifiersConfigDto? modifiers,
    AnimatedDataDto? animated,
  }) {
    return builder(SelectMenuItemSpecAttribute(
      icon: icon,
      textStyle: textStyle,
      container: container,
      modifiers: modifiers,
      animated: animated,
    ));
  }
}

/// A tween that interpolates between two [SelectMenuItemSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [SelectMenuItemSpec] specifications.
class SelectMenuItemSpecTween extends Tween<SelectMenuItemSpec?> {
  SelectMenuItemSpecTween({
    super.begin,
    super.end,
  });

  @override
  SelectMenuItemSpec lerp(double t) {
    if (begin == null && end == null) {
      return const SelectMenuItemSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}

/// A mixin that provides spec functionality for [SelectTriggerSpec].
mixin _$SelectTriggerSpec on Spec<SelectTriggerSpec> {
  static SelectTriggerSpec from(MixContext mix) {
    return mix.attributeOf<SelectTriggerSpecAttribute>()?.resolve(mix) ??
        const SelectTriggerSpec();
  }

  /// {@template select_trigger_spec_of}
  /// Retrieves the [SelectTriggerSpec] from the nearest [ComputedStyle] ancestor in the widget tree.
  ///
  /// This method uses [ComputedStyle.specOf] for surgical rebuilds - only widgets
  /// that call this method will rebuild when [SelectTriggerSpec] changes, not when other specs change.
  /// If no ancestor [ComputedStyle] is found, this method returns an empty [SelectTriggerSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final selectTriggerSpec = SelectTriggerSpec.of(context);
  /// ```
  /// {@endtemplate}
  static SelectTriggerSpec of(BuildContext context) {
    return ComputedStyle.specOf<SelectTriggerSpec>(context) ??
        const SelectTriggerSpec();
  }

  /// Creates a copy of this [SelectTriggerSpec] but with the given fields
  /// replaced with the new values.
  @override
  SelectTriggerSpec copyWith({
    FlexBoxSpec? container,
    IconThemeData? icon,
    TextSpec? label,
    WidgetModifiersConfig? modifiers,
    AnimatedData? animated,
  }) {
    return SelectTriggerSpec(
      container: container ?? _$this.container,
      icon: icon ?? _$this.icon,
      label: label ?? _$this.label,
      modifiers: modifiers ?? _$this.modifiers,
      animated: animated ?? _$this.animated,
    );
  }

  /// The list of properties that constitute the state of this [SelectTriggerSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [SelectTriggerSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.container,
        _$this.icon,
        _$this.label,
        _$this.modifiers,
        _$this.animated,
      ];

  SelectTriggerSpec get _$this => this as SelectTriggerSpec;

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(
        DiagnosticsProperty('container', _$this.container, defaultValue: null));
    properties
        .add(DiagnosticsProperty('icon', _$this.icon, defaultValue: null));
    properties
        .add(DiagnosticsProperty('label', _$this.label, defaultValue: null));
    properties.add(
        DiagnosticsProperty('modifiers', _$this.modifiers, defaultValue: null));
    properties.add(
        DiagnosticsProperty('animated', _$this.animated, defaultValue: null));
  }
}

/// Represents the attributes of a [SelectTriggerSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [SelectTriggerSpec].
///
/// Use this class to configure the attributes of a [SelectTriggerSpec] and pass it to
/// the [SelectTriggerSpec] constructor.
class SelectTriggerSpecAttribute extends SpecAttribute<SelectTriggerSpec>
    with Diagnosticable {
  final FlexBoxSpecAttribute? container;
  final IconThemeDataDto? icon;
  final TextSpecAttribute? label;

  const SelectTriggerSpecAttribute({
    this.container,
    this.icon,
    this.label,
    super.modifiers,
    super.animated,
  });

  /// Resolves to [SelectTriggerSpec] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final selectTriggerSpec = SelectTriggerSpecAttribute(...).resolve(mix);
  /// ```
  @override
  SelectTriggerSpec resolve(MixContext mix) {
    return SelectTriggerSpec(
      container: container?.resolve(mix),
      icon: icon?.resolve(mix),
      label: label?.resolve(mix),
      modifiers: modifiers?.resolve(mix),
      animated: animated?.resolve(mix) ?? mix.animation,
    );
  }

  /// Merges the properties of this [SelectTriggerSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [SelectTriggerSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  SelectTriggerSpecAttribute merge(SelectTriggerSpecAttribute? other) {
    if (other == null) return this;

    return SelectTriggerSpecAttribute(
      container: container?.merge(other.container) ?? other.container,
      icon: icon?.merge(other.icon) ?? other.icon,
      label: label?.merge(other.label) ?? other.label,
      modifiers: modifiers?.merge(other.modifiers) ?? other.modifiers,
      animated: animated?.merge(other.animated) ?? other.animated,
    );
  }

  /// The list of properties that constitute the state of this [SelectTriggerSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [SelectTriggerSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
        container,
        icon,
        label,
        modifiers,
        animated,
      ];

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty('container', container, defaultValue: null));
    properties.add(DiagnosticsProperty('icon', icon, defaultValue: null));
    properties.add(DiagnosticsProperty('label', label, defaultValue: null));
    properties
        .add(DiagnosticsProperty('modifiers', modifiers, defaultValue: null));
    properties
        .add(DiagnosticsProperty('animated', animated, defaultValue: null));
  }
}

/// Utility class for configuring [SelectTriggerSpec] properties.
///
/// This class provides methods to set individual properties of a [SelectTriggerSpec].
/// Use the methods of this class to configure specific properties of a [SelectTriggerSpec].
class SelectTriggerSpecUtility<T extends SpecAttribute>
    extends SpecUtility<T, SelectTriggerSpecAttribute> {
  /// Utility for defining [SelectTriggerSpecAttribute.container]
  late final container = FlexBoxSpecUtility((v) => only(container: v));

  /// Utility for defining [SelectTriggerSpecAttribute.icon]
  late final icon = IconThemeDataUtility((v) => only(icon: v));

  /// Utility for defining [SelectTriggerSpecAttribute.label]
  late final label = TextSpecUtility((v) => only(label: v));

  /// Utility for defining [SelectTriggerSpecAttribute.modifiers]
  late final wrap = SpecModifierUtility((v) => only(modifiers: v));

  /// Utility for defining [SelectTriggerSpecAttribute.animated]
  late final animated = AnimatedUtility((v) => only(animated: v));

  SelectTriggerSpecUtility(
    super.builder, {
    @Deprecated(
      'mutable parameter is no longer used. All SpecUtilities are now mutable by default.',
    )
    super.mutable,
  });

  @Deprecated(
    'Use "this" instead of "chain" for method chaining. '
    'The chain getter will be removed in a future version.',
  )
  SelectTriggerSpecUtility<T> get chain =>
      SelectTriggerSpecUtility(attributeBuilder);

  static SelectTriggerSpecUtility<SelectTriggerSpecAttribute> get self =>
      SelectTriggerSpecUtility((v) => v);

  /// Returns a new [SelectTriggerSpecAttribute] with the specified properties.
  @override
  T only({
    FlexBoxSpecAttribute? container,
    IconThemeDataDto? icon,
    TextSpecAttribute? label,
    WidgetModifiersConfigDto? modifiers,
    AnimatedDataDto? animated,
  }) {
    return builder(SelectTriggerSpecAttribute(
      container: container,
      icon: icon,
      label: label,
      modifiers: modifiers,
      animated: animated,
    ));
  }
}

/// A tween that interpolates between two [SelectTriggerSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [SelectTriggerSpec] specifications.
class SelectTriggerSpecTween extends Tween<SelectTriggerSpec?> {
  SelectTriggerSpecTween({
    super.begin,
    super.end,
  });

  @override
  SelectTriggerSpec lerp(double t) {
    if (begin == null && end == null) {
      return const SelectTriggerSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}
