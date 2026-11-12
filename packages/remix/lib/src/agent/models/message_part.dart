import 'package:flutter/foundation.dart';

import 'source.dart';
import 'statuses.dart';
import 'step.dart';
import 'tool_call.dart';

/// One piece of an Agent message's content.
///
/// A message is an ordered list of parts, like the AI SDK's `UIMessage.parts`:
/// text, steps (reasoning), tool calls, sources and host data. Each part
/// changes in place as the run advances, so a host maps its stream onto these
/// values and rebuilds.
///
/// The type is sealed: a `switch` over a part is exhaustive.
@immutable
sealed class AgentMessagePart {
  /// Initializes a part; only the part types below extend it.
  const AgentMessagePart();
}

/// Text the assistant wrote, usually markdown.
final class AgentTextPart extends AgentMessagePart {
  /// Creates a text part.
  const AgentTextPart(this.text, {this.status = AgentAnswerStatus.complete});

  /// The text so far.
  final String text;

  /// Whether the text is still streaming, finished or failed.
  final AgentAnswerStatus status;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AgentTextPart && other.text == text && other.status == status;

  @override
  int get hashCode => Object.hash(text, status);

  @override
  String toString() => 'AgentTextPart(status: $status, ${text.length} chars)';
}

/// The steps of a run, shown as "Thought for 6s · 3 steps" once it settles.
///
/// Maps the AI SDK's reasoning and step parts.
final class AgentStepsPart extends AgentMessagePart {
  /// Creates a steps part.
  const AgentStepsPart({
    required this.steps,
    required this.status,
    this.duration,
  });

  /// The steps in order.
  final List<AgentStep> steps;

  /// Whether the run is working, waiting for the reader, or complete.
  final AgentRunStatus status;

  /// How long the run worked, for a settled summary. `AgentRunClock` measures
  /// it for a live run; history stores it.
  final Duration? duration;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AgentStepsPart &&
          listEquals(other.steps, steps) &&
          other.status == status &&
          other.duration == duration;

  @override
  int get hashCode => Object.hash(Object.hashAll(steps), status, duration);

  @override
  String toString() =>
      'AgentStepsPart(status: $status, duration: $duration, steps: $steps)';
}

/// One call to a tool: its input, its lifecycle and its result.
///
/// Maps the AI SDK's `tool-<name>` parts. A host renderer registered for
/// [name] receives the whole part; other calls use the standard row.
final class AgentToolCallPart extends AgentMessagePart {
  /// Creates a tool call part.
  const AgentToolCallPart({
    required this.id,
    required this.name,
    this.summary,
    this.description,
    this.detail,
    this.input = const [],
    this.status = AgentToolCallStatus.inputStreaming,
    this.output,
    this.result,
    this.error,
    this.decision,
    this.duration,
  });

  /// Stable identity of the call, such as the SDK's `toolCallId`.
  final String id;

  /// The tool's identifier, such as `terminal.run`.
  final String name;

  /// One line on what the call does or did, such as "Run the cart tests".
  final String? summary;

  /// Why the agent wants to make the call, shown when it asks for approval.
  final String? description;

  /// Compact outcome metadata, such as "31 tests".
  final String? detail;

  /// The call's labelled input values.
  final List<AgentToolInput> input;

  /// Where the call is in its lifecycle.
  final AgentToolCallStatus status;

  /// The tool's text output, shown in the output well.
  final String? output;

  /// The tool's structured result, for a host renderer. The standard row
  /// does not read it.
  final Object? result;

  /// What went wrong, when [status] is [AgentToolCallStatus.failed].
  final String? error;

  /// The recorded approval decision, such as
  /// [AgentApprovalDecision.allowOnce].
  final AgentApprovalDecision? decision;

  /// How long the tool ran.
  final Duration? duration;

  /// Returns a copy with the given fields replaced.
  ///
  /// The usual update moves [status] and fills in the result:
  /// `call.copyWith(status: AgentToolCallStatus.running)`.
  AgentToolCallPart copyWith({
    String? summary,
    String? description,
    String? detail,
    List<AgentToolInput>? input,
    AgentToolCallStatus? status,
    String? output,
    Object? result,
    String? error,
    AgentApprovalDecision? decision,
    Duration? duration,
  }) => AgentToolCallPart(
    id: id,
    name: name,
    summary: summary ?? this.summary,
    description: description ?? this.description,
    detail: detail ?? this.detail,
    input: input ?? this.input,
    status: status ?? this.status,
    output: output ?? this.output,
    result: result ?? this.result,
    error: error ?? this.error,
    decision: decision ?? this.decision,
    duration: duration ?? this.duration,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AgentToolCallPart &&
          other.id == id &&
          other.name == name &&
          other.summary == summary &&
          other.description == description &&
          other.detail == detail &&
          listEquals(other.input, input) &&
          other.status == status &&
          other.output == output &&
          other.result == result &&
          other.error == error &&
          other.decision == decision &&
          other.duration == duration;

  @override
  int get hashCode => Object.hash(
    id,
    name,
    summary,
    description,
    detail,
    Object.hashAll(input),
    status,
    output,
    result,
    error,
    decision,
    duration,
  );

  @override
  String toString() =>
      'AgentToolCallPart(id: $id, name: $name, status: $status, '
      'decision: $decision)';
}

/// The sources an answer refers to, such as "2 files referenced".
///
/// Maps the AI SDK's `source-url` and `source-document` parts.
final class AgentSourcesPart extends AgentMessagePart {
  /// Creates a sources part.
  const AgentSourcesPart(this.sources);

  /// The sources in order.
  final List<AgentSource> sources;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AgentSourcesPart && listEquals(other.sources, sources);

  @override
  int get hashCode => Object.hashAll(sources);

  @override
  String toString() => 'AgentSourcesPart($sources)';
}

/// Host data the conversation renders with a registered builder.
///
/// Maps the AI SDK's `data-<name>` parts. [name] selects the builder and is
/// never shown to the reader.
final class AgentDataPart extends AgentMessagePart {
  /// Creates a data part.
  const AgentDataPart({required this.name, this.id, this.data});

  /// The key a host builder is registered under.
  final String name;

  /// Stable identity, when the host updates the part in place.
  final String? id;

  /// The payload for the builder.
  final Object? data;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AgentDataPart &&
          other.name == name &&
          other.id == id &&
          other.data == data;

  @override
  int get hashCode => Object.hash(name, id, data);

  @override
  String toString() => 'AgentDataPart(name: $name, id: $id)';
}
