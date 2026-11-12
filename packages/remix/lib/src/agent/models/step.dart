import 'package:flutter/foundation.dart';

/// Status of one step in a run.
enum AgentStepStatus {
  /// Not started.
  pending,

  /// Underway.
  active,

  /// Finished.
  complete,

  /// Abandoned or skipped.
  cancelled;

  /// Whether the step is underway.
  bool get isActive => this == active;

  /// Whether the step is finished, complete or cancelled.
  bool get isDone => this == complete || this == cancelled;
}

/// One step of a run: something the agent read, found or did.
///
/// Merges the current plan item and activity row into one model.
@immutable
final class AgentStep {
  /// Creates a step.
  const AgentStep({
    required this.id,
    required this.title,
    this.status = AgentStepStatus.pending,
    this.detail,
  });

  /// Stable identity across updates.
  final String id;

  /// The visible title, such as "Read the checkout module".
  final String title;

  /// The current status.
  final AgentStepStatus status;

  /// Optional compact metadata, such as an elapsed time or a path.
  final String? detail;

  /// Returns a copy with the given fields replaced.
  ///
  /// A null [detail] keeps the current one; [clearDetail] removes it and wins
  /// over [detail].
  AgentStep copyWith({
    String? title,
    AgentStepStatus? status,
    String? detail,
    bool clearDetail = false,
  }) => AgentStep(
    id: id,
    title: title ?? this.title,
    status: status ?? this.status,
    detail: clearDetail ? null : detail ?? this.detail,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AgentStep &&
          other.id == id &&
          other.title == title &&
          other.status == status &&
          other.detail == detail;

  @override
  int get hashCode => Object.hash(id, title, status, detail);

  @override
  String toString() =>
      'AgentStep(id: $id, title: $title, status: $status, detail: $detail)';
}
