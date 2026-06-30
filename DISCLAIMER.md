# DISCLAIMER

**CorpusBiblioExtractor is a personal portfolio project — a personal tool built to ease a
bibliometrics thesis development process.** Please read this before using or forking it.

## It is beta — and intended to stay beta
The core objective — extracting and materialising the full set of biblioshiny
outputs from a bibliographic corpus — works end to end. Everything beyond that is
hardening, documented as known, intentional debt in
[`docs/TECHNICAL_DEBT.md`](docs/TECHNICAL_DEBT.md). There is no roadmap to a "1.0".

## It is pinned to the versions it was tested against
There is **no guarantee of backward or forward compatibility.** It was developed
and tested *only* against:

- **R 4.6.1**
- **bibliometrix 5.4.1** (which ships *biblioshiny*)
- the exact versions of every other CRAN dependency, **frozen in `renv.lock`**
- Windows 11

Because the runner mirrors — and the extractor parses — biblioshiny's source code,
a different bibliometrix/biblioshiny version may change or break results.
`cbe_run()` calls `cbe_check_versions()` and **warns** when your installed R or
bibliometrix differ from the tested baseline. Run `renv::restore()` (or
`Rscript make.R setup`) to install the exact pinned versions.

## Input format, and no example data or outputs
- **Input is Web of Science BibTeX only** (`convert2df(dbsource = "wos", format = "bibtex")`).
  Other sources (OpenAlex, Scopus, …) are **not** supported in this version — OpenAlex does not even
  emit WoS-format `.bib`. Multi-source ingestion is recorded as future work in
  [`docs/TECHNICAL_DEBT.md`](docs/TECHNICAL_DEBT.md).
- **No corpus, and no example run outputs, are shipped in this repository.** Both would be derived
  from licensed Web of Science data, whose terms prohibit redistribution. Bring your own corpus
  (see [`assetsbib/README.md`](assetsbib/README.md)) and generate your own runs **locally** — the
  `runs/` directory is git-ignored on purpose.

## No "latest" — versions are locked
Dependencies are **not** tracked to "latest"; they are frozen to the numeric
versions in `renv.lock` as of this writing. Update at your own risk, in a fork.

## No support · no pull requests · not a community project
This repository is published as a portfolio artifact. **Issues and pull requests
are not monitored or accepted.** It is licensed under **GPL-3** (see `NOTICE.md`
for attribution to bibliometrix): fork it and improve it on your own terms.
