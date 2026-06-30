# --- runners_networks.R -----------------------------------------------------
# Mapping / science-structure networks (4_synthesis):
#   co_occurrence_network (4.1.1.1) · co_citation_network (4.2.1) ·
#   collaboration_network (4.3.1)
#
# Loaded after runners.R (alphabetical), so the shared helpers are available:
#   .tbl(df, file, id)            -> table_xlsx asset (as.data.frame)
#   .fig(ggplot, file, id)        -> figure_png asset
#   .network_assets(igraph, base) -> list(network.html [visNetwork], network.net [igraph/pajek])
# Available libs: bibliometrix, dplyr, ggplot2. NO plotly. No tryCatch (driver
# wraps every runner). No set.seed (the driver seeds before each scenario).
#
# Every section here produces the SAME 4 assets (see each tab's tabs.md):
#   network.html (Network tab)  · network.net (Pajek)
#   table.xlsx   (Table tab)     · degree_plot.png (Degree Plot tab)
#
# Pipeline (mirrors biblioshiny server.R conceptually):
#   biblioNetwork(M, analysis=<section>, network=<field>, sep=";")  -> NetMatrix
#   networkPlot(NetMatrix, n=50, type="auto", cluster="louvain", ...) -> net
#   net$graph (igraph) -> .network_assets ; net$cluster_res -> table ;
#   net$nodeDegree     -> degree plot.
#
# ---------------------------------------------------------------------------
# FIELD -> biblioNetwork(network=) MAPPING  (verified in server.R)
#
# co_occurrence_network (params$field is a CODE; ngrams only for TI/AB):
#   ID        -> analysis="co-occurrences", network="keywords"         (Keywords Plus)
#   DE        -> analysis="co-occurrences", network="author_keywords"  (Author Keywords)
#   KW_Merged -> analysis="co-occurrences", network="all_keywords"     (merged ID+DE;
#                cocMatrix() builds KW_Merged on the fly via mergeKeywords())
#   TI        -> termExtraction(Field="TI", ngrams) FIRST, then network="titles"
#   AB        -> termExtraction(Field="AB", ngrams) FIRST, then network="abstracts"
#   WC        -> NOT a valid biblioNetwork co-occurrence network. biblioshiny builds
#                the Subject-Categories network directly with
#                cocMatrix(Field="WC", binary=FALSE) then crossprod() -> we do the same,
#                but prefer "WC" and fall back to "SC": convert2df(format="bibtex")
#                stores WoS categories in SC (the WC tag exists only for plaintext WoS
#                imports), and our corpus is bibtex-derived. (closest valid value.)
#   NOTE: the task brief suggested KW_Merged->"keywords" and WC->"sources"; we instead
#   follow the authoritative server.R mapping (all_keywords / cocMatrix-WC), which is
#   the correct, biblioshiny-faithful behaviour.
#
# co_citation_network (params$field already IS the network arg):
#   references -> network="references" (uses CR, always present)
#   authors    -> network="authors"    (needs CR_AU -> metaTagExtraction if missing)
#   sources    -> network="sources"    (needs CR_SO -> metaTagExtraction if missing)
#
# collaboration_network (params$field already IS the network arg):
#   authors      -> network="authors"      (uses AU, always present)
#   universities -> network="universities" (needs AU_UN -> metaTagExtraction if missing)
#   countries    -> network="countries"    (needs AU_CO -> metaTagExtraction if missing)
# ---------------------------------------------------------------------------

# networkPlot "Number of Nodes" cap (biblioshiny default-ish; per the task brief).
.NET_N <- 50L

# Resolve the node cap for a scenario (plan.json section$compute$n, else .NET_N).
.net_n <- function(params) if (!is.null(params$n)) as.integer(params$n) else .NET_N

# biblioNetwork with the node cap applied BEFORE the (heavy) crossprod, so the
# co-occurrence/co-citation matrix is at most n x n. CRITICAL for co-citation of
# references (otherwise O(refs^2) on the full reference set hangs at scale).
.bn <- function(M, analysis, network, n) bibliometrix::biblioNetwork(
  M, analysis = analysis, network = network, n = n, sep = ";")

# Run networkPlot with the standard config; returns the `net` list (incl. $graph).
# verbose=FALSE: suppress the base-graphics side plot + messages in the headless run
# (server.R also calls networkPlot with verbose=FALSE).
.net_plot <- function(NetMatrix) {
  bibliometrix::networkPlot(
    NetMatrix, n = .NET_N, type = "auto", cluster = "louvain",
    Title = "", labelsize = 1, verbose = FALSE)
}

# Node-metrics table -> Node/Cluster/Betweenness/Closeness/PageRank (per tabs.md).
# Prefer networkPlot's $cluster_res (vertex/cluster/btw/clos/pagerank, already in the
# corpus order). Fall back to computing from the igraph if cluster_res is not a df.
.net_node_table <- function(net) {
  cr <- net$cluster_res
  if (is.data.frame(cr)) {
    return(data.frame(
      Node        = as.character(cr$vertex),
      Cluster     = cr$cluster,
      Betweenness = round(as.numeric(cr$btw_centrality), 3),
      Closeness   = round(as.numeric(cr$clos_centrality), 3),
      PageRank    = round(as.numeric(cr$pagerank_centrality), 3),
      row.names = NULL, stringsAsFactors = FALSE))
  }
  g  <- net$graph
  cl <- igraph::V(g)$community
  if (is.null(cl))
    cl <- igraph::membership(igraph::cluster_louvain(igraph::as.undirected(g)))
  df <- data.frame(
    Node        = igraph::V(g)$name,
    Cluster     = as.integer(cl),
    Betweenness = round(igraph::betweenness(g, directed = FALSE, normalized = FALSE), 3),
    Closeness   = round(suppressWarnings(igraph::closeness(g)), 3),
    PageRank    = round(igraph::page_rank(g)$vector, 3),
    row.names = NULL, stringsAsFactors = FALSE)
  df[order(df$Cluster), , drop = FALSE]
}

# Degree plot: nodes ordered by (normalized) degree, mirrors biblioshiny degreePlot().
# net$nodeDegree is data.frame(node, degree), already arrange(desc(degree)) + scaled.
.net_degree_plot <- function(net) {
  deg <- net$nodeDegree
  if (is.null(deg)) {
    d   <- igraph::degree(net$graph, mode = "all")
    deg <- data.frame(node = igraph::V(net$graph)$name, degree = d)
    deg <- deg[order(-deg$degree), , drop = FALSE]
  }
  deg$x <- seq_len(nrow(deg))
  ggplot2::ggplot(deg, ggplot2::aes(x = .data$x, y = .data$degree)) +
    ggplot2::geom_line(colour = "#002F80", alpha = 0.5) +
    ggplot2::geom_point() +
    ggplot2::labs(title = "Node Degrees", x = "Node", y = "Cumulative Degree") +
    ggplot2::theme_minimal(base_size = 12)
}

# The 4 standard assets shared by every node-and-edge network section.
.net_section_assets <- function(net) {
  c(.network_assets(net$graph, base = "network"),
    list(.tbl(.net_node_table(net),  file = "table.xlsx",      id = "table"),
         .fig(.net_degree_plot(net), file = "degree_plot.png", id = "degree_plot")))
}

# === Co-occurrence Network (4.1.1.1) ========================================
register_runner("co_occurrence_network", function(M, params) {
  field  <- params$field
  ngrams <- if (!is.null(params$ngrams)) as.numeric(params$ngrams) else 1
  nn     <- .net_n(params)
  NetMatrix <- switch(field,
    ID        = .bn(M, "co-occurrences", "keywords",        nn),
    DE        = .bn(M, "co-occurrences", "author_keywords", nn),
    KW_Merged = .bn(M, "co-occurrences", "all_keywords",    nn),
    TI        = .bn(bibliometrix::termExtraction(M, Field = "TI", ngrams = ngrams, verbose = FALSE),
                    "co-occurrences", "titles", nn),
    AB        = .bn(bibliometrix::termExtraction(M, Field = "AB", ngrams = ngrams, verbose = FALSE),
                    "co-occurrences", "abstracts", nn),
    WC        = { catfield <- if ("WC" %in% names(M)) "WC"          # WoS plaintext import
                              else if ("SC" %in% names(M)) "SC"     # WoS bibtex import (our case)
                              else stop("co_occurrence_network: no subject-category column (WC/SC)")
                  WSC <- bibliometrix::cocMatrix(M, Field = catfield, n = nn, binary = FALSE)
                  Matrix::crossprod(WSC, WSC) },
    stop(sprintf("co_occurrence_network: unknown field code '%s'", field)))

  .net_section_assets(.net_plot(NetMatrix))
})

# === Co-citation Network (4.2.1) ============================================
register_runner("co_citation_network", function(M, params) {
  network <- params$field                       # "references" | "authors" | "sources"
  if (network == "authors" && !("CR_AU" %in% names(M)))
    M <- bibliometrix::metaTagExtraction(M, Field = "CR_AU", sep = ";")
  if (network == "sources" && !("CR_SO" %in% names(M)))
    M <- bibliometrix::metaTagExtraction(M, Field = "CR_SO", sep = ";")

  NetMatrix <- .bn(M, "co-citation", network, .net_n(params))
  .net_section_assets(.net_plot(NetMatrix))
})

# === Collaboration Network (4.3.1) ==========================================
register_runner("collaboration_network", function(M, params) {
  network <- params$field                       # "authors" | "universities" | "countries"
  if (network == "universities" && !("AU_UN" %in% names(M)))
    M <- bibliometrix::metaTagExtraction(M, Field = "AU_UN", sep = ";")
  if (network == "countries" && !("AU_CO" %in% names(M)))
    M <- bibliometrix::metaTagExtraction(M, Field = "AU_CO", sep = ";")

  NetMatrix <- .bn(M, "collaboration", network, .net_n(params))
  .net_section_assets(.net_plot(NetMatrix))
})
