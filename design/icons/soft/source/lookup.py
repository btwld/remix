"""Explicit lookup seams. Missing pack/size/appearance never substitutes."""
from __future__ import annotations

from source.draw import draw
from source.seams import (
    APPEARANCES, CANONICAL_IDS, CrossPackFallbackError, LABELS, MASTERS,
    MASTER_SELECTION, PACK, UnknownAppearanceError, UnknownIconError,
    UnknownMasterError,
)
from source.svg import path_data, svg_text


def select_master(display_size: int) -> int:
    if display_size not in MASTER_SELECTION:
        raise UnknownMasterError(
            f'No reviewed Soft master for display size {display_size}; will not guess')
    return MASTER_SELECTION[display_size]


def icon_svg(icon_id: str, *, appearance: str, master: int, pack: str = PACK) -> str:
    if pack != PACK:
        raise CrossPackFallbackError(
            f'Soft pilot will not serve pack {pack!r}; no silent fallback')
    if icon_id not in CANONICAL_IDS:
        raise UnknownIconError(f'Unknown Soft icon {icon_id!r}')
    if appearance not in APPEARANCES:
        raise UnknownAppearanceError(f'Unknown appearance {appearance!r}')
    if master not in MASTERS:
        raise UnknownMasterError(f'No native Soft master {master}')
    geom = draw(icon_id, master, appearance)
    return svg_text(LABELS[icon_id], appearance, master, path_data(geom))


def icon_svg_for_display(icon_id: str, *, appearance: str, size: int, pack: str = PACK) -> str:
    return icon_svg(icon_id, appearance=appearance, master=select_master(size), pack=pack)
