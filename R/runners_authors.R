# --- runners_authors.R ------------------------------------------------------
# Authors family: ANALYSIS > Authors > Authors panel (sections 3.3.1.*).
# Registers into the shared registry; helpers (.tbl/.fig/.hbar) come from
# runners.R, which is sourced first. No plotly, no tryCatch, no set.seed.
# Loaded packages available: bibliometrix, dplyr, ggplot2.

# === Authors family =========================================================

# 3.3.1.1 Author Profile -----------------------------------------------------
# VERBATIM del handler observeEvent(input$authorPageApply) (server.R:6967-7016): por
# autor produce DOS cards, con las funciones REALES de biblioshiny:
#   - GLOBAL = authorCard(au, values)  (utils.R:1116) -> findAuthorWorks + authorBio(doi[1])
#              + create_author_bio_card(..., max_topics=20). Cachea el bio en values$author_data.
#   - LOCAL  = create_local_author_bio_card(local_data, display_name, max_py, width="100%",
#              show_trends=TRUE, show_keywords=TRUE, max_keywords=20, max_works_display=50)
#              (server.R:7002) sobre los papers del autor en M (TI/SO en title-case).
# El extractor cura los TOP-10 autores (biblioshiny es busqueda de 1 autor, default vacio).
# Render: cada card -> SVG con <foreignObject> (se ve identica + ligas vivas ORCID/OpenAlex/
# topics; iconos base64) + PNG snapshot del driver. `values` va como ENTORNO (authorCard muta
# author_data). Requiere internet + openalexR; NO determinista (datos OpenAlex + timestamp).

# Bootstrap grid como flexbox (el foreignObject no lleva el CSS de bootstrap).
.author_grid_css <- '<style>*{box-sizing:border-box}.row{display:flex;flex-wrap:wrap;margin:0 -15px}[class*="col-sm-"]{padding:0 15px}.col-sm-3{flex:0 0 25%;max-width:25%}.col-sm-4{flex:0 0 33.3333%;max-width:33.3333%}.col-sm-6{flex:0 0 50%;max-width:50%}.col-sm-8{flex:0 0 66.6667%;max-width:66.6667%}</style>'

.datauri <- function(f) {
  if (!file.exists(f) || !requireNamespace("base64enc", quietly = TRUE)) return("")
  paste0("data:image/jpeg;base64,", base64enc::base64encode(f))
}

# Card (htmltools tag) -> self-contained SVG string with foreignObject + links.
.author_svg <- function(card, icon_orcid, icon_oa, W = 1240L, H = 900L) {
  html <- as.character(card)   # footer "Data retrieved from OpenAlex on <run time>" se conserva
  if (nzchar(icon_orcid)) html <- gsub("ORCID.jpg",    icon_orcid, html, fixed = TRUE)
  if (nzchar(icon_oa))    html <- gsub("openalex.jpg", icon_oa,    html, fixed = TRUE)
  sprintf('<svg xmlns="http://www.w3.org/2000/svg" width="%d" height="%d" viewBox="0 0 %d %d"><foreignObject x="0" y="0" width="%d" height="%d"><div xmlns="http://www.w3.org/1999/xhtml" style="width:%dpx;font-family:Segoe UI,Tahoma,sans-serif;">%s%s</div></foreignObject></svg>',
          W, H, W, H, W, H, W, .author_grid_css, html)
}

# Pre-resuelve el bio de OpenAlex probando VARIOS DOIs del autor (authorCard/utils.R:1128 solo
# usa el primero). Reusa las funciones REALES findAuthorWorks + authorBio; limpia el escape de
# bibtex del DOI (\_ -> _). El bio se INYECTA en values$author_data para que authorCard lo tome de
# cache (utils.R:1138) y construya la card con create_author_bio_card SIN tocar su codigo.
.resolve_bio <- function(au, M, mailto, tries = 12L) {
  fAW <- tryCatch(get("findAuthorWorks", envir = .BSHINY), error = function(e) NULL)
  if (is.null(fAW)) fAW <- tryCatch(getFromNamespace("findAuthorWorks", "bibliometrix"), error = function(e) NULL)
  if (is.null(fAW)) return(NULL)
  w <- tryCatch(fAW(au, M, exact_match = TRUE), error = function(e) NULL)
  if (is.null(w) || nrow(w) == 0) return(NULL)
  w <- w[!is.na(w$doi), , drop = FALSE]
  if (nrow(w) == 0) return(NULL)
  w$doi <- gsub("\\\\", "", w$doi)                       # bibtex escape: \_ -> _
  for (k in seq_len(min(tries, nrow(w)))) {
    bio <- tryCatch(bibliometrix::authorBio(author_position = w$author_position[k], doi = w$doi[k],
                                            mailto = if (nchar(mailto)) mailto else NULL),
                    error = function(e) NULL)
    if (is.data.frame(bio) && NROW(bio) >= 1 && "display_name" %in% names(bio)) return(bio)
  }
  NULL
}

register_runner("author_profile", function(M, params) {
  ac  <- tryCatch(get("authorCard", envir = .BSHINY), error = function(e) NULL)
  clc <- tryCatch(get("create_local_author_bio_card", envir = .BSHINY), error = function(e) NULL)
  ttc <- tryCatch(get("to_title_case", envir = .BSHINY), error = function(e) NULL)
  if (is.null(ac) || is.null(clc))
    return(list(.tbl(data.frame(note = "authorCard / create_local_author_bio_card unavailable"),
                     file = "table.xlsx", id = "table")))

  res    <- bibliometrix::biblioAnalysis(M)
  top10  <- names(res$Authors)[seq_len(min(10L, length(res$Authors)))]
  www    <- system.file("biblioshiny/www", package = "bibliometrix")
  ic_orcid <- .datauri(file.path(www, "ORCID.jpg"))
  ic_oa    <- .datauri(file.path(www, "openalex.jpg"))
  max_py   <- max(as.numeric(M$PY), na.rm = TRUE)
  mailto   <- Sys.getenv("openalexR.mailto", unset = "miguel.diazmacedo@gmail.com")
  run_time <- Sys.time()

  # `values` como ENTORNO: authorCard (server.R:6983) MUTA values$author_data (reactiveValues en
  # la app viva); con un env la mutacion persiste y de ahi sale el display_name de la card local.
  values <- new.env(parent = emptyenv())
  values$M <- M
  values$author_data <- NULL

  out <- list(); rows <- list()
  for (i in seq_along(top10)) {
    au   <- top10[i]
    slug <- gsub("_+", "_", gsub("[^a-z0-9]+", "_", tolower(au)))

    # GLOBAL card = authorCard(au, values) (server.R:6983; utils.R:1116) -> create_author_bio_card.
    # Pre-resolvemos el bio con reintento multi-DOI y lo inyectamos en values$author_data: authorCard
    # lo toma de cache (utils.R:1138) y arma la card SIN modificar su codigo. Si el reintento falla,
    # authorCard cae a su propio doi[1] (verbatim).
    bio_r <- .resolve_bio(au, M, mailto)
    if (!is.null(bio_r)) {
      bio_r$query_timestamp <- run_time                  # footer "Data retrieved from OpenAlex on ..."
      values$author_data <- dplyr::mutate(bio_r, AUid = au)
    } else {
      values$author_data <- NULL
    }
    set.seed(42)   # pildoras (topics) estables: create_author_bio_card las baraja sin seed
    card_g <- tryCatch(ac(au, values), error = function(e) NULL)
    if (!is.null(card_g))
      out <- c(out, list(list(id = sprintf("author_%02d_global", i), type = "svg_doc",
                              filename = sprintf("author_%02d_%s_global.svg", i, slug),
                              object = .author_svg(card_g, ic_orcid, ic_oa),
                              snap_w = 1240, snap_h = 900)))

    # LOCAL card VERBATIM (server.R:6990-7011): display_name del bio cacheado por authorCard;
    # local_data = papers del autor en M con TI/SO en title-case; create_local_author_bio_card.
    local_author <- tryCatch(values$author_data %>% dplyr::filter(AUid == au) %>%
                               dplyr::pull(display_name), error = function(e) character(0))
    if (length(local_author) == 0) local_author <- au
    local_data <- tryCatch(values$M[gregexpr(au, values$M$AU) > -1, ], error = function(e) NULL)
    if (!is.null(local_data) && is.function(ttc))
      local_data <- tryCatch(local_data %>% dplyr::mutate(TI = ttc(TI), SO = ttc(SO)),
                             error = function(e) local_data)
    card_l <- if (!is.null(local_data)) tryCatch(
      clc(local_author_data = local_data, selected_author = local_author[1], max_py = max_py,
          width = "100%", show_trends = TRUE, show_keywords = TRUE, max_keywords = 20,
          max_works_display = 50), error = function(e) NULL) else NULL
    if (!is.null(card_l))
      out <- c(out, list(list(id = sprintf("author_%02d_local", i), type = "svg_doc",
                              filename = sprintf("author_%02d_%s_local.svg", i, slug),
                              object = .author_svg(card_l, ic_orcid, ic_oa, W = 1240L, H = 2400L),
                              snap_w = 1240, snap_h = 2400)))

    # fila de tabla desde el bio (OpenAlex) que authorCard cacheo en values$author_data
    bio <- tryCatch(values$author_data %>% dplyr::filter(AUid == au), error = function(e) NULL)
    if (!is.null(bio) && NROW(bio) >= 1) {
      val <- function(x) if (is.null(x) || length(x) == 0) NA else x[1]
      rows[[length(rows) + 1L]] <- data.frame(
        Rank = i, Author = au, Name = val(bio$display_name),
        Works = val(bio$works_count), Citations = val(bio$cited_by_count),
        H_Index = val(bio$h_index), i10_Index = val(bio$i10_index),
        ORCID = val(bio$orcid), OpenAlex_ID = val(bio$id), stringsAsFactors = FALSE)
    }
  }
  tab <- if (length(rows)) do.call(rbind, rows) else
    data.frame(note = "no author profiles fetched (offline / no DOI matches)")
  c(out, list(.tbl(tab, file = "table.xlsx", id = "table")))
})

# 3.3.1.2 Most Relevant Authors ----------------------------------------------
# VERBATIM del handler MRAuthorsResult (server.R:7100-7161): datos INLINE (no res$Authors) =
# strsplit(AU) -> tibble -> group_by(Author) -> Articles=n()/AuthorFrac=sum(frac) -> arrange
# desc(Articles). measure AuFreqMeasure t/p/f (default "t", ui.R:3679). El TOP-k se toma por
# TOTAL (Articles) y LUEGO se hace round(,1) + sort por el measure (importa en fractionalized:
# el set son los top-k por total, no por fraccionalizado). freqPlot(x=2,y=1,textLaby="Authors").
# Tabla = values$TABAu COMPLETA (3 cols) con la 1a renombrada "Author" (server.R:7193). La barra
# es el EXTRA que pidio el usuario (biblioshiny solo tiene lollipop + tabla).
register_runner("most_relevant_authors", function(M, params) {
  listAU <- strsplit(M$AU, ";")
  nAU    <- lengths(listAU)
  fracAU <- rep(1 / nAU, nAU)
  TAB <- tibble::tibble(Author = unlist(listAU), fracAU = fracAU) %>%
    dplyr::group_by(Author) %>%
    dplyr::summarize(Articles = dplyr::n(), AuthorFrac = sum(fracAU)) %>%
    dplyr::arrange(dplyr::desc(Articles)) %>%
    as.data.frame()
  names(TAB) <- c("Authors", "Articles", "Articles Fractionalized")

  fm     <- switch(if (is.null(params$measure)) "documents" else params$measure,
                   documents = "t", documents_percent = "p", fractionalized = "f",
                   stop(sprintf("unknown measure: %s", params$measure)))
  n_docs <- nrow(M)
  xx     <- TAB
  if (fm == "t")      { lab <- "N. of Documents";                 xx <- xx[, 1:2] }
  else if (fm == "p") { xx <- xx[, 1:2]; xx[, 2] <- as.numeric(xx[, 2]) / n_docs * 100
                        lab <- "N. of Documents (in %)" }
  else                { xx <- xx[, c(1, 3)];                       lab <- "N. of Documents (Fractionalized)" }
  xx[, 2] <- as.numeric(xx[, 2])
  k <- 10L; if (k > nrow(xx)) k <- nrow(xx)        # MostRelAuthorsK default 10 (ui.R:3688)
  xx <- xx[1:k, ]
  xx[, 2] <- round(xx[, 2], 1)
  xx <- xx[order(-xx[, 2]), ]
  names(xx) <- c("Authors", "value")

  tab_out <- TAB; names(tab_out)[1] <- "Author"    # tabla de 3 columnas (server.R:7193)
  c(.rank_figs(xx, "value", "Authors", "Most Relevant Authors", lab, M, n = nrow(xx)),
    list(.tbl(tab_out)))
})

# 3.3.1.3 Most Local Cited Authors -------------------------------------------
# VERBATIM del handler MLCAuthorsResult (server.R:7318-7357): TAB = localCitations(M,
# fast.search=FALSE, verbose=FALSE)$Authors (Author, LocalCitations, ya ordenada desc);
# top-k=MostCitAuthorsK=10 (ui.R:3936) + round(,1) + sort; freqPlot(x=2, y=1, textLaby=
# "Authors", textLabx="Local Citations", title="Most Local Cited Authors"); render
# plot.ly(aspectratio=1.3 inerte). Tabla = values$TABAuCit completa (server.R:7389).
# textLaby="Authors" (plural) != nombre de columna "Author" -> se pasa explicito. Barra = extra.
register_runner("most_local_cited_authors", function(M, params) {
  A <- bibliometrix::localCitations(M, fast.search = FALSE, verbose = FALSE)$Authors
  A$Author <- as.character(A$Author)
  A <- A[order(-A$LocalCitations), , drop = FALSE]
  c(.rank_figs(A, "LocalCitations", "Author", "Most Local Cited Authors", "Local Citations",
               M, textLaby = "Authors"),
    list(.tbl(A)))
})

# 3.3.1.4 Authors' Production over Time --------------------------------------
# VERBATIM del handler AUoverTime (server.R:7514-7583): authorProdOverTime(M, k=
# TopAuthorsProdK=10 (ui.R:4046), graph=FALSE). El PLOT es el ggplot REAL de la funcion
# ($graph), renderizado on-screen con plot.ly(g, flip=TRUE, side="l", aspectratio=1)
# (7552; plot.ly ignora flip/side/aspectratio y quita el titulo) -> plot_html (75vh,
# ui.R:4070). DOS tablas: $dfAU (server.R:7563) + $dfPapersAU (papers por autor, 7587).
register_runner("authors_production_over_time", function(M, params) {
  suppressMessages(library(plotly))
  ap  <- bibliometrix::authorProdOverTime(M, k = 10, graph = FALSE)
  plf <- tryCatch(get("plot.ly", envir = .BSHINY), error = function(e) NULL)
  ply <- if (is.function(plf) && !is.null(ap$graph))
    tryCatch(plf(ap$graph, flip = TRUE, side = "l", aspectratio = 1), error = function(e) NULL) else NULL
  plot_asset <- if (!is.null(ply))
    list(id = "plot", type = "plot_html", filename = "plot.html", object = ply, snap_w = 1650, snap_h = 810)
  else .fig(ap$graph)                              # fallback: ggsave del $graph (= descarga)
  out <- list(plot_asset, .tbl(ap$dfAU))
  if (!is.null(ap$dfPapersAU))
    out <- c(out, list(.tbl(ap$dfPapersAU, file = "table_papers.xlsx", id = "table_papers")))
  out
})

# 3.3.1.5 Lotka's Law --------------------------------------------------------
# Summary tab (output$lotkaSummary, server.R:7687-7814) - bloque HTML VERBATIM desde
# L$stat (Beta, C, R2, ks.theo.*, ks.fit.*). No hay funcion reusable -> copia literal.
.lotka_summary_doc <- function(L) {
  s <- L$stat
  ks_theo_interp <- if (s$ks.theo.pvalue >= 0.05) {
    paste0("<span style='color:#2E7D32;font-weight:bold;'>The empirical distribution is consistent with the theoretical Lotka's Law (\u03b2=2) (p = ",
           format.pval(s$ks.theo.pvalue, digits = 3), ")</span>")
  } else {
    paste0("<span style='color:#C62828;font-weight:bold;'>The empirical distribution deviates significantly from the theoretical Lotka's Law (\u03b2=2) (p = ",
           format.pval(s$ks.theo.pvalue, digits = 3), ")</span>")
  }
  ks_fit_interp <- if (s$ks.fit.pvalue >= 0.05) {
    paste0("<span style='color:#2E7D32;font-weight:bold;'>The empirical distribution is consistent with the fitted model (\u03b2=",
           round(s$Beta, 2), ") (p = ", format.pval(s$ks.fit.pvalue, digits = 3), ")</span>")
  } else {
    paste0("<span style='color:#C62828;font-weight:bold;'>The empirical distribution deviates significantly from the fitted model (\u03b2=",
           round(s$Beta, 2), ") (p = ", format.pval(s$ks.fit.pvalue, digits = 3), ")</span>")
  }
  summary_html <- paste0(
    "<div style='max-width:800px; margin:30px auto; font-family:inherit;'>",
    "<h4 style='color:#333; border-bottom:2px solid #2171B5; padding-bottom:8px;'>",
    "Lotka's Inverse Power Law Model</h4>",
    "<p style='font-size:15px; color:#444;'>",
    "Lotka's Law models the proportion of authors <em>f(n)</em> who publish exactly <em>n</em> articles as:</p>",
    "<p style='font-size:16px; text-align:center; font-weight:bold; color:#333; ",
    "background:#f8f9fa; padding:12px; border-radius:6px;'>",
    "f(n) = C / n<sup>\u03b2</sup>", "</p>",
    "<table style='width:100%; border-collapse:collapse; margin:20px 0;'>",
    "<tr style='background:#f0f4f8;'>",
    "<td style='padding:10px 15px; font-weight:bold; border-bottom:1px solid #ddd;'>Estimated \u03b2 (slope)</td>",
    "<td style='padding:10px 15px; border-bottom:1px solid #ddd;'>", round(s$Beta, 4), "</td></tr>",
    "<tr><td style='padding:10px 15px; font-weight:bold; border-bottom:1px solid #ddd;'>Theoretical \u03b2</td>",
    "<td style='padding:10px 15px; border-bottom:1px solid #ddd;'>2.0000</td></tr>",
    "<tr style='background:#f0f4f8;'>",
    "<td style='padding:10px 15px; font-weight:bold; border-bottom:1px solid #ddd;'>Constant (C)</td>",
    "<td style='padding:10px 15px; border-bottom:1px solid #ddd;'>", round(s$C, 4), "</td></tr>",
    "<tr><td style='padding:10px 15px; font-weight:bold; border-bottom:1px solid #ddd;'>R&sup2;</td>",
    "<td style='padding:10px 15px; border-bottom:1px solid #ddd;'>", round(s$R2, 4), "</td></tr>",
    "</table>",
    "<h4 style='color:#333; border-bottom:2px solid #2171B5; padding-bottom:8px; margin-top:30px;'>",
    "Kolmogorov-Smirnov Goodness-of-Fit Tests</h4>",
    "<h5 style='color:#555; margin-top:15px;'>Test 1: Empirical vs Theoretical (\u03b2 = 2)</h5>",
    "<table style='width:100%; border-collapse:collapse; margin:10px 0;'>",
    "<tr style='background:#f0f4f8;'>",
    "<td style='padding:10px 15px; font-weight:bold; border-bottom:1px solid #ddd;'>KS Statistic (D)</td>",
    "<td style='padding:10px 15px; border-bottom:1px solid #ddd;'>", round(s$ks.theo.stat, 4), "</td></tr>",
    "<tr><td style='padding:10px 15px; font-weight:bold; border-bottom:1px solid #ddd;'>p-value</td>",
    "<td style='padding:10px 15px; border-bottom:1px solid #ddd;'>", format.pval(s$ks.theo.pvalue, digits = 3), "</td></tr>",
    "</table>",
    "<p style='font-size:14px; margin:5px 0;'>", ks_theo_interp, "</p>",
    "<h5 style='color:#555; margin-top:20px;'>Test 2: Empirical vs Fitted (\u03b2 = ", round(s$Beta, 2), ")</h5>",
    "<table style='width:100%; border-collapse:collapse; margin:10px 0;'>",
    "<tr style='background:#f0f4f8;'>",
    "<td style='padding:10px 15px; font-weight:bold; border-bottom:1px solid #ddd;'>KS Statistic (D)</td>",
    "<td style='padding:10px 15px; border-bottom:1px solid #ddd;'>", round(s$ks.fit.stat, 4), "</td></tr>",
    "<tr><td style='padding:10px 15px; font-weight:bold; border-bottom:1px solid #ddd;'>p-value</td>",
    "<td style='padding:10px 15px; border-bottom:1px solid #ddd;'>", format.pval(s$ks.fit.pvalue, digits = 3), "</td></tr>",
    "</table>",
    "<p style='font-size:14px; margin:5px 0;'>", ks_fit_interp, "</p>",
    "<p style='font-size:12px; color:#888; margin-top:15px;'>H0: The empirical distribution follows the theoretical distribution. ",
    "A p-value &ge; 0.05 indicates no significant deviation.</p>",
    "<h4 style='color:#333; border-bottom:2px solid #2171B5; padding-bottom:8px; margin-top:30px;'>",
    "Plot Legend</h4>",
    "<table style='width:100%; border-collapse:collapse; margin:10px 0;'>",
    "<tr style='background:#f0f4f8;'>",
    "<td style='padding:8px 15px; border-bottom:1px solid #ddd;'><span style='color:#1a1a1a;font-weight:bold;'>&mdash;&mdash;</span> Solid black</td>",
    "<td style='padding:8px 15px; border-bottom:1px solid #ddd;'>Empirical distribution</td></tr>",
    "<tr>",
    "<td style='padding:8px 15px; border-bottom:1px solid #ddd;'><span style='color:#D6604D;font-weight:bold;'>- - -</span> Dashed red</td>",
    "<td style='padding:8px 15px; border-bottom:1px solid #ddd;'>Theoretical Lotka's Law (\u03b2 = 2)</td></tr>",
    "<tr style='background:#f0f4f8;'>",
    "<td style='padding:8px 15px; border-bottom:1px solid #ddd;'><span style='color:#2171B5;font-weight:bold;'>-&middot;-&middot;-</span> Dot-dash blue</td>",
    "<td style='padding:8px 15px; border-bottom:1px solid #ddd;'>Fitted model (\u03b2 = ", round(s$Beta, 2), ")</td></tr>",
    "</table>", "</div>")
  htmltools::tagList(htmltools::tags$style("body{background:#fff;margin:0;}"), shiny::HTML(summary_html))
}

# VERBATIM del handler (server.R:7635-7814): lotka(M) -> 3 outputs. Plot = plot.ly(L$g_shiny,
# flip=FALSE, side="r", aspectratio=1.4, size=0.10) (7638) -> plot_html (75vh, ui.R:4160). Tabla =
# L$AuthorProd (7667). Summary = output$lotkaSummary (HTML de L$stat). lotka() toma M (no
# biblioAnalysis); g_shiny = observed vs theoretical(beta=2) vs fitted.
register_runner("lotka_law", function(M, params) {
  suppressMessages(library(plotly))
  L   <- bibliometrix::lotka(M)
  plf <- tryCatch(get("plot.ly", envir = .BSHINY), error = function(e) NULL)
  ply <- if (is.function(plf) && !is.null(L$g_shiny))
    tryCatch(plf(L$g_shiny, flip = FALSE, side = "r", aspectratio = 1.4, size = 0.10),
             error = function(e) NULL) else NULL
  plot_asset <- if (!is.null(ply))
    list(id = "plot", type = "plot_html", filename = "plot.html", object = ply, snap_w = 1650, snap_h = 810)
  else .fig(L$g_shiny)
  sdoc <- tryCatch(.lotka_summary_doc(L), error = function(e) NULL)
  out  <- list(plot_asset, .tbl(L$AuthorProd))
  if (!is.null(sdoc))
    out <- c(out, list(list(id = "summary", type = "html_doc", filename = "summary.html",
                            object = sdoc, snap_w = 900, snap_h = 1400)))
  out
})

# 3.3.1.6 Authors' Local Impact ----------------------------------------------
# VERBATIM del handler HAuthors -> Hindex_plot(values, "author", input) (server.R:7441;
# utils.R:3011-3092). H = Hindex(M, field="author", elements=NULL, sep=";", years=Inf)$H
# %>% arrange(desc(h_index)). measure HmeasureAuthors h/g/m/tc (default "h", ui.R:4292) ->
# columna m: h=2, g=3, m=4, tc=5; m_index se REDONDEA a 2 (utils.R:3072). top-k=Hkauthor=10
# (ui.R:4301) por el measure; freqPlot(x=2, y=1, textLaby="Authors", textLabx="Impact
# Measure: <M>", title="Authors' Local Impact by <M> index"). Tabla = values$H (arrange
# desc h_index) renombrada Author (server.R:7475). Render plot.ly(aspectratio=1.3 inerte). Barra = extra.
register_runner("authors_local_impact", function(M, params) {
  H  <- bibliometrix::Hindex(M, field = "author", elements = NULL, sep = ";", years = Inf)$H
  H$Element <- as.character(H$Element)
  H  <- H[order(-H$h_index), , drop = FALSE]               # arrange(desc(h_index))
  ml <- switch(params$measure, h_index = "h", g_index = "g", m_index = "m",
               total_citation = "tc", stop(sprintf("unknown measure: %s", params$measure)))
  m  <- switch(ml, h = 2L, g = 3L, m = 4L, tc = 5L)        # columna del measure en Hindex$H
  xx <- H
  if (m == 4L) xx[, m] <- round(xx[, m], 2)                # m_index round 2 (utils.R:3072), ANTES del sort
  k  <- min(10L, nrow(xx))                                 # Hkauthor default 10
  xx <- xx[order(-xx[, m]), ]
  xx <- xx[1:k, c(1, m)]
  names(xx) <- c("Element", "value")
  lab <- paste("Impact Measure:", toupper(ml))                        # textLabx (utils.R:3086)
  ttl <- paste("Authors' Local Impact", "by", toupper(ml), "index")   # title (utils.R:3087)
  rd  <- if (m == 4L) 2L else 1L                           # etiqueta: m_index 2 decimales, resto 1 (enteros)
  tab_out <- H; names(tab_out)[names(tab_out) == "Element"] <- "Author"   # tabla = H rename Author (server.R:7475)
  c(.rank_figs(xx, "value", "Element", ttl, lab, M, n = nrow(xx), textLaby = "Authors", round_digits = rd),
    list(.tbl(tab_out)))
})
