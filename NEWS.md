# CorpusBiblioExtractor — NEWS

## v0.1.0 (beta.1) — first public release

First GitHub release. **Beta, and intended to stay beta**: the core objective —
extract and materialise the full set of biblioshiny outputs from a bibliographic
corpus — works end to end. Everything else is hardening (see `TECHNICAL_DEBT`).

Highlights:

- **Exhaustive sweep runner** (`cbe_run()`): runs every section × Main-Configuration
  combination of biblioshiny 5.4.1 by calling `bibliometrix` directly (no GUI, no
  Python). Asset types: `.xlsx` tables, `.png` ggplot figures, interactive
  `.html` networks (visNetwork) and Sankeys (plotly), Pajek `.net`. Per-scenario
  timing, manifest-based resume, fixed seed for reproducibility.
- **Per-run self-contained viewer** (`index.html`): vertical menu proportional to
  the sections that actually ran + horizontal tabs (Info & References / Options /
  Tabs / Results).
- **AST-based UI-metadata extractor** (`cbe_extract_ui()`): parses biblioshiny's
  `ui.R` from source and emits a structured JSON (menu, per-page options with box
  group + conditional, output tabs, help keys) — reproducible across versions.
- **Test suite**: 47 unit + pipeline (smoke / regression-snapshot / determinism)
  on a small corpus, plus an opt-in end-to-end on a large corpus. Bring-your-own
  corpora via `assetsbib/` (no licensed data shipped).

Known limitations are documented and intentional — see the DISCLAIMER and
`docs/TECHNICAL_DEBT.md`. Pinned to its tested dependency versions via `renv`.
