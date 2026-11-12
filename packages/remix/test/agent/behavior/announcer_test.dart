import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/agent.dart';

import '../helpers/pump.dart';

AgentToolCallPart _call(AgentToolCallStatus status, {String id = 'call-1'}) =>
    AgentToolCallPart(id: id, name: 'terminal.run', status: status);

void main() {
  late List<AgentAnnouncement> heard;
  late AgentAnnouncer announcer;

  setUp(() {
    heard = [];
    announcer = AgentAnnouncer(onAnnouncement: heard.add);
  });

  test('one announcement each: approval needed, tool failed, answer ready', () {
    for (final status in [
      AgentToolCallStatus.inputStreaming,
      AgentToolCallStatus.awaitingApproval,
      AgentToolCallStatus.running,
      AgentToolCallStatus.failed,
    ]) {
      announcer.updateToolCall(_call(status));
    }
    announcer
      ..updateAnswer('answer-1', AgentAnswerStatus.streaming)
      ..updateAnswer('answer-1', AgentAnswerStatus.complete);

    expect(heard, const [
      AgentAnnouncement(
        kind: AgentAnnouncementKind.approvalNeeded,
        id: 'call-1',
        tool: 'terminal.run',
      ),
      AgentAnnouncement(
        kind: AgentAnnouncementKind.toolFailed,
        id: 'call-1',
        tool: 'terminal.run',
      ),
      AgentAnnouncement(
        kind: AgentAnnouncementKind.answerReady,
        id: 'answer-1',
      ),
    ]);
  });

  test('a rebuild with the same status says nothing again', () {
    for (var rebuild = 0; rebuild < 3; rebuild++) {
      announcer
        ..updateToolCall(_call(AgentToolCallStatus.awaitingApproval))
        ..updateAnswer('answer-1', AgentAnswerStatus.streaming);
    }
    expect(heard.map((announcement) => announcement.kind), [
      AgentAnnouncementKind.approvalNeeded,
    ]);
  });

  test('streaming text is never announced', () {
    for (var token = 0; token < 20; token++) {
      expect(
        announcer.updateAnswer('answer-1', AgentAnswerStatus.streaming),
        isNull,
      );
    }
    expect(heard, isEmpty);
    expect(announcer.updateAnswer('answer-1', AgentAnswerStatus.error), isNull);
    expect(heard, isEmpty);
  });

  test('history is quiet, but a waiting approval is news', () {
    announcer
      ..updateToolCall(_call(AgentToolCallStatus.failed, id: 'old'))
      ..updateToolCall(_call(AgentToolCallStatus.succeeded, id: 'older'))
      ..updateAnswer('old-answer', AgentAnswerStatus.complete);
    expect(heard, isEmpty);

    announcer.updateToolCall(
      _call(AgentToolCallStatus.awaitingApproval, id: 'pending'),
    );
    expect(heard.single.kind, AgentAnnouncementKind.approvalNeeded);
    expect(heard.single.id, 'pending');
  });

  test('a success, a denial and a cancel are not announced', () {
    for (final status in [
      AgentToolCallStatus.running,
      AgentToolCallStatus.succeeded,
    ]) {
      announcer.updateToolCall(_call(status));
    }
    announcer
      ..updateToolCall(_call(AgentToolCallStatus.awaitingApproval, id: 'b'))
      ..updateToolCall(_call(AgentToolCallStatus.denied, id: 'b'))
      ..updateToolCall(_call(AgentToolCallStatus.running, id: 'c'))
      ..updateToolCall(_call(AgentToolCallStatus.cancelled, id: 'c'));
    expect(heard.map((announcement) => announcement.kind), [
      AgentAnnouncementKind.approvalNeeded,
    ]);
  });

  test('reset forgets every status for a new conversation', () {
    announcer
      ..updateToolCall(_call(AgentToolCallStatus.awaitingApproval))
      ..reset()
      ..updateToolCall(_call(AgentToolCallStatus.awaitingApproval));
    expect(heard, hasLength(2));
  });

  testWidgets('announce sends a polite message for the current view', (
    tester,
  ) async {
    late BuildContext context;
    await pumpAgent(
      tester,
      Builder(
        builder: (built) {
          context = built;
          return const SizedBox.shrink();
        },
      ),
    );
    await AgentAnnouncer.announce(context, 'terminal.run needs approval');
    final announcements = tester.takeAnnouncements();
    expect(announcements, hasLength(1));
    expect(announcements.single.message, 'terminal.run needs approval');
    expect(announcements.single.textDirection, TextDirection.ltr);
    expect(announcements.single.assertiveness, Assertiveness.polite);
  });
}
