# --- runners_authors.R ------------------------------------------------------
# Authors family: ANALYSIS > Authors > Authors panel (sections 3.3.1.*).
# Registers into the shared registry; helpers (.tbl/.fig/.hbar) come from
# runners.R, which is sourced first. No plotly, no tryCatch, no set.seed.
# Loaded packages available: bibliometrix, dplyr, ggplot2.

# === Authors family =========================================================

# 3.3.1.1 Author Profile -----------------------------------------------------
# In biblioshiny this page shows an interactive, per-author profile card whose
# GLOBAL tab is fetched live from OpenAlex (API + a selected author). Neither a
# selection nor network access exists in batch, so we emit only the LOCAL,
# corpus-aggregated profile across all authors. Hindex(field="author") already
# yields every column we need (Element->Author, NP->Articles, TC, h_index).
register_runner("author_profile", function(M, params) {
  H <- bibliometrix::Hindex(M, field = "author", elements = NULL, sep = ";", years = Inf)$H
  TAB <- data.frame(
    Author   = as.character(H$Element),
    Articles = H$NP,
    TC       = H$TC,
    h_index  = H$h_index,
    stringsAsFactors = FALSE
  )
  TAB <- TAB[order(-TAB$Articles, -TAB$TC), , drop = FALSE]
  list(.tbl(TAB))
})

# 3.3.1.2 Most Relevant Authors ----------------------------------------------
# measure: documents | documents_percent | fractionalized.
# documents/percent come from res$Authors (appearance counts); fractionalized
# from res$AuthorsFrac. Percent = appearances / N. documents * 100 (as biblioshiny).
register_runner("most_relevant_authors", function(M, params) {
  res <- bibliometrix::biblioAnalysis(M)
  if (identical(params$measure, "fractionalized")) {
    TAB <- as.data.frame(res$AuthorsFrac)            # Author, Frequency
    names(TAB) <- c("Authors", "Articles")
    TAB$Articles <- round(as.numeric(TAB$Articles), 2)
    xlab <- "N. of Documents (Fractionalized)"
  } else {
    TAB <- as.data.frame(res$Authors)                # AU, Freq
    names(TAB) <- c("Authors", "Articles")
    TAB$Articles <- as.numeric(TAB$Articles)
    if (identical(params$measure, "documents_percent")) {
      TAB$Articles <- round(TAB$Articles / nrow(M) * 100, 2)
      xlab <- "N. of Documents (in %)"
    } else if (identical(params$measure, "documents")) {
      xlab <- "N. of Documents"
    } else {
      stop(sprintf("unknown measure: %s", params$measure))
    }
  }
  TAB$Authors <- as.character(TAB$Authors)
  TAB <- TAB[order(-TAB$Articles), , drop = FALSE]
  list(.fig(.hbar(TAB, "Articles", "Authors", "Most Relevant Authors", xlab)),
       .tbl(TAB))
})

# 3.3.1.3 Most Local Cited Authors -------------------------------------------
# localCitations()$Authors -> data.frame(Author, LocalCitations), already
# sorted desc. fast.search=FALSE => exact LCS over the whole collection.
register_runner("most_local_cited_authors", function(M, params) {
  A <- bibliometrix::localCitations(M, fast.search = FALSE, sep = ";")$Authors
  A$Author <- as.character(A$Author)
  A <- A[order(-A$LocalCitations), , drop = FALSE]
  list(.fig(.hbar(A, "LocalCitations", "Author",
                  "Most Local Cited Authors", "Local Citations")),
       .tbl(A))
})

# 3.3.1.4 Authors' Production over Time --------------------------------------
# dfAU: Author (factor, top-k), year, freq, TC, TCpY. Plot = bubble/time chart
# (size=freq, color=TCpY, one line per author, flipped); table = dfAU.
register_runner("authors_production_over_time", function(M, params) {
  ap <- bibliometrix::authorProdOverTime(M, k = 10, graph = FALSE)
  d  <- ap$dfAU
  p <- ggplot2::ggplot(d, ggplot2::aes(x = Author, y = year)) +
    ggplot2::geom_line(ggplot2::aes(group = Author),
                       color = "firebrick4", alpha = 0.3, linewidth = 1) +
    ggplot2::geom_point(ggplot2::aes(size = freq, color = TCpY)) +
    ggplot2::scale_size(range = c(2, 6)) +
    ggplot2::scale_color_gradient(low = "#9ecae1", high = "#08306b") +
    ggplot2::coord_flip() +
    ggplot2::labs(title = "Authors' Production over Time",
                  x = "Author", y = "Year",
                  size = "N. Articles", color = "TC per Year") +
    ggplot2::theme_minimal(base_size = 12)
  list(.fig(p), .tbl(d))
})

# 3.3.1.5 Lotka's Law --------------------------------------------------------
# NOTE: in bibliometrix 5.4.1 lotka() takes M (a bibliometrixDB), NOT the
# biblioAnalysis() result; lotka(<biblioAnalysis output>) returns NA. We call
# lotka(M). g_shiny is the (logo-free) observed vs theoretical(beta=2) vs fitted
# ggplot; AuthorProd is the productivity frequency table.
register_runner("lotka_law", function(M, params) {
  L <- bibliometrix::lotka(M)
  list(.fig(L$g_shiny), .tbl(L$AuthorProd))
})

# 3.3.1.6 Authors' Local Impact ----------------------------------------------
# measure: h_index | g_index | m_index | total_citation (-> TC column of Hindex).
register_runner("authors_local_impact", function(M, params) {
  H   <- bibliometrix::Hindex(M, field = "author", elements = NULL, sep = ";", years = Inf)$H
  col <- switch(params$measure,
                h_index = "h_index", g_index = "g_index", m_index = "m_index",
                total_citation = "TC", stop("unknown measure"))
  H$Element <- as.character(H$Element)
  list(.fig(.hbar(H, col, "Element",
                  sprintf("Authors' Local Impact (%s)", params$measure), col)),
       .tbl(H[order(-H[[col]]), , drop = FALSE]))
})
