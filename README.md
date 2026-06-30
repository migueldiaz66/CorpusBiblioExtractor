# CorpusBiblioExtractor

> Drive **bibliometrix** directly — no GUI, no Python — to run the *full* combinatorial
> sweep of **biblioshiny**'s "Main Configuration" over a bibliographic corpus, materialise
> every output asset (tables, figures, interactive networks & Sankeys, Pajek nets), and
> browse the whole run in a self-contained HTML viewer. Plus an AST-based extractor that
> reads biblioshiny's UI metadata straight from source.

**Re-run an entire science-mapping study after the corpus changes in one command and a few
minutes — not days of manual point-and-click in the GUI.** That repeatability is the point.

![status: beta](https://img.shields.io/badge/status-beta-orange)
![license: GPL-3](https://img.shields.io/badge/license-GPL--3.0-blue)
![R 4.6.1](https://img.shields.io/badge/R-4.6.1-276DC3)
![deps: pinned (renv)](https://img.shields.io/badge/deps-pinned%20(renv)-success)

> ⚠️ **Personal portfolio project — a personal tool built to ease a bibliometrics thesis
> development process. Beta, and meant to stay beta. No support, no pull
> requests.** Pinned to the exact dependency versions it was tested with. Read
> [`DISCLAIMER.md`](DISCLAIMER.md) before using or forking. Licensed **GPL-3** (see
> [`NOTICE.md`](NOTICE.md) for attribution to bibliometrix).

---

## What it does

[biblioshiny](https://www.bibliometrix.org/) is a Shiny GUI over the `bibliometrix` R
package. Reproducing a *complete* science-mapping study through it means clicking every
section, toggling every Field / Method / Measure / N-Grams selector, exporting each table
and figure, and organising hundreds of files by hand — and redoing all of it whenever the
corpus changes.

CorpusBiblioExtractor does that **exhaustively, by code, in one command**:

1. **Extract** the UI metadata from biblioshiny's source via the R AST →
   what controls exist, which combinations are possible, what each view produces.
2. **Plan** the Cartesian product of the categorical *Main Configuration* selectors for all
   42 sections (the machine-readable spec ships in `inst/spec/plan.json`).
3. **Run** every section × combination by calling `bibliometrix` directly, writing each
   asset to `runs/<UTC>/<section>/<combination>/` and a **self-contained `index.html`**
   whose menu is proportional to the sections that actually ran.

### The value is the *re*-run, not the first run

A science-mapping study is **iterative**: you refine the query, add a year, fix a
document-type filter, re-download the corpus — and **every change very likely invalidates every table,
figure, and network you already produced.** Reproducing the full sweep by hand in
biblioshiny takes **days — realistically weeks** — across hundreds of point-and-click
exports, with the transcription errors and rework that manual processes carry. And you pay
that cost *again* on every corpus change.

Here it is **one command, in minutes, deterministically** (`set.seed`, manifest-based
resume). The first run saves you an afternoon; **every corpus change after that saves you a
week.** *That* is the point.

> Scaling is sub-linear — a ~10× larger corpus costs only ~2.5× more time; a full
> 42-section sweep of a ~470-document corpus runs in roughly 13 minutes.

### Public API (`cbe_*`)

| Function | What it does |
|---|---|
| `cbe_run(bib, …)` | Exhaustive sweep over a corpus → assets + per-run `index.html` |
| `cbe_build_index(run_dir)` | (Re)build a run's HTML viewer |
| `cbe_extract_ui(src, out)` | Parse the installed biblioshiny's `ui.R` → `ui_metadata.json` |
| `cbe_verify_parity(run_dir)` | Spot-check saved tables vs an independent bibliometrix recompute |
| `cbe_check_versions()` | Warn if R / bibliometrix differ from the tested baseline |

Asset types: `.xlsx` tables · `.png` ggplot figures · interactive `.html` networks
(visNetwork) and Sankeys (plotly) · Pajek `.net`.

---

## Requirements (strict — versions are pinned)

This project is **deliberately locked** to the exact versions it was tested against. There
is **no "latest"**: every dependency is frozen in [`renv.lock`](renv.lock), and `cbe_run()`
**warns** (via `cbe_check_versions()`) if your R or bibliometrix differ.

| | Tested / pinned version |
|---|---|
| **R** | **4.6.1** |
| **bibliometrix** (ships *biblioshiny*) | **5.4.1** |
| All other CRAN dependencies (123 packages) | exact versions in **`renv.lock`** |
| OS | Windows 11 (should work elsewhere; untested) |

Key pins (full list in `renv.lock`): `dplyr 1.2.1`, `ggplot2 4.0.3`, `igraph 2.3.2`,
`openxlsx 4.2.8.1`, `plotly 4.12.0`, `visNetwork 2.1.4`, `commonmark 2.0.0`,
`treemapify 2.6.0`, `jsonlite 2.0.0`, `htmlwidgets 1.6.4`.
*Optional:* `ggwordcloud` (real word-clouds; without it the wordcloud falls back to bars) —
pinned (`ggwordcloud 0.6.2`) and installed by `make.R setup`.

> **No Python, no pandoc, no Rtools** are required (pure-R package; interactive widgets are
> saved with `selfcontained = FALSE`).

---

## Install (one command)

```bash
git clone https://github.com/migueldiaz66/CorpusBiblioExtractor
cd CorpusBiblioExtractor
Rscript make.R setup
```

`make.R setup` installs `renv`, runs `renv::restore()` to install the **exact pinned
versions** from `renv.lock`, then installs the package itself. That's it.

<details><summary>Manual install (equivalent)</summary>

```r
install.packages("renv")
renv::restore()                                    # installs the 123 pinned versions
install.packages(".", repos = NULL, type = "source")  # install CorpusBiblioExtractor
```
</details>

> Windows has no `make`; use `Rscript make.R <target>`. A thin `Makefile` is provided for
> systems that do.

---

## Use

**Bring your own corpus.** No data ships with this repo: Web of Science licenses prohibit
redistributing exports, so you supply your own (see [`assetsbib/README.md`](assetsbib/README.md)).
**Input is Web of Science BibTeX only** (`convert2df(dbsource = "wos", format = "bibtex")`).

```bash
# run the full sweep on your WoS BibTeX export
Rscript make.R run path/to/your.bib
# -> writes runs/<UTC>/...  open runs/<UTC>/index.html in a browser
```

…or from R:

```r
library(CorpusBiblioExtractor)
run_dir <- cbe_run(bib = "path/to/your.bib")   # warns if your versions drift from the baseline
browseURL(file.path(run_dir, "index.html"))

cbe_extract_ui(out = "ui_metadata")            # parse the installed biblioshiny's UI -> JSON
```

CLI targets: `Rscript make.R {setup | test | check | run <bib> | extract | index <run>}`.

---

## Tests

A dependency-free harness (no testthat):

```bash
Rscript make.R test            # unit + pipeline (the latter needs assetsbib/short.bib)
Rscript make.R test --unit     # fast, no corpus
Rscript make.R test --e2e473   # full sweep on assetsbib/large.bib (~12 min)
```

- **Unit** (47): combination expansion (incl. conditionals), manifest, savers, AST helpers,
  and structural facts of the installed `ui.R` (a version-drift detector).
- **Pipeline**: a real `cbe_run()` of a per-family subset on `assetsbib/short.bib` →
  smoke + a corpus-specific regression baseline + a determinism check.

Corpus-dependent tests **skip** unless you place `assetsbib/short.bib` (10–40 docs) and/or
`assetsbib/large.bib` (400–500 docs). See [`tests/README.md`](tests/README.md).

---

## Scope & limitations

- **Input: Web of Science BibTeX only.** OpenAlex/Scopus/etc. are not supported (OpenAlex
  doesn't even emit WoS-format `.bib`); multi-source ingestion is noted as future work.
- **No example data or run outputs are shipped** (they'd derive from licensed WoS data).
- **Beta, version-locked, unsupported.** Known, intentional debt is catalogued in
  [`docs/TECHNICAL_DEBT.md`](docs/TECHNICAL_DEBT.md).

---

## Origin

This started as a very personal frustration. While writing a bibliometrics thesis, every time
I stepped away from the work and came back to it — a fresh corpus export, a tweaked filter, one
more year of data — I had to **recreate the entire science-mapping analysis by hand** in
biblioshiny. That recurring nightmare is exactly what this tool automates away, so that neither
the next person nor the next *me* ever has to redo it manually again.

📖 Write-up (Spanish): [*Bibliometría reproducible con R y bibliometrix*](https://www.migueldiazmacedo.com/bibliometria/bibliometria-reproducible/) — the why and how, on the author's blog.

## License & attribution

**GPL-3** (see [`LICENSE.md`](LICENSE.md)). It builds on, requires, and bundles documentation
derived from **bibliometrix** / **biblioshiny** (© Massimo Aria & Corrado Cuccurullo,
GPL-3) — see [`NOTICE.md`](NOTICE.md). Not affiliated with or endorsed by the bibliometrix
authors.

> Aria, M. & Cuccurullo, C. (2017). *bibliometrix: An R-tool for comprehensive science
> mapping analysis.* Journal of Informetrics, 11(4), 959–975.
