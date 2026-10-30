# Remix Fumadocs app

This app renders the canonical `../../docs` content with the shared Concepta
Fumadocs theme. It does not contain a second editable copy of the documentation.

## Run

Use Node 24.14+, pnpm 11.5.3, Python 3.9+, and FVM with the repository's
pinned Flutter SDK. Run `fvm flutter pub get` in `apps/demo` first:

```bash
cd apps/docs
pnpm install --frozen-lockfile
pnpm dev
```

Open `http://localhost:3000/remix/tutorials/settings-screen/`. Production checks:

```bash
pnpm typecheck
pnpm build
pnpm test:search
DOCS_OUTPUT=out node scripts/test-pages.mjs --docs-only
DOCS_OUTPUT=out pnpm start
```

## GitHub Pages publishing

The app exports static HTML with `/remix` as its base path. Set
`NEXT_PUBLIC_SITE_URL` to the HTTPS origin before building metadata; it defaults
to `https://btwld.github.io`. Search downloads static page and section
indexes and runs in the browser, preserving component-title and keyword ranking.
No Node server runs in production.

`.github/workflows/deploy_web.yml` builds the docs and catalog, then the dashboard,
checks the combined artifact, and deploys it through GitHub Pages on main.
Pull requests build and validate without deploying. The public routes are:

- `/remix/`: Fumadocs documentation
- `/remix/catalog/`: Flutter component catalog and embedded examples
- `/remix/dashboard/`: dashboard showcase

`.github/actions/setup-docs` installs the pinned Node/pnpm toolchain and locked
dependencies. The reusable `.github/workflows/docs.yml` accepts a `site-url`
HTTPS origin and uploads a verified `remix-docs-static` artifact containing docs
and catalog. It does not deploy or include the dashboard.

To assemble and preview the full Pages artifact locally after `pnpm build`:

```bash
cd ../dashboard
fvm flutter build web --release --base-href /remix/dashboard/
cd ../docs
node scripts/package-pages.mjs
pnpm test:pages
pnpm start
```

The packager recreates `build/pages` and adds the dashboard. The docs build
includes `.nojekyll`, retired URL aliases and old catalog `#/?` forwarding.
A retirement worker clears the former root Flutter service worker; catalog and
dashboard workers keep their own scopes. The preview server uses real directory
indexes/404s, without an SPA fallback. To recover the former deployment, revert
the migration and rerun the main-branch Pages workflow.

## Theme package

The site pins `@concepta/docs-theme@0.0.1` from the public npm registry.
The theme uses BSD-3-Clause; its source repository is `btwld/docs-theme`.
The lockfile records the published archive integrity. The release-age exception
is limited to this reviewed first version. To upgrade, change the pinned version,
regenerate the lockfile, and repeat the production and deployment smoke checks.

## Content ownership

Edit MDX and assets under `../../docs`; edit navigation in `../../docs.json`.
That JSON file contains only `sidebar`; site settings live in `docs.config.ts`
and colors live in `app/global.css`. Component categories use `collapsible: true`.
The Fortal catalog generator reuses those categories; regenerate it with
`dart run melos run docs:catalog` after changing their membership or names.
`pnpm content` validates evidence, stages generated MDX in `.generated/content`,
and copies assets into `public/assets`. These directories are disposable and
gitignored. Restart `pnpm dev` after editing canonical content to stage changes.

`TutorialSource` expands checked sample-ZIP Dart into native Fumadocs fenced
blocks at build time. [Content/evidence rules](../../docs/README.md) own tutorial
source policy. Fumadocs provides highlighting, copying, search and layout; the
MDX compatibility map retains existing callouts and single-example code groups.

## Live component examples

Every component page pairs a live Widgetbook preview with its real catalog
source. `docs/component-previews.json` selects the generated Widgetbook routes;
`tool/prepare_docs_site.py` includes `apps/demo/lib/components/<page>.dart`
directly. Edit these sources, not the generated MDX. Source panels are catalog
examples with Fortal styling, not standalone applications.

Embedded examples follow the site's light/dark theme unless overridden with
the Theme control. Reset restores the first example, follows the site theme and
restarts Flutter.

Both `pnpm dev` and `pnpm build` build that same Flutter catalog into ignored
`public/catalog`. `/remix/catalog/` opens the full catalog; embedded routes use
Widgetbook's native preview mode. No separate renderer or remote deployment
is required. To iterate on docs alone after the initial build, run `pnpm content`
and `pnpm exec next dev`. Rebuild previews after changing Flutter examples.

`apps/demo/test/docs_preview_test.dart` checks page coverage, actual generated
routes, and the new interactive examples. Run it from `apps/demo` with
`fvm flutter test test/docs_preview_test.dart test/catalog_test.dart`.

The build uses the current Git commit for page-source links. Set
`DOCS_SOURCE_REF` explicitly when building without a Git checkout. Configure
`NEXT_PUBLIC_SITE_URL` separately for canonical metadata.

## Styling

`app/global.css` loads Tailwind, the Fumadocs `preset.css`, and the theme's
`theme.css`, in that order. The Concepta payload is a complete Fumadocs color
preset, so `fumadocs-ui/css/neutral.css` must not be stacked underneath it.
Shared fonts, reading styles, and logo support belong in `btwld/docs-theme`.
Remix keeps only its own identity in `.remix-docs`: its existing artwork, the
green accent through `--docs-primary-light`/`--docs-primary-dark`, and the
Flutter preview styles. The theme documents its Concepta design-system
reference; private design-system source and assets are not copied here.
