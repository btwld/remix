/// Where a piece of Agent work is in its lifecycle.
///
/// Every status maps to one phase, so the disclosure policy and the announcer
/// read surfaces with different statuses the same way.
enum AgentWorkPhase {
  /// Paused for a decision from the reader, such as an approval.
  waiting,

  /// In progress.
  working,

  /// Finished without a failure: done, denied or cancelled.
  settled,

  /// Finished with a failure.
  failed;

  /// Whether the work has finished, with or without a failure.
  bool get isFinished => this == settled || this == failed;
}

/// Status of a turn or a run of steps.
enum AgentRunStatus {
  /// Work is in progress.
  working,

  /// The run is paused until the reader decides, for example on an approval.
  waiting,

  /// Work finished.
  complete;

  /// The lifecycle phase of this status.
  AgentWorkPhase get phase => switch (this) {
    working => AgentWorkPhase.working,
    waiting => AgentWorkPhase.waiting,
    complete => AgentWorkPhase.settled,
  };
}

/// Status of a streamed answer.
enum AgentAnswerStatus {
  /// Tokens are still arriving.
  streaming,

  /// The answer finished successfully.
  complete,

  /// The answer failed.
  error;

  /// Whether tokens are still arriving.
  bool get isStreaming => this == streaming;

  /// Whether completion actions (copy, feedback, retry) may appear.
  bool get showsActions => this == complete || this == error;
}

/// Status of an in-transcript tool permission.
///
/// This is a machine, not a boolean loading flag. Actions are offered only
/// while [pending]. `AgentToolCallStatus` merges it with
/// [AgentExecutionStatus] into one tool-call lifecycle.
enum AgentPermissionStatus {
  /// Waiting for a human decision.
  pending,

  /// A decision was submitted and is being recorded.
  deciding,

  /// The host accepted this invocation.
  allowed,

  /// The approved tool is executing.
  running,

  /// The approved tool finished.
  complete,

  /// The host refused this invocation.
  denied,

  /// Permission or execution failed.
  error;

  /// Whether the request still occupies the operator: true until a terminal
  /// outcome. [pending] is working (a decision is in flight) but does not keep
  /// parameter details open.
  bool get isWorking => !isSettled;

  /// Whether a terminal decision or outcome was reached.
  bool get isSettled => this == complete || this == denied || this == error;

  /// Whether parameter details stay open without a reader toggle. [pending]
  /// starts closed.
  bool get keepsDetailsOpen =>
      this == deciding || this == allowed || this == running;

  /// The lifecycle phase of this status.
  AgentWorkPhase get phase => switch (this) {
    pending => AgentWorkPhase.waiting,
    deciding || allowed || running => AgentWorkPhase.working,
    complete || denied => AgentWorkPhase.settled,
    error => AgentWorkPhase.failed,
  };
}

/// Status of a tool execution disclosure.
enum AgentExecutionStatus {
  /// Output is still arriving.
  running,

  /// The tool finished successfully.
  success,

  /// The tool failed.
  error,

  /// The host or runtime cancelled the tool.
  cancelled;

  /// Whether output should stay expanded.
  bool get isWorking => this == running;

  /// Whether a terminal outcome was reached.
  bool get isSettled => !isWorking;

  /// The lifecycle phase of this status.
  AgentWorkPhase get phase => switch (this) {
    running => AgentWorkPhase.working,
    success || cancelled => AgentWorkPhase.settled,
    error => AgentWorkPhase.failed,
  };
}

/// Status of one item in a task plan.
enum AgentPlanItemStatus {
  /// Not started.
  pending,

  /// Currently underway.
  inProgress,

  /// Finished successfully.
  completed,

  /// Abandoned or skipped.
  cancelled;

  /// Whether the item is underway.
  bool get isActive => this == inProgress;

  /// Whether the item is finished, completed or cancelled.
  bool get isDone => this == completed || this == cancelled;
}

/// Status of one row in an activity ledger.
enum AgentActivityItemStatus {
  /// Not yet started.
  pending,

  /// The current step.
  active,

  /// Finished.
  complete,
}

/// Who authored a transcript row.
enum AgentRole {
  /// The human operator.
  user,

  /// The assistant replying to the operator.
  assistant,
}
