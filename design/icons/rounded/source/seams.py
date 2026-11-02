"""Public seams for the Rounded family.

Tests bind to these names and behaviors, not to helper internals.
Implementation lives in draw / svg / lookup; this module is the contract.
"""
from __future__ import annotations

PACK = 'rounded'
FAMILY = 'Vector UI'
VERSION = '0.2.0-private'
STATUS = 'private-source-pack-not-public'

CANONICAL_IDS = (
    'home', 'menu', 'more', 'search', 'grid', 'arrow-left', 'arrow-right', 'arrow-up',
    'arrow-down', 'arrow-up-right', 'chevron-left', 'chevron-right', 'chevron-up',
    'chevron-down', 'plus', 'minus', 'check', 'close', 'edit', 'copy', 'trash', 'refresh',
    'filter', 'sliders', 'upload', 'download', 'save', 'file', 'folder', 'link', 'bookmark',
    'star', 'calendar', 'user', 'chat', 'bell', 'warning', 'info', 'help', 'lock', 'shield',
    'gear', 'terminal', 'branch', 'chart', 'play', 'pause', 'focus', 'activity',
    'align-center', 'align-left', 'align-right', 'box', 'check-circle', 'circle', 'ban',
    'close-circle', 'cursor', 'dot', 'chevrons-left', 'chevrons-right', 'bold', 'type',
    'group', 'heart', 'input', 'laptop', 'wand', 'smartphone', 'moon', 'square', 'layers',
    'sun', 'table', 'loader', 'code', 'dashboard',
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

# remix_ui_icons compiles at this many units per em, so one pixel is 15360 / master units.
FONT_UNITS_PER_EM = 15360
# 1/80 px is the coarsest grid exact in both four-decimal SVG coordinates and font units at every
# master. A master on it compiles with nothing to round. Used only where rounding flips a pixel.
FONT_EXACT_GRID = 0.0125
FONT_EXACT_MASTERS = frozenset({('play', 16, 'outline'), ('box', 16, 'outline')})

# Explicit reviewed display-size mapping. Anything else must raise.
MASTER_SELECTION = {12: 12, 14: 16, 16: 16, 20: 24, 24: 24, 32: 24}

PAIR_MODEL = {
    'home': 'silhouette',
    'menu': 'weight',
    'more': 'weight',
    'search': 'weight',
    'grid': 'silhouette',
    'arrow-left': 'weight',
    'arrow-right': 'weight',
    'arrow-up': 'weight',
    'arrow-down': 'weight',
    'arrow-up-right': 'weight',
    'chevron-left': 'weight',
    'chevron-right': 'weight',
    'chevron-up': 'weight',
    'chevron-down': 'weight',
    'plus': 'weight',
    'minus': 'weight',
    'check': 'weight',
    'close': 'weight',
    'edit': 'silhouette',
    'copy': 'silhouette',
    'trash': 'silhouette',
    'refresh': 'weight',
    'filter': 'silhouette',
    'sliders': 'silhouette',
    'upload': 'weight',
    'download': 'weight',
    'save': 'silhouette',
    'file': 'silhouette',
    'folder': 'silhouette',
    'link': 'weight',
    'bookmark': 'silhouette',
    'star': 'silhouette',
    'calendar': 'silhouette',
    'user': 'silhouette',
    'chat': 'silhouette',
    'bell': 'silhouette',
    'warning': 'silhouette',
    'info': 'silhouette',
    'help': 'silhouette',
    'lock': 'silhouette',
    'shield': 'silhouette',
    'gear': 'silhouette',
    'terminal': 'silhouette',
    'branch': 'silhouette',
    'chart': 'weight',
    'play': 'silhouette',
    'pause': 'weight',
    'focus': 'weight',
    'activity': 'weight',
    'align-center': 'silhouette',
    'align-left': 'silhouette',
    'align-right': 'silhouette',
    'box': 'silhouette',
    'check-circle': 'silhouette',
    'circle': 'silhouette',
    'ban': 'weight',
    'close-circle': 'silhouette',
    'cursor': 'silhouette',
    'dot': 'weight',
    'chevrons-left': 'weight',
    'chevrons-right': 'weight',
    'bold': 'weight',
    'type': 'weight',
    'group': 'weight',
    'heart': 'silhouette',
    'input': 'silhouette',
    'laptop': 'silhouette',
    'wand': 'weight',
    'smartphone': 'silhouette',
    'moon': 'silhouette',
    'square': 'silhouette',
    'layers': 'silhouette',
    'sun': 'silhouette',
    'table': 'silhouette',
    'loader': 'weight',
    'code': 'weight',
    'dashboard': 'silhouette',
}

MEANING = {
    'home': 'Home or top-level destination. Do not substitute for Back.',
    'menu': 'Open navigation or a menu.',
    'more': 'Additional actions in an overflow menu.',
    'search': 'Find content. A heavier lens still has an open center.',
    'grid': 'Open an application grid or change to grid view.',
    'arrow-left': 'Literal left arrow; application chooses its navigation role.',
    'arrow-right': 'A literal right arrow. Navigation direction must be chosen by the application.',
    'arrow-up': 'Literal up arrow, not Upload.',
    'arrow-down': 'Literal down arrow, not Download.',
    'arrow-up-right': 'Open another destination. Keep a visible action label.',
    'chevron-left': 'Compact left direction. Navigation semantics stay in the component.',
    'chevron-right': 'Compact right direction. Not an external-link marker.',
    'chevron-up': 'Up direction or collapse, with a label.',
    'chevron-down': 'Down direction or disclosure, with a label.',
    'plus': 'Add or create. Distinct from expand and zoom-in.',
    'minus': 'Decrease or subtract. Not a destructive delete substitute.',
    'check': 'Confirm or communicate completion.',
    'close': 'Dismiss or close. Do not use as a destructive delete substitute.',
    'edit': 'A pencil for editing content.',
    'copy': 'Create a duplicate or copy to clipboard.',
    'trash': 'Delete. Confirm destructive behavior at the application level.',
    'refresh': 'Reload the current data. Not Undo or Redo.',
    'filter': 'A funnel that narrows a result set. Not generic adjustment controls.',
    'sliders': 'Adjust parameters. Not a funnel filter or gear glyph.',
    'upload': 'Transfer into a service.',
    'download': 'Transfer out to this device.',
    'save': 'A disk metaphor for committing changes. Not Bookmark or Download.',
    'file': 'A document. Not a duplicate action.',
    'folder': 'A folder or grouped files.',
    'link': 'A link or related resource. Not external navigation by itself.',
    'bookmark': 'Save a reference for later. Different from saving changed data.',
    'star': 'Favorite or rating, with context. Distinct from Focus.',
    'calendar': 'A date or calendar.',
    'user': 'A person or profile.',
    'chat': 'A message or conversation.',
    'bell': 'Notifications. Do not imply a warning or failure by shape alone.',
    'warning': 'A warning requiring a visible text label in every supported appearance and native size.',
    'info': 'Information about content or a status. Distinct from Help and Warning.',
    'help': 'Assistance or documentation. Distinct from information status.',
    'lock': 'Restricted access or locked content.',
    'shield': 'Protection or policy. Pair with the actual status in text.',
    'gear': 'A gear settings metaphor. Sliders remains a separate adjustment glyph.',
    'terminal': 'A command interface. Not an ordinary next arrow.',
    'branch': 'A branching relationship. Use a visible label, especially at 12 px.',
    'chart': 'A bar chart or analytics view.',
    'play': 'Play media or start an operation. Do not auto-mirror in RTL.',
    'pause': 'Pause an operation. Do not use for stop.',
    'focus': 'Focus a region. Context is required; not a star or fullscreen symbol.',
    'activity': 'A pulse of activity; existing registry activity motif.',
    'align-center': 'Align selected objects on a horizontal center axis; distinct from text paragraph formatting.',
    'align-left': 'Align selected objects to their left edge; distinct from paragraph formatting.',
    'align-right': 'Align selected objects to their right edge; distinct from paragraph formatting.',
    'box': 'A package or inventory box.',
    'check-circle': 'Confirmed or successful status in an enclosing circle.',
    'circle': 'A circular shape; do not imply control behavior.',
    'ban': 'Prohibited or unavailable action.',
    'close-circle': 'Dismissed or failed status in an enclosing circle.',
    'cursor': 'A pointer or selection tool.',
    'dot': 'A small solid dot, optically distinct from the full-size Circle.',
    'chevrons-left': 'Jump left or to the first item, with an enclosing action label.',
    'chevrons-right': 'Jump right or to the last item, with an enclosing action label.',
    'bold': 'Bold text formatting; authored letter B, no font outline reuse.',
    'type': 'Typography or text-size controls; authored letter T.',
    'group': 'Group or arrange selected objects, matching the current selection-group meaning.',
    'heart': 'Like or favorite with context; distinct from Star.',
    'input': 'A text input field with an insertion cursor.',
    'laptop': 'A laptop device or desktop-sized preview.',
    'wand': 'An assisted or automatic action, with an action label.',
    'smartphone': 'A mobile phone device or narrow preview.',
    'moon': 'Dark appearance or night; not a generic status.',
    'square': 'A square shape; do not imply control behavior.',
    'layers': 'A stack of layers or related objects.',
    'sun': 'Light appearance or daylight.',
    'table': 'Tabular data with a header and cells.',
    'loader': 'An in-progress segmented ring; animation belongs to the caller.',
    'code': 'Source code brackets, distinct from the Terminal prompt.',
    'dashboard': 'An overview of multiple panels, distinct from a uniform Grid.',
}

LABELS = {
    'home': 'Home',
    'menu': 'Menu',
    'more': 'More',
    'search': 'Search',
    'grid': 'Grid',
    'arrow-left': 'Arrow left',
    'arrow-right': 'Arrow right',
    'arrow-up': 'Arrow up',
    'arrow-down': 'Arrow down',
    'arrow-up-right': 'Arrow up right',
    'chevron-left': 'Chevron left',
    'chevron-right': 'Chevron right',
    'chevron-up': 'Chevron up',
    'chevron-down': 'Chevron down',
    'plus': 'Plus',
    'minus': 'Minus',
    'check': 'Check',
    'close': 'Close',
    'edit': 'Edit',
    'copy': 'Copy',
    'trash': 'Trash',
    'refresh': 'Refresh',
    'filter': 'Filter',
    'sliders': 'Sliders',
    'upload': 'Upload',
    'download': 'Download',
    'save': 'Save',
    'file': 'File',
    'folder': 'Folder',
    'link': 'Link',
    'bookmark': 'Bookmark',
    'star': 'Star',
    'calendar': 'Calendar',
    'user': 'User',
    'chat': 'Chat',
    'bell': 'Bell',
    'warning': 'Warning',
    'info': 'Info',
    'help': 'Help',
    'lock': 'Lock',
    'shield': 'Shield',
    'gear': 'Gear',
    'terminal': 'Terminal',
    'branch': 'Branch',
    'chart': 'Chart',
    'play': 'Play',
    'pause': 'Pause',
    'focus': 'Focus',
    'activity': 'Activity',
    'align-center': 'Align center',
    'align-left': 'Align left',
    'align-right': 'Align right',
    'box': 'Box',
    'check-circle': 'Check circle',
    'circle': 'Circle',
    'ban': 'Ban',
    'close-circle': 'Close circle',
    'cursor': 'Cursor',
    'dot': 'Dot',
    'chevrons-left': 'Chevrons left',
    'chevrons-right': 'Chevrons right',
    'bold': 'Bold',
    'type': 'Type',
    'group': 'Group',
    'heart': 'Heart',
    'input': 'Input',
    'laptop': 'Laptop',
    'wand': 'Wand',
    'smartphone': 'Smartphone',
    'moon': 'Moon',
    'square': 'Square',
    'layers': 'Layers',
    'sun': 'Sun',
    'table': 'Table',
    'loader': 'Loader',
    'code': 'Code',
    'dashboard': 'Dashboard',
}

# Drawings on the canvas centre along this axis, unless a 1 px stroke sits on one pixel line at 12.
CENTRED_AXIS = {
    'arrow-right': 'y', 'arrow-left': 'y', 'arrow-up': 'x', 'arrow-down': 'x',
    'upload': 'x', 'download': 'x', 'minus': 'y', 'menu': 'y', 'chart': 'x', 'type': 'x',
    'align-center': 'x', 'warning': 'x',
}

# Open glyphs whose filled stroke may sit below BOLD_WIDTH to keep their parts apart.
THINNED_FILLED_STROKE = ('code', 'group', 'loader')

# Flattening used when measuring A/C/Q. Construction buffers use the same quad_segs.
FLATTEN_TOLERANCE_PX = 0.05
QUAD_SEGS = 8

OUTLINE_ROOT_REL = ('design', 'icons', 'outline')


class UnknownIconError(LookupError):
    """Canonical ID is not in the Rounded inventory. Do not substitute."""


class UnknownAppearanceError(LookupError):
    """Appearance is not outline|filled. Do not substitute the other."""


class UnknownMasterError(LookupError):
    """Native master or display size is not in the reviewed table. Do not pick a neighbor."""


class CrossPackFallbackError(LookupError):
    """Asked for a pack this family will not serve. Never return another family silently."""
