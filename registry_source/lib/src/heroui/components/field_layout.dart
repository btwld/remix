import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

/// `.label`, `text-danger` inside an invalid field.
TextStyler _label({required bool invalid}) =>
    invalid ? heroUiLabelText.color(HeroUiTokens.danger()) : heroUiLabelText;

/// A group's [label] and [items], its [helperText] description, and its
/// [errorText].
///
/// Vertically they stack with `mt-4` before each item, as the CSS gives each
/// radio and checkbox; the description follows the last item, then the error.
/// Upstream lays a horizontal group out as one wrapping row, label and help
/// included, and so does this.
///
/// While [invalid] the label turns danger and [errorText] shows beside the
/// description, which stays (`radio-group.css` has no hide rule).
class HeroUiFieldLayout extends StatelessWidget {
  const HeroUiFieldLayout({
    super.key,
    required this.items,
    this.axis = Axis.vertical,
    this.label,
    this.helperText,
    this.errorText,
    this.invalid = false,
    this.enabled = true,
  });

  final List<Widget> items;
  final Axis axis;
  final String? label;
  final String? helperText;
  final String? errorText;
  final bool invalid;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final labelStyle = _label(invalid: invalid);
    final labelText = label == null
        ? null
        : StyledText(
            label!,
            // `[data-disabled] .label` is `status-disabled`.
            style: enabled
                ? labelStyle
                : labelStyle.wrap(.opacity(HeroUiTokens.disabledOpacity)),
          );
    final description = helperText == null
        ? null
        : StyledText(helperText!, style: heroUiDescriptionText);
    final error = invalid && errorText != null
        ? StyledText(errorText!, style: heroUiErrorText)
        : null;

    if (axis == Axis.horizontal) {
      return Wrap(
        spacing: _groupGap,
        runSpacing: _groupGap,
        children: [?labelText, ...items, ?description, ?error],
      );
    }
    return FlexBox(
      style: FlexBoxStyler()
          .direction(.vertical)
          .mainAxisSize(.min)
          .crossAxisAlignment(.start),
      children: [
        ?labelText,
        for (var i = 0; i < items.length; i++)
          Box(
            style: BoxStyler().padding(
              .top(i == 0 && labelText == null ? 0 : _groupGap),
            ),
            child: items[i],
          ),
        ?description,
        ?error,
      ],
    );
  }
}

/// A labeled radio or switch with an optional [description] beneath.
///
/// [descriptionInset] indents the description under the label: the control's
/// width plus its label gap. The control dims itself and its label when
/// disabled; this dims the description.
class HeroUiDescribedControl extends StatelessWidget {
  const HeroUiDescribedControl({
    super.key,
    required this.control,
    required this.descriptionInset,
    this.description,
    this.enabled = true,
  });

  final Widget control;
  final double descriptionInset;
  final String? description;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final description = this.description;
    if (description == null) return control;
    return FlexBox(
      // `.radio` and `.switch`: `flex-col items-start gap-1`.
      style: FlexBoxStyler()
          .direction(.vertical)
          .mainAxisSize(.min)
          .crossAxisAlignment(.start)
          .spacing(_fieldGap),
      children: [
        control,
        Box(
          style: BoxStyler().padding(.start(descriptionInset)),
          child: StyledText(
            description,
            style: enabled
                ? heroUiDescriptionText
                : heroUiDescriptionText.wrap(
                    WidgetModifierConfig.opacity(_disabledTwice),
                  ),
          ),
        ),
      ],
    );
  }
}

/// `[data-slot="radio"]` and `[data-slot="checkbox"]`: `mt-4`; horizontal
/// groups and `.switch-group__items`: `gap-4`.
const _groupGap = 16.0;

/// `.radio` and `.switch`: `gap-1`.
const _fieldGap = 4.0;

/// A disabled item is `status-disabled`, and so is its description, so it dims
/// twice.
const _disabledTwice =
    HeroUiTokens.disabledOpacity * HeroUiTokens.disabledOpacity;
