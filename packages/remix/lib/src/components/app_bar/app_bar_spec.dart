part of 'app_bar.dart';

/// Resolved visual values for a [RemixAppBar].
///
/// Geometry scalars stay null here. [RemixAppBar] falls back to a 56 logical
/// pixel toolbar and no gaps at render time; presets set their own metrics.
@MixableSpec(target: RemixAppBar.new, extraStylerMixins: [RemixBoxStylerMixin])
@immutable
final class AppBarSpec with _$AppBarSpec {
  /// Surface behind the whole bar: color, border, and decoration.
  ///
  /// It paints under the top inset when [RemixAppBar.safeArea] is true, so
  /// its padding applies inside the inset rather than replacing it.
  @override
  @MixableField(forwardStyler: true)
  final StyleSpec<BoxSpec> container;

  /// Layout around the leading, title, and actions row, typically the
  /// horizontal inset of its content.
  @override
  final StyleSpec<BoxSpec> toolbar;

  /// Typography for the title.
  ///
  /// Also the default text style for a custom title widget. A title stays on
  /// one line with an ellipsis unless this sets [TextSpec.maxLines].
  @override
  final StyleSpec<TextSpec> title;

  /// Layout for the actions row. Its direction and main-axis size are always
  /// horizontal and minimal; use it for spacing and alignment.
  @override
  final StyleSpec<FlexBoxSpec> actions;

  /// Layout and decoration around the optional bottom content.
  ///
  /// Resolved but unused when the bar has no bottom content.
  @override
  final StyleSpec<BoxSpec> bottom;

  /// Height of the toolbar row, including the [toolbar] padding.
  @override
  final double? toolbarHeight;

  /// Gap between the leading widget, the title, and the actions.
  ///
  /// Applies only between parts that are present.
  @override
  final double? spacing;

  const AppBarSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<BoxSpec>? toolbar,
    StyleSpec<TextSpec>? title,
    StyleSpec<FlexBoxSpec>? actions,
    StyleSpec<BoxSpec>? bottom,
    this.toolbarHeight,
    this.spacing,
  }) : container = container ?? const StyleSpec(spec: BoxSpec()),
       toolbar = toolbar ?? const StyleSpec(spec: BoxSpec()),
       title = title ?? const StyleSpec(spec: TextSpec()),
       actions = actions ?? const StyleSpec(spec: FlexBoxSpec()),
       bottom = bottom ?? const StyleSpec(spec: BoxSpec());
}
