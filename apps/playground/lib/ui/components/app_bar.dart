import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/tokens.dart';

part 'app_bar.g.dart';

/// Height of the toolbar row, including its bottom hairline. The sidebar
/// brand row uses it to line up with the app bar.
const playgroundAppBarToolbarHeight = PlaygroundTokens.s16;

/// The application's AppBar recipe: a `background` surface over a toolbar row
/// with a bottom hairline and a semibold `textLg` title.
///
/// [style] merges last:
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
