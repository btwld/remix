import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Central namespace for Naked UI intent helpers. Access widget-specific helpers
/// via namespaces such as `NakedIntentActions.button.shortcuts` and
/// `NakedIntentActions.button.actions(...)`. Each helper returns the concrete
/// types expected for that widget to keep usage strongly typed and predictable.
///
/// This class is not intended to be instantiated or extended; use the static
/// members to access the helpers.
class NakedIntentActions {
  /// Intent bindings for button activation.
  static const _ButtonIntentActions button = _ButtonIntentActions();

  /// Intent bindings for Link activation.
  static const _LinkIntentActions link = _LinkIntentActions();

  /// Intent bindings for checkbox activation.
  static const _CheckboxIntentActions checkbox = _CheckboxIntentActions();

  /// Intent bindings for binary toggle activation.
  static const _ToggleIntentActions toggle = _ToggleIntentActions();

  /// Intent bindings for accordion item activation.
  static const _AccordionIntentActions accordion = _AccordionIntentActions();

  /// Intent bindings for tab activation and navigation.
  static const _TabIntentActions tab = _TabIntentActions();

  /// Intent bindings for menu dismissal and navigation.
  static const _MenuIntentActions menu = _MenuIntentActions();

  /// Intent bindings for menu-bar traversal.
  static const _MenubarIntentActions menubar = _MenubarIntentActions();

  /// Intent bindings for select dismissal and navigation.
  static const _SelectIntentActions select = _SelectIntentActions();

  /// Intent bindings for dialog dismissal.
  static const _DialogIntentActions dialog = _DialogIntentActions();
}

// Intent helpers for button and activation-based widgets

class _ButtonIntentActions {
  const _ButtonIntentActions();

  Map<ShortcutActivator, Intent> get shortcuts => _buttonShortcuts;

  Map<Type, Action<Intent>> actions({required VoidCallback onPressed}) =>
      _activation(onPressed);
}

class _LinkIntentActions {
  const _LinkIntentActions();

  Map<ShortcutActivator, Intent> get shortcuts => _linkShortcuts;

  Map<Type, Action<Intent>> actions({required VoidCallback onPressed}) =>
      <Type, Action<Intent>>{
        _LinkActivateIntent: CallbackAction<_LinkActivateIntent>(
          onInvoke: (_) => onPressed(),
        ),
      };
}

class _CheckboxIntentActions {
  const _CheckboxIntentActions();

  Map<ShortcutActivator, Intent> get shortcuts => _buttonShortcuts;

  Map<Type, Action<Intent>> actions({required VoidCallback onToggle}) =>
      _activation(onToggle);
}

class _ToggleIntentActions {
  const _ToggleIntentActions();

  Map<ShortcutActivator, Intent> get shortcuts => _buttonShortcuts;

  Map<Type, Action<Intent>> actions({required VoidCallback onToggle}) =>
      _activation(onToggle);
}

class _AccordionIntentActions {
  const _AccordionIntentActions();

  Map<ShortcutActivator, Intent> get shortcuts => _buttonShortcuts;

  Map<Type, Action<Intent>> actions({required VoidCallback onToggle}) =>
      _activation(onToggle);
}

// Intent helpers for tab widgets

class _TabIntentActions {
  const _TabIntentActions();

  Map<ShortcutActivator, Intent> get shortcuts => _tabShortcuts;

  Map<Type, Action<Intent>> actions({
    required VoidCallback onActivate,
    required ValueChanged<TraversalDirection> onDirectionalFocus,
    VoidCallback? onFirstFocus,
    VoidCallback? onLastFocus,
  }) {
    final map = _activation(onActivate);
    map[DirectionalFocusIntent] = CallbackAction<DirectionalFocusIntent>(
      onInvoke: (intent) => onDirectionalFocus(intent.direction),
    );

    if (onFirstFocus != null) {
      map[_FirstFocusIntent] = CallbackAction<_FirstFocusIntent>(
        onInvoke: (_) => onFirstFocus(),
      );
    }

    if (onLastFocus != null) {
      map[_LastFocusIntent] = CallbackAction<_LastFocusIntent>(
        onInvoke: (_) => onLastFocus(),
      );
    }

    return map;
  }
}

// Intent helpers for menu and overlay collection widgets

class _MenuIntentActions {
  const _MenuIntentActions();

  Map<ShortcutActivator, Intent> get shortcuts => _menuShortcuts;

  Map<Type, Action<Intent>> actions({
    required VoidCallback onDismiss,
    required VoidCallback onFirstFocus,
    required VoidCallback onLastFocus,
  }) => {
    DismissIntent: CallbackAction<DismissIntent>(onInvoke: (_) => onDismiss()),
    NextFocusIntent: NextFocusAction(),
    PreviousFocusIntent: PreviousFocusAction(),
    _FirstFocusIntent: CallbackAction<_FirstFocusIntent>(
      onInvoke: (_) => onFirstFocus(),
    ),
    _LastFocusIntent: CallbackAction<_LastFocusIntent>(
      onInvoke: (_) => onLastFocus(),
    ),
  };
}

// Intent helpers for menu bars

class _MenubarIntentActions {
  const _MenubarIntentActions();

  /// Left/right (direction-aware) and Home/End move between bar triggers.
  Map<ShortcutActivator, Intent> barShortcuts(TextDirection direction) {
    final nextKey = direction == TextDirection.ltr
        ? LogicalKeyboardKey.arrowRight
        : LogicalKeyboardKey.arrowLeft;
    final previousKey = direction == TextDirection.ltr
        ? LogicalKeyboardKey.arrowLeft
        : LogicalKeyboardKey.arrowRight;

    return <ShortcutActivator, Intent>{
      SingleActivator(nextKey): _MenubarNextIntent(),
      SingleActivator(previousKey): _MenubarPreviousIntent(),
      SingleActivator(LogicalKeyboardKey.home): _FirstFocusIntent(),
      SingleActivator(LogicalKeyboardKey.end): _LastFocusIntent(),
    };
  }

  /// Up/Down on a bar trigger opens that menu.
  Map<ShortcutActivator, Intent> get triggerShortcuts =>
      <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.arrowDown): _OpenOverlayIntent(),
        SingleActivator(LogicalKeyboardKey.arrowUp): _OpenOverlayIntent(),
      };

  /// Actions for [barShortcuts].
  Map<Type, Action<Intent>> barActions({
    required VoidCallback onNext,
    required VoidCallback onPrevious,
    required VoidCallback onFirst,
    required VoidCallback onLast,
  }) {
    return <Type, Action<Intent>>{
      _MenubarNextIntent: CallbackAction<_MenubarNextIntent>(
        onInvoke: (_) => onNext(),
      ),
      _MenubarPreviousIntent: CallbackAction<_MenubarPreviousIntent>(
        onInvoke: (_) => onPrevious(),
      ),
      _FirstFocusIntent: CallbackAction<_FirstFocusIntent>(
        onInvoke: (_) => onFirst(),
      ),
      _LastFocusIntent: CallbackAction<_LastFocusIntent>(
        onInvoke: (_) => onLast(),
      ),
    };
  }

  Map<Type, Action<Intent>> triggerActions({required VoidCallback onOpen}) {
    return <Type, Action<Intent>>{
      _OpenOverlayIntent: CallbackAction<_OpenOverlayIntent>(
        onInvoke: (_) => onOpen(),
      ),
    };
  }
}

/// Intent: move to the next menu-bar trigger.
class _MenubarNextIntent extends Intent {
  const _MenubarNextIntent();
}

/// Intent: move to the previous menu-bar trigger.
class _MenubarPreviousIntent extends Intent {
  const _MenubarPreviousIntent();
}

// Intent helpers for select and combobox widgets

class _SelectIntentActions {
  const _SelectIntentActions();

  Map<ShortcutActivator, Intent> get shortcuts => _selectShortcuts;

  Map<Type, Action<Intent>> actions({
    VoidCallback? onDismiss,
    VoidCallback? onOpenOverlay,
    VoidCallback? onPageUp,
    VoidCallback? onPageDown,
  }) {
    final map = <Type, Action<Intent>>{
      if (onDismiss != null)
        DismissIntent: CallbackAction<DismissIntent>(
          onInvoke: (_) => onDismiss(),
        ),
    };

    if (onOpenOverlay != null) {
      map[_OpenOverlayIntent] = CallbackAction<_OpenOverlayIntent>(
        onInvoke: (_) => onOpenOverlay(),
      );
    }

    if (onPageUp != null) {
      map[_PageUpIntent] = CallbackAction<_PageUpIntent>(
        onInvoke: (_) => onPageUp(),
      );
    }

    if (onPageDown != null) {
      map[_PageDownIntent] = CallbackAction<_PageDownIntent>(
        onInvoke: (_) => onPageDown(),
      );
    }

    return map;
  }
}

// Intent helpers for dialog widgets

class _DialogIntentActions {
  const _DialogIntentActions();

  Map<ShortcutActivator, Intent> get shortcuts => _dialogShortcuts;

  Map<Type, Action<Intent>> actions({required VoidCallback onDismiss}) => {
    DismissIntent: CallbackAction<DismissIntent>(onInvoke: (_) => onDismiss()),
  };
}

// Shared shortcut definitions and helper functions

const Map<ShortcutActivator, Intent> _buttonShortcuts =
    <ShortcutActivator, Intent>{
      SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
      SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
      SingleActivator(LogicalKeyboardKey.numpadEnter): ButtonActivateIntent(),
    };

const Map<ShortcutActivator, Intent> _linkShortcuts =
    <ShortcutActivator, Intent>{
      SingleActivator(LogicalKeyboardKey.enter, includeRepeats: false):
          _LinkActivateIntent(),
      SingleActivator(LogicalKeyboardKey.numpadEnter, includeRepeats: false):
          _LinkActivateIntent(),
    };

const Map<ShortcutActivator, Intent> _tabShortcuts =
    <ShortcutActivator, Intent>{
      SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
      SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
      SingleActivator(LogicalKeyboardKey.numpadEnter): ButtonActivateIntent(),
      SingleActivator(LogicalKeyboardKey.arrowLeft): DirectionalFocusIntent(
        TraversalDirection.left,
      ),
      SingleActivator(LogicalKeyboardKey.arrowRight): DirectionalFocusIntent(
        TraversalDirection.right,
      ),
      SingleActivator(LogicalKeyboardKey.arrowUp): DirectionalFocusIntent(
        TraversalDirection.up,
      ),
      SingleActivator(LogicalKeyboardKey.arrowDown): DirectionalFocusIntent(
        TraversalDirection.down,
      ),
      SingleActivator(LogicalKeyboardKey.home): _FirstFocusIntent(),
      SingleActivator(LogicalKeyboardKey.end): _LastFocusIntent(),
    };

const Map<ShortcutActivator, Intent> _menuShortcuts =
    <ShortcutActivator, Intent>{
      SingleActivator(LogicalKeyboardKey.escape): DismissIntent(),
      SingleActivator(LogicalKeyboardKey.arrowDown): NextFocusIntent(),
      SingleActivator(LogicalKeyboardKey.arrowUp): PreviousFocusIntent(),
      SingleActivator(LogicalKeyboardKey.home): _FirstFocusIntent(),
      SingleActivator(LogicalKeyboardKey.end): _LastFocusIntent(),
    };

const Map<ShortcutActivator, Intent> _selectShortcuts =
    <ShortcutActivator, Intent>{
      SingleActivator(LogicalKeyboardKey.escape): DismissIntent(),
      SingleActivator(LogicalKeyboardKey.arrowDown): NextFocusIntent(),
      SingleActivator(LogicalKeyboardKey.arrowUp): PreviousFocusIntent(),
      SingleActivator(LogicalKeyboardKey.pageUp): _PageUpIntent(),
      SingleActivator(LogicalKeyboardKey.pageDown): _PageDownIntent(),
      SingleActivator(LogicalKeyboardKey.arrowDown, alt: true):
          _OpenOverlayIntent(),
      SingleActivator(LogicalKeyboardKey.arrowUp, alt: true): DismissIntent(),
    };

const Map<ShortcutActivator, Intent> _dialogShortcuts =
    <ShortcutActivator, Intent>{
      SingleActivator(LogicalKeyboardKey.escape): DismissIntent(),
    };

Map<Type, Action<Intent>> _activation(VoidCallback handler) {
  return <Type, Action<Intent>>{
    ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) => handler()),
    ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
      onInvoke: (_) => handler(),
    ),
  };
}

/// Intent: activate a Link without inheriting Button/Space behavior.
class _LinkActivateIntent extends Intent {
  const _LinkActivateIntent();
}

/// Intent: Move focus to first item in a collection.
class _FirstFocusIntent extends Intent {
  const _FirstFocusIntent();
}

/// Intent: Move focus to last item in a collection.
class _LastFocusIntent extends Intent {
  const _LastFocusIntent();
}

/// Intent: Move focus by page up (large jump backward).
class _PageUpIntent extends Intent {
  const _PageUpIntent();
}

/// Intent: Move focus by page down (large jump forward).
class _PageDownIntent extends Intent {
  const _PageDownIntent();
}

/// Intent: Open overlay/dropdown.
class _OpenOverlayIntent extends Intent {
  const _OpenOverlayIntent();
}
