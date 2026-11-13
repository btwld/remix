/// Vanilla: the compact default preset theme and widget catalog for Remix.
///
/// Vanilla is built on [package:remix](https://pub.dev/packages/remix). It adds
/// a token scope ([VanillaTheme]), the `vanilla*Style()` recipes, and a
/// matching catalog of ready-made `Vanilla*` widgets. It does not re-export
/// `remix`; add `package:remix/remix.dart` alongside this import when you need
/// the base widgets or stylers.
library;

/// ICONS
export 'src/default/icons.dart';

/// THEME
export 'src/default/theme/effects.dart';
export 'src/default/theme/theme_data.dart';
export 'src/default/theme/theme_scope.dart';
export 'src/default/theme/tokens.dart';

/// RECIPES
export 'src/default/components/accordion.dart';
export 'src/default/components/app_bar.dart';
export 'src/default/components/avatar.dart';
export 'src/default/components/badge.dart';
export 'src/default/components/button.dart';
export 'src/default/components/callout.dart';
export 'src/default/components/card.dart';
export 'src/default/components/chart.dart';
export 'src/default/components/checkbox.dart';
export 'src/default/components/combobox.dart';
export 'src/default/components/data_list.dart';
export 'src/default/components/data_table.dart';
export 'src/default/components/dialog.dart';
export 'src/default/components/disclosure.dart';
export 'src/default/components/divider.dart';
export 'src/default/components/icon_button.dart';
export 'src/default/components/link.dart';
export 'src/default/components/menu.dart';
export 'src/default/components/popover.dart';
export 'src/default/components/progress.dart';
export 'src/default/components/radio.dart';
export 'src/default/components/range_slider.dart';
export 'src/default/components/segmented_control.dart';
export 'src/default/components/select.dart';
export 'src/default/components/sidebar.dart';
export 'src/default/components/sidebar_layout.dart';
export 'src/default/components/skeleton.dart';
export 'src/default/components/slider.dart';
export 'src/default/components/spinner.dart';
export 'src/default/components/switch.dart';
export 'src/default/components/tabs.dart';
export 'src/default/components/textfield.dart';
export 'src/default/components/toast.dart';
export 'src/default/components/toggle.dart';
export 'src/default/components/toggle_group.dart';
export 'src/default/components/tooltip.dart';

export 'src/default/components/calendar.dart';
export 'src/default/components/range_calendar.dart';
export 'src/default/components/date_picker.dart';
export 'src/default/components/date_range_picker.dart';

/// AGENT RECIPES
export 'src/default/recipes/agent_glyphs_recipe.dart';
export 'src/default/recipes/answer_recipe.dart';
export 'src/default/recipes/composer_recipe.dart';
export 'src/default/recipes/conversation_recipe.dart';
export 'src/default/recipes/message_recipe.dart';
export 'src/default/recipes/sources_recipe.dart';
export 'src/default/recipes/steps_recipe.dart';
export 'src/default/recipes/suggestions_recipe.dart';
export 'src/default/recipes/tool_call_recipe.dart';
