library remix_label;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

part 'label_spec.dart';
part 'label_style.dart';
part 'label_widget.dart';

// Enum for icon position
enum IconPosition { leading, trailing }

// Builder typedef for full label customization
typedef RemixLabelBuilder = Widget Function(
  BuildContext context,
  LabelSpec spec,
  String text, // The label text passed to the widget
);

// Builder typedef for customizing text rendering
typedef RemixTextBuilder = Widget Function(
  BuildContext context,
  TextSpec spec,
  String text, // The actual text string
);

// Builder typedef for customizing icon rendering with position
typedef RemixIconBuilder = Widget Function(
  BuildContext context,
  IconSpec spec,
  IconData? icon, // The actual icon data (optional)
  IconPosition position, // The position of the icon (leading or trailing)
);
