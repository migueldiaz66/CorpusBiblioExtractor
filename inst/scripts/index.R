#!/usr/bin/env Rscript
# CLI wrapper around cbe_build_index(): (re)build a run's index.html.
#   Rscript index.R --run <path-to-run-dir>
suppressPackageStartupMessages(library(CorpusBiblioExtractor))
a    <- commandArgs(trailingOnly = TRUE)
flag <- function(n, d = NULL) { i <- which(a == n); if (length(i) && i < length(a)) a[i + 1] else d }
rd <- flag("--run")
if (is.null(rd)) stop("--run <run-dir> is required")
cbe_build_index(rd)
