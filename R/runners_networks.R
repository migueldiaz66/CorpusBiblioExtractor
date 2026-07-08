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

# Load biblioshiny's OWN helper functions (igraph2vis, freqPlot, plot.ly, wordlist,
# plotLifeCycle, ValueBoxes, lifeCycleSummaryUI, cssTags, to_title_case, ...) from the
# INSTALLED bibliometrix, so the figures render with the exact biblioshiny code/style.
# They live in the private env `.BSHINY`. In a PACKAGE the sourcing must happen at LOAD
# time (runtime), NOT build time -> the empty env is created here and populated by
# `.load_bshiny()` called from `.onLoad()` (see zzz.R). The env's parent is globalenv();
# igraph2vis/freqPlot/plot.ly use bare %>%/mutate/ggplot/ggplotly, so dplyr, ggplot2 and
# plotly are in DESCRIPTION `Depends` (attached to the search path when the package loads).
.BSHINY <- new.env(parent = globalenv())
.load_bshiny <- function() {
  # utils.R: igraph2vis / plotLifeCycle / ValueBoxes / wordlist / freqPlot / plot.ly ...
  # lifeCycleUI.R: lifeCycleSummaryUI (Life Cycle Summary cards).
  # cssTags.R: cssTags() = el CSS global REAL de biblioshiny (del que toman clases las cards).
  # biblioAI.R: to_title_case() (usada por authorCard / Author Profile).
  # biblioShot.R: biblioShot() = screenshot plotly->PNG (colores solidos) que usan
  #   plotlySankey2png / los snapshots de word_map (factorial) y map (thematic_evolution);
  #   utils.R lo LLAMA pero no lo define -> hay que sourcearlo tambien.
  for (fn in c("utils.R", "lifeCycleUI.R", "cssTags.R", "biblioAI.R", "biblioShot.R")) {
    f <- file.path(system.file("biblioshiny", package = "bibliometrix"), fn)
    if (nzchar(f) && file.exists(f)) try(sys.source(f, envir = .BSHINY), silent = TRUE)
  }
  # biblioShot() llama default_chromote_object() BARE (chromote); se inyecta en .BSHINY
  # para que resuelva sin tener que attachar chromote a la search path.
  if (requireNamespace("chromote", quietly = TRUE))
    assign("default_chromote_object", chromote::default_chromote_object, envir = .BSHINY)
}

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

# --- biblioshiny-parity helpers (co-occurrence / collaboration) -------------
# Resolve a UI default from params$ui (keyed by inputId) with a fallback.
.uival <- function(ui, id, d) { v <- ui[[id]]; if (is.null(v)) d else v }
# "Yes"/"yes" -> TRUE (biblioshiny stores toggles as Yes/No or yes/no strings).
.yn    <- function(x) identical(as.character(x), "Yes") || identical(as.character(x), "yes")

# Run networkPlot with resolved options (mirroring server.R) + render with
# biblioshiny's own igraph2vis (fallback visIgraph); returns the 4 std assets.
# `opt`: normalize, layout, cluster, repulsion(already /2), isolates, edges_min,
# alpha, label_n, label_cex, labelsize, shape, edgesize, curved, shadow, noOverlap.
# seed left at networkPlot default (123) for determinism (biblioshiny uses a
# per-session seed for co-occurrence, so exact layout parity there is by-design
# impossible; content/clusters still match). igraph2vis edgesize left at its
# default 5 (server.R passes it only for co-occurrence, whose default is also 5).
.net_render <- function(NetMatrix, opt) {
  net <- bibliometrix::networkPlot(
    NetMatrix, normalize = opt$normalize, Title = "", type = opt$layout,
    size.cex = TRUE, size = 5, remove.multiple = FALSE, edgesize = opt$edgesize * 3,
    labelsize = opt$labelsize, label.cex = opt$label_cex, curved = opt$curved,
    label.n = opt$label_n, edges.min = opt$edges_min, label.color = FALSE,
    remove.isolates = opt$isolates, alpha = opt$alpha, cluster = opt$cluster,
    community.repulsion = opt$repulsion,
    seed = if (is.null(opt$seed)) 123L else as.integer(opt$seed), verbose = FALSE)
  ig2v <- tryCatch(get("igraph2vis", envir = .BSHINY), error = function(e) NULL)
  vis  <- tryCatch(
    if (is.function(ig2v))
      ig2v(g = net$graph, curved = opt$curved, labelsize = opt$labelsize, opacity = opt$alpha,
           type = opt$layout, shape = opt$shape, net = net, shadow = opt$shadow,
           noOverlap = opt$noOverlap)$VIS
    else visNetwork::visIgraph(net$graph),
    error = function(e) visNetwork::visIgraph(net$graph))
  list(
    list(id = "network_html", type = "network_html", filename = "network.html", object = vis),
    list(id = "network_net",  type = "network_net",  filename = "network.net",  object = net$graph),
    .tbl(.net_node_table(net),  file = "table.xlsx",      id = "table"),
    .fig(.net_degree_plot(net), file = "degree_plot.png", id = "degree_plot"))
}

# === Co-occurrence Network (4.1.1.1) ========================================
# biblioshiny-faithful: applies Options defaults (params$ui, prefix `coc`/bare),
# incl. Normalization (default "association"); renders via igraph2vis.
register_runner("co_occurrence_network", function(M, params) {
  field  <- params$field
  ngrams <- if (!is.null(params$ngrams)) as.numeric(params$ngrams) else 1
  ui     <- if (is.null(params$ui)) list() else params$ui
  nn     <- as.integer(.uival(ui, "Nodes", .net_n(params)))
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

  norm <- .uival(ui, "normalize", "association"); if (identical(norm, "none")) norm <- NULL
  .net_render(NetMatrix, list(
    normalize = norm,
    layout    = .uival(ui, "layout", "auto"),
    cluster   = .uival(ui, "cocCluster", "louvain"),
    repulsion = as.numeric(.uival(ui, "coc.repulsion", 0.5)) / 2,
    isolates  = .yn(.uival(ui, "coc.isolates", "yes")),
    edges_min = as.numeric(.uival(ui, "edges.min", 2)),
    alpha     = as.numeric(.uival(ui, "cocAlpha", 0.7)),
    label_n   = min(as.integer(.uival(ui, "Labels", 1000)), nn),
    label_cex = .yn(.uival(ui, "label.cex", "Yes")),
    labelsize = as.numeric(.uival(ui, "labelsize", 3)),
    shape     = .uival(ui, "coc.shape", "dot"),
    edgesize  = as.numeric(.uival(ui, "edgesize", 5)),
    shadow    = .yn(.uival(ui, "coc.shadow", "Yes")),
    curved    = .yn(.uival(ui, "coc.curved", "No")),
    seed      = as.integer(.uival(ui, "random_seed", 1234)),  # biblioshiny co-occurrence networkPlot uses seed=random_seed (UI default 1234)
    noOverlap = isTRUE(as.logical(.uival(ui, "noOverlap", TRUE)))))
})

# === Co-citation Network (4.2.1) ============================================
# Faithful to biblioshiny server.R (co-citation block): applies the Options-panel
# defaults (plan.json section$options -> params$ui, keyed by inputId) to
# biblioNetwork + networkPlot, then renders with biblioshiny's own igraph2vis
# (exact layout/style; falls back to visIgraph if unavailable). Non-Option server.R
# constants (size=5, remove.multiple=FALSE, alpha=0.7, label.color=FALSE) and the
# server.R transforms (Repulsion/2, Edge Size*3, "yes"->TRUE) are replicated.
register_runner("co_citation_network", function(M, params) {
  network <- params$field                       # "references" | "authors" | "sources"
  if (network == "authors" && !("CR_AU" %in% names(M)))
    M <- bibliometrix::metaTagExtraction(M, Field = "CR_AU", sep = ";")
  if (network == "sources" && !("CR_SO" %in% names(M)))
    M <- bibliometrix::metaTagExtraction(M, Field = "CR_SO", sep = ";")

  ui  <- if (is.null(params$ui)) list() else params$ui
  val <- function(id, d) { v <- ui[[id]]; if (is.null(v)) d else v }

  n           <- as.integer(val("citNodes", .net_n(params)))
  label.n     <- as.integer(val("citLabels", 1000)); if (label.n > n) label.n <- n
  cit_sep     <- val("citSep", ";")
  shortlabel  <- identical(val("citShortlabel", "Yes"), "Yes")
  cit_layout  <- val("citlayout", "auto")
  cit_curved  <- identical(val("cocit.curved", "No"), "Yes")
  cit_labelsz <- as.numeric(val("citlabelsize", 2))
  cit_shape   <- val("cocit.shape", "dot")
  cit_shadow  <- identical(val("cocit.shadow", "Yes"), "Yes")
  cit_noover  <- isTRUE(as.logical(val("citNoOverlap", TRUE)))
  cit_labcex  <- identical(val("citlabel.cex", "Yes"), "Yes")
  cit_edgemin <- as.numeric(val("citedges.min", 2))
  cit_isol    <- identical(val("cit.isolates", "yes"), "yes")
  cit_edgesz  <- as.numeric(val("citedgesize", 2))
  cit_cluster <- val("cocitCluster", "louvain")
  cit_repul   <- as.numeric(val("cocit.repulsion", 0.5)) / 2        # server.R: /2

  NetRefs <- if (identical(network, "references"))
    bibliometrix::biblioNetwork(M, analysis = "co-citation", network = "references",
                                n = n, sep = cit_sep, shortlabel = shortlabel)
  else
    bibliometrix::biblioNetwork(M, analysis = "co-citation", network = network,
                                n = n, sep = cit_sep)

  net <- bibliometrix::networkPlot(
    NetRefs, normalize = NULL, Title = "", type = cit_layout,
    size.cex = TRUE, size = 5, remove.multiple = FALSE, edgesize = cit_edgesz * 3,  # server.R: *3
    labelsize = cit_labelsz, label.cex = cit_labcex, curved = cit_curved,
    label.n = label.n, edges.min = cit_edgemin, label.color = FALSE,
    remove.isolates = cit_isol, alpha = 0.7, cluster = cit_cluster,
    community.repulsion = cit_repul, verbose = FALSE)

  # Render with biblioshiny's own igraph2vis for exact parity; fallback to visIgraph.
  ig2v <- tryCatch(get("igraph2vis", envir = .BSHINY), error = function(e) NULL)
  vis  <- tryCatch(
    if (is.function(ig2v))
      ig2v(g = net$graph, curved = cit_curved, labelsize = cit_labelsz, opacity = 0.7,
           type = cit_layout, shape = cit_shape, net = net, shadow = cit_shadow,
           noOverlap = cit_noover)$VIS      # igraph2vis returns list(VIS=<widget>, ...)
    else visNetwork::visIgraph(net$graph),
    error = function(e) visNetwork::visIgraph(net$graph))

  list(
    list(id = "network_html", type = "network_html", filename = "network.html", object = vis),
    list(id = "network_net",  type = "network_net",  filename = "network.net",  object = net$graph),
    .tbl(.net_node_table(net),  file = "table.xlsx",      id = "table"),
    .fig(.net_degree_plot(net), file = "degree_plot.png", id = "degree_plot"))
})

# === Collaboration Network (4.3.1) ==========================================
# biblioshiny-faithful: applies Options defaults (params$ui, prefix `col`; note
# Edit Nodes inputId is `soc.curved`, and edges.min default is 1); Normalization
# default "association"; optional filter of articles with >20 authors (default
# off); renders via igraph2vis.
register_runner("collaboration_network", function(M, params) {
  network <- params$field                       # "authors" | "universities" | "countries"
  if (network == "universities" && !("AU_UN" %in% names(M)))
    M <- bibliometrix::metaTagExtraction(M, Field = "AU_UN", sep = ";")
  if (network == "countries" && !("AU_CO" %in% names(M)))
    M <- bibliometrix::metaTagExtraction(M, Field = "AU_CO", sep = ";")

  ui <- if (is.null(params$ui)) list() else params$ui
  if (identical(network, "authors") &&
      isTRUE(as.logical(.uival(ui, "col.filterMaxAuthors", FALSE))) && "nAU" %in% names(M))
    M <- M[M$nAU <= 20, , drop = FALSE]
  nn <- as.integer(.uival(ui, "colNodes", .net_n(params)))
  NetMatrix <- .bn(M, "collaboration", network, nn)

  norm <- .uival(ui, "colnormalize", "association"); if (identical(norm, "none")) norm <- NULL
  .net_render(NetMatrix, list(
    normalize = norm,
    layout    = .uival(ui, "collayout", "auto"),
    cluster   = .uival(ui, "colCluster", "louvain"),
    repulsion = as.numeric(.uival(ui, "col.repulsion", 0.5)) / 2,
    isolates  = .yn(.uival(ui, "col.isolates", "yes")),
    edges_min = as.numeric(.uival(ui, "coledges.min", 1)),
    alpha     = as.numeric(.uival(ui, "colAlpha", 0.7)),
    label_n   = min(as.integer(.uival(ui, "colLabels", 1000)), nn),
    label_cex = .yn(.uival(ui, "collabel.cex", "Yes")),
    labelsize = as.numeric(.uival(ui, "collabelsize", 2)),
    shape     = .uival(ui, "col.shape", "dot"),
    edgesize  = as.numeric(.uival(ui, "coledgesize", 5)),
    shadow    = .yn(.uival(ui, "col.shadow", "Yes")),
    curved    = .yn(.uival(ui, "soc.curved", "No")),
    noOverlap = isTRUE(as.logical(.uival(ui, "colNoOverlap", TRUE)))))
})
