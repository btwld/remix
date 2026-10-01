# remix_ui_fonts

`remix_ui_fonts` bundles open-licensed fonts for Flutter applications built
with Remix UI. The files ship inside the package, so text renders in the right
face on the first frame and offline, and every weight is a real file rather
than synthesized.

| Family | Constant | Weights | Upstream |
| --- | --- | --- | --- |
| Geist | `RemixFonts.geist` | 400, 500, 600, 700 | [vercel/geist-font](https://github.com/vercel/geist-font) v1.7.2 |
| Geist Mono | `RemixFonts.geistMono` | 400, 500 | [vercel/geist-font](https://github.com/vercel/geist-font) v1.7.2 |

Add the package, then pass a `RemixFonts` constant as the font family:

```dart
import 'package:flutter/widgets.dart';
import 'package:remix_ui_fonts/remix_ui_fonts.dart';

const body = TextStyle(fontFamily: RemixFonts.geist);
const code = TextStyle(
  fontFamily: RemixFonts.geistMono,
  fontWeight: FontWeight.w500,
);
```

Flutter exposes a package's fonts as `packages/<package>/<family>`, so the
constants hold fully qualified names and work from any consumer package
without a `package:` argument on `TextStyle`. A weight that is not bundled
falls back to the nearest one that is. Flutter bundles every font a
dependency declares, so each family adds its files to your app's size.

## Adding a font

In the [btwld/remix](https://github.com/btwld/remix) repository, each upstream
font project gets one directory under `lib/fonts/`:

1. Copy the unmodified static `.ttf` files and the upstream license into
   `lib/fonts/<project>/`.
2. Write `lib/fonts/<project>/fonts.lock.json` with the upstream repository,
   tag, commit, release asset, license, and a SHA-256 for every file. Follow
   `lib/fonts/geist/fonts.lock.json`.
3. Declare each family in `pubspec.yaml`, one entry per weight (and style),
   and list the license under `flutter: licenses` so it reaches the app's
   license page.
4. Add a `RemixFonts` constant, a row in the table above, and a section in
   `THIRD_PARTY_NOTICES.md`.

The package tests check every directory against its lock and the pubspec.
