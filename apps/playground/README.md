# Remix playground

This standalone app previews Remix components and compares their Mix 2 styles.
Open the component index or select one directly with the web query parameter
`?component=<name>`.

From the repository root:

```sh
fvm dart run melos bootstrap
cd apps/playground
fvm flutter run -d chrome
```

## Base-theme dashboard shell

Open `?component=dashboard_shell` (or select `dashboard_shell` from the home
list) to preview the installed default-preset dashboard shell. Switch between
Overview and Projects, filter projects with the search field, collapse the
sidebar, and use the preview toolbar to test light/dark and mobile layouts.
The sample data is local; no backend is needed.
