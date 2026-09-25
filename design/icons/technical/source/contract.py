"""Shared identity and fail-closed resolve seam for the Technical pilot.

This module does not draw glyphs and does not import Angular construction.
Unknown pack / id / appearance / master raise. Nothing is substituted.
"""
from __future__ import annotations

APPEARANCES = ("outline", "filled")
MASTERS = (12, 16, 24)
PACK = "technical"
FAMILY = "Vector UI"
PILOT_VERSION = "0.1.0-technical-pilot"

# Display size → native master. Documented for a future API; this pilot
# does not silently serve a non-native size as if it were native.
MASTER_FOR_DISPLAY = {12: 12, 14: 16, 16: 16, 20: 24, 24: 24, 32: 24}

ICONS = (
    {
        "id": "home",
        "label": "Home",
        "category": "navigation",
        "pairModel": "silhouette",
        "meaning": "Home or top-level destination. Do not substitute for Back.",
        "keywords": ["dashboard", "main"],
        "example": "Overview",
        "rtlPolicy": "literal-no-automatic-mirroring",
    },
    {
        "id": "search",
        "label": "Search",
        "category": "navigation",
        "pairModel": "weight",
        "meaning": "Find content. A heavier lens still has an open center.",
        "keywords": ["find", "lookup"],
        "example": "Search workspace",
        "rtlPolicy": "literal-no-automatic-mirroring",
    },
    {
        "id": "plus",
        "label": "Plus",
        "category": "actions",
        "pairModel": "weight",
        "meaning": "Add or create. Distinct from expand and zoom-in.",
        "keywords": ["add", "new", "create"],
        "example": "Create item",
        "rtlPolicy": "literal-no-automatic-mirroring",
    },
    {
        "id": "arrow-right",
        "label": "Arrow right",
        "category": "navigation",
        "pairModel": "weight",
        "meaning": "A literal right arrow. Navigation direction must be chosen by the application.",
        "keywords": ["next", "forward"],
        "example": "Next step",
        "rtlPolicy": "literal-no-automatic-mirroring",
    },
    {
        "id": "user",
        "label": "User",
        "category": "people-communication",
        "pairModel": "silhouette",
        "meaning": "A person or profile.",
        "keywords": ["person", "account"],
        "example": "Your profile",
        "rtlPolicy": "literal-no-automatic-mirroring",
    },
    {
        "id": "file",
        "label": "File",
        "category": "content",
        "pairModel": "silhouette",
        "meaning": "A document. Not a duplicate action.",
        "keywords": ["document", "page"],
        "example": "Read document",
        "rtlPolicy": "literal-no-automatic-mirroring",
    },
    {
        "id": "calendar",
        "label": "Calendar",
        "category": "content",
        "pairModel": "silhouette",
        "meaning": "A date or calendar.",
        "keywords": ["date", "schedule"],
        "example": "Choose date",
        "rtlPolicy": "literal-no-automatic-mirroring",
    },
    {
        "id": "sliders",
        "label": "Sliders",
        "category": "actions",
        "pairModel": "silhouette",
        "meaning": "Adjust parameters. Not a funnel filter or gear glyph.",
        "keywords": ["settings", "adjust", "controls"],
        "example": "Adjust view",
        "rtlPolicy": "literal-no-automatic-mirroring",
    },
    {
        "id": "warning",
        "label": "Warning",
        "category": "status-security",
        "pairModel": "silhouette",
        "meaning": "A warning requiring a visible text label in every supported appearance and native size.",
        "keywords": ["caution", "attention"],
        "example": "Needs attention",
        "rtlPolicy": "literal-no-automatic-mirroring",
        "usageRestriction": "warning-visible-label",
    },
    {
        "id": "link",
        "label": "Link",
        "category": "content",
        "pairModel": "weight",
        "meaning": "A link or related resource. Not external navigation by itself.",
        "keywords": ["url", "chain"],
        "example": "Copy link",
        "rtlPolicy": "literal-no-automatic-mirroring",
    },
    {
        "id": "branch",
        "label": "Branch",
        "category": "system-data",
        "pairModel": "silhouette",
        "meaning": "A branching relationship. Use a visible label, especially at 12 px.",
        "keywords": ["workflow", "fork"],
        "example": "Workflow branch",
        "rtlPolicy": "literal-no-automatic-mirroring",
    },
    {
        "id": "star",
        "label": "Star",
        "category": "content",
        "pairModel": "silhouette",
        "meaning": "Favorite or rating, with context. Distinct from Focus.",
        "keywords": ["favorite", "rating"],
        "example": "Favorite",
        "rtlPolicy": "literal-no-automatic-mirroring",
    },
)

IDS = tuple(i["id"] for i in ICONS)
ICON_BY_ID = {i["id"]: i for i in ICONS}
PAIR_MODEL = {i["id"]: i["pairModel"] for i in ICONS}


class UnavailablePack(KeyError):
    """This pilot does not serve another style pack (including Angular)."""


class UnknownIcon(KeyError):
    """Canonical ID is not in the 12-icon calibration set."""


class UnavailableAppearance(KeyError):
    """Appearance is not outline or filled, or is not drawn for this ID."""


class UnavailableMaster(KeyError):
    """Optical master is not a native 12 / 16 / 24 drawing. No size fallback."""


def resolve(pack, icon_id, appearance, master):
    """Validate a drawing request. Returns a tuple key. Never substitutes."""
    if pack != PACK:
        raise UnavailablePack(
            "Pack %r is not served by the Technical pilot (no fallback)" % (pack,)
        )
    if icon_id not in ICON_BY_ID:
        raise UnknownIcon("Unknown Technical icon %r (no fallback)" % (icon_id,))
    if appearance not in APPEARANCES:
        raise UnavailableAppearance(
            "Appearance %r is unavailable for %s (no fallback)" % (appearance, icon_id)
        )
    if master not in MASTERS:
        raise UnavailableMaster(
            "Master %r is not a native Technical size for %s (no fallback)"
            % (master, icon_id)
        )
    return pack, icon_id, appearance, int(master)


def select_master(display_size):
    """Map a display size to a native master. Unknown sizes raise, never clamp."""
    if display_size not in MASTER_FOR_DISPLAY:
        raise UnavailableMaster(
            "Display size %r has no reviewed Technical master (no fallback)"
            % (display_size,)
        )
    return MASTER_FOR_DISPLAY[display_size]


# Named questions for human review. Construction must not "decide" these.
OPEN_QUESTIONS = (
    {
        "id": "search-as-viewfinder",
        "icons": ["search"],
        "question": "Is a chamfered-square viewfinder still recognizable as Search next to crop/frame/view tools?",
    },
    {
        "id": "cad-star-as-favorite",
        "icons": ["star"],
        "question": "Does a regular (not optically shifted) five-point star read as Favorite, or as a CAD/badge mark?",
    },
    {
        "id": "plus-keyline-mixed-toolbar",
        "icons": ["plus"],
        "question": "Should Technical plus keep its tighter inset, or share Angular's outer keyline in mixed-pack toolbars?",
    },
    {
        "id": "density-12-link-branch",
        "icons": ["link", "branch"],
        "question": "Are 12 px Link shackles and Branch junction boxes recognizable at native size, or must they stay labeled-only?",
    },
)
