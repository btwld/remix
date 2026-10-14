import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/tokens.dart';

part 'app_bar.g.dart';

/// The height of the Playground app bar toolbar row, including its bottom hairline.
///
/// Adjacent components that align with the app bar, such as the sidebar brand
/// row, use this value.
const playgroundAppBarToolbarHeight = PlaygroundTokens.s16;

/// Creates the default [AppBarStyler] for the Playground app bar.
///
/// Configures a `background` surface, a [playgroundAppBarToolbarHeight] toolbar row
/// with an inset bottom hairline border, horizontal padding, semibold `textLg`
/// title text, and 12px spacing between elements.
///
/// Merges [style] after the default styling to allow caller overrides:
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
