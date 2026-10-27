#!/usr/bin/env python3
"""Deterministically build the Technical 12-icon calibration pilot.

Run from the package root:  python source/build.py
Does not write into design/icons/angular/.
"""
from __future__ import annotations
import csv
import hashlib
import io
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

from PIL import Image
import cairosvg

from source.contract import (
    APPEARANCES,
    FAMILY,
    ICONS,
    IDS,
    MASTERS,
    OPEN_QUESTIONS,
    PACK,
    PILOT_VERSION,
)
from source.export import path_data, svg_text, parse_svg
from source.grammar import CHAMFER, CHAMFER_OVERRIDE, GAP, HEAVY, OUTLINE, PAD, tokens
from source.icons import WARNING_GEOMETRY, draw
from shapely.geometry import box
from shapely.ops import unary_union
from source.grammar import chamfered_frame

PROOF_PNGS = (
    "contact-sheet.png",
    "masters-12-4x.png",
    "masters-16-4x.png",
    "masters-24-4x.png",
    "angular-vs-technical-24.png",
)


def workspace_root(start: Path) -> Path:
    for p in [start, *start.parents]:
        if (p / "design/icons/angular/generated/angular").is_dir():
            return p
    return start.parents[2]


WORKSPACE = workspace_root(ROOT)
ANGULAR_GEN = WORKSPACE / "design/icons/angular/generated/angular"


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def sha_for(inventory, icon_id, appearance, master):
    for row in inventory:
        if row["id"] == icon_id and row["appearance"] == appearance and row["master"] == master:
            return row["sha256"]
    raise KeyError("%s/%s/%s" % (icon_id, appearance, master))


def catalog_document():
    icons = []
    for meta in ICONS:
        rec = {
            "id": meta["id"],
            "label": meta["label"],
            "category": meta["category"],
            "pairModel": meta["pairModel"],
            "meaning": meta["meaning"],
            "keywords": meta["keywords"],
            "aliases": [],
            "rtlPolicy": meta["rtlPolicy"],
            "example": meta["example"],
            "availability": {
                "technical": {
                    "appearances": list(APPEARANCES),
                    "opticalSizes": list(MASTERS),
                }
            },
            "provenance": {
                "method": "original-technical-construction",
                "source": "source/icons.py",
                "externalArtworkUsed": False,
                "angularGeometryCopied": False,
            },
            "review": {
                "technical": "checked-by-build-and-validation",
                "optical": "pilot-local-review",
                "recognition": "not-user-tested",
                "independentApproval": "pending",
                "note": "Calibration drawing. Independent design approval is not implied.",
                "exceptions": [],
                "usage": "Use the action name on the enclosing control; 12 px is for labeled information.",
            },
        }
        if meta.get("usageRestriction"):
            rec["review"]["usageRestriction"] = meta["usageRestriction"]
            rec["review"]["usage"] = (
                "Visible text label required for outline and filled Warning at "
                "12 / 16 / 24 px, including scaled uses of those masters."
            )
        icons.append(rec)
    return {
        "schemaVersion": 1,
        "family": FAMILY,
        "pack": PACK,
        "nameStatus": "working-name",
        "version": PILOT_VERSION,
        "status": "calibration-pilot-not-public",
        "counts": {"icons": len(icons), "drawings": len(icons) * 6},
        "packs": {
            "technical": {
                "available": True,
                "nativeSizes": list(MASTERS),
                "status": "calibration-pilot",
            },
            "angular": {
                "available": False,
                "status": "not-in-this-pilot-package",
                "note": "Angular remains in design/icons/angular; this package does not re-export or edit it.",
            },
            "rounded": {"available": False, "status": "not-drawn"},
            "soft": {"available": False, "status": "not-drawn"},
        },
        "releaseApproval": {
            "owner": None,
            "designReviewer": None,
            "publicReleaseApproved": False,
            "promotedToPublicCatalog": False,
        },
        "icons": icons,
    }


def measure_exceptions(inventory):
    """Record warning gaps, chamfer reductions, and the 12 px plus centering policy."""
    exceptions = []
    restriction_sizes = {}
    for n in MASTERS:
        tok = tokens(n)
        spec = WARNING_GEOMETRY[n]
        marks = unary_union([box(*b) for b in spec["marks"]])
        frame = chamfered_frame(spec["pts"], tok["chamfer"], tok["outline"])
        dist = float(frame.distance(marks))
        stem_w = float(marks.bounds[2] - marks.bounds[0])
        restriction_sizes[str(n)] = {}
        for appearance in APPEARANCES:
            digest = sha_for(inventory, "warning", appearance, n)
            ex_ids = []
            if appearance == "outline" and dist + 1e-6 < tok["gap"]:
                eid = "warning-gap-%s" % n
                ex_ids.append(eid)
                exceptions.append(
                    {
                        "id": eid,
                        "icon": "warning",
                        "pack": PACK,
                        "appearance": "outline",
                        "nativeSize": n,
                        "target": tok["gap"],
                        "measuredApprox": round(dist, 3),
                        "status": "recorded-for-calibration",
                        "rule": "meaningful-mark-to-frame-gap",
                        "permittedUse": "visible-label-required",
                        "owner": None,
                        "reviewer": None,
                        "reason": (
                            "Chamfered caution plate cannot host 1/1.5/2 px punctuation "
                            "with full side and base clearance at this native size. "
                            "Visible-label restriction remains concept-level and is not weakened."
                        ),
                        "restrictionId": "warning-visible-label",
                        "geometrySha256": digest,
                    }
                )
            if appearance == "filled" and stem_w + 1e-6 < tok["gap"]:
                eid = "warning-filled-punctuation-%s" % n
                ex_ids.append(eid)
                exceptions.append(
                    {
                        "id": eid,
                        "icon": "warning",
                        "pack": PACK,
                        "appearance": "filled",
                        "nativeSize": n,
                        "target": tok["gap"],
                        "measuredApprox": round(stem_w, 3),
                        "status": "recorded-for-calibration",
                        "rule": "negative-punctuation-width",
                        "permittedUse": "visible-label-required",
                        "restrictionId": "warning-visible-label",
                        "geometrySha256": digest,
                        "owner": None,
                        "reviewer": None,
                        "reason": "Filled punctuation is narrower than the general opening-width target.",
                    }
                )
            restriction_sizes[str(n)][appearance] = {
                "visibleLabelRequired": True,
                "geometrySha256": digest,
                "exceptionIds": ex_ids,
            }
    for (icon_id, n), used in sorted(CHAMFER_OVERRIDE.items()):
        declared = CHAMFER[n]
        if abs(used - declared) < 1e-9:
            continue
        exceptions.append(
            {
                "id": "%s-chamfer-%s" % (icon_id, n),
                "icon": icon_id,
                "pack": PACK,
                "nativeSize": n,
                "target": declared,
                "measuredApprox": used,
                "status": "recorded-for-calibration",
                "rule": "part-chamfer-reduction",
                "reason": (
                    "Full chamfer token would collapse the outline ring on this dense "
                    "plate (knob or junction box). Construction uses the reduced cut; "
                    "styles.json lists the same override."
                ),
                "owner": None,
                "reviewer": None,
                "geometrySha256": {
                    "outline": sha_for(inventory, icon_id, "outline", n),
                    "filled": sha_for(inventory, icon_id, "filled", n),
                },
            }
        )
    exceptions.append(
        {
            "id": "plus-12-outline-centered-odd-width",
            "icon": "plus",
            "pack": PACK,
            "appearance": "outline",
            "nativeSize": 12,
            "status": "allowed-optical-policy",
            "rule": "odd-width-canvas-centering",
            "reason": (
                "A 1 px stem on a 12 px even canvas stays on center 6, so edges are "
                "5.5–6.5. This is Technical centering, not Angular's integer 5–6 split."
            ),
            "geometrySha256": sha_for(inventory, "plus", "outline", 12),
        }
    )
    return exceptions, restriction_sizes


def write_proof(catalog, paths, exceptions):
    proof = ROOT / "proof"
    proof.mkdir(exist_ok=True)
    rasters = proof / "rasters"
    if rasters.exists():
        for p in rasters.rglob("*"):
            if p.is_file():
                p.unlink()
    cards = []
    for meta in catalog["icons"]:
        icon_id = meta["id"]
        cells = []
        for n in MASTERS:
            for appearance in APPEARANCES:
                d = paths[icon_id][appearance][str(n)]
                svg = (
                    '<svg xmlns="http://www.w3.org/2000/svg" width="%d" height="%d" '
                    'viewBox="0 0 %d %d" fill="currentColor" fill-rule="evenodd" '
                    'aria-hidden="true"><path d="%s"/></svg>'
                    % (n, n, n, n, d)
                )
                cells.append(
                    '<div class="cell"><span>%s / %s</span>%s</div>'
                    % (n, appearance, svg)
                )
        cards.append(
            '<article class="card" id="%s"><header><strong>%s</strong>'
            "<small>%s · %s</small></header><p>%s</p>"
            '<div class="matrix">%s</div></article>'
            % (
                icon_id,
                meta["label"],
                meta["pairModel"],
                icon_id,
                meta["meaning"],
                "".join(cells),
            )
        )
    compare_rows = []
    angular_note = "Angular comparison omitted — generated Angular SVGs not found in this checkout."
    if ANGULAR_GEN.exists():
        angular_note = (
            "Angular drawings are inlined read-only for comparison. "
            "This pilot does not copy them into generated/technical/."
        )
        for meta in catalog["icons"]:
            icon_id = meta["id"]
            tech = paths[icon_id]["outline"]["24"]
            ang_svg = (ANGULAR_GEN / "outline/24" / ("%s.svg" % icon_id)).read_text()
            _n, ang_d, _g = parse_svg(ang_svg)
            def mark(d, n=24, css=48):
                return (
                    '<svg xmlns="http://www.w3.org/2000/svg" width="%d" height="%d" '
                    'viewBox="0 0 %d %d" fill="currentColor" fill-rule="evenodd" '
                    'aria-hidden="true"><path d="%s"/></svg>' % (css, css, n, n, d)
                )
            compare_rows.append(
                '<tr><th>%s</th><td><div class="cmp">%s<span>Angular</span></div></td>'
                '<td><div class="cmp">%s<span>Technical</span></div></td></tr>'
                % (meta["label"], mark(ang_d), mark(tech))
            )
    ex_html = (
        "<p>No spacing exceptions were recorded by the build. Warning still requires a visible label.</p>"
        if not exceptions
        else "<ul>"
        + "".join(
            "<li><strong>%s</strong> — %s %s: %s</li>"
            % (
                e["id"],
                e["icon"],
                e.get("appearance") or ("master " + str(e.get("nativeSize"))),
                e["reason"],
            )
            for e in exceptions
        )
        + "</ul>"
    )
    q_html = "<ul>" + "".join(
        "<li><strong>%s</strong> (%s) — %s</li>"
        % (q["id"], ", ".join(q["icons"]), q["question"])
        for q in OPEN_QUESTIONS
    ) + "</ul>"
    page = """<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Vector UI — Technical calibration pilot</title>
<style>
:root { --ink:#101218; --muted:#5b6170; --line:#d8dbe3; --paper:#f6f7f9; --accent:#0b5fff; }
* { box-sizing:border-box; }
body { margin:0; font:15px/1.45 ui-sans-serif,system-ui,sans-serif; color:var(--ink); background:#fff; }
.wrap { max-width:1100px; margin:0 auto; padding:32px 20px 64px; }
header.top { display:flex; justify-content:space-between; gap:16px; border-bottom:1px solid var(--ink); padding-bottom:16px; }
.brand { font-weight:700; letter-spacing:.08em; font-size:12px; }
h1 { font-size:34px; letter-spacing:-.03em; margin:18px 0 8px; }
.lede { max-width:42em; color:var(--muted); }
.stats { display:flex; gap:24px; margin:20px 0 32px; }
.stats div { border:1px solid var(--line); padding:12px 16px; min-width:110px; }
.stats strong { display:block; font-size:22px; }
.grid { display:grid; gap:16px; }
.card { border:1px solid var(--line); padding:16px; background:var(--paper); }
.card header { display:flex; justify-content:space-between; gap:8px; margin-bottom:6px; }
.card small { color:var(--muted); font-family:ui-monospace,monospace; }
.matrix { display:grid; grid-template-columns:repeat(6,minmax(0,1fr)); gap:8px; margin-top:12px; align-items:end; }
.cell { display:flex; flex-direction:column; align-items:center; gap:6px; color:var(--ink); background:#fff; border:1px solid var(--line); padding:10px 4px 8px; min-height:64px; }
.cell span { font-size:10px; letter-spacing:.04em; color:var(--muted); text-transform:uppercase; }
.surfaces { display:grid; grid-template-columns:1fr 1fr; gap:12px; margin:16px 0 32px; }
.surface { padding:16px; border:1px solid var(--line); }
.surface.dark { background:#12141a; color:#f3f4f7; }
.surface.dark .cell { background:#1b1e27; border-color:#2a2e3a; color:#f3f4f7; }
table { width:100%%; border-collapse:collapse; }
th, td { border:1px solid var(--line); padding:10px; vertical-align:middle; }
.cmp { display:flex; flex-direction:column; align-items:center; gap:6px; }
.token { font-family:ui-monospace,monospace; font-size:13px; }
footer { margin-top:40px; color:var(--muted); font-size:13px; }
@media (max-width:800px){ .matrix,.surfaces { grid-template-columns:1fr 1fr 1fr; } }
</style>
</head>
<body>
<main class="wrap">
<header class="top"><div class="brand">VECTOR UI</div><div class="brand">TECHNICAL / CALIBRATION PILOT</div></header>
<h1>Technical 12</h1>
<p class="lede">Instrument grammar: orthogonal plates, 45° chamfers, square-cut terminals.
Same semantic IDs as Angular. Not a public catalog, not a transform of Angular paths.</p>
<div class="stats">
<div><strong>12</strong><span>icons</span></div>
<div><strong>2</strong><span>appearances</span></div>
<div><strong>3</strong><span>native masters</span></div>
<div><strong>72</strong><span>SVGs</span></div>
</div>
<section>
<h2>Tokens</h2>
<table class="token">
<tr><th>Master</th><th>Outline</th><th>Heavy</th><th>Chamfer</th><th>Pad / gap</th></tr>
<tr><td>12</td><td>1</td><td>2</td><td>1</td><td>1</td></tr>
<tr><td>16</td><td>1.5</td><td>2.5</td><td>1.5</td><td>1.5</td></tr>
<tr><td>24</td><td>2</td><td>3</td><td>2</td><td>2</td></tr>
</table>
<p class="lede">M/L/Z only. currentColor. No silent fallback to Angular or another size. Warning keeps a visible-label restriction at concept level.</p>
</section>
<section>
<h2>Native matrix</h2>
<p class="lede">Each pair is a native drawing at CSS 12 / 16 / 24 px. Outline left, filled right in every size group.</p>
<div class="grid">%s</div>
</section>
<section>
<h2>Light / dark surfaces</h2>
<div class="surfaces">
<div class="surface light"><strong>Light</strong><div class="matrix">%s</div></div>
<div class="surface dark"><strong>Dark</strong><div class="matrix">%s</div></div>
</div>
</section>
<section>
<h2>Angular vs Technical at 24 outline</h2>
<p class="lede">%s</p>
<table><thead><tr><th>ID</th><th>Angular 24</th><th>Technical 24</th></tr></thead><tbody>%s</tbody></table>
</section>
<section>
<h2>Spacing / construction exceptions</h2>
%s
</section>
<section>
<h2>Open questions for human review</h2>
<p class="lede">Construction does not decide these. They remain named questions for a short recognition pass.</p>
%s
</section>
<footer>Vector UI Technical calibration · %s · private review · not promoted to the public catalog.<br>
Proof rasters: proof/rasters/ · Rebuild with <code>python source/build.py</code></footer>
</main>
</body>
</html>
""" % (
        "".join(cards),
        "".join(
            '<div class="cell">%s</div>'
            % (
                '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="currentColor" fill-rule="evenodd" aria-hidden="true"><path d="%s"/></svg>'
                % paths[i]["outline"]["24"]
            )
            for i in IDS
        ),
        "".join(
            '<div class="cell">%s</div>'
            % (
                '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="currentColor" fill-rule="evenodd" aria-hidden="true"><path d="%s"/></svg>'
                % paths[i]["outline"]["24"]
            )
            for i in IDS
        ),
        angular_note,
        "".join(compare_rows),
        ex_html,
        q_html,
        PILOT_VERSION,
    )
    (proof / "index.html").write_text(page, encoding="utf-8")
    return proof


def write_rasters(inventory, paths):
    proof = ROOT / "proof"
    rasters = proof / "rasters"
    if rasters.exists():
        for p in rasters.rglob("*"):
            if p.is_file():
                p.unlink()
    for name in PROOF_PNGS:
        stale = proof / name
        if stale.exists():
            stale.unlink()
    for row in inventory:
        txt = (ROOT / "generated" / row["path"]).read_text().replace("currentColor", "#111318")
        png = cairosvg.svg2png(bytestring=txt.encode("utf-8"), output_width=row["master"], output_height=row["master"])
        dest = rasters / row["appearance"] / str(row["master"]) / ("%s.png" % row["id"])
        dest.parent.mkdir(parents=True, exist_ok=True)
        dest.write_bytes(png)
    cell = 28
    cols = 6
    rows_n = 12
    pad = 8
    sheet = Image.new("RGBA", (cols * cell + pad * 2, rows_n * cell + pad * 2), (255, 255, 255, 255))
    for r, icon_id in enumerate(IDS):
        c = 0
        for n in MASTERS:
            for appearance in APPEARANCES:
                im = Image.open(rasters / appearance / str(n) / ("%s.png" % icon_id)).convert("RGBA")
                x = pad + c * cell + (cell - n) // 2
                y = pad + r * cell + (cell - n) // 2
                sheet.alpha_composite(im, (x, y))
                c += 1
    sheet.save(proof / "contact-sheet.png")
    scale = 8
    for n in MASTERS:
        cell_n = n * scale + 16
        im = Image.new("RGBA", (2 * cell_n + 40, 12 * cell_n + 40), (255, 255, 255, 255))
        for r, icon_id in enumerate(IDS):
            for c, appearance in enumerate(APPEARANCES):
                src = Image.open(rasters / appearance / str(n) / ("%s.png" % icon_id)).convert("RGBA")
                src = src.resize((n * scale, n * scale), Image.NEAREST)
                im.alpha_composite(src, (20 + c * cell_n, 20 + r * cell_n))
        im.save(proof / ("masters-%s-4x.png" % n))
    if ANGULAR_GEN.exists():
        scale = 6
        cell_n = 24 * scale + 28
        cmp_im = Image.new("RGBA", (2 * cell_n + 48, 12 * cell_n + 80), (255, 255, 255, 255))
        for r, icon_id in enumerate(IDS):
            tech = Image.open(rasters / "outline" / "24" / ("%s.png" % icon_id)).convert("RGBA")
            tech = tech.resize((24 * scale, 24 * scale), Image.NEAREST)
            ang_txt = (ANGULAR_GEN / "outline/24" / ("%s.svg" % icon_id)).read_text().replace("currentColor", "#111318")
            ang_png = cairosvg.svg2png(bytestring=ang_txt.encode("utf-8"), output_width=24, output_height=24)
            ang = Image.open(io.BytesIO(ang_png)).convert("RGBA").resize((24 * scale, 24 * scale), Image.NEAREST)
            cmp_im.alpha_composite(ang, (24, 48 + r * cell_n))
            cmp_im.alpha_composite(tech, (24 + cell_n, 48 + r * cell_n))
        cmp_im.save(proof / "angular-vs-technical-24.png")
    return proof / "contact-sheet.png"


def build():
    catalog = catalog_document()
    (ROOT / "catalog").mkdir(exist_ok=True)
    generated = ROOT / "generated"
    out = generated / "technical"
    if out.exists():
        for p in out.rglob("*.svg"):
            p.unlink()
    paths = {}
    inventory = []
    for meta in catalog["icons"]:
        icon_id = meta["id"]
        paths[icon_id] = {}
        for appearance in APPEARANCES:
            paths[icon_id][appearance] = {}
            for n in MASTERS:
                g = draw(icon_id, n, appearance)
                path = path_data(g)
                rel = "technical/%s/%s/%s.svg" % (appearance, n, icon_id)
                dest = generated / rel
                dest.parent.mkdir(parents=True, exist_ok=True)
                txt = svg_text(meta["label"], appearance, n, path)
                dest.write_text(txt, encoding="utf-8")
                digest = sha256_bytes(txt.encode("utf-8"))
                parse_svg(txt)
                paths[icon_id][appearance][str(n)] = path
                inventory.append(
                    {
                        "id": icon_id,
                        "pack": PACK,
                        "appearance": appearance,
                        "master": n,
                        "path": rel,
                        "sha256": digest,
                    }
                )
    exceptions, warning_sizes = measure_exceptions(inventory)
    if exceptions:
        by_icon = {}
        for e in exceptions:
            by_icon.setdefault(e["icon"], []).append(e["id"])
        for meta in catalog["icons"]:
            if meta["id"] in by_icon:
                meta["review"]["exceptions"] = by_icon[meta["id"]]
    registry_paths = {
        i: {a: {str(n): paths[i][a][str(n)] for n in MASTERS} for a in APPEARANCES}
        for i in IDS
    }
    (generated / "registry.json").write_text(
        json.dumps({"version": catalog["version"], "pack": PACK, "paths": registry_paths}, indent=2)
        + "\n"
    )
    (generated / "inventory.json").write_text(json.dumps(inventory, indent=2) + "\n")
    with (generated / "inventory.csv").open("w", newline="") as fh:
        wr = csv.DictWriter(fh, fieldnames=list(inventory[0]))
        wr.writeheader()
        wr.writerows(inventory)
    (ROOT / "catalog/icons.json").write_text(json.dumps(catalog, indent=2) + "\n")
    (ROOT / "catalog/exceptions.json").write_text(json.dumps(exceptions, indent=2) + "\n")
    restrictions = {
        "schemaVersion": 1,
        "records": [
            {
                "id": "warning-visible-label",
                "icon": "warning",
                "pack": PACK,
                "status": "concept-level-restriction",
                "owner": None,
                "reviewer": None,
                "reason": (
                    "Visible text label required at every master and appearance, "
                    "including scaled uses. Geometry improvements do not lift this rule."
                ),
                "sizes": warning_sizes,
            }
        ],
    }
    (ROOT / "catalog/restrictions.json").write_text(json.dumps(restrictions, indent=2) + "\n")
    styles = {
        "technical": {
            "outlineWidth": {str(k): v for k, v in OUTLINE.items()},
            "openGlyphFilledWidth": {str(k): v for k, v in HEAVY.items()},
            "meaningfulGapTarget": {str(k): v for k, v in GAP.items()},
            "chamfer": {str(k): v for k, v in CHAMFER.items()},
            "chamferPartOverrides": [
                {
                    "icon": icon_id,
                    "nativeSize": n,
                    "declared": CHAMFER[n],
                    "used": used,
                    "exceptionId": "%s-chamfer-%s" % (icon_id, n),
                }
                for (icon_id, n), used in sorted(CHAMFER_OVERRIDE.items())
                if abs(used - CHAMFER[n]) > 1e-9
            ],
            "oddWidthCentering": {
                "policy": "canvas-center",
                "twelvePxOutlinePlus": "half-pixel-edges",
                "note": "1px bar at 12 remains centered at 6 (edges 5.5-6.5). Not Angular's 5-6 integer split.",
                "exceptionId": "plus-12-outline-centered-odd-width",
            },
            "padding": {str(k): v for k, v in PAD.items()},
            "pathCommands": ["M", "L", "Z"],
            "masterSelection": {"12": 12, "14": 16, "16": 16, "20": 24, "24": 24, "32": 24},
            "corners": "systematic 45-degree plate chamfer",
            "terminals": "square-cut bars; plates chamfered",
            "diagonals": "45-degree plus warning and star metaphor exceptions",
        }
    }
    (ROOT / "catalog/styles.json").write_text(json.dumps(styles, indent=2) + "\n")
    (ROOT / "catalog/aliases.json").write_text("{}\n")
    (ROOT / "catalog/open-questions.json").write_text(
        json.dumps({"schemaVersion": 1, "questions": list(OPEN_QUESTIONS)}, indent=2) + "\n"
    )
    write_proof(catalog, registry_paths, exceptions)
    write_rasters(inventory, registry_paths)
    # Hash reproducible products, not the checksum file itself (Angular
    # writes generated-sha256.json outside the hashed tree for the same reason).
    products = [p for p in generated.rglob("*") if p.is_file() and p.name != "sha256.json"]
    products += [p for p in (ROOT / "proof").rglob("*") if p.is_file()]
    products += list((ROOT / "catalog").glob("*.json"))
    products += list((ROOT / "catalog/schemas").glob("*.json"))
    sums = {str(p.relative_to(ROOT)): sha256_bytes(p.read_bytes()) for p in sorted(products)}
    (generated / "sha256.json").write_text(json.dumps(sums, indent=2) + "\n")
    print(
        "Built %d icons / %d SVGs / %d exceptions"
        % (len(paths), len(inventory), len(exceptions))
    )
    return catalog, inventory


if __name__ == "__main__":
    build()
