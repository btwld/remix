"""Write the one Outline / Rounded comparison catalog.

The page inlines generated SVGs. It does not redraw them and it does not
fetch anything from the network.
"""
from __future__ import annotations

import html
import json
from pathlib import Path

FAMILIES = ("outline", "rounded")
MASTERS = (12, 16, 24)
APPEARANCES = ("outline", "filled")
SHARED = (
    "home",
    "search",
    "plus",
    "arrow-right",
    "user",
    "file",
    "calendar",
    "sliders",
    "warning",
    "link",
    "branch",
    "star",
)
FAMILY_LABEL = {"outline": "Outline", "rounded": "Rounded"}
WARNING_SENTENCE = (
    "Visible text label required for outline at 12 / 16 / 24 px and filled at "
    "12 / 16 / 24 px. This also applies to scaled uses of those masters. "
    "A tooltip or accessible name alone does not replace the visible label."
)


def svg_file(root: Path, family: str, appearance: str, size: int, icon_id: str) -> Path:
    return (
        root
        / family
        / "generated"
        / family
        / appearance
        / str(size)
        / f"{icon_id}.svg"
    )


def _load_json(path: Path):
    return json.loads(path.read_text(encoding="utf-8"))


def _icons(root: Path, family: str) -> list[dict]:
    return _load_json(root / family / "catalog" / "icons.json")["icons"]


def _labels(root: Path, family: str) -> dict[str, str]:
    return {icon["id"]: icon["label"] for icon in _icons(root, family)}


def _esc(value: object) -> str:
    return html.escape(str(value), quote=True)


def _num(value: object) -> str:
    if value is None or isinstance(value, bool):
        return "—"
    if isinstance(value, float):
        return f"{value:.4f}".rstrip("0").rstrip(".")
    return str(value)


def _read_svg(root: Path, family: str, appearance: str, size: int, icon_id: str) -> str:
    path = svg_file(root, family, appearance, size, icon_id)
    if not path.is_file():
        raise FileNotFoundError(path)
    return path.read_text(encoding="utf-8").strip()


def _figure(root: Path, family: str, appearance: str, size: int, icon_id: str) -> str:
    svg = _read_svg(root, family, appearance, size, icon_id)
    label = FAMILY_LABEL[family]
    return (
        f'<figure class="cell s{size}">'
        f'<div class="stage">{svg}</div>'
        f'<figcaption>{size} {_esc(appearance)} · {_esc(label)}</figcaption>'
        f"</figure>"
    )


def _grammar(root: Path) -> str:
    rounded = _load_json(root / "rounded" / "catalog" / "styles.json")["rounded"]
    outline = _load_json(root / "outline" / "catalog" / "styles.json")["outline"]
    cards = [
        (
            "Outline",
            "Validated geometry at native 12 / 16 / 24. "
            f"Corners: {outline['corners']}. Terminals: {outline['terminals']}. "
            "Outline and filled path commands are "
            + " ".join(outline["pathCommands"])
            + ".",
        ),
        (
            "Rounded",
            f"{rounded['notOutlineFilter']}. {rounded['corners']}. "
            f"Terminals are {rounded['terminals']}. Product commands are "
            + " ".join(rounded["productPathCommands"])
            + f". {rounded['legacyRoundedPlan']}.",
        ),

    ]
    body = []
    for title, text in cards:
        body.append(f"<article><h3>{_esc(title)}</h3><p>{_esc(text)}</p></article>")
    return '<div class="grammar">' + "".join(body) + "</div>"


def _exceptions(root: Path) -> str:
    rows = []
    order = {name: index for index, name in enumerate(FAMILIES)}
    for family in FAMILIES:
        records = _load_json(root / family / "catalog" / "exceptions.json")
        if not isinstance(records, list):
            raise ValueError(f"{family} exceptions.json must be a list")
        rows.extend(records)
    rows.sort(
        key=lambda record: (
            order.get(record.get("pack"), 9),
            str(record.get("icon") or ""),
            int(record.get("nativeSize") or 0),
            str(record.get("appearance") or ""),
            str(record.get("id") or ""),
        )
    )
    body = []
    for record in rows:
        body.append(
            "<tr>"
            f"<td>{_esc(record.get('pack', '—'))}</td>"
            f"<td><code>{_esc(record.get('id', '—'))}</code></td>"
            f"<td>{_esc(record.get('icon', '—'))}</td>"
            f"<td>{_esc(record.get('nativeSize', '—'))}</td>"
            f"<td>{_esc(record.get('appearance', '—'))}</td>"
            f"<td>{_esc(_num(record.get('measuredApprox')))}</td>"
            f"<td>{_esc(_num(record.get('target')))}</td>"
            f"<td>{_esc(record.get('permittedUse', '—'))}</td>"
            f"<td>{_esc(record.get('reason', ''))}</td>"
            "</tr>"
        )
    return (
        '<div class="table-wrap"><table class="exceptions"><thead><tr>'
        "<th>Family</th><th>Id</th><th>Icon</th><th>Native</th><th>Appearance</th>"
        "<th>Measured</th><th>Target</th><th>Permitted use</th><th>Reason</th>"
        f"</tr></thead><tbody>{''.join(body)}</tbody></table></div>"
    )


def _usage_limits(root: Path) -> str:
    items = []
    for family in FAMILIES:
        for icon in _icons(root, family):
            review = icon.get("review", {})
            guidance = review.get("usage")
            if guidance:
                items.append(
                    f"<li><strong>{_esc(FAMILY_LABEL[family])} {_esc(icon['label'])}:</strong> "
                    f"{_esc(guidance)}</li>"
                )
    return '<ul class="questions">' + "".join(items) + "</ul>"


def _proof(root: Path, labels: dict[str, str]) -> str:
    rows = []
    for icon_id in SHARED:
        cells = "".join(
            f"<div>{_figure(root, family, 'outline', 24, icon_id)}</div>"
            for family in FAMILIES
        )
        rows.append(
            f'<div class="proof-label"><a href="#{_esc(icon_id)}">{_esc(labels[icon_id])}</a>'
            f"<code>{_esc(icon_id)}</code></div>{cells}"
        )
    headers = "".join(f"<div>{FAMILY_LABEL[family]}</div>" for family in FAMILIES)
    return (
        '<section id="proof">'
        "<h2>Proof at 24 outline</h2>"
        "<p>Same native master, shown at 4×. Read across a row to compare families. "
        "Rounded geometry is not an Outline path filter.</p>"
        f'<div class="proof"><div></div>{headers}{"".join(rows)}</div>'
        "</section>"
    )


def _detail(root: Path, labels: dict[str, str]) -> str:
    articles = []
    for icon_id in SHARED:
        rows = []
        for size in MASTERS:
            for appearance in APPEARANCES:
                cells = "".join(
                    _figure(root, family, appearance, size, icon_id) for family in FAMILIES
                )
                rows.append(
                    f'<div class="row-label">{size}<span>{_esc(appearance)}</span></div>{cells}'
                )
        articles.append(
            f'<article id="{_esc(icon_id)}">'
            f"<h2>{_esc(labels[icon_id])} <code>{_esc(icon_id)}</code></h2>"
            '<div class="matrix"><div></div>'
            + "".join(f"<div class=\"col\">{FAMILY_LABEL[family]}</div>" for family in FAMILIES)
            + "".join(rows)
            + "</div></article>"
        )
    return (
        '<section id="families">'
        "<h2>Native 12 / 16 / 24</h2>"
        "<p>Outline and filled for every shared id. Captions name the native size; "
        "the drawing is shown at 4×.</p>"
        + "".join(articles)
        + "</section>"
    )


def _outline_only(root: Path, labels: dict[str, str]) -> str:
    outline_ids = [icon["id"] for icon in _icons(root, "outline")]
    extra = [icon_id for icon_id in outline_ids if icon_id not in SHARED]
    cards = []
    for icon_id in extra:
        outline = _figure(root, "outline", "outline", 24, icon_id)
        filled = _figure(root, "outline", "filled", 24, icon_id)
        cards.append(
            f'<article id="{_esc(icon_id)}">'
            f"<h3>{_esc(labels[icon_id])} <code>{_esc(icon_id)}</code></h3>"
            f'<div class="solo">{outline}{filled}</div>'
            "</article>"
        )
    return (
        '<section id="outline-only">'
        "<h2>Outline icons without a Rounded sibling</h2>"
        f"<p>{len(extra)} Outline icons are in this pack. Rounded currently "
        "covers the shared 12 only. Shown here at native 24, outline then filled.</p>"
        f'<div class="solo-grid">{"".join(cards)}</div>'
        "</section>"
    )


def render_catalog(root: Path) -> str:
    labels = {family: _labels(root, family) for family in FAMILIES}
    for icon_id in SHARED:
        names = {labels[family][icon_id] for family in FAMILIES}
        if len(names) != 1:
            raise ValueError(f"label mismatch for {icon_id}: {names}")
    shared_labels = labels["outline"]
    counts = {
        family: len(list((root / family / "generated" / family).rglob("*.svg")))
        for family in FAMILIES
    }
    expected = {"outline": 288, "rounded": 72}
    if counts != expected:
        raise ValueError(f"unexpected SVG counts: {counts}")
    return f"""<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Vector UI icon families</title>
<style>
:root {{
  color-scheme: light;
  --ink: #1c1915;
  --muted: #5e584f;
  --line: #e3ddd2;
  --paper: #f6f4ef;
  --card: #fffcf7;
  --stage: #ffffff;
  --warn: #7a3e12;
  --warn-bg: #fff4e5;
}}
* {{ box-sizing: border-box; }}
body {{
  margin: 0;
  font: 15px/1.45 "Iowan Old Style", Palatino, "Palatino Linotype", Georgia, serif;
  color: var(--ink);
  background: var(--paper);
}}
header, main, footer {{ width: min(1120px, calc(100% - 32px)); margin: 0 auto; }}
header {{ padding: 28px 0 8px; }}
.kicker {{ letter-spacing: .08em; text-transform: uppercase; font-size: 12px; color: var(--muted); margin: 0; }}
h1 {{ font-size: 34px; line-height: 1.1; margin: 6px 0 8px; }}
h2 {{ font-size: 22px; margin: 28px 0 8px; }}
h3 {{ font-size: 16px; margin: 0 0 6px; }}
p {{ margin: 0 0 10px; }}
a {{ color: inherit; }}
code {{ font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace; font-size: .86em; }}
.banner {{
  background: var(--warn-bg);
  color: var(--warn);
  border: 1px solid #efd3b0;
  border-radius: 10px;
  padding: 12px 14px;
  margin: 14px 0;
}}
nav {{ display: flex; flex-wrap: wrap; gap: 10px 14px; font-size: 14px; margin: 8px 0 18px; }}
.surface {{ font-size: 14px; color: var(--muted); }}
.grammar {{ display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 12px; }}
.grammar article, article, .solo-grid article {{
  background: var(--card);
  border: 1px solid var(--line);
  border-radius: 12px;
  padding: 12px;
}}
.grammar article {{ padding: 12px 14px; }}
.proof, .matrix {{
  display: grid;
  grid-template-columns: 8.5rem repeat(2, minmax(0, 1fr));
  gap: 8px 10px;
  align-items: end;
  margin-top: 8px;
}}
.col, .proof > div:nth-child(-n+3) {{ font-size: 12px; letter-spacing: .04em; text-transform: uppercase; color: var(--muted); }}
.proof-label, .row-label {{ font-size: 14px; }}
.row-label span, .proof-label code {{ display: block; color: var(--muted); font-size: 12px; }}
.cell {{ margin: 0; }}
.stage {{
  display: grid;
  place-items: center;
  background: var(--stage);
  color: var(--ink);
  border: 1px solid var(--line);
  border-radius: 8px;
  min-height: 48px;
  padding: 8px;
}}
.s12 svg {{ width: 48px; height: 48px; }}
.s16 svg {{ width: 64px; height: 64px; }}
.s24 svg {{ width: 96px; height: 96px; }}
figcaption {{ font-size: 11px; color: var(--muted); margin-top: 4px; }}
#families article {{ margin: 14px 0; }}
.solo-grid {{ display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 12px; }}
.solo {{ display: flex; gap: 12px; }}
.table-wrap {{ overflow-x: auto; border: 1px solid var(--line); border-radius: 12px; background: var(--card); }}
table {{ width: 100%; border-collapse: collapse; font-size: 13px; background: var(--card); }}
th, td {{ border-bottom: 1px solid var(--line); text-align: left; vertical-align: top; padding: 6px 8px; }}
th {{ font-size: 11px; letter-spacing: .04em; text-transform: uppercase; color: var(--muted); }}
.questions {{ padding-left: 18px; }}
footer {{ color: var(--muted); font-size: 13px; padding: 8px 0 36px; }}
body:has(#surface:checked) {{
  --ink: #f3efe6;
  --muted: #b7b0a4;
  --line: #34322c;
  --paper: #141311;
  --card: #1d1c19;
  --stage: #0e0e0c;
  --warn: #f0c48a;
  --warn-bg: #2a2118;
}}
@media (max-width: 860px) {{
  .grammar, .solo-grid {{ grid-template-columns: 1fr; }}
  .proof, .matrix {{ grid-template-columns: repeat(2, minmax(0, 1fr)); }}
  .proof > div:first-child:empty,
  .matrix > div:first-child:empty {{ display: none; }}
  .proof-label, .row-label {{ grid-column: 1 / -1; }}
  .s12 svg {{ width: 36px; height: 36px; }}
  .s16 svg {{ width: 44px; height: 44px; }}
  .s24 svg {{ width: 56px; height: 56px; }}
}}
</style>
</head>
<body>
<header>
<p class="kicker">Private review pack · not for publication</p>
<h1>Vector UI icon families</h1>
<p>Outline and Rounded live here as siblings. Outline has {counts["outline"]} SVGs. Rounded has {counts["rounded"]}. Each drawing is outline or filled at native 12, 16, or 24.</p>
<p class="banner"><strong>Warning.</strong> {WARNING_SENTENCE} The rule applies to Outline and Rounded. A recorded gap exception does not lift it.</p>
<label class="surface"><input id="surface" type="checkbox"> Dark surface</label>
<nav>
<a href="#proof">24 outline proof</a>
<a href="#grammar">Grammar</a>
<a href="#exceptions">Exceptions</a>
<a href="#questions">Open questions</a>
<a href="#families">All masters</a>
<a href="#warning">Warning icon</a>
<a href="#outline-only">Outline only</a>
</nav>
</header>
<main>
{_proof(root, shared_labels)}
<section id="grammar">
<h2>Grammar</h2>
<p>Each family is constructed from its own primitives. Comparison on this page reads finished SVGs; it does not refit one family onto another.</p>
{_grammar(root)}
</section>
<section id="exceptions">
<h2>Recorded exceptions</h2>
<p>These measurements stay attached to the artwork they were taken from. Permitted use for Warning gaps remains a visible label.</p>
{_exceptions(root)}
</section>
<section id="questions">
<h2>Usage limits</h2>
<p>Keep visible labels consistent with each family’s documented usage rules.</p>
{_usage_limits(root)}
</section>
{_detail(root, shared_labels)}
{_outline_only(root, shared_labels)}
</main>
<footer>
<p>BSD 3-Clause. Copyright 2026, Leo Farias. <code>package.json</code> is <code>private</code>. This source pack is not published to npm or pub.dev; <code>remix_ui_icons</code> compiles its masters into a Flutter icon font.</p>
<p>Family catalogs remain build products: <a href="../outline/docs/catalog/index.html">Outline</a>, <a href="../rounded/docs/catalog/index.html">Rounded</a>.</p>
</footer>
</body>
</html>
"""


def write_catalog(root: Path) -> Path:
    path = root / "catalog" / "index.html"
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(render_catalog(root), encoding="utf-8")
    return path
