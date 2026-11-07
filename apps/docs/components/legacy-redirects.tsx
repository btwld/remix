'use client';

import { useEffect } from 'react';
import legacyAnchors from '@/legacy-anchors.json';
import { sitePath } from '@/lib/paths';

type OldPagePath = string;
type HeadingId = string;
type NewPagePath = string;
const anchors: Record<OldPagePath, Record<HeadingId, NewPagePath>> = legacyAnchors;

/** Forwards retired deep links client-side, since the static export has no server redirects. */
export function LegacyRedirects() {
  useEffect(() => {
    const path = location.pathname.slice(sitePath('').length).replace(/\/$/, '');
    const id = location.hash.slice(1);
    if (path === '' && location.hash.startsWith('#/?')) {
      location.replace(sitePath('/catalog/') + location.search + location.hash);
    } else if (Object.hasOwn(anchors, path) && Object.hasOwn(anchors[path], id)) {
      location.replace(sitePath(anchors[path][id]) + location.search + location.hash);
    }
  }, []);
  return null;
}
