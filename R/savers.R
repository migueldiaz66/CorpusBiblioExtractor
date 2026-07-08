# --- savers.R ---------------------------------------------------------------
# Persist each asset to disk according to its type. One entry point: save_asset().

save_table <- function(df, path) {
  # PARIDAD: NO redondear. biblioshiny MUESTRA las tablas a 2 decimales (renderBibliobox),
  # pero su botón Excel exporta el valor CRUDO/precisión-completa (`exportToExcel` usa el
  # campo `.s` de sort, no el `.d` de display; Htmlboxformat.R:245). El `.xlsx` del extractor
  # con precisión completa YA coincide con el Excel de biblioshiny. (El redondeo SÍ va en las
  # GRÁFICAS lollipop, vía .hbar/.lollipop, porque ahí biblioshiny sí redondea la etiqueta.)
  openxlsx::write.xlsx(as.data.frame(df), path, overwrite = TRUE)
}

save_ggplot <- function(p, path, width = NULL, height = NULL, dpi = 300, device = NULL) {
  # device="ragg" -> ragg::agg_png (usa systemfonts; necesario para dibujar la fuente
  # FontAwesome en las KPI cards de Main Information). Resto: ggsave default (sin cambio).
  dev <- if (identical(device, "ragg") && requireNamespace("ragg", quietly = TRUE)) ragg::agg_png else NULL
  ggplot2::ggsave(path, plot = p,
                  width  = if (is.null(width))  9 else width,
                  height = if (is.null(height)) 6 else height,
                  dpi = dpi, bg = "white", device = dev)
}

# Network: interactive HTML (visNetwork) + Pajek .net (igraph).
# selfcontained = FALSE avoids the pandoc dependency (bare Rscript has none);
# it writes the .html plus a sibling <name>_files/ folder of JS/CSS deps.
save_network_html <- function(vis, path) {
  # Fill the browser viewport instead of the fixed 960x500 htmlwidget default, so the
  # standalone HTML (and the lightbox iframe) uses the whole window.
  vis$width  <- "100%"
  vis$height <- "100vh"
  visNetwork::visSave(vis, path, selfcontained = FALSE, background = "white")
}

save_network <- function(vis, igraph_obj, path_html, path_net) {
  if (!is.null(vis))        save_network_html(vis, path_html)
  if (!is.null(igraph_obj)) igraph::write_graph(igraph_obj, path_net, format = "pajek")
}

# Generic htmlwidget (plotly Sankey, etc.) -> interactive HTML (no pandoc).
# NOTE: do NOT force height:100vh here. plotly is already responsive (fills its
# container), and a "100vh" CSS height BREAKS plotly Sankey node layout — the nodes
# collapse to the top and the colored bars stop lining up with the flows. Only
# visNetwork needs the 100vh fill (that lives in save_network_html). Snapshot size
# for plotly is controlled per-asset via snap_w/snap_h in the driver.
save_widget_html <- function(widget, path) {
  htmlwidgets::saveWidget(widget, path, selfcontained = FALSE)
}

# Static raster snapshot of an interactive widget HTML (visNetwork / plotly) via
# headless Chrome (webshot2 -> chromote). Renders the ALREADY-SAVED .html (its deps
# are correct and under Windows MAX_PATH) so every HTML-only view also gets a raw
# PNG. `delay` lets the widget's JS lay out before the shot. Returns TRUE on success;
# never throws fatally (missing webshot2 / no Chrome -> FALSE, the run goes on).
snapshot_widget_html <- function(html_path, png_path, delay = 2, vwidth = 1200, vheight = 900) {
  if (!requireNamespace("webshot2", quietly = TRUE)) return(FALSE)
  src <- html_path; tmp <- NULL
  # A bare .svg file cannot be screenshotted directly (Chrome exposes no <body>
  # node -> webshot errors). Wrap it inline in a minimal HTML page and shoot that.
  if (grepl("\\.svg$", html_path, ignore.case = TRUE)) {
    svg <- paste(readLines(html_path, warn = FALSE, encoding = "UTF-8"), collapse = "\n")
    tmp <- tempfile(fileext = ".html")
    writeLines(sprintf("<!doctype html><html><head><meta charset='utf-8'></head><body style='margin:0'>%s</body></html>", svg),
               tmp, useBytes = TRUE)
    src <- tmp
  }
  suppressMessages(webshot2::webshot(url = src, file = png_path,
                                     delay = delay, vwidth = vwidth, vheight = vheight))
  if (!is.null(tmp)) unlink(tmp)
  file.exists(png_path)
}

# HTML document (htmltools/shiny tag object) -> self-contained .html + deps in a
# libdir (bootstrap/fontawesome bundled). Used for biblioshiny UI fragments rendered
# outside the Shiny app (e.g. the Life Cycle summary cards). The driver then snapshots
# it to PNG like any other .html widget.
save_html_doc <- function(tags, path) {
  htmltools::save_html(tags, file = path, background = "white", libdir = "lib")
}

# Self-contained SVG string -> .svg file (object is the SVG markup as a character
# string). Used for the Author Profile cards: an <svg><foreignObject> wrapping the
# biblioshiny HTML card, with inlined icons + inline grid CSS, so the .svg opens in
# any browser with WORKING hyperlinks (ORCID / OpenAlex / topics). The driver
# snapshots it to a (link-less) PNG.
save_svg_doc <- function(svg, path) {
  writeLines(svg, path, useBytes = TRUE)
}

# grid gTree -> raw PNG via ragg (systemfonts-aware, needed to draw the Source Sans
# Pro / FontAwesome / glyphicon fonts). Used by the Main Information KPI cards.
save_grid_png <- function(grob, path, width = 12, height = 4.8, dpi = 150) {
  if (!requireNamespace("ragg", quietly = TRUE)) stop("ragg required for grid_png")
  ragg::agg_png(path, width = round(width * dpi), height = round(height * dpi),
                res = dpi, background = "white")
  on.exit(grDevices::dev.off())
  grid::grid.newpage(); grid::grid.draw(grob)
  invisible(path)
}

# HTML tags -> RAW PNG only (no .html kept). Renders a faithful copy of a biblioshiny
# HTML fragment (with its real CSS/deps) to a self-contained temp HTML, webshots it,
# then deletes the temp. Used by Main Information: the actual shinydashboard valueBox
# grid + AdminLTE CSS -> a raster image identical to biblioshiny (no HTML artifact).
save_card_png <- function(tags, path, vwidth = 1300, vheight = 540) {
  tmp  <- tempfile(fileext = ".html")
  ldir <- paste0(tmp, "_files")
  htmltools::save_html(tags, file = tmp, background = "white", libdir = ldir)
  ok <- tryCatch(snapshot_widget_html(tmp, path, vwidth = vwidth, vheight = vheight),
                 error = function(e) FALSE)
  unlink(tmp); unlink(ldir, recursive = TRUE)
  if (!isTRUE(ok)) stop("card_png webshot failed")
  invisible(path)
}

# Sankey plotly -> PNG usando la función REAL de biblioshiny `plotlySankey2png`
# (biblioshiny/utils.R:5852, vía .BSHINY): renderiza con **Plotly.toImage()** por chromote,
# que saca los colores SÓLIDOS. (El webshot genérico los deja pálidos — el propio comentario
# de biblioshiny lo dice: "Last resort: use biblioShot (links may be faint)".) plotlySankey2png
# hace `saveWidget(selfcontained=TRUE)` que necesita **pandoc**: se apunta RSTUDIO_PANDOC al
# pandoc que trae RStudio (Quarto) para que `rmarkdown` lo encuentre.
save_sankey_png <- function(sk, path, dpi = 300, height = 7) {
  pd <- "C:/Program Files/RStudio/resources/app/bin/quarto/bin/tools"
  if (dir.exists(pd)) {
    Sys.setenv(RSTUDIO_PANDOC = pd)
    try(rmarkdown::find_pandoc(cache = FALSE), silent = TRUE)
  }
  fn <- get("plotlySankey2png", envir = .BSHINY)
  fn(sk, path, dpi = dpi, height = height)
  invisible(path)
}

# visNetwork -> PNG estático. El HTML temporal (+ su _files muy anidado) se escribe en un
# TEMPDIR de ruta CORTA para evitar MAX_PATH (los combos del factorial son larguísimos);
# el webshot escribe el PNG en `path` (nombre corto). Usado por el Topic Dendrogram del
# factorial (dend2vis, la función real de biblioshiny).
save_vis_png <- function(vis, path, vwidth = 1400, vheight = 1000) {
  vis$width  <- "100%"; vis$height <- "100vh"
  td  <- tempfile("visdend"); dir.create(td)
  tmp <- file.path(td, "v.html")
  visNetwork::visSave(vis, tmp, selfcontained = FALSE, background = "white")
  ok  <- tryCatch(snapshot_widget_html(tmp, path, vwidth = vwidth, vheight = vheight),
                  error = function(e) FALSE)
  unlink(td, recursive = TRUE)
  if (!isTRUE(ok)) stop("vis_png webshot failed")
  invisible(path)
}

# Dispatch by asset type. `a` = list(id, type, filename, object[, object2]).
save_asset <- function(a, path) {
  switch(a$type,
    table_xlsx   = save_table(a$object, path),
    figure_png   = save_ggplot(a$object, path, width = a$width, height = a$height, device = a$device),
    plot_html    = save_widget_html(a$object, path),
    network_html = save_network_html(a$object, path),
    network_net  = igraph::write_graph(a$object, path, format = "pajek"),
    html_doc     = save_html_doc(a$object, path),
    svg_doc      = save_svg_doc(a$object, path),
    grid_png     = save_grid_png(a$object, path,
                                 width  = if (is.null(a$width))  12  else a$width,
                                 height = if (is.null(a$height)) 4.8 else a$height),
    card_png     = save_card_png(a$object, path,
                                 vwidth  = if (is.null(a$snap_w)) 1300 else a$snap_w,
                                 vheight = if (is.null(a$snap_h)) 540  else a$snap_h),
    sankey_png   = save_sankey_png(a$object, path,
                                   dpi    = if (is.null(a$dpi))    300 else a$dpi,
                                   height = if (is.null(a$height)) 7   else a$height),
    vis_png      = save_vis_png(a$object, path,
                                vwidth  = if (is.null(a$snap_w)) 1400 else a$snap_w,
                                vheight = if (is.null(a$snap_h)) 1000 else a$snap_h),
    stop(sprintf("Unknown asset type: %s", a$type))
  )
}
