import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'tag_input.g.dart';

// One row is a 28px tag or editor inside 7px of padding and a 1px edge: 44px.
const _shellPadding = 7.0;
const _gap = 6.0;
const _rowHeight = 28.0;
const _editorPaddingX = 5.0;
// The editor wraps to its own row when less than its 100px basis is left.
const _editorMinWidth = 100.0;
const _tagPaddingStart = 9.0;
const _tagPaddingEnd = 4.0;
const _tagGap = 3.0;
const _pill = Radius.circular(9999);
const _removeSize = 22.0;
const _removeGlyph = 14.0;
const _cursorWidth = 1.5;
const _transparent = Color(0x00000000);

/// The Fortal tag input recipe: a 44px shell of wrapping tags and an inline
/// editor, with a label above and helper text below.
///
/// The shell edge is `gray7` at rest, `gray8` under the pointer and `gray12`
/// while the editor has focus. Tags are 28px pills on `gray3` with a 1px
/// `gray7` edge. A picked tag takes an `accent9` edge over an `accentA3`
/// tint, and its remove glyph darkens to `gray12`. The remove button is a
/// 22px circle that fills with `gray2` under the pointer.
///
/// [highContrast] moves the resting shell and tag edges to `gray8`, which
/// holds 3:1 against the page.
@MixWidget(target: RemixTagInput.new)
TagInputStyler fortalTagInputStyle({
  bool highContrast = false,
  TagInputStyler style = const TagInputStyler.create(),
}) {
  final edge = highContrast ? FortalTokens.gray8() : FortalTokens.gray7();
  final text = FortalTokens.text2.mix();

  return TagInputStyler()
      .layout(FlexBoxStyler().spacing(FortalTokens.space2()))
      .label(
        TextStyler()
            .style(text)
            .fontWeight(FortalTokens.fontWeightMedium())
            .color(FortalTokens.gray12()),
      )
      .helperText(
        TextStyler()
            .style(FortalTokens.text1.mix())
            .color(FortalTokens.gray10()),
      )
      .padding(.all(_shellPadding))
      .borderRadius(.all(FortalTokens.radius4()))
      .border(.all(.color(edge).width(FortalTokens.borderWidth1())))
      .color(FortalTokens.gray2())
      .spacing(_gap)
      .runSpacing(_gap)
      .editorMinWidth(_editorMinWidth)
      .editor(
        BoxStyler()
            .minHeight(_rowHeight)
            .padding(.horizontal(_editorPaddingX))
            .alignment(.centerLeft),
      )
      .text(TextStyler().style(text).color(FortalTokens.gray12()))
      .hintText(TextStyler().style(text).color(FortalTokens.gray10()))
      .cursorColor(FortalTokens.gray12())
      .cursorWidth(_cursorWidth)
      .tag(fortalTagInputTagStyle(highContrast: highContrast))
      .onHovered(TagInputStyler().border(.all(.color(FortalTokens.gray8()))))
      .onFocused(TagInputStyler().border(.all(.color(FortalTokens.gray12()))))
      .variant(
        ContextVariant.widgetState(.error),
        TagInputStyler()
            .border(.all(.color(FortalTokens.error8())))
            .label(TextStyler().color(FortalTokens.error11()))
            .helperText(TextStyler().color(FortalTokens.error11()))
            .cursorColor(FortalTokens.error9()),
      )
      .onDisabled(
        TagInputStyler()
            .color(FortalTokens.gray3())
            .text(TextStyler().color(FortalTokens.grayA11()))
            .hintText(TextStyler().color(FortalTokens.gray9())),
      )
      .animate(
        AnimationConfig.curve(
          duration: FortalMotion.fast,
          curve: FortalMotion.easeStandard,
        ),
      )
      .merge(style);
}

/// The style every tag of [fortalTagInputStyle] resolves in its own state.
TagInputTagStyler fortalTagInputTagStyle({bool highContrast = false}) {
  final edge = highContrast ? FortalTokens.gray8() : FortalTokens.gray7();
  final pill = BorderRadiusMix.all(_pill);

  return TagInputTagStyler()
      .minHeight(_rowHeight)
      .padding(.only(left: _tagPaddingStart, right: _tagPaddingEnd))
      .spacing(_tagGap)
      .borderRadius(pill)
      .border(.all(.color(edge).width(FortalTokens.borderWidth1())))
      // The fill sits in a wrapper so a picked tag can lay its tint over it.
      .color(_transparent)
      .wrap(.box(BoxStyler().color(FortalTokens.gray3()).borderRadius(pill)))
      .label(
        TextStyler()
            .style(FortalTokens.text2.mix())
            .color(FortalTokens.gray12())
            .maxLines(1)
            .softWrap(false),
      )
      .removeButton(_removeButton(FortalTokens.gray11()))
      .onSelected(
        TagInputTagStyler()
            .color(FortalTokens.accentA3())
            .border(.all(.color(FortalTokens.accent9())))
            .removeButton(_removeButton(FortalTokens.gray12())),
      )
      .onDisabled(
        TagInputTagStyler().label(TextStyler().color(FortalTokens.grayA11())),
      );
}

IconButtonStyler _removeButton(Color glyph) => IconButtonStyler()
    .size(_removeSize, _removeSize)
    .alignment(.center)
    .borderRadius(.all(const Radius.circular(_removeSize / 2)))
    .color(_transparent)
    .iconColor(glyph)
    .iconSize(_removeGlyph)
    .onHovered(
      IconButtonStyler()
          .color(FortalTokens.gray2())
          .iconColor(FortalTokens.gray12()),
    )
    .animate(
      AnimationConfig.curve(
        duration: FortalMotion.fast,
        curve: FortalMotion.easeStandard,
      ),
    );
