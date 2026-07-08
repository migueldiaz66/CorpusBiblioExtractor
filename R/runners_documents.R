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
  y <- as.numeric(substr(Sys.Date(), 1, 4))
  # Datos VERBATIM del handler MGCDocsResult (server.R:8854-8872): 5 columnas
  # {Paper, DOI, Total Citations, TC per Year, Normalized TC}. Normalized TC =
  # TC/mean(TC) POR AÑO de publicación (group_by(PY)); PY se descarta. SIN Title/Year.
  # Orden SIEMPRE desc(TC).
  TAB <- M %>%
    dplyr::mutate(TCperYear = round(TC / (y + 1 - PY), 1)) %>%
    dplyr::select(SR, DI, TC, TCperYear, PY) %>%
    dplyr::group_by(PY) %>%
    dplyr::mutate(NTC = TC / mean(TC)) %>%
    dplyr::ungroup() %>%
    dplyr::select(-PY) %>%
    dplyr::arrange(dplyr::desc(TC)) %>%
    as.data.frame()
  names(TAB) <- c("Paper", "DOI", "Total Citations", "TC per Year", "Normalized TC")

  # Measure (ui.R:5104-5108): TC (default) / TCY.
  measure <- switch(if (is.null(params$measure)) "total_citations" else params$measure,
                    total_citations          = "TC",
                    total_citations_per_year = "TCY",
                    stop("unknown measure: ", params$measure))
  # Plot data (server.R:8881-8892): parte de TAB ordenado por desc(TC). Para TCY toma el
  # top-k POR TC (no re-ordena por TCY) -> presorted=TRUE. textLaby="Documents" (8897).
  if (measure == "TC") { xx <- TAB[, c(1, 3)]; lab <- "Global Citations" }
  else                 { xx <- TAB[, c(1, 4)]; xx[, 2] <- round(xx[, 2], 1); lab <- "Global Citations per Year" }
  k  <- min(10L, nrow(xx))                    # MostCitDocsK default = 10 (ui.R:5095)
  xx <- xx[seq_len(k), , drop = FALSE]
  names(xx) <- c("Paper", "value")
  c(.rank_figs(xx, "value", "Paper", "Most Global Cited Documents", lab, M,
               n = nrow(xx), textLaby = "Documents", presorted = TRUE),
    list(.tbl(TAB)))
})

# 2) Most Local Cited Documents ---------------------------------------------
# 3.4.1.2 · plot.png + table.xlsx · no params
register_runner("most_local_cited_documents", function(M, params) {
  # Datos VERBATIM del handler MLCDocuments (server.R:8988-9013). localCitations$Papers =
  # Paper|DOI|Year|LCS|GCS (ya ordenado por LCS desc). group_by(Year) agrega Ratio/NLCS/NGCS.
  TAB <- bibliometrix::localCitations(M, fast.search = FALSE, sep = ";")$Papers
  TAB <- TAB %>%
    dplyr::group_by(Year) %>%
    dplyr::mutate(
      Ratio = LCS / GCS * 100,
      NLCS  = LCS / mean(LCS),
      NGCS  = GCS / mean(GCS)
    ) %>%
    dplyr::ungroup() %>%
    as.data.frame()
  # Tabla = las 8 columnas de xx (server.R:9004-9013) con los nombres de display del
  # render (server.R:9081-9088). DOI plano (el <a href> es solo display).
  tbl <- data.frame(
    Paper                          = as.character(TAB[[1]]),
    DOI                            = as.character(TAB[[2]]),
    Year                           = TAB[[3]],
    "Local Citations"              = TAB[[4]],
    "Global Citations"             = TAB[[5]],
    "LC/GC Ratio (%)"              = TAB[[6]],
    "Normalized Local Citations"   = TAB[[7]],
    "Normalized Global Citations"  = TAB[[8]],
    check.names = FALSE, stringsAsFactors = FALSE
  )
  # Plot: freqPlot(xx, x=4=Local Citations, y=1=Document), textLaby="Documents",
  # top-k=10 (MostLocCitDocsK). biblioshiny toma xx[1:k,] SIN re-ordenar -> presorted.
  k  <- min(10L, nrow(tbl))                    # MostLocCitDocsK default = 10 (ui.R:5221)
  xx <- data.frame(Paper = tbl$Paper, value = tbl[["Local Citations"]],
                   stringsAsFactors = FALSE)[seq_len(k), , drop = FALSE]
  c(.rank_figs(xx, "value", "Paper", "Most Local Cited Documents", "Local Citations", M,
               n = nrow(xx), textLaby = "Documents", presorted = TRUE),
    list(.tbl(tbl)))
})

# 3) Most Local Cited References --------------------------------------------
# 3.4.2.1 · plot.png + table.xlsx · no params
register_runner("most_local_cited_references", function(M, params) {
  # Datos VERBATIM del handler MLCReferences (server.R:9132-9145). citations() sin `field`
  # usa el default "article"; sep=";" (CitRefsSep default). $Cited = tabla ordenada desc.
  CR  <- bibliometrix::citations(M, sep = ";")$Cited
  TAB <- data.frame(names(CR), as.numeric(CR), stringsAsFactors = FALSE)
  names(TAB) <- c("Cited References", "Citations")
  TAB <- TAB[TAB[["Cited References"]] != "ANONYMOUS, NO TITLE CAPTURED", , drop = FALSE]

  # Plot: freqPlot(xx, x=2, y=1, textLaby="References", textLabx="Local Citations"), top-k=10
  # (MostCitRefsK). biblioshiny toma xx[1:k,] sin re-ordenar -> presorted.
  k  <- min(10L, nrow(TAB))                    # MostCitRefsK default = 10 (ui.R:5358)
  xx <- data.frame(Reference = TAB[["Cited References"]], value = TAB[["Citations"]],
                   stringsAsFactors = FALSE)[seq_len(k), , drop = FALSE]

  # Tabla verbatim (server.R:9189-9199): + columna "Google Scholar" (link a scholar con la
  # referencia reducida+limpia: trimES(gsub([[:punct:]]," ",reduceRefs(ref)))), reordenada a
  # Google Scholar | Cited References | Citations. Guardo la URL cruda (no el <a href> display).
  reduceRefs <- get("reduceRefs", envir = .BSHINY)              # biblioshiny/utils.R:2546
  q   <- bibliometrix:::trimES(gsub("[[:punct:]]", " ", reduceRefs(TAB[["Cited References"]])))
  tbl <- data.frame(
    "Google Scholar"   = paste0("https://scholar.google.it/scholar?hl=en&as_sdt=0%2C5&q=", q),
    "Cited References"  = TAB[["Cited References"]],
    "Citations"         = TAB[["Citations"]],
    check.names = FALSE, stringsAsFactors = FALSE
  )
  c(.rank_figs(xx, "value", "Reference", "Most Local Cited References", "Local Citations", M,
               n = nrow(xx), textLaby = "References", presorted = TRUE),
    list(.tbl(tbl)))
})

# 4) References Spectroscopy (RPYS) -----------------------------------------
# 3.4.2.2 · plot.png + table.xlsx · params$median_window in {centered, backward}
# rpys() exposes median.window, so the chosen window drives $rpysTable$diffMedian
# directly (backward -> diffMedian5, centered -> diffMedian2).
register_runner("references_spectroscopy", function(M, params) {
  # biblioshiny (server.R:9269 rpys graph=FALSE; render 9329-9340) NO hace ggsave del ggplot:
  # lo pasa por plot.ly -> plotly. plot.ly QUITA el título (labs(title=NULL)) e ggplotly
  # convierte el ggplot (dropea el logo GeomCustomAnn). Por eso la spectroscopy de biblioshiny
  # NO trae título ni las etiquetas de año grandes que salían con ggsave (el runner viejo usaba
  # .fig(g)=ggsave -> NO verbatim). median.window = "centered"/"backward" (default UI backward).
  r   <- bibliometrix::rpys(M, sep = ";", timespan = NULL,
                            median.window = params$median_window, graph = FALSE)
  # RENDER VERBATIM (server.R:9331): plot.ly(res$spectroscopy, side="l", aspectratio=1.3,
  # size=0.10) + hoverinfo="skip" en traces 3+ (picos y etiquetas; solo afecta el hover).
  plf <- get("plot.ly", envir = .BSHINY)
  p   <- plf(r$spectroscopy, side = "l", aspectratio = 1.3, size = 0.10)
  nt  <- length(p$x$data)
  if (nt > 2) for (i in 3:nt) p$x$data[[i]]$hoverinfo <- "skip"

  # La página tiene 4 TABLAS (server.R:9342/9366/9401/9447). El extractor exportaba solo
  # la primera; ahora las 4, con las transformaciones EXACTAS de biblioshiny.
  scholar <- function(q) paste0("https://scholar.google.it/scholar?hl=en&as_sdt=0%2C5&q=", q)

  # (1) Table - RPYS: r$rpysTable tal cual (Year, Citations, diffMedian5/2/median).
  t_rpys <- as.data.frame(r$rpysTable)

  # (2) Table - Cited References (output$crTable): +Google link, orden desc Year/Freq,
  # cols reordenadas a Year | Google link | Reference | Local Citations.
  cr <- as.data.frame(r$CR)                                   # Year | Reference | Freq
  cr$link <- scholar(cr$Reference)
  cr <- cr[order(-as.numeric(cr$Year), -cr$Freq), , drop = FALSE]
  names(cr) <- c("Year", "Reference", "Local Citations", "Google link")
  cr <- cr[, c(1, 4, 2, 3)]

  # (3) Table - Influential References (output$rpysSequence): FILTRA por Class según el
  # selector rpysInfluential, cuyo DEFAULT de UI es "Hot Paper" (ui.R:5587). select+rename.
  paperClass <- if (is.null(params$influential)) "Hot Paper" else params$influential
  sq <- as.data.frame(r$Sequences)                           # CR | RPY | Freq | sequence | Class
  sq <- sq[regexpr(paperClass, sq$Class) > -1, , drop = FALSE]
  sq$link <- scholar(sq$CR)
  sq <- sq[, c("RPY", "CR", "Freq", "link", "sequence", "Class")]
  names(sq) <- c("Year", "Reference", "Local Citations", "Google link", "Citation Sequence", "Sequence Type")

  # (4) Table - Top 10 Peaks (output$rpysPeaks -> rpysPeaks(res,n=10), biblioAI.R:2111):
  # top-3 refs (por Freq) de cada AÑO-PICO; años-pico = diffMedian mayor que sus vecinos,
  # tomando los 10 de mayor diffMedian. Reimplementado (evita cargar el modulo biblioAI).
  dp <- r$rpysTable |> dplyr::arrange(Year) |>
    dplyr::mutate(is_peak = (diffMedian > dplyr::lag(diffMedian)) & (diffMedian > dplyr::lead(diffMedian))) |>
    dplyr::filter(is_peak) |> dplyr::arrange(dplyr::desc(diffMedian)) |> dplyr::slice_head(n = 10)
  pk <- r$CR |> dplyr::group_by(Year) |> dplyr::slice_max(Freq, n = 3, with_ties = FALSE) |>
    dplyr::filter(Year %in% dp$Year) |> dplyr::ungroup() |> as.data.frame()
  names(pk) <- c("Year", "Reference", "Local Citations")

  list(list(id = "plot", type = "plot_html", filename = "plot.html", object = p,
            snap_w = 1650, snap_h = 810),
       .tbl(t_rpys, file = "table.xlsx",                        id = "table"),
       .tbl(cr,     file = "table_cited_references.xlsx",       id = "table_cited_references"),
       .tbl(sq,     file = "table_influential_references.xlsx", id = "table_influential_references"),
       .tbl(pk,     file = "table_top10_peaks.xlsx",            id = "table_top10_peaks"))
})
