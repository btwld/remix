# Behavioral benchmark provenance

The former `remix_agent` package (now shared Agent source in
`registry_source/lib/src/agent`) used BeUI as a behavior, anatomy and icon
vocabulary benchmark, pinned to:

- Repository: <https://github.com/starc007/ui-components.git>
- Commit: `1942f3f93d8d36dba8a0dd8366699a933f56b135`
- License at that commit: MIT, copyright 2026 Saurabh Chauhan

## Source mapping

| Remix Agent surface | Benchmark source |
| --- | --- |
| `AgentComposer` | `components/agents/prompt-input.tsx` |
| `AgentMessage`, `AgentMessageCollapsible` | `components/agents/message.tsx`, `message-bubble.tsx` |
| `AgentTranscript` | `components/agents/message-scroller.tsx` |
| `AgentAnswer` | `components/agents/streaming-response.tsx` |
| `AgentPermission` | `components/agents/tool-approval.tsx` |
| `AgentExecution` | `components/agents/tool-result.tsx` |
| `AgentPlan` | `components/agents/todo-list.tsx` |
| `AgentActivity` | `components/agents/agent-activity/` |

## Intentional deviations

The benchmark informed workflow questions such as component boundaries,
disclosure placement, lifecycle states, live-edge behavior, and functional icon
choices. It is not an API, branding, or pixel-parity target. The implementation
uses Flutter, Naked UI behavior, Remix controls, generated Mix specs, and
this repository's `remix_ui_icons` font, including its stop, pending, active,
loading, and circled-outcome statuses. Domain specs have empty visual
defaults; both presets supply installed recipe bundles. Agent defines its own
controlled/uncontrolled, accessibility, keyboard, lifecycle and scroll ownership
contracts rather than copying the benchmark API.

## License and NOTICE conclusion

The benchmark repository's MIT license was reviewed at the pinned commit. No
benchmark source code, runtime asset, branding, or substantial copied portion
is distributed by Agent source; the implementation was written against the
behavioral/anatomical observations above. On that basis there is no benchmark
license text or NOTICE file to add to the distributed source. Preserve this
record and reassess that conclusion if future work copies source or assets.
