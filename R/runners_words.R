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
  # PARIDAD: biblioshiny NO usa tableTag crudo en estas páginas; pasa por wordlist()
  # (utils.R:3483) que minusculiza TODOS los términos (utils.R:3534
  # `names(v) <- tolower(names(v))`). tableTag los devuelve en MAYÚSCULA -> replicar.
  names(Tab) <- tolower(names(Tab))
  data.frame(Words = names(Tab), Frequencies = as.numeric(Tab),
             stringsAsFactors = FALSE)
}

# === 3.4.3.1 Most Frequent Words ===========================================
# PARIDAD con server.R (observeEvent(input$applyMFWords), l.9616):
#   - Tabla = lista COMPLETA (n=Inf), columnas Words/Occurrences, minúsculas.
#   - Figura = lollipop de biblioshiny `freqPlot()` (utils.R:2465), NO barras,
#     limitado a las top-`MostRelWordsN` (default 10), título "Most Relevant Words".
#   freqPlot solo toca `values` en una rama (title=="Most Local Cited References" &&
#   SCOPUS) que no aplica a WoS -> le pasamos values=list(M=M) y corre exacto.
register_runner("most_frequent_words", function(M, params) {
  ui  <- if (is.null(params$ui)) list() else params$ui
  N   <- as.integer(.uival(ui, "MostRelWordsN", 10))     # MostRelWordsN default = 10 (ui.R:5752)
  # Datos VERBATIM (server.R:9645-9656): wordlist(Field, n=Inf, measure="identity")$v ->
  # {Words, Occurrences}, minúsculas. `.words_table` = tableTag+tolower, verificado IDÉNTICO
  # a wordlist$v (mismas filas/orden) y además resuelve WC->SC para corpus bibtex.
  TAB <- .words_table(M, params$field, .ng(params))
  names(TAB) <- c("Words", "Occurrences")
  # textLaby DEPENDE DEL CAMPO (server.R:9667-9687), NO es fijo "Words".
  lab <- switch(params$field,
                ID = "Keywords Plus", DE = "Author's Keywords", KW_Merged = "All Keywords",
                TI = "Title's Words", AB = "Abstract's Words", WC = "Subject Categories",
                "Words")
  # Plot = lollipop freqPlot RENDERIZADO VÍA plot.ly (server.R:9721-9723:
  # plot.ly(g, side="r", aspectratio=1.3, size=0.10)) -> fuente FINA como biblioshiny; el
  # runner viejo hacía .fig(g)=ggsave -> fuente BOLD (NO verbatim). `.rank_figs` reproduce
  # ese render + agrega la barra horizontal (representación ADICIONAL que pidió el usuario).
  # top-k=N; wordlist ya viene desc -> presorted.
  k  <- min(N, nrow(TAB))
  xx <- data.frame(Words = TAB$Words, value = TAB$Occurrences,
                   stringsAsFactors = FALSE)[seq_len(k), , drop = FALSE]
  c(.rank_figs(xx, "value", "Words", "Most Relevant Words", "Occurrences", M,
               n = nrow(xx), textLaby = lab, presorted = TRUE),
    list(.tbl(TAB)))
})

# === 3.4.3.2 WordCloud =====================================================
# PARIDAD DE CONTENIDO con server.R (eventReactive(input$applyWordCloud), l.9809):
#   biblioshiny usa top-`n_words` (default 50) y measure "freq" (= conteos crudos).
#   Tabla = top-N, columnas Terms/Frequency, minúsculas.
#   FIGURA: biblioshiny dibuja con el widget wordcloud2 (JS, SIN seed -> NO
#   reproducible ni siquiera en biblioshiny) y exporta un screenshot. El extractor
#   produce un PNG con ggwordcloud (mismo top-N y pesos); el LAYOUT diferirá por
#   fuerza (otro motor). Determinista aquí por el set.seed del driver.
register_runner("wordcloud", function(M, params) {
  ui    <- if (is.null(params$ui)) list() else params$ui
  N     <- as.integer(.uival(ui, "n_words", 50))
  field <- .resolve_tag(M, params$field)
  ng    <- .ng(params)
  # PARIDAD: biblioshiny (server.R:9839/9852) arma los datos con wordlist() y dibuja la
  # nube con el WIDGET REAL wordcloud2::wordcloud2() usando los defaults de UI (size 0.5,
  # gridSize 1, fontFamily "Impact", color "random-dark", shape "circle", ellipticity
  # 0.65, maxRotation 0 [=rotate/10], shuffle TRUE, rotateRatio 0.7, bg blanco). Se guarda
  # como HTML widget y el driver le hace webshot -> PNG (igual que biblioshiny, que TAMBIÉN
  # exporta un screenshot del widget). wordcloud2 es JS con shuffle SIN seed -> el layout
  # NO es reproducible ni en biblioshiny (varía entre corridas). Antes el runner usaba
  # ggwordcloud (otro motor) = el bug reportado.
  wlf   <- tryCatch(get("wordlist", envir = .BSHINY), error = function(e) NULL)
  resW  <- if (is.function(wlf))
    tryCatch(wlf(M, Field = field, n = N, measure = "freq", ngrams = ng,
                 remove.terms = NULL, synonyms = NULL), error = function(e) NULL)
  else NULL
  if (!is.null(resW) && !is.null(resW$W) && nrow(resW$W) > 0) {
    W <- resW$W                                          # cols Terms | Frequency (top-N)
  } else {                                               # fallback si wordlist no está
    TAB <- .words_table(M, params$field, ng)
    W   <- utils::head(data.frame(Terms = TAB$Words, Frequency = TAB$Frequencies,
                                  stringsAsFactors = FALSE), min(N, nrow(TAB)))
  }
  wc  <- wordcloud2::wordcloud2(W, size = 0.5, minSize = 0, gridSize = 1,
    fontFamily = "Impact", fontWeight = "normal", color = "random-dark",
    backgroundColor = "white", minRotation = 0, maxRotation = 0, shuffle = TRUE,
    rotateRatio = 0.7, shape = "circle", ellipticity = 0.65,
    widgetsize = NULL, figPath = NULL, hoverFunction = NULL)
  tbl <- data.frame(Terms = W[[1]], Frequency = W[[2]], stringsAsFactors = FALSE)
  # Snapshot con el ASPECTO de biblioshiny: el widget ocupa el ancho completo del
  # fluidPage (los Options son un botón flotante, NO una columna) con height="75vh"
  # (ui.R:6311) -> en 1920x1080 ~1650x810 (aspecto ~2:1). Un lienzo casi cuadrado
  # empacaría las palabras distinto (el layout de wordcloud2 depende del aspecto).
  list(list(id = "plot", type = "plot_html", filename = "plot.html", object = wc,
            snap_w = 1650, snap_h = 810),
       .tbl(tbl, file = "table.xlsx", id = "table"))
})

# === 3.4.3.3 TreeMap =======================================================
# PARIDAD DE CONTENIDO con server.R (eventReactive(input$applyTreeMap), l.9942):
#   biblioshiny usa top-`treen_words` (default 50), measure "identity" (crudo).
#   Tabla = top-N, columnas Terms/Frequency, minúsculas.
#   FIGURA: biblioshiny dibuja un treemap de plotly (otro algoritmo de teselado) y
#   exporta screenshot; el extractor produce PNG con treemapify (mismo top-N y áreas,
#   colocación de rectángulos distinta -> paridad de contenido, no visual exacta).
register_runner("treemap", function(M, params) {
  ui    <- if (is.null(params$ui)) list() else params$ui
  N     <- as.integer(.uival(ui, "treen_words", 50))
  field <- .resolve_tag(M, params$field)
  ng    <- .ng(params)
  # PARIDAD: biblioshiny (server.R:9969/9980) arma los datos con wordlist(measure=
  # "identity") y dibuja con el WIDGET REAL de plotly `plot_ly(type='treemap', labels=
  # W[,1], parents="Tree", values=W[,2], textinfo="label+value+percent entry")`. Se guarda
  # como HTML widget y el driver le hace webshot -> PNG (biblioshiny TAMBIÉN exporta un
  # screenshot del widget). Antes el runner usaba treemapify (otro motor de teselado) = bug.
  wlf   <- tryCatch(get("wordlist", envir = .BSHINY), error = function(e) NULL)
  resW  <- if (is.function(wlf))
    tryCatch(wlf(M, Field = field, n = N, measure = "identity", ngrams = ng,
                 remove.terms = NULL, synonyms = NULL), error = function(e) NULL)
  else NULL
  if (!is.null(resW) && !is.null(resW$W) && nrow(resW$W) > 0) {
    W <- resW$W                                          # cols Terms | Frequency (top-N)
  } else {                                               # fallback si wordlist no está
    TAB <- .words_table(M, params$field, ng)
    W   <- utils::head(data.frame(Terms = TAB$Words, Frequency = TAB$Frequencies,
                                  stringsAsFactors = FALSE), min(N, nrow(TAB)))
  }
  tm  <- plotly::plot_ly(type = "treemap", labels = W[, 1], parents = "Tree",
                         values = W[, 2], textinfo = "label+value+percent entry",
                         domain = list(column = 0))
  tm  <- plotly::config(tm, displaylogo = FALSE,
                        modeBarButtonsToRemove = c("toImage", "sendDataToCloud", "pan2d",
                          "select2d", "lasso2d", "toggleSpikelines",
                          "hoverClosestCartesian", "hoverCompareCartesian"))
  tbl <- data.frame(Terms = W[[1]], Frequency = W[[2]], stringsAsFactors = FALSE)
  # Snapshot con el ASPECTO de biblioshiny: ancho completo del fluidPage (Options =
  # botón flotante) + height="75vh" (ui.R:6574) -> ~1650x810 (aspecto ~2:1, apaisado).
  # El teselado del treemap plotly depende del aspecto del contenedor.
  list(list(id = "plot", type = "plot_html", filename = "plot.html", object = tm,
            snap_w = 1650, snap_h = 810),
       .tbl(tbl, file = "table.xlsx", id = "table"))
})

# === 3.4.3.4 Words' Frequency over Time ====================================
# PARIDAD con server.R (eventReactive(input$applyWD), l.10125):
#   - `cumTerms` (default "Cum") -> cdf=TRUE + eje "Cumulate occurrences";
#     "noCum" -> cdf=FALSE + "Annual occurrences".
#   - `topkw` es un slider de RANGO (default c(1,10)): KeywordGrowth(top=topkw[2]);
#     luego se ventanea a las columnas [topkw[1]..topkw[2]].
#   - biblioshiny REORDENA la leyenda (factor Term) por valor máximo descendente
#     -> replicarlo para que los colores de las líneas coincidan.
#   Render VERBATIM (server.R:10342-10375): ggplot con theme COMPLETO + geom_hline + Text
#   aes, rendida vía plot.ly (leyenda a la DERECHA vertical + margin r=200 + hovermode).
#   El runner viejo reconstruía un ggplot con theme MÍNIMO y hacía .fig=ggsave -> NO verbatim
#   (fuente bold, título presente, leyenda distinta). Defaults ui.R: field="KW_Merged" (6669),
#   cumTerms="Cum" (6827), topkw=c(1,10) (6837).
register_runner("words_frequency_over_time", function(M, params) {
  suppressMessages(library(plotly))
  ui   <- if (is.null(params$ui)) list() else params$ui
  cdf  <- identical(.uival(ui, "cumTerms", "Cum"), "Cum")
  laby <- if (cdf) "Cumulate occurrences" else "Annual occurrences"
  rng  <- .uival(ui, "topkw", c(1L, 10L)); low <- as.integer(rng[1]); high <- as.integer(rng[2])

  # --- datos VERBATIM (server.R:10156-10237) ---
  fr <- .words_field(M, params$field, .ng(params))   # TI/AB -> termExtraction(_TM); resto Tag directo
  KW <- bibliometrix::KeywordGrowth(fr$M, Tag = fr$tag, sep = ";", top = high, cdf = cdf)
  KW <- KW[, c(1L, seq(low, high) + 1L)]              # ventana [low..high] (server.R:10227)
  term <- names(KW)[-1]
  term <- rep(term, each = nrow(KW))
  n    <- nrow(KW) * (ncol(KW) - 1)
  freq <- matrix(as.matrix(KW[, -1]), n, 1)
  DF   <- data.frame(Year = rep(KW$Year, (ncol(KW) - 1)), Term = term, Freq = freq)
  Text <- paste(DF$Term, " (", DF$Year, ") ", DF$Freq, sep = "")
  x <- c(min(DF$Year) + 0.02, min(DF$Year) + 0.02 + diff(range(DF$Year)) * 0.20)
  y <- c(max(DF$Freq) - diff(range(DF$Freq)) * 0.20, max(DF$Freq))
  # reordena leyenda por valor máx desc (server.R:10259-10266)
  DF$Term <- factor(DF$Term, levels = names(sort(tapply(DF$Freq, DF$Term, max), decreasing = TRUE)))

  # --- ggplot INLINE VERBATIM (server.R:10268-10318), logoGrid -> nullGrob ---
  g <- ggplot2::ggplot(DF, ggplot2::aes(x = DF$Year, y = DF$Freq, group = DF$Term,
                                        color = DF$Term, text = Text)) +
    ggplot2::geom_line() +
    ggplot2::labs(x = 'Year', y = laby, title = "Words' Frequency over Time") +
    ggplot2::scale_x_continuous(breaks = (KW$Year[seq(1, length(KW$Year),
                                          by = ceiling(length(KW$Year) / 20))])) +
    ggplot2::geom_hline(ggplot2::aes(yintercept = 0), alpha = 0.1) +
    ggplot2::labs(color = "Term") +
    ggplot2::theme(
      text = ggplot2::element_text(color = "#444444"),
      legend.text = ggplot2::element_text(size = 10),
      legend.box.margin = ggplot2::margin(6, 6, 6, 6),
      legend.title = ggplot2::element_text(size = 12, face = "bold"),
      legend.position = "right",
      legend.direction = "vertical",
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
    ggplot2::annotation_custom(grid::nullGrob(), xmin = x[1], xmax = x[2], ymin = y[1], ymax = y[2])

  # --- render on-screen = plot.ly + leyenda derecha + hovermode (server.R:10342-10375) ---
  plf <- tryCatch(get("plot.ly", envir = .BSHINY), error = function(e) NULL)
  ply <- if (is.function(plf)) tryCatch({
    leg <- list(orientation = 'v', x = 1.02, y = 1, xanchor = 'left', yanchor = 'top',
                font = list(family = "sans-serif", size = 12, color = "#000"),
                bgcolor = "rgba(255,255,255,0.9)", bordercolor = "#EEEEEE", borderwidth = 1)
    plf(g, flip = FALSE, side = "r", aspectratio = 1.6, size = 0.10) %>%
      plotly::layout(legend = leg, margin = list(r = 200)) %>%
      plotly::config(displaylogo = FALSE, modeBarButtonsToRemove = c(
        'toImage', 'sendDataToCloud', 'pan2d', 'select2d', 'lasso2d',
        'toggleSpikelines', 'hoverClosestCartesian', 'hoverCompareCartesian')) %>%
      plotly::layout(hovermode = 'compare')
  }, error = function(e) NULL) else NULL
  plot_asset <- if (!is.null(ply))
    list(id = "plot", type = "plot_html", filename = "plot.html", object = ply,
         snap_w = 1650, snap_h = 864)     # 80vh
  else .fig(g)
  list(plot_asset, .tbl(KW))              # tabla = values$KW (server.R:10381)
})

# === 3.4.3.5 Trend Topics ==================================================
# fieldByYear -> static ggplot (median year + IQR segments); df_graph table
# renamed to the biblioshiny column labels.
register_runner("trend_topics", function(M, params) {
  fr  <- .words_field(M, params$field, .ng(params))
  ui  <- if (is.null(params$ui)) list() else params$ui
  min.freq <- as.numeric(if (is.null(ui$trendMinFreq)) 5 else ui$trendMinFreq)  # biblioshiny default 5
  n.items  <- as.numeric(if (is.null(ui$trendNItems))  3 else ui$trendNItems)   # biblioshiny default 3
  # PARIDAD: biblioshiny (server.R:10508) pasa dynamic.plot=TRUE a fieldByYear y RENDERIZA
  # con plot.ly (=ggplotly, l.10556) -> el font de los ejes lo dibuja el navegador (FINO).
  # El extractor hacía ggsave del ggplot -> R rasteriza el font más GRUESO (lo que notó el
  # usuario). Fix: replicar el render real de biblioshiny (plotly) reusando su helper
  # plot.ly (.BSHINY) + dynamic.plot=TRUE; asset plot_html -> el driver hace webshot -> PNG.
  # timespan = c(min PY, max PY): default del slider trendSliderPY (server.R:10469) = rango
  # completo. Equivale al NULL de fieldByYear, pero se pasa explícito como biblioshiny (10511).
  tsp <- c(min(M$PY, na.rm = TRUE), max(M$PY, na.rm = TRUE))
  res <- bibliometrix::fieldByYear(fr$M, field = fr$tag, timespan = tsp,
                                   min.freq = min.freq, n.items = n.items,
                                   dynamic.plot = TRUE, graph = FALSE)
  TAB <- res$df_graph |>
    dplyr::rename(Term = "item", Frequency = "freq",
                  `Year (Q1)` = "year_q1", `Year (Median)` = "year_med",
                  `Year (Q3)` = "year_q3") |>
    as.data.frame()
  plf <- tryCatch(get("plot.ly", envir = .BSHINY), error = function(e) NULL)
  g   <- if (is.function(plf))
    tryCatch(plf(res$graph, flip = TRUE, side = "r", size = 0.1, aspectratio = 1.3),
             error = function(e) NULL) else NULL
  if (!is.null(g))
    list(list(id = "plot", type = "plot_html", filename = "plot.html", object = g,
              snap_w = 1500, snap_h = 900),
         .tbl(TAB))
  else
    list(.fig(res$graph), .tbl(TAB))     # fallback ggplot si plot.ly no está
})
