import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

import '../models/statuses.dart';

/// When a collapsible Agent surface opens and closes on its own.
///
/// The work behind the surface moves through [AgentWorkPhase]s. Entering
/// [AgentWorkPhase.working] opens the surface, settling closes it, and a
/// failure leaves it as it is, so output that explains the failure stays in
/// view. Once the reader toggles the surface within a run, the run never
/// overrides that choice; the next run starts fresh.
///
/// The policy decides; [AgentDisclosureController] applies it to an open
/// state that the host or the widget owns.
@immutable
class AgentDisclosurePolicy {
  /// Creates a disclosure policy.
  const AgentDisclosurePolicy({
    this.openWhileWorking = true,
    this.collapseWhenSettled = true,
    this.keepOpenOnFailure = true,
    this.respectReaderToggle = true,
  });

  /// Whether entering [AgentWorkPhase.working] opens the surface.
  final bool openWhileWorking;

  /// Whether settling ([AgentWorkPhase.settled]) closes the surface.
  final bool collapseWhenSettled;

  /// Whether a failure ([AgentWorkPhase.failed]) leaves the surface as it is.
  ///
  /// When false, a failure closes the surface like a settle does, if
  /// [collapseWhenSettled] is true.
  final bool keepOpenOnFailure;

  /// Whether a reader's toggle within a run suppresses the run's own requests.
  final bool respectReaderToggle;

  /// The open state the work asks for when it moves from [from] to [to], or
  /// null when it asks for nothing.
  ///
  /// This ignores the reader; [AgentDisclosureController] applies
  /// [respectReaderToggle].
  bool? request(AgentWorkPhase from, AgentWorkPhase to) {
    if (from == to) return null;

    return switch (to) {
      AgentWorkPhase.working => openWhileWorking ? true : null,
      AgentWorkPhase.waiting => null,
      AgentWorkPhase.settled => collapseWhenSettled ? false : null,
      AgentWorkPhase.failed =>
        !keepOpenOnFailure && collapseWhenSettled ? false : null,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AgentDisclosurePolicy &&
          other.openWhileWorking == openWhileWorking &&
          other.collapseWhenSettled == collapseWhenSettled &&
          other.keepOpenOnFailure == keepOpenOnFailure &&
          other.respectReaderToggle == respectReaderToggle;

  @override
  int get hashCode => Object.hash(
    openWhileWorking,
    collapseWhenSettled,
    keepOpenOnFailure,
    respectReaderToggle,
  );
}

/// The open state of one collapsible Agent surface.
///
/// The state is either uncontrolled, stored here from `defaultExpanded`, or
/// controlled by the host through [updateExpanded]. Releasing control keeps
/// the last controlled value. Every request, from the reader ([toggle]) or
/// from the work's lifecycle ([updatePhase] under [policy]), is reported to
/// [onExpandedChanged], even when it does not change the stored value: a
/// controlled host decides for itself.
///
/// A request from the reader reaches [onExpandedChanged] at once. A request
/// from the lifecycle arrives while the host rebuilds the widget that owns
/// this controller, so it reaches [onExpandedChanged] after the frame: the
/// host can call `setState` in it without touching the tree mid-build.
///
/// Listeners hear about changes to [expanded].
class AgentDisclosureController extends ChangeNotifier {
  /// Creates a disclosure in [phase].
  ///
  /// A non-null [expanded] makes it controlled; otherwise it starts at
  /// [defaultExpanded]. Later changes to the default are not read.
  AgentDisclosureController({
    AgentWorkPhase phase = AgentWorkPhase.settled,
    bool? expanded,
    bool defaultExpanded = true,
    this.policy = const AgentDisclosurePolicy(),
    this.onExpandedChanged,
  }) : _phase = phase,
       _controlled = expanded,
       _uncontrolled = expanded ?? defaultExpanded;

  /// When the work opens and closes the surface.
  AgentDisclosurePolicy policy;

  /// Receives every open or close request.
  ValueChanged<bool>? onExpandedChanged;

  AgentWorkPhase _phase;
  bool? _controlled;
  bool _uncontrolled;
  bool _readerToggled = false;
  bool _disposed = false;

  /// Whether the surface is open.
  bool get expanded => _controlled ?? _uncontrolled;

  /// Whether the host controls [expanded].
  bool get isControlled => _controlled != null;

  /// Where the work behind the surface is.
  AgentWorkPhase get phase => _phase;

  /// Whether the reader toggled the surface during the current run.
  bool get readerToggled => _readerToggled;

  /// Adopts the host's controlled value; null hands control back and keeps
  /// the last controlled value.
  void updateExpanded(bool? expanded) {
    final before = this.expanded;
    final controlled = _controlled;
    if (controlled != null && expanded == null) _uncontrolled = controlled;
    _controlled = expanded;
    if (this.expanded != before) notifyListeners();
  }

  /// Moves the work to [next] and applies the [policy]'s request, if any.
  ///
  /// Entering [AgentWorkPhase.working] from a finished phase starts a new run
  /// and forgets the reader's toggle. A pause for the reader does not.
  void updatePhase(AgentWorkPhase next) {
    final previous = _phase;
    if (next == previous) return;
    _phase = next;
    if (next == AgentWorkPhase.working && previous.isFinished) {
      _readerToggled = false;
    }
    final request = policy.request(previous, next);
    if (request == null || (policy.respectReaderToggle && _readerToggled)) {
      return;
    }
    _request(request, fromLifecycle: true);
  }

  /// Records the reader's request to open ([expanded] true) or close.
  void toggle(bool expanded) {
    _readerToggled = true;
    _request(expanded);
  }

  void _request(bool next, {bool fromLifecycle = false}) {
    if (_controlled == null && next != _uncontrolled) {
      _uncontrolled = next;
      notifyListeners();
    }
    if (!fromLifecycle) {
      onExpandedChanged?.call(next);
      return;
    }
    // The lifecycle moves while the host builds; report it after the frame.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!_disposed) onExpandedChanged?.call(next);
    });
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
