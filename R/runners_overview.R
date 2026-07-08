# --- runners_overview.R -----------------------------------------------------
# ANALYSIS > Overview family. Registers five runners. Sourced after
# registry.R (register_runner) and runners.R (helpers .tbl/.fig/.hbar), so all
# of those are available here.
#
# Contract: register_runner("<name>", function(M, params){ ... ; list(<assets>) })
#   asset = list(id=, type=, filename=, object=)
#   helpers: .tbl(df, file, id)  -> table_xlsx ; .fig(ggplot, file, id) -> figure_png
#            .hbar(df, value_col, label_col, title, xlab, n=20) -> ggplot (top-n h-bars)
#   Loaded libs: bibliometrix, dplyr, ggplot2. No plotly. The driver handles the
#   per-scenario seed + error capture, so no set.seed here; tryCatch is used ONLY
#   where the section spec asks for graceful degradation (logistic fit in
#   life_cycle; the plotly-only three-field plot, which must never fail).
# All five Overview pages take an empty `params` (single "default" scenario).
#
# Notes on data sources (verified against bibliometrix 5.4.1 source + server.R):
# - main_information: summary.bibliometrix() returns $MainInformationDF
#   (cols Description, Results) and biblioAnalysis()$Documents is a table of DT
#   counts (names padded)                              [summary.bibliometrix.R,
#   biblioAnalysis.R].
# - annual_scientific_production: descriptive(type="tab2") = group_by(PY) |>
#   count() |> rename(Year=PY, Articles=n)             [server.R AnnualProdPlot].
# - average_citations_per_year: server groups by PY -> MeanTCperArt=mean(TC),
#   N=n(), MeanTCperYear=MeanTCperArt/(currentYear+1-PY). The section spec for
#   this runner instead divides by (maxYear-Year+1), which is what we use below
#   [server.R AnnualTotCitperYearPlot].
# - life_cycle: bibliometrix::lifeCycle() fits the logistic via optim() on ANNUAL
#   counts and is plotly-rendered. The section spec asks for a simpler stand-in:
#   fit the CUMULATIVE curve with stats::nls(SSlogis), fall back to the raw
#   cumulative if it does not converge                 [lifeCycle.R].
# - three_field_plot: threeFieldsPlot() returns a plotly Sankey (cannot be a
#   ggplot/PNG); we emit a static faceted-bars stand-in built from the same
#   per-field top-n items via cocMatrix()              [threeFieldsPlot.R].

# Reused biblioshiny functions need their libs on the search path: ValueBoxes()
# uses tidyr::replace_na; lifeCycleSummaryUI() uses shiny UI fns; plotLifeCycle()
# uses plotly -> attach tidyr / shiny / plotly.
suppressWarnings(suppressMessages({ library(tidyr); library(shiny); library(plotly) }))

# NOTA: el CSS de las Life Cycle Summary cards NO se copia a mano — se usa la función
# REAL cssTags() de biblioshiny (biblioshiny/cssTags.R, sourced a .BSHINY), que es lo que
# ui.R:739 inyecta globalmente y de donde lifeCycleSummaryUI() toma sus clases .lifecycle-*
# (lifeCycleUI.R NO trae CSS propio). Ver el runner life_cycle abajo.

# === Overview family ========================================================

# 1) Main Information -------------------------------------------------------
# 3.1.1 · plot.png + table.xlsx · no params
# PARIDAD con biblioshiny: la pestaña *Plot* de Main Information NO es una gráfica
# (menos aún de "Document Types") -> es la rejilla de 12 tarjetas KPI (valueBox).
# TANTO las tarjetas COMO la Tabla salen de ValueBoxes(M) (utils.R:2849) ->
# values$TABvb (server.R renderiza output$MainInfo = renderBibliobox(TABvb) y las
# 12 valueBox leen de ese df). Reusamos ValueBoxes via .BSHINY para números
# idénticos; fallback a summary()$MainInformationDF si no está disponible.
# La rejilla es COPIA LITERAL del layout de biblioshiny ui.R:2419-2445 (fluidRow con
# 4 column(3), cada una apila 3 valueBox); ver detalle abajo.
register_runner("main_information", function(M, params) {
  vbf <- tryCatch(get("ValueBoxes", envir = .BSHINY), error = function(e) NULL)
  TAB <- if (is.function(vbf)) tryCatch(vbf(M), error = function(e) NULL) else NULL
  if (is.null(TAB))
    TAB <- summary(bibliometrix::biblioAnalysis(M), k = 10, verbose = FALSE)$MainInformationDF

  vb <- function(desc) { v <- TAB$Results[trimws(as.character(TAB$Description)) == desc]
                         if (!length(v)) "" else trimws(as.character(v[1])) }

  # COPIA FIEL del HTML de biblioshiny: el valueBox REAL de shinydashboard + su CSS
  # (AdminLTE small-box/skins + shinydashboard.css, que trae .icon-large = 70px
  # bottom-right rgba(0,0,0,0.15), Source Sans Pro, número centrado, esquinas 2px, y
  # el tamaño de card por el grid col-sm-3). Se hace webshot -> PNG raw (card_png, NO
  # deja .html). Iconos EXACTOS de server.R: 9 FontAwesome + 3 glyphicon
  # (arrow-up, globe, volume-up = icon(lib="glyphicon")).
  adminlte <- system.file("AdminLTE", package = "shinydashboard")
  dep <- htmltools::htmlDependency("AdminLTE", "2.0.6", src = adminlte,
                                   stylesheet = c("AdminLTE.min.css", "_all-skins.min.css"))
  sd_css <- paste(readLines(system.file("shinydashboard.css", package = "shinydashboard"), warn = FALSE), collapse = "\n")
  # width = NULL como server.R (el ancho lo da el column(3) del ui.R, no el valueBox).
  vbx <- function(label, val, ic, color, glyph = FALSE) {
    ico <- if (glyph) shiny::icon(ic, lib = "glyphicon") else shiny::icon(ic)
    shinydashboard::valueBox(
      value    = shiny::p(label, style = "font-size:16px;color:white;"),
      subtitle = shiny::p(shiny::strong(val), style = "font-size:36px;color:white;", align = "center"),
      icon = ico, color = color, width = NULL)
  }
  # LAYOUT = copia LITERAL de biblioshiny ui.R:2419-2445: un fluidRow con 4 column(3),
  # cada columna apila 3 valueBox EN EL MISMO ORDEN Y CON EL MISMO icono/color/valor que
  # server.R:5509-5735 (col1 Timespan/au/kw, col2 so/auS1/cr, col3 doc/col/agePerDoc,
  # col4 cagr/coAuPerDoc/tc). El color va por caja (cíclico blue/light-blue/aqua) -> cada
  # columna tiene una de cada color; leído por filas queda fila1 blue / fila2 light-blue /
  # fila3 aqua (idéntico a la vista de biblioshiny). El fluidPage exterior es solo el lienzo
  # para el webshot (fondo blanco + centrado), no parte del layout.
  doc <- shiny::tagList(dep, shiny::tags$style(shiny::HTML(sd_css)),
    shiny::fluidPage(style = "padding:15px;background:#fff;max-width:1280px;margin:auto;",
      shiny::fluidRow(
        shiny::br(),
        shiny::column(3,
          vbx("Timespan", vb("Timespan"), "hourglass", "blue"),
          vbx("Authors", vb("Authors"), "user", "light-blue"),
          vbx("Author's Keywords (DE)", vb("Author's Keywords (DE)"), "spell-check", "aqua")),
        shiny::column(3,
          vbx("Sources", vb("Sources (Journals, Books, etc)"), "book", "blue"),
          vbx("Authors of single-authored docs", vb("Authors of single-authored docs"), "pen-fancy", "light-blue"),
          vbx("References", vb("References"), "file", "aqua")),
        shiny::column(3,
          vbx("Documents", vb("Documents"), "layer-group", "blue"),
          vbx("International Co-Authorship", paste0(vb("International co-authorships %"), " %"), "globe", "light-blue", TRUE),
          vbx("Document Average Age", vb("Document Average Age"), "calendar", "aqua")),
        shiny::column(3,
          vbx("Annual Growth Rate", paste0(vb("Annual Growth Rate %"), " %"), "arrow-up", "blue", TRUE),
          vbx("Co-Authors per Doc", vb("Co-Authors per Doc"), "users", "light-blue"),
          vbx("Average citations per doc", vb("Average citations per doc"), "volume-up", "aqua", TRUE)))))

  list(list(id = "plot", type = "card_png", filename = "plot.png", object = doc, snap_w = 1300, snap_h = 470),
       .tbl(TAB, file = "table.xlsx", id = "table"))
})

# 2) Annual Scientific Production -------------------------------------------
# 3.1.2 · plot.html + table.xlsx · no params
# PARIDAD 100% biblioshiny (server.R:5766-5814, output$AnnualProdPlot=renderPlotly):
# NO hay función con nombre para el plot -> el ggplot se arma INLINE en el renderPlotly.
# Los DATOS salen de descriptive(values,"tab2") (utils.R:3095, vía .BSHINY): TAB(Year,
# Articles) con el rango de años RELLENADO con 0 (right_join a seq(min,max)+replace_na)
# -> vector CONTIGUO. El ggplot + el render plot.ly(g, flip=FALSE, side="r",
# aspectratio=1.7, size=0.10) se copian VERBATIM de server.R (breaks=Year[seq(1,N,by=2)],
# labels verticales, tema fondo blanco/grid #EFEFEF, título 24). logoGrid -> nullGrob.
register_runner("annual_scientific_production", function(M, params) {
  suppressMessages({ library(plotly) })
  desc <- tryCatch(get("descriptive", envir = .BSHINY), error = function(e) NULL)
  plf  <- tryCatch(get("plot.ly",     envir = .BSHINY), error = function(e) NULL)

  TAB <- if (!is.null(desc)) tryCatch(desc(list(M = M), type = "tab2")$TAB, error = function(e) NULL) else NULL
  if (is.null(TAB))  # fallback: misma lógica de descriptive tab2
    TAB <- M |> dplyr::group_by(PY) |> dplyr::count() |>
      dplyr::rename(Year = PY, Articles = n) |>
      dplyr::right_join(data.frame(Year = seq(min(M$PY, na.rm = TRUE), max(M$PY, na.rm = TRUE))), by = "Year") |>
      dplyr::mutate(Articles = tidyr::replace_na(Articles, 0)) |>
      dplyr::arrange(Year) |> as.data.frame()

  # --- ggplot INLINE, VERBATIM de server.R:5771-5810 (logoGrid -> nullGrob) ---
  Y <- TAB; names(Y) <- c("Year", "Freq")
  x <- c(max(Y$Year) - 0.02 - diff(range(Y$Year)) * 0.125, max(Y$Year) - 0.02) + 1
  y <- c(min(Y$Freq), min(Y$Freq) + diff(range(Y$Freq)) * 0.125)
  g <- ggplot2::ggplot(Y, ggplot2::aes(x = Year, y = Freq,
         text = paste("Year: ", Year, "\nN .of Documents: ", Freq))) +
    ggplot2::geom_line(ggplot2::aes(group = "NA")) +
    ggplot2::labs(x = 'Year', y = 'Articles', title = "Annual Scientific Production") +
    ggplot2::scale_x_continuous(breaks = (Y$Year[seq(1, length(Y$Year), by = 2)])) +
    ggplot2::theme(
      text = ggplot2::element_text(color = "#444444"),
      panel.background = ggplot2::element_rect(fill = '#FFFFFF'),
      panel.grid.minor = ggplot2::element_line(color = '#EFEFEF'),
      panel.grid.major = ggplot2::element_line(color = '#EFEFEF'),
      plot.title = ggplot2::element_text(size = 24),
      axis.title = ggplot2::element_text(size = 14, color = '#555555'),
      axis.title.y = ggplot2::element_text(vjust = 1, angle = 0),
      axis.title.x = ggplot2::element_text(hjust = 0),
      axis.text.x = ggplot2::element_text(vjust = 1, angle = 90),
      axis.line.x = ggplot2::element_line(color = "black", linewidth = 0.5),
      axis.line.y = ggplot2::element_line(color = "black", linewidth = 0.5)) +
    ggplot2::annotation_custom(grid::nullGrob(), xmin = x[1], xmax = x[2], ymin = y[1], ymax = y[2])

  gly <- if (!is.null(plf)) tryCatch(plf(g, flip = FALSE, side = "r", aspectratio = 1.7, size = 0.10),
                                     error = function(e) NULL) else NULL
  if (!is.null(gly))
    return(list(list(id = "plot", type = "plot_html", filename = "plot.html", object = gly,
                     snap_w = 1500, snap_h = 880),
                .tbl(TAB)))
  list(.fig(g), .tbl(TAB))  # fallback: ggsave del ggplot (= descarga ASPplot.save de biblioshiny)
})

# 3) Average Citations per Year ---------------------------------------------
# 3.1.3 · plot.html + table.xlsx · no params
# PARIDAD 100% biblioshiny (server.R:5877-5941, output$AnnualTotCitperYearPlot=renderPlotly):
# NO hay función con nombre -> datos + ggplot INLINE, copiados VERBATIM. Datos = pipe
# dplyr de server.R: group_by(PY) mean(TC)/n(), MeanTCperYear = MeanTCperArt/(current_year
# - PY) con current_year = year(Sys.Date())+1 (¡NO max(Year)!), CitableYears, drop_na().
# OJO: usa Sys.Date() -> NO determinista (depende de la fecha del run), pero así es
# biblioshiny EXACTO. Eje discontinuo (años con citas), labels HORIZONTALES (el theme NO
# define axis.text.x, a diferencia de Annual). Render plot.ly(...); logoGrid -> nullGrob.
register_runner("average_citations_per_year", function(M, params) {
  suppressMessages({ library(plotly) })
  plf <- tryCatch(get("plot.ly", envir = .BSHINY), error = function(e) NULL)

  # --- datos VERBATIM de server.R:5878-5888 ---
  current_year <- as.numeric(substr(Sys.Date(), 1, 4)) + 1
  Table2 <- M %>% dplyr::group_by(PY) %>%
    dplyr::summarize(MeanTCperArt = round(mean(TC, na.rm = TRUE), 2), N = dplyr::n()) %>%
    dplyr::mutate(MeanTCperYear = round(MeanTCperArt / (current_year - PY), 2),
                  CitableYears = current_year - PY) %>%
    dplyr::rename(Year = PY) %>% tidyr::drop_na()
  TAB <- as.data.frame(Table2)                 # tabla = values$AnnualTotCitperYear (5 cols)
  Table2$group <- "A"

  # --- ggplot INLINE, VERBATIM de server.R:5891-5938 (logoGrid -> nullGrob) ---
  x <- c(max(Table2$Year) - 0.02 - diff(range(Table2$Year)) * 0.125, max(Table2$Year) - 0.02) + 1
  y <- c(min(Table2$MeanTCperYear), min(Table2$MeanTCperYear) + diff(range(Table2$MeanTCperYear)) * 0.125)
  g <- ggplot2::ggplot(Table2, ggplot2::aes(x = Year, y = MeanTCperYear,
         text = paste("Year: ", Year, "\nAverage Citations per Year: ", round(MeanTCperYear, 1)))) +
    ggplot2::geom_line(ggplot2::aes(x = Year, y = MeanTCperYear, group = group)) +
    ggplot2::labs(x = 'Year', y = 'Citations', title = "Average Citations per Year") +
    ggplot2::scale_x_continuous(breaks = (Table2$Year[seq(1, length(Table2$Year), by = 2)])) +
    ggplot2::theme(
      text = ggplot2::element_text(color = "#444444"),
      panel.background = ggplot2::element_rect(fill = '#FFFFFF'),
      panel.grid.minor = ggplot2::element_line(color = '#EFEFEF'),
      panel.grid.major = ggplot2::element_line(color = '#EFEFEF'),
      plot.title = ggplot2::element_text(size = 24),
      axis.title = ggplot2::element_text(size = 14, color = '#555555'),
      axis.title.y = ggplot2::element_text(vjust = 1, angle = 0),
      axis.title.x = ggplot2::element_text(hjust = 0),
      axis.line.x = ggplot2::element_line(color = "black", linewidth = 0.5),
      axis.line.y = ggplot2::element_line(color = "black", linewidth = 0.5)) +
    ggplot2::annotation_custom(grid::nullGrob(), xmin = x[1], xmax = x[2], ymin = y[1], ymax = y[2])

  gly <- if (!is.null(plf)) tryCatch(plf(g, flip = FALSE, side = "r", aspectratio = 1.7, size = 0.10),
                                     error = function(e) NULL) else NULL
  if (!is.null(gly))
    return(list(list(id = "plot", type = "plot_html", filename = "plot.html", object = gly,
                     snap_w = 1500, snap_h = 880),
                .tbl(TAB)))
  list(.fig(g), .tbl(TAB))  # fallback: ggsave del ggplot (= descarga ACpYplot.save de biblioshiny)
})

# 4) Life Cycle -------------------------------------------------------------
# 3.1.4 · plot_annual.html + plot_cumulative.html + summary.html + table.xlsx · no params
# VERBATIM del handler observeEvent(input$applyDLC) de biblioshiny (server.R:6004-6044):
#   dlc = M %>% filter(!is.na(PY)) %>% group_by(PY) %>% count()   (6010-13)
#   res = lifeCycle(dlc, forecast_years=20, plot=FALSE)           (6016)
#   wA/wC = plotLifeCycle(res, plot_type="annual"|"cumulative")   (6027-28)  [plotly, renderPlotly]
#   sdoc  = lifeCycleSummaryUI(res) + cssTags()                   (6044 + ui.R:739)  [las 5 cards]
#   tab   = res$parameters %>% as.data.frame %>% rownames_to_column("Metrics") %>% rename(Value=".")  (6029-32)
# Todo con funciones REALES de biblioshiny; código propio del extractor = SOLO el andamiaje
# de webshot (la app viva renderiza en Shiny; aquí se exporta a PNG estático).
register_runner("life_cycle", function(M, params) {
  # dlc EXACTO como biblioshiny (server.R:6010-6013): el TIBBLE de count(), SIN
  # as.data.frame -> lifeCycle recibe el mismo tipo que le pasa biblioshiny.
  dlc <- M %>% dplyr::filter(!is.na(PY)) %>% dplyr::group_by(PY) %>% dplyr::count()
  res <- tryCatch(bibliometrix::lifeCycle(dlc, forecast_years = 20, plot = FALSE),
                  error = function(e) NULL)

  # Fallback (corpus degenerado / < 3 años): curva acumulada simple (ggplot) + tabla.
  if (is.null(res)) {
    dlc <- as.data.frame(dlc); dlc <- dlc[order(dlc$PY), , drop = FALSE]; dlc$Cumulative <- cumsum(dlc$n)
    p <- ggplot2::ggplot(dlc, ggplot2::aes(x = PY, y = Cumulative)) +
      ggplot2::geom_point(color = "#2ca02c", size = 2) +
      ggplot2::geom_line(color = "#1f77b4", linewidth = 1) +
      ggplot2::labs(title = "Life Cycle - Cumulative Production", x = "Year", y = "Cumulative Publications") +
      ggplot2::theme_minimal(base_size = 12)
    return(list(.fig(p, file = "plot_cumulative.png", id = "plot_cumulative"),
                .tbl(dlc, file = "table.xlsx", id = "table")))
  }

  # ── Reproducción VERBATIM del handler observeEvent(input$applyDLC) (server.R:6010-6044).
  # Todo con funciones REALES de biblioshiny; el ÚNICO código propio es el andamiaje de
  # webshot (biblioshiny renderiza en la app viva; el extractor exporta a PNG estático).

  # 2 gráficas = plotLifeCycle(DLC, plot_type=...) (server.R:6027-6028), la vista renderPlotly.
  plc <- tryCatch(get("plotLifeCycle", envir = .BSHINY), error = function(e) NULL)
  wA  <- if (is.function(plc)) tryCatch(plc(res, plot_type = "annual"),     error = function(e) NULL) else NULL
  wC  <- if (is.function(plc)) tryCatch(plc(res, plot_type = "cumulative"), error = function(e) NULL) else NULL

  # Summary = lifeCycleSummaryUI(DLC) (server.R:6044) + el CSS global REAL cssTags()
  # (ui.R:739; lifeCycleUI.R no trae CSS propio). fluidPage/body-style = SOLO lienzo del webshot.
  lcs  <- tryCatch(get("lifeCycleSummaryUI", envir = .BSHINY), error = function(e) NULL)
  cssf <- tryCatch(get("cssTags",            envir = .BSHINY), error = function(e) NULL)
  sdoc <- if (is.function(lcs) && is.function(cssf))
    tryCatch(shiny::fluidPage(cssf(),
                              shiny::tags$style(shiny::HTML("body{background:#fff;padding:20px;}")),
                              lcs(res)),
             error = function(e) NULL) else NULL

  # Tabla = VERBATIM server.R:6029-6032: values$DLC$parameters -> data.frame ->
  # rownames_to_column("Metrics") -> rename(Value="."). (Life Cycle NO tiene pestaña de
  # tabla; su reporte vuelca values$DLC, cuyo componente tabular es `parameters`.)
  tab <- res$parameters %>% as.data.frame() %>%
    tibble::rownames_to_column("Metrics") %>% dplyr::rename(Value = ".")

  out <- list()
  if (!is.null(wA)) out <- c(out, list(list(id = "plot_annual",     type = "plot_html", filename = "plot_annual.html",     object = wA)))
  if (!is.null(wC)) out <- c(out, list(list(id = "plot_cumulative", type = "plot_html", filename = "plot_cumulative.html", object = wC)))
  if (!is.null(sdoc))
    out <- c(out, list(list(id = "summary", type = "html_doc", filename = "summary.html",
                            object = sdoc, snap_w = 1500, snap_h = 860)))
  c(out, list(.tbl(tab, file = "table.xlsx", id = "table")))
})

# 5) Three-Field Plot -------------------------------------------------------
# 3.1.5 · plot.png (Sankey) · no params
# VERBATIM del handler TFP (server.R:6126-6132) con los DEFAULTS de ui.R:
#   fields = c(LeftField, CentralField, RightField) = c("CR","AU","KW_Merged")
#            (ui.R:2888/2846/2930, selected=)
#   n      = c(LeftFieldn, CentralFieldn, RightFieldn) = c(20,20,20) (ui.R:2902/2860/2944)
# EXPORT a PNG = plotlySankey2png(TFP, dpi=values$dpi, height=values$h) (server.R:14278;
# values$dpi=300 / values$h=7 en server.R:254/256), NO webshot genérico -> asset sankey_png
# (save_sankey_png reusa la función real plotlySankey2png). KW_Merged lo crea biblioshiny al
# importar (server.R:1373, mergeKeywords); si el corpus no lo trae, se crea con la misma fn.
register_runner("three_field_plot", function(M, params) {
  if (!"KW_Merged" %in% names(M)) M <- bibliometrix::mergeKeywords(M, force = FALSE)
  sk <- bibliometrix::threeFieldsPlot(M, fields = c("CR", "AU", "KW_Merged"), n = c(20, 20, 20))
  list(
    # PNG = export REAL de biblioshiny (plotlySankey2png, dpi=300/height=7):
    list(id = "plot", type = "sankey_png", filename = "plot.png", object = sk),
    # + el mismo widget plotly VIVO/interactivo (la vista renderPlotly de biblioshiny);
    #   snapshot=FALSE: su PNG ya lo da el asset sankey_png (evita un snapshot pálido duplicado).
    list(id = "plot_live", type = "plot_html", filename = "plot.html", object = sk, snapshot = FALSE))
})
