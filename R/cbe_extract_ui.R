# ============================================================================
# UI-metadata extractor: parse biblioshiny's ui.R via the R AST and emit a
# structured description (menu + per-page options/tabs + help keys). Reproducible
# across versions because it reads the installed source, not hand notes.
# The AST helpers below are package-internal and exercised by the test suite.
# ============================================================================

`%||%` <- function(a, b) if (is.null(a) || length(a) == 0) b else a
fname  <- function(n) tryCatch(deparse(n[[1]])[1], error = function(e) "")
lit    <- function(x) if (is.null(x)) NA_character_ else tryCatch(paste(deparse(x), collapse = " "), error = function(e) NA_character_)

# positional-or-named argument of a call
arg <- function(cl, name, pos) {
  if (!is.null(name) && !is.null(cl[[name]])) return(cl[[name]])
  nm <- names(cl); if (is.null(nm)) nm <- rep("", length(cl))
  unnamed <- which(nm == "")[-1]
  if (!is.null(pos) && length(unnamed) >= pos) cl[[unnamed[pos]]] else NULL
}

# collect every call to `want` anywhere under a node / expression list
collect <- function(exprs, want) {
  out <- list()
  rec <- function(n) {
    if (is.call(n)) { if (identical(fname(n), want)) out[[length(out) + 1L]] <<- n
                      for (i in seq_along(n)) rec(n[[i]]) }
    else if (is.list(n) || is.pairlist(n)) for (i in seq_along(n)) rec(n[[i]])
  }
  if ((is.expression(exprs) || is.list(exprs)) && !is.call(exprs)) for (ex in exprs) rec(ex) else rec(exprs)
  out
}

# visible text of a label/title (strings from children; skip icon() and style/class/id)
text_of <- function(x) {
  if (is.character(x)) return(x)
  if (!is.call(x)) return(NA_character_)
  if (identical(fname(x), "icon")) return("")
  nm <- names(x); if (is.null(nm)) nm <- rep("", length(x))
  parts <- character(0)
  for (i in seq_along(x)[-1]) {
    if (nm[i] %in% c("style", "class", "id")) next
    t <- text_of(x[[i]]); if (length(t) && any(nzchar(t), na.rm = TRUE)) parts <- c(parts, t[nzchar(t)])
  }
  if (length(parts)) paste(parts, collapse = " ") else NA_character_
}

# eval a pure literal (c("a"="x",...) / "x" / 1); NULL if not a safe literal
eval_lit <- function(x) if (is.null(x)) NULL else tryCatch(eval(x, baseenv()), error = function(e) NULL)

.CONTROL_TYPE <- c(
  selectInput = "combo", pickerInput = "combo", selectizeInput = "combo",
  numericInput = "integer", sliderInput = "slider",
  materialSwitch = "toggle", prettySwitch = "toggle", switchInput = "toggle", checkboxInput = "toggle",
  radioButtons = "radio", checkboxGroupInput = "checkgroup",
  textInput = "text", fileInput = "file", colourInput = "color")
.OUTPUT_KIND <- c(
  visNetworkOutput = "network", plotlyOutput = "figure", plotOutput = "figure",
  uiOutput = "table_or_ui", DTOutput = "table", dataTableOutput = "table",
  htmlOutput = "html", leafletOutput = "map", verbatimTextOutput = "text")

# --- per-construct parsers (take parsed nodes; no global state) -------------
.parse_control <- function(node, group, conds) {
  fn <- fname(node)
  ch <- eval_lit(arg(node, "choices", 3))
  choices <- if (!is.null(ch)) {
    nm <- names(ch); if (is.null(nm)) nm <- rep("", length(ch))
    Map(function(label, value) list(label = label, value = as.character(value)), nm, ch)
  } else NULL
  list(
    type      = unname(.CONTROL_TYPE[fn]), fn = fn,
    inputId   = eval_lit(arg(node, "inputId", 1)) %||% lit(arg(node, "inputId", 1)),
    label     = text_of(arg(node, "label", 2)), choices = choices,
    default   = { d <- eval_lit(arg(node, "selected", 4)); if (is.null(d)) lit(arg(node, "selected", 4)) else as.character(d) },
    group     = group,
    condition = if (length(conds)) paste(conds, collapse = " && ") else NA_character_)
}

.walk_options <- function(node, group, conds, emit) {
  if (is.call(node)) {
    fn <- fname(node)
    if (fn == "box") group <- { t <- text_of(arg(node, "title", 1)); if (is.na(t)) group else t }
    if (fn == "conditionalPanel") conds <- c(conds, eval_lit(arg(node, "condition", 1)) %||% lit(arg(node, "condition", 1)))
    if (fn %in% names(.CONTROL_TYPE)) emit(.parse_control(node, group, conds))
    for (i in seq_along(node)) .walk_options(node[[i]], group, conds, emit)
  } else if (is.list(node) || is.pairlist(node)) for (i in seq_along(node)) .walk_options(node[[i]], group, conds, emit)
}

.page_options <- function(ti) {
  acc <- list()
  for (d in collect(list(ti), "dropdown"))
    .walk_options(d, NA_character_, character(0), function(ctl) acc[[length(acc) + 1L]] <<- ctl)
  btns <- list()
  for (bf in c("actionButton", "actionBttn")) for (b in collect(list(ti), bf))
    btns[[length(btns) + 1L]] <- list(role = "action", inputId = eval_lit(arg(b, "inputId", 1)) %||% lit(arg(b, "inputId", 1)), label = text_of(arg(b, "label", 2)))
  for (df in c("downloadButton", "downloadBttn")) for (b in collect(list(ti), df))
    btns[[length(btns) + 1L]] <- list(role = "download", inputId = eval_lit(arg(b, "outputId", 1)) %||% lit(arg(b, "outputId", 1)), label = text_of(arg(b, "label", 2)))
  list(controls = acc, buttons = btns)
}

.page_tabs <- function(ti) {
  out <- list()
  for (tp in collect(list(ti), "tabPanel")) {
    outputs <- list()
    for (of in names(.OUTPUT_KIND)) for (o in collect(list(tp), of))
      outputs[[length(outputs) + 1L]] <- list(kind = unname(.OUTPUT_KIND[of]), fn = of,
                                              outputId = eval_lit(arg(o, "outputId", 1)) %||% lit(arg(o, "outputId", 1)))
    out[[length(out) + 1L]] <- list(title = text_of(arg(tp, "title", 1)), outputs = outputs)
  }
  out
}

.parse_menu <- function(e) {
  sm <- collect(e, "sidebarMenu"); if (!length(sm)) return(list())
  walk <- function(node) {
    items <- list()
    for (i in seq_along(node)[-1]) {
      ch <- node[[i]]; if (!is.call(ch)) next
      fn <- fname(ch)
      if (fn %in% c("menuItem", "menuSubItem")) {
        items[[length(items) + 1L]] <- list(kind = fn, text = text_of(arg(ch, "text", 1)),
          tabName = eval_lit(arg(ch, "tabName", NULL)) %||% NA,
          children = if (fn == "menuItem") walk(ch) else list())
      } else if (fn %in% c("tags$div", "div", "tags$p", "p", "HTML")) {
        t <- text_of(ch); if (!is.na(t) && nzchar(t))
          items[[length(items) + 1L]] <- list(kind = "header", text = t, tabName = NA, children = list())
      }
    }
    items
  }
  walk(sm[[1]])
}

.menu_tabnames <- function(tree) {
  acc <- character(0)
  rec <- function(items) for (it in items) { if (!is.na(it$tabName)) acc[[length(acc) + 1L]] <<- it$tabName; rec(it$children) }
  rec(tree); acc
}

#' Extract the biblioshiny UI metadata from source (via the R AST)
#'
#' Parses `ui.R` of the installed (or given) biblioshiny and returns a structured
#' list: the sidebar `menu` tree, one entry per `tabItem` page with its `options`
#' (controls, nesting-aware: box `group` + `conditionalPanel` condition) and `tabs`
#' (output panels), plus the `helpContent()` keys.
#'
#' @param src biblioshiny source directory. Default:
#'   `system.file("biblioshiny", package = "bibliometrix")` (the installed package).
#' @param out Optional directory; if given, writes `ui_metadata.json` there.
#' @return (invisibly) the metadata list.
#' @export
cbe_extract_ui <- function(src = NULL, out = NULL) {
  if (is.null(src) || !nzchar(src)) src <- system.file("biblioshiny", package = "bibliometrix")
  if (!file.exists(file.path(src, "ui.R"))) stop("ui.R not found under: ", src)
  e <- parse(file.path(src, "ui.R"))

  menu <- .parse_menu(e)
  mtab <- .menu_tabnames(menu)

  pages <- list()
  for (ti in collect(e, "tabItem")) {
    tn  <- eval_lit(arg(ti, "tabName", 1)) %||% lit(arg(ti, "tabName", 1))
    opt <- .page_options(ti); tabs <- .page_tabs(ti)
    pages[[length(pages) + 1L]] <- list(
      tabName = tn, in_menu = tn %in% mtab,
      n_controls = length(opt$controls), n_tabs = length(tabs),
      options = opt$controls, buttons = opt$buttons, tabs = tabs)
  }

  hc_keys <- tryCatch({
    env <- new.env(); sys.source(file.path(src, "helpContent.R"), envir = env)
    if (exists("helpContent", env)) names(env$helpContent()) else character(0)
  }, error = function(e) character(0))

  result <- list(
    source  = list(dir = src, ui = "ui.R"),
    menu    = menu,
    help    = list(keys = hc_keys, n_keys = length(hc_keys)),
    pages   = pages,
    summary = list(n_tabItems = length(pages),
                   n_in_menu  = sum(vapply(pages, `[[`, logical(1), "in_menu")),
                   n_help_keys = length(hc_keys)))

  if (!is.null(out)) {
    dir.create(out, recursive = TRUE, showWarnings = FALSE)
    jsonlite::write_json(result, file.path(out, "ui_metadata.json"),
                         auto_unbox = TRUE, pretty = TRUE, null = "null", na = "null")
  }
  invisible(result)
}
