// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'switch_spec.dart';

// **************************************************************************
// MixableSpecGenerator
// **************************************************************************

// ignore_for_file: deprecated_member_use_from_same_package

base mixin _$SwitchSpec on Spec<SwitchSpec> {
  static SwitchSpec from(MixData mix) {
    return mix.attributeOf<SwitchSpecAttribute>()?.resolve(mix) ??
        const SwitchSpec();
  }

  /// {@template switch_spec_of}
  /// Retrieves the [SwitchSpec] from the nearest [Mix] ancestor in the widget tree.
  ///
  /// This method uses [Mix.of] to obtain the [Mix] instance associated with the
  /// given [BuildContext], and then retrieves the [SwitchSpec] from that [Mix].
  /// If no ancestor [Mix] is found, this method returns an empty [SwitchSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final switchSpec = SwitchSpec.of(context);
  /// ```
  /// {@endtemplate}
  static SwitchSpec of(BuildContext context) {
    return _$SwitchSpec.from(Mix.of(context));
  }

  /// Creates a copy of this [SwitchSpec] but with the given fields
  /// replaced with the new values.
  @override
  SwitchSpec copyWith({
    BoxSpec? container,
    BoxSpec? indicator,
    AnimatedData? animated,
  }) {
    return SwitchSpec(
      container: container ?? _$this.container,
      indicator: indicator ?? _$this.indicator,
      animated: animated ?? _$this.animated,
    );
  }

  /// Linearly interpolates between this [SwitchSpec] and another [SwitchSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [SwitchSpec] is returned. When [t] is 1.0, the [other] [SwitchSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [SwitchSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [SwitchSpec] instance.
  ///
  /// The interpolation is performed on each property of the [SwitchSpec] using the appropriate
  /// interpolation method:
  ///
  /// - [BoxSpec.lerp] for [container] and [indicator].

  /// For [animated], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [SwitchSpec] is used. Otherwise, the value
  /// from the [other] [SwitchSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [SwitchSpec] configurations.
  @override
  SwitchSpec lerp(SwitchSpec? other, double t) {
    if (other == null) return _$this;

    return SwitchSpec(
      container: _$this.container.lerp(other.container, t),
      indicator: _$this.indicator.lerp(other.indicator, t),
      animated: t < 0.5 ? _$this.animated : other.animated,
    );
  }

  /// The list of properties that constitute the state of this [SwitchSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [SwitchSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.container,
        _$this.indicator,
        _$this.animated,
      ];

  SwitchSpec get _$this => this as SwitchSpec;
}

/// Represents the attributes of a [SwitchSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [SwitchSpec].
///
/// Use this class to configure the attributes of a [SwitchSpec] and pass it to
/// the [SwitchSpec] constructor.
final class SwitchSpecAttribute extends SpecAttribute<SwitchSpec> {
  final BoxSpecAttribute? container;
  final BoxSpecAttribute? indicator;

  const SwitchSpecAttribute({
    this.container,
    this.indicator,
    super.animated,
  });

  /// Resolves to [SwitchSpec] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final switchSpec = SwitchSpecAttribute(...).resolve(mix);
  /// ```
  @override
  SwitchSpec resolve(MixData mix) {
    return SwitchSpec(
      container: container?.resolve(mix),
      indicator: indicator?.resolve(mix),
      animated: animated?.resolve(mix) ?? mix.animation,
    );
  }

  /// Merges the properties of this [SwitchSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [SwitchSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  SwitchSpecAttribute merge(covariant SwitchSpecAttribute? other) {
    if (other == null) return this;

    return SwitchSpecAttribute(
      container: container?.merge(other.container) ?? other.container,
      indicator: indicator?.merge(other.indicator) ?? other.indicator,
      animated: animated?.merge(other.animated) ?? other.animated,
    );
  }

  /// The list of properties that constitute the state of this [SwitchSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [SwitchSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
        container,
        indicator,
        animated,
      ];
}

/// Utility class for configuring [SwitchSpecAttribute] properties.
///
/// This class provides methods to set individual properties of a [SwitchSpecAttribute].
/// Use the methods of this class to configure specific properties of a [SwitchSpecAttribute].
base class SwitchSpecUtility<T extends Attribute>
    extends SpecUtility<T, SwitchSpecAttribute> {
  /// Utility for defining [SwitchSpecAttribute.container]
  late final container = BoxSpecUtility((v) => only(container: v));

  /// Utility for defining [SwitchSpecAttribute.indicator]
  late final indicator = BoxSpecUtility((v) => only(indicator: v));

  /// Utility for defining [SwitchSpecAttribute.animated]
  late final animated = AnimatedUtility((v) => only(animated: v));

  SwitchSpecUtility(super.builder);

  static final self = SwitchSpecUtility((v) => v);

  /// Returns a new [SwitchSpecAttribute] with the specified properties.
  @override
  T only({
    BoxSpecAttribute? container,
    BoxSpecAttribute? indicator,
    AnimatedDataDto? animated,
  }) {
    return builder(SwitchSpecAttribute(
      container: container,
      indicator: indicator,
      animated: animated,
    ));
  }
}

/// A tween that interpolates between two [SwitchSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [SwitchSpec] specifications.
class SwitchSpecTween extends Tween<SwitchSpec?> {
  SwitchSpecTween({
    super.begin,
    super.end,
  });

  @override
  SwitchSpec lerp(double t) {
    if (begin == null && end == null) return const SwitchSpec();
    if (begin == null) return end!;

    return begin!.lerp(end!, t);
  }
}
