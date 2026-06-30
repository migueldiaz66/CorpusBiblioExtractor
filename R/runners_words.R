# --- runners_words.R --------------------------------------------------------
# Words family: ANALYSIS > Documents > Words (biblioshiny 5.4.1).
# Pages: Most Frequent Words, WordCloud, TreeMap, Words' Frequency over Time,
#        Trend Topics.
# Helpers (.tbl/.fig/.hbar) come from runners.R; do NOT redefine them here.
# Available: bibliometrix, dplyr, ggplot2. No plotly (figures are ggplot).
# No tryCatch (the driver handles errors).

# --- internal helpers (words-specific) --------------------------------------

# N-gram count for a scenario. `params$ngrams` exists only for TI/AB; for every
# other field it is absent and 1 applies.
.ng <- function(params) if (!is.null(params$ngrams)) as.numeric(params$ngrams) else 1L

# WoS Subject Categories live in `WC` for plaintext imports but in `SC` for
# bibtex-derived collections (convert2df). Fall back WC -> SC when WC is absent.
.resolve_tag <- function(M, field) {
  if (identical(field, "WC") && !"WC" %in% names(M) && "SC" %in% names(M)) return("SC")
  field
}

# Resolve a field CODE to an actual ";"-separated term column, mirroring
# biblioshiny: TI/AB are run through termExtraction first (-> TI_TM / AB_TM);
# KW_Merged is built on demand if missing (convert2df normally creates it).
# Returns list(M = <possibly augmented M>, tag = <column to read>).
# Used by KeywordGrowth / fieldByYear, which (unlike tableTag) do NOT extract
# terms themselves.
.words_field <- function(M, field, ngrams = 1L) {
  if (field %in% c("TI", "AB")) {
    M <- bibliometrix::termExtraction(M, Field = field, ngrams = ngrams,
                                      stemming = FALSE, verbose = FALSE)
    return(list(M = M, tag = paste0(field, "_TM")))
  }
  if (identical(field, "KW_Merged") && !"KW_Merged" %in% names(M))
    M <- bibliometrix::mergeKeywords(M, force = FALSE)
  list(M = M, tag = .resolve_tag(M, field))
}

# Words/Frequencies data.frame for a field via tableTag (which extracts terms
# for TI/AB internally). Sorted by descending frequency (tableTag already sorts).
.words_table <- function(M, field, ngrams = 1L) {
  Tab <- bibliometrix::tableTag(M, Tag = .resolve_tag(M, field), sep = ";", ngrams = ngrams)
  data.frame(Words = names(Tab), Frequencies = as.numeric(Tab),
             stringsAsFactors = FALSE)
}

# === 3.4.3.1 Most Frequent Words ===========================================
# Horizontal bars of the most frequent terms + Words/Frequencies table.
register_runner("most_frequent_words", function(M, params) {
  TAB <- .words_table(M, params$field, .ng(params))
  list(
    .fig(.hbar(TAB, "Frequencies", "Words", "Most Frequent Words", "Occurrences")),
    .tbl(TAB)
  )
})

# === 3.4.3.2 WordCloud =====================================================
# ggwordcloud if available, else top-N horizontal bars; full frequency table.
register_runner("wordcloud", function(M, params) {
  TAB <- .words_table(M, params$field, .ng(params))
  topN <- utils::head(TAB, 50L)
  if (requireNamespace("ggwordcloud", quietly = TRUE)) {
    p <- ggwordcloud::ggwordcloud2(topN[, c("Words", "Frequencies")]) +
      ggplot2::theme_minimal(base_size = 12)
  } else {
    p <- .hbar(TAB, "Frequencies", "Words", "WordCloud (bar fallback)",
               "Occurrences", n = 20L)
  }
  list(.fig(p), .tbl(TAB))
})

# === 3.4.3.3 TreeMap =======================================================
# treemapify if available, else top-N horizontal bars; full frequency table.
register_runner("treemap", function(M, params) {
  TAB <- .words_table(M, params$field, .ng(params))
  topN <- utils::head(TAB, 50L)
  if (requireNamespace("treemapify", quietly = TRUE)) {
    p <- ggplot2::ggplot(topN, ggplot2::aes(area = .data[["Frequencies"]],
                                            fill = .data[["Frequencies"]],
                                            label = .data[["Words"]])) +
      treemapify::geom_treemap() +
      treemapify::geom_treemap_text(colour = "white", place = "centre",
                                    grow = TRUE, reflow = TRUE) +
      ggplot2::scale_fill_gradient(low = "#9ecae1", high = "#08519c") +
      ggplot2::labs(title = "TreeMap", fill = "Occurrences") +
      ggplot2::theme_minimal(base_size = 12)
  } else {
    p <- .hbar(TAB, "Frequencies", "Words", "TreeMap (bar fallback)",
               "Occurrences", n = 20L)
  }
  list(.fig(p), .tbl(TAB))
})

# === 3.4.3.4 Words' Frequency over Time ====================================
# KeywordGrowth (top 10, cumulative) -> line chart Year x freq; wide table.
register_runner("words_frequency_over_time", function(M, params) {
  fr  <- .words_field(M, params$field, .ng(params))
  KW  <- bibliometrix::KeywordGrowth(fr$M, Tag = fr$tag, sep = ";", top = 10)
  # Wide (Year + one column per term) for the table; long for the line plot.
  terms <- names(KW)[-1]
  long  <- do.call(rbind, lapply(terms, function(tm)
    data.frame(Year = KW$Year, Term = tm, Freq = KW[[tm]],
               stringsAsFactors = FALSE)))
  long$Term <- factor(long$Term, levels = terms)
  p <- ggplot2::ggplot(long, ggplot2::aes(x = .data[["Year"]], y = .data[["Freq"]],
                                          colour = .data[["Term"]])) +
    ggplot2::geom_line(linewidth = 0.8) +
    ggplot2::labs(title = "Words' Frequency over Time", x = "Year",
                  y = "Cumulate occurrences", colour = NULL) +
    ggplot2::theme_minimal(base_size = 12)
  list(.fig(p), .tbl(KW))
})

# === 3.4.3.5 Trend Topics ==================================================
# fieldByYear -> static ggplot (median year + IQR segments); df_graph table
# renamed to the biblioshiny column labels.
register_runner("trend_topics", function(M, params) {
  fr  <- .words_field(M, params$field, .ng(params))
  res <- bibliometrix::fieldByYear(fr$M, field = fr$tag, graph = FALSE)
  TAB <- res$df_graph |>
    dplyr::rename(Term = "item", Frequency = "freq",
                  `Year (Q1)` = "year_q1", `Year (Median)` = "year_med",
                  `Year (Q3)` = "year_q3") |>
    as.data.frame()
  list(.fig(res$graph), .tbl(TAB))
})
