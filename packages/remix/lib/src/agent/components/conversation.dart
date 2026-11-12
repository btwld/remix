import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../components/icon_button/icon_button.dart';
import '../../utilities/remix_reduced_motion.dart';
import '../../utilities/remix_style.dart';
import '../behavior/live_edge.dart';
import 'glyphs.dart';

part 'conversation.g.dart';

/// The scrolling transcript of an Agent conversation.
///
/// Each child is one turn, usually an [AgentTurn]: the reader's message and
/// everything the assistant did in reply. The spec spaces turns apart by
/// [AgentConversationSpec.turnSpacing] and the blocks inside an [AgentTurn]
/// by [AgentConversationSpec.blockSpacing].
///
/// The transcript keeps its live edge with an [AgentLiveEdgeController]: it
/// follows growing output until the reader scrolls back, and then offers a
/// way back to the latest output. That button animates in and out, and the
/// return scrolls, except under reduced motion; activating it from the
/// keyboard moves focus to the transcript.
///
/// The transcript takes focus as one stop and scrolls with the arrow keys,
/// Page Up, Page Down, Home and End. [busy] reports work in progress to
/// assistive technology without making the transcript a live region.
class AgentConversation extends StatefulWidget {
  /// Creates a transcript of [children], one per turn.
  const AgentConversation({
    super.key,
    required List<Widget> this.children,
    this.empty,
    this.liveEdge,
    this.scrollController,
    this.busy = false,
    this.busyLabel = 'Busy',
    this.semanticLabel = 'Conversation',
    this.showLatestButton = true,
    this.latestLabel = 'Scroll to latest',
    this.glyphBuilder,
    this.latestStyle = const IconButtonStyler.create(),
    this.style = const AgentConversationStyler.create(),
    this.styleSpec,
  }) : itemCount = null,
       itemBuilder = null,
       findChildIndexCallback = null;

  /// Creates a transcript that builds its [itemCount] turns lazily.
  const AgentConversation.builder({
    super.key,
    required int this.itemCount,
    required IndexedWidgetBuilder this.itemBuilder,
    this.findChildIndexCallback,
    this.empty,
    this.liveEdge,
    this.scrollController,
    this.busy = false,
    this.busyLabel = 'Busy',
    this.semanticLabel = 'Conversation',
    this.showLatestButton = true,
    this.latestLabel = 'Scroll to latest',
    this.glyphBuilder,
    this.latestStyle = const IconButtonStyler.create(),
    this.style = const AgentConversationStyler.create(),
    this.styleSpec,
  }) : children = null;

  /// The turns, oldest first.
  final List<Widget>? children;

  /// How many turns [itemBuilder] builds.
  final int? itemCount;

  /// Builds the turn at an index, oldest first.
  final IndexedWidgetBuilder? itemBuilder;

  /// Finds the current index of the turn whose key is given, for the
  /// [AgentConversation.builder] form.
  ///
  /// Give it when turns carry keys and history can be prepended or
  /// reordered, so each turn keeps its state. It receives the key the host
  /// put on the turn.
  final ChildIndexGetter? findChildIndexCallback;

  /// Shown instead of the transcript while it has no turns.
  final Widget? empty;

  /// The live edge to follow; when null, the transcript owns one.
  final AgentLiveEdgeController? liveEdge;

  /// The scroll controller of the transcript; when null, it owns one.
  final ScrollController? scrollController;

  /// Whether the assistant is working, reported as [busyLabel].
  final bool busy;

  /// The semantic value while [busy].
  final String busyLabel;

  /// The transcript's accessible name.
  final String semanticLabel;

  /// Whether a reader away from the live edge is offered a way back.
  final bool showLatestButton;

  /// The accessible name of the way back to the latest output.
  final String latestLabel;

  /// Draws [AgentGlyph.latest]; defaults to the nearest [AgentGlyphs].
  final AgentGlyphBuilder? glyphBuilder;

  /// The style of the way back to the latest output.
  final IconButtonStyler latestStyle;

  /// The transcript's style.
  final AgentConversationStyler style;

  /// A resolved spec that bypasses [style].
  final AgentConversationSpec? styleSpec;

  /// The spacing between the blocks of a turn, from the nearest
  /// [AgentConversation]; zero outside one.
  static double blockSpacingOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<_AgentConversationScope>()
          ?.blockSpacing ??
      0;

  @override
  State<AgentConversation> createState() => _AgentConversationState();
}

class _AgentConversationState extends State<AgentConversation> {
  AgentLiveEdgeController? _ownedLiveEdge;
  late AgentLiveEdgeController _liveEdge;
  final FocusNode _viewportFocus = FocusNode(debugLabel: 'AgentConversation');
  final FocusNode _latestFocus = FocusNode(debugLabel: 'Scroll to latest');
  final WidgetStatesController _states = WidgetStatesController();
  late bool _showLatest;
  ScrollController? _ownedScrollController;

  ScrollController get _scrollController =>
      widget.scrollController ??
      (_ownedScrollController ??= ScrollController());

  int get _count => widget.children?.length ?? widget.itemCount!;

  @override
  void initState() {
    super.initState();
    _adopt(widget.liveEdge ?? (_ownedLiveEdge = AgentLiveEdgeController()));
  }

  void _adopt(AgentLiveEdgeController liveEdge) {
    _liveEdge = liveEdge..addListener(_handleLiveEdge);
    _showLatest = liveEdge.showLatest;
  }

  @override
  void didUpdateWidget(AgentConversation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (identical(oldWidget.liveEdge, widget.liveEdge)) return;
    _liveEdge.removeListener(_handleLiveEdge);
    final superseded = _ownedLiveEdge;
    _ownedLiveEdge = null;
    _adopt(widget.liveEdge ?? (_ownedLiveEdge = AgentLiveEdgeController()));
    // The live edge still serves this frame's scrollable until it rebuilds.
    if (superseded != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => superseded.dispose());
    }
  }

  void _handleLiveEdge() {
    final next = _liveEdge.showLatest;
    if (next != _showLatest && mounted) setState(() => _showLatest = next);
  }

  void _returnToLatest(bool reduceMotion) {
    if (_latestFocus.hasFocus) _viewportFocus.requestFocus();
    _liveEdge.scrollToEnd(animate: !reduceMotion);
  }

  void _scroll(_ScrollKind kind) {
    final position = _position;
    if (position == null) return;
    final page = position.viewportDimension * 0.8;
    final target = switch (kind) {
      _ScrollKind.lineUp => position.pixels - 50,
      _ScrollKind.lineDown => position.pixels + 50,
      _ScrollKind.pageUp => position.pixels - page,
      _ScrollKind.pageDown => position.pixels + page,
      _ScrollKind.home => position.minScrollExtent,
      _ScrollKind.end => position.maxScrollExtent,
    };
    // The jump reports a scroll update, which the live edge reads like any
    // other scroll by the reader.
    position.jumpTo(
      target.clamp(position.minScrollExtent, position.maxScrollExtent),
    );
  }

  ScrollPosition? get _position {
    final controller = _scrollController;
    if (!controller.hasClients) return null;
    final position = controller.position;

    return position.hasContentDimensions ? position : null;
  }

  /// Finds a keyed turn of the `children` form, so reordering keeps state.
  ChildIndexGetter? get _findInChildren {
    final children = widget.children;
    if (children == null) return null;
    final indexes = <Key, int>{
      for (var i = 0; i < children.length; i++)
        if (children[i].key case final key?) key: i,
    };

    return (key) => indexes[key];
  }

  Widget _list(AgentConversationSpec spec, {required bool shrinkWrap}) {
    final maxWidth = spec.maxWidth;
    Widget turn(BuildContext context, int index) {
      final child =
          widget.children?[index] ?? widget.itemBuilder!(context, index);
      Widget current = Box(styleSpec: spec.turn, child: child);
      if (maxWidth != null) {
        current = Align(
          alignment: AlignmentDirectional.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            // As wide as the transcript allows, up to the maximum.
            child: SizedBox(width: double.infinity, child: current),
          ),
        );
      }

      // The host's key on a turn keys the wrapper, so a turn keeps its state
      // when history is prepended or reordered.
      final key = child.key;

      return KeyedSubtree(
        key: key == null ? ValueKey<int>(index) : ValueKey<Key>(key),
        child: current,
      );
    }

    final findChild = widget.findChildIndexCallback ?? _findInChildren;

    return AgentLiveEdge(
      controller: _liveEdge,
      scrollController: _scrollController,
      builder: (context, scrollController, physics) => ListView.separated(
        controller: scrollController,
        physics: physics,
        shrinkWrap: shrinkWrap,
        padding: spec.padding,
        itemCount: _count,
        itemBuilder: turn,
        findItemIndexCallback: findChild == null
            ? null
            : (key) => key is ValueKey<Key> ? findChild(key.value) : null,
        separatorBuilder: (context, index) =>
            SizedBox(height: spec.turnSpacing ?? 0),
      ),
    );
  }

  Widget _latest(AgentConversationSpec spec, bool reduceMotion) {
    final button = _showLatest
        ? Box(
            key: const ValueKey('agent-conversation-latest'),
            styleSpec: spec.latest,
            child: RemixIconButton(
              icon: null,
              focusNode: _latestFocus,
              iconBuilder: (context, iconSpec, icon) =>
                  agentGlyph(
                    context,
                    widget.glyphBuilder,
                    AgentGlyph.latest,
                    StyleSpec(spec: iconSpec),
                  ) ??
                  const SizedBox.shrink(),
              semanticLabel: widget.latestLabel,
              onPressed: () => _returnToLatest(reduceMotion),
              style: widget.latestStyle,
            ),
          )
        : const SizedBox.shrink(key: ValueKey('agent-conversation-no-latest'));
    if (reduceMotion) return button;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 150),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.9, end: 1).animate(animation),
          child: child,
        ),
      ),
      child: button,
    );
  }

  @override
  Widget build(BuildContext context) {
    return RemixReducedMotionBuilder(
      builder: (context, reduceMotion) =>
          RemixStyleSpecBuilder<AgentConversationSpec>(
            style: widget.style,
            styleSpec: widget.styleSpec,
            controller: _states,
            builder: (context, spec) => _AgentConversationScope(
              blockSpacing: spec.blockSpacing ?? 0,
              child: Semantics(
                container: true,
                explicitChildNodes: true,
                label: widget.semanticLabel,
                value: widget.busy ? widget.busyLabel : null,
                child: FocusableActionDetector(
                  focusNode: _viewportFocus,
                  onFocusChange: (focused) =>
                      _states.update(WidgetState.focused, focused),
                  shortcuts: _shortcuts,
                  actions: <Type, Action<Intent>>{
                    _ScrollIntent: CallbackAction<_ScrollIntent>(
                      onInvoke: (intent) {
                        _scroll(intent.kind);
                        return null;
                      },
                    ),
                  },
                  child: Box(
                    styleSpec: spec.container,
                    child: WidgetStateProvider(
                      states: const {},
                      child: _body(spec, reduceMotion),
                    ),
                  ),
                ),
              ),
            ),
          ),
    );
  }

  Widget _body(AgentConversationSpec spec, bool reduceMotion) {
    final empty = widget.empty;
    if (_count == 0 && empty != null) {
      return Box(styleSpec: spec.empty, child: empty);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final bounded = constraints.hasBoundedHeight;
        final list = ScrollConfiguration(
          // The live edge decides where the transcript rests; an overscroll
          // bounce would fight it.
          behavior: ScrollConfiguration.of(
            context,
          ).copyWith(overscroll: false, physics: const ClampingScrollPhysics()),
          child: _list(spec, shrinkWrap: !bounded),
        );
        if (!bounded || !widget.showLatestButton) return list;

        return Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [list, _latest(spec, reduceMotion)],
        );
      },
    );
  }

  @override
  void dispose() {
    _liveEdge.removeListener(_handleLiveEdge);
    _ownedLiveEdge?.dispose();
    _ownedScrollController?.dispose();
    _viewportFocus.dispose();
    _latestFocus.dispose();
    _states.dispose();
    super.dispose();
  }
}

/// One turn of an [AgentConversation]: the reader's message and the blocks
/// the assistant replied with, spaced by the conversation's
/// [AgentConversationSpec.blockSpacing].
class AgentTurn extends StatelessWidget {
  /// Creates a turn of [children], top to bottom.
  const AgentTurn({super.key, required this.children});

  /// The blocks of the turn.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AgentConversation.blockSpacingOf(context),
    children: children,
  );
}

final class _AgentConversationScope extends InheritedWidget {
  const _AgentConversationScope({
    required this.blockSpacing,
    required super.child,
  });

  final double blockSpacing;

  @override
  bool updateShouldNotify(_AgentConversationScope oldWidget) =>
      blockSpacing != oldWidget.blockSpacing;
}

enum _ScrollKind { lineUp, lineDown, pageUp, pageDown, home, end }

class _ScrollIntent extends Intent {
  const _ScrollIntent(this.kind);

  final _ScrollKind kind;
}

const _shortcuts = <ShortcutActivator, Intent>{
  SingleActivator(LogicalKeyboardKey.arrowUp): _ScrollIntent(
    _ScrollKind.lineUp,
  ),
  SingleActivator(LogicalKeyboardKey.arrowDown): _ScrollIntent(
    _ScrollKind.lineDown,
  ),
  SingleActivator(LogicalKeyboardKey.pageUp): _ScrollIntent(_ScrollKind.pageUp),
  SingleActivator(LogicalKeyboardKey.pageDown): _ScrollIntent(
    _ScrollKind.pageDown,
  ),
  SingleActivator(LogicalKeyboardKey.home): _ScrollIntent(_ScrollKind.home),
  SingleActivator(LogicalKeyboardKey.end): _ScrollIntent(_ScrollKind.end),
};

/// Resolved visual properties for an [AgentConversation].
///
/// Every slot is empty by default; presets supply the look.
// No target: mix_generator 2.2.0-beta.3 emits InvalidType for constructor
// parameters typed with stylers generated in the same build (the nested
// component styles), as CalendarSpec notes.
@MixableSpec()
@immutable
final class AgentConversationSpec with _$AgentConversationSpec {
  /// The transcript's frame.
  @override
  final StyleSpec<BoxSpec> container;

  /// Wraps each turn.
  @override
  final StyleSpec<BoxSpec> turn;

  /// The widest a turn grows; turns center in a wider transcript.
  @override
  final double? maxWidth;

  /// The space around the turns, inside the scrolling area.
  @override
  @MixableField(skipMixin: true)
  final EdgeInsetsGeometry? padding;

  /// The space between turns.
  @override
  final double? turnSpacing;

  /// The space between the blocks of an [AgentTurn].
  @override
  final double? blockSpacing;

  /// Places the way back to the latest output over the transcript's bottom
  /// edge.
  @override
  final StyleSpec<BoxSpec> latest;

  /// Wraps [AgentConversation.empty].
  @override
  final StyleSpec<BoxSpec> empty;

  /// Creates a spec; every slot defaults to empty.
  const AgentConversationSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<BoxSpec>? turn,
    this.maxWidth,
    this.padding,
    this.turnSpacing,
    this.blockSpacing,
    StyleSpec<BoxSpec>? latest,
    StyleSpec<BoxSpec>? empty,
  }) : container = container ?? const StyleSpec(spec: BoxSpec()),
       turn = turn ?? const StyleSpec(spec: BoxSpec()),
       latest = latest ?? const StyleSpec(spec: BoxSpec()),
       empty = empty ?? const StyleSpec(spec: BoxSpec());
}
