# CorpusBiblioExtractor — Release Notes

Semantic Versioning (`vMAJOR.MINOR.PATCH`, with an optional `-beta.N` pre-release
suffix). This project is a personal portfolio tool: **beta, and intended to stay
beta** — no support, no pull requests, pinned to its tested dependency versions.

---

## v0.2.0 — biblioshiny-verbatim rendering

**What changed since v0.1.0.** Figures and tables are now produced by **reusing
biblioshiny's own functions** (from the installed `bibliometrix`) instead of
reimplementing them, so the output matches biblioshiny exactly. The public API
(`cbe_run()`, `cbe_build_index()`, `cbe_extract_ui()`, `cbe_verify_parity()`,
`cbe_check_versions()`) is unchanged — this is a backward-compatible **minor**
release (new functionality + new dependencies, no breaking changes).

### Verbatim rendering
- **On-screen figures render via `plot.ly` (plotly), not `ggsave`** — matching what
  biblioshiny actually shows: thin axis fonts, no baked-in title, right-hand
  legends. Applies to the ranking lollipops (`freqPlot`), the over-time line charts
  (Sources / Affiliations / Countries / Words' Frequency over Time), References
  Spectroscopy, Trend Topics, and the factorial word maps.
- **biblioshiny's real helpers are reused** through a private environment populated
  at load time: `freqPlot`, `plot.ly`, `igraph2vis`, `wordlist`, `ValueBoxes`,
  `lifeCycleSummaryUI`, `cssTags`, `plotlySankey2png`, `biblioShot`, `authorCard`,
  `ca2plotly`, `dend2vis`, `hist2vis`, `mapworld`, `to_title_case`, and more.
- **Tables corrected to biblioshiny's exact columns** — e.g. Most Global / Local
  Cited Documents now include the `Normalized TC`, `LC/GC Ratio (%)` and
  normalized-citations columns; Most Local Cited References gets its Google Scholar
  link column; Most Frequent Words / Words over Time use the right field labels.
- **UI Options defaults** are flattened out of `plan.json` and passed to each runner
  (`params$ui`), so every section runs with biblioshiny's real defaults.

### New asset types
- Live **plotly** and **visNetwork** widgets are saved as interactive HTML **and**
  snapshotted to a static **PNG** via headless Chrome (`webshot2` / `chromote`), so
  no view is HTML-only and the per-run viewer can embed a thumbnail.
- **Author-profile cards** (top-10 authors) as hyperlinked **SVG** + **PNG**, and
  **Life-Cycle summary cards** rendered from biblioshiny's own `lifeCycleSummaryUI`
  + `cssTags`.

### Viewer (`index.html`)
- The setup groups **1 · Search** (import / filters) and **2 · Appraisal** (PRISMA)
  are reliably hidden from the viewer (dropped by group **and** by section-number
  prefix, so a section that fell back to another group is still removed).
- Results-first tabs, click-to-enlarge lightbox, and full-height live widgets.

### Dependencies
- `plotly`, `ggplot2`, `dplyr`, `shiny`, `tidyr`, `visNetwork` are now **attached**
  (`Depends`) so the reused biblioshiny helpers resolve their bare symbols — e.g.
  `lifeCycleSummaryUI()` calls `tagList()` bare and `dend2vis()` calls
  `visHclust()`/`visGroups()` bare, so without those packages attached the Life-Cycle
  summary card and the Factorial Analysis topic dendrogram errored out and were
  silently dropped. (These mirror the top-level `library(...)` calls the thesis
  driver relied on, which don't attach at runtime inside an installed package.)
- Added to `Imports`: `base64enc`, `chromote`, `grid`, `htmltools`, `ragg`,
  `webshot2`, `wordcloud2`. `renv.lock` re-snapshotted; `R CMD check` Status: OK.

Still **WoS-BibTeX only** (multi-source import remains technical debt).

---

## v0.1.0-beta.1 — first public release

First GitHub release. The core objective — extract and materialise the full set of
biblioshiny outputs from a bibliographic corpus — works end to end.

- **Exhaustive sweep runner** (`cbe_run()`): runs every section × Main-Configuration
  combination of biblioshiny 5.4.1 by calling `bibliometrix` directly (no GUI, no
  Python). Asset types: `.xlsx` tables, `.png` figures, interactive `.html` networks
  (visNetwork) and Sankeys (plotly), Pajek `.net`. Per-scenario timing,
  manifest-based resume, fixed seed for reproducibility.
- **Per-run self-contained viewer** (`index.html`): vertical menu proportional to the
  sections that actually ran + horizontal tabs (Info & References / Options / Tabs /
  Results).
- **AST-based UI-metadata extractor** (`cbe_extract_ui()`): parses biblioshiny's
  `ui.R` from source and emits a structured JSON (menu, per-page options with box
  group + conditional, output tabs, help keys).
- **Test suite**: unit + pipeline (smoke / regression-snapshot / determinism) on a
  small corpus, plus an opt-in end-to-end on a large corpus. Bring-your-own corpora
  via `assetsbib/` (no licensed data shipped). GPL-3, `renv`-pinned, `R CMD check`
  Status: OK.
