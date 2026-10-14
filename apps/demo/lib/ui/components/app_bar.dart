import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';
import 'text.dart';

part 'app_bar.g.dart';

/// Creates the default [AppBarStyler] for the Fortal app bar.
///
/// Configures a solid panel surface, a `space9` toolbar height with an inset
/// bottom border, `space4` horizontal padding, and bold `size4` title
/// typography.
///
/// Merges [style] after the default styling to allow caller overrides.
@MixWidget(target: RemixAppBar.new)
AppBarStyler fortalAppBarStyle({
  AppBarStyler style = const AppBarStyler.create(),
}) => AppBarStyler(
  container: BoxStyler().color(FortalTokens.colorPanelSolid()),
  toolbar: BoxStyler()
      .padding(.horizontal(FortalTokens.space4()))
      .border(
        .bottom(
          .color(FortalTokens.grayA6()).width(FortalTokens.borderWidth1()),
        ),
      ),
  title: fortalTextStyle(size: .size4, weight: .bold),
  actions: FlexBoxStyler().spacing(FortalTokens.space3()),
  toolbarHeight: FortalTokens.space9(),
  spacing: FortalTokens.space3(),
).merge(style);
