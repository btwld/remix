import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';
import 'text.dart';

part 'app_bar.g.dart';

/// Creates the default [AppBarStyler] for the Ui app bar.
///
/// Configures a solid panel surface, a `space9` toolbar height with an inset
/// bottom border, `space4` horizontal padding, and bold `size4` title
/// typography.
///
/// Merges [style] after the default styling to allow caller overrides.
@MixWidget(target: RemixAppBar.new)
AppBarStyler uiAppBarStyle({
  AppBarStyler style = const AppBarStyler.create(),
}) => AppBarStyler(
  container: BoxStyler().color(UiTokens.colorPanelSolid()),
  toolbar: BoxStyler()
      .padding(.horizontal(UiTokens.space4()))
      .border(
        .bottom(.color(UiTokens.grayA6()).width(UiTokens.borderWidth1())),
      ),
  title: uiTextStyle(size: .size4, weight: .bold),
  actions: FlexBoxStyler().spacing(UiTokens.space3()),
  toolbarHeight: UiTokens.space9(),
  spacing: UiTokens.space3(),
).merge(style);
