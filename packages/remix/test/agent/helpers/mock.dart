import 'package:remix/agent.dart';

// The content of the approved mock (evidence/2026-11-11-remix-agent-package/
// mock/index.html): one turn that asks to run the cart tests, in each state.

const prompt = 'Run the checkout tests and tell me if the cart flow is ready.';

const readModule = AgentStep(
  id: 'read',
  title: 'Read the checkout module',
  status: AgentStepStatus.complete,
);

const foundTests = AgentStep(
  id: 'found',
  title: 'Found 4 test files for the cart',
  status: AgentStepStatus.complete,
);

const ranTests = AgentStep(
  id: 'ran',
  title: 'Ran the cart tests',
  status: AgentStepStatus.complete,
);

const _input = <AgentToolInput>[
  (label: 'Command', value: 'flutter test test/cart'),
  (label: 'Directory', value: 'packages/checkout'),
];

const approvalCall = AgentToolCallPart(
  id: 'call-1',
  name: 'terminal.run',
  summary: 'Run the cart tests',
  description:
      'The agent wants to run the checkout test suite in this '
      'workspace.',
  input: _input,
  status: AgentToolCallStatus.awaitingApproval,
);

const runningOutput =
    r'$ flutter test test/cart'
    '\n00:01 +12: cart_state_test.dart: adds an item'
    '\n00:02 +27: cart_totals_test.dart: applies a discount'
    '\n00:03 +31: checkout_flow_test.dart: submits the order…';

const runningCall = AgentToolCallPart(
  id: 'call-1',
  name: 'terminal.run',
  summary: 'Running the cart tests',
  input: _input,
  status: AgentToolCallStatus.running,
  output: runningOutput,
);

const doneCall = AgentToolCallPart(
  id: 'call-1',
  name: 'terminal.run',
  summary: 'Tests passed',
  detail: '31 tests',
  input: _input,
  status: AgentToolCallStatus.succeeded,
  output: runningOutput,
  decision: AgentApprovalDecision.allowOnce,
  duration: Duration(milliseconds: 2900),
);

const failedOutput =
    r'$ flutter test test/cart'
    '\n00:02 +30: cart_totals_test.dart: applies a discount';

const failedError =
    '00:03 +30 -1: checkout_flow_test.dart: submits the order [E]'
    '\n  Expected: OrderStatus.placed'
    '\n    Actual: OrderStatus.pending';

const failedCall = AgentToolCallPart(
  id: 'call-1',
  name: 'terminal.run',
  summary: '1 test failed',
  detail: '30 of 31 passed',
  input: _input,
  status: AgentToolCallStatus.failed,
  output: failedOutput,
  error: failedError,
  decision: AgentApprovalDecision.allowOnce,
  duration: Duration(milliseconds: 3100),
);

const deniedCall = AgentToolCallPart(
  id: 'call-1',
  name: 'terminal.run',
  summary: 'Run the cart tests',
  input: _input,
  status: AgentToolCallStatus.denied,
  decision: AgentApprovalDecision.deny,
);

const sources = [
  AgentSource(id: 'totals', title: 'cart_totals_test.dart'),
  AgentSource(id: 'flow', title: 'checkout_flow_test.dart'),
];
