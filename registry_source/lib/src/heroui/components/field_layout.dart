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

/// A radio or switch followed by its label, with an optional description
/// beneath.
///
/// Remix's radio and switch are bare controls, so the label is plain text next
/// to them: it is not a tap target. [controlWidth] indents the description
/// under the label. A disabled control dims itself; this dims the text.
class HeroUiControlRow extends StatelessWidget {
  const HeroUiControlRow({
    super.key,
    required this.control,
    required this.controlWidth,
    required this.label,
    this.description,
    this.invalid = false,
    this.enabled = true,
  });

  final Widget control;
  final double controlWidth;
  final String label;
  final String? description;
  final bool invalid;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final labelStyle = _label(invalid: invalid);
    final dimmed = WidgetModifierConfig.opacity(_disabledTwice);
    return FlexBox(
      // `.radio` and `.switch`: `flex-col items-start gap-1`.
      style: FlexBoxStyler()
          .direction(.vertical)
          .mainAxisSize(.min)
          .crossAxisAlignment(.start)
          .spacing(_fieldGap),
      children: [
        FlexBox(
          // `__content`: `inline-flex items-center gap-3`.
          style: FlexBoxStyler()
              .direction(.horizontal)
              .mainAxisSize(.min)
              .crossAxisAlignment(.center)
              .spacing(_contentGap),
          children: [
            control,
            // Let long labels wrap in the space left after the control and
            // gap, while short labels keep their natural width.
            Flexible(
              // The control already supplies the option's accessible name.
              child: ExcludeSemantics(
                child: StyledText(
                  label,
                  style: enabled ? labelStyle : labelStyle.wrap(dimmed),
                ),
              ),
            ),
          ],
        ),
        if (description != null)
          Box(
            style: BoxStyler().padding(.start(controlWidth + _contentGap)),
            child: StyledText(
              description!,
              style: enabled
                  ? heroUiDescriptionText
                  : heroUiDescriptionText.wrap(dimmed),
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

/// A disabled item is `status-disabled`, and so are its label (`.label` in a
/// disabled field) and its description, so both dim twice.
const _disabledTwice =
    HeroUiTokens.disabledOpacity * HeroUiTokens.disabledOpacity;

/// `.radio__content` and `.switch__content`: `gap-3`.
const _contentGap = 12.0;
