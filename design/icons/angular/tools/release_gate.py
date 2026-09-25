#!/usr/bin/env python3
"""Report public-release readiness. The private pilot intentionally does not pass.

Exit codes: 0 = required evidence present; 2 = release blocked; 1 = invalid input.
This checks recorded evidence and file consistency. It cannot replace a reviewer,
create a license, or perform a user study. It never publishes or modifies artwork.
"""
from __future__ import annotations

import hashlib
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from tools.evidence import snapshot, verify_report


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def read_json(path: Path) -> dict | list:
    return json.loads(path.read_text(encoding="utf-8"))


def main() -> int:
    checks: list[dict] = []

    def record(key: str, passed: bool, detail: str) -> None:
        checks.append({"check": key, "passed": bool(passed), "detail": detail})

    try:
        catalog = read_json(ROOT / "catalog/icons.json")
        current_evidence = snapshot(ROOT)
        current_catalog = sha256(ROOT / "catalog/icons.json")
        current_html = sha256(ROOT / "docs/catalog/index.html")
        approval = catalog["releaseApproval"]
        name_ready = catalog.get("nameStatus") == "approved-final-name"
        record("final-name", name_ready, "Set nameStatus to approved-final-name only after owner approval.")
        named = bool(approval.get("owner") and approval.get("designReviewer"))
        independent = named and approval["owner"] != approval["designReviewer"]
        record("named-owner-and-reviewer", independent, "Owner and independent design reviewer must be identified; no names are inferred.")
        pending = [i["id"] for i in catalog["icons"] if i["review"].get("independentApproval") != "approved"]
        record("independent-icon-approval", not pending, f"{len(pending)} of {len(catalog['icons'])} icons await recorded independent approval.")
        record("explicit-public-approval", approval.get("publicReleaseApproved") is True, "No automatic public release approval is inferred from technical tests.")

        license_text = (ROOT / "LICENSE").read_text(encoding="utf-8")
        license_ready = approval.get("licenseSelected") is True and "PUBLIC DISTRIBUTION LICENSE NOT SELECTED" not in license_text
        record("distribution-license", license_ready, "BSD 3-Clause is selected." if license_ready else "The current LICENSE is a status notice, not a public-use license.")
        package = read_json(ROOT / "packages/web/package.json")
        record("public-package-metadata", package.get("private") is False and package.get("license") not in (None, "UNLICENSED"), "The web package is BSD-3-Clause and remains private until a deliberate publication decision." if package.get("license") not in (None, "UNLICENSED") else "The web package remains private and UNLICENSED until a deliberate release decision.")

        exceptions = read_json(ROOT / "catalog/exceptions.json")
        unresolved = [e["id"] for e in exceptions if not e.get("owner") or not e.get("reviewer") or e.get("status") not in ("approved-with-restriction", "resolved")]
        restriction_data = read_json(ROOT / "catalog/restrictions.json")["records"]
        unresolved_restrictions = [r["id"] for r in restriction_data if not r.get("owner") or not r.get("reviewer") or r.get("status") not in ("approved-with-restriction", "resolved")]
        unresolved += unresolved_restrictions
        stale_exceptions = []
        for exception in exceptions:
            artifact = ROOT / f"generated/{exception['pack']}/{exception['appearance']}/{exception['nativeSize']}/{exception['icon']}.svg"
            if not artifact.is_file() or exception.get('geometrySha256') != sha256(artifact):
                stale_exceptions.append(exception['id'])
        record("exception-geometry-revision", not stale_exceptions, "Exceptions must match exact SVG bytes: " + (", ".join(stale_exceptions) or "all match"))
        record("exception-ownership", not unresolved, f"{len(unresolved)} spacing exceptions need named approval or resolution.")

        inventory = read_json(ROOT / "generated-sha256.json")
        # Build writes a flat relative-path -> digest map.
        mismatches = [path for path, digest in inventory.items() if not (ROOT / path).is_file() or sha256(ROOT / path) != digest]
        record("generated-product-integrity", not mismatches, f"Checked {len(inventory)} products; {len(mismatches)} differ or are missing.")
        for filename in ["asset-checks.json", "web-adapter.json", "rebuild.json", "pixel-regression.json"]:
            path = ROOT / "reports" / filename
            result = read_json(path) if path.is_file() else {}
            fresh, problems = verify_report(result, current_evidence)
            scope_ok = ((filename != "rebuild.json" or result.get("cleanBuild") is True)
                        and (filename != "pixel-regression.json" or result.get("createdBaseline") is False))
            record("technical-" + filename, result.get("status") == "passed" and fresh and scope_ok,
                   "; ".join(problems) if problems else "Evidence matches all current inputs and the local toolchain; a clean rebuild and unchanged baselines are required.")

        for browser in ["chromium", "firefox", "webkit"]:
            path = ROOT / "reports" / f"browser-{browser}-full.json"
            result = read_json(path) if path.is_file() else {}
            required_loads = {"http", "file"}
            good_loads = {item["context"] for item in result.get("loading", []) if item.get("status") == "passed"}
            passed_checks = {item["check"] for item in result.get("checks", []) if item.get("passed") is True}
            fresh, problems = verify_report(result, current_evidence)
            fresh = fresh and result.get("catalogHTMLSHA256") == current_html
            ok = result.get("status") == "passed" and result.get("mode") == "full" and fresh and required_loads.issubset(good_loads) and "hosted ESM consumer renders" in passed_checks
            patch_path = ROOT / "reports" / f"audit-browser-{browser}-full.json"
            patch_result = read_json(patch_path) if patch_path.is_file() else {}
            patch_fresh, _ = verify_report(patch_result, current_evidence)
            ok = ok and patch_result.get("status") == "passed" and patch_result.get("mode") == "full" and patch_fresh
            record("full-browser-" + browser, ok, "Needs a successful full-mode report for this exact guide, including HTTP, file, and module loading. WebKit does not claim branded Safari coverage.")

        unpinned: list[str] = []
        for path in sorted((ROOT / ".github/workflows").glob("*.yml")):
            for ref in re.findall(r"(?m)^\s*-?\s*uses:\s*([^\s#]+)", path.read_text(encoding="utf-8")):
                if not ref.startswith("./") and not re.search(r"@[0-9a-fA-F]{40}$", ref):
                    unpinned.append(ref)
        record("immutable-ci-action-pins", not unpinned, "Unpinned references: " + ", ".join(sorted(set(unpinned))) if unpinned else "All external actions use full commit hashes; verify their provenance before approval.")

        for stem in ["recognition", "screen-audit"]:
            path = ROOT / "reports" / f"{stem}-approval.json"
            evidence = read_json(path) if path.is_file() else {}
            relative = evidence.get("evidenceFile", "")
            target = (ROOT / relative).resolve() if relative else None
            in_project = target is not None and target.is_relative_to(ROOT.resolve()) and target.is_file()
            ok = evidence.get("status") == "approved" and bool(evidence.get("reviewer")) and evidence.get("catalogSha256") == current_catalog and in_project
            record("human-evidence-" + stem, ok, "Requires real findings, a named reviewer, a project-local evidence file, and the current catalog hash. Empty templates are not evidence.")

        blocked = [item["check"] for item in checks if not item["passed"]]
        report = {
            "status": "blocked" if blocked else "recorded-gates-satisfied",
            "catalogSha256": current_catalog,
            "catalogHTMLSHA256": current_html,
            "inputFingerprint": current_evidence["inputSha256"],
            "toolchainFingerprint": current_evidence["toolchainSha256"],
            "scope": "Public release readiness, separate from private pilot usability. Checks recorded evidence; does not certify design, legal rights, or accessibility.",
            "blockers": blocked,
            "checks": checks,
        }
        (ROOT / "reports/release-readiness.json").write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
        print(json.dumps({"status": report["status"], "blockerCount": len(blocked), "blockers": blocked}, indent=2))
        return 2 if blocked else 0
    except (OSError, ValueError, TypeError, KeyError) as exc:
        print(f"Release evidence could not be read: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
