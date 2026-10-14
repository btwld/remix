import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/tokens.dart';

part 'app_bar.g.dart';

/// The height of the Vanilla app bar toolbar row, including its bottom hairline.
///
/// Adjacent components that align with the app bar, such as the sidebar brand
/// row, use this value.
const vanillaAppBarToolbarHeight = VanillaTokens.s16;

/// Creates the default [AppBarStyler] for the Vanilla app bar.
///
/// Configures a `background` surface, a [vanillaAppBarToolbarHeight] toolbar row
/// with an inset bottom hairline border, horizontal padding, semibold `textLg`
/// title text, and 12px spacing between elements.
///
/// Merges [style] after the default styling to allow caller overrides:
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
