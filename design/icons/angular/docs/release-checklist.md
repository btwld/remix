# Public release gate

The private pilot can be reviewed and integrated locally. Public release remains blocked until the following are resolved:

- Choose the family name, public package names, owner, and independent reviewer.
- Choose and insert the actual distribution license after reviewing provenance.
- Approve the 15 new concepts and their outline/filled/size drawings; retain or resolve each exception.
- Run strict HTTP/file/module tests and record the declared browser support. WebKit engine testing is not branded Safari testing.
- Run the planned formative task study and record the product-specific risks and label requirements.
- Audit target workflows before claiming coverage or committing to all remaining 72 proposals.
- Verify and pin GitHub Actions to full commit SHAs. The supplied private-pilot workflow uses documented major tags because action commit refs could not be fetched in this environment; it has no publishing permissions.
- Review the changelog, reproducible build, inventory, snapshots, and provenance together, then approve an immutable release tag.

`python tools/release_gate.py` reports these unresolved decisions and exits nonzero until explicit evidence is supplied. Do not bypass it by renaming the version to 1.0.0. No automatic publish workflow is included.

## Record real study evidence

After conducting the work, save the findings in this project and create
`reports/recognition-approval.json` and `reports/screen-audit-approval.json`. Each
record must have `status: "approved"`, a named `reviewer`, the current
`catalogSha256`, and an `evidenceFile` path relative to this project. Empty CSV
templates and planned participant counts do not satisfy the gate.

The gate also checks `nameStatus: "approved-final-name"`, explicit catalog release
approvals, per-icon `independentApproval: "approved"`, and owned exceptions with
status `approved-with-restriction` or `resolved`. Changing these fields is an
approval action, not a way to silence a test. Public-package metadata stays
private until the license and owner approve distribution.
