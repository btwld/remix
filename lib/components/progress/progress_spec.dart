import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'progress_spec.g.dart';

@MixableSpec()
base class ProgressSpec extends Spec<ProgressSpec> with _$ProgressSpec {
  final BoxSpec container;
  final BoxSpec track;
  final BoxSpec fill;

  /// {@macro progress_spec_of}
  static const of = _$ProgressSpec.of;

  static const from = _$ProgressSpec.from;

  const ProgressSpec({
    BoxSpec? container,
    BoxSpec? track,
    BoxSpec? fill,
    super.animated,
  })  : container = container ?? const BoxSpec(),
        track = track ?? const BoxSpec(),
        fill = fill ?? const BoxSpec();
}
