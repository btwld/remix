import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';
import 'text.dart';

part 'app_bar.g.dart';

/// Ui-themed preset for [RemixAppBar].
///
/// The recipe paints the solid panel surface, sets the toolbar row to the
/// `space9` token (64 logical pixels at 100% scaling) including a bottom edge
/// border, insets it by `space4`, and separates the leading button, the
/// title, and the actions by `space3`. The title uses the bold `size4` text
/// step.
///
/// The edge belongs to the row rather than the surface so it sits inside the
/// row height instead of adding a pixel below it. Anything built the same way
/// beside the bar, such as a sidebar's brand row with a `space9` height and
/// the same edge, lines up with it under every Ui scaling setting.
/// Content in the bar's `bottom` slot brings its own edge.
///
/// App bar is a Ui extension, not a Radix Themes parity family.
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
