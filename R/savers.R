# --- savers.R ---------------------------------------------------------------
# Persist each asset to disk according to its type. One entry point: save_asset().

save_table <- function(df, path) {
  openxlsx::write.xlsx(as.data.frame(df), path, overwrite = TRUE)
}

save_ggplot <- function(p, path, width = 9, height = 6, dpi = 300) {
  ggplot2::ggsave(path, plot = p, width = width, height = height, dpi = dpi, bg = "white")
}

# Network: interactive HTML (visNetwork) + Pajek .net (igraph).
# selfcontained = FALSE avoids the pandoc dependency (bare Rscript has none);
# it writes the .html plus a sibling <name>_files/ folder of JS/CSS deps.
save_network_html <- function(vis, path) {
  visNetwork::visSave(vis, path, selfcontained = FALSE, background = "white")
}

save_network <- function(vis, igraph_obj, path_html, path_net) {
  if (!is.null(vis))        save_network_html(vis, path_html)
  if (!is.null(igraph_obj)) igraph::write_graph(igraph_obj, path_net, format = "pajek")
}

# Generic htmlwidget (plotly Sankey, etc.) -> interactive HTML (no pandoc).
save_widget_html <- function(widget, path) {
  htmlwidgets::saveWidget(widget, path, selfcontained = FALSE)
}

# Dispatch by asset type. `a` = list(id, type, filename, object[, object2]).
save_asset <- function(a, path) {
  switch(a$type,
    table_xlsx   = save_table(a$object, path),
    figure_png   = save_ggplot(a$object, path),
    plot_html    = save_widget_html(a$object, path),
    network_html = save_network_html(a$object, path),
    network_net  = igraph::write_graph(a$object, path, format = "pajek"),
    stop(sprintf("Unknown asset type: %s", a$type))
  )
}
