import 'statuses.dart';

/// One labelled input value of a tool call, such as `Command` and
/// `flutter test`.
typedef AgentToolInput = ({String label, String value});

/// The lifecycle of one tool call.
///
/// A call moves through these values in place, as one row that changes:
///
/// ```text
/// inputStreaming → awaitingApproval → denied
///                                   → running → succeeded | failed | cancelled
/// ```
///
/// A call that needs no approval goes from [inputStreaming] straight to
/// [running]. Each value is exactly one of [isWorking], [needsDecision] and
/// [isSettled].
enum AgentToolCallStatus {
  /// The model is still writing the call's input.
  inputStreaming,

  /// The call waits for the reader to allow or deny it.
  awaitingApproval,

  /// The reader or the host refused the call.
  denied,

  /// The tool is executing.
  running,

  /// The tool finished successfully.
  succeeded,

  /// The tool failed.
  failed,

  /// The host or the runtime stopped the tool before it finished.
  cancelled;

  /// Whether the call is making progress without the reader.
  bool get isWorking => this == inputStreaming || this == running;

  /// Whether the call waits for the reader's decision.
  bool get needsDecision => this == awaitingApproval;

  /// Whether the call reached a terminal outcome.
  bool get isSettled =>
      this == denied ||
      this == succeeded ||
      this == failed ||
      this == cancelled;

  /// The lifecycle phase of this status.
  AgentWorkPhase get phase => switch (this) {
    inputStreaming || running => AgentWorkPhase.working,
    awaitingApproval => AgentWorkPhase.waiting,
    denied || succeeded || cancelled => AgentWorkPhase.settled,
    failed => AgentWorkPhase.failed,
  };
}

/// The reader's decision on a tool call that needs approval.
enum AgentApprovalDecision {
  /// Run this call once.
  allowOnce,

  /// Run this call and later calls of the same tool without asking.
  alwaysAllow,

  /// Do not run this call.
  deny;

  /// Whether the decision lets the call run.
  bool get allows => this != deny;
}
