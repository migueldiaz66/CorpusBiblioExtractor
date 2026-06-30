# --- runners_structure.R ----------------------------------------------------
# Conceptual & Intellectual Structure family (4_synthesis):
#   thematic_map · thematic_evolution · factorial_analysis · historiograph
#
# Loaded after runners.R (alphabetical), so the shared helpers are available:
#   .tbl(df, file, id)            -> table_xlsx asset (as.data.frame)
#   .fig(ggplot, file, id)        -> figure_png asset
#   .network_assets(igraph, base) -> list(network.html [visNetwork], network.net [igraph/pajek])
# Available libs: bibliometrix, dplyr, ggplot2. NO plotly. No tryCatch (driver
# wraps every runner). No set.seed (the driver seeds before each scenario).
#
# params CODES (named list of value codes for the scenario):
#   field    in {ID, DE, KW_Merged, TI, AB}
#   ngrams   in {1, 2, 3}             (may be absent -> default 1)
#   method   in {CA, MCA, MDS}
#   stemming in {TRUE, FALSE}         (may be absent -> default FALSE)

# Local helpers (param coercion) --------------------------------------------
.p_field    <- function(params) params$field
.p_ngrams   <- function(params) if (!is.null(params$ngrams)) as.integer(params$ngrams) else 1L
.p_stemming <- function(params) if (!is.null(params$stemming)) isTRUE(as.logical(params$stemming)) else FALSE

# Minimal ggplot "flow" figure for Thematic Evolution -----------------------
# plotThematicEvolution() returns a plotly *sankey* object, which the figure_png
# saver (ggsave) cannot handle and plotly is unavailable. We rebuild a minimal
# alluvial-style flow as a ggplot from the same nexus$Nodes / nexus$Edges that
# feed the sankey: nodes laid out in columns by time slice, edges drawn as
# segments whose width encodes the weighted inclusion index. Returns NULL when
# there is nothing to draw (degenerate corpus / single slice).
.te_flow_ggplot <- function(Nodes, Edges) {
  nd <- as.data.frame(Nodes)
  ed <- as.data.frame(Edges)
  if (nrow(nd) == 0 || nrow(ed) == 0) return(NULL)

  # x = time slice (factor labelled 1..K), y = rank order within the slice.
  nd$x <- as.integer(nd$slice)
  nd   <- nd[order(nd$x, nd$id), , drop = FALSE]
  nd$y <- stats::ave(seq_len(nrow(nd)), nd$x, FUN = seq_along)

  pos      <- data.frame(id = nd$id, x = nd$x, y = nd$y)
  ed$x     <- pos$x[match(ed$from, pos$id)]
  ed$y     <- pos$y[match(ed$from, pos$id)]
  ed$xend  <- pos$x[match(ed$to,   pos$id)]
  ed$yend  <- pos$y[match(ed$to,   pos$id)]
  ed       <- ed[!is.na(ed$x) & !is.na(ed$xend), , drop = FALSE]
  if (!"Inc_Weighted" %in% names(ed)) ed$Inc_Weighted <- 1

  nd$col   <- ifelse(is.na(nd$color), "#4477AA", nd$color)
  nd$freq2 <- ifelse(is.na(nd$freq), 1, as.numeric(nd$freq))

  xb  <- sort(unique(nd$x))
  xlb <- nd$group[match(xb, nd$x)]

  ggplot2::ggplot() +
    ggplot2::geom_segment(
      data = ed,
      ggplot2::aes(x = x, y = y, xend = xend, yend = yend, linewidth = Inc_Weighted),
      colour = "grey70", alpha = 0.6) +
    ggplot2::geom_point(
      data = nd, ggplot2::aes(x = x, y = y, size = freq2),
      colour = nd$col, alpha = 0.85) +
    ggplot2::geom_text(
      data = nd, ggplot2::aes(x = x, y = y, label = name),
      size = 3, vjust = -0.8) +
    ggplot2::scale_x_continuous(breaks = xb, labels = xlb) +
    ggplot2::scale_linewidth(range = c(0.3, 3)) +
    ggplot2::labs(title = "Thematic Evolution (flow)", x = NULL, y = NULL) +
    ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(legend.position = "none",
                   axis.text.y = ggplot2::element_blank(),
                   panel.grid.major.y = ggplot2::element_blank(),
                   panel.grid.minor.y = ggplot2::element_blank())
}

# === Thematic Map (4.1.1.2) =================================================
# thematicMap(): res$map (ggplot), res$words (terms+metrics), res$clusters
# (per-cluster centrality/density/freq), res$net$graph (igraph co-word net).
register_runner("thematic_map", function(M, params) {
  res <- bibliometrix::thematicMap(
    M, field = .p_field(params), n = 250, minfreq = 5,
    ngrams = .p_ngrams(params), stemming = .p_stemming(params), repel = TRUE)

  out <- list(
    .fig(res$map,      file = "map.png",      id = "map"),
    .tbl(res$words,    file = "table.xlsx",   id = "table"),
    .tbl(res$clusters, file = "clusters.xlsx", id = "clusters"))

  # Co-word network: include the 2 network assets only if the igraph exists.
  g <- res$net$graph
  if (inherits(g, "igraph")) out <- c(out, .network_assets(g, "network"))
  out
})

# === Thematic Evolution (4.1.1.3) ===========================================
# thematicEvolution(): single cut point at the median publication year -> 2
# time slices. nexus$Data = the flow/transition table; nexus$Nodes/$Edges feed
# the (plotly) sankey, which we replace with a minimal ggplot flow (.te_flow_ggplot).
register_runner("thematic_evolution", function(M, params) {
  cut   <- stats::median(as.numeric(M$PY), na.rm = TRUE)
  nexus <- bibliometrix::thematicEvolution(
    M, field = .p_field(params), years = cut, n = 250, minFreq = 2,
    ngrams = .p_ngrams(params))

  out <- list(.tbl(nexus$Data, file = "table.xlsx", id = "table"))

  # Native plotThematicEvolution() is a plotly Sankey -> saved as interactive HTML.
  sk <- bibliometrix::plotThematicEvolution(nexus$Nodes, nexus$Edges,
                                            measure = "inclusion", min.flow = 0)
  if (!is.null(sk))
    out <- c(list(list(id = "map", type = "plot_html", filename = "map.html", object = sk)), out)
  out
})

# === Factorial Analysis (4.1.2.1) ===========================================
# conceptualStructure(graph=FALSE): cs$graph_terms (ggplot word map),
# cs$km.res$data.clust (terms with Dim1/Dim2/clust, rownames = words),
# cs$docCoord (document coordinates; NULL for MDS).
# Table construction mirrors biblioshiny server.R (WData / CSData, l.11544-11582).
register_runner("factorial_analysis", function(M, params) {
  field  <- .p_field(params)
  ngrams <- .p_ngrams(params)
  maxT   <- if (!is.null(params$max_terms)) as.integer(params$max_terms) else 50L
  # Cap the term set to the top-N most frequent (biblioshiny "Number of Terms",
  # default 50). MCA/CA on the full free-text term set (esp. abstracts) is
  # otherwise intractable. Done via remove.terms = every term beyond the top-N.
  freq    <- bibliometrix::tableTag(M, Tag = field, ngrams = ngrams, sep = ";")
  rmterms <- if (length(freq) > maxT) names(freq)[(maxT + 1L):length(freq)] else NULL

  cs <- bibliometrix::conceptualStructure(
    M, field = field, method = params$method, minDegree = 2,
    clust = "auto", k.max = 8, stemming = FALSE, labelsize = 10,
    documents = 10, ngrams = ngrams, graph = FALSE, remove.terms = rmterms)

  # words_by_cluster: word + Dim1 + Dim2 + cluster (works for CA / MCA / MDS,
  # since km.res$data.clust always carries Dim1/Dim2/clust with word rownames).
  dc <- as.data.frame(cs$km.res$data.clust)
  words_tbl <- data.frame(
    word    = rownames(dc),
    Dim1    = round(dc$Dim1, 2),
    Dim2    = round(dc$Dim2, 2),
    cluster = dc$clust,
    row.names = NULL, stringsAsFactors = FALSE)

  # articles_by_cluster: cs$docCoord with the row names as a Documents column.
  # MDS does not compute document coordinates -> docCoord is NULL (empty table).
  if (is.null(cs$docCoord)) {
    art_tbl <- data.frame(
      Documents = character(0), dim1 = numeric(0),
      dim2 = numeric(0), contrib = numeric(0), stringsAsFactors = FALSE)
  } else {
    dco <- as.data.frame(cs$docCoord)
    art_tbl <- data.frame(Documents = rownames(dco), dco, row.names = NULL,
                          stringsAsFactors = FALSE)
    art_tbl$dim1    <- round(art_tbl$dim1, 2)
    art_tbl$dim2    <- round(art_tbl$dim2, 2)
    art_tbl$contrib <- round(art_tbl$contrib, 2)
  }

  list(
    .fig(cs$graph_terms, file = "word_map.png",            id = "word_map"),
    .tbl(words_tbl,      file = "words_by_cluster.xlsx",   id = "words_by_cluster"),
    .tbl(art_tbl,        file = "articles_by_cluster.xlsx", id = "articles_by_cluster"))
})

# === Historiograph (4.2.2) ==================================================
# histNetwork() builds the direct-citation network; histPlot() lays it out.
# NOTE: hp$g is a *ggplot* (the static historiograph), NOT igraph. The igraph
# object is hp$net (bsk.network) -> that is what feeds the network assets.
# Documents table = hp$graph.data (the docs actually in the plotted network:
# Label/Title/Author_Keywords/KeywordsPlus/DOI/Year/LCS/GCS).
register_runner("historiograph", function(M, params) {
  h  <- bibliometrix::histNetwork(M, min.citations = 1, sep = ";")
  hp <- bibliometrix::histPlot(h, n = 20, size = 5, labelsize = 4, verbose = FALSE)

  out <- list()
  g <- hp$net
  if (inherits(g, "igraph")) out <- c(out, .network_assets(g, "network"))

  tab <- if (!is.null(hp$graph.data)) hp$graph.data else h$histData
  out <- c(out, list(.tbl(tab, file = "table.xlsx", id = "table")))
  out
})
