"""Public seams for the Rounded calibration pilot.

Tests bind to these names and behaviors, not to helper internals.
Implementation lives in draw / svg / lookup; this module is the contract.
"""
from __future__ import annotations

PACK = 'rounded'
FAMILY = 'Vector UI'
VERSION = '0.1.0-soft-pilot'
STATUS = 'calibration-pilot-not-public'

CANONICAL_IDS = (
    'home', 'search', 'plus', 'arrow-right', 'user', 'file',
    'calendar', 'sliders', 'warning', 'link', 'branch', 'star',
)

APPEARANCES = ('outline', 'filled')
MASTERS = (12, 16, 24)
# Products serialize as expanded polylines. The validator still accepts curves.
PRODUCT_PATH_COMMANDS = ('M', 'L', 'Z')
VALIDATOR_PATH_COMMANDS = ('M', 'L', 'C', 'Q', 'A', 'Z')

# Nominal tokens — same numbers as Outline, different join/cap model.
OUTLINE_WIDTH = {12: 1.0, 16: 1.5, 24: 2.0}
BOLD_WIDTH = {12: 2.0, 16: 2.5, 24: 3.0}
# Filled Link 12 is thinner than BOLD_WIDTH so its counters stay open. Registered exception.
LINK_BOLD_WIDTH = {12: 1.75, 16: 2.5, 24: 3.0}
PADDING = {12: 1.0, 16: 1.5, 24: 2.0}
GAP_TARGET = {12: 1.0, 16: 1.5, 24: 2.0}
# Smallest inscribed diameter of a transparent counter (GRAMMAR section 6).
COUNTER_FLOOR = {12: 0.9, 16: 1.35, 24: 1.8}
# Object outer corners ≈ 1.6–1.7× outline. Wired into drawers. Not legacy fillet proposal's 0.5–1× fillet.
CORNER_TOKEN = {12: 1.6, 16: 2.4, 24: 3.4}
# Acute cues (dog-ear, apex, roof peak) stay round but smaller. Above the outline
# width, so a ring's inner contour keeps a visible radius too.
ACUTE_JOIN = {12: 1.25, 16: 2.0, 24: 2.6}
# Terminals a boolean cut leaves behind: fold slit, header rail, door jambs, link weave.
CUT_JOIN = {12: 0.3, 16: 0.45, 24: 0.6}
# Pointed silhouette exception: star join ~0.5× outline. 1.0×+ collapses optical mass.
STAR_JOIN = {12: 0.65, 16: 0.85, 24: 1.0}

# Explicit reviewed display-size mapping. Anything else must raise.
MASTER_SELECTION = {12: 12, 14: 16, 16: 16, 20: 24, 24: 24, 32: 24}

PAIR_MODEL = {
    'home': 'silhouette',
    'search': 'weight',
    'plus': 'weight',
    'arrow-right': 'weight',
    'user': 'silhouette',
    'file': 'silhouette',
    'calendar': 'silhouette',
    'sliders': 'silhouette',
    'warning': 'silhouette',
    'link': 'weight',
    'branch': 'silhouette',
    'star': 'silhouette',
}

MEANING = {
    'home': 'Home or top-level destination. Do not substitute for Back.',
    'search': 'Find content. A heavier lens still has an open center.',
    'plus': 'Add or create. Distinct from expand and zoom-in.',
    'arrow-right': 'A literal right arrow. Navigation direction must be chosen by the application.',
    'user': 'A person or profile.',
    'file': 'A document. Not a duplicate action.',
    'calendar': 'A date or calendar.',
    'sliders': 'Adjust parameters. Not a funnel filter or gear glyph.',
    'warning': 'A warning requiring a visible text label in every supported appearance and native size.',
    'link': 'A link or related resource. Not external navigation by itself.',
    'branch': 'A branching relationship. Requires a visible text label at every size.',
    'star': 'Favorite or rating, with context. Distinct from Focus.',
}

LABELS = {
    'home': 'Home',
    'search': 'Search',
    'plus': 'Plus',
    'arrow-right': 'Arrow right',
    'user': 'User',
    'file': 'File',
    'calendar': 'Calendar',
    'sliders': 'Sliders',
    'warning': 'Warning',
    'link': 'Link',
    'branch': 'Branch',
    'star': 'Star',
}

# Flattening used when measuring A/C/Q. Construction buffers use the same quad_segs.
FLATTEN_TOLERANCE_PX = 0.05
QUAD_SEGS = 8

OUTLINE_ROOT_REL = ('design', 'icons', 'outline')


class UnknownIconError(LookupError):
    """Canonical ID is not in the Rounded pilot set. Do not substitute."""


class UnknownAppearanceError(LookupError):
    """Appearance is not outline|filled. Do not substitute the other."""


class UnknownMasterError(LookupError):
    """Native master or display size is not in the reviewed table. Do not pick a neighbor."""


class CrossPackFallbackError(LookupError):
    """Asked for a pack this pilot will not serve. Never return another family silently."""
