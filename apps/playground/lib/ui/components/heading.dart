import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../theme/tokens.dart';

/// The heading styles, after shadcn/ui's Typography page, from a page of
/// prose's title down.
enum PlaygroundHeadingVariant {
  /// `text4xl` at extra-bold weight: the title of a page of prose.
  h1,

  /// `text3xl` at semibold weight: a section of prose, or an application
  /// page's title.
  h2,

  /// `text2xl` at semibold weight.
  h3,

  /// `textXl` at semibold weight.
  h4,
}

/// The style of a [PlaygroundHeading]: the variant's step and weight in
/// `foreground`, tracked tight (`tracking-tight`, -0.025em).
///
/// A plain recipe rather than a `@MixWidget`: a generated widget only renders
/// its styler, and a heading must also tell assistive technology that it is
/// one.
TextStyler playgroundHeadingStyle({
  PlaygroundHeadingVariant variant = .h1,
  TextStyler style = const TextStyler.create(),
}) {
  final (step, weight) = switch (variant) {
    .h1 => (PlaygroundTokens.text4xl, FontWeight.w800),
    .h2 => (PlaygroundTokens.text3xl, FontWeight.w600),
    .h3 => (PlaygroundTokens.text2xl, FontWeight.w600),
    .h4 => (PlaygroundTokens.textXl, FontWeight.w600),
  };

  final typography = TextStyler()
      .style(step.mix())
      .fontWeight(weight)
      .letterSpacing(_tight(step)())
      .color(PlaygroundTokens.foreground());

  return switch (variant) {
    .h1 => typography.textAlign(.center),
    .h2 => typography.wrap(
      .box(
        BoxStyler()
            .padding(.bottom(PlaygroundTokens.s2))
            .border(
              .bottom(
                .color(
                  PlaygroundTokens.border(),
                ).width(PlaygroundTokens.strokeHairline),
              ),
            ),
      ),
    ),
    _ => typography,
  }.merge(style);
}

/// `tracking-tight`: -0.025em of whatever size [step] resolves to.
///
/// Cached per step, because `ContextToken` equality is resolver identity.
ContextToken<double> _tight(TextStyleToken step) => _tracking.putIfAbsent(
  step,
  () => ContextToken<double>(
    (context) => -0.025 * step.resolve(context).fontSize!,
  ),
);

final _tracking = <TextStyleToken, ContextToken<double>>{};

/// The application's Heading: a title that assistive technology announces as
/// a heading.
///
/// [variant] sets the look and [headingLevel] the level announced, which
/// defaults to the variant's own (an `h2` is level 2). Set it when the two
/// differ, such as an application page whose title is drawn as an `h2` but
/// is the page's top heading:
///
/// ```dart
/// VanillaHeading.h2('Customers', headingLevel: 1)
/// ```
///
/// Align, wrap, truncate, or set a spoken label through [style].
class PlaygroundHeading extends StatelessWidget {
  const PlaygroundHeading(
    this.text, {
    super.key,
    this.variant = PlaygroundHeadingVariant.h1,
    this.headingLevel,
    this.style = const TextStyler.create(),
  }) : assert(headingLevel == null || (headingLevel >= 1 && headingLevel <= 6));

  /// A page of prose's title.
  const PlaygroundHeading.h1(
    this.text, {
    super.key,
    this.headingLevel,
    this.style = const TextStyler.create(),
  }) : variant = PlaygroundHeadingVariant.h1,
       assert(headingLevel == null || (headingLevel >= 1 && headingLevel <= 6));

  /// A section of prose, or an application page's title.
  const PlaygroundHeading.h2(
    this.text, {
    super.key,
    this.headingLevel,
    this.style = const TextStyler.create(),
  }) : variant = PlaygroundHeadingVariant.h2,
       assert(headingLevel == null || (headingLevel >= 1 && headingLevel <= 6));

  /// A subsection.
  const PlaygroundHeading.h3(
    this.text, {
    super.key,
    this.headingLevel,
    this.style = const TextStyler.create(),
  }) : variant = PlaygroundHeadingVariant.h3,
       assert(headingLevel == null || (headingLevel >= 1 && headingLevel <= 6));

  /// The smallest heading.
  const PlaygroundHeading.h4(
    this.text, {
    super.key,
    this.headingLevel,
    this.style = const TextStyler.create(),
  }) : variant = PlaygroundHeadingVariant.h4,
       assert(headingLevel == null || (headingLevel >= 1 && headingLevel <= 6));

  /// The visible text.
  final String text;

  /// The look: `h1` through `h4`.
  final PlaygroundHeadingVariant variant;

  /// The level assistive technology announces, 1 to 6; the variant's own
  /// when null.
  final int? headingLevel;

  /// Merged last over [playgroundHeadingStyle].
  final TextStyler style;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    header: true,
    headingLevel: headingLevel ?? variant.index + 1,
    child: playgroundHeadingStyle(variant: variant, style: style)(text),
  );
}
