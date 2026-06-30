#' Run the exhaustive biblioshiny sweep over a bibliographic corpus
#'
#' Runs every section x Main-Configuration combination of biblioshiny 5.4.1 by
#' calling `bibliometrix` directly (no GUI, no Python) and materialises every
#' output asset to `<runs_root>/<UTC>/<section>/<combination>/`, plus a
#' per-scenario `_timing.csv`, a resume `_manifest.json`, a `_corpus_info.json`,
#' and a self-contained per-run `index.html`.
#'
#' @param bib Path to a BibTeX corpus file (required unless `dry_run = TRUE`).
#' @param only Optional comma-separated id substrings restricting which sections run.
#' @param resume Optional run timestamp (UTC, colon-free) to resume; assets already
#'   marked `ok` are skipped and `error`/missing ones retried.
#' @param seed Integer RNG seed for reproducibility of stochastic steps (default 42).
#' @param runs_root Directory under which the dated run directory is created
#'   (default `file.path(getwd(), "runs")`).
#' @param dry_run If `TRUE`, list scenarios and expected assets without computing.
#' @return (invisibly) the run directory path.
#' @export
cbe_run <- function(bib = NULL, only = NULL, resume = NULL, seed = 42L,
                    runs_root = NULL, dry_run = FALSE) {
  spec     <- read_spec(system.file("spec", "plan.json", package = "CorpusBiblioExtractor"))
  scaffold <- system.file("scaffold", package = "CorpusBiblioExtractor")
  if (is.null(runs_root)) runs_root <- file.path(getwd(), "runs")
  cbe_check_versions()   # warn if R / bibliometrix differ from the tested baseline

  ts <- if (!is.null(resume)) resume
        else format(as.POSIXct(Sys.time(), tz = "UTC"), "%Y-%m-%dT%H%M%SZ", tz = "UTC")
  run_dir <- file.path(runs_root, ts)
  dir.create(run_dir, recursive = TRUE, showWarnings = FALSE)
  init_log(file.path(run_dir, "_run_log.txt"))
  manifest <- load_manifest(run_dir)
  elapsed  <- function(t0) as.numeric(difftime(Sys.time(), t0, units = "secs"))

  log_info(sprintf("Run %s | bib=%s | seed=%d | only=%s | dry=%s", ts,
                   ifelse(is.null(bib), "-", bib), seed, ifelse(is.null(only), "-", only), dry_run))

  M <- NULL
  if (!dry_run) {
    if (is.null(bib)) stop("`bib` is required (unless dry_run = TRUE)")
    t_corpus <- Sys.time()
    M <- load_corpus(bib)
    log_info(sprintf("Corpus loaded: %d documents (%.1fs)", nrow(M), elapsed(t_corpus)))
    write_corpus_info(run_dir, M, bib)
  }

  n_ok <- 0L; n_err <- 0L; n_skip <- 0L; timing <- list(); run_t0 <- Sys.time()
  for (section in spec$sections) {
    if (!is.null(only) &&
        !any(vapply(strsplit(only, ",")[[1]], function(o) grepl(trimws(o), section$id, fixed = TRUE), logical(1)))) next
    combos <- expand_combinations(section); sec_t0 <- Sys.time()
    log_info(sprintf("Section %s | %d scenario(s) | runner=%s", section$id, length(combos), section$runner))

    for (combo in combos) {
      pending <- Filter(function(a) !is_done(manifest, asset_key(section$id, combo$name, a$id)), section$assets)
      if (length(pending) == 0) { n_skip <- n_skip + 1L; log_info(sprintf("  [skip] %s", combo$name)); next }
      if (dry_run) { log_info(sprintf("  [dry ] %s -> %s", combo$name,
                                       paste(vapply(section$assets, function(a) a$filename, ""), collapse = ", "))); next }

      out_dir <- file.path(run_dir, section$id, combo$name)
      dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
      params_full <- c(combo$values, section$compute)

      t0 <- Sys.time()
      assets <- tryCatch(run_section(section, M, params_full, seed),
                         error = function(e) { log_error(sprintf("  %s | %s | %s", section$id, combo$name, conditionMessage(e))); NULL })
      if (is.null(assets)) {
        dt <- elapsed(t0)
        for (a in section$assets) manifest[[asset_key(section$id, combo$name, a$id)]] <- list(status = "error")
        save_manifest(run_dir, manifest)
        timing[[length(timing) + 1L]] <- list(section = section$id, runner = section$runner,
                                              combination = combo$name, seconds = round(dt, 3), status = "error", n_assets = 0L)
        n_err <- n_err + 1L; log_info(sprintf("  [err ] %s (%.1fs)", combo$name, dt)); next
      }
      for (a in assets) {
        fname <- sprintf("%s__%s__%s", section$id, combo$name, a$filename)
        path  <- file.path(out_dir, fname)
        ok <- tryCatch({ save_asset(a, path); TRUE },
                       error = function(e) { log_error(sprintf("  save %s: %s", path, conditionMessage(e))); FALSE })
        manifest[[asset_key(section$id, combo$name, a$id)]] <- list(status = if (ok) "ok" else "error", path = path)
      }
      dt <- elapsed(t0); save_manifest(run_dir, manifest)
      timing[[length(timing) + 1L]] <- list(section = section$id, runner = section$runner,
                                            combination = combo$name, seconds = round(dt, 3), status = "ok", n_assets = length(assets))
      n_ok <- n_ok + 1L; log_info(sprintf("  [ok  ] %s (%.1fs)", combo$name, dt))
    }
    log_info(sprintf("Section %s finished (%.1fs)", section$id, elapsed(sec_t0)))
  }

  if (length(timing) > 0) {
    td  <- do.call(rbind, lapply(timing, function(x) as.data.frame(x, stringsAsFactors = FALSE)))
    utils::write.csv(td, file.path(run_dir, "_timing.csv"), row.names = FALSE)
    agg <- stats::aggregate(seconds ~ section + runner, data = td, FUN = sum)
    nsc <- stats::aggregate(seconds ~ section, data = td, FUN = length)
    agg$n_scen <- nsc$seconds[match(agg$section, nsc$section)]
    agg <- agg[order(-agg$seconds), ]
    log_info("=== Timing per section (total s, desc) ===")
    for (i in seq_len(nrow(agg)))
      log_info(sprintf("  %-42s %8.1fs  | %3d scen | %s", agg$section[i], agg$seconds[i], agg$n_scen[i], agg$runner[i]))
    log_info(sprintf("Scenarios timed: %d | sum-of-scenarios=%.1fs | slowest single scenario=%.1fs",
                     nrow(td), sum(td$seconds), max(td$seconds)))
  }

  if (!dry_run) {
    idx <- tryCatch(build_run_index(run_dir, ts, base = scaffold),
                    error = function(e) { log_error(sprintf("index: %s", conditionMessage(e))); NULL })
    if (!is.null(idx)) log_info(sprintf("Index: %s", idx))
  }
  total_s <- elapsed(run_t0)
  log_info(sprintf("Done. scenarios ok=%d err=%d skipped=%d | wall=%.1fs (%.1f min) | run_dir=%s",
                   n_ok, n_err, n_skip, total_s, total_s / 60, run_dir))
  invisible(run_dir)
}
