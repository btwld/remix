/// Base abstractions for overlay widgets like [NakedMenu] and [NakedSelect].
///
/// This file provides:
/// - [OverlayScope]: [InheritedWidget] pattern for overlay context.
/// - [OverlayItem]: Base class for overlay items (actions and options).
/// - [OverlayStateMixin]: State management for overlay widgets.
library;

import 'dart:ui' show SemanticsRole;

import 'package:flutter/widgets.dart';

import '../naked_button.dart';
import '../naked_menu.dart';
import '../naked_select.dart';
import '../utilities/anchored_overlay.dart';
import '../utilities/naked_state_scope.dart';
import '../utilities/state.dart';

// Overlay scope pattern implementation

/// Base class for overlay scope widgets that provide context to their children.
///
/// Provides the [InheritedWidget] scope pattern used by [NakedMenu] and
/// [NakedSelect].
abstract class OverlayScope<T> extends InheritedWidget {
  /// Creates a scope that exposes overlay state to [child].
  const OverlayScope({required super.child, super.key});

  /// Returns the scope of the specified type that most tightly encloses the given [context].
  ///
  /// Returns `null` if no scope of the specified type is found.
  @protected
  static S? maybeOf<S extends OverlayScope>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }

  /// Returns the scope of the specified type that most tightly encloses the given [context].
  ///
  /// Throws a [FlutterError] if no matching scope is found.
  @protected
  static S of<S extends OverlayScope>(
    BuildContext context, {
    required Type scopeConsumer,
    required Type scopeOwner,
  }) {
    final S? result = maybeOf<S>(context);
    if (result == null) {
      throw FlutterError.fromParts([
        ErrorSummary('$scopeConsumer requires a $scopeOwner ancestor.'),
        ErrorDescription(
          'The $scopeConsumer widget must be placed inside the overlayBuilder '
          'callback of a $scopeOwner widget.',
        ),
        ErrorHint(
          'Ensure that $scopeConsumer is only used within:\n'
          '$scopeOwner(\n'
          '  overlayBuilder: (context, info) {\n'
          '    return $scopeConsumer(...); // ✓ Correct usage\n'
          '  },\n'
          ')',
        ),
        context.describeElement('The context used was'),
      ]);
    }

    return result;
  }
}

// Base implementation for overlay item widgets

/// Base class for selectable or actionable items in overlay panels.
abstract class OverlayItem<T, S extends NakedState> extends StatelessWidget {
  /// Creates an overlay item associated with [value].
  const OverlayItem({
    super.key,
    required this.value,
    this.enabled = true,
    this.semanticLabel,
    this.child,
    this.builder,
  }) : assert(
         child != null || builder != null,
         'Either child or builder must be provided',
       );

  /// The value associated with this item.
  final T value;

  /// Whether this item is enabled for interaction.
  final bool enabled;

  /// The semantic label for accessibility.
  final String? semanticLabel;

  /// The child widget to display.
  final Widget? child;

  /// A builder function for custom styling based on widget states.
  final ValueWidgetBuilder<S>? builder;

  /// Builds a [NakedButton] with state mapping and semantics for this item.
  @protected
  Widget buildButton({
    required VoidCallback? onPressed,
    required bool effectiveEnabled,
    bool? isSelected,
    bool? isChecked,
    bool? inMutuallyExclusiveGroup,
    SemanticsRole? semanticsRole,
    FocusNode? focusNode,
    required S Function(Set<WidgetState> states) mapStates,
  }) {
    final button = Builder(
      builder: (context) => Listener(
        behavior: HitTestBehavior.translucent,
        // Unlike a hover enter, a hover only arrives when the pointer moves, not
        // when content scrolls under a resting pointer.
        onPointerHover: (event) {
          if (effectiveEnabled && event.delta != Offset.zero) {
            AnchoredOverlay.clearItemFocus(context);
          }
        },
        child: NakedButton(
          onPressed: onPressed,
          enabled: effectiveEnabled,
          focusNode: focusNode,
          semanticLabel: semanticLabel,
          child: child,
          builder: builder == null
              ? null
              : (context, buttonState, child) {
                  final effectiveStates = <WidgetState>{...buttonState.states};
                  if (isSelected == true || isChecked == true) {
                    effectiveStates.add(WidgetState.selected);
                  }

                  // Install a NakedStateScope<S> for the mapped item state so the
                  // builder honors the public invariant: every ValueWidgetBuilder<S>
                  // receives a context containing a matching NakedStateScope<S>,
                  // making S.of(context) and S.controllerOf(context) resolve to the
                  // item state without leaking the internal NakedButton scope.
                  // Mirrors how the NakedSelect trigger scopes NakedSelectState.
                  return NakedStateScopeBuilder<S>(
                    value: mapStates(effectiveStates),
                    child: child,
                    builder: builder,
                  );
                },
        ),
      ),
    );

    if (semanticsRole == null &&
        isSelected == null &&
        isChecked == null &&
        inMutuallyExclusiveGroup == null) {
      return button;
    }

    return MergeSemantics(
      child: Semantics(
        role: semanticsRole,
        selected: isSelected,
        checked: isChecked,
        inMutuallyExclusiveGroup: inMutuallyExclusiveGroup,
        child: button,
      ),
    );
  }
}

// State management utilities for overlay widgets

/// Mixin that manages selection sessions and lifecycle callbacks for overlays.
mixin OverlayStateMixin<T extends StatefulWidget> on State<T> {
  bool _selectionMadeDuringSession = false;

  /// Whether a selection was made during the current session.
  @protected
  bool get selectionMadeDuringSession => _selectionMadeDuringSession;

  /// Resets selection tracking and invokes [onOpen].
  @protected
  void handleOpen(VoidCallback? onOpen) {
    _selectionMadeDuringSession = false;
    onOpen?.call();
  }

  /// Handles overlay closure, invoking [onCanceled] if no selection occurred.
  ///
  /// Always invokes [onClose] and requests focus on [triggerFocusNode] when
  /// provided.
  @protected
  void handleClose({
    VoidCallback? onClose,
    VoidCallback? onCanceled,
    FocusNode? triggerFocusNode,
  }) {
    if (!_selectionMadeDuringSession) {
      onCanceled?.call();
    }
    onClose?.call();
    triggerFocusNode?.requestFocus();
  }

  /// Marks that a selection was made during the current session.
  ///
  /// Prevents [handleClose] from invoking `onCanceled` when the overlay closes.
  @protected
  void markSelectionMade() {
    _selectionMadeDuringSession = true;
  }

  /// Forwards [hideOverlay] to [onCloseRequested] only while [controller] is
  /// open, ignoring close requests sent to already-closed anchors.
  @protected
  void handleCloseRequested({
    required MenuController controller,
    required RawMenuAnchorCloseRequestedCallback? onCloseRequested,
    required VoidCallback hideOverlay,
  }) {
    if (!controller.isOpen || onCloseRequested == null) {
      hideOverlay();
    } else {
      onCloseRequested(hideOverlay);
    }
  }
}
