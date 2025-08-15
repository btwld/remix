import 'package:flutter/widgets.dart';

extension WidgetStateControllerExt on WidgetStatesController {
  void setHovered(bool state) {
    update(WidgetState.hovered, state);
  }
}
