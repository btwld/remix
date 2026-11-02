# Public release gate

The private pilot can be reviewed and integrated locally. Public release remains blocked until the following are resolved:

- Choose the family name, public package names, owner, and independent reviewer.
- Retain the selected BSD-3-Clause license and review provenance before distribution.
- Approve the 15 pilot and 29 product concepts and their outline/filled/size drawings; retain or resolve each exception.
- Run strict HTTP/file/module tests and record the declared browser support. WebKit engine testing is not branded Safari testing.
- Supply actual recognition findings and product-specific label requirements.
- Audit target workflows before claiming broader coverage.
- Verify immutable action pins in the maintained root `vector-ui-icons.yml` workflow.
- Review the changelog, reproducible build, inventory, snapshots, and provenance together, then approve an immutable release tag.

`python tools/release_gate.py` reports these unresolved decisions and exits nonzero until explicit evidence is supplied. Do not bypass it by renaming the version to 1.0.0. No automatic publish workflow is included.

## Record real study evidence

After conducting the work, save actual findings in the external evidence
directory and create `recognition-approval.json` and `screen-audit-approval.json`
in its `outline/` subdirectory. Each must have `status: "approved"`, a named
`reviewer`, the current `catalogSha256`, and an `evidenceFile` path relative to
that subdirectory. The target must remain inside the evidence directory.
Empty templates and participant plans do not satisfy the gate.

Use the same `VECTOR_UI_EVIDENCE_DIR` for every runner and the release gate.
Technical reports, captures, and approval findings are ephemeral external
evidence, not committed source. Missing or stale evidence keeps the gate closed.

The gate also checks `nameStatus: "approved-final-name"`, explicit catalog release
approvals, per-icon `independentApproval: "approved"`, and owned exceptions with
status `approved-with-restriction` or `resolved`. Changing these fields is an
approval action, not a way to silence a test. Public-package metadata stays
private until the license and owner approve distribution.
