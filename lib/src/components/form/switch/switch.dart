import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:naked_ui/naked_ui.dart';

import '../../../helpers/style_mix_ext.dart';
import '../../../helpers/mix_controller_mixin.dart';
import '../../../helpers/remix_builder.dart';

part 'switch.g.dart';
part 'switch_style.dart';
part 'switch_widget.dart';

@MixableSpec()
base class SwitchSpec extends Spec<SwitchSpec>
    with _$SwitchSpec, Diagnosticable {
  final BoxSpec container;
  final BoxSpec indicator;

  /// {@macro switch_spec_of}
  static const of = _$SwitchSpec.of;

  static const from = _$SwitchSpec.from;

  const SwitchSpec({
    BoxSpec? container,
    BoxSpec? indicator,
    super.animated,
    super.modifiers,
  })  : container = container ?? const BoxSpec(),
        indicator = indicator ?? const BoxSpec();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }
}
