#!/usr/bin/env Rscript
# CLI wrapper around cbe_run().
#   Rscript run.R --bib <path.bib> [--only ids] [--resume <UTC>] [--seed 42]
#                 [--runs-root <dir>] [--dry-run]
suppressPackageStartupMessages(library(CorpusBiblioExtractor))
a    <- commandArgs(trailingOnly = TRUE)
flag <- function(n, d = NULL) { i <- which(a == n); if (length(i) && i < length(a)) a[i + 1] else d }
has  <- function(n) n %in% a
invisible(cbe_run(
  bib       = flag("--bib"),
  only      = flag("--only"),
  resume    = flag("--resume"),
  seed      = as.integer(flag("--seed", "42")),
  runs_root = flag("--runs-root"),
  dry_run   = has("--dry-run")))
