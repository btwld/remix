import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../support/functional_glyph.dart';
import '../support/live_edge.dart';

part 'transcript.g.dart';

/// Chronological transcript with reader-aware live-edge following.
class UiTranscript extends StatefulWidget {
  const UiTranscript({
    super.key,
    required List<Widget> this.children,
    this.followOutput = true,
    this.followThreshold = 48.0,
    this.busy = false,
    this.busyLabel = 'Busy',
    this.label = 'Conversation',
    this.onFollowChanged,
    this.controller,
    this.clipBehavior = Clip.hardEdge,
    this.showLatestButton = true,
    this.latestLabel = 'Scroll to latest',
    this.latestIconBuilder,
    this.latestStyle = const IconButtonStyler.create(),
    this.style = const UiTranscriptStyler.create(),
    this.styleSpec,
  }) : itemCount = null,
       itemBuilder = null;

  /// Builds rows lazily, for transcripts too long to build at once.
  const UiTranscript.builder({
    super.key,
    required int this.itemCount,
    required IndexedWidgetBuilder this.itemBuilder,
    this.followOutput = true,
    this.followThreshold = 48.0,
    this.busy = false,
    this.busyLabel = 'Busy',
    this.label = 'Conversation',
    this.onFollowChanged,
    this.controller,
    this.clipBehavior = Clip.hardEdge,
    this.showLatestButton = true,
    this.latestLabel = 'Scroll to latest',
    this.latestIconBuilder,
    this.latestStyle = const IconButtonStyler.create(),
    this.style = const UiTranscriptStyler.create(),
    this.styleSpec,
  }) : children = null;

  /// The rows, oldest first. Null for [UiTranscript.builder].
  final List<Widget>? children;

  /// Number of rows built by [itemBuilder].
  final int? itemCount;

  /// Builds the row at an index, for [UiTranscript.builder].
  final IndexedWidgetBuilder? itemBuilder;

  /// Whether growing content keeps the newest row in view.
  ///
  /// A reader who scrolls away releases the edge until they return to it.
  final bool followOutput;

  /// Distance from the end, in logical pixels, that still counts as near it.
  final double followThreshold;

  /// Whether a turn is running; announced as [busyLabel].
  final bool busy;

  /// Accessible value announced while [busy].
  final String busyLabel;

  /// Accessible label of the transcript.
  final String label;

  /// Called when the reader leaves or returns to the live edge.
  final ValueChanged<bool>? onFollowChanged;

  /// Scroll controller. When null, the transcript owns one.
  final ScrollController? controller;

  /// How the list clips its rows.
  final Clip clipBehavior;

  /// Whether a reader away from the live edge is offered a way back to it.
  ///
  /// The button appears once the reader is more than [followThreshold] from
  /// the end and the transcript is not following, returns to the end
  /// (instantly when animations are disabled) and follows again.
  final bool showLatestButton;

  /// Accessible label of the scroll-to-latest button.
  final String latestLabel;

  /// Replaces the scroll-to-latest button's default icon.
  final RemixIconButtonIconBuilder? latestIconBuilder;

  /// Style of the scroll-to-latest button.
  final IconButtonStyler latestStyle;

  /// Style of the transcript's own slots.
  final UiTranscriptStyler style;

  /// A resolved spec that is used instead of resolving [style].
  final UiTranscriptSpec? styleSpec;

  @override
  State<UiTranscript> createState() => _UiTranscriptState();
}

class _UiTranscriptState extends State<UiTranscript> {
  ScrollController? _ownedController;
  late ScrollController _controller;
  late final UiLiveEdgeEngine _liveEdge;
  late final UiLiveEdgeScrollPhysics _physics;
  final FocusNode _viewportFocus = FocusNode(debugLabel: 'UiTranscript');
  final FocusNode _latestFocus = FocusNode(debugLabel: 'Scroll to latest');
  bool _showLatest = false;
  bool _returning = false;

  /// Publishes this surface's focus to the styles resolved above it.
  ///
  /// `focused` has no other source here: the slots resolve above any Naked
  /// control, so without this the `focus-visible` state could never activate.
  ///
  /// Only `focused`. Pointer states do not resolve on this slot, so a host's
  /// `onHovered` on [UiTranscriptSpec.viewport] has no effect: passing a
  /// controller stops Mix from mounting its own pointer detector.
  final WidgetStatesController _statesController = WidgetStatesController();

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? (_ownedController = ScrollController());
    _liveEdge = UiLiveEdgeEngine(
      enabled: widget.followOutput,
      threshold: widget.followThreshold,
      onChanged: _handleFollowChanged,
    );
    _physics = UiLiveEdgeScrollPhysics(
      liveEdge: _liveEdge,
      parent: const ClampingScrollPhysics(),
    );
    // Growth follows in layout; only the first extents need a jump.
    _scheduleFollow();
  }

  @override
  void didUpdateWidget(UiTranscript oldWidget) {
    super.didUpdateWidget(oldWidget);
    _liveEdge
      ..enabled = widget.followOutput
      ..threshold = widget.followThreshold;
    if (!identical(oldWidget.controller, widget.controller)) {
      final offset = _controller.hasClients ? _controller.offset : 0.0;
      final oldOwned = _ownedController;
      _ownedController = null;
      _controller =
          widget.controller ??
          (_ownedController = ScrollController(initialScrollOffset: offset));
      if (oldOwned != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) => oldOwned.dispose());
      }
      _scheduleFollow();
    } else if (!oldWidget.followOutput && widget.followOutput && !_returning) {
      _scheduleFollow();
    }
    // Build follows; a field write is enough.
    _showLatest = _latestWanted(null);
  }

  void _handleFollowChanged(bool following) {
    widget.onFollowChanged?.call(following);
    _updateLatest(null);
  }

  /// Whether the reader is away from the end without the transcript
  /// following them back, so the scroll-to-latest button should show.
  bool _latestWanted(ScrollMetrics? metrics) {
    if (!widget.showLatestButton) return false;
    if (_liveEdge.sticks) return false;
    final position = _controller.hasClients ? _controller.position : null;
    final current =
        metrics ??
        (position != null && position.hasContentDimensions ? position : null);
    if (current == null) return false;
    return current.maxScrollExtent - current.pixels > _liveEdge.threshold;
  }

  void _updateLatest(ScrollMetrics? metrics) {
    final next = _latestWanted(metrics);
    if (next == _showLatest || !mounted) return;
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _updateLatest(null));
      return;
    }
    setState(() => _showLatest = next);
  }

  void _returnToLatest() {
    final hadFocus = _latestFocus.hasFocus;
    _liveEdge.resume();
    _updateLatest(null);
    if (hadFocus) _viewportFocus.requestFocus();
    if (!_controller.hasClients) return;
    final position = _controller.position;
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
      _liveEdge.jumpToEnd(_controller);
      return;
    }
    _returning = true;
    position
        .animateTo(
          position.maxScrollExtent,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
        )
        .whenComplete(() {
          _returning = false;
          // Output may have grown while the animation ran.
          if (mounted && _liveEdge.following) _liveEdge.jumpToEnd(_controller);
        });
  }

  void _scheduleFollow() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _liveEdge.follow(_controller);
    });
  }

  bool _handleScroll(ScrollNotification notification) {
    if (notification.depth != 0) return false;
    _liveEdge.handleScroll(notification);
    _updateLatest(notification.metrics);
    return notification is OverscrollNotification;
  }

  void _handleIntent(_TranscriptScrollIntent intent) {
    if (!_controller.hasClients) return;
    final position = _controller.position;
    final target = switch (intent.kind) {
      _TranscriptScrollKind.lineUp => position.pixels - 50,
      _TranscriptScrollKind.lineDown => position.pixels + 50,
      _TranscriptScrollKind.pageUp =>
        position.pixels - position.viewportDimension * 0.8,
      _TranscriptScrollKind.pageDown =>
        position.pixels + position.viewportDimension * 0.8,
      _TranscriptScrollKind.home => position.minScrollExtent,
      _TranscriptScrollKind.end => position.maxScrollExtent,
    };
    // The jump reports a scroll update, which decides following like any
    // other reader scroll.
    position.jumpTo(
      target
          .clamp(position.minScrollExtent, position.maxScrollExtent)
          .toDouble(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RemixStyleSpecBuilder<UiTranscriptSpec>(
      style: widget.style,
      styleSpec: widget.styleSpec,
      controller: _statesController,
      builder: (context, spec) => Semantics(
        container: true,
        explicitChildNodes: true,
        label: widget.label,
        value: widget.busy ? widget.busyLabel : null,
        child: FocusableActionDetector(
          focusNode: _viewportFocus,
          onFocusChange: (focused) =>
              _statesController.update(WidgetState.focused, focused),
          shortcuts: _transcriptShortcuts,
          actions: <Type, Action<Intent>>{
            _TranscriptScrollIntent: CallbackAction<_TranscriptScrollIntent>(
              onInvoke: (intent) {
                _handleIntent(intent);
                return null;
              },
            ),
          },
          child: Box(
            styleSpec: spec.viewport,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final bounded = constraints.hasBoundedHeight;
                final list = NotificationListener<ScrollMetricsNotification>(
                  onNotification: (notification) {
                    if (notification.depth == 0) {
                      if (_liveEdge.needsFollow(notification.metrics)) {
                        _scheduleFollow();
                      }
                      _updateLatest(notification.metrics);
                    }
                    return false;
                  },
                  child: NotificationListener<ScrollNotification>(
                    onNotification: _handleScroll,
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(
                        overscroll: false,
                        physics: const ClampingScrollPhysics(),
                      ),
                      child: _buildList(spec, shrinkWrap: !bounded),
                    ),
                  ),
                );
                if (!bounded || !widget.showLatestButton) return list;
                return Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [list, if (_showLatest) _latestButton(spec)],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _latestButton(UiTranscriptSpec spec) => Box(
    styleSpec: spec.latest,
    child: RemixIconButton(
      key: const ValueKey('ui-transcript-latest'),
      icon: null,
      focusNode: _latestFocus,
      iconBuilder:
          widget.latestIconBuilder ??
          (context, iconSpec, icon) =>
              UiFunctionalGlyph(kind: .latest, spec: iconSpec),
      semanticLabel: widget.latestLabel,
      onPressed: _returnToLatest,
      style: widget.latestStyle,
    ),
  );

  Widget _buildList(UiTranscriptSpec spec, {required bool shrinkWrap}) {
    final children = widget.children;
    final count = children?.length ?? widget.itemCount!;
    final spacing = spec.spacing ?? 0;
    assert(spacing >= 0, 'UiTranscript spacing must be non-negative.');
    return ListView.separated(
      controller: _controller,
      shrinkWrap: shrinkWrap,
      physics: _physics,
      clipBehavior: widget.clipBehavior,
      itemCount: count,
      itemBuilder: (context, index) => Box(
        styleSpec: spec.item,
        child: children?[index] ?? widget.itemBuilder!(context, index),
      ),
      separatorBuilder: (context, index) => SizedBox(height: spacing),
    );
  }

  @override
  void dispose() {
    _ownedController?.dispose();
    _statesController.dispose();
    _viewportFocus.dispose();
    _latestFocus.dispose();
    super.dispose();
  }
}

enum _TranscriptScrollKind { lineUp, lineDown, pageUp, pageDown, home, end }

class _TranscriptScrollIntent extends Intent {
  const _TranscriptScrollIntent(this.kind);
  final _TranscriptScrollKind kind;
}

const _transcriptShortcuts = <ShortcutActivator, Intent>{
  SingleActivator(LogicalKeyboardKey.arrowUp): _TranscriptScrollIntent(
    _TranscriptScrollKind.lineUp,
  ),
  SingleActivator(LogicalKeyboardKey.arrowDown): _TranscriptScrollIntent(
    _TranscriptScrollKind.lineDown,
  ),
  SingleActivator(LogicalKeyboardKey.pageUp): _TranscriptScrollIntent(
    _TranscriptScrollKind.pageUp,
  ),
  SingleActivator(LogicalKeyboardKey.pageDown): _TranscriptScrollIntent(
    _TranscriptScrollKind.pageDown,
  ),
  SingleActivator(LogicalKeyboardKey.home): _TranscriptScrollIntent(
    _TranscriptScrollKind.home,
  ),
  SingleActivator(LogicalKeyboardKey.end): _TranscriptScrollIntent(
    _TranscriptScrollKind.end,
  ),
};

@MixableSpec(target: UiTranscript.new)
@immutable
final class UiTranscriptSpec with _$UiTranscriptSpec {
  /// Wraps the scrolling list.
  @override
  final StyleSpec<BoxSpec> viewport;

  /// Wraps each row.
  @override
  final StyleSpec<BoxSpec> item;

  /// Gap between rows, in logical pixels; defaults to 0.
  @override
  final double? spacing;

  /// Places the scroll-to-latest button over the bottom of the viewport.
  @override
  final StyleSpec<BoxSpec> latest;

  const UiTranscriptSpec({
    StyleSpec<BoxSpec>? viewport,
    StyleSpec<BoxSpec>? item,
    this.spacing,
    StyleSpec<BoxSpec>? latest,
  }) : viewport = viewport ?? const StyleSpec(spec: BoxSpec()),
       item = item ?? const StyleSpec(spec: BoxSpec()),
       latest = latest ?? const StyleSpec(spec: BoxSpec());
}
