# --- runners_data.R ---------------------------------------------------------
# Load / appraisal family: the data-handling sections of biblioshiny that have
# no Main-Configuration selectors (single "default" scenario each).
#   1.1.1 Import or Load   -> readable export of the collection
#   2.1   Filters          -> readable export of the (filtered) collection + TCpY
#   2.2   PRISMA Diagram    -> screening summary table by document type
# Helpers (.tbl) come from runners.R (sourced earlier, alphabetically).

# === 1.1.1 Import or Load ===================================================
# Export a legible subset of the collection's columns (those that exist in M).
register_runner("import_or_load", function(M, params) {
  cols    <- c("SR", "AU", "TI", "SO", "JI", "PY", "DT", "DE", "ID", "TC", "DI", "LA", "SC")
  present <- cols[cols %in% names(M)]
  df      <- M[, present, drop = FALSE]
  list(.tbl(df))
})

# === 2.1 Filters ============================================================
# Typical filtered-table subset + TCpY (citations per year since publication).
register_runner("filters", function(M, params) {
  cols    <- c("SR", "AU", "TI", "SO", "PY", "LA", "DT", "TC", "DI")
  present <- cols[cols %in% names(M)]
  df      <- M[, present, drop = FALSE]
  if (all(c("TC", "PY") %in% names(M))) {
    py <- suppressWarnings(as.numeric(M$PY))
    tc <- suppressWarnings(as.numeric(M$TC))
    df$TCpY <- tc / (max(py, na.rm = TRUE) - py + 1)
  }
  list(.tbl(df))
})

# === 2.2 PRISMA Diagram =====================================================
# Batch mode has no interactive PRISMA flow; summarize the screening by
# document type: count of M$DT with percentages and a TOTAL row.
register_runner("prisma", function(M, params) {
  dtv <- toupper(trimws(M$DT))
  TAB <- data.frame(DocumentType = dtv, stringsAsFactors = FALSE) |>
    dplyr::count(DocumentType, name = "N") |>
    dplyr::arrange(dplyr::desc(N)) |>
    as.data.frame()
  TAB$Percent <- round(100 * TAB$N / sum(TAB$N), 2)
  TAB <- rbind(TAB, data.frame(DocumentType = "TOTAL", N = sum(TAB$N), Percent = 100))
  list(.tbl(TAB))
})
