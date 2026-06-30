# Versions this package was developed and tested against. renv.lock pins the
# FULL dependency tree; this lightweight guard warns at runtime if the two
# critical pieces differ: R and bibliometrix (which ships biblioshiny — the UI
# the runner mirrors and the extractor parses, and which changes across versions).
.CBE_TESTED <- list(R = "4.6.1", bibliometrix = "5.4.1")

#' Check runtime versions against the tested, pinned baseline
#'
#' CorpusBiblioExtractor is pinned (see `renv.lock`) to the dependency versions it
#' was tested with. This warns — or, with `strict = TRUE`, errors — when the
#' installed R or `bibliometrix` differs, because `biblioshiny`'s UI (mirrored by
#' the runner and parsed by the extractor) changes between versions. It is called
#' automatically at the start of [cbe_run()].
#'
#' @param strict If `TRUE`, raise an error instead of a warning on a mismatch.
#' @return (invisibly) `TRUE` if everything matches the baseline, `FALSE` otherwise.
#' @export
cbe_check_versions <- function(strict = FALSE) {
  diffs <- character(0)
  rv <- paste(R.version$major, R.version$minor, sep = ".")
  if (!identical(rv, .CBE_TESTED$R))
    diffs <- c(diffs, sprintf("R %s (tested %s)", rv, .CBE_TESTED$R))
  bv <- tryCatch(as.character(utils::packageVersion("bibliometrix")), error = function(e) "missing")
  if (!identical(bv, .CBE_TESTED$bibliometrix))
    diffs <- c(diffs, sprintf("bibliometrix %s (tested %s)", bv, .CBE_TESTED$bibliometrix))
  if (length(diffs)) {
    msg <- sprintf(paste0("CorpusBiblioExtractor was tested against pinned versions; running with: %s. ",
                          "Results are not guaranteed across versions (biblioshiny's UI changes). ",
                          "Run renv::restore() to match the lockfile."),
                   paste(diffs, collapse = "; "))
    if (strict) stop(msg, call. = FALSE) else warning(msg, call. = FALSE)
  }
  invisible(length(diffs) == 0)
}
