import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../components/disclosure/disclosure.dart';
import '../../utilities/remix_reduced_motion.dart';
import '../../utilities/remix_style.dart';
import '../behavior/disclosure.dart';
import '../behavior/run_clock.dart';
import '../models/statuses.dart';
import '../models/step.dart';
import 'glyphs.dart';
import 'internal.dart';

part 'steps.g.dart';

/// Builds the steps line from the run's [status], its number of [steps] and,
/// once it settles, how long it worked ([duration], null when unknown).
typedef AgentStepsLabelBuilder =
    String Function(AgentRunStatus status, int steps, Duration? duration);

/// Wraps the steps line in a shimmer while the run works.
typedef AgentShimmerBuilder =
    Widget Function(BuildContext context, Widget child);

/// The steps of a run: one line that summarizes them, over a rail that lists
/// them.
///
/// The line reads "Thinking…" while the run works, "Waiting for approval · 2
/// steps" while it waits for the reader and "Thought for 6s · 3 steps" once it
/// settles. While the run works, [shimmer] wraps the line, except under
/// reduced motion.
///
/// The rail opens and closes with the run under [policy]: it opens while the
/// run works and collapses when it settles. A reader's toggle wins for the
/// rest of the run. Each step resolves [stepStyle] with its own status; style
/// one with [AgentStepStylerStatus.onStatus].
///
/// A settled run shows [duration], or else the time [clock] measured. The
/// host starts and stops [clock]; the line only reads it.
class AgentSteps extends StatefulWidget {
  /// Creates the steps of a run.
  const AgentSteps({
    super.key,
    required this.steps,
    this.status = AgentRunStatus.working,
    this.duration,
    this.clock,
    this.policy = const AgentDisclosurePolicy(),
    this.expanded,
    this.defaultExpanded,
    this.onExpandedChanged,
    this.labelBuilder,
    this.stepStatusLabelBuilder,
    this.shimmer,
    this.glyphBuilder,
    this.disclosureStyle = const DisclosureStyler.create(),
    this.stepStyle = const AgentStepStyler.create(),
    this.style = const AgentStepsStyler.create(),
    this.styleSpec,
  });

  /// The steps in order.
  final List<AgentStep> steps;

  /// Whether the run works, waits for the reader or is complete.
  final AgentRunStatus status;

  /// How long the run worked, for a settled run; wins over [clock].
  final Duration? duration;

  /// Measures a live run; read for a settled run without [duration].
  final AgentRunClock? clock;

  /// When the rail opens and closes on its own.
  final AgentDisclosurePolicy policy;

  /// Whether the rail is open. Null lets the widget own the state.
  final bool? expanded;

  /// Whether the rail starts open when uncontrolled; defaults to open while
  /// the run has not finished.
  final bool? defaultExpanded;

  /// Receives every request to open or close the rail.
  final ValueChanged<bool>? onExpandedChanged;

  /// Builds the steps line; defaults to English.
  final AgentStepsLabelBuilder? labelBuilder;

  /// Names a step's status for assistive technology; defaults to English.
  final String Function(AgentStepStatus status)? stepStatusLabelBuilder;

  /// Wraps the steps line while the run works.
  final AgentShimmerBuilder? shimmer;

  /// Draws the glyphs; defaults to the nearest [AgentGlyphs].
  final AgentGlyphBuilder? glyphBuilder;

  /// The style of the disclosure behind the line and the rail.
  final DisclosureStyler disclosureStyle;

  /// The style of each step, resolved with the step's status.
  final AgentStepStyler stepStyle;

  /// The style of the line and the rail.
  final AgentStepsStyler style;

  /// A resolved spec that bypasses [style].
  final AgentStepsSpec? styleSpec;

  /// The default steps line.
  static String defaultLabel(
    AgentRunStatus status,
    int steps,
    Duration? duration,
  ) {
    final count = steps == 0
        ? ''
        : ' · $steps ${steps == 1 ? 'step' : 'steps'}';

    return switch (status) {
      AgentRunStatus.working => 'Thinking…',
      AgentRunStatus.waiting => 'Waiting for approval$count',
      AgentRunStatus.complete =>
        duration == null || duration <= Duration.zero
            ? 'Thought for a few seconds$count'
            : 'Thought for ${_seconds(duration)}$count',
    };
  }

  static String _seconds(Duration duration) {
    final seconds = agentCeilSeconds(duration);

    return seconds < 60 ? '${seconds}s' : '${seconds ~/ 60}m ${seconds % 60}s';
  }

  /// The default name of a step's status.
  static String defaultStepStatusLabel(AgentStepStatus status) =>
      switch (status) {
        AgentStepStatus.pending => 'Pending',
        AgentStepStatus.active => 'In progress',
        AgentStepStatus.complete => 'Done',
        AgentStepStatus.cancelled => 'Skipped',
      };

  @override
  State<AgentSteps> createState() => _AgentStepsState();
}

final _stepsLayout = AgentStepsStyler(
  trigger: FlexBoxStyler().mainAxisSize(MainAxisSize.min),
  rail: FlexBoxStyler()
      .mainAxisSize(MainAxisSize.min)
      .crossAxisAlignment(CrossAxisAlignment.start),
);

class _AgentStepsState extends State<AgentSteps>
    with AutomaticKeepAliveClientMixin {
  late final AgentDisclosureController _disclosure;
  bool _retainDisclosure = false;

  @override
  void initState() {
    super.initState();
    final phase = widget.status.phase;
    _disclosure = AgentDisclosureController(
      phase: phase,
      expanded: widget.expanded,
      defaultExpanded: _defaultExpanded,
      policy: widget.policy,
      onExpandedChanged: widget.onExpandedChanged,
    )..addListener(_changed);
    widget.clock?.addListener(_changed);
  }

  @override
  void didUpdateWidget(AgentSteps oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.clock, widget.clock)) {
      oldWidget.clock?.removeListener(_changed);
      widget.clock?.addListener(_changed);
    }
    _disclosure
      ..policy = widget.policy
      ..onExpandedChanged = widget.onExpandedChanged
      ..updateExpanded(widget.expanded)
      ..updatePhase(widget.status.phase);
    _updateDisclosureKeepAlive();
  }

  bool get _defaultExpanded =>
      widget.defaultExpanded ??
      (!widget.status.phase.isFinished && widget.policy.openWhileWorking);

  void _toggle(bool expanded) {
    _disclosure.toggle(expanded);
    _updateDisclosureKeepAlive();
  }

  void _updateDisclosureKeepAlive() {
    _retainDisclosure =
        _disclosure.readerToggled &&
        widget.policy.respectReaderToggle &&
        (!widget.status.phase.isFinished ||
            _disclosure.expanded != _defaultExpanded);
    updateKeepAlive();
  }

  @override
  bool get wantKeepAlive => _retainDisclosure;

  void _changed() {
    if (mounted) setState(() {});
  }

  String get _label {
    final settled = widget.status == AgentRunStatus.complete;
    final duration = settled
        ? widget.duration ?? widget.clock?.elapsed
        : widget.duration;

    return (widget.labelBuilder ?? AgentSteps.defaultLabel)(
      widget.status,
      widget.steps.length,
      duration,
    );
  }

  AgentGlyph get _lineGlyph => switch (widget.status) {
    AgentRunStatus.working => AgentGlyph.thinking,
    AgentRunStatus.waiting => AgentGlyph.waiting,
    AgentRunStatus.complete => AgentGlyph.thought,
  };

  Widget _line(
    BuildContext context,
    AgentStepsSpec spec,
    bool reduceMotion, {
    required bool? expanded,
  }) {
    Widget label = StyledText(_label, styleSpec: spec.label);
    final shimmer = widget.shimmer;
    if (shimmer != null &&
        widget.status == AgentRunStatus.working &&
        !reduceMotion) {
      label = shimmer(context, label);
    }
    final icon = agentGlyph(
      context,
      widget.glyphBuilder,
      _lineGlyph,
      spec.icon,
    );
    final indicator = expanded == null
        ? null
        : agentGlyph(
            context,
            widget.glyphBuilder,
            expanded ? AgentGlyph.disclosureOpen : AgentGlyph.disclosureClosed,
            spec.indicator,
          );

    return RowBox(
      styleSpec: spec.trigger,
      children: [
        ?icon,
        Flexible(child: label),
        ?indicator,
      ],
    );
  }

  Widget _rail(AgentStepsSpec spec) {
    final statusLabel =
        widget.stepStatusLabelBuilder ?? AgentSteps.defaultStepStatusLabel;

    return ColumnBox(
      styleSpec: spec.rail,
      children: [
        for (final step in widget.steps)
          AgentValueScope<AgentStepStatus>(
            key: ValueKey(step.id),
            value: step.status,
            child: Semantics(
              container: true,
              label: [
                step.title,
                if (step.detail != null) step.detail!,
                statusLabel(step.status),
              ].join(', '),
              child: ExcludeSemantics(
                child: RemixStyleSpecBuilder<AgentStepSpec>(
                  style: widget.stepStyle,
                  styleSpec: null,
                  builder: (context, stepSpec) {
                    final glyph = agentGlyph(
                      context,
                      widget.glyphBuilder,
                      switch (step.status) {
                        AgentStepStatus.pending => AgentGlyph.stepPending,
                        AgentStepStatus.active => AgentGlyph.stepActive,
                        AgentStepStatus.complete => AgentGlyph.stepComplete,
                        AgentStepStatus.cancelled => AgentGlyph.stepCancelled,
                      },
                      stepSpec.icon,
                    );
                    final detail = step.detail;

                    return RowBox(
                      styleSpec: stepSpec.container,
                      children: [
                        ?glyph,
                        Flexible(
                          child: StyledText(
                            step.title,
                            styleSpec: stepSpec.title,
                          ),
                        ),
                        if (detail != null)
                          StyledText(detail, styleSpec: stepSpec.detail),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RemixReducedMotionBuilder(
      builder: (context, reduceMotion) => AgentValueScope<AgentRunStatus>(
        value: widget.status,
        child: RemixStyleSpecBuilder<AgentStepsSpec>(
          style: _stepsLayout.merge(widget.style),
          styleSpec: widget.styleSpec,
          builder: (context, spec) {
            if (widget.steps.isEmpty) {
              return Box(
                styleSpec: spec.container,
                child: Semantics(
                  container: true,
                  label: _label,
                  child: ExcludeSemantics(
                    child: _line(context, spec, reduceMotion, expanded: null),
                  ),
                ),
              );
            }

            return Box(
              styleSpec: spec.container,
              child: RemixDisclosure(
                expanded: _disclosure.expanded,
                onExpandedChanged: _toggle,
                semanticLabel: _label,
                style: widget.disclosureStyle,
                trigger: const SizedBox.shrink(),
                triggerBuilder: (context, state, _) => _line(
                  context,
                  spec,
                  reduceMotion,
                  expanded: state.isExpanded,
                ),
                content: _rail(spec),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.clock?.removeListener(_changed);
    _disclosure.dispose();
    super.dispose();
  }
}

final _runVariants = agentValueVariants<AgentRunStatus>(
  'agentSteps.status',
  AgentRunStatus.values,
);

/// Status variants for [AgentStepsStyler].
extension AgentStepsStylerStatus on AgentStepsStyler {
  /// Applies [value] while the run is in [status].
  AgentStepsStyler onStatus(AgentRunStatus status, AgentStepsStyler value) =>
      variant(_runVariants[status]!, value);
}

final _stepVariants = agentValueVariants<AgentStepStatus>(
  'agentStep.status',
  AgentStepStatus.values,
);

/// Status variants for [AgentStepStyler].
extension AgentStepStylerStatus on AgentStepStyler {
  /// Applies [value] to steps in [status].
  AgentStepStyler onStatus(AgentStepStatus status, AgentStepStyler value) =>
      variant(_stepVariants[status]!, value);
}

/// Resolved visual properties for the line and the rail of [AgentSteps].
///
/// Every slot is empty by default; presets supply the look.
// No target: mix_generator 2.2.0-beta.3 emits InvalidType for constructor
// parameters typed with stylers generated in the same build (the nested
// component styles), as CalendarSpec notes.
@MixableSpec()
@immutable
final class AgentStepsSpec with _$AgentStepsSpec {
  /// Wraps the line and the rail.
  @override
  final StyleSpec<BoxSpec> container;

  /// The line: its glyph, label and indicator in a row.
  @override
  final StyleSpec<FlexBoxSpec> trigger;

  /// The line's leading glyph.
  @override
  final StyleSpec<IconSpec> icon;

  /// The line's text.
  @override
  final StyleSpec<TextSpec> label;

  /// The glyph that shows whether the rail is open.
  @override
  final StyleSpec<IconSpec> indicator;

  /// The rail of steps.
  @override
  final StyleSpec<FlexBoxSpec> rail;

  /// Creates a spec; every slot defaults to empty.
  const AgentStepsSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<FlexBoxSpec>? trigger,
    StyleSpec<IconSpec>? icon,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? indicator,
    StyleSpec<FlexBoxSpec>? rail,
  }) : container = container ?? const StyleSpec(spec: BoxSpec()),
       trigger = trigger ?? const StyleSpec(spec: FlexBoxSpec()),
       icon = icon ?? const StyleSpec(spec: IconSpec()),
       label = label ?? const StyleSpec(spec: TextSpec()),
       indicator = indicator ?? const StyleSpec(spec: IconSpec()),
       rail = rail ?? const StyleSpec(spec: FlexBoxSpec());
}

/// Resolved visual properties for one step on the rail of [AgentSteps].
///
/// Every slot is empty by default; presets supply the look.
@MixableSpec()
@immutable
final class AgentStepSpec with _$AgentStepSpec {
  /// The step's row.
  @override
  final StyleSpec<FlexBoxSpec> container;

  /// The step's status glyph.
  @override
  final StyleSpec<IconSpec> icon;

  /// The step's title.
  @override
  final StyleSpec<TextSpec> title;

  /// The step's detail.
  @override
  final StyleSpec<TextSpec> detail;

  /// Creates a spec; every slot defaults to empty.
  const AgentStepSpec({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<IconSpec>? icon,
    StyleSpec<TextSpec>? title,
    StyleSpec<TextSpec>? detail,
  }) : container = container ?? const StyleSpec(spec: FlexBoxSpec()),
       icon = icon ?? const StyleSpec(spec: IconSpec()),
       title = title ?? const StyleSpec(spec: TextSpec()),
       detail = detail ?? const StyleSpec(spec: TextSpec());
}
