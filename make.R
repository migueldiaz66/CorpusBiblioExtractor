#!/usr/bin/env Rscript
# ============================================================================
# Cross-platform task runner (no `make` required) for CorpusBiblioExtractor.
#
#   Rscript make.R setup          # install pinned deps (renv) + the package
#   Rscript make.R test [--unit|--pipeline|--e2e473|--all]
#   Rscript make.R check          # R CMD check (no manual)
#   Rscript make.R run <bib>      # cbe_run() on a .bib  (or use assetsbib/)
#   Rscript make.R extract        # cbe_extract_ui() -> ./ui_metadata
#   Rscript make.R index <run>    # rebuild a run's index.html
#
# (A thin Makefile delegates to these targets for users who have `make`.)
# ============================================================================

a    <- commandArgs(trailingOnly = TRUE)
t    <- if (length(a)) a[1] else "help"
rest <- if (length(a) > 1) a[-1] else character(0)
RS   <- file.path(R.home("bin"), "Rscript")
RB   <- file.path(R.home("bin"), "R")

run_target <- switch(t,

  setup = {
    if (!requireNamespace("renv", quietly = TRUE))
      install.packages("renv", repos = "https://cloud.r-project.org")
    renv::activate()                                       # writes renv infra (idempotent)
    renv::restore(prompt = FALSE)                          # install the pinned versions from renv.lock
    install.packages(".", repos = NULL, type = "source")   # install CorpusBiblioExtractor itself
    cat("Setup complete. Try: Rscript make.R test --unit\n")
  },

  test    = quit(status = system2(RS, c("tests/run_tests.R", rest))),
  check   = quit(status = system2(RB, c("CMD", "check", "--no-manual", "--no-build-vignettes", "."))),

  run = {
    if (!length(rest)) stop("usage: Rscript make.R run <path-to-.bib>")
    suppressPackageStartupMessages(library(CorpusBiblioExtractor))
    cbe_run(bib = rest[1])
  },
  extract = {
    suppressPackageStartupMessages(library(CorpusBiblioExtractor))
    m <- cbe_extract_ui(out = file.path(getwd(), "ui_metadata"))
    cat(sprintf("Extracted %d pages -> %s\n", length(m$pages), file.path(getwd(), "ui_metadata", "ui_metadata.json")))
  },
  index = {
    if (!length(rest)) stop("usage: Rscript make.R index <run-dir>")
    suppressPackageStartupMessages(library(CorpusBiblioExtractor))
    cbe_build_index(rest[1])
  },

  {  # help / default
    cat("targets: setup | test [flags] | check | run <bib> | extract | index <run>\n")
  }
)
