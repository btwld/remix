part of 'combobox.dart';

/// A fully open panel as an image, with where it was, for the exit.
final class _PanelSnapshot {
  _PanelSnapshot(this.image, this.rect);

  final ui.Image image;

  /// The panel's bounds in global coordinates.
  final Rect rect;
}

/// Owns the exit of a combobox panel.
///
/// RawAutocomplete unmounts the panel as soon as the suggestions hide, so a
/// transition cannot keep the panel itself mounted as menu and popover do.
/// The open panel hands its last snapshot here when it unmounts, and the exit
/// plays on that image in the nearest [Overlay] until it is dismissed.
class _ComboboxExitScope extends StatefulWidget {
  const _ComboboxExitScope({required this.builder});

  final Widget Function(BuildContext context, _ComboboxExit exit) builder;

  @override
  State<_ComboboxExitScope> createState() => _ComboboxExitScopeState();
}

class _ComboboxExitScopeState extends State<_ComboboxExitScope>
    with TickerProviderStateMixin
    implements _ComboboxExit {
  @override
  final fieldKey = GlobalKey();

  AnimationController? _controller;
  OverlayEntry? _entry;
  _PanelSnapshot? _snapshot;

  @override
  void opened() {
    // The panel mounts during a build; changing the overlay waits for it.
    SchedulerBinding.instance.addPostFrameCallback((_) => _dismiss());
  }

  @override
  void closed(
    _PanelSnapshot? snapshot,
    RemixPanelTransition transition, {
    required bool reduceMotion,
  }) {
    if (!mounted || snapshot == null || reduceMotion) {
      snapshot?.image.dispose();
      return;
    }
    // The panel unmounts during a build; the ghost enters afterwards.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        snapshot.image.dispose();
        return;
      }
      _play(snapshot, transition);
    });
  }

  @override
  Rect anchorRect(BuildContext context) {
    final box = fieldKey.currentContext?.findRenderObject();
    final overlay = Overlay.maybeOf(context)?.context.findRenderObject();
    if (box is! RenderBox || !box.attached || overlay is! RenderBox) {
      return Rect.zero;
    }

    return box.localToGlobal(Offset.zero, ancestor: overlay) & box.size;
  }

  void _play(_PanelSnapshot snapshot, RemixPanelTransition transition) {
    final overlay = Overlay.maybeOf(context);
    final overlayBox = overlay?.context.findRenderObject();
    if (overlay == null || overlayBox is! RenderBox) {
      snapshot.image.dispose();
      return;
    }
    _dismiss();
    final controller = AnimationController(
      vsync: this,
      duration: transition.duration,
      reverseDuration: transition.reverseDuration ?? transition.duration,
      value: 1,
    );
    final rect =
        overlayBox.globalToLocal(snapshot.rect.topLeft) & snapshot.rect.size;
    final anchor = anchorRect(context);
    final entry = OverlayEntry(
      builder: (context) => Positioned.fromRect(
        rect: rect,
        child: ExcludeSemantics(
          child: IgnorePointer(
            child: Builder(
              builder: (context) => transition.builder(
                context,
                RemixPanelTransitionInfo(
                  animation: controller,
                  anchorRect: anchor,
                ),
                RawImage(
                  image: snapshot.image,
                  width: rect.width,
                  height: rect.height,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    _controller = controller;
    _entry = entry;
    _snapshot = snapshot;
    overlay.insert(entry);
    controller.reverse().whenComplete(() {
      if (_controller == controller) _dismiss();
    });
  }

  void _dismiss() {
    _entry?.remove();
    _entry?.dispose();
    _entry = null;
    _controller?.dispose();
    _controller = null;
    _snapshot?.image.dispose();
    _snapshot = null;
  }

  @override
  void dispose() {
    _dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, this);
}

/// What the panel host needs from the exit scope.
abstract interface class _ComboboxExit {
  /// Marks the editor, so the transition can report its bounds.
  GlobalKey get fieldKey;

  /// A panel mounted: an exit still playing is dropped.
  void opened();

  /// The panel unmounted, leaving [snapshot] of how it last looked.
  void closed(
    _PanelSnapshot? snapshot,
    RemixPanelTransition transition, {
    required bool reduceMotion,
  });

  /// The editor's bounds in the overlay's coordinate space.
  Rect anchorRect(BuildContext context);
}

/// Runs the open of one panel and keeps a snapshot of it for the exit.
class _ComboboxPanelHost extends StatefulWidget {
  const _ComboboxPanelHost({
    required this.exit,
    required this.transition,
    required this.child,
  });

  final _ComboboxExit exit;
  final RemixPanelTransition transition;
  final Widget child;

  @override
  State<_ComboboxPanelHost> createState() => _ComboboxPanelHostState();
}

class _ComboboxPanelHostState extends State<_ComboboxPanelHost>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final _boundary = GlobalKey();
  _PanelSnapshot? _snapshot;
  bool _started = false;
  bool _reduceMotion = false;
  late RemixPanelTransition _transition = widget.transition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.transition.duration,
      reverseDuration:
          widget.transition.reverseDuration ?? widget.transition.duration,
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) _captureAfterFrame();
    });
    widget.exit.opened();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    _reduceMotion = remixReducedMotionOf(context);
    if (_reduceMotion) {
      _controller.value = 1;
      _captureAfterFrame();
    } else {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(_ComboboxPanelHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    _transition = widget.transition;
  }

  void _captureAfterFrame() =>
      SchedulerBinding.instance.addPostFrameCallback((_) => _capture());

  void _capture() {
    if (!mounted || _controller.value < 1) return;
    final object = _boundary.currentContext?.findRenderObject();
    if (object is! RenderRepaintBoundary ||
        !object.attached ||
        object.debugNeedsPaint) {
      return;
    }
    final view = View.maybeOf(context);
    final image = object.toImageSync(pixelRatio: view?.devicePixelRatio ?? 1);
    _snapshot?.image.dispose();
    _snapshot = _PanelSnapshot(
      image,
      object.localToGlobal(Offset.zero) & object.size,
    );
  }

  @override
  void dispose() {
    widget.exit.closed(_snapshot, _transition, reduceMotion: _reduceMotion);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Once open, keep the snapshot current as the suggestions change.
    if (_controller.value >= 1) _captureAfterFrame();

    return Builder(
      builder: (context) => widget.transition.builder(
        context,
        RemixPanelTransitionInfo(
          animation: _controller,
          anchorRect: widget.exit.anchorRect(context),
        ),
        RepaintBoundary(key: _boundary, child: widget.child),
      ),
    );
  }
}

/// `ComboboxStyler.panelTransition`, as on the menu and the popover.
extension ComboboxStylerPanelTransition on ComboboxStyler {
  /// Opens and closes the suggestions panel with [transition].
  ComboboxStyler panelTransition(RemixPanelTransition transition) =>
      panel(ComboboxPanelStyler().panelTransition(transition));
}
