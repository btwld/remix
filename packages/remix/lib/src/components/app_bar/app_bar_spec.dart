part of 'app_bar.dart';

/// Resolved visual values for a [RemixAppBar].
///
/// Unset dimensions default at render time to a 56 logical pixel toolbar
/// height and zero spacing.
@MixableSpec(target: RemixAppBar.new, extraStylerMixins: [RemixBoxStylerMixin])
@immutable
final class AppBarSpec with _$AppBarSpec {
  /// Surface style for the entire bar, including color, border, and decoration.
  ///
  /// When [RemixAppBar.safeArea] is `true`, this surface paints behind the top
  /// inset. Container padding applies inside that inset.
  @override
  @MixableField(forwardStyler: true)
  final StyleSpec<BoxSpec> container;

  /// Layout and decoration style for the toolbar row.
  ///
  /// This style typically defines horizontal padding for the leading widget,
  /// title, and actions.
  @override
  final StyleSpec<BoxSpec> toolbar;

  /// Text style for the title.
  ///
  /// This style also provides the default text style for [RemixAppBar.titleChild].
  /// Titles truncate to a single line with an ellipsis unless this style sets
  /// [TextSpec.maxLines].
  @override
  final StyleSpec<TextSpec> title;

  /// Layout style for the actions row.
  ///
  /// The row direction is always horizontal with minimal main-axis size. Use
  /// this style to configure spacing and alignment for action items.
  @override
  final StyleSpec<FlexBoxSpec> actions;

  /// Layout and decoration style for optional bottom content.
  ///
  /// [RemixAppBar] resolves this style even when [RemixAppBar.bottom] is `null`.
  @override
  final StyleSpec<BoxSpec> bottom;

  /// Height of the toolbar row, including [toolbar] padding.
  ///
  /// When `null`, [RemixAppBar] uses a default height of 56 logical pixels.
  @override
  final double? toolbarHeight;

  /// Horizontal spacing between the leading widget, title, and actions.
  ///
  /// Spacing applies only between slots that contain widgets.
  @override
  final double? spacing;

  /// Creates an [AppBarSpec].
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
