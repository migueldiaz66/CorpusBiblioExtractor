#!/usr/bin/env Rscript
# ============================================================================
# Test driver for CorpusBiblioExtractor. Run from the repo root:
#   Rscript tests/run_tests.R                 # unit + pipeline(short.bib)
#   Rscript tests/run_tests.R --unit          # unit only (no corpus)
#   Rscript tests/run_tests.R --pipeline      # pipeline only
#   Rscript tests/run_tests.R --e2e473        # large.bib end-to-end (~12 min)
#   Rscript tests/run_tests.R --all
#   ... --update-snapshots                    # re-baseline the regression snapshot
# Exit 0 = all passed, 1 = failures. Corpus tests SKIP if assetsbib/ files are
# absent or out of the required document-count range (see assetsbib/README.md).
# ============================================================================

# Locate the tests dir whether invoked from the repo root (manual) or from
# inside tests/ (R CMD check runs each tests/*.R with cwd = the tests dir).
if (file.exists(file.path(getwd(), "helpers", "assert.R"))) {
  TDIR <- getwd(); REPO <- dirname(getwd())
} else {
  REPO <- getwd(); TDIR <- file.path(REPO, "tests")
}
suppressPackageStartupMessages(library(CorpusBiblioExtractor))

RT_args <- commandArgs(trailingOnly = TRUE)
RT_has  <- function(f) f %in% RT_args
RT_do_unit <- TRUE; RT_do_pipeline <- TRUE; RT_do_e2e473 <- FALSE
if (RT_has("--unit"))     RT_do_pipeline <- FALSE
if (RT_has("--pipeline")) RT_do_unit <- FALSE
if (RT_has("--e2e473"))  { RT_do_unit <- FALSE; RT_do_pipeline <- FALSE; RT_do_e2e473 <- TRUE }
if (RT_has("--all"))     { RT_do_unit <- TRUE;  RT_do_pipeline <- TRUE;  RT_do_e2e473 <- TRUE }

source(file.path(TDIR, "helpers", "assert.R"))
cat(sprintf("Tests: unit=%s pipeline=%s e2e473=%s\n", RT_do_unit, RT_do_pipeline, RT_do_e2e473))

# count records in a .bib (raw @ entries); used for the assetsbib range gate
bib_count <- function(path) if (file.exists(path)) length(grep("^@", readLines(path, warn = FALSE))) else 0L
assetsbib <- function(name) file.path(REPO, "assetsbib", name)

if (RT_do_unit)
  for (f in c("test_spec.R", "test_manifest.R", "test_savers.R", "test_extractor.R"))
    source(file.path(TDIR, "unit", f))
if (RT_do_pipeline) source(file.path(TDIR, "pipeline", "pipeline49.R"))
if (RT_do_e2e473)   source(file.path(TDIR, "pipeline", "e2e473.R"))

nfail <- test_summary()
quit(status = if (nfail > 0) 1L else 0L)
