# --- runners_documents.R ----------------------------------------------------
# ANALYSIS > Documents family. Registers four runners. Sourced after
# registry.R (register_runner) and runners.R (helpers .tbl/.fig/.hbar), so all
# of those are available here.
#
# Contract: register_runner("<name>", function(M, params){ ... ; list(<assets>) })
#   asset = list(id=, type=, filename=, object=)
#   helpers: .tbl(df, file, id)  -> table_xlsx ; .fig(ggplot, file, id) -> figure_png
#            .hbar(df, value_col, label_col, title, xlab, n=20) -> ggplot (top-n h-bars)
# No tryCatch / no set.seed / no plotly here (driver handles seed + errors).
#
# Notes on data sources (verified against bibliometrix 5.4.1 source + server.R):
# - Global cited docs: TCperYear = round(TC/(currentYear+1-PY),1)  [server.R ~8927].
# - localCitations(M)$Papers cols: Paper, DOI, Year, LCS, GCS      [localCitations.R].
# - citations(field="article")$Cited is a sorted named table;
#   biblioshiny drops "ANONYMOUS, NO TITLE CAPTURED"               [server.R ~9202].
# - rpys() EXPOSES median.window ("centered"/"backward"); its $rpysTable cols are
#   Year, Citations, diffMedian5 (backward), diffMedian2 (centered), diffMedian
#   (= the window selected). So we pass params$median_window straight through and
#   plot the resulting diffMedian; no manual rolling median needed.   [rpys.R].

# === Documents family =======================================================

# 1) Most Global Cited Documents --------------------------------------------
# 3.4.1.1 · plot.png + table.xlsx · params$measure in
#   {total_citations, total_citations_per_year}
register_runner("most_global_cited_documents", function(M, params) {
  y   <- as.numeric(substr(Sys.Date(), 1, 4))
  TAB <- data.frame(
    Paper          = M$SR,
    DOI            = M$DI,
    Title          = M$TI,
    Year           = M$PY,
    TotalCitations = M$TC,
    TCperYear      = round(M$TC / (y + 1 - M$PY), 1),
    stringsAsFactors = FALSE
  )
  measure_col <- switch(params$measure,
                        total_citations          = "TotalCitations",
                        total_citations_per_year = "TCperYear",
                        stop("unknown measure: ", params$measure))
  xlab <- if (params$measure == "total_citations")
            "Global Citations" else "Global Citations per Year"
  TAB <- TAB[order(-TAB[[measure_col]]), , drop = FALSE]
  list(.fig(.hbar(TAB, measure_col, "Paper", "Most Global Cited Documents", xlab)),
       .tbl(TAB))
})

# 2) Most Local Cited Documents ---------------------------------------------
# 3.4.1.2 · plot.png + table.xlsx · no params
register_runner("most_local_cited_documents", function(M, params) {
  lc <- bibliometrix::localCitations(M, fast.search = FALSE, sep = ";")$Papers
  lc <- as.data.frame(lc)          # cols: Paper, DOI, Year, LCS, GCS
  list(.fig(.hbar(lc, "LCS", "Paper", "Most Local Cited Documents", "Local Citations")),
       .tbl(lc))
})

# 3) Most Local Cited References --------------------------------------------
# 3.4.2.1 · plot.png + table.xlsx · no params
register_runner("most_local_cited_references", function(M, params) {
  cr  <- bibliometrix::citations(M, field = "article", sep = ";")$Cited
  TAB <- data.frame(
    Reference = names(cr),
    Citations = as.numeric(cr),
    stringsAsFactors = FALSE
  )
  # Mirror biblioshiny: drop the placeholder for uncaptured references.
  TAB <- TAB[TAB$Reference != "ANONYMOUS, NO TITLE CAPTURED", , drop = FALSE]
  list(.fig(.hbar(TAB, "Citations", "Reference", "Most Local Cited References", "Citations")),
       .tbl(TAB))
})

# 4) References Spectroscopy (RPYS) -----------------------------------------
# 3.4.2.2 · plot.png + table.xlsx · params$median_window in {centered, backward}
# rpys() exposes median.window, so the chosen window drives $rpysTable$diffMedian
# directly (backward -> diffMedian5, centered -> diffMedian2).
register_runner("references_spectroscopy", function(M, params) {
  r   <- bibliometrix::rpys(M, sep = ";", timespan = NULL,
                            median.window = params$median_window, graph = FALSE)
  tab <- as.data.frame(r$rpysTable)   # Year, Citations, diffMedian5, diffMedian2, diffMedian
  p <- ggplot2::ggplot(tab, ggplot2::aes(x = Year)) +
    ggplot2::geom_line(ggplot2::aes(y = Citations), color = "black") +
    ggplot2::geom_line(ggplot2::aes(y = diffMedian), color = "firebrick") +
    ggplot2::labs(
      title   = sprintf("Reference Publication Year Spectroscopy (%s median)",
                        params$median_window),
      x = "Year", y = "Cited References",
      caption = paste0("Black line: cited references per year. ",
                       "Red line: deviation from the ", params$median_window,
                       " 5-year moving median.")) +
    ggplot2::theme_minimal(base_size = 12)
  list(.fig(p), .tbl(tab))
})
