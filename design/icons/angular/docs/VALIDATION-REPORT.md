# Validation report locations

This pilot.2 patch supersedes the previous unstamped reports. Actual results
are recorded in `reports/AUDIT-FIXES.md` and the machine-readable reports.
Each technical report contains an evidence envelope with all relevant file
hashes, tool versions, and a payload hash. Missing or stale envelopes fail the
release gate. Counted checks do not establish design or accessibility approval.

The strict browser runners require HTTP and file loading. Content mode tests
injected HTML only and must not be called full browser integration. Reports
state the executed mode and browser version. WebKit is not branded Safari.

The original 288 native pixel snapshots remain unchanged. The original 198
baseline files and all 288 pilot SVGs must remain byte-identical. No new icons,
Rounded pack, or recognition study is included in this patch.
