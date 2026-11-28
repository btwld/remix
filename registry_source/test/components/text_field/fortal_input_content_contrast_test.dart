import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:remix/remix.dart';

import '../../helpers/contrast.dart';
import '../../helpers/test_helpers.dart';

void main() {
  for (final accent in FortalAccentColor.values) {
    for (final dark in [false, true]) {
      testWidgets(
        '${accent.name}/${dark ? 'dark' : 'light'} input content contrast',
        (tester) async {
          for (final area in [false, true]) {
            for (final soft in [false, true]) {
              const iconKey = Key('leading');
              late TextFieldSpec spec;
              late FortalThemeColors colors;
              await tester.pumpRemixApp(
                Builder(
                  builder: (context) {
                    expect(
                      FortalTheme.of(context).brightness,
                      dark ? Brightness.dark : Brightness.light,
                    );
                    colors = resolveFortalTokens(FortalTheme.of(context));
                    spec = area
                        ? fortalTextAreaStyle(
                            variant: soft ? .soft : .surface,
                          ).build(context).spec
                        : fortalTextFieldStyle(
                            variant: soft ? .soft : .surface,
                          ).build(context).spec;
                    return area
                        ? FortalTextArea(
                            variant: soft ? .soft : .surface,
                            hintText: 'Hint',
                            leading: const Icon(Icons.search, key: iconKey),
                          )
                        : FortalTextField(
                            variant: soft ? .soft : .surface,
                            hintText: 'Hint',
                            leading: const Icon(Icons.search, key: iconKey),
                          );
                  },
                ),
                accent: accent,
                mode: dark ? .dark : .light,
                // The content gate applies to the high contrast switch.
                highContrast: true,
              );
              final iconColor = IconTheme.of(
                tester.element(find.byKey(iconKey)),
              ).color!;
              final hint = spec.hintText.spec.style!.color!;
              final fill =
                  (spec.container.spec.decoration as BoxDecoration).color!;
              final reason = '$accent/$dark/area=$area/soft=$soft';
              for (final panel in [
                colors.colorBackground,
                colors.colorPanelSolid,
              ]) {
                expect(
                  compositedContrast(
                    foreground: iconColor,
                    fill: fill,
                    panel: panel,
                  ),
                  greaterThanOrEqualTo(3),
                  reason: '$reason icon',
                );
                expect(
                  compositedContrast(
                    foreground: hint,
                    fill: fill,
                    panel: panel,
                  ),
                  greaterThanOrEqualTo(4.5),
                  reason: '$reason hint',
                );
              }
              // Both looks are neutral; high contrast lifts muted content
              // from gray 10 to gray 11.
              expect(iconColor, colors.gray.scale.step(11), reason: reason);
              expect(hint, colors.gray.scale.step(11), reason: reason);
              expect(tester.takeException(), isNull);
            }
          }
        },
      );
    }
  }

  testWidgets(
    'soft input base icon overrides and disabled-state overrides retain precedence',
    (tester) async {
      const custom = Color(0xff8038cc);
      for (final dark in [false, true]) {
        for (final area in [false, true]) {
          for (final enabled in [false, true]) {
            for (final overrideDisabled in [false, true]) {
              const iconKey = Key('base-leading');
              final base = TextFieldStyler().wrap(.iconTheme(color: custom));
              final style = overrideDisabled
                  ? base.onDisabled(
                      TextFieldStyler().wrap(.iconTheme(color: custom)),
                    )
                  : base;
              await tester.pumpRemixApp(
                Builder(
                  builder: (context) {
                    expect(
                      FortalTheme.of(context).brightness,
                      dark ? Brightness.dark : Brightness.light,
                    );
                    return area
                        ? FortalTextArea.soft(
                            enabled: enabled,
                            leading: const Icon(Icons.search, key: iconKey),
                            style: style,
                          )
                        : FortalTextField.soft(
                            enabled: enabled,
                            leading: const Icon(Icons.search, key: iconKey),
                            style: style,
                          );
                  },
                ),
                accent: .mar,
                mode: dark ? .dark : .light,
              );
              // Disabled fades the box and keeps the content colors, so a
              // base override holds whether or not it is repeated there.
              expect(
                IconTheme.of(tester.element(find.byKey(iconKey))).color,
                custom,
              );
              expect(tester.takeException(), isNull);
            }
          }
        }
      }
    },
  );

  testWidgets(
    'disabled hints/icons and enabled caller overrides retain precedence',
    (tester) async {
      const custom = Color(0xff8038cc);
      for (final dark in [false, true]) {
        for (final area in [false, true]) {
          for (final soft in [false, true]) {
            for (final enabled in [false, true]) {
              const iconKey = Key('leading');
              late FortalThemeColors colors;
              final override = TextFieldStyler().onEnabled(
                TextFieldStyler()
                    .hintText(TextStyler().color(custom))
                    .wrap(.iconTheme(color: custom)),
              );
              late TextFieldSpec resolved;
              await tester.pumpRemixApp(
                Builder(
                  builder: (context) {
                    expect(
                      FortalTheme.of(context).brightness,
                      dark ? Brightness.dark : Brightness.light,
                    );
                    colors = resolveFortalTokens(FortalTheme.of(context));
                    return WidgetStateProvider(
                      states: {if (!enabled) WidgetState.disabled},
                      child: Builder(
                        builder: (context) {
                          resolved = area
                              ? fortalTextAreaStyle(
                                  variant: soft ? .soft : .surface,
                                  style: override,
                                ).build(context).spec
                              : fortalTextFieldStyle(
                                  variant: soft ? .soft : .surface,
                                  style: override,
                                ).build(context).spec;
                          return area
                              ? FortalTextArea(
                                  variant: soft ? .soft : .surface,
                                  enabled: enabled,
                                  hintText: 'Hint',
                                  leading: const Icon(
                                    Icons.search,
                                    key: iconKey,
                                  ),
                                  style: override,
                                )
                              : FortalTextField(
                                  variant: soft ? .soft : .surface,
                                  enabled: enabled,
                                  hintText: 'Hint',
                                  leading: const Icon(
                                    Icons.search,
                                    key: iconKey,
                                  ),
                                  style: override,
                                );
                        },
                      ),
                    );
                  },
                ),
                accent: .mar,
                mode: dark ? .dark : .light,
              );
              // Frame and content colors ease between states.
              await tester.pumpAndSettle();
              final muted = colors.gray.scale.step(10);
              expect(
                resolved.hintText.spec.style?.color,
                enabled ? custom : muted,
              );
              expect(
                IconTheme.of(tester.element(find.byKey(iconKey))).color,
                enabled ? custom : muted,
              );
              expect(tester.takeException(), isNull);
            }
          }
        }
      }
    },
  );
}
