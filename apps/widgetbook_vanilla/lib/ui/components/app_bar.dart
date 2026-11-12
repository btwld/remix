import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/tokens.dart';

part 'app_bar.g.dart';

/// Height of the toolbar row, including its bottom hairline. The sidebar
/// brand row uses it to line up with the app bar.
const vanillaAppBarToolbarHeight = VanillaTokens.s16;

/// The application's AppBar recipe: a `background` surface over a toolbar row
/// with a bottom hairline and a semibold `textLg` title.
///
/// [style] merges last:
///
/// ```dart
/// VanillaAppBar(
///   style: AppBarStyler().toolbarHeight(VanillaTokens.s12),
///   title: 'Orders',
/// )
/// ```
@MixWidget(target: RemixAppBar.new)
AppBarStyler vanillaAppBarStyle({
  AppBarStyler style = const AppBarStyler.create(),
}) => AppBarStyler(
  container: BoxStyler().color(VanillaTokens.background()),
  toolbar: BoxStyler()
      .padding(.horizontal(VanillaTokens.s4))
      .border(
        .bottom(
          .color(VanillaTokens.border()).width(VanillaTokens.strokeHairline),
        ),
      ),
  title: TextStyler()
      .style(VanillaTokens.textLg.mix())
      .fontWeight(FontWeight.w600)
      .color(VanillaTokens.foreground()),
  actions: FlexBoxStyler().spacing(VanillaTokens.s3),
  toolbarHeight: vanillaAppBarToolbarHeight,
  spacing: VanillaTokens.s3,
).merge(style);
