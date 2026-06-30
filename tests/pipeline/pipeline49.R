# Pipeline test on assetsbib/short.bib (required 10-40 docs): one real cbe_run()
# of a per-family subset, then SMOKE (it ran, assets exist), REGRESSION (key
# values vs a LOCAL baseline snapshot = drift detector), DETERMINISM (same
# scenario twice -> identical .net). SKIPS entirely if short.bib is absent or
# out of range. The snapshot is corpus-specific and git-ignored (bring-your-own
# corpus), bootstrapped on first run.

test_section("pipeline :: SMOKE (short.bib)")
SHORT  <- assetsbib("short.bib")
nshort <- bib_count(SHORT)
if (!(nshort >= 10 && nshort <= 40)) {
  cat(sprintf("  [SKIP] assetsbib/short.bib missing or out of range 10-40 (got %d) - see assetsbib/README.md\n", nshort))
} else {
  SUBSET <- paste("main_information", "most_relevant_sources", "bradford", "lotka",
                  "countries_scientific_production", "most_global_cited_documents",
                  "most_frequent_words", "co_occurrence", "thematic_map", "import_or_load", sep = ",")
  TMP <- file.path(tempdir(), paste0("cbe_test_", as.integer(runif(1, 1, 1e6))))
  RD  <- NULL; invisible(capture.output(RD <- cbe_run(bib = SHORT, only = SUBSET, runs_root = TMP)))

  sec_dir   <- function(rd, frag) { d <- list.dirs(rd, recursive = FALSE, full.names = TRUE); d[grepl(frag, basename(d))][1] }
  find_file <- function(rd, frag, pat) { sd <- sec_dir(rd, frag); if (is.na(sd)) return(NA); f <- list.files(sd, pattern = pat, recursive = TRUE, full.names = TRUE); if (length(f)) f[1] else NA }

  test_that("run produced a run dir", expect_true(!is.null(RD) && dir.exists(RD), "run_dir"))
  test_that("run-level artifacts exist", {
    expect_file(file.path(RD, "index.html"), "index");      expect_file(file.path(RD, "_timing.csv"), "timing")
    expect_file(file.path(RD, "_manifest.json"), "manifest"); expect_file(file.path(RD, "_corpus_info.json"), "corpus_info")
  })
  ci  <- jsonlite::fromJSON(file.path(RD, "_corpus_info.json"))
  man <- jsonlite::fromJSON(file.path(RD, "_manifest.json"), simplifyVector = FALSE)
  nerr <- sum(vapply(man, function(x) identical(x$status, "error"), logical(1)))
  nok  <- sum(vapply(man, function(x) identical(x$status, "ok"), logical(1)))
  test_that("subset ran with assets and no errors", {
    expect_true(as.integer(ci$n_documents) > 0 && as.integer(ci$n_documents) <= 40, "short corpus size")
    expect_true(nok > 0, sprintf("ok assets (%d)", nok))
    expect_equal(nerr, 0L, "no errors in this subset")
  })
  test_that("each requested family produced a section folder with assets", {
    for (frag in c("main_information", "most_relevant_sources", "bradford", "lotka",
                   "most_global_cited_documents", "most_frequent_words", "co_occurrence", "thematic_map")) {
      sd <- sec_dir(RD, frag)
      expect_true(!is.na(sd) && length(list.files(sd, recursive = TRUE)) > 0, frag)
    }
  })

  # ===== REGRESSION / local baseline snapshot (git-ignored, corpus-specific) =
  test_section("pipeline :: REGRESSION (local baseline)")
  SNAP_FILE   <- file.path(TDIR, "fixtures", "snapshots_short.json")
  SNAP        <- if (file.exists(SNAP_FILE)) jsonlite::fromJSON(SNAP_FILE, simplifyVector = TRUE) else list()
  SNAP_UPDATE <- RT_has("--update-snapshots"); SNAP_BOOT <- !file.exists(SNAP_FILE); SNAP_NEW <- list()
  check_snap  <- function(key, actual, tol = 1e-6) {
    SNAP_NEW[[key]] <<- actual
    if (SNAP_UPDATE || SNAP_BOOT || is.null(SNAP[[key]])) { .pass(paste("snapshot", key, "(recorded)")); return(invisible()) }
    exp <- SNAP[[key]]
    ok <- if (is.numeric(actual) && is.numeric(exp)) length(actual) == length(exp) && all(abs(as.numeric(actual) - as.numeric(exp)) <= tol)
          else isTRUE(all.equal(as.character(actual), as.character(exp)))
    if (ok) .pass(paste("snapshot", key)) else .fail(sprintf("snapshot %s DRIFT (got=%s want=%s)", key, paste(actual, collapse = ","), paste(exp, collapse = ",")))
  }
  test_that("corpus headline numbers", {
    check_snap("corpus.docs", as.integer(ci$n_documents)); check_snap("corpus.sources", as.integer(ci$sources))
  })
  f <- find_file(RD, "most_relevant_sources", "__table\\.xlsx$")
  test_that("Most Relevant Sources", {
    expect_true(!is.na(f), "table found")
    if (!is.na(f)) { t <- openxlsx::read.xlsx(f); check_snap("mrs.top1_source", as.character(t$Sources[1])); check_snap("mrs.articles", as.numeric(t$Articles[seq_len(min(5, nrow(t)))])) }
  })
  f <- find_file(RD, "bradford", "__table\\.xlsx$")
  test_that("Bradford zones", {
    expect_true(!is.na(f), "table found")
    if (!is.na(f)) { t <- openxlsx::read.xlsx(f); check_snap("bradford.zones", as.numeric(table(t$Zone))) }
  })
  if (SNAP_UPDATE || SNAP_BOOT) {
    dir.create(dirname(SNAP_FILE), showWarnings = FALSE, recursive = TRUE)
    jsonlite::write_json(SNAP_NEW, SNAP_FILE, auto_unbox = TRUE, pretty = TRUE, digits = 10)
    cat(sprintf("  (local snapshot %s -> %s)\n", if (SNAP_BOOT) "bootstrapped" else "updated", basename(SNAP_FILE)))
  }

  # ===== DETERMINISM ========================================================
  test_section("pipeline :: DETERMINISM")
  TMP2 <- file.path(tempdir(), paste0("cbe_test2_", as.integer(runif(1, 1, 1e6))))
  RD2  <- NULL; invisible(capture.output(RD2 <- cbe_run(bib = SHORT, only = "co_occurrence", runs_root = TMP2)))
  net1 <- find_file(RD,  "co_occurrence", "field-keywords_plus__network\\.net$")
  net2 <- find_file(RD2, "co_occurrence", "field-keywords_plus__network\\.net$")
  test_that("co-occurrence network is reproducible across runs (set.seed)", {
    expect_true(!is.na(net1) && !is.na(net2), "both .net found")
    if (!is.na(net1) && !is.na(net2)) expect_equal(unname(tools::md5sum(net1)), unname(tools::md5sum(net2)), "identical .net")
  })
  unlink(c(TMP, TMP2), recursive = TRUE)
}
