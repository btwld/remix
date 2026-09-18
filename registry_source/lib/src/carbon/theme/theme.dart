// Adapted from remix_carbon at commit 606bfbb36 and from design tokens in the
// IBM Carbon Design System. Copyright 2026 the Remix authors; IBM Carbon
// Design System copyright IBM Corp. and the Carbon authors. Apache-2.0.
// SPDX-License-Identifier: Apache-2.0

/// The public Carbon foundation installed with the Carbon registry preset.
library;

export 'generated/carbon_component_tokens.dart' show CarbideComponentTokens;
export 'generated/carbon_palette.dart';
export 'generated/carbon_source_manifest.dart';
export 'generated/carbon_tokens.dart';
export 'generated/carbon_type.dart' show CarbideFontFamilies;
export 'layer.dart';
export 'layout.dart';
export 'motion.dart';
export 'token_types.dart'
    show CarbideBreakpointData, CarbideFluidTypeStyle, CarbideTextStyleData;
export 'theme_data.dart';
export 'theme_scope.dart';
export 'type.dart';
