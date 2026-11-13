# Agent recipes

Agent widgets, models, controllers, specs, and stylers live in experimental
`package:remix/agent.dart`. Import that library explicitly. It ships with Remix,
outside its stability promise. The private authoring package supplies only
preset recipes; apps never depend on `registry_source`.

The eight widgets are `AgentConversation`, `AgentMessage`, `AgentSteps`,
`AgentToolCall`, `AgentAnswer`, `AgentSources`, `AgentSuggestions`, and
`AgentComposer`. `AgentTurn` groups a prompt and its response blocks.
Widgets have empty visual defaults and glyph slots. Each preset's recipes
supply unresolved styles; `agent_glyphs_recipe` supplies its glyph builder.

```shell
remix add conversation_recipe message_recipe steps_recipe tool_call_recipe answer_recipe composer_recipe sources_recipe suggestions_recipe agent_glyphs_recipe
```

No consumer Agent code generation is needed. Widget and model names keep the
`Agent` prefix; installed recipe names use the app prefix. Pass each recipe's
fields into the matching widget parameters. Wrap the conversation in
`AgentGlyphs(builder: uiAgentGlyph, child: ...)` for prefix `Ui`.

The host owns model-provider calls, tool execution, approval persistence,
clipboard writes, feedback, and announcements. Supply an Overlay when a
composer can focus: a routed WidgetsApp already provides one, while a bare
WidgetsApp builder can use `Overlay.wrap`.

See the [component guides](../../../docs/agent/conversation.mdx) and
[migration guide](../../../docs/agent/migrating.mdx) for call sites, recipe
fields, and the old-to-new map. Previously installed behavior source keeps
compiling because it belongs to the app.
