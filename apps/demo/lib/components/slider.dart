import 'package:demo/helpers/catalog.dart';
import 'package:demo/helpers/use_case_state.dart';
import 'package:demo/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final _key = GlobalKey();

// Resolve inside the disabled fragment so the dark face is not shadowed by
// the higher-priority disabled state of the shared recipe.
final _disabledThumbFill = ContextToken<Color>(
  (context) =>
      (FortalTheme.of(context).isDark ? FortalTokens.gray9 : FortalTokens.gray4)
          .resolve(context),
);

/// Shared presentation for the demo's single and range sliders.
SliderStyler demoSliderStyle({
  FortalSliderVariant variant = .surface,
  FortalSliderSize size = .size2,
}) => fortalSliderStyle(
  variant: variant,
  size: size,
  style: _demoSliderOverrides(),
);

SliderStyler _demoSliderOverrides() => SliderStyler()
    // Local to this demo: preserve the preset's shared 40px target elsewhere.
    .wrap(.sizedBox(height: 48))
    .onHovered(
      SliderStyler()
          .thumbEffects(
            RemixBoxEffectsMix(
              outline: .color(
                FortalTokens.accentA4(),
              ).width(FortalTokens.borderWidth2()),
            ),
          )
          .thumb(
            .border(
              .all(
                .color(
                  FortalTokens.accent11(),
                ).width(FortalTokens.borderWidth2()),
              ),
            ),
          ),
    )
    .onPressed(
      SliderStyler()
          .thumbEffects(
            RemixBoxEffectsMix(
              outline: .color(
                FortalTokens.accentA6(),
              ).width(FortalTokens.space1()),
            ),
          )
          .thumb(
            .border(
              .all(
                .color(
                  FortalTokens.accent12(),
                ).width(FortalTokens.borderWidth2()),
              ),
            ),
          ),
    )
    .thumbFocusEffects(
      RemixBoxEffectsMix(
        outline: BorderSideMix(
          color: FortalTokens.accent11(),
          width: FortalTokens.focusRingWidth(),
        ),
        outlineOffset: FortalTokens.focusRingOffset(),
      ),
    )
    .onDisabled(
      SliderStyler()
          .track(.color(FortalTokens.gray5()))
          .range(.color(FortalTokens.gray8()))
          .thumbColor(_disabledThumbFill())
          .thumb(
            .border(
              .all(
                .color(FortalTokens.gray9()).width(FortalTokens.borderWidth1()),
              ),
            ),
          )
          .blendMode(BlendMode.srcOver),
    )
    // Override the recipe's dark disabled screen blend as well.
    .variant(
      ContextVariant(
        'demoSliderDark',
        (context) => FortalTheme.of(context).isDark,
      ),
      // A neutral edge separates white handles even where they overlap.
      SliderStyler()
          .thumb(.border(.all(.color(FortalTokens.gray8()))))
          .onDisabled(.blendMode(BlendMode.srcOver)),
    );

@widgetbook.UseCase(name: 'Slider Component', type: RemixSlider)
Widget buildSliderUseCase(BuildContext context) {
  final knobState = WidgetbookState.of(context);
  return KeyedSubtree(
    key: _key,
    child: Scaffold(
      body: Center(
        child: SizedBox(
          width: 200,
          child: FortalSlider(
            onChanged: (value) => knobState.updateKnob('value', value),
            enabled: context.knobs.boolean(
              label: 'enabled',
              initialValue: true,
            ),
            snapDivisions: context.knobs.int.input(
              label: 'snapDivisions',
              initialValue: 2,
            ),
            value: context.knobs.double.slider(
              label: 'value',
              min: 0,
              max: 1,
              initialValue: 0.25,
            ),
            variant: context.knobs.object.dropdown(
              label: 'variant',
              options: FortalSliderVariant.values,
              labelBuilder: (variant) => variant.name,
            ),
            size: context.knobs.object.dropdown(
              label: 'size',
              options: FortalSliderSize.values,
              labelBuilder: (size) => size.name,
              initialOption: FortalSliderSize.size2,
            ),
            style: _demoSliderOverrides(),
          ),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Catalog', type: RemixSlider)
Widget buildSliderCatalogUseCase(BuildContext context) {
  return CatalogMatrix(
    cellWidth: 180,
    columns: labelsOf(FortalSliderSize.values),
    rows: labelsOf(FortalSliderVariant.values),
    cell: (row, column) => SizedBox(
      width: 140,
      child: FortalSlider(
        value: 0.5,
        size: FortalSliderSize.values[column],
        variant: FortalSliderVariant.values[row],
        style: _demoSliderOverrides(),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Price range', type: RemixSlider)
Widget buildRangeSliderUseCase(BuildContext context) => const _PriceRange();

class _PriceRange extends StatefulWidget {
  const _PriceRange();
  @override
  State<_PriceRange> createState() => _PriceRangeState();
}

class _PriceRangeState extends State<_PriceRange> {
  List<double> _prices = [80, 240];
  @override
  Widget build(BuildContext context) => Center(
    child: SizedBox(
      width: 280,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Nightly price'),
          Text('\$${_prices[0].round()} – \$${_prices[1].round()}'),
          RemixRangeSlider(
            values: _prices,
            min: 0,
            max: 400,
            snapDivisions: 80,
            semanticLabels: const [
              'Minimum nightly price',
              'Maximum nightly price',
            ],
            semanticFormatterCallbacks: [
              (v) => '\$${v.round()} per night',
              (v) => '\$${v.round()} per night',
            ],
            style: demoSliderStyle(),
            onChanged: (next) => setState(() => _prices = next),
          ),
        ],
      ),
    ),
  );
}
