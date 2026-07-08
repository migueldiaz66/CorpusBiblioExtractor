# --- runners.R --------------------------------------------------------------
# Shared runner helpers + the pilot runners (Sources family).
# Other families live in R/runners_*.R and register themselves too.
# Sourced before runners_*.R (alphabetical), so helpers below are available.

# Horizontal bar chart (mirrors biblioshiny freqPlot look) ------------------
.hbar <- function(df, value_col, label_col, title, xlab, n = 20L, round_digits = 1L, presorted = FALSE) {
  df <- as.data.frame(df)
  # presorted=TRUE: usa el df TAL CUAL (ya ordenado + top-k por el caller); si no, ordena desc(value).
  d  <- if (presorted) utils::head(df, n) else utils::head(df[order(-df[[value_col]]), , drop = FALSE], n)
  d[[value_col]] <- round(as.numeric(d[[value_col]]), round_digits)   # etiquetas: 1 decimal default (freqPlot handlers 7148/7344/8455/8886); algunas secciones 2 (m_index en Hindex_plot, utils.R:3072)
  d[[label_col]] <- substr(as.character(d[[label_col]]), 1, 50)
  # orden de las barras: presorted -> conserva el orden dado (fila 1 arriba); si no -> por valor.
  d$.ord <- if (presorted) factor(d[[label_col]], levels = rev(d[[label_col]]))
            else stats::reorder(d[[label_col]], d[[value_col]])
  ggplot2::ggplot(d, ggplot2::aes(x = .data[[".ord"]],
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

# Lollipop (biblioshiny's EXACT style for ranking pages): thin grey segment 0->value +
# circle sized/colored by value (scale_radius 5..12) + bold value label at the end;
# labels top-ranked first. biblioshiny draws ALL "Most Relevant / Most Cited / Local
# Impact / Most Frequent" pages with freqPlot() (utils.R:2465). We reuse that REAL
# function via .BSHINY (identical), passing a null logo grob (freqPlot embeds the
# bibliometrix watermark via annotation_custom(values$logoGrid); a nullGrob removes it
# and avoids the ggsave crash on NULL). Falls back to the horizontal bar if freqPlot
# is unavailable. `M` is needed because freqPlot reads values$M$DB[1].
# n = 10L: default de biblioshiny para estas páginas (MostRelSourcesK/MostRelAuthorsK/
# MostCitCountriesK... todos value=10 en ui.R:3087/3688/4979), NO 20.
.lollipop <- function(df, value_col, label_col, title, xlab, M, n = 10L, label_max = Inf,
                      textLaby = NULL, round_digits = 1L, presorted = FALSE) {
  df <- as.data.frame(df)
  # presorted=TRUE: el caller ya ordenó + limitó (p.ej. MGCD-por-año conserva el orden de TC).
  d  <- if (presorted) utils::head(df, n) else utils::head(df[order(-df[[value_col]]), , drop = FALSE], n)
  lab <- as.character(d[[label_col]])
  # Truncado ANTES de freqPlot que hacen SOLO los handlers de Sources (server.R:6204/6304:
  # substr(xx$Sources,1,50)); los demás handlers no truncan (freqPlot ya recorta a
  # string.max=70). label_max=Inf -> no trunca (default de las secciones no-Sources).
  if (is.finite(label_max)) lab <- substr(lab, 1, label_max)
  xx <- data.frame(a = lab, b = round(as.numeric(d[[value_col]]), round_digits),
                   stringsAsFactors = FALSE)            # round_digits: 1 default; 2 p.ej. m_index (Hindex_plot)
  names(xx) <- c(label_col, value_col)                 # y=1 (label), x=2 (value)
  # textLaby = título del eje Y en freqPlot; puede diferir del nombre de la columna
  # (p.ej. Most Local Cited Sources: columna "Sources" pero textLaby="Cited Sources",
  # server.R:6310). Default = label_col (secciones donde coinciden).
  tly <- if (is.null(textLaby)) label_col else textLaby
  fp <- tryCatch(get("freqPlot", envir = .BSHINY), error = function(e) NULL)
  if (is.function(fp)) {
    g <- tryCatch(fp(xx, x = 2, y = 1, textLaby = tly, textLabx = xlab,
                     title = title, values = list(M = M, logoGrid = grid::nullGrob())),
                  error = function(e) NULL)
    if (!is.null(g)) return(g)
  }
  .hbar(df, value_col, label_col, title, xlab, n)       # fallback
}

# Two figures for a ranking page: biblioshiny's lollipop (PRIMARY, paridad) + the
# horizontal bar as an ADDITIONAL representation (plot_bar.png).
# El lollipop se RENDERIZA VÍA PLOTLY (plot.ly, como biblioshiny server.R:6238, a 75vh):
# ggplotly NO respeta el `face="bold"` que fija freqPlot en el eje Y -> los labels salen
# FINOS (como en biblioshiny). El `ggsave` del ggplot SÍ respeta el bold -> grueso (lo que
# notó el usuario). Por eso el lollipop va como plot_html (webshot->PNG); la barra sí es
# ggplot PNG. Fallback a ggplot si plot.ly no está.
.rank_figs <- function(df, value_col, label_col, title, xlab, M, n = 10L, label_max = Inf,
                       textLaby = NULL, round_digits = 1L, presorted = FALSE) {   # 10 = default biblioshiny
  gg  <- .lollipop(df, value_col, label_col, title, xlab, M, n, label_max, textLaby, round_digits, presorted)   # freqPlot ggplot
  plf <- tryCatch(get("plot.ly", envir = .BSHINY), error = function(e) NULL)
  # VERBATIM: exactamente lo que biblioshiny hace (server.R renderPlotly -> plot.ly(g,...)).
  # SIN standoff/automargin/margin manuales: el layout del título del eje Y sale tal cual del
  # ggplotly de biblioshiny. La posición título<->labels que se vea es la que produce el
  # código de biblioshiny; no se ajusta a mano.
  ply <- if (is.function(plf))
    tryCatch(plf(gg, flip = FALSE, side = "r", aspectratio = 1.1, size = 0.10),
             error = function(e) NULL) else NULL
  primary <- if (!is.null(ply))
    list(id = "plot", type = "plot_html", filename = "plot.html", object = ply,
         snap_w = 1650, snap_h = 810)
  else
    .fig(gg, file = "plot.png", id = "plot")                       # fallback ggplot PNG
  list(primary,
       .fig(.hbar(df, value_col, label_col, title, xlab, n, round_digits, presorted), file = "plot_bar.png", id = "plot_bar"))
}

# === Sources family (pilot, validated) =====================================

register_runner("most_relevant_sources", function(M, params) {
  # Datos VERBATIM del handler MRSourcesResult (server.R:6184-6190).
  TAB <- M |>
    dplyr::group_by(SO) |>
    dplyr::count() |>
    dplyr::arrange(dplyr::desc(n)) |>
    dplyr::rename(Sources = SO, Articles = n) |>
    as.data.frame()
  TAB <- TAB[!is.na(TAB$Sources), , drop = FALSE]
  # Lollipop = freqPlot(xx, x=2, y=1, ...) con substr(Sources,1,50) (server.R:6204) + render
  # plot.ly(aspectratio=1.1) (6238); la barra es el extra que pidió el usuario (no está en biblioshiny).
  c(.rank_figs(TAB, "Articles", "Sources", "Most Relevant Sources", "N. of Documents", M, label_max = 50),
    list(.tbl(TAB)))
})

# Bradford Summary tab (ui.R:3294, output$bradfordSummary) — bloque HTML VERBATIM de
# server.R:6444-6566 (paste0 de strings desde b$stat + b$zoneSummary; NO hay función
# reusable). Se devuelve envuelto para webshot (fondo blanco). html_doc -> PNG.
.bradford_summary_doc <- function(b) {
  s  <- b$stat
  zs <- b$zoneSummary
  ks_interpretation <- if (s$ks.pvalue >= 0.05) {
    paste0("<span style='color:#2E7D32;font-weight:bold;'>The empirical distribution is consistent with Bradford's Law (p = ",
           format.pval(s$ks.pvalue, digits = 3), ")</span>")
  } else {
    paste0("<span style='color:#C62828;font-weight:bold;'>The empirical distribution deviates significantly from Bradford's Law (p = ",
           format.pval(s$ks.pvalue, digits = 3), ")</span>")
  }
  summary_html <- paste0(
    "<div style='max-width:800px; margin:30px auto; font-family:inherit;'>",
    "<h4 style='color:#333; border-bottom:2px solid #2171B5; padding-bottom:8px;'>",
    "Bradford Distribution Model</h4>",
    "<p style='font-size:15px; color:#444;'>",
    "The Bradford distribution models the cumulative number of articles <em>C(r)</em> ",
    "contributed by the top <em>r</em> sources as:</p>",
    "<p style='font-size:16px; text-align:center; font-weight:bold; color:#333; ",
    "background:#f8f9fa; padding:12px; border-radius:6px;'>",
    "C(r) = ", round(s$a, 2), " + ", round(s$b, 2), " &middot; log(r)", "</p>",
    "<table style='width:100%; border-collapse:collapse; margin:20px 0;'>",
    "<tr style='background:#f0f4f8;'>",
    "<td style='padding:10px 15px; font-weight:bold; border-bottom:1px solid #ddd;'>Intercept (a)</td>",
    "<td style='padding:10px 15px; border-bottom:1px solid #ddd;'>", round(s$a, 4), "</td></tr>",
    "<tr><td style='padding:10px 15px; font-weight:bold; border-bottom:1px solid #ddd;'>Slope (b)</td>",
    "<td style='padding:10px 15px; border-bottom:1px solid #ddd;'>", round(s$b, 4), "</td></tr>",
    "<tr style='background:#f0f4f8;'>",
    "<td style='padding:10px 15px; font-weight:bold; border-bottom:1px solid #ddd;'>R&sup2;</td>",
    "<td style='padding:10px 15px; border-bottom:1px solid #ddd;'>", round(s$R2, 4), "</td></tr>",
    "<tr><td style='padding:10px 15px; font-weight:bold; border-bottom:1px solid #ddd;'>Bradford Multiplier (k)</td>",
    "<td style='padding:10px 15px; border-bottom:1px solid #ddd;'>", round(s$k, 2), "</td></tr>",
    "</table>",
    "<h4 style='color:#333; border-bottom:2px solid #2171B5; padding-bottom:8px; margin-top:30px;'>",
    "Kolmogorov-Smirnov Goodness-of-Fit Test</h4>",
    "<table style='width:100%; border-collapse:collapse; margin:20px 0;'>",
    "<tr style='background:#f0f4f8;'>",
    "<td style='padding:10px 15px; font-weight:bold; border-bottom:1px solid #ddd;'>KS Statistic (D)</td>",
    "<td style='padding:10px 15px; border-bottom:1px solid #ddd;'>", round(s$ks.stat, 4), "</td></tr>",
    "<tr><td style='padding:10px 15px; font-weight:bold; border-bottom:1px solid #ddd;'>p-value</td>",
    "<td style='padding:10px 15px; border-bottom:1px solid #ddd;'>", format.pval(s$ks.pvalue, digits = 3), "</td></tr>",
    "</table>",
    "<p style='font-size:14px; margin:10px 0 5px 0;'>", ks_interpretation, "</p>",
    "<p style='font-size:12px; color:#888;'>H0: The empirical distribution follows the theoretical Bradford distribution. ",
    "A p-value &ge; 0.05 indicates no significant deviation.</p>",
    "<h4 style='color:#333; border-bottom:2px solid #2171B5; padding-bottom:8px; margin-top:30px;'>",
    "Zone Summary</h4>",
    "<table style='width:100%; border-collapse:collapse; margin:20px 0;'>",
    "<thead><tr style='background:#2171B5; color:white;'>",
    "<th style='padding:10px 15px; text-align:left;'>Zone</th>",
    "<th style='padding:10px 15px; text-align:right;'>N. Sources</th>",
    "<th style='padding:10px 15px; text-align:right;'>% Sources</th>",
    "<th style='padding:10px 15px; text-align:right;'>N. Articles</th>",
    "<th style='padding:10px 15px; text-align:right;'>% Articles</th>",
    "</tr></thead><tbody>")
  zone_colors <- c("#E3F0FA", "#FFFFFF", "#E3F0FA", "#F0F4F8")
  for (i in seq_len(nrow(zs))) {
    bg <- zone_colors[i]
    fw <- if (i == nrow(zs)) "font-weight:bold;" else ""
    summary_html <- paste0(summary_html,
      "<tr style='background:", bg, ";'>",
      "<td style='padding:8px 15px; border-bottom:1px solid #ddd;", fw, "'>", zs$Zone[i], "</td>",
      "<td style='padding:8px 15px; text-align:right; border-bottom:1px solid #ddd;", fw, "'>", zs[["N. Sources"]][i], "</td>",
      "<td style='padding:8px 15px; text-align:right; border-bottom:1px solid #ddd;", fw, "'>", zs[["% Sources"]][i], "%</td>",
      "<td style='padding:8px 15px; text-align:right; border-bottom:1px solid #ddd;", fw, "'>", zs[["N. Articles"]][i], "</td>",
      "<td style='padding:8px 15px; text-align:right; border-bottom:1px solid #ddd;", fw, "'>", zs[["% Articles"]][i], "%</td>",
      "</tr>")
  }
  summary_html <- paste0(summary_html, "</tbody></table></div>")
  htmltools::tagList(htmltools::tags$style("body{background:#fff;margin:0;}"), shiny::HTML(summary_html))
}

register_runner("bradford", function(M, params) {
  # 3 salidas como biblioshiny (ui.R:3284/3290/3294): Plot + Table + Summary.
  b   <- bibliometrix::bradford(M)
  plf <- tryCatch(get("plot.ly", envir = .BSHINY), error = function(e) NULL)
  # PLOT on-screen = plot.ly(b$graph_shiny, ...) (server.R:6389, renderPlotly). plot.ly ignora
  # aspectratio/size y quita el título (utils.R:2445-62) -> plot_html (75vh, ui.R:3285).
  # Fallback al ggplot de export (b$graph, server.R:6406) si plot.ly/graph_shiny no están.
  ply <- if (is.function(plf) && !is.null(b$graph_shiny))
    tryCatch(plf(b$graph_shiny, flip = FALSE, side = "r", aspectratio = 1.6, size = 0.15),
             error = function(e) NULL) else NULL
  plot_asset <- if (!is.null(ply))
    list(id = "plot", type = "plot_html", filename = "plot.html", object = ply, snap_w = 1650, snap_h = 810)
  else .fig(b$graph)
  # SUMMARY = output$bradfordSummary (HTML verbatim) -> html_doc -> webshot PNG.
  sdoc <- tryCatch(.bradford_summary_doc(b), error = function(e) NULL)
  out  <- list(plot_asset)
  if (!is.null(sdoc))
    out <- c(out, list(list(id = "summary", type = "html_doc", filename = "summary.html",
                            object = sdoc, snap_w = 900, snap_h = 1150)))
  c(out, list(.tbl(b$table)))
})

register_runner("sources_local_impact", function(M, params) {
  H   <- bibliometrix::Hindex(M, field = "source", elements = NULL, sep = ";", years = Inf)$H
  col <- switch(params$impact_measure,
                h_index = "h_index", g_index = "g_index", m_index = "m_index",
                total_citation = "TC", stop("unknown impact_measure"))
  Hr  <- H; Hr[[col]] <- round(as.numeric(Hr[[col]]), 1)   # biblioshiny redondea el impacto a 1 decimal en la gráfica (server.R:7148)
  c(.rank_figs(Hr, col, "Element", sprintf("Sources' Local Impact (%s)", params$impact_measure), col, M),
    list(.tbl(H[order(-H[[col]]), , drop = FALSE])))
})
