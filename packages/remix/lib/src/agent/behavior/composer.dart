import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// The draft behind an Agent composer, with the rules for sending it.
///
/// It is a [TextEditingController], so the composer's text field uses it
/// directly. It adds the run state ([running]) and the send rules: when the
/// draft can be sent ([canSubmit]), taking it ([submit]), and what a key press
/// does ([handleKeyEvent]).
///
/// Enter sends. Shift+Enter and Enter during IME composition belong to the
/// field. Enter never becomes a newline in a composer that sends, even when
/// there is nothing to send or a run is live, and a held Enter sends once.
class AgentComposerController extends TextEditingController {
  /// Creates a composer draft holding [text].
  AgentComposerController({
    super.text,
    bool running = false,
    this.clearOnSubmit = true,
  }) : _running = running;

  /// Creates a composer draft from an existing editing [value].
  AgentComposerController.fromValue(
    super.value, {
    bool running = false,
    this.clearOnSubmit = true,
  }) : _running = running,
       super.fromValue();

  bool _running;

  /// Whether [submit] empties the field after taking the draft.
  bool clearOnSubmit;

  /// Whether a run is live. While it is, the draft cannot be sent and the
  /// composer offers to stop instead.
  bool get running => _running;

  set running(bool value) {
    if (value == _running) return;
    _running = value;
    notifyListeners();
  }

  /// Whether the draft has something to send: any text besides whitespace.
  bool get hasDraft => text.trim().isNotEmpty;

  /// Whether an input method is composing text. Enter then confirms the
  /// composition, not the message.
  bool get isComposing {
    final composing = value.composing;

    return composing.isValid && !composing.isCollapsed;
  }

  /// Whether the draft can be sent now: there is a draft and no run is live.
  bool get canSubmit => !_running && hasDraft;

  /// Takes the draft for sending.
  ///
  /// Returns the trimmed text and, when [clearOnSubmit] is true, empties the
  /// field. Returns null and leaves the draft as it is when [canSubmit] is
  /// false. It does not check for an input method's composition: a Send
  /// button sends the draft as shown, and only the Enter key, in
  /// [handleKeyEvent], defers to the composition.
  String? submit() {
    if (!canSubmit) return null;
    final prompt = text.trim();
    if (clearOnSubmit) clear();

    return prompt;
  }

  /// Applies the composer's Enter rules to [event].
  ///
  /// Call it from a [Focus.onKeyEvent] above the text field. Enter sends the
  /// draft through [onSubmit] when [submit] gives one; either way the key is
  /// handled, so it never falls through to a newline. A repeat of a held
  /// Enter is handled without sending. [allowSubmit] false keeps Enter
  /// handled but sends nothing, for a host that disables sending.
  ///
  /// The key is left to the field (ignored) when [onSubmit] is null, which
  /// makes the composer a plain multiline field, when Shift is held, and
  /// while an input method is composing.
  KeyEventResult handleKeyEvent(
    KeyEvent event, {
    required ValueChanged<String>? onSubmit,
    bool allowSubmit = true,
  }) {
    if (event is KeyUpEvent) return KeyEventResult.ignored;
    final isEnter =
        event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter;
    if (!isEnter ||
        onSubmit == null ||
        HardwareKeyboard.instance.isShiftPressed ||
        isComposing) {
      return KeyEventResult.ignored;
    }
    if (event is KeyDownEvent && allowSubmit) {
      final prompt = submit();
      if (prompt != null) onSubmit(prompt);
    }

    return KeyEventResult.handled;
  }
}
