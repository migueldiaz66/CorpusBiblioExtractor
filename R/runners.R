# --- runners.R --------------------------------------------------------------
# Shared runner helpers + the pilot runners (Sources family).
# Other families live in R/runners_*.R and register themselves too.
# Sourced before runners_*.R (alphabetical), so helpers below are available.

# Horizontal bar chart (mirrors biblioshiny freqPlot look) ------------------
.hbar <- function(df, value_col, label_col, title, xlab, n = 20L) {
  df <- as.data.frame(df)
  d  <- utils::head(df[order(-df[[value_col]]), , drop = FALSE], n)
  d[[label_col]] <- substr(as.character(d[[label_col]]), 1, 50)
  ggplot2::ggplot(d, ggplot2::aes(x = stats::reorder(.data[[label_col]], .data[[value_col]]),
                                  y = .data[[value_col]])) +
    ggplot2::geom_col(fill = "#4477AA") +
    ggplot2::geom_text(ggplot2::aes(label = .data[[value_col]]), hjust = -0.15, size = 3) +
    ggplot2::coord_flip() +
    ggplot2::labs(title = title, x = NULL, y = xlab) +
    ggplot2::theme_minimal(base_size = 12)
}

# Build network assets (HTML + Pajek .net) from an igraph object ------------
# Returns a list with two assets named "<base>.html" and "<base>.net".
.network_assets <- function(g, base = "network",
                            ids = c(html = "network_html", net = "network_net")) {
  out <- list()
  vis <- tryCatch(visNetwork::visIgraph(g), error = function(e) NULL)
  if (!is.null(vis))
    out[[length(out) + 1L]] <- list(id = ids[["html"]], type = "network_html",
                                    filename = paste0(base, ".html"), object = vis)
  out[[length(out) + 1L]] <- list(id = ids[["net"]], type = "network_net",
                                  filename = paste0(base, ".net"), object = g)
  out
}

# Convenience constructors ---------------------------------------------------
.tbl  <- function(df, file = "table.xlsx", id = "table") list(id = id, type = "table_xlsx",  filename = file, object = as.data.frame(df))
.fig  <- function(p,  file = "plot.png",  id = "plot")  list(id = id, type = "figure_png",  filename = file, object = p)

# === Sources family (pilot, validated) =====================================

register_runner("most_relevant_sources", function(M, params) {
  TAB <- M |>
    dplyr::group_by(SO) |>
    dplyr::count() |>
    dplyr::arrange(dplyr::desc(n)) |>
    dplyr::rename(Sources = SO, Articles = n) |>
    as.data.frame()
  TAB <- TAB[!is.na(TAB$Sources), , drop = FALSE]
  list(.fig(.hbar(TAB, "Articles", "Sources", "Most Relevant Sources", "N. of Documents")),
       .tbl(TAB))
})

register_runner("bradford", function(M, params) {
  b <- bibliometrix::bradford(M)
  list(.fig(b$graph), .tbl(b$table))
})

register_runner("sources_local_impact", function(M, params) {
  H   <- bibliometrix::Hindex(M, field = "source", elements = NULL, sep = ";", years = Inf)$H
  col <- switch(params$impact_measure,
                h_index = "h_index", g_index = "g_index", m_index = "m_index",
                total_citation = "TC", stop("unknown impact_measure"))
  list(.fig(.hbar(H, col, "Element", sprintf("Sources' Local Impact (%s)", params$impact_measure), col)),
       .tbl(H[order(-H[[col]]), , drop = FALSE]))
})
