import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/tokens.dart';

part 'app_bar.g.dart';

/// The app bar's toolbar row height, 64px, including its bottom hairline.
///
/// Anything that has to line up with the bar, such as a sidebar's brand row
/// beside it, reads this value. It lives here rather than in the theme so
/// installing `app_bar` never requires reinstalling `theme`.
const playgroundAppBarToolbarHeight = PlaygroundTokens.s16;

/// The application's App Bar recipe.
///
/// An app bar is the row across the top of a page: an optional Back or menu
/// button, the page title, and the page's actions. Remix owns the layout, the
/// heading semantics, and the top safe area; this recipe owns the surface,
/// the row height, the insets, and the title type.
///
/// It takes no variant and no size. The bar is the `background` surface. Its
/// toolbar row is [playgroundAppBarToolbarHeight] (64px) tall including a `border`
/// hairline along its bottom edge, inset 16px from both sides, with a 12px
/// gap between the leading button, the title, and the actions, and between
/// the actions themselves. The title is `textLg` at semibold weight in
/// `foreground`.
///
/// The hairline belongs to the row rather than the surface so it sits inside
/// the 64px, as CSS's `h-16 border-b` does, instead of adding a pixel below
/// it. That keeps the bar exactly as tall as anything built the same way
/// beside it, such as a sidebar's brand row with the same height and edge.
/// Content in the bar's `bottom` slot brings its own edge.
///
/// [style] is merged **last**, so a single call site can override any part of
/// the resolved recipe without forking it:
///
/// ```dart
/// PlaygroundAppBar(
///   style: AppBarStyler().toolbarHeight(PlaygroundTokens.s12),
///   title: 'Orders',
/// )
/// ```
@MixWidget(target: RemixAppBar.new)
AppBarStyler playgroundAppBarStyle({
  AppBarStyler style = const AppBarStyler.create(),
}) => AppBarStyler(
  container: BoxStyler().color(PlaygroundTokens.background()),
  toolbar: BoxStyler()
      .padding(.horizontal(PlaygroundTokens.s4))
      .border(
        .bottom(
          .color(
            PlaygroundTokens.border(),
          ).width(PlaygroundTokens.strokeHairline),
        ),
      ),
  title: TextStyler()
      .style(PlaygroundTokens.textLg.mix())
      .fontWeight(FontWeight.w600)
      .color(PlaygroundTokens.foreground()),
  actions: FlexBoxStyler().spacing(PlaygroundTokens.s3),
  toolbarHeight: playgroundAppBarToolbarHeight,
  spacing: PlaygroundTokens.s3,
).merge(style);
