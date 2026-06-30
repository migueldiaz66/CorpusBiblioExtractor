#!/usr/bin/env Rscript
# CLI wrapper around cbe_extract_ui().
#   Rscript extract.R [--src <biblioshiny dir>] [--out <dir>]
# Default src = the installed bibliometrix's biblioshiny; default out = ./ui_metadata
suppressPackageStartupMessages(library(CorpusBiblioExtractor))
a    <- commandArgs(trailingOnly = TRUE)
flag <- function(n, d = NULL) { i <- which(a == n); if (length(i) && i < length(a)) a[i + 1] else d }
m <- cbe_extract_ui(src = flag("--src"), out = flag("--out", file.path(getwd(), "ui_metadata")))
cat(sprintf("Extracted %d pages (%d in menu), %d help keys.\n",
            length(m$pages), m$summary$n_in_menu, m$summary$n_help_keys))
