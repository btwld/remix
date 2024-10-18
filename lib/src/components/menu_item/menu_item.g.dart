// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_item.dart';

// **************************************************************************
// MixableSpecGenerator
// **************************************************************************

mixin _$MenuItemSpec on Spec<MenuItemSpec> {
  static MenuItemSpec from(MixData mix) {
    return mix.attributeOf<MenuItemSpecAttribute>()?.resolve(mix) ??
        const MenuItemSpec();
  }

  /// {@template menu_item_spec_of}
  /// Retrieves the [MenuItemSpec] from the nearest [Mix] ancestor in the widget tree.
  ///
  /// This method uses [Mix.of] to obtain the [Mix] instance associated with the
  /// given [BuildContext], and then retrieves the [MenuItemSpec] from that [Mix].
  /// If no ancestor [Mix] is found, this method returns an empty [MenuItemSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final menuItemSpec = MenuItemSpec.of(context);
  /// ```
  /// {@endtemplate}
  static MenuItemSpec of(BuildContext context) {
    return _$MenuItemSpec.from(Mix.of(context));
  }

  /// Creates a copy of this [MenuItemSpec] but with the given fields
  /// replaced with the new values.
  @override
  MenuItemSpec copyWith({
    BoxSpec? outerContainer,
    FlexSpec? contentLayout,
    FlexSpec? titleSubtitleLayout,
    IconSpec? icon,
    TextSpec? title,
    TextSpec? subtitle,
    WidgetModifiersData? modifiers,
    AnimatedData? animated,
  }) {
    return MenuItemSpec(
      outerContainer: outerContainer ?? _$this.outerContainer,
      contentLayout: contentLayout ?? _$this.contentLayout,
      titleSubtitleLayout: titleSubtitleLayout ?? _$this.titleSubtitleLayout,
      icon: icon ?? _$this.icon,
      title: title ?? _$this.title,
      subtitle: subtitle ?? _$this.subtitle,
      modifiers: modifiers ?? _$this.modifiers,
      animated: animated ?? _$this.animated,
    );
  }

  /// Linearly interpolates between this [MenuItemSpec] and another [MenuItemSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [MenuItemSpec] is returned. When [t] is 1.0, the [other] [MenuItemSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [MenuItemSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [MenuItemSpec] instance.
  ///
  /// The interpolation is performed on each property of the [MenuItemSpec] using the appropriate
  /// interpolation method:
  ///
  /// - [BoxSpec.lerp] for [outerContainer].
  /// - [FlexSpec.lerp] for [contentLayout] and [titleSubtitleLayout].
  /// - [IconSpec.lerp] for [icon].
  /// - [TextSpec.lerp] for [title] and [subtitle].

  /// For [modifiers] and [animated], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [MenuItemSpec] is used. Otherwise, the value
  /// from the [other] [MenuItemSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [MenuItemSpec] configurations.
  @override
  MenuItemSpec lerp(MenuItemSpec? other, double t) {
    if (other == null) return _$this;

    return MenuItemSpec(
      outerContainer: _$this.outerContainer.lerp(other.outerContainer, t),
      contentLayout: _$this.contentLayout.lerp(other.contentLayout, t),
      titleSubtitleLayout:
          _$this.titleSubtitleLayout.lerp(other.titleSubtitleLayout, t),
      icon: _$this.icon.lerp(other.icon, t),
      title: _$this.title.lerp(other.title, t),
      subtitle: _$this.subtitle.lerp(other.subtitle, t),
      modifiers: other.modifiers,
      animated: t < 0.5 ? _$this.animated : other.animated,
    );
  }

  /// The list of properties that constitute the state of this [MenuItemSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [MenuItemSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.outerContainer,
        _$this.contentLayout,
        _$this.titleSubtitleLayout,
        _$this.icon,
        _$this.title,
        _$this.subtitle,
        _$this.modifiers,
        _$this.animated,
      ];

  MenuItemSpec get _$this => this as MenuItemSpec;

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(DiagnosticsProperty('outerContainer', _$this.outerContainer,
        defaultValue: null));
    properties.add(DiagnosticsProperty('contentLayout', _$this.contentLayout,
        defaultValue: null));
    properties.add(DiagnosticsProperty(
        'titleSubtitleLayout', _$this.titleSubtitleLayout,
        defaultValue: null));
    properties
        .add(DiagnosticsProperty('icon', _$this.icon, defaultValue: null));
    properties
        .add(DiagnosticsProperty('title', _$this.title, defaultValue: null));
    properties.add(
        DiagnosticsProperty('subtitle', _$this.subtitle, defaultValue: null));
    properties.add(
        DiagnosticsProperty('modifiers', _$this.modifiers, defaultValue: null));
    properties.add(
        DiagnosticsProperty('animated', _$this.animated, defaultValue: null));
  }
}

/// Represents the attributes of a [MenuItemSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [MenuItemSpec].
///
/// Use this class to configure the attributes of a [MenuItemSpec] and pass it to
/// the [MenuItemSpec] constructor.
class MenuItemSpecAttribute extends SpecAttribute<MenuItemSpec>
    with Diagnosticable {
  final BoxSpecAttribute? outerContainer;
  final FlexSpecAttribute? contentLayout;
  final FlexSpecAttribute? titleSubtitleLayout;
  final IconSpecAttribute? icon;
  final TextSpecAttribute? title;
  final TextSpecAttribute? subtitle;

  const MenuItemSpecAttribute({
    this.outerContainer,
    this.contentLayout,
    this.titleSubtitleLayout,
    this.icon,
    this.title,
    this.subtitle,
    super.modifiers,
    super.animated,
  });

  /// Resolves to [MenuItemSpec] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final menuItemSpec = MenuItemSpecAttribute(...).resolve(mix);
  /// ```
  @override
  MenuItemSpec resolve(MixData mix) {
    return MenuItemSpec(
      outerContainer: outerContainer?.resolve(mix),
      contentLayout: contentLayout?.resolve(mix),
      titleSubtitleLayout: titleSubtitleLayout?.resolve(mix),
      icon: icon?.resolve(mix),
      title: title?.resolve(mix),
      subtitle: subtitle?.resolve(mix),
      modifiers: modifiers?.resolve(mix),
      animated: animated?.resolve(mix) ?? mix.animation,
    );
  }

  /// Merges the properties of this [MenuItemSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [MenuItemSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  MenuItemSpecAttribute merge(covariant MenuItemSpecAttribute? other) {
    if (other == null) return this;

    return MenuItemSpecAttribute(
      outerContainer:
          outerContainer?.merge(other.outerContainer) ?? other.outerContainer,
      contentLayout:
          contentLayout?.merge(other.contentLayout) ?? other.contentLayout,
      titleSubtitleLayout:
          titleSubtitleLayout?.merge(other.titleSubtitleLayout) ??
              other.titleSubtitleLayout,
      icon: icon?.merge(other.icon) ?? other.icon,
      title: title?.merge(other.title) ?? other.title,
      subtitle: subtitle?.merge(other.subtitle) ?? other.subtitle,
      modifiers: modifiers?.merge(other.modifiers) ?? other.modifiers,
      animated: animated?.merge(other.animated) ?? other.animated,
    );
  }

  /// The list of properties that constitute the state of this [MenuItemSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [MenuItemSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
        outerContainer,
        contentLayout,
        titleSubtitleLayout,
        icon,
        title,
        subtitle,
        modifiers,
        animated,
      ];

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('outerContainer', outerContainer,
        defaultValue: null));
    properties.add(DiagnosticsProperty('contentLayout', contentLayout,
        defaultValue: null));
    properties.add(DiagnosticsProperty(
        'titleSubtitleLayout', titleSubtitleLayout,
        defaultValue: null));
    properties.add(DiagnosticsProperty('icon', icon, defaultValue: null));
    properties.add(DiagnosticsProperty('title', title, defaultValue: null));
    properties
        .add(DiagnosticsProperty('subtitle', subtitle, defaultValue: null));
    properties
        .add(DiagnosticsProperty('modifiers', modifiers, defaultValue: null));
    properties
        .add(DiagnosticsProperty('animated', animated, defaultValue: null));
  }
}

/// Utility class for configuring [MenuItemSpec] properties.
///
/// This class provides methods to set individual properties of a [MenuItemSpec].
/// Use the methods of this class to configure specific properties of a [MenuItemSpec].
class MenuItemSpecUtility<T extends Attribute>
    extends SpecUtility<T, MenuItemSpecAttribute> {
  /// Utility for defining [MenuItemSpecAttribute.outerContainer]
  late final outerContainer = BoxSpecUtility((v) => only(outerContainer: v));

  /// Utility for defining [MenuItemSpecAttribute.contentLayout]
  late final contentLayout = FlexSpecUtility((v) => only(contentLayout: v));

  /// Utility for defining [MenuItemSpecAttribute.titleSubtitleLayout]
  late final titleSubtitleLayout =
      FlexSpecUtility((v) => only(titleSubtitleLayout: v));

  /// Utility for defining [MenuItemSpecAttribute.icon]
  late final icon = IconSpecUtility((v) => only(icon: v));

  /// Utility for defining [MenuItemSpecAttribute.title]
  late final title = TextSpecUtility((v) => only(title: v));

  /// Utility for defining [MenuItemSpecAttribute.subtitle]
  late final subtitle = TextSpecUtility((v) => only(subtitle: v));

  /// Utility for defining [MenuItemSpecAttribute.modifiers]
  late final wrap = SpecModifierUtility((v) => only(modifiers: v));

  /// Utility for defining [MenuItemSpecAttribute.animated]
  late final animated = AnimatedUtility((v) => only(animated: v));

  MenuItemSpecUtility(super.builder, {super.mutable});

  MenuItemSpecUtility<T> get chain =>
      MenuItemSpecUtility(attributeBuilder, mutable: true);

  static MenuItemSpecUtility<MenuItemSpecAttribute> get self =>
      MenuItemSpecUtility((v) => v);

  /// Returns a new [MenuItemSpecAttribute] with the specified properties.
  @override
  T only({
    BoxSpecAttribute? outerContainer,
    FlexSpecAttribute? contentLayout,
    FlexSpecAttribute? titleSubtitleLayout,
    IconSpecAttribute? icon,
    TextSpecAttribute? title,
    TextSpecAttribute? subtitle,
    WidgetModifiersDataDto? modifiers,
    AnimatedDataDto? animated,
  }) {
    return builder(MenuItemSpecAttribute(
      outerContainer: outerContainer,
      contentLayout: contentLayout,
      titleSubtitleLayout: titleSubtitleLayout,
      icon: icon,
      title: title,
      subtitle: subtitle,
      modifiers: modifiers,
      animated: animated,
    ));
  }
}

/// A tween that interpolates between two [MenuItemSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [MenuItemSpec] specifications.
class MenuItemSpecTween extends Tween<MenuItemSpec?> {
  MenuItemSpecTween({
    super.begin,
    super.end,
  });

  @override
  MenuItemSpec lerp(double t) {
    if (begin == null && end == null) {
      return const MenuItemSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}
