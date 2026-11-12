import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';

import '../models/message_part.dart';
import '../models/statuses.dart';
import '../models/tool_call.dart';

/// What an [AgentAnnouncement] reports.
enum AgentAnnouncementKind {
  /// A tool call waits for the reader's approval.
  approvalNeeded,

  /// A tool call failed.
  toolFailed,

  /// An answer finished streaming.
  answerReady,
}

/// One transition worth telling a screen reader about.
@immutable
final class AgentAnnouncement {
  /// Creates an announcement.
  const AgentAnnouncement({required this.kind, required this.id, this.tool});

  /// What happened.
  final AgentAnnouncementKind kind;

  /// The tool call's or the answer's id.
  final String id;

  /// The tool's name, for a tool call announcement.
  final String? tool;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AgentAnnouncement &&
          other.kind == kind &&
          other.id == id &&
          other.tool == tool;

  @override
  int get hashCode => Object.hash(kind, id, tool);

  @override
  String toString() => 'AgentAnnouncement($kind, id: $id, tool: $tool)';
}

/// Decides which Agent transitions a screen reader hears, once each.
///
/// Three transitions are announced: a tool call that starts waiting for
/// approval, a tool call that fails, and an answer that finishes streaming.
/// Streaming text itself is never announced, and no surface should make it a
/// live region: a screen reader that reads every token is unusable.
///
/// The announcer remembers the last status it saw for each id, so a rebuild,
/// or a widget recreated by a lazy list, does not repeat an announcement. An
/// id seen for the first time is history unless it needs the reader now: a
/// call already awaiting approval is announced, a call that already failed or
/// an answer that already finished is not.
///
/// Give one announcer the lifetime of a conversation. It reports to
/// [onAnnouncement]; [announce] sends a message to the platform.
class AgentAnnouncer {
  /// Creates an announcer that reports to [onAnnouncement].
  AgentAnnouncer({this.onAnnouncement});

  /// Receives each announcement as it is decided.
  ValueChanged<AgentAnnouncement>? onAnnouncement;

  final Map<String, AgentToolCallStatus> _toolCalls = {};
  final Map<String, AgentAnswerStatus> _answers = {};

  /// Records [call]'s status; returns and reports the announcement it
  /// triggers, if any.
  AgentAnnouncement? updateToolCall(AgentToolCallPart call) {
    final previous = _toolCalls[call.id];
    _toolCalls[call.id] = call.status;
    if (previous == call.status) return null;

    final kind = switch (call.status) {
      AgentToolCallStatus.awaitingApproval =>
        AgentAnnouncementKind.approvalNeeded,
      AgentToolCallStatus.failed when previous != null =>
        AgentAnnouncementKind.toolFailed,
      _ => null,
    };

    return kind == null
        ? null
        : _report(AgentAnnouncement(kind: kind, id: call.id, tool: call.name));
  }

  /// Records the status of the answer [id]; returns and reports the
  /// announcement it triggers, if any.
  AgentAnnouncement? updateAnswer(String id, AgentAnswerStatus status) {
    final previous = _answers[id];
    _answers[id] = status;
    if (previous != AgentAnswerStatus.streaming ||
        status != AgentAnswerStatus.complete) {
      return null;
    }

    return _report(
      AgentAnnouncement(kind: AgentAnnouncementKind.answerReady, id: id),
    );
  }

  /// Forgets every status, for a new conversation.
  void reset() {
    _toolCalls.clear();
    _answers.clear();
  }

  AgentAnnouncement _report(AgentAnnouncement announcement) {
    onAnnouncement?.call(announcement);

    return announcement;
  }

  /// Sends [message] to assistive technology for the view that holds
  /// [context], in the ambient text direction.
  static Future<void> announce(
    BuildContext context,
    String message, {
    Assertiveness assertiveness = Assertiveness.polite,
  }) => SemanticsService.sendAnnouncement(
    View.of(context),
    message,
    Directionality.of(context),
    assertiveness: assertiveness,
  );
}
