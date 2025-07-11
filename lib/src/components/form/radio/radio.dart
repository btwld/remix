import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:naked_ui/naked_ui.dart';

import '../../../helpers/style_mix_ext.dart';
import '../../../core/style_scope.dart';
import '../../../helpers/mix_controller_mixin.dart';
import '../../../helpers/remix_builder.dart';
import '../../../helpers/utility_extension.dart';

part 'radio.g.dart';
part 'radio_style.dart';
part 'radio_widget.dart';

@MixableSpec()
base class RadioSpec extends Spec<RadioSpec> with _$RadioSpec, Diagnosticable {
  final BoxSpec indicatorContainer;
  final BoxSpec indicator;
  final FlexBoxSpec container;
  final TextSpec text;

  /// {@macro radio_spec_of}
  static const of = _$RadioSpec.of;

  static const from = _$RadioSpec.from;

  const RadioSpec({
    BoxSpec? indicatorContainer,
    BoxSpec? indicator,
    FlexBoxSpec? container,
    TextSpec? text,
    super.modifiers,
    super.animated,
  })  : indicatorContainer = indicatorContainer ?? const BoxSpec(),
        indicator = indicator ?? const BoxSpec(),
        text = text ?? const TextSpec(),
        container = container ?? const FlexBoxSpec();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }
}
