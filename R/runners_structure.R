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

# dend2vis() (Topic Dendrogram del factorial, reusada de .BSHINY) llama funciones de
# visNetwork SIN calificar -> hay que ATTACHARLO (el driver solo carga bibliometrix/dplyr/
# ggplot2; los runners de red usan visNetwork:: calificado, por eso no estaba attached).
suppressWarnings(suppressMessages(library(visNetwork)))

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
  ui  <- if (is.null(params$ui)) list() else params$ui
  res <- bibliometrix::thematicMap(
    M, field   = .p_field(params),
    n          = as.integer(.uival(ui, "TMn", 250)),
    minfreq    = as.numeric(.uival(ui, "TMfreq", 5)),
    ngrams     = .p_ngrams(params),
    # PARIDAD EXACTA: biblioshiny pasa `stemming <- input$TMstemming` SIN convertir, o sea
    # el STRING crudo del selectInput ("TRUE"/"FALSE"). bibliometrix usa isTRUE(), que
    # rechaza el string -> el "Word Stemming" de biblioshiny NUNCA estemiza (Yes == No).
    # Se replica como string para que el extractor sea IDÉNTICO (decisión del usuario).
    stemming   = if (.p_stemming(params)) "TRUE" else "FALSE",
    size       = as.numeric(.uival(ui, "sizeTM", 0.3)),         # biblioshiny UI 0.3 (fn default 0.5)
    n.labels   = as.integer(.uival(ui, "TMn.labels", 3)),        # biblioshiny UI 3 (fn default 1)
    community.repulsion = as.numeric(.uival(ui, "TMrepulsion", 0.5)),  # NOT halved (unlike networkPlot)
    cluster    = .uival(ui, "TMCluster", "louvain"),
    alpha      = as.numeric(.uival(ui, "TMalpha", 0.5)),
    repel      = FALSE,                                          # biblioshiny hardcodes FALSE
    seed       = as.integer(.uival(ui, "random_seed", 1234)))

  out <- list(
    .fig(res$map,      file = "map.png",      id = "map"),
    .tbl(res$words,    file = "table.xlsx",   id = "table"),
    .tbl(res$clusters, file = "clusters.xlsx", id = "clusters"))

  # Co-word network -> render with biblioshiny's igraph2vis (its Network tab reuses
  # the co-occurrence graphical defaults: labelsize 3, opacity 0.7, layout auto,
  # shape dot; noOverlap from noOverlapTM). Fallback to visIgraph.
  g <- res$net$graph
  if (inherits(g, "igraph")) {
    ig2v <- tryCatch(get("igraph2vis", envir = .BSHINY), error = function(e) NULL)
    vis  <- tryCatch(
      if (is.function(ig2v))
        ig2v(g = g, curved = FALSE, labelsize = 3, opacity = 0.7, type = "auto",
             shape = "dot", net = res$net, shadow = TRUE,
             noOverlap = isTRUE(as.logical(.uival(ui, "noOverlapTM", TRUE))))$VIS
      else visNetwork::visIgraph(g),
      error = function(e) visNetwork::visIgraph(g))
    out <- c(out,
             list(list(id = "network_html", type = "network_html", filename = "network.html", object = vis),
                  list(id = "network_net",  type = "network_net",  filename = "network.net",  object = g)))
  }
  out
})

# === Thematic Evolution (4.1.1.3) ===========================================
# thematicEvolution(): single cut point at the median publication year -> 2
# time slices. nexus$Data = the flow/transition table; nexus$Nodes/$Edges feed
# the (plotly) sankey, which we replace with a minimal ggplot flow (.te_flow_ggplot).
register_runner("thematic_evolution", function(M, params) {
  ui  <- if (is.null(params$ui)) list() else params$ui
  cut <- stats::median(as.numeric(M$PY), na.rm = TRUE)      # numSlices=1 -> single median cut (biblioshiny default)
  nexus <- bibliometrix::thematicEvolution(
    M, field  = .p_field(params), years = cut,
    n         = as.integer(.uival(ui, "nTE", 250)),
    minFreq   = as.numeric(.uival(ui, "fTE", 5)),           # biblioshiny UI 5 (fn default is 2) -- material
    ngrams    = .p_ngrams(params),
    size      = as.numeric(.uival(ui, "sizeTE", 0.3)),
    n.labels  = as.integer(.uival(ui, "TEn.labels", 3)),
    cluster   = .uival(ui, "TECluster", "louvain"),
    repel     = FALSE,                                       # biblioshiny hardcodes FALSE
    seed      = as.integer(.uival(ui, "random_seed", 1234)),
    assign.evolution.colors = list(assign = TRUE, alpha = as.numeric(.uival(ui, "TEalpha", 0.5))))

  out <- list(.tbl(nexus$Data, file = "table.xlsx", id = "table"))

  # Sankey -> PNG replicando EXACTAMENTE el EXPORT de biblioshiny (server.R:12413-12433):
  #   export_nodes$color <- hex_to_rgba(color, alpha = 1)   # nodos opacos
  #   export_edges$color <- hex_to_rgba(color, alpha = 0.6) # edges a 0.6
  #   plotThematicEvolution(min.flow = 0)                   # todos los flujos
  #   plotlySankey2png(...)                                 # render Plotly.toImage (SÓLIDO)
  # El asset `sankey_png` usa la función REAL plotlySankey2png (savers.R, vía .BSHINY) -> los
  # colores salen sólidos (el webshot los dejaba pálidos). `hex_to_rgba` es local en server.R
  # (no exportada) -> se copia literal.
  hex_to_rgba <- function(hex_colors, alpha = 1) {
    vapply(as.character(hex_colors), function(h) {
      h <- sub("^#", "", h); if (nchar(h) == 8) h <- substr(h, 1, 6)
      sprintf("rgba(%d,%d,%d,%s)", strtoi(substr(h, 1, 2), 16L),
              strtoi(substr(h, 3, 4), 16L), strtoi(substr(h, 5, 6), 16L), alpha)
    }, character(1), USE.NAMES = FALSE)
  }
  nexus$Nodes$color <- hex_to_rgba(nexus$Nodes$color, alpha = 1)
  nexus$Edges$color <- hex_to_rgba(nexus$Edges$color, alpha = 0.6)
  # min.flow = minFlowTE (0.1, el on-screen que compara el usuario) en vez del 0 del export,
  # para el mismo set de nodos que biblioshiny en pantalla; el render sólido lo da plotlySankey2png.
  sk <- bibliometrix::plotThematicEvolution(nexus$Nodes, nexus$Edges,
                                            min.flow = as.numeric(.uival(ui, "minFlowTE", 0.1)))
  if (!is.null(sk))
    out <- c(list(list(id = "map", type = "sankey_png", filename = "map.png", object = sk)), out)
  out
})

# === Factorial Analysis (4.1.2.1) ===========================================
# conceptualStructure(graph=FALSE): cs$graph_terms (ggplot word map),
# cs$km.res$data.clust (terms with Dim1/Dim2/clust, rownames = words),
# cs$docCoord (document coordinates; NULL for MDS).
# Table construction mirrors biblioshiny server.R (WData / CSData, l.11544-11582).
register_runner("factorial_analysis", function(M, params) {
  ui     <- if (is.null(params$ui)) list() else params$ui
  field  <- .p_field(params)
  ngrams <- .p_ngrams(params)

  # PARIDAD EXACTA con server.R (handler input$applyCA, l.11522-11536):
  #  - minDegree NO es un cap por nombre: biblioshiny fija un UMBRAL DE OCURRENCIA =
  #    frecuencia del término #CSn ("Number of Terms", default 50) en tableTag; luego
  #    conceptualStructure conserva los términos con freq >= ese umbral (~top-50, más
  #    empates). Eso además mantiene tratable el MCA/CA sobre texto libre (abstracts).
  #  - remove.terms se queda en NULL (biblioshiny solo lo usa si subes un stopword file).
  #  - clust: el dropdown "N. of Clusters" solo ofrece 1..8 (NO existe "auto"); default "1"
  #    -> con 1 cluster no hay kmeans aleatorio, el mapa es 100% determinista y calza con
  #    biblioshiny aunque este NO siembre. (Para k>1 biblioshiny no siembra -> sin match
  #    bit-a-bit por construcción; el extractor sí es reproducible vía el seed del driver.)
  #  - labelsize = CSlabelsize/2 (=5); documents = CSdoc (=5); k.max=8 y stemming=FALSE hardcoded.
  cs_n <- as.integer(.uival(ui, "CSn", 50))
  tab  <- bibliometrix::tableTag(M, Tag = field, ngrams = ngrams)
  cs_n <- min(cs_n, length(tab))                       # guard: corpus con < CSn términos
  minDegree <- as.numeric(tab[cs_n])

  cs <- bibliometrix::conceptualStructure(
    M, method = params$method, field = field, ngrams = ngrams,
    minDegree = minDegree,
    clust     = .uival(ui, "nClustersCS", "1"),
    k.max     = 8, stemming = FALSE,
    labelsize = as.numeric(.uival(ui, "CSlabelsize", 10)) / 2,
    documents = as.integer(.uival(ui, "CSdoc", 5)),
    graph = FALSE, remove.terms = NULL, synonyms = NULL)

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

  # Word Map = ca2plotly() (biblioshiny on-screen, output$CSPlot1, server.R:11584): plotly de
  # PUNTOS, SIN casco convexo ni logo — a diferencia de cs$graph_terms (el ggplot de EXPORT,
  # que dibuja el polígono que notó el usuario). Requiere el post-proceso de biblioshiny que
  # agrega CS$WData (server.R:11554-11582). Se renderiza con plotlySankey2png (Plotly.toImage)
  # vía el asset `sankey_png`. Fallback al ggplot si ca2plotly falla.
  if (identical(params$method, "MDS")) {
    WData <- data.frame(word = row.names(cs$res), cs$res, cluster = cs$km.res$cluster,
                        stringsAsFactors = FALSE)
  } else {
    WData <- data.frame(word = row.names(cs$km.res$data.clust), cs$km.res$data.clust,
                        stringsAsFactors = FALSE)
    names(WData)[4] <- "cluster"
  }
  WData$Dim1 <- round(WData$Dim1, 2); WData$Dim2 <- round(WData$Dim2, 2)
  cs$WData <- WData
  ca2p <- tryCatch(get("ca2plotly", envir = .BSHINY), error = function(e) NULL)
  csl  <- as.numeric(.uival(ui, "CSlabelsize", 10))
  plotCS <- if (is.function(ca2p))
    tryCatch(ca2p(cs, method = params$method, dimX = 1, dimY = 2, topWordPlot = Inf,
                  threshold = 0.05, labelsize = csl * 2, size = csl * 1.5),
             error = function(e) NULL) else NULL
  word_map_asset <- if (!is.null(plotCS))
    list(id = "word_map", type = "sankey_png", filename = "word_map.png", object = plotCS)
  else
    .fig(cs$graph_terms, file = "word_map.png", id = "word_map")   # fallback ggplot

  # Topic Dendrogram = dend2vis() (biblioshiny on-screen, output$CSPlot4, server.R:11594/11661):
  # visNetwork del clustering jerárquico de términos. Se reusa dend2vis de .BSHINY con los args de
  # biblioshiny (labelsize=CSlabelsize, nclusters=nClustersCS, community=FALSE) -> PNG vía vis_png.
  d2v  <- tryCatch(get("dend2vis", envir = .BSHINY), error = function(e) NULL)
  dend <- if (is.function(d2v))
    tryCatch(d2v(cs$km.res, labelsize = csl,
                 nclusters = as.numeric(.uival(ui, "nClustersCS", "1")), community = FALSE),
             error = function(e) NULL) else NULL
  dend_asset <- if (!is.null(dend))
    list(list(id = "topic_dendrogram", type = "vis_png", filename = "topic_dendrogram.png", object = dend))
  else list()

  c(list(word_map_asset), dend_asset,
    list(.tbl(words_tbl, file = "words_by_cluster.xlsx",    id = "words_by_cluster"),
         .tbl(art_tbl,   file = "articles_by_cluster.xlsx", id = "articles_by_cluster")))
})

# === Historiograph (4.2.2) ==================================================
# PARIDAD con biblioshiny (server.R:13360-13434): render con la función REAL hist2vis()
# (output$histPlotVis) = visNetwork con clusters de color + aristas curvas + Node Label,
# NO el visIgraph genérico. Params de biblioshiny: histNetwork(min.citations=0),
# histData rownames_to_column("SR"), histPlot(n=histNodes 20, size=histsize 2,
# remove.isolates=(hist.isolates=="yes"), labelsize=histlabelsize 3, label=titlelabel),
# hist2vis(curved=TRUE, opacity=0.7, shape="dot", labeltype=titlelabel, timeline=FALSE)$VIS.
# Node Label (titlelabel) = escenario: short (1er autor+año, default) / title / keywords /
# keywordsplus. Se renderiza a PNG con vis_png (como el Topic Dendrogram).
register_runner("historiograph", function(M, params) {
  ui  <- if (is.null(params$ui)) list() else params$ui
  lab <- if (is.null(params$node_label)) "short" else params$node_label
  h   <- bibliometrix::histNetwork(M, min.citations = 0, sep = ";")
  h$histData <- tibble::rownames_to_column(h$histData, var = "SR")
  hp  <- bibliometrix::histPlot(h,
    n               = as.integer(.uival(ui, "histNodes", 20)),
    size            = as.numeric(.uival(ui, "histsize", 2)),
    remove.isolates = identical(.uival(ui, "hist.isolates", "yes"), "yes"),
    labelsize       = as.numeric(.uival(ui, "histlabelsize", 3)),
    label           = lab, verbose = FALSE)

  h2v <- tryCatch(get("hist2vis", envir = .BSHINY), error = function(e) NULL)
  vis <- if (is.function(h2v))
    tryCatch(h2v(hp, curved = TRUE, labelsize = as.numeric(.uival(ui, "histlabelsize", 3)),
                 nodesize = as.numeric(.uival(ui, "histsize", 2)), opacity = 0.7,
                 shape = "dot", labeltype = lab, timeline = FALSE)$VIS,
             error = function(e) NULL) else NULL

  out <- list()
  if (!is.null(vis))
    out <- c(out, list(list(id = "network", type = "vis_png", filename = "network.png", object = vis)))
  else if (inherits(hp$net, "igraph"))
    out <- c(out, .network_assets(hp$net, "network"))           # fallback visIgraph
  if (inherits(hp$net, "igraph"))
    out <- c(out, list(list(id = "network_net", type = "network_net", filename = "network.net", object = hp$net)))
  tab <- if (!is.null(hp$graph.data)) hp$graph.data else h$histData
  c(out, list(.tbl(tab, file = "table.xlsx", id = "table")))
})
