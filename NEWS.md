# CorpusBiblioExtractor — NEWS

## v0.2.0 — biblioshiny-verbatim rendering

Figures and tables are now rendered by **reusing biblioshiny's own functions**
(from the installed `bibliometrix`) instead of reimplementing them, so the output
matches biblioshiny exactly:

- **On-screen figures render via `plot.ly` (plotly), not `ggsave`** — thin axis
  fonts, no title, right-hand legends — matching what biblioshiny shows: ranking
  lollipops (`freqPlot`), the over-time line charts, References Spectroscopy,
  Trend Topics, Words' Frequency over Time.
- **Real biblioshiny helpers reused** via a private env populated at load time
  (`freqPlot`, `plot.ly`, `igraph2vis`, `wordlist`, `ValueBoxes`,
  `lifeCycleSummaryUI`, `cssTags`, `to_title_case`, …).
- **Tables corrected to biblioshiny's exact columns** (e.g. Most Global/Local
  Cited Documents' `Normalized TC` / `LC/GC Ratio` / normalized-citations columns;
  Most Local Cited References' Google Scholar link column).
- **Options defaults from the UI** are flattened out of `plan.json` and passed to
  the runners (`params$ui`), so each section runs with biblioshiny's real defaults.
- HTML-widget figures (visNetwork, plotly Sankeys, wordcloud2) are additionally
  snapshotted to PNG via headless Chrome (`webshot2`).

New dependencies for the above: `plotly`/`ggplot2`/`dplyr`/`shiny`/`tidyr`/`visNetwork`
are now attached (`Depends`) so the reused biblioshiny helpers resolve their bare
symbols (e.g. `lifeCycleSummaryUI()` calls `tagList()` bare, `dend2vis()` calls
`visHclust()` bare), plus `htmltools`, `webshot2`, `wordcloud2`, `ragg`, `grid`,
`base64enc`, `chromote` in `Imports`. Still beta, still WoS-BibTeX only, still no
support / no PRs.

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
