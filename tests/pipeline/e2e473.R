# Opt-in end-to-end: full 42-section sweep on assetsbib/large.bib (400-500 docs,
# ~12 min). Asserts the whole pipeline closes with no errors and builds the index.
# SKIPS if large.bib is absent or out of range.
test_section("e2e :: FULL SWEEP (large.bib, ~12 min)")
LARGE  <- assetsbib("large.bib")
nlarge <- bib_count(LARGE)
if (!(nlarge >= 400 && nlarge <= 500)) {
  cat(sprintf("  [SKIP] assetsbib/large.bib missing or out of range 400-500 (got %d) - see assetsbib/README.md\n", nlarge))
} else {
  TMP <- file.path(tempdir(), paste0("cbe_e2e_", as.integer(runif(1, 1, 1e6))))
  RD  <- NULL; invisible(capture.output(RD <- cbe_run(bib = LARGE, runs_root = TMP)))
  test_that("full sweep produced a run dir + index", {
    expect_true(!is.null(RD) && dir.exists(RD), "run dir")
    expect_file(file.path(RD, "index.html"), "index")
  })
  if (!is.null(RD) && dir.exists(RD)) {
    man  <- jsonlite::fromJSON(file.path(RD, "_manifest.json"), simplifyVector = FALSE)
    nerr <- sum(vapply(man, function(x) identical(x$status, "error"), logical(1)))
    nok  <- sum(vapply(man, function(x) identical(x$status, "ok"),    logical(1)))
    test_that("full sweep: all 42 sections, no errors", {
      expect_equal(nerr, 0L, "0 errors")
      expect_true(nok >= 150, sprintf("scenarios ok (%d, expected ~159)", nok))
    })
  }
  unlink(TMP, recursive = TRUE)
}
