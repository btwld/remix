// `TextInputAction` appears in the generated HeroUiSearchField constructor,
// so it must be visible from this library.
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../theme/theme.dart';
import 'close_button.dart';
import 'textfield.dart';

part 'search_field.g.dart';

/// HeroUI recipe for [RemixTextField] as a search field.
///
/// Pass [HeroUiSearchIcon] as `leading` and [HeroUiSearchClearButton] as
/// `trailing`. The group is a fixed `h-9` row with the icon `ms-3`, the input
/// `px-2` beside each accessory, and the clear button `me-2`.
@MixWidget(
  target: RemixTextField.new,
  widgetParameters: .only({
    'controller',
    'focusNode',
    'label',
    'hintText',
    'helperText',
    'error',
    'keyboardType',
    'textInputAction',
    'enabled',
    'readOnly',
    'autofocus',
    'onChanged',
    'onEditingComplete',
    'onSubmitted',
    'onTap',
    'onTapOutside',
    'autofillHints',
    'leading',
    'trailing',
    'semanticLabel',
    'semanticHint',
    'excludeSemantics',
  }),
)
TextFieldStyler heroUiSearchFieldStyle({
  HeroUiTextFieldVariant variant = .primary,
  TextFieldStyler style = const TextFieldStyler.create(),
}) => heroUiTextFieldStyle(variant: variant)
    .height(_height)
    .padding(.vertical(0))
    .padding(.right(_trailingInset))
    .spacing(_accessoryGap)
    .merge(style);

/// HeroUI recipe for the clear button of a [HeroUiSearchField]: the close
/// button at `size-5` with a `size-3` icon.
///
/// The app decides when it shows and what its `onPressed` clears; HeroUI
/// hides it while the field is empty.
@MixWidget(target: RemixIconButton.new)
IconButtonStyler heroUiSearchClearButtonStyle({
  IconData? icon = RemixIcons.close,
  String semanticLabel = 'Clear search',
  IconButtonStyler style = const IconButtonStyler.create(),
}) => heroUiCloseButtonStyle()
    .size(_clearSize, _clearSize)
    .icon(.size(_clearIconSize))
    .merge(style);

/// The search glyph of a [HeroUiSearchField], `size-4` in the placeholder color.
class HeroUiSearchIcon extends StatelessWidget {
  const HeroUiSearchIcon({super.key});

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: StyledIcon(
      icon: RemixIcons.search,
      style: IconStyler()
          .size(_iconSize)
          .color(HeroUiTokens.fieldPlaceholder()),
    ),
  );
}

/// `.search-field__group`: `h-9`; `.search-field__search-icon`: `size-4`.
const _height = 36.0;
const _iconSize = 16.0;

/// The input's `ps-2` and `pe-2` beside the icon and the clear button.
const _accessoryGap = 8.0;

/// `.search-field__clear-button`: `me-2`.
const _trailingInset = 8.0;

/// `.search-field__clear-button`: `size-5`, its icon `size-3`.
const _clearSize = 20.0;
const _clearIconSize = 12.0;
