# --- runners_geo.R ----------------------------------------------------------
# Geographic / affiliation / country family of Phase-3 runners.
# Sources, Affiliations, Countries (ANALYSIS) + Countries' Collaboration World
# Map (SYNTHESIS). Registers itself via register_runner(); sourced after
# runners.R so the shared helpers (.tbl/.fig/.hbar) are available.
#
# Loaded by run_exhaustive.R: bibliometrix, dplyr, ggplot2 (+ openxlsx/jsonlite).
# Contract: register_runner("<name>", function(M, params){ list(<assets>) }).
# No plotly, no tryCatch, no set.seed here.

# --- local helpers ----------------------------------------------------------

# Normalize country names to match ggplot2::map_data("world") regions
# (replicates inst/biblioshiny/utils.R::mapworld()). Input already partly
# normalized by metaTagExtraction()'s AU_CO(); we finish the job (notably
# UNITED KINGDOM -> UK and KOREA -> SOUTH KOREA, which AU_CO does not do).
.norm_country <- function(x) {
  x <- toupper(trimws(as.character(x)))
  x <- gsub("[[:digit:]]", "", x)
  x <- gsub(".", "", x, fixed = TRUE)
  x <- gsub(";;", ";", x, fixed = TRUE)
  x <- gsub("UNITED STATES", "USA", x)
  x <- gsub("RUSSIAN FEDERATION", "RUSSIA", x)
  x <- gsub("TAIWAN", "CHINA", x)
  x <- gsub("ENGLAND", "UNITED KINGDOM", x)
  x <- gsub("SCOTLAND", "UNITED KINGDOM", x)
  x <- gsub("WALES", "UNITED KINGDOM", x)
  x <- gsub("NORTH IRELAND", "UNITED KINGDOM", x)
  x <- gsub("UNITED KINGDOM", "UK", x)
  x <- gsub("KOREA", "SOUTH KOREA", x)
  trimws(x)
}

# Cumulative production-over-time table for a ";"-separated multivalue field
# (e.g. AU_UN, AU_CO) crossed with PY. Returns long df: <label>, Year, Articles
# (cumulative document count up to each year) for the top-K elements.
.over_time <- function(M, field, label, top = 5L) {
  PY    <- suppressWarnings(as.numeric(M$PY))
  years <- seq.int(min(PY, na.rm = TRUE), max(PY, na.rm = TRUE))
  sv    <- strsplit(as.character(M[[field]]), ";")
  sv    <- lapply(sv, function(z) { z <- trimws(z); unique(z[!is.na(z) & nchar(z) > 0]) })

  freq <- sort(table(unlist(sv)), decreasing = TRUE)
  topn <- names(freq)[seq_len(min(top, length(freq)))]

  rows <- lapply(topn, function(el) {
    yr  <- PY[vapply(sv, function(z) el %in% z, logical(1))]
    cnt <- vapply(years, function(y) sum(yr == y, na.rm = TRUE), integer(1))
    data.frame(El = el, Year = years, Articles = cumsum(cnt), stringsAsFactors = FALSE)
  })
  df <- do.call(rbind, rows)
  names(df)[1] <- label
  df
}

# Multi-series line chart (production over time). `group` = colour/legend column.
.lines <- function(df, group, title, ylab) {
  # Eje X EXACTO de biblioshiny para los plots "...over Time" (server.R:6763 y 10275):
  #   breaks = Year[seq(1, length(Year), by = ceiling(length(Year)/20))]
  # es decir, una-de-cada-`ceiling(N/20)` POSICIONES del vector de años (apunta a <=20
  # etiquetas; N = nº de años del vector, ya relleno/contiguo por sourceGrowth y por
  # .over_time -> seq.int(min,max)). Verticales (axis.text.x angle=90, l.6796/10308).
  yrs  <- sort(unique(df$Year[is.finite(df$Year)]))
  N    <- length(yrs)
  step <- max(1L, ceiling(N / 20L))
  brks <- yrs[seq(1L, N, by = step)]
  ggplot2::ggplot(df, ggplot2::aes(x = .data$Year, y = .data$Articles,
                                   colour = .data[[group]], group = .data[[group]])) +
    ggplot2::geom_line(linewidth = 0.8) +
    ggplot2::scale_x_continuous(breaks = brks) +
    ggplot2::labs(title = title, x = "Year", y = ylab, colour = group) +
    ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90, hjust = 1, vjust = 0.5))
}

# ===========================================================================
# 1) Most Local Cited Sources  (3.2.2)
#    Cited sources within the collection: metaTagExtraction(CR_SO) + tableTag,
#    exactly as biblioshiny's values$TABSoCit. (citations(field="source") does
#    not exist in bibliometrix; CR_SO/tableTag is the real source of truth.)
# ===========================================================================
register_runner("most_local_cited_sources", function(M, params) {
  # Datos VERBATIM del handler MLCSources (server.R:6292-6294): metaTagExtraction(CR_SO) ->
  # tableTag(CR_SO) -> data.frame(Sources=names, Articles=as.numeric). biblioshiny NO filtra.
  MM  <- bibliometrix::metaTagExtraction(M, "CR_SO")
  tab <- bibliometrix::tableTag(MM, "CR_SO")
  TAB <- data.frame(Sources = names(tab), Articles = as.numeric(tab), stringsAsFactors = FALSE)
  # Lollipop = freqPlot(xx, x=2, y=1, textLaby="Cited Sources", textLabx="N. of Local Citations",
  # title="Most Local Cited Sources", values) con substr(Sources,1,50) (server.R:6304-6314);
  # render plot.ly (6341, aspectratio inerte). k=MostRelCitSourcesK=10 (ui.R:3197). La barra es
  # el EXTRA del usuario (biblioshiny no la tiene). Tabla = values$TABSoCit (=TAB).
  c(.rank_figs(TAB, "Articles", "Sources", "Most Local Cited Sources", "N. of Local Citations",
               M, label_max = 50, textLaby = "Cited Sources"),
    list(.tbl(TAB)))
})

# ===========================================================================
# 2) Sources' Production over Time  (3.2.5)  ·  params$occurrences {cumulate, per_year}
# VERBATIM del handler SOGrowth (server.R:6688-6811) + render soGrowthPlot (6832-6866).
# Defaults ui.R: cumSO="Cum" (3545) -> occurrences=cumulate; topSO=c(1,5) (3557) -> top 5.
# ===========================================================================
register_runner("sources_production_over_time", function(M, params) {
  suppressMessages(library(plotly))   # layout/config/%>% del render on-screen
  occ <- if (is.null(params$occurrences)) "cumulate" else params$occurrences
  if (identical(occ, "cumulate")) { cdf <- TRUE;  laby <- "Cumulate occurrences" }
  else                            { cdf <- FALSE; laby <- "Annual occurrences"  }

  # --- datos VERBATIM (server.R:6697-6711) ---
  topSO <- c(1, 5)                                     # default ui.R:3557 (topSO[2]=5)
  PYSO  <- bibliometrix::sourceGrowth(M, topSO[2], cdf = cdf)
  if (topSO[1] > 1) PYSO <- PYSO[-c(2:(topSO[1]))]
  term  <- names(PYSO)[-1]
  term  <- rep(term, each = dim(PYSO)[1])
  n     <- dim(PYSO)[1] * (dim(PYSO)[2] - 1)
  freq  <- matrix(as.matrix(PYSO[, -1]), n, 1)
  SODF  <- data.frame(Year = rep(PYSO$Year, (dim(PYSO)[2] - 1)), Source = term, Freq = freq)
  Text  <- paste(SODF$Source, " (", SODF$Year, ") ", SODF$Freq, sep = "")
  x <- c(min(SODF$Year) + 0.02, min(SODF$Year) + 0.02 + diff(range(SODF$Year)) * 0.15)
  y <- c(max(SODF$Freq) - diff(range(SODF$Freq)) * 0.15, max(SODF$Freq))
  # reordena leyenda por valor máx desc + trunca nombres largos (>35 -> 32+"...")
  SODF$Source <- factor(SODF$Source, levels = names(sort(
    tapply(SODF$Freq, SODF$Source, max), decreasing = TRUE)))
  trunc_labels <- stats::setNames(ifelse(nchar(levels(SODF$Source)) > 35,
    paste0(substr(levels(SODF$Source), 1, 32), "..."), levels(SODF$Source)), levels(SODF$Source))

  # --- ggplot INLINE VERBATIM (server.R:6750-6808), logoGrid -> nullGrob ---
  g <- ggplot2::ggplot(SODF, ggplot2::aes(x = SODF$Year, y = SODF$Freq, group = SODF$Source,
                                          color = SODF$Source, text = Text)) +
    ggplot2::geom_line() +
    ggplot2::labs(x = 'Year', y = laby, title = "Sources' Production over Time") +
    ggplot2::scale_x_continuous(breaks = (PYSO$Year[seq(1, length(PYSO$Year),
                                          by = ceiling(length(PYSO$Year) / 20))])) +
    ggplot2::geom_hline(ggplot2::aes(yintercept = 0), alpha = 0.1) +
    ggplot2::labs(color = "Source") +
    ggplot2::theme(
      text = ggplot2::element_text(color = "#444444"),
      legend.text = ggplot2::element_text(size = 9, face = "bold"),
      legend.box.margin = ggplot2::margin(2, 2, 2, 2),
      legend.title = ggplot2::element_text(size = 10, face = "bold"),
      legend.position = "bottom",
      legend.direction = "horizontal",
      legend.key.size = grid::unit(0.4, "cm"),
      legend.key.width = grid::unit(0.6, "cm"),
      plot.caption = ggplot2::element_text(size = 9, hjust = 0.5, color = "black", face = "bold"),
      panel.background = ggplot2::element_rect(fill = '#FFFFFF'),
      panel.grid.minor = ggplot2::element_line(color = '#EFEFEF'),
      panel.grid.major = ggplot2::element_line(color = '#EFEFEF'),
      plot.title = ggplot2::element_text(size = 24),
      axis.title = ggplot2::element_text(size = 14, color = '#555555'),
      axis.title.y = ggplot2::element_text(vjust = 1, angle = 90),
      axis.title.x = ggplot2::element_text(hjust = 0.95, angle = 0),
      axis.text.x = ggplot2::element_text(size = 10, angle = 90),
      axis.line.x = ggplot2::element_line(color = "black", linewidth = 0.5),
      axis.line.y = ggplot2::element_line(color = "black", linewidth = 0.5)) +
    ggplot2::scale_color_discrete(labels = trunc_labels) +
    ggplot2::guides(color = ggplot2::guide_legend(ncol = 2)) +
    ggplot2::annotation_custom(grid::nullGrob(), xmin = x[1], xmax = x[2], ymin = y[1], ymax = y[2])

  # --- render on-screen = plot.ly + layout(leyenda a la DERECHA) + hovermode='compare'
  #     (server.R:6832-6866; plot.ly quita el título e ignora aspectratio) ---
  plf <- tryCatch(get("plot.ly", envir = .BSHINY), error = function(e) NULL)
  ply <- if (is.function(plf)) tryCatch({
    leg <- list(orientation = 'v', x = 1.02, y = 1, xanchor = 'left', yanchor = 'top',
                font = list(family = "sans-serif", size = 12, color = "#000"),
                bgcolor = "rgba(255,255,255,0.9)", bordercolor = "#EEEEEE", borderwidth = 1)
    plf(g, flip = FALSE, side = "r", aspectratio = 1.8, size = 0.10) %>%
      plotly::layout(legend = leg, margin = list(r = 200)) %>%
      plotly::config(displaylogo = FALSE, modeBarButtonsToRemove = c(
        'toImage', 'sendDataToCloud', 'pan2d', 'select2d', 'lasso2d',
        'toggleSpikelines', 'hoverClosestCartesian', 'hoverCompareCartesian')) %>%
      plotly::layout(hovermode = 'compare')
  }, error = function(e) NULL) else NULL
  plot_asset <- if (!is.null(ply))
    list(id = "plot", type = "plot_html", filename = "plot.html", object = ply,
         snap_w = 1650, snap_h = 864)          # 80vh (ui.R:3582) x ancho de contenido
  else .fig(g)
  list(plot_asset, .tbl(PYSO))                 # tabla = values$PYSO (server.R:6871)
})

# ===========================================================================
# 3) Most Relevant Affiliations  (3.3.2.1)  ·  params$disambiguation {yes, no}
# VERBATIM del handler MRAffResult (server.R:7846-7903). disAff Y/N (default "Y", ui.R:4420):
#   Y = strsplit(AU_UN) -> group_by count arrange rename(Articles) filter(!= "NA")
#   N = tableTag(M,"C1") CRUDO (afiliaciones completas del campo C1), filtro nchar>4
# top-k=MostRelAffiliationsK=10 (ui.R:4429). freqPlot(x=2, y=1, textLaby="Affiliations",
# textLabx="Articles", title="Most Relevant Affiliations"). Tabla = values$TABAff (TAB
# completa). render plot.ly(aspectratio=1.3 inerte). Barra = extra del usuario.
# ===========================================================================
register_runner("most_relevant_affiliations", function(M, params) {
  disAff <- switch(if (is.null(params$disambiguation)) "yes" else params$disambiguation,
                   yes = "Y", no = "N",
                   stop(sprintf("unknown disambiguation: %s", params$disambiguation)))
  if (disAff == "Y") {
    if (!("AU_UN" %in% names(M))) M <- bibliometrix::metaTagExtraction(M, Field = "AU_UN")
    TAB <- data.frame(Affiliation = unlist(strsplit(M$AU_UN, ";"))) %>%
      dplyr::group_by(Affiliation) %>%
      dplyr::count() %>%
      tidyr::drop_na(Affiliation) %>%
      dplyr::arrange(dplyr::desc(n)) %>%
      dplyr::rename(Articles = n) %>%
      dplyr::filter(Affiliation != "NA") %>%
      as.data.frame()
  } else {
    TAB <- bibliometrix::tableTag(M, "C1")
    TAB <- data.frame(Affiliations = names(TAB), Articles = as.numeric(TAB))
    TAB <- TAB[nchar(TAB[, 1]) > 4, ]
  }
  xx <- TAB; names(xx) <- c("AFF", "Freq")
  k  <- min(10L, nrow(xx))                               # MostRelAffiliationsK default 10
  xx <- xx[1:k, ]
  c(.rank_figs(xx, "Freq", "AFF", "Most Relevant Affiliations", "Articles",
               M, n = nrow(xx), textLaby = "Affiliations"),
    list(.tbl(TAB)))                                     # tabla = values$TABAff (TAB completa)
})

# ===========================================================================
# 4) Affiliations' Production over Time  (3.3.2.2)
# VERBATIM del handler AFFGrowth (server.R:7978-8031): usa la función REAL
# AffiliationOverTime(values, topAFF=5 (ui.R:4545)) (utils.R:3233) -> values$AffOverTimePlot
# (ggplot inline: geom_line, breaks ceiling(N/20), reorden leyenda por máx, trunca >35,
# geom_hline, tema) + values$AffOverTime (tabla larga acumulada). Render on-screen =
# plot.ly(g) %>% layout(leyenda a la DERECHA, margin r=200) %>% config %>% layout(hovermode)
# (8019-8031) -> plot_html (80vh, ui.R:4569). logoGrid -> nullGrob (annotation_custom).
# `values` va como ENTORNO (AffiliationOverTime muta $AffOverTime/$AffOverTimePlot y devuelve values).
# ===========================================================================
register_runner("affiliations_production_over_time", function(M, params) {
  suppressMessages({ library(plotly); library(tidyr) })   # AffiliationOverTime usa pivot_*/drop_na/across sin calificar
  aot <- tryCatch(get("AffiliationOverTime", envir = .BSHINY), error = function(e) NULL)
  plf <- tryCatch(get("plot.ly",             envir = .BSHINY), error = function(e) NULL)
  if (is.null(aot)) {                                     # fallback: helper simplificado
    MM <- bibliometrix::metaTagExtraction(M, "AU_UN")
    df <- .over_time(MM, "AU_UN", "Affiliation", top = 5L)
    return(list(.fig(.lines(df, "Affiliation", "Affiliations' Production over Time", "Articles")), .tbl(df)))
  }
  values <- new.env(parent = globalenv())
  values$M <- M
  values$logoGrid <- grid::nullGrob()                    # annotation_custom(values$logoGrid) sin watermark
  values <- aot(values, 5L)                              # topAFF default 5
  g   <- values$AffOverTimePlot
  tab <- as.data.frame(values$AffOverTime)

  ply <- if (is.function(plf)) tryCatch({
    leg <- list(orientation = 'v', x = 1.02, y = 1, xanchor = 'left', yanchor = 'top',
                font = list(family = "sans-serif", size = 12, color = "#000"),
                bgcolor = "rgba(255,255,255,0.9)", bordercolor = "#EEEEEE", borderwidth = 1)
    plf(g, flip = FALSE, side = "r", aspectratio = 1.8, size = 0.10) %>%
      plotly::layout(legend = leg, margin = list(r = 200)) %>%
      plotly::config(displaylogo = FALSE, modeBarButtonsToRemove = c(
        'sendDataToCloud', 'pan2d', 'select2d', 'lasso2d', 'toggleSpikelines')) %>%
      plotly::layout(hovermode = 'compare')
  }, error = function(e) NULL) else NULL
  plot_asset <- if (!is.null(ply))
    list(id = "plot", type = "plot_html", filename = "plot.html", object = ply, snap_w = 1650, snap_h = 864)
  else .fig(g)
  list(plot_asset, .tbl(tab))                            # tabla = values$AffOverTime
})

# ===========================================================================
# 5) Corresponding Author's Countries  (3.3.3.1)
# VERBATIM del handler CAUCountriesResult (server.R:8078-8213): countryCollab(M)
# (utils.R:2975, vía .BSHINY) -> TABCo(Country, Articles, SCP, MCP) + Freq/MCP_Ratio;
# top-k=MostRelCountriesK=20 (ui.R:4656) por (SCP+MCP); stacked bar SCP/MCP inline
# (geom_bar stat=identity, coord_flip, caption SCP/MCP). Render plot.ly(flip=T, aspectratio=1.4)
# -> plot_html (75vh, ui.R:4682). Tabla = values$TABCo (Country, Articles, Articles %, SCP,
# MCP, MCP %). logoGrid -> nullGrob. El plot YA ES el bar (no hay lollipop+barra aquí).
# ===========================================================================
register_runner("corresponding_author_countries", function(M, params) {
  suppressMessages({ library(plotly); library(tidyr) })
  cc  <- tryCatch(get("countryCollab", envir = .BSHINY), error = function(e) NULL)
  plf <- tryCatch(get("plot.ly",       envir = .BSHINY), error = function(e) NULL)

  TABCo <- cc(M) %>%
    dplyr::mutate(Freq = Articles / sum(Articles)) %>%
    dplyr::mutate(MCP_Ratio = MCP / Articles) %>%
    tidyr::drop_na(Country)

  k  <- min(20L, nrow(TABCo))                            # MostRelCountriesK default 20 (ui.R:4656)
  xx <- TABCo %>% dplyr::slice_head(n = k) %>% dplyr::select(Country, SCP, MCP)
  xx <- xx[order(-(xx$SCP + xx$MCP)), ]
  xx1 <- cbind(xx[, 1:2], rep("SCP", k)); names(xx1) <- c("Country", "Freq", "Collaboration")
  xx2 <- cbind(xx[, c(1, 3)], rep("MCP", k)); names(xx2) <- c("Country", "Freq", "Collaboration")
  xx  <- rbind(xx2, xx1)
  xx$Country <- factor(xx$Country, levels = xx$Country[1:nrow(xx2)])
  xxs <- xx %>% dplyr::group_by(Country) %>% dplyr::summarize(Freq = sum(Freq))
  x <- c(0.5, 0.5 + length(levels(xxs$Country)) * 0.125) + 1
  y <- c(max(xxs$Freq) - 0.02 - diff(range(xxs$Freq)) * 0.125, max(xxs$Freq) - 0.02)

  # --- ggplot INLINE VERBATIM (server.R:8119-8165), logoGrid -> nullGrob ---
  g <- suppressWarnings(
    ggplot2::ggplot(data = xx, ggplot2::aes(x = Country, y = Freq, fill = Collaboration,
                    text = paste("Country: ", Country, "\nN.of Documents: ", Freq))) +
      ggplot2::geom_bar(ggplot2::aes(group = "NA"), stat = "identity") +
      ggplot2::scale_x_discrete(limits = rev(levels(xx$Country))) +
      ggplot2::scale_fill_discrete(name = "Collaboration", breaks = c("SCP", "MCP")) +
      ggplot2::labs(title = "Corresponding Author's Countries", x = "Countries", y = "N. of Documents",
                    caption = "SCP: Single Country Publications, MCP: Multiple Country Publications") +
      ggplot2::theme(
        plot.caption = ggplot2::element_text(size = 9, hjust = 0.5, color = "blue", face = "italic"),
        panel.background = ggplot2::element_rect(fill = '#FFFFFF'),
        panel.grid.major.y = ggplot2::element_line(color = '#EFEFEF'),
        plot.title = ggplot2::element_text(size = 24),
        axis.title = ggplot2::element_text(size = 14, color = '#555555'),
        axis.title.y = ggplot2::element_text(vjust = 1, angle = 0),
        axis.title.x = ggplot2::element_text(hjust = 0),
        axis.text.y = ggplot2::element_text(face = "bold", size = 11),
        axis.line.x = ggplot2::element_line(color = "black", linewidth = 0.5)) +
      ggplot2::coord_flip()) +
    ggplot2::annotation_custom(grid::nullGrob(), xmin = x[1], xmax = x[2], ymin = y[1], ymax = y[2])

  # --- tabla VERBATIM (server.R:8167-8170) ---
  tab <- TABCo %>% dplyr::mutate(Freq = Freq * 100, MCP_Ratio = MCP_Ratio * 100) %>%
    dplyr::rename("Articles %" = Freq, "MCP %" = MCP_Ratio) %>%
    dplyr::select(Country, "Articles", "Articles %", SCP, MCP, "MCP %")

  # render on-screen = plot.ly(g, flip=T, side="r", aspectratio=1.4, size=0.10, data.type=1) (8206)
  ply <- if (is.function(plf))
    tryCatch(plf(g, flip = TRUE, side = "r", aspectratio = 1.4, size = 0.10, data.type = 1),
             error = function(e) NULL) else NULL
  plot_asset <- if (!is.null(ply))
    list(id = "plot", type = "plot_html", filename = "plot.html", object = ply, snap_w = 1650, snap_h = 810)
  else .fig(g)
  list(plot_asset, .tbl(as.data.frame(tab)))
})

# ===========================================================================
# 6) Countries' Scientific Production  (3.3.3.2)
#    Choropleth world map coloured by country document frequency (AU_CO).
#    Replicates inst/biblioshiny/utils.R::mapworld(). Falls back to a top-20
#    bar chart (no error) if no country name matches the world map.
# ===========================================================================
register_runner("countries_scientific_production", function(M, params) {
  # PARIDAD: se reusa la función REAL de biblioshiny mapworld() (biblioshiny/utils.R:3582)
  # vía .BSHINY -> ggplot choropleth (fill azul #87CEEB->dodgerblue4, breaks=cut(Freq,10),
  # legend.position="none", título "Country Scientific Production", normalización interna de
  # países). On-screen biblioshiny lo muestra como PLOTLY vía plot.ly(g, flip=FALSE,
  # side="r", aspectratio=1.7, size=0.07, data.type=1, height=15) (server.R:8262,
  # output$countryProdPlot=renderPlotly) -> el extractor emite ESE plotly (plot_html ->
  # webshot), consistente con el World Map (4.3.2). Tabla = mapworld$tab %>%
  # rename(Country=region) (server.R:8292).
  # GOTCHA (igual que freqPlot): mapworld hace annotation_custom(values$logoGrid,...) -> si
  # logoGrid es NULL, ggsave/print truena -> pasar values=list(logoGrid=grid::nullGrob())
  # (sin watermark). plotly avisa "geom_GeomCustomAnn not implemented" -> inocuo (nullGrob).
  suppressMessages({ library(plotly) })

  mw  <- tryCatch(get("mapworld", envir = .BSHINY), error = function(e) NULL)
  plf <- tryCatch(get("plot.ly",  envir = .BSHINY), error = function(e) NULL)

  res <- if (!is.null(mw)) tryCatch(mw(M, list(logoGrid = grid::nullGrob())),
                                    error = function(e) NULL) else NULL

  if (is.list(res) && !is.null(res$g)) {
    tab <- res$tab
    names(tab)[names(tab) == "region"] <- "Country"                 # server.R:8292
    g2  <- if (!is.null(plf)) tryCatch(
      plf(res$g, flip = FALSE, side = "r", aspectratio = 1.7, size = 0.07,
          data.type = 1, height = 15), error = function(e) NULL) else NULL
    if (!is.null(g2)) {
      return(list(
        list(id = "plot", type = "plot_html", filename = "plot.html", object = g2,
             snap_w = 1650, snap_h = 825),          # 2:1, = World Map (4.3.2)
        .tbl(tab)))
    }
    # Fallback: ggsave del ggplot (= la descarga CSPplot.save de biblioshiny, server.R:8279)
    return(list(list(id = "plot", type = "figure_png", filename = "plot.png",
                     object = res$g, width = 12, height = 6),
                .tbl(tab)))
  }

  # Fallback final (mapworld no disponible): barra top-20 (sin error)
  MM <- bibliometrix::metaTagExtraction(M, "AU_CO")
  CO <- as.data.frame(bibliometrix::tableTag(MM, "AU_CO"))
  names(CO) <- c("Country", "Freq"); CO$Freq <- as.numeric(CO$Freq)
  CO <- CO[order(-CO$Freq), , drop = FALSE]
  list(.fig(.hbar(CO, "Freq", "Country",
                  "Countries' Scientific Production", "N. of Documents")),
       .tbl(CO))
})

# ===========================================================================
# 7) Countries' Production over Time  (3.3.3.3)
# VERBATIM del handler COGrowth (server.R:8333-8390): usa la función REAL
# CountryOverTime(values, topCO=5 (ui.R:4853)) (utils.R:3366) -> values$CountryOverTimePlot
# (ggplot inline: geom_line, breaks ceiling(N/20), reorden leyenda por máx, trunca >35,
# geom_hline, tema) + values$CountryOverTime (tabla larga acumulada). Render on-screen =
# plot.ly(g) %>% layout(leyenda a la DERECHA, margin r=200) %>% config %>% layout(hovermode)
# (8374-8389) -> plot_html (80vh, ui.R:4877). logoGrid -> nullGrob. Mismo patrón que
# AffiliationOverTime; `values` va como ENTORNO (la fn muta $CountryOverTime/$Plot y devuelve values).
# ===========================================================================
register_runner("countries_production_over_time", function(M, params) {
  suppressMessages({ library(plotly); library(tidyr) })
  cot <- tryCatch(get("CountryOverTime", envir = .BSHINY), error = function(e) NULL)
  plf <- tryCatch(get("plot.ly",         envir = .BSHINY), error = function(e) NULL)
  if (is.null(cot)) {                                     # fallback: helper simplificado
    MM <- bibliometrix::metaTagExtraction(M, "AU_CO")
    df <- .over_time(MM, "AU_CO", "Country", top = 5L)
    return(list(.fig(.lines(df, "Country", "Countries' Production over Time", "Articles")), .tbl(df)))
  }
  values <- new.env(parent = globalenv())
  values$M <- M
  values$logoGrid <- grid::nullGrob()
  values <- cot(values, 5L)                              # topCO default 5
  g   <- values$CountryOverTimePlot
  tab <- as.data.frame(values$CountryOverTime)

  ply <- if (is.function(plf)) tryCatch({
    leg <- list(orientation = 'v', x = 1.02, y = 1, xanchor = 'left', yanchor = 'top',
                font = list(family = "sans-serif", size = 12, color = "#000"),
                bgcolor = "rgba(255,255,255,0.9)", bordercolor = "#EEEEEE", borderwidth = 1)
    plf(g, flip = FALSE, side = "r", aspectratio = 1.8, size = 0.10) %>%
      plotly::layout(legend = leg, margin = list(r = 200)) %>%
      plotly::config(displaylogo = FALSE, modeBarButtonsToRemove = c(
        'toImage', 'sendDataToCloud', 'pan2d', 'select2d', 'lasso2d',
        'toggleSpikelines', 'hoverClosestCartesian', 'hoverCompareCartesian')) %>%
      plotly::layout(hovermode = 'compare')
  }, error = function(e) NULL) else NULL
  plot_asset <- if (!is.null(ply))
    list(id = "plot", type = "plot_html", filename = "plot.html", object = ply, snap_w = 1650, snap_h = 864)
  else .fig(g)
  list(plot_asset, .tbl(tab))                            # tabla = values$CountryOverTime
})

# ===========================================================================
# 8) Most Cited Countries  (3.3.3.4)  ·  params$measure {total_citations, average_article_citations}
# VERBATIM del handler MCCountriesResult (server.R:8434-8492): AU1_CO; TAB =
# select(AU1_CO,TC) drop_na rename(Country) group_by summarise(TC=sum(TotalCitation),
# "Average Article Citations"=round(sum/length,1)) arrange(-TC). measure CitCountriesMeasure
# TC/TCY (default "TC", ui.R:4970). TC -> top-k por TC, laby="N. of Citations"; TCY -> re-sort
# por avg, laby="Average Article Citations". freqPlot(x=2, y=1, textLaby="Countries" (plural),
# textLabx=laby, title="Most Cited Countries"). k=MostCitCountriesK=10 (ui.R:4979). Tabla =
# values$TABCitCo (TAB ordenada por TC, 3 cols). Barra = extra del usuario.
# ===========================================================================
register_runner("most_cited_countries", function(M, params) {
  if (!("AU1_CO" %in% names(M))) M <- bibliometrix::metaTagExtraction(M, "AU1_CO")
  TAB <- M %>%
    dplyr::select(AU1_CO, TC) %>%
    tidyr::drop_na(AU1_CO) %>%
    dplyr::rename(Country = AU1_CO, TotalCitation = TC) %>%
    dplyr::group_by(Country) %>%
    dplyr::summarise("TC" = sum(TotalCitation),
                     "Average Article Citations" = round(sum(TotalCitation) / length(TotalCitation), 1)) %>%
    dplyr::arrange(-TC) %>%
    as.data.frame()

  measure <- switch(if (is.null(params$measure)) "total_citations" else params$measure,
                    total_citations = "TC", average_article_citations = "TCY",
                    stop(sprintf("unknown measure: %s", params$measure)))
  k  <- min(10L, nrow(TAB))                              # MostCitCountriesK default 10
  xx <- TAB
  xx[, 2] <- as.numeric(xx[, 2]); xx[, 3] <- as.numeric(xx[, 3])
  if (measure == "TC") { xx <- xx[1:k, c(1, 2)]; laby <- "N. of Citations" }
  else                 { xx <- xx[order(-xx[, 3]), ]; xx <- xx[1:k, c(1, 3)]; laby <- "Average Article Citations" }
  names(xx) <- c("Country", "value")

  c(.rank_figs(xx, "value", "Country", "Most Cited Countries", laby, M, n = nrow(xx), textLaby = "Countries"),
    list(.tbl(TAB)))                                     # tabla = values$TABCitCo (TAB por TC)
})

# ===========================================================================
# 9) Countries' Collaboration World Map  (4.3.2)
#    Country-country collaboration matrix via biblioNetwork(collaboration,
#    countries). Edges table = From/To/Frequency. Map = collaboration segments
#    between country centroids over the world map; falls back (no error) to a
#    bar chart of the top collaborating pairs if no centroid matches.
# ===========================================================================
register_runner("countries_collaboration_world_map", function(M, params) {
  # PARIDAD: se reusa la función REAL de biblioshiny countrycollaboration_plotly
  # (biblioshiny/utils.R:4320) vía .BSHINY -> mapa plotly choropleth (coloreado por
  # nº de documentos del país) + arcos de colaboración curvos (geosphere), IDÉNTICO
  # a la vista de biblioshiny (server.R:13970). Defaults de la UI: WMedges.min=2 ->
  # min.edges; WMedgesize=5 -> edgesize = WMedgesize*2 = 10; edge_opacity=0.4;
  # min_edgesize=1. La tabla = WMmap$tab[,c(1,2,11)] renombrada (server.R:13984).
  # El mapa se exporta como PNG vía saveWidget(selfcontained=FALSE)+webshot, IGUAL
  # que screen2export(type="plotly")/plot2png de biblioshiny (NO plotlySankey2png:
  # ese usa selfcontained=TRUE y truena "long vectors" con el mapa enorme).
  # Requiere plotly (add_trace/%>% sin calificar) y Matrix (diag() sobre la matriz
  # sparse de biblioNetwork) ATTACHED, como el entorno de biblioshiny.
  suppressMessages({ library(plotly); library(Matrix) })

  ccp       <- tryCatch(get("countrycollaboration_plotly", envir = .BSHINY), error = function(e) NULL)
  min_edges <- if (is.null(params$wm_min_edges)) 2L else as.integer(params$wm_min_edges)
  edgesize  <- (if (is.null(params$wm_edgesize)) 5 else as.numeric(params$wm_edgesize)) * 2

  wm <- if (!is.null(ccp)) tryCatch(
    ccp(M, min.edges = min_edges, edge_opacity = 0.4, edgesize = edgesize, min_edgesize = 1),
    error = function(e) NULL) else NULL

  if (is.list(wm) && !is.null(wm$g)) {
    tab <- wm$tab[, c(1, 2, 11)]                    # server.R:13984
    names(tab) <- c("From", "To", "Frequency")
    return(list(
      list(id = "plot", type = "plot_html", filename = "plot.html", object = wm$g,
           snap_w = 1650, snap_h = 825),            # 2:1 como plot2png (vwidth=h*2*96, vheight=h*96)
      .tbl(tab)))
  }

  # Fallback (ccp no disponible / corpus sin colaboración de países): tabla de
  # aristas + barra de los pares más frecuentes, sin error.
  Net <- as.matrix(bibliometrix::biblioNetwork(
    bibliometrix::metaTagExtraction(M, "AU_CO"),
    analysis = "collaboration", network = "countries", sep = ";"))
  cn  <- colnames(Net)
  ut  <- which(upper.tri(Net) & Net > 0, arr.ind = TRUE)
  edges <- data.frame(From = cn[ut[, 1]], To = cn[ut[, 2]], Frequency = Net[ut],
                      stringsAsFactors = FALSE)
  edges <- edges[order(-edges$Frequency), , drop = FALSE]
  edges$Pair <- paste(edges$From, edges$To, sep = " - ")
  list(.fig(.hbar(edges, "Frequency", "Pair",
                  "Top Country Collaboration Pairs", "N. of Co-Publications")),
       .tbl(edges[, c("From", "To", "Frequency")]))
})
