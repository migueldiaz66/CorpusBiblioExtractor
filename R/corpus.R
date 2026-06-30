# --- corpus.R ---------------------------------------------------------------
# Load the WoS .bib into a bibliometrix data frame (M), apply the study filters,
# and cache the result to RDS so repeated runs are fast.

# Document types excluded by the study (see Material y Método / EXHAUSTIVE plan).
EXCLUDED_DOC_TYPES <- c(
  "EARLY ACCESS", "RETRACTED PUBLICATION", "CORRECTION",
  "LETTER", "NEWS ITEM"
)

load_corpus <- function(bib_path, cache = TRUE) {
  stopifnot(file.exists(bib_path))
  cache_file <- paste0(tools::file_path_sans_ext(bib_path), ".corpus.rds")
  if (cache && file.exists(cache_file) &&
      file.info(cache_file)$mtime >= file.info(bib_path)$mtime) {
    log_info(sprintf("Corpus from cache: %s", cache_file))
    return(readRDS(cache_file))
  }
  log_info("Converting .bib with bibliometrix::convert2df (dbsource='wos') ...")
  M <- bibliometrix::convert2df(bib_path, dbsource = "wos", format = "bibtex")
  n0 <- nrow(M)
  M  <- filter_corpus(M)
  log_info(sprintf("Filtered corpus: %d -> %d documents", n0, nrow(M)))
  if (cache) saveRDS(M, cache_file)
  M
}

filter_corpus <- function(M) {
  if ("DT" %in% names(M)) {
    keep <- !(toupper(trimws(M$DT)) %in% EXCLUDED_DOC_TYPES)
    M <- M[keep, , drop = FALSE]
  }
  M
}

write_corpus_info <- function(run_dir, M, bib_path) {
  info <- list(
    bib               = bib_path,
    n_documents       = nrow(M),
    timespan          = if ("PY" %in% names(M))
                          paste(range(suppressWarnings(as.numeric(M$PY)), na.rm = TRUE), collapse = "-")
                        else NA,
    sources           = if ("SO" %in% names(M)) length(unique(M$SO)) else NA,
    bibliometrix_ver  = as.character(utils::packageVersion("bibliometrix")),
    generated_utc     = format(as.POSIXct(Sys.time(), tz = "UTC"), "%Y-%m-%dT%H:%M:%SZ", tz = "UTC")
  )
  jsonlite::write_json(info, file.path(run_dir, "_corpus_info.json"),
                       auto_unbox = TRUE, pretty = TRUE)
  invisible(info)
}
