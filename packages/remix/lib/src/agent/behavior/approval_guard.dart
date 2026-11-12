import '../models/tool_call.dart';

/// Accepts one decision per approval request.
///
/// A reader can press Allow twice, or Allow and then Deny, before the host
/// records the first decision. The guard takes the first and refuses the
/// rest, until the host shows a new request: a different call [id], or the
/// same call back in [AgentToolCallStatus.awaitingApproval].
class AgentApprovalGuard {
  /// Creates a guard for the call [id] in [status].
  AgentApprovalGuard({required String id, required AgentToolCallStatus status})
    : _id = id,
      _status = status;

  String _id;
  AgentToolCallStatus _status;
  AgentApprovalDecision? _decision;

  /// The call the guard watches.
  String get id => _id;

  /// The call's latest status.
  AgentToolCallStatus get status => _status;

  /// The decision taken for the current request, or null before one.
  AgentApprovalDecision? get decision => _decision;

  /// Whether a decision can be taken now: the call needs one and none was
  /// taken for this request.
  bool get canDecide => _status.needsDecision && _decision == null;

  /// Records the call's latest [id] and [status].
  ///
  /// A new request re-arms the guard: a different [id] that awaits approval,
  /// or a return to [AgentToolCallStatus.awaitingApproval].
  void update({required String id, required AgentToolCallStatus status}) {
    final awaiting = status == AgentToolCallStatus.awaitingApproval;
    final newRequest = id != _id && awaiting;
    final returned = !_status.needsDecision && awaiting;
    _id = id;
    _status = status;
    if (newRequest || returned) _decision = null;
  }

  /// Takes [decision] if [canDecide]; returns whether it was taken.
  ///
  /// Send the decision to the host only when this returns true.
  bool decide(AgentApprovalDecision decision) {
    if (!canDecide) return false;
    _decision = decision;

    return true;
  }
}
